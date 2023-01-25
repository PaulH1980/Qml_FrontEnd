import QtQuick 2.7
import "."

Canvas {
    width: 100;
    height: 100;
    smooth: true;
    antialiasing: true;
    contextType: "2d";
    onPaint: {
        var context = getContext("2d");
        if (context !== null) {
			
            context.reset ();
			context.globalAlpha = alpha
            // NOTE : filling points clockwise from top left (0,0)
            /// border
            var borderPoints = [];
            // top left corner
            if (topLeftRadius) {
                addPointsFromArc (borderPoints,
                                  Qt.point (topLeftRadius, topLeftRadius),
                                  topLeftRadius, topLeftRadius,
                                  180, 270);
            }
            else {
                borderPoints.push (Qt.point (0, 0));
            }
            // top right corner
            if (topRightRadius) {
                addPointsFromArc (borderPoints,
                                  Qt.point (width - topRightRadius, topRightRadius),
                                  topRightRadius, topRightRadius,
                                  270, 0);
            }
            else {
                borderPoints.push (Qt.point (width, 0));
            }
            // bottom right corner
            if (bottomRightRadius) {
                addPointsFromArc (borderPoints,
                                  Qt.point (width - bottomRightRadius, height - bottomRightRadius),
                                  bottomRightRadius, bottomRightRadius,
                                  0, 90);
            }
            else {
                borderPoints.push (Qt.point (width, height));
            }
            // bottom left corner
            if (bottomLeftRadius) {
                addPointsFromArc (borderPoints,
                                  Qt.point (bottomLeftRadius, height - bottomLeftRadius),
                                  bottomLeftRadius, bottomLeftRadius,
                                  90, 180);
            }
            else {
                borderPoints.push (Qt.point (0, height));
            }
            context.beginPath ();
            borderPoints.forEach (function (point, idx) {
                context [idx ? "lineTo" : "moveTo"] (point ["x"], point ["y"]);
            });
            context.closePath ();
            context.fillStyle = lineColor;
            context.fill ();
            
			
			
			/// background
            var backgroundPoints = [];
            // top left corner
            if (topLeftRadius) {
                addPointsFromArc (backgroundPoints,
                                  Qt.point (topLeftRadius, topLeftRadius),
                                  topLeftRadius - leftBorderSize, topLeftRadius - topBorderSize,
                                  180, 270);
            }
            else {
                backgroundPoints.push (Qt.point (leftBorderSize, topBorderSize));
            }
            // top right corner
            if (topRightRadius) {
                addPointsFromArc (backgroundPoints,
                                  Qt.point (width - topRightRadius, topRightRadius),
                                  topRightRadius - rightBorderSize, topRightRadius - topBorderSize,
                                  270, 0);
            }
            else {
                backgroundPoints.push (Qt.point (width - rightBorderSize, topBorderSize));
            }
            // bottom right corner
            if (bottomRightRadius) {
                addPointsFromArc (backgroundPoints,
                                  Qt.point (width - bottomRightRadius, height - bottomRightRadius),
                                  bottomRightRadius - rightBorderSize, bottomRightRadius - bottomBorderSize,
                                  0, 90);
            }
            else {
                backgroundPoints.push (Qt.point (width - rightBorderSize, height - bottomBorderSize));
            }
            // bottom left corner
            if (bottomLeftRadius) {
                addPointsFromArc (backgroundPoints,
                                  Qt.point (bottomLeftRadius, height - bottomLeftRadius),
                                  bottomLeftRadius - leftBorderSize, bottomLeftRadius - bottomBorderSize,
                                  90, 180);
            }
            else {
                backgroundPoints.push (Qt.point (leftBorderSize, height - bottomBorderSize));
            }
            context.beginPath ();
            backgroundPoints.forEach (function (point, idx) {
                context [idx ? "lineTo" : "moveTo"] (point ["x"], point ["y"]);
            });
					
            context.closePath ();
			if( gradient.stops.length )
			{
				var grad = context.createLinearGradient( startGrad.x, startGrad.y, 
														 endGrad.x, endGrad.y)
				for( var idx = 0; idx < gradient.stops.length; ++idx )
				{
					var tmp = gradient.stops[idx];
					grad.addColorStop( tmp.position, tmp.color );
				}				
				context.fillStyle = grad;
			}
			else			
				context.fillStyle = fillColor;
            context.fill ();
        }
    }
    Component.onCompleted: { requestPaint (); }
    onFillColorChanged: { requestPaint (); }
    onLineColorChanged: { requestPaint (); }
    onTopBorderSizeChanged: { requestPaint (); }
    onLeftBorderSizeChanged: { requestPaint (); }
    onRightBorderSizeChanged: { requestPaint (); }
    onBottomBorderSizeChanged: { requestPaint (); }
    onTopLeftRadiusChanged: { requestPaint (); }
    onTopRightRadiusChanged: { requestPaint (); }
    onBottomLeftRadiusChanged: { requestPaint (); }
    onBottomRightRadiusChanged: { requestPaint (); }
	onHeightChanged:  { requestPaint (); }
	onWidthChanged:  { requestPaint (); }
	
	property real alpha				: Style.roundRectAlpha
    property color fillColor 		: Style.roundRectFillColor;
    property color lineColor 		: Style.roundRectLineColor
    property real borderSize        : Style.roundRectBorderSize;    
    property real radius            : Style.roundRectRadius;
	
    property real topLeftRadius     : radius;
    property real topRightRadius    : radius;
    property real bottomLeftRadius  : radius;
    property real bottomRightRadius : radius;
	property real topBorderSize     : borderSize;
    property real leftBorderSize    : borderSize;
    property real rightBorderSize   : borderSize;
    property real bottomBorderSize  : borderSize;
		
	property variant startGrad		: Qt.point(0, 0)
	property variant endGrad		: Qt.point(0, height)	
	property Gradient gradient		: Gradient{}
	
    function addPointsFromArc (list, center, xRadius, yRadius, startAngle, endAngle) {
        var angle = startAngle;
        while (angle !== endAngle) {
            list.push (Qt.point (center ["x"] + xRadius * Math.cos (angle * Math.PI / 180),
                                 center ["y"] + yRadius * Math.sin (angle * Math.PI / 180)));
            angle = ((360 + angle +1) % 360);
        }
    }
}