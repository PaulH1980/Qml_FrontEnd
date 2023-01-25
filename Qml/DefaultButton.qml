import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import FlowEventTypes 1.0 // event types enumerations
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."


Item
{
    signal buttonClicked();
    id                          : control    
    height                      : defaultButton.height

    property alias highlighted  : defaultButton.highlighted
    property alias text         : defaultButton.text 
    
    
    Button 
    {
       id               : defaultButton  
       anchors.fill     : control  
       Material.accent  : Material.Grey
       highlighted      : true

     


       onClicked        : 
       { 
           buttonClicked()  
       }
    }

    DropShadow 
    {
        anchors.fill: control
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "#80000000"
        source: defaultButton
    }
}
