
layout( location = 0 ) in vec3		vertIn;


uniform mat4    wvp;
//out vec3		viewDir;
out vec3		worldPos;

void main()
{
	worldPos	= vertIn;	 
	gl_Position = wvp * vec4( vertIn, 1.0 );	
}