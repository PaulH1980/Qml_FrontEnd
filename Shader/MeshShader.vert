
layout( location = 0 ) in vec3		position;
layout( location = 1 ) in vec4		color_rgba_f32;
layout( location = 2 ) in vec4		normal_2_10_10_10;	//normal & tangent
layout( location = 3 ) in vec2		tex_coord0;
layout( location = 4 ) in vec2		tex_coord1;


const mat4 biasMatrix = mat4(   0.5, 0.0, 0.0, 0.0,
								0.0, 0.5, 0.0, 0.0,
								0.0, 0.0, 0.5, 0.0,
								0.5, 0.5, 0.5, 1.0);


uniform mat4    objTransform;

out vec4		rgba;
out vec2		uv;
out vec2		st;
out vec3		normal;
out vec3		worldCoord;
out vec2		velocityXY;
out vec3		viewDir;
out vec4 		shadowCoord;

uniform mat4 	depthWVP;
uniform mat4    depthBiasWVP;





#if defined(RENDER_ALBEDO_TO_CUBE)
uniform mat4    wvp;
void main()
{
	vec4 world  = objTransform * vec4( vertIn, 1.0 );
	gl_Position = wvp * ( world );
	viewDir 	= ( world.xyz - viewBuffer.m_cameraPos.xyz);    
	uv 			= uvIn;
}
#else
void main()
{
	vec3 norm   	= (objTransform * vec4( unpack_normal_octahedron( normal_2_10_10_10.xy ), 0.0 )).xyz;
	vec4 world  	= objTransform * vec4( position, 1.0 );
	vec4 ndc		= viewBuffer.m_wvpMatrix * ( world );
	vec4 ndcPrev	= viewBuffer.m_wvpMatrixPrevious * ( world );
	gl_Position 	= ndc;
	shadowCoord 	= (biasMatrix * depthWVP * ( world ));
	
	rgba 			= color_rgba_f32;
	uv 				= tex_coord0;
	st 				= tex_coord1;
	normal  		= norm;
	worldCoord  	= world.xyz;	
	velocityXY 		= (ndc.xy - ndcPrev.xy) * viewBuffer.m_frameBufferDims;  
	viewDir 		= ( world.xyz - viewBuffer.m_cameraPos.xyz);	
}
#endif


