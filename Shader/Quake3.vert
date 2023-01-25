layout( location = 0 ) in vec3		vertIn;
layout( location = 1 ) in vec4 		rgbaIn;
layout( location = 2 ) in vec2		stIn;	//regulart tex coords
layout( location = 3 ) in vec2 		uvIn;	//lightmap coords
layout( location = 4 ) in vec4		normalIn;

out vec4		world;
out vec4		rgba;
out vec2		st;
out vec2		uv;
out vec4		normal;

struct WaveDeform
{
  int 		type;
  float		pad[3];
  
  float 	base;
  float 	amp;
  float 	phase;
  float 	freq;
};


struct VertexDeform
{
	WaveDeform	wave;
	vec3		bulge;
	float 		div;	
	vec3		move;
	vec2		normal;
	float 		pad[2];	
}



void main()
{
	world  		= objTransform * vec4( vertIn, 1.0 );
	rgba		= rgbaIn;
	st			= stIn;
	uv			= uvIn;
	normal		= normalIn;
	
	gl_Position = viewBuffer.m_wvpMatrix * world;
		
}