import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

Item
{
    id                                  : control
    width								: 450

    StackLayout
    {
        anchors.fill    : parent       
        visible         : true
        currentIndex    : root.defaultTab
        id              : stackLayoutId
        Item
        {
            id: scenePropGrid         
            ScenePropertyGrid
            {            
                anchors.fill        : parent               
                Component.onCompleted:
                {
                     setModel( PropertyModel )
                }
            }
        }
        Item
        {
            id: flowPropGrid
            FlowPropertyGrid
            {
                anchors.fill        : parent              
                Component.onCompleted:
                {
                             
                }
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


