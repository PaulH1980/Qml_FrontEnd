import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "."

Item
{
    id						       : titleId
    height                         : 24
    Text
    {
        id						  	: textId
        anchors.verticalCenter		: parent.verticalCenter
        anchors.left                : parent.left
        anchors.right               : parent.right

        text					  	: mDescription
        font.pixelSize			  	: mPropValueFontSize
        font.family				  	: Style.defaultFont
        font.bold                   : true
        color					  	: "White"
        horizontalAlignment			: Text.AlignLeft
        smooth						: true
        antialiasing				: true
    }
}
