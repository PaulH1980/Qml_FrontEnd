import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "."

ToolButton 
{
    signal clickedWithId( var id )
    
    
    property int iconSize       : 32
    property string iconName    : FontAwesome.checkSquareO  
    property var    parentItem  : null
    id                          : toolbarButtonId
    hoverEnabled                : true    

    width                       : iconSize
    height                      : iconSize

    font.pixelSize	            : iconSize
    font.family		            : FontAwesome.fontFamily
    text                        : iconName

    ToolTip.delay               : 1000
    ToolTip.timeout             : 5000
    ToolTip.visible             : hovered


    onClicked: clickedWithId( toolbarButtonId )
}
