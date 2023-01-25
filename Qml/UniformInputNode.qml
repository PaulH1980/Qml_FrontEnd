import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import FlowEventTypes 1.0 // event types enumerations
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

ShaderBlockNodeBase
{
   id                            : control
   property var newUniformButton : null
   property var descriptorData   : null //this can come from a descriptor
   property bool sealed          : false
   property bool isUbo           : false 
   property int  bindLocation    : -1  
   
   Component.onCompleted:
   {
        setTitle        ( "Uniform Input" )
        setTitleBackgroundColor( "blue" )
        setWidth( 240 )
        if( AppScripts.isDefined( descriptorData ) )
            setFromDescriptor()
        else
            addDefaultButton();
        fitItemToContents()
   }

   function setFromDescriptor()
   {
      
   }


   function addDefaultButton( )
   {
       var itemArgs = {               
            "button.text"             : "Add Uniform"   , 
            "anchors.left"            : flowContentItem.left,
            "anchors.right"           : flowContentItem.right,
            "anchors.leftMargin"      : 8,
            "anchors.rightMargin"     : 8
        }; 
        newUniformButton = addItemToLayout( "FlowButton.qml", itemArgs )          
        newUniformButton.button.clicked.connect( addNewUniform )
   }

   function addNewUniform()
   {
       var itemArgs = {
            "anchors.left"          : flowContentItem.left,
            "anchors.right"         : flowContentItem.right,
            "anchors.leftMargin"    : 8,
            "anchors.rightMargin"   : 4,
            "outputPort.enabled"    : true
       };        
       var newItem = addItemToLayout( "UniformType.qml", itemArgs )    
       newItem.removeUniformClicked.connect( removeUniform )
       connectOutputPort( newItem.outputPort )
       //move button down
       nodeContent = AppScripts.moveItemToEnd( newUniformButton, nodeContent )
       fitItemToContents()
   }

   /*
        @brief: Remove uniform from node
   */
   function removeUniform( item )
   {
      removeItem( item )
   }  
   
}