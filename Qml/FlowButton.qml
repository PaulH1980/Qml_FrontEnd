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
    id                    : control
    
    property alias button : button
    height                : button.height
    implicitHeight        : button.height

    RowLayout
    {
        anchors.fill            : parent
        Item
        {
            id                   : filler
            Layout.fillWidth     : true           
        }
        
        Button
        {
            id                 : button
            highlighted        : true
            text               : qsTr("Button")   
            height             : 32
            implicitHeight     : 32            
            topPadding         : 3
            bottomPadding      : 3
            flat               : false

            contentItem: Text {
                 text           : button.text
                 font.family    : Style.defaultFont
                 font.pointSize : 14
                 color          : Style.defaultFontColor
                 opacity        : enabled ? 1.0 : 0.3
                 horizontalAlignment    : Text.AlignHCenter
                 verticalAlignment      : Text.AlignVCenter
                 elide                  : Text.ElideRight
            }  
        }
    }
}
   
    


