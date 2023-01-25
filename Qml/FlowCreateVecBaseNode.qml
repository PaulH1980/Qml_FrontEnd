import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowNodeBase
{
    property var vecType      : undefined

    onInPortConnectionRemoved:
    {
        setOutputPortsToType(  FlowConfig.noneMask )
        var conCount = getConnectedInputCount()
        if( conCount === 0 )
            reset()
    }



    function reset()
    {
        setTitlePostFix( "" )
        setInputPortsToType( [FlowConfig.vec1fMask, FlowConfig.vec1iMask] )
    }
}
