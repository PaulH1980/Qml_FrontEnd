layout( location = 0 ) in vec3		vertIn;


uniform mat4 	objTransform;
out vec3		worldCoord;
out vec3		viewDir;

void main()
{
	vec4 world  = objTransform * vec4( vertIn, 1.0 );
	gl_Position = viewBuffer.m_wvpMatrix * ( world );
	worldCoord  = world.xyz;	
	viewDir 	= ( world.xyz - viewBuffer.m_cameraPos.xyz);	
}