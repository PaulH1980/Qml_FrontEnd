import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts

Item
{

    signal                          flowDiagramCompiled( bool succeed, string code )
    
    signal                          inPortClicked  ( var portId, var mouse )
    signal                          inPortPressed  ( var portId, var mouse )
    signal                          inPortReleased ( var portId, var mouse )
    signal                          inPortDragged  ( var portId, var mouse )

    signal                          outPortClicked ( var portId, var mouse )
    signal                          outPortPressed ( var portId, var mouse )
    signal                          outPortReleased( var portId, var mouse )
    signal                          outPortDragged ( var portId, var mouse )
    signal                          flowMenuItemClicked( var xyPos, var jsonObj )   
    signal                          flowNodeEditRequested( var node )


    clip                                : true
    id                                  : flowRenderControl
    property alias   translationDb      : flowRenderCanvas.translationDb //double buffering
    property alias   scale              : flowRenderCanvas.scale
    property alias   scaleFactor        : flowRenderCanvas.scaleFactor
    property alias   translation        : flowRenderCanvas.translation
    property var     currentOutPort     : null

    property point   dragStartPos       : Qt.point( 0, 0 )
    property point   dragCurrentPos     : Qt.point( 0, 0 )
    property var     copyBuffer         : [] 

    //display selection
    Rectangle
    {
        id  : selectionRect
        visible : false
        z: 99
        color :  Qt.rgba( 48/255, 48/255, 128/255, .5)
    }

    DropArea {
        anchors.fill : parent
        id           : dropArea
        onDropped:
        {
            var src = drop.source
            if( src instanceof ResourceDragItem ) {               
                src.droppedTarget = flowRenderControl 

                var worldPos = screenToWorld( Qt.vector2d( drag.x, drag.y ) )
                var fileName = src.parentItem.getPath()
                  console.log( worldPos.x + " " + worldPos.y )
                if( AppScripts.isDefined( fileName ) )
                    spawnItemForFile( fileName, worldPos )              
            }
        }   
    }


    FlowRenderCanvas
    {
        bgColor             : Qt.rgba( 24/255, 24/255, 24/255, 1)
        id                  : flowRenderCanvas
        anchors.fill        : parent
    }
    
    //context popup menu
    FlowDynamicMenu
    {
        id         : flowContextMenu
        objectName : "flowContextMenu"
    }


    onFlowMenuItemClicked:
    {
        const worldPos = screenToWorld( xyPos )
        const flowData = jsonObj.flowData;        
        if( flowData.qmlFile !== undefined )
        {
             spawnItem( flowRenderCanvas, worldPos, flowData.qmlFile )
        }
        else if( AppScripts.isDefined( flowData.FlowNodeType ) )
        {
            spawnFlowNodeFromParameters( flowRenderCanvas, worldPos, jsonObj, "ShaderBlockNodeBase.qml" )
        }
    }




    Component.onCompleted:
    {
        //root.createFlowNode.connect( this.createFlowNode )
        
        var a = spawnItem( flowRenderCanvas, Qt.vector2d( 100, 100 ),  "FlowColorConstantNode.qml"      )     
        var j = spawnItem( flowRenderCanvas, Qt.vector2d( 900, 500 ),  "RenderPassShaderNode.qml"       )
        var k = spawnItem( flowRenderCanvas, Qt.vector2d( 300, 100 ),  "FlowPixShaderOutputNode.qml"    )
        var k = spawnItem( flowRenderCanvas, Qt.vector2d( 400, 100 ),  "VertexShaderNode.qml"    )
        var k = spawnItem( flowRenderCanvas, Qt.vector2d( 900, 100 ),  "UniformInputNode.qml"    )
        var k = spawnItem( flowRenderCanvas, Qt.vector2d( 500, 100 ),  "VertexAttributeNode.qml"    )
        var k = spawnItem( flowRenderCanvas, Qt.vector2d( 300, 500 ),  "MaterialNode.qml"    )

        FlowScripts.popuplateNodeItemViews( null, flowContextMenu )

    }

    Keys.onPressed:
    {
       /* if( event.key == Qt.Key_Shift ){
         //   console.log( "shift pressed" )
        }
        else if( event.key == Qt.Key_Control )
            console.log( "control pressed" )
        else if( event.key == Qt.Key_Alt )
            console.log( "alt pressed" )
       */
    }

    Keys.onReleased:
    {
        /*if( event.key == Qt.Key_Shift )
            console.log( "shift released" )
        else if( event.key == Qt.Key_Control )
            console.log( "control released" )
        else if( event.key == Qt.Key_Alt )
            console.log( "alt released" )
        */
    }

    onInPortClicked:
    {
        // console.log( "clicked " + portId )
    }

    onInPortPressed:
    {
        //console.log( "pressed "  + portId )
    }

    onInPortReleased:
    {
        //console.log( "released " + portId )
    }

    onInPortDragged:
    {
        //console.log( "dragged " + portId )
    }

    onOutPortClicked:
    {
        //console.log( "clicked " + portId )
    }

    onOutPortPressed:
    {
        currentOutPort = portId;
    }

    onOutPortReleased:
    {
        if( currentOutPort !== null ){
            var globalPos = portId.getPortInternal().positionToGlobal( mouse )
            var inPort = mouseOverInPort( globalPos )
            if( inPort !== null && inPort.canAcceptConnection( currentOutPort ) )
            {
                addConnection( currentOutPort, inPort )
            }
        }
        currentOutPort = null //nullify output port
    }

    onOutPortDragged:
    {
        var globalPos = portId.getPortInternal().positionToGlobal( mouse )
        var inPort = mouseOverInPort( globalPos )
        if( inPort !== null ){
            //    console.log( "Mouse over port: " + inPort )
        }
    }
    
    MouseArea
    {
        property vector2d   rightMouseDownPos : Qt.vector2d( 0, 0 )
        property vector2d   leftMouseDownPos  : Qt.vector2d( 0, 0 )
        property bool       rightMouseDown    : false
        property bool       leftMouseDown     : false
      
        state                   : "none" //none, pan, zoom

        anchors.fill            : parent
        hoverEnabled            : true
        acceptedButtons         : Qt.AllButtons
        propagateComposedEvents : true
        id                      : mouseArea

        onClicked:
        {
            var mousePos   = Qt.vector2d( mouse.x, mouse.y )
            var globalPos  = mouseArea.mapToGlobal( mouse.x, mouse.y )
            if( ( mouse.button === Qt.LeftButton ) )
            {
                var child = getChildItemForScreenPos( mousePos )
                if( !child )
                    clearSelectedNodes()                     
            }       
            
            if( getChildItemForScreenPos( mousePos ) ) {
                mouse.accepted = false; //propagate to child items
            }
            //popup context menu on CTRL+RightClick
            else if ( AppScripts.isMouseCondition( mouse, Qt.RightButton, Qt.ControlModifier ) )
            {
                flowContextMenu.popupLocation = mousePos
                flowContextMenu.popup()
                mouse.accepted = true
            }
            else
            {
                flowRenderCanvas.focus = true
                mouse.accepted = true
            }
        }
        onPressed:
        {
            var mousePos   = Qt.vector2d( mouse.x, mouse.y );
            var globalPos  = mouseArea.mapToGlobal( mouse.x, mouse.y )
            if( getChildItemForScreenPos( mousePos ) ){ //clicked on children
                mouse.accepted = false
            }
            else if ( AppScripts.isMouseCondition( mouse, Qt.LeftButton, Qt.ControlModifier ) )
            {
                leftMouseDown = true
                 mouse.accepted          = true
                leftMouseDownPos = mousePos
            }
            else if ( AppScripts.isMouseCondition( mouse, Qt.RightButton, Qt.AltModifier) )
            {
                rightMouseDownPos       = mousePos
                flowRenderCanvas.focus  = true
                rightMouseDown          = true
                mouse.accepted          = true
                translationDb           = translation
            }

        }
        onReleased:
        {
            var mousePos   = Qt.vector2d( mouse.x, mouse.y);
            var globalPos  = mouseArea.mapToGlobal( mouse.x, mouse.y )
            if (  rightMouseDown )
            {
                rightMouseDown     = false
                rightMouseDownPos  = Qt.vector2d( 0, 0 )
                mouse.accepted     = true
            }
            else if ( leftMouseDown )
            {
                leftMouseDown               = false
                mouse.accepted              = true
                selectionRect.visible       = false
            }
            else if( getChildItemForScreenPos( mousePos ) )
            {
                mouse.accepted = false;
            }
        }
        onPositionChanged:
        {
            var mousePos   = Qt.vector2d( mouse.x, mouse.y);
            var globalPos  = mouseArea.mapToGlobal( mouse.x, mouse.y )
            if( rightMouseDown )
            {
                var rightMousePos   = mousePos;
                var worldDelta      = pixelToWorld( rightMousePos.minus( rightMouseDownPos ) )
                setTranslation( flowRenderControl.translationDb.plus( worldDelta ) );
                mouse.accepted = true;
            }
            else if( leftMouseDown )
            {
                var points = [leftMouseDownPos, mousePos]
                var aabb   = new FlowScripts.BBox2()
                aabb.updateFromArray( points )

                selectionRect.x = aabb.min.x
                selectionRect.y = aabb.min.y
                selectionRect.width  = aabb.max.x - aabb.min.x
                selectionRect.height = aabb.max.y - aabb.min.y
                selectionRect.visible = true
                mouse.accepted = true;               
            }
            else if( getChildItemForScreenPos( mousePos ) )
            {
                mouse.accepted = false;
            }
            else {
                mouse.accepted = false;
            }
        }
      
        onWheel:
        {
            if( wheel.angleDelta.y !== 0 ){
                zoomCentered( wheel.angleDelta.y > 0 )
            }
        }
    }

    

    function serialize()
    {
        var nodesSerialized = {
            "version"       : FlowConfig.version,
            "translation"   : flowRenderControl.translation,
            "scale"         : flowRenderControl.scale,
            "nodes"         : []
        }
        for( var i in flowRenderCanvas.children ) {
            var nodeObj = flowRenderControl.serializeNode( flowRenderCanvas.children[i] )
            if( nodeObj )
                nodesSerialized["nodes"].push( nodeObj )
        }
        return nodesSerialized;
    }

    function deSerialize( jsonObj )
    {
        const version = jsonObj.version
        flowRenderCanvas.translation = Qt.vector2d(  jsonObj.translation.x,  jsonObj.translation.y )
        flowRenderCanvas.scale       = jsonObj.scale

        for( var i in jsonObj.nodes )
        {
            var curNode = jsonObj.nodes[i]
            var result = spawnItem( Qt.vector2d( curNode.x, curNode.y ), curNode.qmlFile )
            result.uuid = curNode.uuid //update uuid
            if( result instanceof FlowConstValueNode &&
                    curNode.constantValue !== undefined )
            {
                result.setConstantValue( curNode.constantValue )
                console.log( result.constantValue )
            }
        }
    }

    function zoomCentered( zoomOut )
    {
        const newScale = zoomOut ? 1.0 / scaleFactor
                                 :  scaleFactor
        var bounds = getScreenBounds()
        bounds = AppScripts.expandBounds( bounds[0], bounds[1], newScale )
        zoomToBounds( bounds[0], bounds[1] )
    }

    function zoomExtents()
    {
        var bbox = flowRenderCanvas.getBoundingBox()
        if( bbox.valid() )
            zoomToBounds( bbox.min, bbox.max )
        else
            zoomToBounds( Qt.vector2d( -512, -512 ), Qt.vector2d( 512, 512 ) )
    }

    function zoomToBounds( topLeft, bottomRight )
    {
        const center   = AppScripts.getCenter( topLeft, bottomRight )
        const rectSize = AppScripts.getSize( topLeft, bottomRight )
        const ratio = rectSize.x > rectSize.y
                ? 1.0
                : rectSize.y / rectSize.x
        const scale  = width / ( rectSize.x * 1.0 )
        zoomFocus( center, scale )
    }

    function zoomFocus( center, scale )
    {
        //apply scale before translation/calculations
        flowRenderCanvas.scale = scale
        //determine translation parameters
        const worldPos  = screenToWorld( Qt.vector2d( width / 2, height / 2 ) )
        const offset    = AppScripts.toVector2( worldPos ).minus( center )
        const screenPos = worldToScreen( offset ).times( 1 / scale )
        //apply translation last
        flowRenderCanvas.translation = screenPos
    }

    function copySelection()
    {
        console.log( "Copy Selection" )
    }

    function cloneSelection()
    {
        console.log( "Clone Selection" )
    }

    function deleteSelection()
    {
        console.log( "Delete Selection" )
    }



    function clearAll()
    {
        flowRenderCanvas.clearFlowItems()
        zoomExtents()
    }


    /*
        Brief: Generates codes, and signals status upon returning from function
    */
    function compileAndRun()
    {
        console.log( "Compiling... Flow Diagram " )

        const input   = flowRenderCanvas.getInputNodes()
        const output  = flowRenderCanvas.getOutputNodes()
        if( input.length === 0 )
            throw new Error("Invalid input node count: " + input.length )
        if( output.length !== 1 )
            throw new Error("Invalid output node count: " + output.length )

        //reset visit counters
        var count = 0
        var i     = 0
        var allNodes = flowRenderCanvas.getNodes()
        for( i in allNodes )
            allNodes[i].beginCompile( count++ )

        //Add nodes to array, if depth is higher for a current node, replace it
        //this could be faster if there was a map/hash data structure
        var visitedNodes = [];
        var nodeCallback = function( node, depth ) {
            var found = false
            for( var i in visitedNodes ) {
                var iter = visitedNodes[i]
                if( node === iter.node ) {
                    found = true
                    if( depth >=  iter.depth )
                        iter.depth = depth
                    break;
                }
            }
            if( !found )
                visitedNodes.push( new FlowScripts.NodeAndDepth( node, depth ) )
        }
        //walk flow diagram starting from root/output node
        FlowScripts.visitNodesReversed( output[0], 0, nodeCallback )
        visitedNodes.sort( function( a, b ) {
            return b.depth - a.depth
        })
        //build code string
        var inputString = "void main(){\n"
        var validCode = false
        for( i in visitedNodes ) {
            var iter    = visitedNodes[i]
            var curCode =  iter.node.toGlsl();
            if( curCode.length ){
                validCode = true
                inputString += curCode
            }
        }
        inputString += "}\n"
        console.log( inputString )
        flowDiagramCompiled( validCode, inputString )
    }


    function updateCanvas()
    {
        const worldBounds = getScreenBounds()
        flowRenderCanvas.topLeft  = Qt.vector2d(worldBounds[0].x, worldBounds[0].y )
        flowRenderCanvas.botRight = Qt.vector2d(worldBounds[1].x, worldBounds[1].y )
        flowRenderCanvas.repaint()
    }

    function getScreenCoord( childId, xCoord, yCoord )
    {
        var point = flowRenderControl.mapFromItem( childId, xCoord, yCoord )
        return Qt.vector2d( point.x, point.y )
    }


    function worldToScreen( worldCoord )
    {
        return getScreenCoord( flowRenderCanvas, worldCoord.x, worldCoord.y )
    }

    function screenToWorld( screenCoord ) {
        return flowRenderControl.mapToItem( flowRenderCanvas, screenCoord.x, screenCoord.y )
    }

    function pixelToWorld( pixel ) {
        var invScale = 1.0 / flowRenderControl.scale
        return pixel.times( invScale  )
    }

    function worldToPixel( worldCoord ){

        var wc = Qt.vector2d( worldCoord.x, worldCoord.y )
        return wc.times( flowRenderControl.scale )
    }

    function setScale( newScale ) {
        flowRenderControl.scale = newScale
    }

    function setTranslation( newTranslation ) {
        flowRenderControl.translation = newTranslation
        Qt.vector2d( 0, 0 )
    }

    function setOrigin( newOrigin ) {
        flowRenderControl.origin = newOrigin
    }

    function getScreenBounds( ) {
        var min = screenToWorld( Qt.vector2d( 0, 0 ) )
        var max = screenToWorld( Qt.vector2d( width, height ) )
        return [min, max]
    }

    //spawn flow node centered on screen
    function createFlowNode( qmlFile )
    {
        var center =  Qt.vector2d( width/2, height/2 )
        spawnItem( screenToWorld( center ), qmlFile )
    }

  
      /*
        @brief: Create Texture/Image flownode
    */
    function spawnItemForFile( fileName, worldPos )
    {
        //#todo look up file time
        
        var result = spawnItem( flowRenderCanvas, worldPos, "FlowImageConstantNode.qml")
        result.setImage( fileName )        
    }

    function postSpawnItem( flowNode )
    {
        flowNode.inPortClicked  .connect( inPortClicked  )
        flowNode.inPortPressed  .connect( inPortPressed  )
        flowNode.inPortReleased .connect( inPortReleased )
        flowNode.inPortDragged  .connect( inPortDragged  )

        flowNode.outPortClicked .connect( outPortClicked  )
        flowNode.outPortPressed .connect( outPortPressed  )
        flowNode.outPortReleased.connect( outPortReleased )
        flowNode.outPortDragged .connect( outPortDragged  )

        //result.flowNodeSelected.connect( testConnection )

        //add back-wards connection, for now only connection created from outgoing
        //to ingoing ports are accepted
        outPortPressed.connect( flowNode.handleOutPortPressed )
        outPortReleased.connect( flowNode.handleOutPortReleased )
    }


    /*
        @brief: Spawn Built In FlowNode 
    */
    function spawnItem( parent, worldPos, qmlFile, jsonObj )
    {
        if( qmlFile === undefined || qmlFile === null )
            throw new Error( "Invalid Qml-File" )

        var component = Qt.createComponent( qmlFile )
        if (component.status !== Component.Ready)
            throw new Error( "Error " + component.errorString() )

        var result = component.createObject(
                    parent,
                    {
                        "x": worldPos.x,
                        "y": worldPos.y,
                        "qmlFile" : qmlFile
                    } );

        if( result !== null ){           
           postSpawnItem( result )
        }
        return result
    }

    /*
        @brief: Spawn Generic Item
    */
    function  spawnFlowNodeFromParameters( parent, worldPos, jsonObj, qmlFile )
    {
       
        var component = Qt.createComponent( qmlFile )
        if (component.status !== Component.Ready)
            throw new Error( "Error " + component.errorString() )

        var result = component.createObject(
                    parent,
                    {
                        "x": worldPos.x,
                        "y": worldPos.y,
                        "qmlFile" : qmlFile
                    } );

        if( result !== null ){            
            
            if( result.populateFlowNode !== undefined )
            {
                result.populateFlowNode( jsonObj.flowData )     
            }
            postSpawnItem( result )
        }
        return result
    }

   



    /*
        @brief: Establish a new connection between an output and input port
    */
    function addConnection( outPort, inPort )
    {
        var qmlFile   = "FlowConnectionBase.qml"
        var component = Qt.createComponent(qmlFile)
        if (component.status === Component.Ready)
        {
            var result = component.createObject( flowRenderCanvas,
                                                {
                                                    "outputPort"   : outPort,
                                                    "inputPort"    : inPort
                                                });
            outPort.addConnection( result )
            inPort.addConnection( result )
            return result
        }
        return null
    }

    function addConnection2( uuidOutNode, outPortIndex, uuidInNode, inPortIndex )
    {
        var outNode = findNode( uuidOutNode )
        var inNode  = findNode( uuidInNode )
        var outPort = outNode.getOutputPortAt( outportIndex )
        var inPort  = inNode.getInputPortAt( inPortIndex )
        return connect( outPort, inPort )
    }


    function findNode( uuid )
    {
        for( var i in flowRenderCanvas.children ) {
            var child = flowRenderCanvas.children[i]
            if( child instanceof FlowNodeBase ) {
                if( child.uuid === uuid )
                    return child
            }
        }
        return null
    }

    

    function clearSelectedNodes()
    {
        var nodes = flowRenderCanvas.getSelectedNodes()
        for( let i in nodes )
            nodes[i].selected = false       
    }





    function spawnRandomItems( numItems ) {
        var bounds = getScreenBounds()
        var rangeX = bounds[1].x - bounds[0].x
        var rangeY = bounds[1].y - bounds[0].y
        for( var i = 0; i < numItems; ++i ) {
            var xLoc = (Math.random() * rangeX) + bounds[0].x
            var yLoc = (Math.random() * rangeY) + bounds[0].y
            spawnItem( Qt.vector2d( xLoc, yLoc ) )
        }
    }

    function mouseOverPort( globalPos )
    {
        var items = itemsFromGlobalPosition( flowRenderCanvas, globalPos )
        for( var i in items ) {
            if( items[i] instanceof FlowPortInternal )
                return items[i]
        }
        return null
    }

    function mouseOverInPort( globalPos )
    {
        var curPort = mouseOverPort( globalPos )
        if( curPort && curPort.getPortControl() instanceof FlowPortBaseIn )
        {
            return curPort.getPortControl()
        }
        return null
    }

    function mouseOverOutPort( globalPos )
    {
        var curPort = mouseOverPort( globalPos )
        if( curPort && curPort.getPortControl() instanceof FlowPortBaseOut )
        {
            return curPort.getPortControl()
        }
        return null
    }



    function itemsFromGlobalPosition( root, globalPos ) {
        var items = []
        for(var i in root.children){
            var children = root.children[i]
            var localpos = children.mapFromGlobal(globalPos.x, globalPos.y)
            if(children.contains(localpos)){
                items.push(children)
            }
            items = items.concat(itemsFromGlobalPosition(children, globalPos))
        }
        return items;
    }


    function getChildItemForScreenPos( screenPos )
    {
        var worldPos = screenToWorld( screenPos )
        var child = flowRenderCanvas.childAt( worldPos.x, worldPos.y )
        if( !child )
            return null
        if( child instanceof FlowNodeBase ){
            return child
        }
        else if( child instanceof FlowConnectionBase ) {
            
        }
        return null
    }

    function removeConnection( connectionId )
    {
        return false
    }

    function serializeNode( child )
    {
        if( !( child instanceof FlowNodeBase ) )
            return null

        var nodeObj = {
            "x"         : child.x,
            "y"         : child.y,
            "uuid"      : child.uuid,
            "qmlFile"   : child.qmlFile,
            "ports"     : [{}]
        }
        //contant input value
        if( child instanceof FlowConstValueNode )
            nodeObj["constantValue"] = child.constantValue
        //append connections
        var outPorts = child.getConnectedOutputPorts()
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
        return nodeObj;

    }


    function    portHotSpotToWorld( portId )
    {
        var hotSpot = portId.getHotSpot();
        var pos = mapFromItem( portId, hotSpot.x, hotSpot.y )
        return pos;
    }

}
