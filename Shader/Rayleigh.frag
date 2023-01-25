
layout( location = 0 ) out vec4 FragColor;




void main()
{
	
	vec3 color = atmosphere(
        normalize(viewDir).xyz,          	// normalized ray direction
        skyBoxBuf.m_rayOrigin.xyz,             // ray origin
        skyBoxBuf.m_sunPos.xyz,                // position of the sun
        skyBoxBuf.m_intensity,                 // intensity of the sun
        skyBoxBuf.m_radiusPlanet,              // radius of the planet in meters
        skyBoxBuf.m_radiusAtmos,               // radius of the atmosphere in meters
        skyBoxBuf.m_raylghScatCoeff.xyz, 		// Rayleigh scattering coefficient
        skyBoxBuf.m_mieScatCoeff,              // Mie scattering coefficient
        skyBoxBuf.m_rayLeighScaleHeight,       // Rayleigh scale height
        skyBoxBuf.m_mieScaleHeight,            // Mie scale height
        skyBoxBuf.m_mieScatDir                 // Mie preferred scattering direction
    );

    // Apply exposure.
    color = 1.0 - exp(-1.0 * color);
	//vec3 envColor   = texture(environment, normalize(viewDir).xzy ).xyz;	
	FragColor.xyzw =  vec4( color , 1.0);
}