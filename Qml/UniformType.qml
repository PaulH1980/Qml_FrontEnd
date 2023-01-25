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
    signal removeUniformClicked ( var id )
    signal uniformTypeChanged   ( var id, var newType )

    height  : 24
    id      : control

   
    Component.onCompleted:
    {
        fillComboBox( uniformTypesDD )
    }

    property alias outputPort       : portOut
    property alias removeButton     : button
    property alias uniformTypesDD   : uniformDD
    property alias uniformNameTF    : nameTF
    
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
          ToolTip.text              : "Remove Uniform"
          onClicked :
          {
                removeUniformClicked( control )
          }
       }
       ComboBoxInput
       {
            id                    : uniformDD
            Layout.preferredHeight: 24
            Layout.preferredWidth : 56
            textSize              : 16
            onSelectionChanged: 
            {
                
            }
       }
       DefaultTextField
       {
            id              : nameTF
            Layout.fillWidth: true
            placeholderText : "Hello World"
       }
       FlowPortBaseOut
       {
          id                    : portOut
          portLabel.visible     : false
          Layout.preferredWidth : 24
       }
    }

    function _uniformTypeChanged( item, selection )
    {
         console.assert( selection.length == 1,  "Invalid Selection Count" )
         var newType = selection[0].Name
         outputPort.outputType          = newType
         outputPort.defaultOutputType   = newType
         uniformTypeChanged( control, newType )
    }

    function fillComboBox( dropDown )
    {
       console.assert( dropDown instanceof ComboBoxInput, "Not A DropDown" )
       
       //convert selection items to compatible combobox format
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
    }
}