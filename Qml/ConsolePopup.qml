import QtQuick 2.7
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import "."

Popup 
{
    id				: consolePopup
    width			: root.width
    height			: root.height / 2
    x				: 0
    y				: 0
    modal			: true
    focus			: true
    closePolicy		: Popup.CloseOnEscape

    contentItem : Console
    {
        anchors.fill : parent
        id			 : userConsole
    }
    onClosed:
    {
        userConsole.close()
    }
    onOpened:
    {
        userConsole.open()
    }
}
