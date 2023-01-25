import QtQuick 2.7
import "."

Item
{
    signal itemClicked         ( var item, var mouse )
    signal itemDoubleClicked   ( var item, var mouse )


    id                         : infoRow
    width                      : itemColumn.width
    height                     : childrenRect.height
    property int indexOf       : -1
    property var object        : null
    property bool expanded     : false
    property int  textSize     : 20
    property alias text        : textItem.text


    property string type       : ""
    property string icon       : ""

    Text
    {
        property int dimensions : textSize - textSize / 4
        width					: dimensions
        height					: dimensions
        anchors.top             : infoRow.top
        anchors.left            : infoRow.left
        anchors.leftMargin 		: textSize / 2
        anchors.topMargin       : textSize / 4
        id						: idCaret
        font.family				: FontAwesome.fontFamily
        text					: FontAwesome.chevronRight
        font.pointSize			: dimensions
        color					: "White"

        visible                 : childrens.count > 0 ? true : false
        MouseArea
        {
            anchors.fill		: parent
            cursorShape			: Qt.PointingHandCursor
            acceptedButtons 	: Qt.LeftButton
            enabled             : parent.visible
            onClicked:
            {
                infoRow.expanded = !infoRow.expanded
            }
        }
        transform: Rotation
        {
            origin.x: 5
            origin.y: 10
            angle: infoRow.expanded ? 90 : 0
            Behavior on angle { NumberAnimation { duration: 150 } }
        }
    }

    Rectangle
    {
        id                      : textHolder
        visible                 : itemColumn.visible
        color                   : "red"
        height                  : textSize + 4
        anchors {
            left                : idCaret.visible ? idCaret.right : infoRow.left
            right               : infoRow.right
            top                 : infoRow.top
            topMargin           : textSize / 4
            leftMargin          : idCaret.visible ? -2 : textSize / 1.5
        }
        Text 
        {
            anchors.fill            : parent
            id                      : textItem           
            font.pixelSize		    : textSize 
            font.family			    : Style.defaultFont
            font.bold               : type === "section" ? true : false
            color				    : "White"
        } 
    }

}
