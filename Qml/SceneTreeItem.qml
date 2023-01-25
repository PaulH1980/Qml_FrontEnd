import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import RoleEnums 1.0
import "."
Item{

    property color  itemColor           : Style.leftSidePanelColor
    property string itemText            : "PlaceHolder"
    property int    itemType            : -1
    property var    contextMenuData     : undefined


    id                          : sceneTreeItemId
    width                       : parent.width
    height                      : Style.treeViewItemDefaultHeight

    Rectangle{
        anchors.fill    : parent
        color           : itemColor
        Text
        {
            anchors.verticalCenter      : parent.verticalCenter
            anchors.left                : parent.left
            height                      : parent.height

            text                        : itemText
            font.pixelSize			  	: Style.defaultFontSize
            font.family				  	: Style.defaultFont
            color					  	: Style.defaultFontColor
            horizontalAlignment			: Text.AlignLeft
        }

        MouseArea
        {
            id: mouse
            acceptedButtons : Qt.RightButton
            anchors.fill    : parent
            onClicked:
            {
                if( contextMenuData !== undefined )
                {
                    itemContextMenu.clearMenu( itemContextMenu )
                    itemContextMenu.populateMenu( itemContextMenu, contextMenuData )
                    itemContextMenu.popup()
                }
            }
            DynamicMenu
            {
                id:     itemContextMenu
            }
        }

    }
}
