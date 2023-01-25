import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

Item
{
    height                      : 24
    implicitHeight              : 24
    property int  controlHeight : 24
    id                          : control
    property alias text         : filePreviewField.text
    
    RowLayout
    {
        anchors.fill          : parent

        DefaultLabel
        {
            Layout.preferredWidth      : 32
            Layout.maximumWidth        : 32
            text                       : "File"
        }

        DefaultTextField
        {
            Layout.fillWidth           : true
            Layout.minimumHeight       : controlHeight
            Layout.maximumHeight       : controlHeight
            Layout.preferredHeight     : controlHeight
            height                     : controlHeight
            implicitHeight             : controlHeight
            id                         : filePreviewField
            readOnly                   : true
            hoverEnabled               : true

            ToolTip.delay             : 500
            ToolTip.visible           : hovered
            ToolTip.text              : "c://test_file.txt"


        }

        DefaultButton2
        {
            Layout.preferredWidth    : 48
            Layout.maximumWidth      : 48
            Layout.preferredHeight   : controlHeight
            Layout.minimumHeight     : controlHeight
            Layout.maximumHeight     : controlHeight
            implicitHeight           : controlHeight
            height                   : controlHeight
            id                       : chooseFileButton
            text                     : "Choose"
        }
    }
}
