layout( location = 0 ) out vec4 FragColor;

uniform vec2  		gGradientStart;
uniform vec2  		gGradientEnd;
uniform vec4		gBrushColor;
uniform int			gBrushStyle;		//1 mask of parts of polygon,2 gradient, 3 use as texture
uniform sampler2D 	gBrushPattern;

uniform vec2		gRepeats;
uniform float		gRotation;
		
uniform vec4		gBounds;

void main()
{
	FragColor = rgba;
}