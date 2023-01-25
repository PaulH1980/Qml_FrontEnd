import QtQuick 2.7
import QtQuick.Controls 2.4
Item
{
    signal   portClicked ( var portId, var mouse )
    signal   portPressed ( var portId, var mouse )
    signal   portReleased( var portId, var mouse )
    signal   portDragged ( var portId, var mouse )


    property int dimensions : 16;
    id                      : portId
    property alias color    : visualPort.color
    state                   : "Disabled" //not active
    
    Rectangle
    {
        anchors.centerIn : parent
        width            : dimensions
        height           : dimensions
        radius           : dimensions / 2
        id               : visualPort
        color            : FlowConfig.unConnectedColor
    }

    MouseArea
    {
        anchors.fill            : portId
        id                      : mouseArea
        hoverEnabled            : true
        acceptedButtons         : Qt.AllButtons
        propagateComposedEvents : true

        onPositionChanged:
        {
            var mousePos   = Qt.vector2d( mouse.x, mouse.y );  //doesnt work
            portDragged( portId, mouse ) //emit signal
            mouse.accepted = true
        }
        onClicked:
        {
            portClicked( portId, mouse ) //emit signal
            mouse.accepted = true
        }
        onPressed:
        {
            portPressed( portId, mouse ) //emit signal
            mouse.accepted      = true
        }
        onReleased:
        {
            portReleased( portId, mouse ) //emit signal
            mouse.accepted      = true
        }
    }

    function setState( newState ) {
        portId.state = newState
    }

    function getState(){
        return portId.state
    }
    
    function getHotSpot()
    {
        return Qt.point( width / 2, height / 2 )
    }

    function getPortControl()
    {
        return portControl
    }

    function positionToGlobal( position )
    {
        return mouseArea.mapToGlobal( position.x, position.y )
    }


    states: [
        State {
            name: ""
            PropertyChanges { target: portId; color: FlowConfig.disabledColor }
        },
        State {
            name: "Pressed"
            PropertyChanges { target: portId; color: FlowConfig.pressedColor }
        },
        State {
            name: "Connected"
            PropertyChanges { target: portId; color: FlowConfig.connectedColor }
        },
        State {
            name: "Enabled"
            PropertyChanges { target: portId; color: FlowConfig.enabledColor }
        },
        State {
            name: "Disabled"
            PropertyChanges { target: portId; color: FlowConfig.disabledColor }
        },
        State {
            name: "AcceptConnection"
            PropertyChanges { target: portId; color: FlowConfig.acceptConnectionColor }
        }
    ]

}
