import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowSplitVecBaseNode
{
    id                        : splitVec2
    objectName                : "SplitVec2"
    
    Component.onCompleted:
    {
        setTitle        ( "Split Vec2" )
        addOutputItem   ( "X"   ,           FlowConfig.noneMask , function(){ return getObjectName() + ".x" } )
        addOutputItem   ( "Y"   ,           FlowConfig.noneMask , function(){ return getObjectName() + ".y" } )
        addInputItem    ( "Vec2 In"   ,     [FlowConfig.vec2fMask, FlowConfig.vec2iMask]  )
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
        setInputPortsToType( [FlowConfig.vec2fMask, FlowConfig.vec2iMask] )
    }

}
