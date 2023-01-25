import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "Scripts/AppScripts.js" as AppScripts
import "."


PropertyGridItemBase 
{
    id								: control
    mPropHeight						: 64
    property int sliderHeight       : 24
    property int sharedValue        : 22
    property int minValue           : 1
    property int maxValue           : 200

    function updateItem() //virtual
    {
      control.minValue    = propertyDataJson.Value.Min
      control.maxValue    = propertyDataJson.Value.Max
      control.sharedValue = propertyDataJson.Value.Value
    }

    function getValue()
    {
        return propertyDataJson.Value;
    }

    function setValue( val )
    {
        propertyDataJson.Value.Value = val;
    }

    function updateAndEmitJson()
    {
        jsonObjectChanged(  propertyDataJson )    //emit signal
        propertyChanged( propertyDataJson.Value ) //emit property changed signal
    }

    onSharedValueChanged:
    {
        setValue( sharedValue )
        updateAndEmitJson()
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

        RowLayout
        {
            Layout.minimumHeight           : sliderHeight
            Layout.maximumHeight           : sliderHeight
            Layout.leftMargin              : 32
            Layout.rightMargin             : 56
            Layout.fillWidth               : true

            DefaultLabel
            {
                text: ""
                Layout.preferredWidth      : 32
                horizontalAlignment        : Text.AlignRight
            }

            Slider
            {
                Layout.fillWidth           : true
                height                     : sliderHeight
                implicitHeight             : sliderHeight
                from                       : control.minValue
                to                         : control.maxValue
                value                      : control.sharedValue
                id						   : sliderId                 
                
                onValueChanged :
                {
                    control.sharedValue = value
                    intInput.currentValue = value;
                }
            }

            IntegerInput
            {
                Layout.preferredWidth    : 48
                id                       : intInput
                min                      : control.minValue
                max                      : control.maxValue
                currentValue             : control.sharedValue
                defaultValue             : control.minValue
                isRanged                 : true
                allowEmptyText           : true
                onCurrentValueChanged :
                {
                    control.sharedValue = currentValue        
                }
            }
        }
    }
}