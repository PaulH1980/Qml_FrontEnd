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
    signal removeAttributeClicked( var id )
    signal semanticNameChanged( var id, var name )
    signal semanticTypeChanged( var id, var type )

    height                          : 24
    id                              : control  
  
    property alias outputPort       : portOut
    property alias removeButton     : button
    property alias semanticTypeDD   : semTypeDD
    property alias semanticNameDD   : semNameDD

    Component.onCompleted:
    {
        fillSemanticNameCombo( semanticNameDD )
        fillSemanticTypeCombo( semanticTypeDD )
    }
    
    RowLayout
    {
       anchors.fill : parent
       ToolBarButton
       {
          id                        : button
          iconSize                  : 16
          iconName                  : FontAwesome.remove
          Layout.preferredHeight    : 24
          Layout.preferredWidth     : 24
          ToolTip.text              : "Remove Vertex Attribute"
          onClicked :
          {
              removeAttributeClicked( control )
          }
       }
       ComboBoxInput
       {
            id                    : semTypeDD
            Layout.preferredHeight: 24
            Layout.preferredWidth : 56
            textSize              : 16
            onSelectionChanged:{
                _semanticTypeChanged( sender, selection )
            }

       }
       ComboBoxInput
       {
            id                  : semNameDD
            Layout.fillWidth    : true
            Layout.preferredHeight: 24
            Layout.preferredWidth : 56
            textSize              : 16
            onSelectionChanged:{
                _semanticNameChanged( sender, selection )
            }
       }
       FlowPortBaseOut
       {
          id                    : portOut
          portLabel.visible     : false
          Layout.preferredWidth : 24
       }
    }

    /*
        Brief: signal only if single selection and type has changed
    */
    function _semanticTypeChanged( item, selection )
    {
         console.assert( selection.length == 1,  "Invalid Selection Count" )
         var newType= selection[0].Name    
         outputPort.outputType          = newType
         outputPort.defaultOutputType   = newType
         semanticTypeChanged( control, newType )
    }

    /*
        @brief: Signal only if single selection and name has changed
    */
    function _semanticNameChanged( item, selection )
    {
         console.assert( selection.length == 1,  "Invalid Selection Count" )
         var newName = selection[0].Name
         outputPort.text = newName
         semanticNameChanged( control, newName )            
    }

    function fillSemanticNameCombo( dropDown )
    {
       var comboSelection = [];
       var selectedItem   = "position" //select 'position' by default
       var arrIter = AppGlobal.vertexFormats.SupportedFormats
       for( var i in arrIter )
       {
          var item = arrIter[i]
          var selItem ={
            "Name"      : item.Name,
            "Selected"  : selectedItem == item.Name,
            "Index"     : i,
            "Value"     : i 
          }
          comboSelection.push( selItem )
       }
       dropDown.comboBoxItems = comboSelection
       _semanticNameChanged( dropDown, dropDown.getSelectedItems() ) 
    }       

    function fillSemanticTypeCombo( dropDown )
    {
       console.assert( dropDown instanceof ComboBoxInput, "Not A DropDown" )       
       var comboSelection = [];
       var selectedItem   = "vec3" //select 'vec3' by default
       var arrIter = AppGlobal.uniformFormats.SupportedFormats
       for( var i in arrIter )
       {
          var item = arrIter[i]
          var itemName = AppGlobal.shaderKeyWordFromEventId( item )
          var selItem = {
            "Name"      : itemName,
            "Selected"  : selectedItem === itemName,
            "Index"     : i,
            "Value"     : i 
          }
          comboSelection.push( selItem )
       }
       dropDown.comboBoxItems = comboSelection;
       _semanticTypeChanged( dropDown, dropDown.getSelectedItems() )
    }
}