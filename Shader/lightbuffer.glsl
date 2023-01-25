#ifndef _LIGHTINFO_GLSL_
#define _LIGHTINFO_GLSL_


mat3 cotangent_frame( vec3 N, vec3 p, vec2 uv )
{
    // get edge vectors of the pixel triangle
    vec3 dp1 = dFdx( p );
    vec3 dp2 = dFdy( p );
    vec2 duv1 = dFdx( uv );
    vec2 duv2 = dFdy( uv );
 
    // solve the linear system
    vec3 dp2perp = cross( dp2, N );
    vec3 dp1perp = cross( N, dp1 );
    vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
 
    // construct a scale-invariant frame 
    float invmax = inversesqrt( max( dot(T,T), dot(B,B) ) );
    return mat3( T * invmax, B * invmax, N );
}

vec3 perturb_normal( vec3 N, vec3 V, vec2 uv, vec3 map )
{
	map.x = -map.x;	
    mat3 TBN = cotangent_frame( N, -V, uv );
	vec3 norm = normalize( TBN * map );
    return norm;;
}




// handy value clamping to 0 - 1 range
float saturate(in float value)
{
    return clamp(value, 0.0, 1.0);
}


// phong (lambertian) diffuse term
float phong_diffuse()
{
    return (1.0 / PI);
}


// compute fresnel specular factor for given base specular and product
// product could be NdV or VdH depending on used technique
vec3 fresnel_factor(in vec3 f0, in float product)
{
    return mix(f0, vec3(1.0), pow(1.01 - product, 5.0));
}


// following functions are copies of UE4
// for computing cook-torrance specular lighting terms

float D_blinn(in float roughness, in float NdH)
{
    float m = roughness * roughness;
    float m2 = m * m;
    float n = 2.0 / m2 - 2.0;
    return (n + 2.0) / (2.0 * PI) * pow(NdH, n);
}

float D_beckmann(in float roughness, in float NdH)
{
    float m = roughness * roughness;
    float m2 = m * m;
    float NdH2 = NdH * NdH;
    return exp((NdH2 - 1.0) / (m2 * NdH2)) / (PI * m2 * NdH2 * NdH2);
}

float D_GGX(in float roughness, in float NdH)
{
    float m = roughness * roughness;
    float m2 = m * m;
    float d = (NdH * m2 - NdH) * NdH + 1.0;
    return m2 / (PI * d * d);
}

float G_schlick(in float roughness, in float NdV, in float NdL)
{
    float k = roughness * roughness * 0.5;
    float V = NdV * (1.0 - k) + k;
    float L = NdL * (1.0 - k) + k;
    return 0.25 / (V * L);
}


// simple phong specular calculation with normalization
vec3 phong_specular(in vec3 V, in vec3 L, in vec3 N, in vec3 specular, in float roughness)
{
    vec3 R = reflect(-L, N);
    float spec = max(0.0, dot(V, R));

    float k = 1.999 / (roughness * roughness);

    return min(1.0, 3.0 * 0.0398 * k) * pow(spec, min(10000.0, k)) * specular;
}

// simple blinn specular calculation with normalization
vec3 blinn_specular(in float NdH, in vec3 specular, in float roughness)
{
    float k = 1.999 / (roughness * roughness);
    
    return min(1.0, 3.0 * 0.0398 * k) * pow(NdH, min(10000.0, k)) * specular;
}

// cook-torrance specular calculation                      
vec3 cooktorrance_specular(in float NdL, in float NdV, in float NdH, in vec3 specular, in float roughness, in float specPower )
{
	float D = 1.0;

#ifdef COOK_BLINN
     D = D_blinn(roughness, NdH);
#endif
#ifdef COOK_BECKMANN
     D = D_beckmann(roughness, NdH);
#endif
#ifdef COOK_GGX
     D = D_GGX(roughness, NdH);
#endif

    float G = G_schlick(roughness, NdV, NdL);

    float rim = mix(1.0 - roughness * specPower * 0.9, 1.0, NdV);

    return (1.0 / rim) * specular * G * D;
}




vec4 LightSurfaceNormal()
{
	return vec4( 1.0 ) ;	
}


vec3 GetSurfaceNormal( )
{
	vec3 n = normalize( normal );
#ifdef USE_NORMALMAP	
	vec3 normalMap  = texture( tex_1, uv ).xyz * 2.0 - 1.0;	
	vec3 faceNormal = perturb_normal( n, viewDir, uv, normalMap );	
	return faceNormal;	
#else
	return n;
#endif
}

vec3 SurfaceToEye(   )
{
	vec3 vDir = normalize( viewDir );
	return vDir;
}

float SunLight() 
{
	vec3 N 	= GetSurfaceNormal();
	vec3 I 	= SurfaceToEye();
	vec3 L  = normalize(viewBuffer.m_sunPos.xyz);	
	float ndl = dot( N, L );	
	return max( 0.0, ndl);	
}

float ShadowPoint()
{
	vec4 sCoord = shadowCoord;
	sCoord.z -= 0.001;
	if (texture(shadowMap, sCoord.xyz, 0.000).r < 1.0f)
		return 0.5;	
	return 1.0;
}



vec3 ShadePixel( vec3 worldCoord, vec3 surfNormal, vec3 albedo, float roughness, float metallic, float opacity )
{
	return vec3( 1.0 );
}



vec4 ShadePixel( in vec3 worldCoord )
{
	int pointStart = lightBuf.m_pointLightStart;
	int pointEnd   = pointStart + lightBuf.m_pointLightEnd;
	int spotStart  = lightBuf.m_spotStart;
	int spotEnd    = spotStart + lightBuf.m_spotEnd;
	
	vec4 contrib = vec4( 0.0 );
	for( int i = 0; i < pointEnd; ++i ) //point lights
	{
		LightInfo curLight = lightBuf.m_numLights[i];
		float dist = distance( worldCoord, curLight.m_position.xyz );		
		float att = 1.0 /( ( dist * dist ) + 1 );		
		vec3 lDir = worldCoord - curLight.m_position.xyz;
		vec3 lDirNormalize = normalize( lDir );
		
		float ndl = max( 0.0, dot( GetSurfaceNormal(), lDirNormalize ) );
		//att *= ndl;
		contrib.xyz += att * curLight.m_color.xyz * curLight.m_color.w;				
	}
	for( int i = spotStart; i < spotEnd; ++i )
	{	
		LightInfo curLight 		= lightBuf.m_numLights[i];
		float interRange 		= curLight.m_spotAngle - curLight.m_spotCutOff;
		vec3 lightToSurfaceDir	= normalize(  curLight.m_position.xyz - worldCoord  );
		float ndl 				= max( 0.0, dot( GetSurfaceNormal(), lightToSurfaceDir ) );
		float dist 				= distance( worldCoord, curLight.m_position.xyz );
		float cosAngle  		= dot( lightToSurfaceDir, -curLight.m_direction.xyz );
		
		float att  = 0.0;	
		if( cosAngle > curLight.m_spotCutOff )
		{
			att = (1.0 /( ( dist * dist  ) + 1 )) * curLight.m_color.w;
		}
		//att *= ndl;
		contrib.xyz += curLight.m_color.xyz * att;	
		
	}
	return contrib;
}


#endif 
