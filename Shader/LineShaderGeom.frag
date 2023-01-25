layout( location = 0 ) 	out vec4 FragColor;

uniform float gFeatherDist 		= 1.0;
uniform float gLineWidthHalf    = 2.0;	//line thickness
#ifdef USE_DASH_TEXTURE
uniform sampler1D	gDashTexture;
#endif
in GeometryPass
{
	vec2 			uvGeom;
	vec4 			rgbaGeom;
	flat vec2 		lineStartGeom;
	flat vec2 		lineEndGeom;
} vertexIn;

void main()																	
{		
#ifdef USE_DASH_TEXTURE
	float mask = texture( gDashTexture, 0.5).r;
	if( mask < 0.05 )
		discard;
#endif
	
	float alpha = 1.0;
	//apply (linear )alpha fade towards edge of line
	if( gFeatherDist > 0.0 )
	{
		vec2 start = vertexIn.lineStartGeom;
		vec2 end   = vertexIn.lineEndGeom; 
		vec2 frag  = gl_FragCoord.xy;				
				
		float featherStart = gLineWidthHalf - gFeatherDist;
		float dist = abs( distanceToLine( start, end, frag ) );
		float featherVal = dist - featherStart;
		float normalizedFeather = 1.0 - (featherVal / gFeatherDist);
		//fade out towards extruded edge of line
		alpha = clamp( normalizedFeather, 0.0, 1.0 );		
	}	
	FragColor = vec4( vertexIn.rgbaGeom.xyz , alpha );	
}				