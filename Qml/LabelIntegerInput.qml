import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

Item
{
    signal  intValueChanged( var newValue )

    property alias text           : label.text
    property alias showLabel      : label.visible
    property alias labelAlignment : label.horizontalAlignment
    property alias inputValue     : input.currentValue
    property alias allowEmptyText : input.allowEmptyText
    property alias isRanged       : input.isRanged  
    property alias min            : input.min
    property alias max            : input.max


    property int   preferredLabelWidth : 16 

    id                            : control
    height                        : 24

    function setValue( val )
    {
        input.setValue( val )
    }

    function getValue()
    {
        return input.getValue()
    }
    
    function emitChangedSignal()
    {
        intValueChanged( getValue() )
    }


    RowLayout
    {
        anchors.fill  : parent
        
        DefaultLabel
        {
            Layout.preferredWidth  : control.preferredLabelWidth   
            Layout.minimumWidth    : control.preferredLabelWidth
            id                     : label
            horizontalAlignment    : Text.AlignRight
            verticalAlignment      : Text.AlignVCenter
            visible                : true
        }

        IntegerInput
        {
            Layout.fillWidth               : true
            id 						       : input
            onValueChanged:
            {
                emitChangedSignal()
            }
        }
    }
}
