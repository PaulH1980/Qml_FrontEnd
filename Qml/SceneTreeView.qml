import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.2 //selectionmodel
import RoleEnums 1.0    //enums from backend
import "."

RectContainer
{
    anchors.fill    : parent
    anchors.margins : 3
    id              : treeViewId   

    function parseJson( jsonString )
    {
        if( jsonString.length )
            return JSON.parse( jsonString );
        return undefined;
    }

    TreeView
    {

        id                      : treeViewComp
        model                   : SceneModel
        clip 			        : true
        alternatingRowColors    : false
        frameVisible            : false
        headerVisible           : false
        anchors.fill            : parent

        selection: ItemSelectionModel
        {
            model: SceneModel
            onCurrentChanged:
            {

            }
        }
        style: TreeViewStyle
        {
            backgroundColor     : Style.leftSidePanelColor
            branchDelegate: Rectangle
            {
                width   : Style.treeViewItemDefaultHeight
                height  : Style.treeViewItemDefaultHeight
                color   : styleData.isExpanded ? "green" : "red"
            }
            rowDelegate: Rectangle
            {
                color: "pink"
                width   : Style.treeViewItemDefaultHeight
                height  : Style.treeViewItemDefaultHeight
            }
            itemDelegate: SceneTreeItem
            {
                itemText        : model.itemName //role
                contextMenuData : parseJson( model.contextMenu )
            }
        }
        TableViewColumn
        {
            role: "itemName"
            width: parent.width
        }

        //signals
        onActivated:
        {
            model.itemActivated(index);
        }



    }
}
