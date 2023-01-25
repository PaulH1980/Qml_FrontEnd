import QtQuick 				2.7
import QtGraphicalEffects 	1.0
import "."
////////////////////////////////////////////
// \Brief: Draws a colorwheel, fully shader based,
// fully self contained==> most of it parameters are automatically adjusted when
// the parent item is resized
////////////////////////////////////////////
Item
{

    signal   hsvChanged( int h, int s, int v )


    id							: colorWheelId
    height						: width
    implicitHeight              : height

    //setup some constants
    property color bgColor  	: Style.defaultBackGroundColor
    property real ringWidth		: width * 0.13333
    property real center 		: width * 0.5
    property real outerRadius 	: width * 0.5

    property real innerRadius 	: outerRadius - ringWidth
    property real downScale 	: 1.5 //cube scale factor ~ sqrt(2)

    property real offset 		:(center - ringWidth) / downScale;
    property real topLeft   	: center - offset;
    property real dimension 	: offset * 2.0

    property int  hue			: 0
    property int  val			: 255
    property int  sat			: 255


    focus						: false

    property int  mouseState	: -1 //TODO bring inside MouseArea ??

    //GLSL
    ShaderEffect
    {
        width   : parent.width
        height  : parent.width

        property real outerRadius 			: parent.outerRadius	//in pixels
        property real innerRadius 			: parent.innerRadius    //in pixels
        property real borderWidth 			: 1.0 //anti- aliasing	for circle
        property real viewportHeight		: height
        property color bgColor				: parent.bgColor
        property color selectedColor		: Qt.hsva( parent.hue / 359, 1.0, 1.0, 1.0 )

        property real downScale				: 1.0 / parent.downScale //scale of saturation & value rectangle

        vertexShader:
            "
                uniform highp mat4 qt_Matrix;
                attribute highp vec4 qt_Vertex;		
				attribute highp vec2 qt_MultiTexCoord0;
                varying highp vec2 coord;				
                																				
                void main()																	
                {																				
                	gl_Position = qt_Matrix * qt_Vertex;
					coord = qt_MultiTexCoord0;					
                }																				
			"
        fragmentShader:
            "
         	    #define PI 3.1415926535897932384626433832795											
               	uniform lowp float  	qt_Opacity;																					
                uniform highp float		innerRadius;	
				uniform highp float		downScale;				
                uniform highp float		outerRadius;		 														
                uniform highp float		borderWidth;																
                uniform highp float  	viewportHeight;															
                uniform lowp vec4  		bgColor;	
				uniform lowp vec4 		selectedColor;
				varying highp vec2 		coord;		
				
                																						
                vec3 rgb2hsv(vec3 c)																	
                {																						
                	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);									
                	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));					
                	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));					
                																						
                	float d = q.x - min(q.w, q.y);														
                	float e = 0.000000001;																	
                	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);			
                }																						
                																						
                vec3 hsv2rgb(vec3 c)																	
                {																						
                	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);										
                	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);									
                	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);							
                }																						
                																						
                																						
                																						
                float atan2( float x, float y )														
                { 																						

					float angle =  x == 0.0 ? sign( y ) * PI/2.0 : atan( y, x );						
                	angle /= 2.0*PI;																		
                	return angle;																		
                } 				


				vec2 getDir()
				{
					vec2 wheelCenterGL = vec2( 0.5, 0.5 );			
                	vec2 dirVec = coord - wheelCenterGL;
					dirVec = normalize(dirVec);
					return dirVec;
				}
				
				float alphaValue( float minVal, float maxVal, float curVal )
				{
					if( curVal <= minVal )
						return 0.0;
					if( curVal >= maxVal )
						return 1.0;
					
					float range  = maxVal - minVal;
					float offset = curVal - minVal;
					
					return offset/range;
					
				}
				
                																						
                vec4 getWheelColor()																		
                {																						
                	vec2 wheelCenterGL = vec2( 0.5, 0.5 );			
                	vec2 xyCoordLocal = coord * viewportHeight;
					vec2 centerPix	  = wheelCenterGL * viewportHeight;
					vec2 dirVec = ( coord - wheelCenterGL ) * viewportHeight;	
					//dirVec = normalize(dirVec) * ( height * 0.5 );
                	float dist  = length( dirVec );														
                	vec4 wheelColor = bgColor;	
					//wheel selection drawing 
                	if( (dist >= innerRadius - borderWidth) && (dist <= outerRadius + borderWidth ) )	
                	{																					
                		float angle = 0.0;																
                		if( dist != 0.0 )																
                		{																				
                			dirVec /= dist;																
                			angle = atan2( dirVec.x, dirVec.y );										
                		}																				
                		float alpha = smoothstep( -borderWidth, borderWidth,  outerRadius - dist);		
                		vec4 hsv = vec4( hsv2rgb( vec3( angle, 1.0, 1.0 ) ), 1.0 );						
                		wheelColor  = mix( wheelColor, hsv, alpha );									
                		alpha = smoothstep( -borderWidth, borderWidth,  innerRadius - dist);			
                		wheelColor  = mix( wheelColor, bgColor, alpha );
						return wheelColor;						
                	}
					//inner selection cube drawing 
					float innerRadiusScaled = innerRadius * downScale;
					vec2 boundsX = vec2(  centerPix.x - innerRadiusScaled, centerPix.x + innerRadiusScaled );
					vec2 boundsY = vec2(  centerPix.y - innerRadiusScaled, centerPix.y + innerRadiusScaled );
					
					if( 	( xyCoordLocal.x > boundsX[0] ) 
						&&  ( xyCoordLocal.x < boundsX[1] ) )
						{
							if( 	( xyCoordLocal.y > boundsY[0] ) 
							&&  	( xyCoordLocal.y < boundsY[1] ) )
							{
								
								float xAlpha = alphaValue( boundsX[0], boundsX[1], xyCoordLocal.x );
								float yAlpha = alphaValue( boundsY[0], boundsY[1], xyCoordLocal.y );								
								
								vec4 color = mix( vec4(1.0), selectedColor, xAlpha );
								color 	   = mix( color, vec4( 0.0, 0.0, 0.0, 1.0 ), yAlpha );
								return color;
							}
						}				
					
					return wheelColor;
                																		
                }																						
               											
                void main()																			
                {																						
                	gl_FragColor = getWheelColor() * qt_Opacity;
                }			
			"	
    }

    Rectangle //Hue selector
    {
        property var xy : color2Wheel( )
        width  : parent.ringWidth * 0.5
        height : parent.ringWidth * 0.5
        radius : width * 0.5
        color  : "White"
        border.width : 2
        border.color : "Black"
        x : xy[0] - ( width  * 0.5 ) //center inside ring
        y : xy[1] - ( height * 0.5 ) //center inside ring
    }

    Rectangle //saturation & value selector
    {
        property real sat 		: parent.sat / 255.0
        property real val 		: (255.0 - parent.val) / 255
        property real offsetX   : sat * parent.dimension;
        property real offsetY   : val * parent.dimension;


        width  		 : parent.ringWidth * 0.5
        height 		 : parent.ringWidth * 0.5
        radius 		 : width * 0.5

        border.width : 2
        border.color : "Black"
        color  		 : "White"

        x : (parent.topLeft + offsetX) - ( width  * 0.5 )
        y : (parent.topLeft + offsetY) - ( height * 0.5 )
    }

    //selected color preview
    Rectangle
    {
        width  		   		 : parent.width * 0.125
        height		   		 : parent.width * 0.125
        anchors.right  		 : parent.right
        anchors.bottom 		 : parent.bottom
        anchors.rightMargin  : width / 8
        anchors.bottomMargin : width / 8

        color 				 : Qt.hsva( parent.hue / 359, parent.sat/255.0, parent.val/255.0, 1.0 )

        border.width		 : 2
        border.color		 : "Black"
    }



    MouseArea
    {
        anchors.fill 	: parent
        preventStealing : true
        acceptedButtons : Qt.LeftButton
        hoverEnabled	: true
        onPressed:
        {
            colorWheelId.focus = true //set focus

            parent.mouseState = -1 //reset state
            var prevValues  = [ parent.hue, parent.sat, parent.val ]
            var curValues   = [ parent.hue, parent.sat, parent.val ]
            //hue selection
            var result = mouseInCircle( mouse.x, mouse.y )
            if( result >= 0.0 ){
                curValues[0] = result
                parent.mouseState = 1
            }
            //saturation value selection
            var satval = mouseInSquare( mouse.x, mouse.y )
            if( satval[0] >= 0.0 )
            {
                curValues[1] = satval[0]
                curValues[2] = satval[1]
                parent.mouseState = 2
            }
            if( !arraysEqual( prevValues, curValues ) ) //emit signal
            {
                parent.hue = curValues[0]
                parent.sat = curValues[1]
                parent.val = curValues[2]
                parent.hsvChanged( curValues[0], curValues[1], curValues[2] )
            }
        }
        //mouse dragging, if we're here do a rectange & circle test
        onPositionChanged:
        {
            if( (parent.mouseState != -1) && ( Qt.LeftButton & pressedButtons ) )
            {
                var prevValues  = [ parent.hue, parent.sat, parent.val ]
                var curValues   = [ parent.hue, parent.sat, parent.val ]

                if( parent.mouseState == 1 )
                {
                    var hue = closestPointOnCircle( mouse.x, mouse.y )
                    if( hue >= 0.0 )
                    {
                        curValues[0] = hue
                    }
                }
                else if ( parent.mouseState == 2 )
                {
                    var satval = closestPointOnSquare( mouse.x, mouse.y )
                    if( satval[0] >= 0.0 )
                    {
                        curValues[1] = satval[0]
                        curValues[2] = satval[1]
                    }
                }
                if( !arraysEqual( prevValues, curValues ) ) //emit signal
                {
                    parent.hue = curValues[0]
                    parent.sat = curValues[1]
                    parent.val = curValues[2]
                    parent.hsvChanged( curValues[0], curValues[1], curValues[2] )
                }
            }
            else
            { //hovering
                var inCircle = mouseInCircle( mouse.x, mouse.y )
                var inSquare = mouseInSquare( mouse.x, mouse.y )
                if( inCircle[0] >= 0 || inSquare[0] >= 0 )
                    cursorShape		: Qt.PointingHandCursor
                else
                    cursorShape		: Qt.ArrowCursor
            }
        }
        onReleased: //reset state
        {
            parent.mouseState = -1
        }
    }

    function closestPointOnSquare( xPos, yPos )
    {
        var result = mouseInSquare(xPos, yPos)
        if( result[0] >= 0.0 )
            return result;
        //closest point outside square
        var a = Qt.vector2d( colorWheelId.center, colorWheelId.center )
        var b = Qt.vector2d( xPos, yPos )
        var corner = colorWheelId.topLeft
        var points =
                [
                    Qt.vector2d(  corner,  corner ).plus( a ),
                    Qt.vector2d( -corner,  corner ).plus( a ),
                    Qt.vector2d( -corner, -corner ).plus( a ),
                    Qt.vector2d(  corner, -corner ).plus( a )
                ]


        var boundsMin = colorWheelId.topLeft
        var boundsMax = boundsMin + colorWheelId.dimension
        //iterate through all the edges
        for( var i = 0; i < 4; ++i ) //this can be optimized but since there are only 4 edges it's low prioirty
        {
            var next = (i + 1) % 4
            var result = lineIntersection( a, b, points[i], points[next])
            if( result[0] == true ) //intersection found
            {
                //calculate saturation & value
                var xAlpha = alphaValue( boundsMin, boundsMax, result[1] )
                var yAlpha = 1.0 - alphaValue( boundsMin, boundsMax, result[2] )
                return [Math.round(xAlpha * 255), Math.round(yAlpha * 255)]
            }
        }
        //no intersection
        return [-1.0]
    }

    function closestPointOnCircle( xPos, yPos )
    {
        var a = Qt.vector2d( colorWheelId.center, colorWheelId.center )
        var b = Qt.vector2d( xPos, yPos )
        var c = a.minus( b );
        var dist = c.length();
        //if( dist <= colorWheelId.innerRadius )
        //	return -1.0
        var hueVal = Math.atan2( c.y, c.x ) + Math.PI
        hueVal /= Math.PI * 2.0
        return Math.round( hueVal * 359.0 )

    }

    function color2Wheel()
    {
        var outerRadius 			= colorWheelId.width * 0.5
        var innerRadius 			= outerRadius - colorWheelId.ringWidth

        var hue  = ( colorWheelId.hue/359 ) * 6.283185307 //2 pi
        var radius = (outerRadius + innerRadius) * 0.5
        var xVal = Math.cos( hue ) * radius + outerRadius
        var yVal = Math.sin( hue ) * radius	+ outerRadius

        return [xVal, yVal]
    }


    function setHsv( h, s, v )
    {
        if( hue !== h )
            hue = h
        if( sat !== s )
            sat = s
        if( val !== v )
            val = v
    }


    function alphaValue( minVal, maxVal, curVal )
    {
        if( curVal <= minVal )
            return 0.0
        if( curVal >= maxVal )
            return 1.0
        var range  = maxVal - minVal
        var offset = curVal - minVal
        return offset/range;
    }

    function lineIntersection( a1, a2, b1, b2 )
    {
        var b = a2.minus( a1 )
        var d = b2.minus( b1 )
        var bDotD = b.x * d.y - b.y * d.x
        if ( bDotD == 0.0 ) //parallel?
            return false

        var oneOverDot = 1.0/bDotD

        var c = b1.minus( a1 )
        var t = (c.x * d.y - c.y * d.x) * oneOverDot
        if (t < 0 || t > 1)
            return false
        var u = (c.x * b.y - c.y * b.x) * oneOverDot
        if (u < 0 || u > 1)
            return false
        var result = a1.plus( b.times( t ) )
        return [true, result.x, result.y ]
    }



    function mouseInSquare( xPos, yPos )
    {
        var boundsMin = colorWheelId.topLeft
        var boundsMax = boundsMin + colorWheelId.dimension

        if( (xPos >= boundsMin) && (xPos <= boundsMax ) )
        {
            if( (yPos >= boundsMin) && ( yPos <= boundsMax ) )
            {
                var xAlpha = alphaValue( boundsMin, boundsMax, xPos )
                var yAlpha = 1.0 - alphaValue( boundsMin, boundsMax, yPos )
                return [Math.round(xAlpha * 255), Math.round(yAlpha * 255)]
            }
        }
        return [-1.0] //outside
    }
    //return the hue value, or -1 if invalid
    function mouseInCircle( xPos, yPos )
    {
        //property real center 	: parent.width * 0.5

        var a = Qt.vector2d( colorWheelId.center, colorWheelId.center )
        var b = Qt.vector2d( xPos, yPos )
        var c = a.minus( b )
        var dist = c.length()
        if( dist >= colorWheelId.innerRadius && dist <= colorWheelId.outerRadius )
        {
            c = c.normalized();
            var hueVal = Math.atan2( c.y, c.x ) + Math.PI
            hueVal /= Math.PI * 2.0
            return Math.round( hueVal * 359.0 )
        }
        return -1.0
    }


    function arraysEqual(a, b)
    {
        if (a === b) return true;
        if (a == null || b == null) return false;
        if (a.length != b.length) return false;
        for (var i = 0; i < a.length; ++i) {
            if (a[i] !== b[i]) return false;
        }
        return true;
    }

}			
