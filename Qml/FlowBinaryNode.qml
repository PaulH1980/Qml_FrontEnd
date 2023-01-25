import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."


/*
    @brief: A binary nodes consist of 2 input ports and 1 output port
      all of the same type.

    The port types will be determined once a connection is first
    established
*/
FlowArithmetricNode
{
    id                         : binaryNode
    property int  operandTypes : 0
    property int  operation    : FlowConfig.pendingOperation
    property var  operandType  : FlowConfig.noneMask //determined by input nodes
    

    onInPortConnectionAdded:
    {
        //grab output from connection
        var connection  = portId.incomingConnection;
        var outport     = connection.outputPort;
        var incomingType = outport.outputType
        if( incomingType === FlowConfig.noneMask )
        { throw new Error( "Invalid Output Type" ); };

        operandType = incomingType
        setTitlePostFix( FlowConfig.operandToTypeName ( incomingType ) );
        setAllPortsToType( incomingType )
    }

    onInPortConnectionRemoved:
    {
        var conCount = getConnectedInputCount()
        setOutputPortsToType(  FlowConfig.noneMask )
        operandType = FlowConfig.noneMask
        if( conCount === 0 )
            reset()
    }



    function reset()
    {
        setTitlePostFix( "" )
        setInputPortsToType( [FlowConfig.anyMask] )
    }

}
