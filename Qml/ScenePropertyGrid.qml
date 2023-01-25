import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."
RectContainer
{
    anchors.fill : parent
    PropertyGrid
    {
        id					: propGrid
        anchors.fill 		: parent
        anchors.margins     : 3    
    }    

    function setModel( newModel )
    {
        propGrid.setModel( newModel )
    }

    function setDelegate( newDelegate ) 
    {
       propGrid.setDelegate( newDelegate )
    }
}

