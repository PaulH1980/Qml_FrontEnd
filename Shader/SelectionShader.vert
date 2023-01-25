layout( location = 0 ) in vec3		vertIn;
//layout( location = 1 ) in vec4		rgbaIn;
//layout( location = 2 ) in vec2		uvIn;
												
out vec2		uvCoord;		
//out vec4		rgba;												
//uniform mat4	wvp;															
																				
void main()																	
{																				
	gl_Position = viewBuffer.m_orthoMatrix2d * ( vec4( vertIn, 1.0 ) );
	//rgba	= rgbaIn;
	//uvCoord = uvIn;														
}																				