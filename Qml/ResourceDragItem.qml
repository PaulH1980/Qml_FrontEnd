import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Qt.labs.folderlistmodel 2.12
import "."

Item
{
    id                          : control    
    property var imgSource      : null
    property var parentItem     : null
    property var droppedTarget  : null;
    property bool dragActive    : false

    /*
        @brief : Drag and Drop support
    */
    Drag.active                 : control.dragActive
    Drag.dragType               : Drag.Automatic
    Drag.supportedActions       : Qt.CopyAction
    Drag.mimeData: {
            "text/plain": "Copied text"
    }  

    Drag.onActiveChanged: {
    
    }

    Drag.onDragStarted: {
    
    }

    Drag.onDragFinished: {

    }

    Drag.hotSpot.x: control.width / 2
    Drag.hotSpot.y: control.height / 2

}