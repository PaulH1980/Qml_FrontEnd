layout( location = 0 ) in vec3		vertIn;
layout( location = 1 ) in vec4		rgbaIn;
layout( location = 2 ) in vec2		stIn;
layout( location = 3 ) in vec2		uvIn;
layout( location = 4 ) in vec4		normalIn;	//normal & tangent


out vec4 rgba;
out vec2 uv;
out vec2 st;
out vec3 normal;
out vec4 misc; 			
out vec3 viewDir;
out vec3 worldCoord;
out vec4 shadowCoord;
out vec2 velocityXY;