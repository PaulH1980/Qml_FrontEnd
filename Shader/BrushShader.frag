layout( location = 0 ) out vec4 FragColor;

uniform vec4		gBrushColor;
uniform sampler2D 	gBrushPattern;		//mask image



void main()
{
	float mask   = texture( gBrushPattern, st).r;	
	if( mask < 0.05 )
		discard;	
	FragColor = gBrushColor * rgba;
}