import QtQuick 2.7
import QtQuick.Controls 2.4
import "."

Button
{
    id              : control
    implicitHeight  : 24
    height          : 24
    width           : 48
    padding         : 0

    contentItem : DefaultLabel
    {
        text                : control.text
        verticalAlignment   : Text.AlignVCenter
        anchors.fill        : parent
        Component.onCompleted:
        {
            
        }
    }
}
