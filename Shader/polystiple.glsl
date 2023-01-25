#ifndef _POLYSTIPLE_GLSL_
#define _POLYSTIPLE_GLSL_


void polyStiple()
{
	vec2 screen = gl_FragCoord.xy;			
    int yValue  = int(screen.y) & 0x01;		
    int xValue  = int(screen.x) & 0x01;		
    if( yValue == 0 ) discard;				
    if( xValue == 0 ) discard;	
}	

#endif 
