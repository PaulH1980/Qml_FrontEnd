layout( location = 0 ) out vec4 FragColor;

uniform vec4		gBrushColor ;
uniform sampler2D 	gBrushPattern;		//mask image
uniform sampler2D 	gBrushTexture;		//regular image



vec4 getTextureColor()
{
	vec4 texColor  = vec4( texture( gBrushTexture, uv ).xyz , 1.0 );	
	return texColor;
}


void main()
{
	float mask   = texture( gBrushPattern, st).r;	
	if( mask < 0.05 )
		discard;	
	
	vec4 texColor = getTextureColor()  ;	
	
	FragColor = texColor * rgba * gBrushColor;
	
}