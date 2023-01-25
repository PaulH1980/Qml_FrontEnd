import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowCreateVecBaseNode
{
    id                        : createVec2
    objectName                : "CreateVec2"
    

    Component.onCompleted:
    {
        setTitle        ( "Create Vec2" )
        addOutputItem   ( "Vec2 Out",  FlowConfig.noneMask , getObjectName )
        addInputItem    ( "X" ,   [FlowConfig.vec1fMask, FlowConfig.vec1iMask]  )
        addInputItem    ( "Y" ,   [FlowConfig.vec1fMask, FlowConfig.vec1iMask]  )
        fitItemToContents()
    }
    
    onInPortConnectionAdded:
    {
        //grab output from connection
        var connection  = portId.incomingConnection;
        var outport     = connection.outputPort;
        var incomingType = outport.outputType
        var outgoingType = getOutgoingType( incomingType )
        vecType = outgoingType

        //set title post fix
        setTitlePostFix( FlowConfig.operandToTypeName ( incomingType ) );
        setInputPortsToType( [incomingType] ) //set all output to type
        setOutputPortsToType( outgoingType )
    }

    function toCpp()
    {
        
    }


    function toGlsl()
    {
        const type  = FlowConfig.typeToGlslType( vecType )
        var genCode = type + " " + getObjectName()
                + " = " + type + "( "
                + getInputPortAt(0).incomingConnection.getVariableName() + ", "
                + getInputPortAt(1).incomingConnection.getVariableName() + " );\n"
        return genCode;
    }




    function getOutgoingType( incomingType )
    {
        if( incomingType === FlowConfig.vec1iMask )
            return FlowConfig.vec2iMask
        else if( incomingType === FlowConfig.vec1fMask )
            return FlowConfig.vec2fMask
        else {
            throw new Error( "Invalid incoming type" )
        }
    }

}
