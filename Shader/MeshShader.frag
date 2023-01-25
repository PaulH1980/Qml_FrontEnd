

vec3 GetAlbedo( )
{
#ifdef USE_ALBEDOMAP	
	vec3 albedo = texture2D(tex_0, uv).xyz;	
#else
	vec3 albedo = materialBuf.m_albedo.xyz;
#endif
return albedo;
}



float GetRoughness()
{
#ifdef USE_ROUGHNESSMAP
    float roughness = texture2D(tex_2, uv).x;
#else
    float roughness = materialBuf.m_roughness;
#endif
	return roughness;  
}

float GetMetalness()
{
#ifdef USE_METALMAP
    float metal = texture2D(tex_3, uv).x;
#else
    float metal = materialBuf.m_metalness;
#endif
	return metal; 
}

vec3 GetSpecular()
{
	vec3 specular = mix(vec3(0.04), GetAlbedo(), GetMetalness());
	return specular;
}


// ----------------------------------------------------------------------------
float DistributionGGX(vec3 N, vec3 H, float roughness)
{
    float a = roughness*roughness;
    float a2 = a*a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH*NdotH;

    float nom   = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;

    return nom / denom;
}
// ----------------------------------------------------------------------------
float GeometrySchlickGGX(float NdotV, float roughness)
{
    float r = (roughness + 1.0);
    float k = (r*r) / 8.0;

    float nom   = NdotV;
    float denom = NdotV * (1.0 - k) + k;

    return nom / denom;
}
// ----------------------------------------------------------------------------
float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx2 = GeometrySchlickGGX(NdotV, roughness);
    float ggx1 = GeometrySchlickGGX(NdotL, roughness);

    return ggx1 * ggx2;
}
// ----------------------------------------------------------------------------
vec3 fresnelSchlick(float cosTheta, vec3 F0)
{
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}



#ifdef OUTPUT_MATERIAL
layout( location = 0 ) out vec4 FragColor;
void main()
{
	vec3 albColor   = GetAlbedo();
	vec3 specColor  = GetSpecular();
	float roughness = GetRoughness();
	float metallic  = GetMetalness();
	
	vec3 N  = GetSurfaceNormal();
	vec3 V  = -SurfaceToEye(); //eyev vector
	vec3 L  = normalize(viewBuffer.m_sunPos.xyz);
	vec3 H  = normalize(L + V);	
	vec3 R =  normalize(reflect(V, N));
	
	//vec3 cube = texture( environment, N ).xyz;
	vec3 radiance = vec3( 1.0 );
	
	// = vec3( 1.0, 0.86, 0.57 );
	
	
	float  NdL = max(0.0,   dot(N, L));
    float  NdV = max(0.0001, dot(N, V));
    float  NdH = max(0.0001, dot(N, H));
    float  HdV = max(0.0001, dot(H, V));
    float  LdV = max(0.0001, dot(L, V));
	
	
	vec3 F0 = vec3(0.04); 
    F0 = mix(F0, albColor, metallic);	
	
	float NDF = DistributionGGX(N, H, roughness);   
    float G   = GeometrySmith(N, V, L, roughness);      
    vec3 F    = fresnelSchlick(max(dot(H, V), 0.0), F0);
           
    vec3 nominator    = NDF * G * F; 
    float denominator = 4 * max( NdV * NdL, 0.0) + 0.001; // 0.001 to prevent divide by zero.
    vec3 brdf = nominator / denominator;
        
        // kS is equal to Fresnel
    vec3 kS = F;
        // for energy conservation, the diffuse and specular light can't
        // be above 1.0 (unless the surface emits light); to preserve this
        // relationship the diffuse component (kD) should equal 1.0 - kS.
    vec3 kD = vec3(1.0) - kS;
        // multiply kD by the inverse metalness such that only non-metals 
        // have diffuse lighting, or a linear blend if partly metal (pure metals
        // have no diffuse light).
    kD *= 1.0 - metallic;	  

        // add to outgoing radiance Lo
	vec3 Lo = vec3(0.0);
    Lo += (kD * albColor / PI + brdf) * radiance * NdL;  
	
	 // ambient lighting (note that the next IBL tutorial will replace 
    // this ambient lighting with environment lighting).
    vec3 ambient = vec3(0.03) * albColor;

    vec3 color = ambient + Lo;

    // HDR tonemapping
    color = color / (color + vec3(1.0));
    // gamma correct
    color = pow(color, vec3(1.0/2.2));  
	
	//vec2 dist = velocityXY;
	
	FragColor  = vec4(N, 1.0 );
}


#elif defined(SAMPLE_IRRADIANCE)
layout( location = 0 ) out vec4 FragColor;
void main()
{
	vec3 color = SampleIrradiance( normalize( viewDir ), 0.025 );
	  // HDR tonemapping
    color = color / (color + vec3(1.0));
    // gamma correct
    color = pow(color, vec3(1.0/2.2)); 
	
	FragColor =  vec4( color, 1.0);
}

#elif defined(RENDER_ALBEDO_TO_CUBE)
layout( location = 0 ) out vec4 FragColor;
void main()
{
	vec3 color   = GetAlbedo();
	  // HDR tonemapping
   // color = color / (color + vec3(1.0));
    // gamma correct
    //color = pow(color, vec3(1.0/2.2)); 	
	FragColor =  vec4( color, 1.0);
}

#else 
layout( location = 0 ) out vec4 FragColor;
void main()
{
	//vec3 texColor  = texture( albedoTex, uv ).rgb;//+ m_ambient.xyz ;
	vec3 albColor   = GetAlbedo();
	vec3 specColor  = GetSpecular();
	float roughness = GetRoughness();
	float metallic  = GetMetalness();
	
	
	
	//albColor = vec3( 1.000, 0.766, 0.336); //godl

	vec3 N  = GetSurfaceNormal();
	vec3 V  = -SurfaceToEye(); //eyev vector
	vec3 L  = normalize(viewBuffer.m_sunPos.xyz);
	vec3 H  = normalize(L + V);	
	vec3 R =  reflect(V, vec3(0.0, 0.0, 1.0) );
	
	vec3 cube = texture( environment, normalize(viewDir ).xyz ).xyz;

	//vec3 surfNormal = GetSurfaceNormal2();//GetSurfacenormal( worldCoord, normal, tangent, biTangent, normalMap.xyz );
	FragColor = vec4( albColor * ShadowPoint(), 1.0 ) ;
}
#endif

