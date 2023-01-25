#version 420
#extension GL_EXT_gpu_shader4 : enable
								
struct FrustumPlane
{
	vec4				m_topLeft;		//top left of frustum part
	vec4				m_rightDir;
	vec4				m_downDir;
	float				m_pixXSize;		//pixel size in meters
	float				m_pixYSize;		
};								
								
								



uniform isampler2D		indirectionTex;	//indirection textture
uniform isampler2D		normalTex;
uniform sampler2D		rgbaTex;

layout (std140, binding = 0) uniform shader_data
{
	FrustumPlane 		nearPlaneInfo;
	FrustumPlane 		farPlaneInfo;												
	vec3				boundsMin;		//world bounding box min value
	vec3				boundsMax;		//world bounding box max value
	float				rootSize;		//size of the root node												
	float 				pixScale;		//size of a pixel at the near plane
	//float 				m_pad0;
	//float				m_pad1;	
};


const int 				MAX_LEVELS   = 21;
const int  				OCTREE_X_VAL = 1;
const int 				OCTREE_Y_VAL = 2;
const int 				OCTREE_Z_VAL = 0;
const int 				TEXTURE_SIZE = 4096;
const uint				INVALID_NODE = 0xFFFFFFFF;


//output values
layout(location = 0) out vec4 	diffuse_spec_out;
layout(location = 1) out uint 	normal_out;
layout(location = 2) out float 	depth_out;


//number of bits
const uint bitCount[256] = uint[256]
(
	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
	4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8
);

//octree scale ratio's
const float ratios[MAX_LEVELS] = float[MAX_LEVELS]
(
	 1.0 / float(1 << 0),  1.0 / float(1 << 1),  1.0 / float(1 << 2),  1.0 / float(1 << 3),
	 1.0 / float(1 << 4),  1.0 / float(1 << 5),  1.0 / float(1 << 6),  1.0 / float(1 << 7),
	 1.0 / float(1 << 8),  1.0 / float(1 << 9),  1.0 / float(1 << 10), 1.0 / float(1 << 11),
	 1.0 / float(1 << 12), 1.0 / float(1 << 13), 1.0 / float(1 << 14), 1.0 / float(1 << 15),
	 1.0 / float(1 << 16), 1.0 / float(1 << 17), 1.0 / float(1 << 18), 1.0 / float(1 << 19),
	 1.0 / float(1 << 20)
);

const int nodeIndices[3 * 8] = int[3*8]
(
	//x-exit	y-exit		z-exit
	2,			4,			1,		//node index 0
	3,			5,			8,		//node index 1
	8,			6,			3,		//node index 2
	8,			7,			8,		//node index 3
	6,			8,			5,		//node index 4
	7,			8,			8,		//node index 5
	8,			8,			7,		//node index 6
	8,			8,			8		//node index 7
);





struct OctRay
{
	vec3	    m_rayDir;
	vec3		m_invRayDir;
	vec3		m_orig;
	float 		m_hitDistance;
	uint		m_rayXor;
	uint		m_numIter;
	uint		m_nodeIndex;
};

struct OctNode
{
	vec3		m_tValues[3];
	uint		m_nextNode;		//points to nextNode in indirection texture
	uint		m_curNode;		//least 8 significant bits are child bits
};

float    minVec3( in vec3 val )
{
	return min( val.x, min( val.y, val.z )  );
}

float    maxVec3( in vec3 val )
{
	return max( val.x, max( val.y, val.z )  );
}


uint popCount8( in uint val )
{
	return bitCount[val];
}


uint BitCountBefore( in uint bitIdx, in uint val )
{
	uint bit = 1 << bitIdx;
	bit += bit - 1; //fill lower bits with '1's
	val &= bit; 	//cap of most significant bits
	return popCount8( val );
}




OctNode createNode( in vec3 t0, in vec3 t1, in uint offset )
{
	OctNode theNode;
	theNode.m_tValues[0] = t0;
	theNode.m_tValues[1] = (t0 + t1 ) * 0.5;
	theNode.m_tValues[2] = t1;
	theNode.m_nextNode   = offset;
	theNode.m_curNode    = -1;
	return theNode;
}

/*
	Determine the first node entrye
*/
uint 	firstNode( in vec3 tMid, in vec3 t0 )
{
	int result = 0;
	if (t0[OCTREE_X_VAL] > t0[OCTREE_Y_VAL] && 
		t0[OCTREE_X_VAL] > t0[OCTREE_Z_VAL]) //YZ plane
	{
		if (tMid[OCTREE_Y_VAL] < t0[OCTREE_X_VAL]) result |= 4;
		if (tMid[OCTREE_Z_VAL] < t0[OCTREE_X_VAL]) result |= 1;
			return result;
	}
	if (t0[OCTREE_Y_VAL] > t0[OCTREE_X_VAL] &&
		t0[OCTREE_Y_VAL] > t0[OCTREE_Z_VAL]) //XZ plane
	{
		if (tMid[OCTREE_X_VAL] < t0[OCTREE_Y_VAL]) result |= 2;
		if (tMid[OCTREE_Z_VAL] < t0[OCTREE_Y_VAL]) result |= 1;
		return result;
	}
	//XY plane
	if (tMid[OCTREE_X_VAL] < t0[OCTREE_Z_VAL]) result |= 2;
	if (tMid[OCTREE_Y_VAL] < t0[OCTREE_Z_VAL]) result |= 4;
		
	return result;
}

/*
	Determine new T-Values
*/
uint  getTValues( in OctNode theNode, out vec3 t0Out, out vec3 t1Out )
{

	int startX = 0,			//initialize to t0 values
		startY = 0,
		startZ = 0;
	if((theNode.m_curNode & 1) != 0 ) //startz
		startZ++;
	if(((theNode.m_curNode >> 2 ) & 1 ) != 0 )
		startY++;
	if(((theNode.m_curNode >> 1 ) & 1 ) != 0 )
		startX++;
		
	t0Out[OCTREE_X_VAL] = theNode.m_tValues[startX][OCTREE_X_VAL];
	t0Out[OCTREE_Y_VAL] = theNode.m_tValues[startY][OCTREE_Y_VAL];
	t0Out[OCTREE_Z_VAL] = theNode.m_tValues[startZ][OCTREE_Z_VAL];

	t1Out[OCTREE_X_VAL] = theNode.m_tValues[startX + 1][OCTREE_X_VAL];
	t1Out[OCTREE_Y_VAL] = theNode.m_tValues[startY + 1][OCTREE_Y_VAL];
	t1Out[OCTREE_Z_VAL] = theNode.m_tValues[startZ + 1][OCTREE_Z_VAL];

	uint nodeIndex = theNode.m_curNode;
	if (t1Out[OCTREE_X_VAL] < t1Out[OCTREE_Y_VAL] &&
		t1Out[OCTREE_X_VAL] < t1Out[OCTREE_Z_VAL]) return nodeIndices[nodeIndex* 3 + 0]; //YZ plane
	if (t1Out[OCTREE_Y_VAL] < t1Out[OCTREE_X_VAL] && 
		t1Out[OCTREE_Y_VAL] < t1Out[OCTREE_Z_VAL]) return nodeIndices[nodeIndex* 3 + 1]; //XZ plane
	
	return nodeIndices[nodeIndex * 3 + 2]; // XY plane;
}

/*
	Returns a point on the near plane or on the far plane
*/
vec3   getPoint( in float x, in float y, in FrustumPlane p )
{
	vec4 res   = p.m_topLeft;							//top left corner of front or back plane
	vec4 right = p.m_rightDir * ( x * p.m_pixXSize);	//right vector offset
	vec4 down  = p.m_downDir *  ( y * p.m_pixYSize );	//down vector offset
	res += right;
	res += down;
	return res.xyz;
}



/*
	Generates a ray, based on viewport coordinates
*/
OctRay getRay( in float x, in float y )
{
	OctRay theRay;
	theRay.m_rayXor 	  = 0;
	theRay.m_nodeIndex 	= -1;
	theRay.m_numIter    = 0;
	theRay.m_orig 		= getPoint( x, y, nearPlaneInfo );	
	vec3 farPoint 		= getPoint( x, y, farPlaneInfo );
	
	theRay.m_rayDir = normalize( farPoint - theRay.m_orig );
	theRay.m_invRayDir = 1.0 /	theRay.m_rayDir;
	if( theRay.m_rayDir[0] < 0.0 )
		theRay.m_rayXor |= 1;
	if( theRay.m_rayDir[1] < 0.0 )
		theRay.m_rayXor |= 2;
	if( theRay.m_rayDir[2] < 0.0 )
		theRay.m_rayXor |= 4;
	return theRay;	
}

bool getNode( inout OctRay ray )
{
	vec3 tMin, tMax, ta, tb;
	float mint, maxt;
		
	ta = (boundsMin - ray.m_orig) * ray.m_invRayDir;
	tb = (boundsMax - ray.m_orig) * ray.m_invRayDir;

	tMin = min(ta, tb); //find min values
	tMax = max(ta, tb);	//find max values

	mint = maxVec3( tMin );  //find min entry
	maxt = minVec3( tMax ); //find max entry
			
	OctNode stack[MAX_LEVELS];
	if ( (maxt > 0.0f) && (maxt > mint)) //hit
	{
		int curStackIdx = 0;
		stack[curStackIdx++] = createNode( tMin, tMax, 0 );
			
		while (curStackIdx != 0 ) //do a depth first search
		{
			ray.m_numIter++; //increment number of iterations for this pixel
			int stackAdr = curStackIdx - 1;
			if( stack[stackAdr].m_curNode ==  -1 )//first time we see this node
			{
				maxt = minVec3( stack[stackAdr].m_tValues[2] );
				if (maxt < 0.0) //this voxel is behind camera continue
				{
					curStackIdx--;
					continue;
				}	
				
				float nodeSize = rootSize * ratios[stackAdr];
				float pixSize = nodeSize / maxt; 
				if (pixSize < pixScale) //voxel becomes too small
				{
				//	ray.m_nodeIndex = 0x01;
					ray.m_nodeIndex = stack[stackAdr].m_nextNode;
					return true;
				}
				//determine first node entry
				stack[stackAdr].m_curNode = firstNode( stack[stackAdr].m_tValues[1], 
											   		   stack[stackAdr].m_tValues[0] );				
			}
			//ray exit's the node
			if (stack[stackAdr].m_curNode == 8)
			{
				curStackIdx--;
				continue;
			}
			uint xCoord = TEXTURE_SIZE % stack[stackAdr].m_nextNode;
			uint yCoord = TEXTURE_SIZE / stack[stackAdr].m_nextNode;  
			
			//r = x coord, g = y coord, b = child bit flags
			ivec4 childNode = texelFetch2D(indirectionTex, ivec2( xCoord,yCoord ), 0 );
			if( childNode[0] < 0 ) //no data yet
			{
			//		ray.m_nodeIndex = 0x01;
				ray.m_nodeIndex = stack[stackAdr].m_nextNode;
				return true;
			}
			
			if( childNode[2] == 0 ) //leaf node reached
			{
				ray.m_nodeIndex = stack[stackAdr].m_nextNode;
				return true;
			} 
				
			vec3 t0, t1;
			//new child index accounted for negative direction
			uint childIdx = stack[stackAdr].m_curNode ^ ray.m_rayXor;
			stack[stackAdr].m_curNode = getTValues( stack[stackAdr], t0, t1 );
			if(  ( (childNode[2] >> childIdx ) & 1 ) != 0 )
			{
				uint texOffset = yCoord * TEXTURE_SIZE + xCoord;	//offset in texture coords( integer )
				uint childOffset = BitCountBefore(childIdx, childNode[2] ) - 1;
				stack[curStackIdx++] = createNode(t0, t1, texOffset + childOffset);
			}
		}//end while			
	}//if 'hit'	
//	ray.m_nodeIndex = 0x01;			   
return false;
}
				
				

void main()									
{												
	vec2 screen = gl_FragCoord.xy;	
	OctRay theRay = getRay( screen.x, screen.y );
//	getNode( theRay );			
	//int yValue  = int(screen.y) & int(0x01);;			
//	int xValue  = int(screen.x) & 0x01;			
//	if( yValue == 0 && xValue == 0 ) discard;					
	//if( xValue == 0 ) discard;				
	diffuse_spec_out = vec4(1.0, 1.0, 0.0, 1.0);	
	normal_out = texelFetch2D( normalTex, ivec2(screen.x, screen.y), 0 ).r;	
	depth_out  = theRay.m_hitDistance;			
}												


