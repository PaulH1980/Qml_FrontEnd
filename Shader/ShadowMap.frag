layout( location = 0 )  out float fragDepth;

void main()
{
	
	fragDepth.x = gl_FragCoord.z;
}