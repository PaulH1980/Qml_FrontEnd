import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowBinaryNode
{
    id                      : divNode
    operation               : FlowConfig.divOperation
    objectName              : "Divide"

    Component.onCompleted:
    {
        setTitle        ( "Divide" )
        addOutputItem   ( "Out" , FlowConfig.noneMask , getObjectName  )
        addInputItem    ( "A"   , [FlowConfig.anyMask] )
        addInputItem    ( "B"   , [FlowConfig.anyMask] )
        fitItemToContents()
    }

    function toCpp()
    {
        
    }

    function toGlsl()
    {
        const type  = FlowConfig.typeToGlslType( operandType )
        var genCode = type + " " + getObjectName() + " = "
                + getInputPortAt(0).incomingConnection.getVariableName()
                + " / "
                + getInputPortAt(1).incomingConnection.getVariableName() + ";\n"
        return genCode;
    }

}
