layout ( lines_adjacency ) in;
layout ( triangle_strip, max_vertices = 6 ) out;

uniform float gFeatherDist 			= 1.0;	//fade out after this distance
uniform float gLineWidth   			= 100.0;	//line thickness


in vec4 rgba[];

out vec2 uvGeom;
out vec4 rgbaGeom;

void main()
{
	float lineWidthHalf = gLineWidth * 0.5;
	
	vec2 p0 = ndcToScreen( gl_in[0].gl_Position );
	vec2 p1 = ndcToScreen( gl_in[1].gl_Position );
	vec2 p2 = ndcToScreen( gl_in[2].gl_Position );
	vec2 p3 = ndcToScreen( gl_in[3].gl_Position );
	
	//calulate line normals
	vec2 lineDir0    = normalize(p1-p0);
    vec2 lineDir1    = normalize(p2-p1);		//current line normal
	vec2 lineDir2    = normalize(p3-p2);
	
	vec2 prevNormal = vec2( lineDir0.y, -lineDir0.x );
	vec2 lineNormal = vec2( lineDir1.y, -lineDir1.x );
	vec2 nextNormal = vec2( lineDir2.y, -lineDir2.x );
	
	
	vec2 offsetDir1 = normalize(prevNormal + lineNormal);
	vec2 offsetDir2 = normalize(nextNormal + lineNormal);
	
	
	//first triangle
	vec2 output0 = p1 + (offsetDir1 * -1.0);	//a
	uvGeom = vec2( 0.0, 1.0 );
	rgbaGeom = rgba[0];
	gl_Position = screenToNdc( output0 );
	EmitVertex();
	
	vec2 output1 = p1 + (offsetDir1 * 1.0);	//b	
	uvGeom = vec2( 0.0, 0.0 );
	rgbaGeom = rgba[0];
	gl_Position = screenToNdc( output1 );
	EmitVertex();	
	
	vec2 output2 = p2 + (offsetDir2 * -1.0);	//a
	uvGeom = vec2( 1.0, 0.0 );
	rgbaGeom = rgba[1];
	gl_Position = screenToNdc( output2 );
	EmitVertex();
	
	vec2 output3 = p2 + (offsetDir2 * 1.0);
	uvGeom = vec2( 1.0, 1.0 );
	rgbaGeom = rgba[1];
	gl_Position = screenToNdc( output3 );
	EmitVertex();	
	
	
	EndPrimitive();	

}