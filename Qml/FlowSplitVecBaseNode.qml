import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowNodeBase
{
    id                        : splitVectorBase
    property var vecType      : undefined


    onInPortConnectionAdded:
    {
        //grab output from connection
        var connection    = portId.incomingConnection;
        var outport       = connection.outputPort;
        var incomingType  = outport.outputType
        var outgoingType  = getBaseType( incomingType )
        vecType           = outgoingType

        //set title post fix
        setTitlePostFix( FlowConfig.operandToTypeName ( outgoingType ) );
        setInputPortsToType( incomingType  )
        setOutputPortsToType( outgoingType )
    }


    function getObjectName()
    {
        return inputPorts[0].incomingConnection.getVariableName()
    }


    function getBaseType( incomingType )
    {
        var outGoingType = FlowConfig.noneMask
        switch( incomingType )
        {
            case FlowConfig.vec1iMask:
            case FlowConfig.vec2iMask:
            case FlowConfig.vec3iMask:
            case FlowConfig.vec4iMask:
                outGoingType = FlowConfig.vec1iMask
                break
           case FlowConfig.vec1fMask:
           case FlowConfig.vec2fMask:
           case FlowConfig.vec3fMask:
           case FlowConfig.vec4fMask:
                outGoingType = FlowConfig.vec1fMask
                break;
        }
        if( outGoingType === FlowConfig.noneMask ) {
            throw new Error( "Invalid Incoming Type" )
        }
        return outGoingType
    }

}
