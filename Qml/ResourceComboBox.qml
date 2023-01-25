import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Item
{
    signal  comboBoxValueChanged( string key, int value )

    
    property alias model : comboBox.model
    property alias text  : label.text
    height               : control.height
    implicitHeight       : control.height
    implicitWidth        : 224
    RowLayout
    {
        anchors.fill : parent

        Label
        {
            id                  : label
            text                : "Icon Size"
            elide               : Label.ElideRight
            horizontalAlignment : Qt.AlignHCenter
            verticalAlignment   : Qt.AlignVCenter
        }
        ComboBox
        {
            id                  : comboBox
            Layout.fillWidth    : true
            textRole: "key"

            model: ListModel
            {
                id : cbModel
                ListElement { key: "PlaceHolder";  value: -1  }
            }
            onCurrentIndexChanged:
            {
                const result = model.get( currentIndex )
                comboBoxValueChanged( result.key, result.value )
            }
        }
    }
}
