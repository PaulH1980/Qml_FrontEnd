import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "."

PropertyGridItemBase 
{
    id								: textInputId
    mPropHeight						: 64

    function updateItem()
    {
        textFieldId.text = propertyDataJson.Value
    }

    function getTextValue()
    {
        return propertyDataJson.Value;
    }

    function setTextValue( val )
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

        Item
        {
            Layout.minimumHeight           : 24
            Layout.maximumHeight           : 24
            Layout.leftMargin              : 56
            Layout.rightMargin             : 56
            Layout.fillWidth               : true

            DefaultTextField
            {
                id						      : textFieldId
                anchors.fill                  : parent
                text 					      : getTextValue()
                onEditingFinished:
                {
                    setTextValue( text );
                    updateAndEmitJson();
                }
            }
        }


    }
}
