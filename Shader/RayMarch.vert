#version 400									
in vec3		vertIn;								
uniform mat4	wvp;								

void main()
{
	gl_Position = wvp * vec4(vertIn, 1.0);
	}
