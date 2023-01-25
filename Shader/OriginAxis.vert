layout( location = 0 ) in vec3		vertIn;
layout( location = 1 ) in vec4		rgbaIn;
		
out vec4		rgba;												
uniform mat4	wvp;
uniform float   scale;															
																				
void main()																	
{																				
	gl_Position = wvp * ( vec4( vertIn * scale, 1.0 ) );
	rgba	= rgbaIn;						
}																				