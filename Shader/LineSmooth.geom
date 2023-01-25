layout ( lines_adjacency ) in;
layout ( triangle_strip, max_vertices = 12 ) out;

uniform float gLineWidthHalf    = 2.0;	//line thickness
uniform float gMiterLimit		= 0.75; //apply alpha fade after this amount of pixels

in vec4		rgba[];
in vec2		uv[];
in vec2		st[];
in vec3		normal[];
in vec4     misc[]; 			
in vec3		viewDir[];
in vec3		worldCoord[];
in vec4     shadowCoord[];
in vec2		velocityXY[];

out GeometryPass
{
	vec2 			uvGeom;
	vec4 			rgbaGeom;
	flat vec2 		lineStartGeom;
	flat vec2 		lineEndGeom;
} vertexOut;


/*
	Work is done in viewspace, then converted to clip-space  before 
	forwarding it to fragment shader.
*/	

//Algorithm looks similar to the one found here:
//https://forum.libcinder.org/topic/smooth-thick-lines-using-geometry-shader
void main()
{
	
	vec2 p0 = ndcToScreen( gl_in[0].gl_Position );
	vec2 p1 = ndcToScreen( gl_in[1].gl_Position );
	vec2 p2 = ndcToScreen( gl_in[2].gl_Position );
	vec2 p3 = ndcToScreen( gl_in[3].gl_Position );
	
	//calulate line normals
	vec2 prevDir    = normalize(p1-p0);     //orthogonal with linedir
    vec2 lineDir    = normalize(p2-p1);		//regular line direction
	vec2 nextDir    = normalize(p3-p2);	    //(invert)orthogonal 
	
	vec2 prevNormal = vec2( prevDir.y, -prevDir.x );
	vec2 lineNormal = vec2( lineDir.y, -lineDir.x );
	vec2 nextNormal = vec2( nextDir.y, -nextDir.x );
	
	vec2 miter1 = normalize(lineNormal + prevNormal);	
	vec2 miter2 = normalize(lineNormal + nextNormal);
	
	float offset1 =  gLineWidthHalf / dot( miter1, lineNormal );
	float offset2 =  gLineWidthHalf / dot( miter2, lineNormal );
	
	if( dot(lineDir, prevDir) < -gMiterLimit ) 
	{
		miter1 = lineNormal;
		offset1 = gLineWidthHalf;
	}	
	
	if( dot(lineDir, nextDir) < -gMiterLimit ) 
	{
		miter2 = lineNormal;
		offset2 = gLineWidthHalf;
	}
	
	
	vec2 offsetDir1 =  offset1 * miter1;
	vec2 offsetDir2 =  offset2 * miter2;
	
	
	//need this to send in the fragment shader for calculating point-lineDistances
	vertexOut.lineStartGeom = p1;
	vertexOut.lineEndGeom   = p2;
	
	vec2 output0 = p1 + (offsetDir1 * -1.0);	//a
	vertexOut.uvGeom   = vec2( 1.0, 0.0 );
	vertexOut.rgbaGeom = rgba[0];
	gl_Position = screenToNdc( output0 ); 
	EmitVertex();
	
	vec2 output1 = p1 + (offsetDir1 * 1.0);	//b	
	vertexOut.uvGeom = vec2( 1.0, 1.0 );
	vertexOut.rgbaGeom = rgba[0];
	gl_Position = screenToNdc( output1 );
	EmitVertex();	
	
	vec2 output2 = p2 + (offsetDir2 * -1.0);	//a
	vertexOut.uvGeom = vec2( 0.0, 0.0 );
	vertexOut.rgbaGeom = rgba[1];
	gl_Position = screenToNdc( output2 );
	EmitVertex();
	
	vec2 output3 = p2 + (offsetDir2 * 1.0);  
	vertexOut.uvGeom 	  = vec2( 0.0, 1.0 );
	vertexOut.rgbaGeom 	  = rgba[1];
	gl_Position = screenToNdc( output3 );
	EmitVertex();		
	
	EndPrimitive();	

}