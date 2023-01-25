#ifndef _TEXTURES_GLSL_
#define _TEXTURES_GLSL_

/*
uniform sampler2D 		albedoTex;
uniform sampler2D 		normalTex;
uniform sampler2D 		roughnessTex;
uniform sampler2D 		metalTex;
uniform sampler2D 		miscTex;
uniform sampler2DShadow shadowMap;
uniform samplerCube 	environment;
*/

uniform sampler2D 		tex_0;			//albedo
uniform sampler2D 		tex_1;			//normal
uniform sampler2D 		tex_2;			//roughness
uniform sampler2D 		tex_3;			//metal
uniform sampler2D 		tex_4;			//mask
uniform sampler2D 		tex_5;		    //misc
uniform sampler2D 		tex_6;          //misc
uniform sampler2D 		tex_7;          //misc

uniform sampler2DShadow shadowMap;
uniform samplerCube 	environment;

in vec4		rgba;
in vec2		uv;
in vec2		st;
in vec3		normal;
in vec4     misc; 			
in vec3		viewDir;
in vec3		worldCoord;
in vec4     shadowCoord;
in vec2		velocityXY;


struct ShadowMapInfo
{
	mat4		m_lightbiasWVP;
	vec4		m_uvInformation;
	vec4		m_min;
	vec4		m_max;
};


//64 bytes
struct LightInfo 
{
  vec4 			m_position;		//16 + radius
  vec4 			m_color;   		//32 + intensity
  vec4			m_direction;	//48 + type	  
  
  float 		m_spotAngle;	//52
  float 		m_spotCutOff;	//56
  float			m_pad0;			//60
  float 		m_pad1;			//64  
};


layout( std430, binding = 2 )  buffer LightBuffer
{
	LightInfo 		m_numLights[16384];	
	int 			m_totalLights;	
	int 			m_pad;	
	int 			m_pointLightStart;
	int 			m_pointLightEnd;  
	int 			m_spotStart;
	int 			m_spotEnd; 
	int 			m_dirStart;
	int 			m_dirEnd;	
} lightBuf;


layout( std430, binding = 3 )  buffer ShadowMapInfoBuffer
{
	ShadowMapInfo		m_numInfo[128];	
} shadowMapInfoBuf;


layout( std430, binding = 4 )  buffer SkyBoxRender
{
	vec3			m_rayOrigin;
	float			m_intensity;	
	
	vec3			m_sunPos;
	float			m_radiusPlanet;
	
	vec3			m_raylghScatCoeff;	
	float			m_radiusAtmos;	
	
	float			m_mieScatCoeff;	
	float			m_rayLeighScaleHeight;
	float			m_mieScaleHeight;
	float			m_mieScatDir;

} skyBoxBuf;


layout( std430, binding = 5 ) buffer MaterialParam
{
    vec4    m_albedo;
    vec4    m_emissive;
    float   m_opacity;
    float   m_metalness;
    float   m_roughness;
    float   m_ao;

    float   m_ior;
    float   m_ssDepth;
    float   m_height ;
    float   m_pad;
} materialBuf;

#endif 
