
function swap(a, b) {
    return [b, a]
}

/*
 *@brief MenuItem Helper 
 */ 
function findMenuByTitle(parentMenu, titleStr) {
    var menuItems = parentMenu.contentChildren;
    for (var i = 0; i < menuItems.length; i++) {
        var curMenu = menuItems[i];
        if (curMenu.subMenu) {
            var subMenuTitle = curMenu.subMenu.title;
            if (subMenuTitle === titleStr)
                return curMenu.subMenu;
        }

    }
    return null;
}

function isDefined( instance ) {
    return instance !== null && instance !== undefined;
}

function cloneObject( instance ){
    
    let target = {};
    for (let prop in instance) {
        if (instance.hasOwnProperty(prop)) {
            target[prop] = instance[prop];
        }
    }
    return target; 
}

function setBit( curMask, idx ) {
    var mask = 1 << idx
    curMask |= mask
    return curMask
}

function clearBit( curMask, idx) {
    var mask = 1 << idx
    curMask &= ~mask
    return curMask
}

function toggleBit(curMask, idx) {
    var mask = 1 << idx
    curMask ^= mask
    return curMask
}
Number.prototype.round = function (places) {
    return +(Math.round(this + "e+" + places) + "e-" + places);
}


function equalsEpsilon( a, b, eps ) {
    return Math.abs(a - b) < eps
}

function isMouseCondition(mouse, button, modMask ) {
    var succeed = (mouse.button === button)
    if (succeed && (modMask != 0))
        succeed = (mouse.modifiers & modMask) != 0
    return succeed
}


function openFile(fileUrl) {
    var request = new XMLHttpRequest();
    request.open("GET", fileUrl, false);
    request.send(null);
    return request.responseText;
}

function saveFile(fileUrl, text) {
    var request = new XMLHttpRequest();
    request.open("PUT", fileUrl, false);
    request.send(text);
    return request.status;
}


function snapToGrid(val, gridSize, roundDown) {
    val = roundDown
        ? (val - gridSize) / gridSize
        : (val + gridSize) / gridSize
    return Math.round(val) * gridSize;
}

function snapPointToGrid(val, gridSize, roundDown) {
    var result = Qt.vector2d(snapToGrid(val.x, gridSize, roundDown),
        snapToGrid(val.y, gridSize, roundDown))
    return result
}


function getCenter( p1, p2 ) {
    return p1.plus( p2 ).times( 0.5 )
}

function getSize(p1, p2) {
    return p2.minus( p1 )
}


function expandBounds(min, max, scale) {

    min = toVector2(min)
    max = toVector2(max)
    var center = getCenter( min, max )
    var size   = getSize( min, max )
    var sizeScale = size.times( scale / 2 ) 
    return [center.minus(sizeScale), center.plus(sizeScale)]
}

function toVector2( val ) {
    return Qt.vector2d( val.x, val.y )
}

function toPoint( val ) {
    return Qt.point( val.x, val.y )
}

function findChildByObjectName(parent, name) {
    if (parent.objectName === name)
        return parent

    for (var i in parent.data) {
        var result = findChildByObjectName( parent.data[i], name ) 
        if (result !== null) {          
            return result                
        }
    }
    return null
}

//https://stackoverflow.com/questions/40438851/use-javascript-to-check-if-json-object-contain-value
function contains(arr, key, val) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i][key] === val) return true;
    }
    return false;
}

function itemIndex(item, arr) {
    for (var i in arr) {
        if (arr[i] === item)
            return i
    }
    return -1
}


function insertItemAt( index, item, srcList ) {
    var arr = []
    for (var i in srcList) {
        if (srcList[i] !== item)
            arr.push(srcList[i])
    }
    arr.splice(index, 0, item)
    return arr
}

function moveItemToEnd(item, srcList) {
    var arr = []
    for (var i in srcList) {
        if (srcList[i] !== item)
            arr.push(srcList[i])
    }
    arr.push(item)
    return arr
}


function swap(a, b) {
    var tmp = a
    a = b
    b = tmp
}