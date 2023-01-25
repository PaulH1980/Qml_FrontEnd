layout( location = 0 ) in vec3		vertIn;

uniform mat4 	objTransform;
uniform mat4 	depthWVP;


void main()
{
	gl_Position = depthWVP * ( objTransform * vec4( vertIn, 1.0 ) );
	vec4 world  = objTransform * vec4( vertIn, 1.0 );	
}