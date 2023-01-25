import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Qt.labs.folderlistmodel 2.12
import "Scripts/AppScripts.js" as AppScripts
import "."
Column
{
    signal   fileActivated( string fileName )
    signal   folderChanged( string folderName )  
    signal   itemSelected ( var item )

    property var  theModel      : null
    property bool isSelected    : false
    

    id                          : imageHolder
    property bool isFolder      : false
    property string curFileName : fileName   
    property int type           : 0
    property int modelIndex     : -1

    RectContainer
    {
        width   : dimensions
        height  : dimensions
        id      : container
        //invisible drag item
        ResourceDragItem
        {
            id           : dragItem
            anchors.fill : container
            visible      : false
            dragActive   : mouseArea.drag.active
            parentItem   : imageHolder
        }
       
        MouseArea
        {
            id              : mouseArea
            anchors.fill    : parent    
            drag.target     : isFolder ? null : dragItem

            onClicked:
            {
                //select item
                if( AppScripts.isMouseCondition( 
                    mouse, Qt.LeftButton, Qt.ControlModifier ) )
                {
                     itemSelected( imageHolder ) //emit signal
                }
            }

            onPressed: {
                  dragItem.droppedTarget = null
                  container.grabToImage( function( result ) {
                         dragItem.Drag.imageSource = result.url } );
               
            }
            onReleased : {                
                if( dragItem.droppedTarget != null )
                {
                    console.log( "Dropped onto " + dragItem.droppedTarget )
                }  
                dragItem.droppedTarget = null;
            }

            onDoubleClicked:
            {
                if( mouse.button === Qt.LeftButton )
                {
                    if( isFolder ) {
                        theModel.folder = theModel.folder + "/" + fileName
                        folderChanged( theModel.folder )
                    }
                    else {
                        fileActivated( theModel.folder + "/" + fileName )
                    }
                }
            }
        }

        Loader {
            anchors.fill : parent
            sourceComponent: isFolder
                             ? folderIcon
                             : thumbNail
        }
    }
    Text
    {
        width                 : dimensions
        font.pixelSize		  : 16
        font.family		      : Style.defaultFont
        color				  : isSelected ? "Red" : "White"
        text                  : fileName
        clip                  : true
    }

    Component
    {
        id : folderIcon
        Item
        {
            anchors.fill            : parent
            anchors.margins         : 2
            property alias iconName : icon.text

            Text
            {
                id                  : icon
                anchors.centerIn    : parent
                font.pixelSize	    : dimensions - 16
                font.family		    : FontAwesome.fontFamily
                text                : FontAwesome.folderOpen
                color				: "White"
            }
        }
    }

    Component.onCompleted :
    {
        isFolder = theModel.isFolder( modelIndex )
    }


    Component
    {
        id          : thumbNail
        ImageComponent
        {
            imgSource : theModel.folder + "/" + fileName
        }
    }



    function getPath() 
    {
        if( isFolder )
            return theModel.folder
        return theModel.folder + "/" + fileName
    }

}

