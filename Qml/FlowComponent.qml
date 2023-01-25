import QtQuick 2.7
import "."

Item
{
    id      : control
    property var infoRow : null
    MouseArea {
        id : mouseArea
        anchors.fill: control
        onClicked: infoRow.expanded = !infoRow.expanded
        enabled: childCount > 0  ? true : false
    }

    Rectangle {
        id: carot
        color : index == 0 ? "green" : "blue"
        width : 16
        height : 16

        anchors {
            top: control.top
            left: control.left
            margins: 5
        }
        visible: childCount > 0 ? true : false
    }

    Text {
        anchors {
            left: carot.visible ? carot.right : parent.left
            top: control.top
            margins: 5
        }
        id      : textItem
        visible : infoRow.visible
    }

    Component.onCompleted:
    {
        console.log( infoRow )
    }
}
