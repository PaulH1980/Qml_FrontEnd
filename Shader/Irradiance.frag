layout( location = 0 ) out vec4 FragColor;
in   vec3		worldPos;

void main()
{
	
	
	vec3 irrad  = SampleIrradiance( normalize( worldPos ), 0.025 );
	FragColor.xyzw = vec4( irrad, 1.0 );
	//FragColor.xyz = abs(normalize( viewDir ) );
}