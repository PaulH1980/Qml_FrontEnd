import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "."

Item{
    id                       : control
    property var outputPort  : null
    property var inputPort   : null
    property int operandType : 0
    property var operandValue:({})
    property int lineWidth   : 2
    width                    : 0
    height                   : 0



    function remove()
    {
        if( outputPort !== null ){
            outputPort.removeConnection( control )
            outputPort = null
        }
        if( inputPort !== null ){
            inputPort.removeConnection( control )
            inputPort = null            
        }
    }


    /*
        @brief: Returns true if mouse hovers bezier curve
    */
    function mouseOnConnection( worldPos )
    {
        return false
    }

    /*
        @brief: Map port into canvas coordinates
    */
    function    getCanvasCoordinates( curPort )
    {
        var hotSpot = curPort.getHotSpot()
        return parent.getPortLocation( curPort, hotSpot.x, hotSpot.y )
    }

    /*
        @brief: Draw Connection
    */
    function drawSelf( drawContext ) {
        if( outputPort === null || inputPort === null )
            return false

        var start   = getCanvasCoordinates( outputPort.getPortInternal() )
        var end     = getCanvasCoordinates( inputPort.getPortInternal() )
        if( start.x > end.x ) {
            var tmp = start;
            start = end;
            end = tmp;
        }
        
        var minmax  = getMinMax( start, end )
        var sizeX   = minmax[2] - minmax[0]


        drawContext.lineWidth   = control.lineWidth;
        drawContext.strokeStyle = FlowConfig.connectedColor
        drawContext.beginPath()
        drawContext.moveTo( start.x, start.y )
        drawContext.bezierCurveTo( start.x + sizeX / 4 , start.y, end.x - sizeX / 4, end.y, end.x, end.y )
        drawContext.stroke()
        return true;
    }


    function getMinMax( start, end )
    {
        var minX, minY,
        maxX, maxY
        if( start.x < end.x ) {
            minX = start.x
            maxX = end.x
        }
        else {
            minX = end.x
            maxX = start.x
        }

        if( start.y < end.y ) {
            minY = start.y
            maxY = end.y
        }
        else {
            minY = end.y
            maxY = start.y
        }
        return [minX, minY, maxX, maxY]
    }

    function getVariableName()
    {
        if( !outputPort )
            return null
        return outputPort.getVariableName()
    }

    function getOutputPort() 
    {
        return outputPort
    }

    function getInputPort()
    {
        return inputPort
    }

}

