import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."
ToolBar 
{
    id : sceneToolBar
    RowLayout
    {
        anchors.fill: parent
        spacing: 8
        ToolBarButton
        {
            Layout.minimumWidth		: 40
            Layout.preferredWidth	: 40
        }
        ToolBarButton
        {
            Layout.minimumWidth		: 40
            Layout.preferredWidth	: 40
        }
        ToolBarButton
        {
            Layout.minimumWidth		: 40
            Layout.preferredWidth	: 40
        }

        Item { Layout.fillWidth: true ; height: 1 }
    }
}
