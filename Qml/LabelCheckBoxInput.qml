import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

import "."

Item
{
    signal         boolValueChanged( var newValue )

    property alias labelName            : label.text
    property alias showLabel            : label.visible
    property alias inputValue           : input.checked 
    property int   labelAlignment       : Text.AlignRight
    property int   leftMargin           : 0
    property int   rightMargin          : 0
    property int   preferredLabelWidth  : 16

    id                                  : control
    height                              : 24

    function setValue( val )
    {
        input.checked = val
    }

    function getValue()
    {
        return input.checked
    }
    
    function emitChangedSignal()
    {
        boolValueChanged( getValue() )
    }


    RowLayout
    {
        anchors.fill                : parent
        anchors.leftMargin          : leftMargin
        anchors.rightMargin         : rightMargin
        
        DefaultLabel
        {
            Layout.preferredWidth  : control.preferredLabelWidth
            Layout.minimumWidth    : control.preferredLabelWidth
            Layout.preferredHeight : control.height
            id                     : label
            horizontalAlignment    : labelAlignment
            verticalAlignment      : Text.AlignVCenter
            visible                : true        
        }

        CheckBox
        {
            Layout.fillWidth               : true
            Layout.preferredHeight         : control.height           
            id 						       : input     

            indicator.width                : 20
            indicator.height               : 20
            indicator.implicitWidth        : 20
            indicator.implicitHeight       : 20
            indicator.x                    : 0
            indicator.y                    : 0         

            contentItem.width              : 0
            contentItem.height             : 0 

            onCheckedChanged:
            {
                boolValueChanged( checked )
            }
        }
    }
}