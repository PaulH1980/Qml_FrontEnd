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
   

    //see FlowConfig.qml  
    property string defaultOutputType   : FlowConfig.noneMask
    property string outputType          : FlowConfig.noneMask  //this is 'strongly' typed
    
    id                                : portControl  
    enabled                           : false
    property var  outgoingConnections : []
    property int  numConnections      : 0 
    property var  outputPortVariable  : null //as callback

    property alias text              : label.text   
    property alias portColor         : portInternal.color    
    property alias layout            : rowLayout
    property alias content           : rowLayout.children
    property alias portLabel         : label
 
    height                          : 20

    RowLayout
    {
        id                          : rowLayout
        anchors.fill                : parent   
        Item
        {
            id                     : filler
            Layout.fillWidth       : true            
        }
        DefaultLabel
        {
            horizontalAlignment    : Text.AlignRight
            verticalAlignment      : Text.AlignVCenter
            text                   : "Output"
            id                     : label
        }
        FlowPortInternal
        {
            Layout.preferredWidth   : portControl.height
            Layout.preferredHeight  : portControl.height
            id                      : portInternal
            onPortClicked:
            {
                if( portControl.enabled ){
                    portControl.portClicked( portControl, mouse )  
                }
            }
            onPortPressed: {
                if( portControl.enabled ){
                    portControl.portPressed( portControl, mouse )
                    setState("Pressed")
                }
            }               
            onPortReleased:
            {
                if( portControl.enabled ){
                    portControl.portReleased( portControl, mouse )       
                    var newState = numConnections > 0 ? "Connected" : "Enabled"
                    setState( newState )
                }
            }
            onPortDragged: {
                if( portControl.enabled ){
                    portControl.portDragged( portControl, mouse )       
                }
            }
        }
    }

    Component.onCompleted:
    {
        
    }

    onEnabledChanged:
    {
        if( enabled )
        {
            setState("Enabled")
        }
        else
        {
            setState("Disabled")
        }
    }
    
    onNumConnectionsChanged:
    {
        var newState = ""
        if( numConnections > 0 )
            newState = "Connected"
        else if( enabled )
            newState = "Enabled"
        else  
            newState = "Disabled"     
        setState( newState )      
    }

    /*
        @brief: Return internal port
    */
    function getPortInternal() {
        return portInternal
    }

    function accept( portId )
    {
       return false //don't accept incoming connections
    }

    /*
        @brief: passthrough function
    */
    function setState( newState )
    {
        portInternal.setState( newState )
    }


    function getVariableName() 
    {
        if( outputPortVariable )
            return outputPortVariable()
        return null
    }

    /*
        @brief: Convenience method returns parent node of this port
    */
    function getNode()
    {
        return flowNodeBase //refernce to FlowNodeRenderItemBase.qml
    }

    

    /*
        @brief: Add a new connection to this port, return true upon success
        false otherwise
    */
    function addConnection( connection )
    {
        if( !containsConnection( connection ) ) {
            outgoingConnections.push( connection ) 
            numConnections = outgoingConnections.length
            connectionAdded( portControl, connection )
            return true
        }
        return false
    }

    function removeAllConnections()
    {
        const numConnections = outgoingConnections.length
        if( numConnections )
        {
             for( var i in outgoingConnections ) {
                var connection = outgoingConnections[i]
                connectionRemoved( portControl, connection )         
             }             
             outgoingConnections = []
             connectionRemoved( portControl )
        }
    }

    /*
        @brief: Remove a connection from this port, return true upon success
        false otherwise
    */
    function removeConnection( connection )
    {
        var removed    = false
        var tmpArray = []
        for( var i in outgoingConnections )
        {
            if( outgoingConnections[i] === connection )
                removed = true
            else
               tmpArray.push( outgoingConnections[i] )           
        }
        if( removed ){
            outgoingConnections = tmpArray;
            numConnections = outgoingConnections.length
            connectionRemoved( portControl, connection )
        }
        return removed
    }

    /*
        @brief: Return true if this array contains a connection
    */
    function containsConnection( connection )
    {
        for( var i in outgoingConnections )
        {
            if( outgoingConnections[i] === connection )
                return true
        }
        return false
    }

    
    function isConnected()
    {
        return outgoingConnections.length >= 1
    }

     function indexOf()
    {
        var outPorts = getNode().getOutputPorts()
        for( var i in outPorts )
        {
            if( outPorts[i] === this )
                return i
        }
        throw new Error( "Port Not Found" )
        return -1
    }


}
