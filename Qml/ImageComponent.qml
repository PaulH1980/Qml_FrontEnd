import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Qt.labs.folderlistmodel 2.12
import "."

RectContainer
{
    property alias imgSource : thumbImg.source
    Image
    {
        id              : thumbImg
        anchors.margins : 1
        anchors.fill    : parent
        fillMode        : Image.PreserveAspectFit
        smooth          : true
        asynchronous    : true
    }
    Item
    {
        x               : 4
        y               : 4
        Column
        {
            Text
            {
                font.pixelSize		   : 14
                font.family		       : Style.defaultFont
                color				   : "White"
                text                   : "W:" +  thumbImg.implicitWidth
            }

            Text
            {
                font.pixelSize		   : 14
                font.family		       : Style.defaultFont
                color				   : "White"
                text                   : "H:" + thumbImg.implicitHeight
            }
        }
    }
}

