import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowArithmetricNode
{
    id                        : unaryNode
    property int  operation   : FlowConfig.pendingOperation
    property int  operandType : FlowConfig.pendingOperand   
    

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

}