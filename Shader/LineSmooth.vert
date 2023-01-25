
void main()
{
	vec3 norm   	= (gObjectTransform * vec4( unpack_normal_octahedron( normalIn.xy ), 0.0 )).xyz;		
	vec4 world  	= gObjectTransform * vec4( vertIn, 1.0 );
	vec4 ndc		= viewBuffer.m_orthoMatrix2d * ( world );
	gl_Position 	= ndc;
	
	rgba 			= rgbaIn;
	uv 				= uvIn;
	st 				= stIn;	
	normal  		= norm;	
	worldCoord  	= world.xyz;		
}