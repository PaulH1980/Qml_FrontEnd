import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."
Item
{
    id           : mainPanel
  
    StackLayout
    {
        width           : parent.width
        anchors.top     : parent.top
        anchors.bottom  : resourceBrowser.top
        visible         : true
        currentIndex    : root.defaultTab
        id              : stackLayoutId
        Item
        {
            id: sceneViewTab          
            SceneRenderItem   
            {
                anchors.fill : parent
            }
        }
        Item
        {
            id: flowEditorTab          

            FlowWidgetMain
            {
                anchors.fill : parent
            }
        }           
    }
    
    Connections
    {
        target              : root
        onMainViewTabChanged:
        {
           stackLayoutId.currentIndex = index
        }       
    }  
    
    ResourceBrowser
    {
        id               : resourceBrowser
        objectName       : "resourceBrowser"
        anchors.bottom   : parent.bottom
        anchors.left     : parent.left
        anchors.right    : parent.right
        onFileActivated: 
        {
           // flowRenderControl.spawnImageItem( fileName )
        }
    }
}