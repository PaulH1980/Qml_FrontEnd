import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowInputNodeBase
{

    id                           : constValueNode
    property var constantValue   : undefined
    property var previewItem     : null

    Component.onCompleted:
    {
        
    }

    onConstantValueChanged:
    {
        
    }

    function hasProperties()
    {
        return true
    }

    function getProperties()
    {
        return constantValue
    }
   
}
