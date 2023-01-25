import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import FlowEventTypes 1.0 // event types enumerations
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

FlowOutputNodeBase
{
   id                      : control
   objectName              : "TechniqueNode"
   property var lastPort   : null
   property var newPassButton : null
   Component.onCompleted:
   {
      setTitle("Technique")
      setTitleBackgroundColor( "blue" )
      setWidth( 192 )
      addDefaultButton();
      fitItemToContents()
   }   

   function addDefaultButton( )
   {
       var itemArgs = {               
            "button.text"             : "Add Render Pass"   , 
            "anchors.left"            : flowContentItem.left,
            "anchors.right"           : flowContentItem.right,
            "anchors.leftMargin"      : 8,
            "anchors.rightMargin"     : 8
        }; 
        newPassButton = addItemToLayout( "FlowButton.qml", itemArgs )          
        newPassButton.button.clicked.connect( addNewPass )
   }
   
   function addNewPass( arg  )
   {
      addInputItem    ( "RenderPass"   ,  ["RenderPass"] )
      nodeContent  = AppScripts.moveItemToEnd( newPassButton, nodeContent )
      fitItemToContents()
   }
   
}