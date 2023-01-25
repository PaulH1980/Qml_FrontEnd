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
   id                               : vertexAttNodeId
   property var newAttributeButton  : null
   property var descriptorData      : null //this can come from geometrybuffer data
   
   Component.onCompleted:
   {
        setTitle        ( "Vertex Attributes" )
        setTitleBackgroundColor( "green" )
        setWidth( 240 )
        //Create output ports & disable adding new ports
        if( AppScripts.isDefined( descriptorData ) )
            setFromDescriptor() 
        else //create an empty vertex attribute node
            addCreateNewPortButton()
        fitItemToContents()
   }

   function setFromDescriptor()
   {
        throw new Error( "Not Implemented" )
   }

   function addCreateNewPortButton( )
   {
        var itemArgs = {               
            "button.text"             : "New Attribute"   , 
            "anchors.left"            : flowContentItem.left,
            "anchors.right"           : flowContentItem.right,
            "anchors.leftMargin"      : 8,
            "anchors.rightMargin"     : 8
        }; 
        newAttributeButton = addItemToLayout( "FlowButton.qml", itemArgs )  
        newAttributeButton.button.clicked.connect( addNewVertexAttribute )
   }

   function addNewVertexAttribute( arg )
   {
       var itemArgs = {
            "anchors.left"          : flowContentItem.left,
            "anchors.right"         : flowContentItem.right,
            "anchors.leftMargin"    : 8,
            "anchors.rightMargin"   : 4,
            "outputPort.enabled"    : true
       };        
       var newItem = addItemToLayout( "VertexAttributeType.qml", itemArgs )    
       newItem.removeAttributeClicked.connect( removeAttribute )
       connectOutputPort( newItem.outputPort )
       //move button down
       nodeContent = AppScripts.moveItemToEnd( newAttributeButton, nodeContent )
       fitItemToContents()
   }

   function handleSemanticNameChange( item, newName )
   {
      
   }


   function handleSemanticTypeChange( item, newType )
   {
     
   }
    /*
        @brief: Remove vertex attribute from node
   */
   function removeAttribute( item )
   {
      removeItem( item )
   } 

     
}