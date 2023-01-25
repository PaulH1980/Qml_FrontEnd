#ifndef _IRRADIANCE_GLSL_
#define _IRRADIANCE_GLSL_

uniform samplerCube toSample; 

vec3 SampleIrradiance( vec3 N, float stepSize )
{
	float PI = 3.14159265;
	vec3 up = vec3( 0.0, 0.0, 1.0 );
	vec3 side = cross( up, N );
	up   = cross(N, side);
	
	vec3 result = vec3( 0.0 );
	float sampleCount = 0.0;
	for( float phi = 0.0; phi < 2.0 * PI; phi += stepSize ) //outer loop on hemisphere
	{
		for( float theta = 0.0; theta < 0.5 * PI; theta += stepSize ) //inner loop 
		{
			vec3 tangentSample = vec3(sin(theta) * cos(phi),  sin(theta) * sin(phi), cos(theta));       
			vec3 sampleVec = tangentSample.x * side + tangentSample.y * up + tangentSample.z * N; 
			result += texture( toSample, sampleVec ).rgb * cos(theta) * sin(theta);			
			sampleCount++;
		}
	}
	result = PI * result * ( 1.0 / sampleCount );
	return result;
}



#endif 
