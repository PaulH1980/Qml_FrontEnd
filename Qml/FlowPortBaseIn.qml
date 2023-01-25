import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."


Item 
{   
    //forwarded signals                             
    signal                          portClicked ( var portControl, var mouse )
    signal                          portPressed ( var portControl, var mouse )
    signal                          portReleased( var portControl, var mouse )
    signal                          portDragged ( var portControl, var mouse )
    //connection modification
    signal                          connectionAdded( var portControl, var connection )
    signal                          connectionRemoved( var portControl, var connection )

    property var  defaultAcceptedTypes : []
    property var  acceptedTypes        : []
    property var  curConnectedType     : 0x0
    
    id                               : portControl
    property bool connected          : false
    property bool acceptConnection   : false
    property alias text              : label.text
    property var  incomingConnection : null    
    property int  numConnections     : 0 
    property int  leftMargin         : 0
    property int  rightMargin        : 0 

    property alias layout            : rowLayout
    property alias content           : rowLayout.children
    height                           : 20
    
    RowLayout
    {
        anchors.fill                : parent
        anchors.leftMargin          : leftMargin
        anchors.rightMargin         : rightMargin
        id                          : rowLayout
        
        FlowPortInternal
        {
            Layout.preferredWidth   : portControl.height
            Layout.preferredHeight  : portControl.height
            id                      : portInternal
            onPortClicked:
                portControl.portClicked( portControl, mouse )
            onPortPressed:
                portControl.portPressed( portControl, mouse )
            onPortReleased:
                portControl.portReleased( portControl, mouse )
            onPortDragged:
                portControl.portDragged( portControl, mouse )
        }
        DefaultLabel
        {
            Layout.fillWidth       : true
            Layout.preferredHeight : portControl.height
            horizontalAlignment    : Text.AlignLeft
            verticalAlignment      : Text.AlignVCenter
            text                   : "Input"
            id                     : label
        }
    }

    onIncomingConnectionChanged:
    {
        var newState = ( !AppScripts.isDefined( incomingConnection ) ) ? "" : "Connected"
        setState( newState )       
    }


    /*
        @brief: Return internal port
    */
    function getPortInternal() {
        return portInternal
    }


    function getNode()
    {
        return flowNodeBase //reference to FlowNodeRenderItemBase.qml
    }


    /*
        @brief: Return if this port can accept a new outgoing connection        
    */
    function canAcceptConnection( portId )
    {
        //#todo check for type( conversion )
        if( true ){
            if( portInternal.getState() === "Connected" )
                return false;
            return isTypeInAcceptedList( portId.outputType )  
        }
        return false;
    }

    function isTypeInAcceptedList( type )
    {
        //console.log( type )
        for( var i in portControl.acceptedTypes )
        {
            var curType = portControl.acceptedTypes[i]
            if( curType == FlowConfig.anyMask || 
                curType == type)
                return true            
        }
        return false

    }

    /*
        @brief: 
    */
    function accept( portId, requestedState )
    {
        return true;
    }

    /*
        @brief: passthrough function
    */
    function setState( newState )
    {
        portInternal.setState( newState )
    }

    /*
        @brief: Set a new connection to this port, return true upon success
        false otherwise
    */
    function addConnection( connection )
    {
        if( incomingConnection === connection )
            return false
        incomingConnection = connection
        numConnections++
        connectionAdded( portControl, connection )
        return true
    }

    /*
        @brief: Remove connection from this port, return true upon succesful removal false otherwise
    */
    function removeConnection( connection )
    {
        if( incomingConnection !== connection )
            return false
        incomingConnection = null
        numConnections--
        connectionRemoved( portControl, connection )
        return true
    }

    /*
        @brief: Return true if this port has a connection
    */
    function containsConnection( connection )
    {
        if( incomingConnection === null )
            return false
        return incomingConnection === connection;      
    }

    function isConnected()
    {
        return numConnections >= 1
    }
       
    function indexOf()
    {
        var inPorts = getNode().getInputPorts()
        for( var i in inPorts )
        {
            if( inPorts[i] === this )
                return i
        }
        throw new Error( "Port Not Found" )
        return -1
    }

}
