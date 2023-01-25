layout(origin_upper_left) 	in  vec4 gl_FragCoord;	
layout( location = 0 ) 		out vec4 FragColor;		

uniform vec4 	mouseBounds;  //defined as vec2 min, vec2 max

uniform float   lineWidth  = 2.0;			
uniform vec4 	rgba	   = vec4( 1.0, 1.0, 1.0, 1.0);					



vec2 closestDistance( vec2 input )
{
	vec2 minVal = mouseBounds.xy;
	vec2 maxVal = mouseBounds.zw;
	
	vec2 minXY  = min( abs( input - minVal), abs( input - maxVal ) );
	
	return minXY;
}
								
void main()																	
{		
	vec2 dist = closestDistance( gl_FragCoord.xy );
	
	if( dist.x > lineWidth && dist.y > lineWidth )
		discard;
	
	FragColor = rgba;				
}																				