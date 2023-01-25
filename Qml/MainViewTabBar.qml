import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import "."

Item
{
    readonly property int sceneView     : 0
    readonly property int flowView      : 1
    //gather, enhance, ( flow ), publish

    id 									: mainTabBar   
    height                              : 50

    TabBar
    {
        // position    : TabBar.Header
        anchors.fill : parent
        id           : bar
        currentIndex : root.defaultTab
        visible      : true
        TabButton
        {
            text: "Scene"
            height: parent.height
            width : 150
        }
        TabButton
        {
            text: "Flow"
            height: parent.height
            width : 150
        }
        
        onCurrentIndexChanged:
        {
            switch( currentIndex )
            {
                case sceneView:
                    root.mainViewTabChanged(sceneView);
                    break;
                case flowView:
                    root.mainViewTabChanged(flowView);
                    break;
                default:
                    throw new Error( "Invalid View Activated" );
            }           
        }
    }   
   
}
