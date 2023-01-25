import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowSplitVecBaseNode
{
    id                        : splitVec3
    objectName               : "SplitVec3"

    Component.onCompleted:
    {
        setTitle        ( "Split Vec3" )
        addOutputItem   ( "X"   ,           FlowConfig.noneMask  , function(){ return getObjectName() + ".x" } )
        addOutputItem   ( "Y"   ,           FlowConfig.noneMask  , function(){ return getObjectName() + ".y" } )
        addOutputItem   ( "Z"   ,           FlowConfig.noneMask  , function(){ return getObjectName() + ".z" } )
        addInputItem    ( "Vec3 In",        [FlowConfig.vec3fMask, FlowConfig.vec3iMask]  )
        fitItemToContents()
    }


    onInPortConnectionRemoved:
    {
        var conCount = getConnectedInputCount()
        setOutputPortsToType(  FlowConfig.noneMask ) //reset output port
        if( conCount === 0 )
            reset()
    }

    function toCpp()
    {
        return "";
    }

    function toGlsl()
    {
        return "" //no code generated since connections take care of members
    }

    function reset()
    {
        setTitlePostFix( "" )
        setInputPortsToType( [FlowConfig.vec3fMask, FlowConfig.vec3iMask] )
    }

}
