#ifndef _VERTEX_GLOBAL_GLSL_
#define _VERTEX_GLOBAL_GLSL_

layout( std430, binding = 1 )  buffer GlobalBuffer
{
	mat4 			m_wvpMatrix;			
	mat4 			m_wvpMatrixInverse;		
	mat4			m_wvpMatrixPrevious;	
	mat4			m_projMatrix;			
	mat4			m_viewMatrix;			
	mat4			m_normalMatrix;	
	mat4			m_orthoMatrix2d;
	mat4			m_skyMatrix;
	
	vec4			m_cameraPos;
	vec4			m_ambient;
	vec4			m_sunPos;
	vec4			m_clipPlanes[6];	
	
	vec2 			m_frameBufferDims;			//glViewport.zw
	vec2 			m_invFrameBufferDims;	
	vec2			m_frameBufferStart;			//glViewport.xy
	vec2			m_nearFar;				
	
	float			m_rootSize;				
	float 			m_pixScale;				
	float 			m_frameTime;			
	float 			m_programTime;		
	
	int 			m_numClipPlanes;
	int 			m_pad[3];	
	
} viewBuffer;
const float PI = 3.14159265359;


float cross2(vec2 a, vec2 b ){
   return a.x * b.y - a.y * b.x;
}

float distanceToLine( in vec2 start, in vec2 end, in vec2 point )
{
	vec2 c1 = end - start;
	vec2 c2 = point - start;
	float area = cross2(c2, c1);
	return area / length( c1 );
}


vec2 projectOnLine( in vec2 start, in vec2 end, in vec2 point )
{
	vec2 ap = point - start;
    vec2 ab = end - start;	
	float t = dot( ap, ab ) / dot( ab, ab );
	if( t < 0.0 )
		return start;
	if( t > 1.0 )
		return end;	
    vec2 result = start + t * ab;
    return result;
}

float lerpFactor( in vec2 start, in vec2 end, in vec2 point )
{
	float lineLength  = distance( end , start );
	return distance( point, start ) / lineLength; 	
}


vec2 ndcToScreen(in vec4 ndcVertex)
{
	vec2 screenVert = ( ( ndcVertex.xy / ndcVertex.w ) + 1.0 ) * 0.5;	
	return screenVert * viewBuffer.m_frameBufferDims;
}

vec4 screenToNdc( in vec2 screenVertex )
{
	vec2 normalizedScreen = ((screenVertex * viewBuffer.m_invFrameBufferDims ) * 2.0) - 1.0 ;
	return vec4( normalizedScreen, 0.0, 1.0 ); 
}



#endif