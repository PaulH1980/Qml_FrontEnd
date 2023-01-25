import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

ToolBar
{
    position                      : ToolBar.Footer
    id : statusBar

    property string toolText	  : "PlaceHolder"
    property string selModeText   : "PlaceHolder"
    property int statusItemWidth : 250

    RowLayout {

        id                          : rowLayout
        anchors.fill                : parent


        DefaultLabel //Active Tool
        {
            
            Layout.leftMargin       : 32
            Layout.preferredWidth   : statusItemWidth
            text                    : "Tool " + toolText
            font.pixelSize		    : 16
        }

        DefaultLabel //Selection Mode
        {
            Layout.preferredWidth  : statusItemWidth
            text                   : "Selection Mode " + selModeText
            font.pixelSize		    : 16
        }

        ProgressBar {

            id : progressBar
            Layout.preferredWidth       : statusItemWidth
            value                       : 0.5
        }

        Item { Layout.fillWidth: true ; height: 1 }

    }
}
