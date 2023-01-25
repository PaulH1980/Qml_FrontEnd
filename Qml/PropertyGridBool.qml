import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

PropertyGridItemBase 
{

    id                              : control
    anchors.left					: parent.left
    mPropHeight						: 64

    property int dimensions 		: 20
    
    function updateItem()
    {
        checkBoxId.checked = control.getValue()
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
            Layout.leftMargin               : 32
            Layout.fillWidth                : true
        }

        Item
        {
            Layout.minimumHeight           : 24
            Layout.maximumHeight           : 24
            Layout.leftMargin              : 56
            Layout.rightMargin             : 56
            Layout.fillWidth               : true
            CheckBox
            {
                id                 : checkBoxId
                checked            : control.getValue()
                anchors.left	   : parent.left
                topPadding         : 0
                bottomPadding      : 0

                onClicked:
                {
                    control.setValue( !control.getValue() );
                    updateAndEmitJson();
                }
            }
        }
    }
}
