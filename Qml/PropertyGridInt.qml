import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

PropertyGridItemBase 
{
    id								: control
    mPropHeight						: 64
    property alias labelText        : inputField.text

    function updateItem()
    {
        inputField.inputValue = propertyDataJson.Value
    }

    function getValue()
    {
        return propertyDataJson.Value;
    }

    function setValue( val )
    {
        propertyDataJson.Value = val;
    }


    function updateAndEmitJson()
    {
        jsonObjectChanged(  propertyDataJson )   //emit signal
        propertyChanged( propertyDataJson.Value ) //emit property changed signal
    }


    ColumnLayout
    {
        anchors.fill         : parent
        anchors.topMargin    : 0
        anchors.bottomMargin : 5
        spacing              : 2

        
        Rectangle
        {
            Layout.minimumHeight           : 1
            Layout.maximumHeight           : 1
            Layout.leftMargin              : 16
            Layout.rightMargin             : 16
            Layout.fillWidth               : true
            color                          : Qt.rgba(80/255, 80/255, 80/255, 1)
        }
        
        PropertyGridName
        {
            Layout.leftMargin       : 32
            Layout.fillWidth        : true
        }
        
        LabelIntegerInput
        {
            Layout.leftMargin                : 32
            Layout.rightMargin               : 56
            Layout.fillWidth                 : true
            text                             : ""
            inputValue                       : control.getValue()
            id                               : inputField
            
            onIntValueChanged:
            {
                control.setValue( inputValue )
                updateAndEmitJson();
            }
        }
    }
}
