import QtQuick 2.7
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "."

PropertyGridItemBase
{
    id								: colorInputId
    mPropHeight                     : 288

    function updateItem()
    {
        var rgba = getColorValue();
        colorControl.updateRgba( rgba.r, rgba.g, rgba.b, rgba.a )           
    }

    function getColorValue()
    {
        if( propertyDataJson.Value === undefined )
            return;

        var r = propertyDataJson.Value.X
        var g = propertyDataJson.Value.Y
        var b = propertyDataJson.Value.Z
        var a = propertyDataJson.Value.W
        var rgba = Qt.rgba(r, g, b, a)

        return rgba
    }

    function setColorValue( val )
    {
        if( propertyDataJson.Value === undefined )
            return;
        propertyDataJson.Value.X  = val.r
        propertyDataJson.Value.Y  = val.g
        propertyDataJson.Value.Z  = val.b
        propertyDataJson.Value.W  = val.a    
    }


    function setFromRGB(  )
    {
        var rgba    = getColorValue();
        colorControl.updateRgba( rgba.r, rgba.g, rgba.b, rgba.a )
    }


    function updateAndEmitJson()
    {
        jsonObjectChanged(  propertyDataJson )   //emit signal
        propertyChanged(  propertyDataJson.Value ) //emit property changed signal
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
            Layout.leftMargin               : 32
            Layout.fillWidth                : true
        }

        ColorWidget
        {
            Layout.fillWidth                : true
            Layout.fillHeight               : true
            id                              : colorControl
            onColorChanged:
            {
                  setColorValue( newColor  )
                  updateAndEmitJson()
            }
        }
    }

}
