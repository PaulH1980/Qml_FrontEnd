import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import FlowShaderRenderer 1.0
import "."


RectContainer
{
    anchors.fill : parent
    anchors.margins : 3
    id           : control


    RectContainer
    {
        id    : previewItemContainer
        width : parent.width
        height: parent.width

        FlowShaderRenderItem
        {
            id : previewItem
            anchors.fill : parent
            anchors.margins : 3
        }
    }
    RectContainer
    {
        anchors.top     : previewItemContainer.bottom
        anchors.bottom  : control.bottom
        width           : parent.width
        FlowSelectionWidget
        {
            anchors.fill    : parent
            id              : tree
            anchors.margins : 3
        }
    }

    Connections
    {
        target : root
        onFlowGlslCodeGenerated:
        {
            previewItem.setFragmentShader( code ) //call c++
        }
    }
}




