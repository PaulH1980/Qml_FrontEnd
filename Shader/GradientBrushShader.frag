layout( location = 0 ) out vec4 FragColor;

uniform vec2  		gGradientStart;
uniform vec2  		gGradientEnd;
uniform uint        gGradientStyle;		//0 linear gradient, 1 radial gradient
uniform vec4		gBrushColor;
uniform sampler1D 	gGradientTexture;
uniform sampler2D 	gBrushPattern;		//mask image

uniform vec2		gBoundsMin;
uniform vec2		gBoundsSize;


const uint GRADIENT_LINEAR    = 0;
const uint GRADIENT_RADIAL    = 1;

vec4 getGradientColor( vec2 lineStart, vec2 lineEnd, vec2 xyPos  )
{
	float uCoord = 0.0;
	if( GRADIENT_LINEAR == gGradientStyle   )
	{
		vec2 projPoint = projectOnLine( lineStart, lineEnd, xyPos );
		uCoord = lerpFactor( lineStart, lineEnd, projPoint );
	}
	else if ( GRADIENT_RADIAL == gGradientStyle  )
	{
		uCoord = lerpFactor( lineStart, lineEnd, xyPos );
	}
	return texture( gGradientTexture, uCoord );	
}

vec4 getTextureColor()
{
	vec4 texColor  = vec4( 1.0 );		
	vec2 start = gBoundsMin + (gGradientStart * gBoundsSize);
	vec2 end   = gBoundsMin + (gGradientEnd * gBoundsSize);			
	texColor = getGradientColor( start, end, gl_FragCoord.xy );
	return texColor;
}


void main()
{
	float mask   = texture( gBrushPattern, st).r;	
	if( mask < 0.05 )
		discard;	
	
	vec4 texColor = getTextureColor();	
	
	FragColor = rgba * gBrushColor * texColor;
}