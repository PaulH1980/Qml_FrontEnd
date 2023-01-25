import QtQuick 2.7
import QtQuick.Controls 2.2

Column {
    width: parent.width
    height: parent.height

    property alias model: columnRepeater.model

    ListView {
        id: columnRepeater
        delegate: accordion

        width: parent.width
        height: parent.height
        clip: true
        model: ListModel { }
        ScrollBar.vertical: ScrollBar { }
    }

    Component {
        id: accordion
        Column {
            width: parent.width

            Item {

                id      : infoRow
                width   : parent.width
                height  : childrenRect.height

                property int parentIndex : index
                property bool expanded   : false

                MouseArea {
                    anchors.fill: parent
                    onClicked: infoRow.expanded = !infoRow.expanded
                    enabled: childrens ? true : false
                }

                Rectangle {
                    id: carot
                    color : index == 0 ? "green" : "blue"
                    width : 16
                    height : 64

                    anchors {
                        top: parent.top
                        left: parent.left
                        margins: 5
                    }
                    visible: childrens.count > 0 ? true : false
                    
                }

                Text {
                    anchors {
                        left: carot.visible ? carot.right : parent.left
                        top: parent.top
                        margins: 5
                    }

                    visible: parent.visible
                    text: label
                }

                Text {
                    visible: infoRow.visible

                    text: type

                    anchors {
                        top: parent.top
                        right: parent.right
                        margins: 5
                        rightMargin: 15
                    }
                }

                Component.onCompleted:
                {
                    //console.log("child " + parentIndex )
                }
            }

            ListView {
                id: subentryColumn
                x: 20
                width: parent.width - x
                height: childrenRect.height * opacity
                visible: opacity > 0
                opacity: infoRow.expanded ? 1 : 0
                delegate: accordion
                model: childrens ? childrens : []
                interactive: false
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }
    }
}
