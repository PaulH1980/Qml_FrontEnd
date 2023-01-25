import QtQuick.Controls 2.4
import QtQuick 2.7
import "Scripts/AppScripts.js" as AppScripts
import "."


Menu {
    id          : dynamicMenu

    Component {
        id: menuItem
        MenuItem {
            property var jsonObj
            action :   Action{}

            onTriggered :
            {
                root.menuItemClicked( JSON.stringify( jsonObj ) ) //emit signal
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


    /*
        @brief: Remove all (sub) menu items from this menu
    */
    function clearMenu( menuId )
    {
        while( menuId.count ) {
            menuId.removeItem( 0 )
        }
    }


    function findMenuByTitle( parentMenu, titleStr  )
    {
        var menuItems = parentMenu.contentChildren;
        for (var i = 0; i < menuItems.length; i++) {
            var curMenu = menuItems[i];
            if( curMenu.subMenu )
            {
                var subMenuTitle = curMenu.subMenu.title;
                if( subMenuTitle === titleStr )
                    return curMenu.subMenu;
            }
        }
        return null;
    }

    function createSubMenu( parentMenu, titleStr )
    {
        var subMenu = AppScripts.findMenuByTitle( parentMenu, titleStr );
        if( subMenu === null ) {
            var component = Qt.createComponent("DynamicMenu.qml");
            subMenu = component.createObject ( parentMenu );
            subMenu.title = titleStr;
            parentMenu.addMenu( subMenu )
        }
        return subMenu;
    }

    /*
        @brief: Populate menu, by means of parsing json data
    */
    function populateMenu( menuId, menuData ) {

        for ( var index in menuData.MenuData )
        {
            var itemEntry = menuData.MenuData[index];
            //Separator item?
            if( itemEntry.IsSeparator ) {
                menuId.addItem( menuSeparator.createObject( menuId ) );
            }
            else if( itemEntry.SubMenuAsJson !== undefined ) //Sub Menu Entry?
            {
                var component = Qt.createComponent("DynamicMenu.qml");
                var subMenu = component.createObject ( root )
                subMenu.title = itemEntry.ItemName;
                //add to parent menu
                menuId.addMenu( subMenu );
                //'recurse' with child menu
                subMenu.populateMenu( subMenu, itemEntry.SubMenuAsJson )
            }
            else //regular menu item
            {
                var newItem  = menuItem.createObject( root )
                newItem.action.text     = itemEntry.ItemName
                newItem.action.shortcut = itemEntry.ShortCut
                newItem.jsonObj  = itemEntry; //store additional meta data as json
                menuId.addItem( newItem );  //add to menu
            }
        }
        return menuId;
    }
}
