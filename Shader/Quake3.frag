uniform sampler2D qtex_0;
uniform sampler2D qtex_1;
uniform sampler2D qtex_2;
uniform sampler2D qtex_3;
uniform sampler2D qtex_4;
uniform sampler2D qtex_5;
uniform sampler2D qtex_6;

in vec4		world;
in vec4		rgba;
in vec2		st;
in vec2		uv;
in vec4		normal;


layout( location = 0 ) out vec4 FragColor;
void main()
{
	vec4 color = texture( qtex_0, uv );
	color *= qtex_1( qtex_1, st );	
	
	FragColor = color;
}