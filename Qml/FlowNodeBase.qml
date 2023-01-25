import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12

import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

Item
{
    signal                          inPortClicked  ( var portId, var mouse )
    signal                          inPortPressed  ( var portId, var mouse )
    signal                          inPortReleased ( var portId, var mouse )
    signal                          inPortDragged  ( var portId, var mouse )

    signal                          inPortConnectionAdded    ( var portId, var connection )
    signal                          inPortConnectionRemoved  ( var portId, var connection )

    signal                          outPortClicked ( var portId, var mouse )
    signal                          outPortPressed ( var portId, var mouse )
    signal                          outPortReleased( var portId, var mouse )
    signal                          outPortDragged ( var portId, var mouse )

    signal                          outPortConnectionAdded    ( var portId, var connection )
    signal                          outPortConnectionRemoved  ( var portId, var connection )

    signal                          flowNodeSelected( var node )
                 
    
    width                           : 160
    height                          : 192
    id                              : flowNodeBase
    
    //lookup & identification

    property string uuid             : null
    property int    visitCount       : 0
    property int    nodeNum          : 0
    property int    nodeDepth        : 0
    property alias  nodeContent      : contentLayout.children

    property color  titleBarColor    : "steelblue"
    property color  contentItemColor : Qt.rgba( 80/255,  80/255,  80/255, 1)
    
    property string title            : ""
    property string titlePostFix     : ""
    property string qmlFile          : ""
    property string group            : ""

    property int    margins          : 1
    property var    inputPorts       : []
    property var    outputPorts      : []
    property real   globalOpactity   : 1.0
    property bool   selected         : false
    
    property var    mJsonObj           : ({}) //shared property data
    property var    propertyDataJson   : ({}) //filled after 'updateItem' contains 'value'

    property alias  flowContentItem    : contentLayout
   
    Drag.active                        : mouseArea.drag.active

    Rectangle
    {
        visible         : flowNodeBase.selected
        anchors.fill    : flowNodeBase
        opacity         : 1.0
        radius          : 8
        layer.enabled   : true
        color           : titleBarColor
        layer.effect: Glow {
            samples          : 10
            color            : titleBarColor
            transparentBorder: true
        }
    }
    
    //header
    Rectangle
    {
        id                  : header
        anchors.top         : parent.top;
        anchors.left        : parent.left
        anchors.right       : parent.right
        anchors.topMargin   : flowNodeBase.margins
        anchors.leftMargin  : flowNodeBase.margins
        anchors.rightMargin : flowNodeBase.margins
        height              : 32
        radius              : 5
        color               : titleBarColor
        opacity             : globalOpactity
        
        MouseArea //mouse area so item can be dragged
        {
            id              : mouseArea
            anchors.fill    : parent
            drag.target     : flowNodeBase
            onClicked       :
            {
                flowNodeBase.focus = true
                if( ( mouse.button === Qt.LeftButton ) && ( mouse.modifiers & Qt.ControlModifier ) )
                {
                    flowNodeBase.selected = !flowNodeBase.selected
                }
            }
        }

        DefaultLabel
        {
            anchors.centerIn : header
            text             : title + " " + titlePostFix
            font.pixelSize	 : 16
            font.bold        : true
            id               : nodeTitle
            opacity          : globalOpactity
        }
    }
    Rectangle//filler to hide rounded rectangle on top
    {
        anchors.top             : header.bottom
        anchors.left            : parent.left
        anchors.right           : parent.right
        anchors.leftMargin      : flowNodeBase.margins
        anchors.rightMargin     : flowNodeBase.margins
        anchors.topMargin       : -header.radius
        height                  : header.radius * 2
        color                   : contentItemColor
        opacity                 : globalOpactity
    }

    Rectangle//content
    {
        anchors.top             : header.bottom
        anchors.left            : parent.left
        anchors.right           : parent.right
        anchors.bottom          : parent.bottom
        anchors.bottomMargin    : flowNodeBase.margins
        anchors.leftMargin      : flowNodeBase.margins
        anchors.rightMargin     : flowNodeBase.margins
        radius          : 5
        id              : contents
        color           : contentItemColor
        opacity         : globalOpactity

        MouseArea
        {
            anchors.fill        : parent
            onClicked:
            {
                flowNodeBase.focus = true
                if( mouse.button === Qt.LeftButton )
                {
                    if( mouse.modifiers & Qt.ControlModifier ) //toggle selection
                    {
                        flowNodeBase.selected = !flowNodeBase.selected
                    }
                    else if( mouse.modifiers & Qt.ShiftModifier )
                    {
                        editRequest();
                    }
                }

            }
        }

        Column
        {
            id                    : contentLayout
            anchors.fill          : parent
            anchors.topMargin     : 8
            anchors.bottomMargin  : 8
            spacing               : 4
        }
    }

    Component.onCompleted:
    {
        uuid = FlowConfig.uuidGen.generate()
        console.log( uuid )
    }

    onInPortConnectionAdded:
    {
        var enable = allInPortsConnected()
        enableOutPorts( enable )
    }

    onOutPortConnectionAdded:
    {
        
    }

    onInPortConnectionRemoved:
    {
        var enable = allInPortsConnected()
        enableOutPorts( enable )
    }
    
    onOutPortConnectionRemoved:
    {

    }

    onFocusChanged:
    {
        if( flowNodeBase.focus ) {
            root.flowNodeSelected( flowNodeBase )
            z = 1  
        }
        else{
            z = 0           
        }
    }

    onSelectedChanged:
    {
        if( selected )
            flowNodeSelected( flowNodeBase )
    }

    /*
        @brief: Base class does nothing
    */
    function editRequest()
    {
        var objModel = getPropertyModel()
        if( objModel )
        {
             console.log("Object Model Selected :" + objModel )
             root.flowNodeEditRequested( flowNodeBase )
        }
        else
        {
            console.log("No Object Model")
        }
    }


    /*
        @brief: Override in derived class
    */
    function getPropertyModel()
    {
        return null
    }

    /*
        @brief: Evaluates node
    */
    function evaluate( type )
    {
        throw new Error( "Not Implemented" )
    }


    function beginCompile( idx )
    {
        flowNodeBase.visitCount = 0
        flowNodeBase.nodeNum    = idx
    }

    function endCompile()
    {
        flowNodeBase.nodeNum  = 0
    }

    function getObjectName()
    {
        var result = objectName + "_" + nodeNum
        return result;
    }

    function serialize()
    {
        var nodeObj = {
            "x"         : this.x,
            "y"         : this.y,
            "uuid"      : this.uuid,
            "qmlFile"   : this.qmlFile,
            "ports"     : [{}]
        }
        //contant input value
        if( this instanceof FlowConstValueNode )
            nodeObj["constantValue"] = this.constantValue

        var outPorts = this.getConnectedOutputPorts()
        for( var j in outPorts ) {
            var port = outPorts[j]
            var portObj = {
                "indexOf"  : port.indexOf(),
                "portName" : port.text,
                "connections" : [{}]
            }
            for( var k in port.outgoingConnections ) {
                var curCon = port.outgoingConnections[k]
                var inPort = curCon.inputPort
                var inNode = inPort.getNode()
                var conObj = {
                    "inNodeUuid" : inNode.uuid,
                    "indexOf"    : inPort.indexOf(),
                    "portName"   : inPort.text
                }
                portObj["connections"].push( conObj )
            }
            nodeObj["ports"].push( portObj )
        }
    }


    function toCpp()
    {
        throw new Error( "Not Implemented" )
    }

    function toGlsl()
    {
        throw new Error( "Not Implemented" )
    }


    function setTitle( txt)
    {
        flowNodeBase.title = txt
    }

    function setTitlePostFix( txt )
    {
        flowNodeBase.titlePostFix = txt
    }


    function setTitleBackgroundColor( bgColor )
    {
        titleBarColor = bgColor
    }

    function addItem( newItem )
    {
        newItem.parent = contentLayout;
        contentLayout.children.push( newItem )
    }

    function canAcceptConnection( outPortId, inPortId )
    {
        return true
    }

    function getContentWidth()
    {
        return contents.width
    }

    function setInputPortTypes()
    {
        var count = getConnectedInputCount()
    }

    function setWidth( width )
    {
        flowNodeBase.width = width
    }

    function setHeight( height)
    {
        flowNodeBase.height = height
    }

    function getHeight( )
    {
        return flowNodeBase.height;
    }
    
    function addOutputItem( txt, outputType, variableNameCb )
    {
        //AppScripts.helloWorld()
        const outputCount =  getOutputPortCount();
        if( outputType === undefined )
            throw new Error("Output type required");
        
        var component = Qt.createComponent("FlowPortBaseOut.qml")
        if (component.status !== Component.Ready)
            throw new Error( "Error " + component.errorString() )
        var result = component.createObject( contentLayout,
                                            {
                                                "defaultOutputType" : outputType,
                                                "outputType"        : outputType,
                                                "anchors.left"      : contentLayout.left,
                                                "anchors.right"     : contentLayout.right,
                                                "height"            : 24,
                                                "text"              : txt,
                                                "outputPortVariable" : variableNameCb
                                            } );
        
        //insert at the end of output ports
        nodeContent = AppScripts.insertItemAt( outputCount, result, nodeContent )

        if( connectOutputPort( result ) )
            return result   
    }

    function connectOutputPort( outputPort )
    {
        console.assert( outputPort instanceof FlowPortBaseOut, "Not An Output Port " )

        outputPort.portClicked.connect ( outPortClicked  )
        outputPort.portPressed.connect ( outPortPressed  )
        outputPort.portReleased.connect( outPortReleased )
        outputPort.portDragged.connect ( outPortDragged  )
        outputPort.connectionAdded.connect( outPortConnectionAdded )
        outputPort.connectionRemoved.connect( outPortConnectionRemoved )
        outputPorts.push( outputPort )   

        return true;
    }
    
    
    function addInputItem( txt, acceptedTypes  )
    {
        if( acceptedTypes === undefined )
        { throw new Error("InputItem requires accepted type"); };

        var component = Qt.createComponent("FlowPortBaseIn.qml");
        if (component.status !== Component.Ready)
            throw new Error( "Error " + component.errorString() )

        var result = component.createObject( contentLayout,
                                            {
                                                "defaultAcceptedTypes"  : acceptedTypes,
                                                "acceptedTypes"         : acceptedTypes,
                                                "anchors.left"          : contentLayout.left,
                                                "anchors.right"         : contentLayout.right,
                                                "height"                : 24 ,
                                                "text"                  : txt
                                            } );
        if( result )
        {
            result.portClicked.connect ( inPortClicked )
            result.portPressed.connect ( inPortPressed )
            result.portReleased.connect( inPortReleased )
            result.portDragged.connect ( inPortDragged  )
            result.connectionAdded.connect( inPortConnectionAdded )
            result.connectionRemoved.connect( inPortConnectionRemoved )

            inputPorts.push( result )
        }
        return result
    }




    function addPreviewItemToBase( qmlFile, arguments ) {

        var component = Qt.createComponent( qmlFile );
        if (component.status !== Component.Ready){
            throw new Error(  "Error " + component.errorString() )
        }
        var result = component.createObject( contents, arguments )
        return result
    }

     function addItemToLayout( qmlFile, arguments ) {

        var component = Qt.createComponent( qmlFile );
        if (component.status !== Component.Ready){
            throw new Error(  "Error " + component.errorString() )
        }
        var result = component.createObject( contentLayout, arguments )
        return result
    }


    function removeItem( item )
    {
        var idx = AppScripts.itemIndex( item, contentLayout.children )
        if( idx != -1 )
        {
            var copy = []            
            for( var i in contentLayout.children ){
                if( i != idx )
                    copy.push( contentLayout.children[i] )  
            }
            item.destroy();      
            contentLayout.children = copy
            fitItemToContents()
            return true
        }        
        return false;
    }
    


    function getChildItemForScreenPos( screenPos )
    {
        var worldPos = screenToWorld( screenPos )
        var child = flowNodeBase.childAt( screenPos.x, screenPos.y )
    }
    
    function handleOutPortPressed( portId, mouse )
    {
        //output port belongs to this node, ignore
        if( portId.getNode() === flowNodeBase )
            return 0

        //get all  input ports and see if they can accept the new outgoing connection
        var count = 0
        var ports = getInputPorts()
        for( var i in ports )
        {
            if( ports[i].canAcceptConnection( portId ) ) {
                ports[i].setState( "AcceptConnection" )
                count++;
            }

        }
        return count
    }


    function handleOutPortReleased( portId, mouse )
    {
        if( portId.getNode() === flowNodeBase )
            return 0
        var count = 0
        var ports = getInputPorts()
        for( var i in ports ){
            if( ports[i].canAcceptConnection( portId ) ) {
                ports[i].setState( "" )
            }
        }
        return count
    }

    function arrayPushArray( src, dst )
    {
        for( var i = 0; i < src.length; ++i )
            dst.push( src[i] );
    }

    function fitItemToContents()
    {
        contentLayout.forceLayout()
        flowNodeBase.height = contentLayout.childrenRect.height + header.height + 16
    }

    function getPreviewItem()
    {
        var childCount = contentLayout.children.length
        for( var i  = 0; i < childCount; ++i )
        {
            var child = contentLayout.children[i]
            if( child instanceof FlowNodePreviewItem )
                return child
        }
        return null
    }

    function getInputPortAt( index )
    {
        return getInputPorts()[index];
    }

    function getOutputPortAt( index )
    {
        return getOutputPorts()[index];
    }


    function getOutputPortCount()
    {
        return getOutputPorts().length
    }

    function getInputPortCount()
    {
        return getInputPorts().length
    }

    function getConnectionCount( ports )
    {
        var result = 0
        for( var i in ports )
        {
            if( ports[i].isConnected() )
                result++;
        }
        return result
    }

    function getConnectedInputCount()
    {
        return getConnectionCount( getInputPorts() )
    }

    function getConnectedOutputCount()
    {
        return getConnectionCount( getOutputPorts() )
    }

    function getConnectedInputPorts()
    {
        var fn = function( port ){
            return port.isConnected()
        }
        return getInputPortsCb( fn )
    }

    function getConnectedOutputPorts()
    {
        var fn = function( port ){
            return port.isConnected()
        }
        return getOutputPortsCb( fn )
    }

    function getOutputPortsCb( callback )
    {
        var result = []
        for( var i in  contentLayout.children )
        {
            var child = contentLayout.children[i]
            if( child instanceof FlowPortBaseOut && callback( child ) )
                result.push( child )
        }
        return result
    }


    function getConnections()
    {
        var result = []
        var outPorts = getConnectedOutputPorts();
        var inPorts  = getConnectedInputPorts();
        // console.log( inPorts.length );
        for( var i in outPorts )
            Array.prototype.push.apply( result, outPorts[i].outgoingConnections )
        for( var i in inPorts )
            result.push( inPorts[i].incomingConnection )
        return result;
    }

    function getInputPortsCb( callback )
    {
        var result = []
        for( var i in  contentLayout.children )
        {
            var child = contentLayout.children[i]
            if( child instanceof FlowPortBaseIn && callback( child ) )
                result.push( child )
        }
        return result
    }


    function getInputPorts()
    {
        var result = []
        for( var i in  contentLayout.children )
        {
            var child = contentLayout.children[i]
            if( child instanceof FlowPortBaseIn )
                result.push( child )
        }
        return result
    }

    function getOutputPorts()
    {
        var result = []
        for( var i in  contentLayout.children )
        {
            var child = contentLayout.children[i]
            if( child instanceof FlowPortBaseOut )
                result.push( child )
        }
        return result
    }

    function containsPort( portId )
    {
        var outPorts = getOutputPorts()
        var inPorts  = getInputPorts()
        for( var i in outPorts )
        {
            if( outPorts[i] === portId )
                return true
        }
        for( var i in inPorts )
        {
            if( inPorts[i] === portId )
                return true
        }
        return false
    }

    function enableOutPorts( enable )
    {
        var outPorts = getOutputPorts()
        for( var i in outPorts )
        {
            outPorts[i].enabled = enable
        }
    }


    function allInPortsConnected()
    {
        var inCount = getInputPortCount()
        var allConnected = inCount === getConnectedInputCount()
        return allConnected
    }

    function setAllPortsToType( newType )
    {
        setInputPortsToType( [newType] )
        setOutputPortsToType( newType )
    }

    function setOutputPortsToType( newType )
    {
        var outPorts = getOutputPorts()
        for( var i in outPorts )
            outPorts[i].outputType = newType
    }


    function setInputPortsToType( newType )
    {
        var inPorts  = getInputPorts()
        for( var i in inPorts )
            inPorts[i].acceptedTypes = newType
    }
}
