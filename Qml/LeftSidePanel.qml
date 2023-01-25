import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import "."

Item
{
    id 									: leftSidePanel
    width								: Style.leftSidePanelWidth

    StackLayout
    {
        anchors.fill        : parent
        visible             : true
        currentIndex        : root.defaultTab
        id                  : stackLayoutId
        RectContainer
        {
            id: sceneTab
            SceneTreeView
            {
                anchors.fill : parent

            }
        }
        RectContainer
        {
            id: flowTab            
            FlowPreviewSelectionItem
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
}
