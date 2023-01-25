import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import SceneGraphRenderer 1.0
import QtQuick.Controls.Material 2.4
import "Scripts/AppScripts.js" as AppScripts

Item
{
    id           : sceneRenderItem
    focus        : true
   
    SceneToolBar
    {
        anchors.left  : parent.left
        anchors.right : parent.right
        anchors.top   : parent.top
        id            : sceneToolbar //contextual toolbar for scene
    }

    DynamicMenu
    {
          id:     sceneMenuContextMenu
    }

    SceneGraphRenderItem
    {
        id                  : renderItem
        anchors.top         : sceneToolbar.bottom
        anchors.left        : parent.left
        anchors.right       : parent.right
        anchors.bottom      : parent.bottom
        mirrorVertically    : true

        Keys.onPressed:
        {
            if(event.key === 96 )
                return
            MainApplication.keyDown( event.key, event.nativeScanCode, event.modifiers )
        }

        Keys.onReleased:
        {
            if( event.isAutoRepeat ) //do nothing
                return
            if(event.key === 96 )
                consolePopup.open()
            MainApplication.keyUp( event.key, event.nativeScanCode, event.modifiers )
        }

        Connections
        {
            target : root
            onRequestSceneContextMenu:
            {
                clearAndShowContextMenu( x, y, contextMenuData )
                console.log("onSetContextMenuData")
            }
        }

        DropArea 
        {
            anchors.fill : parent
            id           : dropArea
            onDropped:
            {
                var src = drop.source
                if( src instanceof ResourceDragItem ) {               
                    src.droppedTarget = sceneRenderItem  
                    console.log( src.parentItem.getPath() )
                }
            }   
        }


        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.AllButtons
            onClicked:
            {
                
                if ( AppScripts.isMouseCondition( mouse, Qt.RightButton, Qt.ControlModifier ) )
                {
                     /* sceneMenuContextMenu.clearMenu( sceneMenuContextMenu )
                      sceneMenuContextMenu.populateMenu( sceneMenuContextMenu, nodeContextMenuData )
                      sceneMenuContextMenu.popup()
                      */
                      parent.focus = true
                      MainApplication.requestContextMenu( mouseX, mouseY, 1, 1 )
                }
                else{
                    parent.focus = true
                    MainApplication.mouseClick( mouseX, mouseY, mouse.button )
                }
            }
            onPressed:
            {
                parent.focus = true
                MainApplication.mouseDown( mouseX, mouseY, mouse.button )
            }
            onReleased:
            {
                MainApplication.mouseUp( mouseX, mouseY, mouse.button )
            }
            onPositionChanged:
            {
                MainApplication.mouseMove( mouseX, mouseY, pressedButtons )
            }
            onDoubleClicked:
            {
                parent.focus = true
                MainApplication.mouseDoubleClicked( mouseX, mouseY, mouse.button, mouse.modifiers )
            }
            onWheel:
            {
                MainApplication.mouseWheel( wheel.angleDelta.y, wheel.modifiers, wheel.buttons )
            }
        }
    }

    function clearAndShowContextMenu( x, y, jsonString )
    {
        sceneMenuContextMenu.clearMenu( sceneMenuContextMenu )
        sceneMenuContextMenu.populateMenu( sceneMenuContextMenu, JSON.parse(jsonString) )
        sceneMenuContextMenu.popup()
    }
}
