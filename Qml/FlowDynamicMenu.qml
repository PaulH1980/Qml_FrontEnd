import QtQuick.Controls 2.4
import QtQuick 2.7
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

Menu 
{
    id                              : flowPopupMenu
    property string  objectName    : "root"
    property vector2d popupLocation : Qt.vector2d( 0, 0 )

    font.family: "Helvetica"
    font.pointSize : 14

    Component {
        id: menuItem
        MenuItem {
            property var jsonObj    : null
            //property string qmlFile : null
            action :   Action{}

            onTriggered :
            {
                flowRenderControl.flowMenuItemClicked( popupLocation, jsonObj ) //emit signal
            }
            Component.onCompleted:
            {
                
            }
        }
    }

    Component {
        id: menuSeparator
        MenuSeparator {
        }
    }

    function createSubMenuEntry( parentMenu, pathSplit, curDepth  )
    {
        const pathLength = pathSplit.length - 1
        const curName = pathSplit[curDepth]
        var subMenu =  AppScripts.findMenuByTitle( parentMenu, curName )
        if( subMenu === null )
        {
            var component      = Qt.createComponent("FlowDynamicMenu.qml")
            subMenu            = component.createObject ( parentMenu )
            subMenu.objectName = curName
            subMenu.title      = curName
            parentMenu.addMenu( subMenu )
        }
        if( curDepth < pathLength ) //recurse with children
            return createSubMenuEntry( subMenu, pathSplit, curDepth + 1 )
        return subMenu
    }

    function createItem( pathSplit, jsonObj )
    {
        var subMenu = createSubMenuEntry( flowPopupMenu, pathSplit, 0 )
        if( subMenu === null )
            throw new Error( "Invalid Path Specified" )
        var newItem     = menuItem.createObject( subMenu )
        newItem.text    = jsonObj.label
       // newItem.qmlFile = jsonObj.flowFile
        newItem.jsonObj = jsonObj
        subMenu.addItem( newItem )
        return newItem
    }

    function getRootMenu( curMenu )
    {
        var result = curMenu

        while( result.parent !== null ){
            if( result instanceof Menu )
                console.log( result )
            result = result.parent
        }
        console.log( result )
        return result
    }
}



