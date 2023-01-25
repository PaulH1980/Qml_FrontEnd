import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts



Item
{
    id                                  : control
    anchors.fill                        : parent
    property real       scale           : 1.0
    property real       scaleFactor     : 1.1
    property real       gridSize        : 64
    property real       minLineDistance : 64

    property vector2d   topLeft      : Qt.vector2d( 0, 0 )
    property vector2d   botRight     : Qt.vector2d( 0, 0 )
    property vector2d   translationDb: Qt.vector2d( 0, 0 )
    property vector2d   translation  : Qt.vector2d( 0, 0 )
    property color      bgColor      : Qt.rgba( 24/255, 24/255, 24/255, 1);
    property color      gridColor    : Qt.rgba( 48/255, 48/255, 64/255, 1);

    property matrix4x4 posMatrix    : Qt.matrix4x4(  1,      0,      0,      translation.x,
                                                   0,      1,      0,      translation.y,
                                                   0,      0,      1,      0,
                                                   0,      0,      0,      1 )

    property matrix4x4 scaleMatrix   : Qt.matrix4x4( scale,  0,      0,      0,
                                                    0,      scale,  0,      0,
                                                    0,      0,      1,      0,
                                                    0,      0,      0,      1 )

    property matrix4x4 canvasTrans : scaleMatrix.times( posMatrix )

    transform: Matrix4x4 {
        id     : trans;
        matrix : canvasTrans
    }

    
    //canvas : required for drawing connections between nodes
    Canvas
    {
        anchors.fill        : parent
        id                  : canvas
        antialiasing        : true
        smooth              : true
        
        transform: Matrix4x4 {
            matrix : canvasTrans.inverted()
        }

        onPaint:
        {
            var context = getContext( "2d" )
            context.fillStyle = bgColor
            context.fillRect(  0, 0, canvas.width, canvas.height )
            drawGrid( context )
            var children = getConnections()
            //let the children draw themself
            for( var i in children )
                children[i].drawSelf( context )
        }
    }

  
    //#todo fixme
    Timer {
        interval: 33
        running: true
        repeat: true
        onTriggered: canvas.requestPaint()
    }


    function getGridSizeInPixels()
    {
        const pixScale = control.pixelScale()
        var curGrid = control.gridSize;
        var pixSize = curGrid / pixScale.x
        while( pixSize <= control.minLineDistance ){
            curGrid  *= 2
            pixSize  *= 2
        }
        return pixSize
    }

    function pixelScale()
    {
        var topLeft  = screenToWorld( Qt.vector2d( 0, 0 ) )
        var botRight = screenToWorld( Qt.vector2d( width, height ) )
        var offset   = Qt.vector2d( botRight.x - topLeft.x , botRight.y - topLeft.y )
        return Qt.vector2d( offset.x / width, offset.y / height )
    }

    function drawGrid( context )
    {
        // init drawing context and set properties
        context.beginPath()
        context.lineWidth   = 0.4 * control.scale;
        context.strokeStyle =  gridColor

        //world coordinates
        var topLeft  = screenToWorld( Qt.vector2d( 0, 0 ) )
        var botRight = screenToWorld( Qt.vector2d( width, height ) )
        //snapped to grid
        topLeft  = AppScripts.snapPointToGrid( topLeft, gridSize, true )
        botRight = AppScripts.snapPointToGrid( botRight, gridSize, false )
        //converted to pixels
        topLeft   = worldToScreen( topLeft  )
        botRight  = worldToScreen( botRight )

        const pixSize = getGridSizeInPixels();
        for(var x = topLeft.x; x <= botRight.x; x += pixSize ) {
            context.moveTo( x, topLeft.y)
            context.lineTo( x, botRight.y )
        }
        for(var y = topLeft.y; y <= botRight.y; y += pixSize ) {
            context.moveTo( topLeft.x, y )
            context.lineTo( botRight.x, y )
        }

        context.stroke()
        context.closePath()

        //draw origin
        var originScreen = worldToScreen( Qt.vector2d( 0, 0 )  )
        context.beginPath()
        context.lineWidth   = 2;
        context.strokeStyle = gridColor
        context.moveTo( originScreen.x, topLeft.y  )
        context.lineTo( originScreen.x, botRight.y )
        context.moveTo(  topLeft.x , originScreen.y )
        context.lineTo(  botRight.x, originScreen.y )
        context.stroke()
        context.closePath()
    }



    function getBoundingBox()
    {
        var bbox = new FlowScripts.BBox2()
        for( var i in control.children ) {
            var child = control.children[i]
            if( child instanceof FlowNodeBase ) {
                bbox.update( Qt.vector2d( child.x, child.y ) )
                bbox.update( Qt.vector2d( child.x + child.width, child.y + child.height ) )
            }
        }
        return bbox;
    }


    function getPortLocation( port, hotSpotX, hotSpotY )
    {
        return canvas.mapFromItem( port, hotSpotX, hotSpotY )
    }

    function repaint()
    {

    }

    /*
        @brief: Return the input nodes
    */
    function getOutputNodes() {
        const fn = function ( node ){
            return node instanceof FlowOutputNodeBase
        };
        return forEachChild( fn )
    }

    /*
        @brief: Return the input nodes
    */
    function getInputNodes() {
        const fn = function ( node ){
            return node instanceof FlowInputNodeBase
        };
        return forEachChild( fn )
    }

    /*
        @brief: Return all the input & output nodes
    */
    function getNodes() {
        const fn = function ( node ){
            return node instanceof FlowNodeBase
        };
        return forEachChild( fn )
    }

    function getSelectedNodes()
    {
        const fn = function ( node ){
            return ( ( node instanceof FlowNodeBase ) && node.selected ) 
        };
        return forEachChild( fn )
    }

    /*
        @brief: Return all connections
    */
    function getConnections() {
        const fn = function( node ){
            return node instanceof FlowConnectionBase
        };
        return forEachChild( fn )
    }

    function isFlowObject( item )
    {
        return ( item instanceof FlowNodeBase ||
                item instanceof FlowConnectionBase )
    }


    /*
        @brief: Clear all node items from this canvas
    */
    function clearFlowItems()
    {
        var length = control.children.length - 1;
        var result = []
        for( var i = length; i >= 0 ; --i ) {
            var child = control.children[i]
            if( isFlowObject( child ) ) {
                control.children[i].destroy()
            }
            else
                result.push( child )
        }
        control.children = result;
    }

    /*
        @brief: iterate over each child,
        add to list if callback returns 'true'
    */
    function forEachChild( callback ) {
        var result = []
        for( var i in control.children ) {
            var child = control.children[i]
            if( callback( child ) )
                result.push( child )
        }
        return result
    }
}

