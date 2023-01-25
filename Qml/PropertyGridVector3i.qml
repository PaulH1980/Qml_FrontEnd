import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "."
PropertyGridItemBase
{
    id                              : vec3Input
    mPropHeight						: 128
    
    function updateItem()
    {
        xInput.inputValue = propertyDataJson.Value.X
        yInput.inputValue = propertyDataJson.Value.Y
        zInput.inputValue = propertyDataJson.Value.Z
    }

    function getValue()
    {
        var x = propertyDataJson.Value.X;
        var y = propertyDataJson.Value.Y;
        var z = propertyDataJson.Value.Z;
        var vec3 = Qt.vector3d( x, y, z );

        return vec3;
    }


    function setValue( val )
    {
        propertyDataJson.Value.X = val.x;
        propertyDataJson.Value.Y = val.y;
        propertyDataJson.Value.Z = val.z;
    }

    function getXYZ()
    {
        var vec3 = Qt.vector3d( xInput.getValue(), yInput.getValue(), zInput.getValue() )
        var isSame = vec3.fuzzyEquals( vec3Input.getValue() )
        if( !isSame )
        {
            setValue( vec3 );
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

        LabelIntegerInput
        {
            Layout.leftMargin                : 32
            Layout.rightMargin               : 56
            Layout.fillWidth                 : true
            text                             : getXLabel()
            inputValue                       : vec3Input.getValue().x
            id                               : xInput
            
            onIntValueChanged:
            {
                getXYZ()
                updateAndEmitJson();
            }
        }

        LabelIntegerInput
        {
            Layout.leftMargin                : 32
            Layout.rightMargin               : 56
            Layout.fillWidth                 : true
            text                             : getYLabel()
            inputValue                       : vec3Input.getValue().y
            id                               : yInput
            onIntValueChanged:
            {
                getXYZ()
                updateAndEmitJson();
            }
        }

        LabelIntegerInput
        {
            Layout.leftMargin                : 32
            Layout.rightMargin               : 56
            Layout.fillWidth                 : true
            text                             : getZLabel()
            inputValue                       : vec3Input.getValue().z
            id                               : zInput


            onIntValueChanged:
            {
                getXYZ()
                updateAndEmitJson();
            }
        }

    }


}
