in vec2 uvCoord;	
in vec4 rgba;															
uniform sampler2D albedoTex;	
												
layout( location = 0 ) out vec4 FragColor;										
void main()																	
{																				
	vec4 col  = texture( albedoTex, uvCoord );	
	if( col.a < 0.5 )
		discard;
	//float alpha = mix(1.0 - max(col.x, col.w), col.y, fontBrightness);			
	FragColor = col * rgba;//vec4( uvCoord, 0, 1 );					
}																				