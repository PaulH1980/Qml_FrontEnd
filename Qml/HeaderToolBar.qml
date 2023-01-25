import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "."
 
 ToolBar 
 {
       id : toolBar      
        
       RowLayout {
                anchors.fill: parent
                ToolButton {
                    text: qsTr("Hello World")
                    onClicked: stack.pop()
                }
                ToolSeparator
                {
                
                }
                ToolButton {
                    text: qsTr("Hello World2")
                    onClicked: menu.open()
                }                
                Item {
                    Layout.fillWidth: true
                }
            }
    }

