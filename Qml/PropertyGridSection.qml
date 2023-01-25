import QtQuick 2.7
import QtQuick.Controls 2.4

import "."

Rectangle {
    signal                  sectionPressed( string objName, bool expanded )
    signal                  onSectionExpanded( bool expanded )
    property bool expanded  : true
    property int  textSize  : 20
    property int  nestedDepth : 0
    property alias sectionText : sectionName.text

   

    color					: Qt.rgba(  82/255,   82/255, 82/255, 1)
    border.color			: Qt.rgba( 	64/255,   64/255, 64/255, 1)
    border.width			: 1
    smooth					: true
    antialiasing			: true
    height					: 32
    id						: propSection

    Text
    {
        width					: textSize
        height					: textSize
        id						: idCaret
        font.family				: FontAwesome.fontFamily
        text					: FontAwesome.caretRight
        font.pointSize			: textSize - 4
        color					: "White"
        anchors.verticalCenter  : propSection.verticalCenter
        anchors.left 			: propSection.left
        anchors.leftMargin 		: 8
        MouseArea
        {
            anchors.fill		: parent
            cursorShape			: Qt.PointingHandCursor
            acceptedButtons 	: Qt.LeftButton
            onClicked:
            {
                expanded = !expanded
                propSection.sectionPressed( sectionText, expanded )    
            }
        }
    }

    Text
    {
        id                      : sectionName
        text					: "PlaceHolder"
        font.pixelSize			: textSize
        font.family				: "Helvetica"
        font.bold               : true
        color					: "White"
        anchors.verticalCenter	: propSection.verticalCenter
        anchors.left            : idCaret.right
    }

    onExpandedChanged:
    {
        idCaret.text = expanded ? FontAwesome.caretRight : FontAwesome.caretDown
    }

}
