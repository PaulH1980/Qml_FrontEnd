layout( location = 0 ) in vec3		vertIn;
layout( location = 1 ) in vec4		rgbaIn;

uniform mat4 wvp;
uniform mat4 objTransform;

out vec4		rgba;
void main()
{
	gl_Position = viewBuffer.m_wvpMatrix * ( objTransform * vec4( vertIn, 1.0 ) );
	rgba = rgbaIn;
}