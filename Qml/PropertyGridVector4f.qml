import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "."

PropertyGridItemBase
{
    mPropHeight						: 64
    id                              : vec4Input
    property bool isInteger         : false

    function updateItem()
    {
        xInput.inputValue = propertyDataJson.Value.X
        yInput.inputValue = propertyDataJson.Value.Y
        zInput.inputValue = propertyDataJson.Value.Z
        wInput.inputValue = propertyDataJson.Value.W
    }


    function getValue()
    {
        var x = propertyDataJson.Value.X;
        var y = propertyDataJson.Value.Y;
        var z = propertyDataJson.Value.Z;
        var w = propertyDataJson.Value.W;
        var vec4 = Qt.vector4d( x, y, z, w );
        return vec4;
    }


    function setValue( val )
    {
        propertyDataJson.Value.X = val.x;
        propertyDataJson.Value.Y = val.y;
        propertyDataJson.Value.Z = val.z;
        propertyDataJson.Value.W = val.w;
    }



    function getXYZW()
    {
        var vec4 = Qt.vector4d( xInput.getValue(), yInput.getValue(), zInput.getValue(), wInput.getValue() )
        var isSame = vec4.fuzzyEquals( vec4Input.getValue())
        if( !isSame )
        {
            setValue( vec4 )
        }
    }


    function updateAndEmitJson()
    {
        jsonObjectChanged(  propertyDataJson )   //emit signal
              propertyChanged( propertyDataJson.Value ) //emit property changed signal
  
    }

    ColumnLayout
    {
        anchors.fill         : parent
        anchors.topMargin    : 2
        anchors.bottomMargin : 2
        spacing              : 4
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

        RowLayout
        {
            Layout.leftMargin                : 32
            Layout.rightMargin               : 56
            Layout.fillWidth                 : true   

            LabelFloatInput
            {
               
                Layout.fillWidth                 : true
                text                             : getXLabel()
                inputValue                       : vec4Input.getValue().x
                id                               : xInput
            
                onFloatValueChanged:
                {
                    getXYZW()
                    updateAndEmitJson();
                }
            }

            LabelFloatInput
            {
               
                Layout.fillWidth                 : true
                text                             : getYLabel()
                inputValue                       : vec4Input.getValue().y
                id                               : yInput
                onFloatValueChanged:
                {
                    getXYZW()
                    updateAndEmitJson();
                }
            }

            LabelFloatInput
            {
             
                Layout.fillWidth                 : true
                text                             : getZLabel()
                inputValue                       : vec4Input.getValue().z
                id                               : zInput
                onFloatValueChanged:
                {
                    getXYZW()
                    updateAndEmitJson();
                }
            }

            LabelFloatInput
            {
              
                Layout.fillWidth                 : true
                text                             : getWLabel()
                inputValue                       : vec4Input.getValue().w
                id                               : wInput
                onFloatValueChanged:
                {
                    getXYZW()
                    updateAndEmitJson();
                }
            }
       }//row layout
    }
}
