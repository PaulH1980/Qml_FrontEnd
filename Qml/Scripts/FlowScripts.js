
function InputOutputPath( input, output )
{
    this.input  = input;
    this.output = output;
}


function NodeAndDepth( node, depth) {
    this.node = node;
    this.depth = depth;
}


function BBox2() {
   this.min = Qt.vector2d(0, 0)
   this.max = Qt.vector2d(0, 0)
   this.clear()
}


BBox2.prototype.clear = function () {
    this.min = Qt.vector2d( 65535,  65535)
    this.max = Qt.vector2d(-65535, -65535)
}

BBox2.prototype.update = function (coord) {
    if (coord.x < this.min.x)
        this.min.x = coord.x
    if (coord.y < this.min.y)
        this.min.y = coord.y
    if (coord.x > this.max.x)
        this.max.x = coord.x
    if (coord.y > this.max.y)
        this.max.y = coord.y
}


BBox2.prototype.updateFromArray = function (coords) {
    for (var i in coords)
       this.update( coords[i] )
}

BBox2.prototype.toString = function () {
    var str = "min " + this.min + ", max " + this.max
    return str
}

BBox2.prototype.size = function () {
    return this.max.minus(this.min)
}

BBox2.prototype.valid = function () {
    return this.min.x < this.max.x && 
           this.min.y < this.max.y
}


/*
    @brief: Return if there is a path between the
            first node and the second node
*/ 
function hasPathTo( first, second )
{
    if (first === second)
        return true
    //iterate over all outgoing nodes of current/first
    var connectedNodes = getConnectedOutgoingNodes( first )
    for (var i in connectedNodes) {
        var curNode = connectedNodes[i]
        if ( hasPathTo( curNode, second ) ) //recurse
            return true;
    }
    return false
}


/*
    @brief: Visit nodes starting from the output node  
*/ 
function visitNodesReversed(curNode, depth, callback) {
    callback( curNode, depth ) //only emit code first time we see this node

    curNode.visitCount++;
    const inPorts = curNode.getConnectedInputPorts();
    for (var i in inPorts) {
        var connection = inPorts[i].incomingConnection     
        if ( connection ) {
            var outgoingNode = connection.outputPort.getNode()
            visitNodesReversed(outgoingNode, depth + 1, callback)
        }
    }    
}




function getOutgoingValidConnections( curNode, endNode ) {
    var outConnections = curNode.getConnectedOutputPorts()
    var result = []
    for (var i in outConnections) {
        var outPort = outConnections[i]
        for (var j in outPort.outgoingConnections)
        {
            var connection = outPort.outgoingConnections[j]
            if (connection.outputPort !== outPort ||
                connection.inputPort === null) throw new Error("Invalid Port(s)")

            var inNode = connection.inputPort.getNode()
            if ( hasPathTo( inNode, endNode ) )
                result.push( connection )
        }
    }
    return result
}


/*
    @brief: Return all outgoing/connected nodes of current node
 */
function getConnectedOutgoingNodes( curNode )
{
    var outConnections = curNode.getConnectedOutputPorts()
    var result = []
    for (var i in outConnections)  {
        var outPort   = outConnections[i]
        for( var j in outPort.outgoingConnections )
        {
            var connection = outPort.outgoingConnections[j]
            if( connection.outputPort  !== outPort ||
                    connection.inputPort === null)
                throw new Error("Invalid Port(s)")
            var inNode = connection.inputPort.getNode()
            if( !result.includes( inNode ) )
                result.push( inNode )
        }
    }
    return result;
}


/*
    @brief: Helper function to generate a object 
*/
function createItem(displayName, qmlFile) {
    var obj = {
        "childrens" : [],
        "label"     : displayName,
        "flowData": {
            "qmlFile": qmlFile
        },
        "type"      : "leaf"
    }
    return obj;
}

function createMenuItem( displayName, qmlFile ) {
    var obj = {        
        "label": displayName,
        "flowData": {
            "qmlFile": qmlFile
        },
        "type": "leaf"
    }
    return obj
}

/*
 * @brief: Register a flownode item to a treeview or menuview
   #todo cleanup + replace qmlFile with jsonObj
 */ 
function registerFlowNode( name, section, qmlFile, treeView, menuView ) {
    var paths = section.split("/") //seperate paths
    if (treeView !== null) {              
        treeView.addItem( paths, createItem( name, qmlFile ) )
    }
    if (menuView !== null) {       
        menuView.createItem( paths, createMenuItem( name, qmlFile ) )
    }        
}

/*
    @brief: Helper function to generate a object 
*/
function createItemJson(displayName, jsonObj) {
    var obj = {
        "childrens" : [],
        "label"     : displayName,
        "flowData"  : jsonObj,
        "type"      : "leaf"
    }
    return obj;
}

function createMenuItemJson(displayName, jsonObj) {
    var obj = {
        "label"     : displayName,
        "flowData"  : jsonObj,
        "type"      : "leaf"
    }
    return obj
}

/*
 * @brief: Register a flownode item to a treeview or menuview
   #todo cleanup + replace qmlFile with jsonObj
 */
function registerFlowNodeJson(name, section, jsonObj, treeView, menuView) {
    var paths = section.split("/") //seperate paths
    if (treeView !== null) {
        treeView.addItem(paths, createItemJson( name, jsonObj ))
    }
    if (menuView !== null) {
        menuView.createItem(paths, createMenuItemJson(name, jsonObj ) )
    }
}

function popuplateNodeItemViews( treeView, menuView ) {
        registerFlowNode( "String",    "Input/Types",   "FlowStringConstantNode.qml" , treeView, menuView   )
        registerFlowNode( "Color",     "Input/Types",   "FlowColorConstantNode.qml"  , treeView, menuView   )
        registerFlowNode( "Image",     "Input/Types",   "FlowImageConstantNode.qml"  , treeView, menuView   )

         
        //output
        registerFlowNode( "Fragment Shader"     , "Output/Gpu" ,  "FlowPixShaderOutputNode.qml" , treeView, menuView )
        //components
        registerFlowNode( "Engine Component"    , "Output/Cpu" ,  "FlowComponentOutputNode.qml" , treeView, menuView )
        //Image/Texture modifications
        registerFlowNode( "Image"               , "Output/Cpu" ,  "FlowImageOutputNode.qml" , treeView, menuView )
       

        registerFlowNode( "IfElse"      , "Logic",   "FlowIfElseNode.qml"     , treeView, menuView )
        registerFlowNode( "Equal"       , "Logic",   "FlowEqualsNode.qml"     , treeView, menuView )
        registerFlowNode( "NotEqual"    , "Logic",   "FlowNotEqualsNode.qml"  , treeView, menuView )
        registerFlowNode( "LessEqual"   , "Logic",   "FlowLEqualsNode.qml"    , treeView, menuView )
        registerFlowNode( "GreaterEqual", "Logic",   "FlowGEqualsNode.qml"    , treeView, menuView )
        registerFlowNode( "Greater"     , "Logic",   "FlowGreaterNode.qml"    , treeView, menuView )
        registerFlowNode( "Smaller"     , "Logic",   "FlowSmallerNode.qml"    , treeView, menuView )
}


/*
   @brief: return all incoming/connected nodes of current node
 */
function getConnectedIncomingNodes( curNode )
{
    var inConnections  = curNode.getConnectedInputPorts()
    var result = []
    for (var i in inConnections)  {
        var inPort   = inConnections[i]
        var connection = inPort.inComingConnection
        if( !connection )
            throw new Error( "Invalid Connection" )
        if ( connection.inputPort !== inPort ||
                connection.outputPort === null )
            throw new Error("Invalid Port(s)")
        var outNode = connection.outputPort.getNode()
        if( !result.includes( outNode ) )
            result.push( outNode )
    }
    return result;
}


function getAllConnections( processedNodes, curNode ) {

    if (!(curNode instanceof FlowNodeBase))
        throw new Error("Invalid Type")

    var result = []
    //only proces curNode if not in list
    if (!processedNodes.includes(curNode)) {
        processedNodes.push(curNode) //add to list
        var connections = curNode.getConnections()
        result = connections //

        for (var i in connections) {
            var connection = connections[i]
            var tmpResults = getAllConnections(processedNodes, connection.inputPort.getNode())
            var j = 0
            for (j in tmpResults) {
                if (!result.includes(tmpResults[j]))
                    result.push( tmpResults[j])
            }
            tmpResults = getAllConnections( processedNodes, connection.outputPort.getNode() )
            for ( j in tmpResults) {
                if (!result.includes(tmpResults[j]))
                    result.push(tmpResults[j])
            }
        }
    }
    return result;
}
