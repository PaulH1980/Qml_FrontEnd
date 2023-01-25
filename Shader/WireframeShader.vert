layout( location = 0 ) in vec3		vertIn;
		
out vec4		rgba;	
uniform mat4    objTransform;	
uniform vec4    lineColor;							

																				
void main()																	
{																				
	vec4 world  = objTransform * vec4( vertIn, 1.0 );
	gl_Position = viewBuffer.m_wvpMatrix * ( world );
	rgba		= lineColor;						
}																				