import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3


import "."
PropertyGridItemBase
{
    id                      : vec2Input
    mPropHeight			    : 96
    property bool isInteger : false

    function updateItem()
    {
        xInput.inputValue = propertyDataJson.Value.X
        yInput.inputValue = propertyDataJson.Value.Y
    }

    function getValue()
    {
        var x = propertyDataJson.Value.X;
        var y = propertyDataJson.Value.Y;
        var vec2 = Qt.vector2d( x, y );
        return vec2;
    }


    function setValue( val )
    {
        propertyDataJson.Value.X = val.x;
        propertyDataJson.Value.Y = val.y;
    }

    function getXY()
    {
        var vec2 = Qt.vector2d( xInput.getValue(), yInput.getValue() )
        var isSame = vec2.fuzzyEquals( vec2Input.getValue() )
        if( !isSame ) {
            setValue( vec2 );
        }
    }

    function updateAndEmitJson()
    {
        jsonObjectChanged(  propertyDataJson )   //emit signal
        propertyChanged( propertyDataJson.Value ) //emit property changed signal
    }


    ColumnLayout {
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
            inputValue                       : vec2Input.getValue().x
            id                               : xInput
            
            onIntValueChanged:
            {
                getXY()
                updateAndEmitJson();
            }
        }

        LabelIntegerInput
        {
            Layout.leftMargin                : 32
            Layout.rightMargin               : 56
            Layout.fillWidth                 : true
            text                             : getYLabel()
            inputValue                       : vec2Input.getValue().y
            id                               : yInput
            onIntValueChanged:
            {
                getXY()
                updateAndEmitJson();
            }
        }
    }
}
