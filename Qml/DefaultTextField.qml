import QtQuick 2.7
import QtQuick.Controls 2.4

import "."

TextField
{
    id                     : control
    hoverEnabled           : true
    height                 : 24
    selectByMouse          : true
    focus				   : false
    font.pixelSize		   : 16
    font.family			   : Style.defaultFont
    color				   : "White"
    placeholderText        : qsTr("PlaceHolder")
    topPadding             : 0
    leftPadding            : 4
    bottomPadding          : 0
    enabled                : true

    onEnabledChanged      : state = ""


    property color hoverColor: "#aaaaaa"
    property color focusColor: "#ffffff"

    background: Rectangle {
        id                     : backGroundRect
        anchors.fill           : parent
        implicitHeight         : 24
        color                  : control.enabled ? Qt.rgba(37/255, 37/255, 37/255, 1) : "#353637"
        border.color           : control.enabled ? Qt.rgba(20/255, 20/255, 20/255, 1)  : "transparent"
        radius                 : 3
    }

    onHoveredChanged: {
        if( hovered )
            control.state =  "Hovering"
        else
            control.state = ""
    }

    onFocusChanged: {
        if( focus)
            control.state =  "Focussed"
        else
            control.state =  ""
    }


    states: [
        State {
            name: "Hovering"
            PropertyChanges {
                target: backGroundRect
                border.color: hoverColor
            }
        },
        State {
            name: "Focussed"
            PropertyChanges {
                target: backGroundRect
                border.color: focusColor
            }
        }
    ]

    transitions: [
        Transition {
            from: ""; to: "Hovering"
            ColorAnimation { duration: 200 }
        },
        Transition {
            from: "*"; to: "Focussed"
            ColorAnimation { duration: 10 }
        }
    ]
}



