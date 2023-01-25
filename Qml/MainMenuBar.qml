import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."
MenuBar
{
    id : menuBar

    function findMenuByTitle( titleStr ){
        for (var i = 0; i < menus.length; i++) {
            var curMenu = menus[i];
            if( curMenu.title === titleStr )
                return curMenu;
        }
        return null;
    }
}
