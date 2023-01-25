layout ( lines ) in;
layout ( triangle_strip, max_vertices = 6 ) out;


uniform float gLineWidthHalf    = 2.0;	//line thickness

in vec4		rgba[];
in vec2		uv[];
in vec2		st[];
in vec3		normal[];
in vec4     misc[]; 			
in vec3		viewDir[];
in vec3		worldCoord[];
in vec4     shadowCoord[];
in vec2		velocityXY[];

out GeometryPass
{
	vec2 			uvGeom;
	vec4 			rgbaGeom;
	flat vec2 		lineStartGeom;
	flat vec2 		lineEndGeom;
} vertexOut;

void main()
{
	vec2 p1 = ndcToScreen( gl_in[0].gl_Position );
	vec2 p2 = ndcToScreen( gl_in[1].gl_Position );
	
	//calulate line normals	
    vec2 lineDir    = normalize(p2-p1);		//current line normal
	vec2 lineNormal = vec2( lineDir.y, -lineDir.x );
		
	vec2 offset1 = lineNormal *  -gLineWidthHalf ;
	vec2 offset2 = lineNormal * gLineWidthHalf ;
	
	vertexOut.lineStartGeom = p1;
	vertexOut.lineEndGeom   = p2;
	
	//first triangle
	vec2 output0 		= p1 + offset1;	//a
	vertexOut.uvGeom   	= vec2( 1.0, 0.0 );
	vertexOut.rgbaGeom 	= rgba[0];
	gl_Position 		= screenToNdc( output0 );
	EmitVertex();
	
	vec2 output1 		= p1 + offset2;	//b	
	vertexOut.uvGeom 	= vec2( 1.0, 1.0 );
	vertexOut.rgbaGeom 	= rgba[0];
	gl_Position 		= screenToNdc( output1 );
	EmitVertex();	
	
	vec2 output2 		= p2 + offset1;	//c
	vertexOut.uvGeom 	= vec2( 0.0, 0.0 );
	vertexOut.rgbaGeom  = rgba[1];
	gl_Position 		= screenToNdc( output2 );
	EmitVertex();
	
	vec2 output3 		= p2 + offset2;	//d
	vertexOut.uvGeom 	= vec2( 0.0, 1.0 );
	vertexOut.rgbaGeom 	= rgba[1];
	gl_Position 		= screenToNdc( output3 );
	EmitVertex();	
	
	
	EndPrimitive();	

}