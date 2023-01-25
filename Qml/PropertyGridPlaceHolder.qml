import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "."

PropertyGridItemBase 
{
    id								: textInputId

    function updateItem()
    {

    }

    function getTextValue()
    {

    }
    function setTextValue( val )
    {
        
    }

    RowLayout
    {
        anchors.fill	: parent
        anchors.margins : 2
        spacing			: 2

        Rectangle
        {
            Layout.fillHeight		: true
            Layout.minimumWidth	 	: Style.rightSidePanelTitleWidth
            Layout.maximumWidth	 	: Style.rightSidePanelTitleWidth
            Layout.preferredWidth	: Style.rightSidePanelTitleWidth
            id						: titleId
            color					: Style.defaultBackGroundColor
            Text
            {
                id						  	: textId
                width						: parent.width
                text					  	: mDescription
                font.pixelSize			  	: Style.defaultFontSize
                font.family				  	: Style.defaultFont
                color					  	: "White"
                horizontalAlignment			: Text.AlignLeft
                anchors.centerIn			: parent
                smooth						: true
                antialiasing				: true

            }
        }

        Rectangle
        {
            Layout.fillWidth	 	: true
            Layout.fillHeight		: true
            Layout.minimumWidth	 	: 128
            color					: "Purple"
        }
    }
}
