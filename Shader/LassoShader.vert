layout( location = 0 ) in vec3		vertIn;

uniform  vec4 rgbaIn;
out vec4 rgba;														
																				
void main()																	
{																				
	gl_Position = viewBuffer.m_orthoMatrix2d * ( vec4( vertIn, 1.0 ) );
	rgba		= rgbaIn;													
}																				