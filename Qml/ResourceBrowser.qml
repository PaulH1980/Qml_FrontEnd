import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Qt.labs.folderlistmodel 2.12
import "."

RectContainer
{
    signal          fileActivated( string fileName )
    signal          imageActivate( var image )

    
    height                          : 320
    id                              : control
    property int dimensions         : 128
    property int itemDimensions     : 160    
    property var selectedObjects    : []
    
    ResourceToolBar
    {
        anchors.left  : control.left
        anchors.right : control.right
        anchors.top   : control.top
        id            : resourceToolbar //contextual toolbar for scene

        onSetIconSize:
        {
            dimensions = value           
            itemDimensions = value + ( value / 4 )
            resetView()
        }
        onSetFilenameFilter:
        {
            resourceModel.nameFilters = fileExtensions
            resetView()
        }
    }

    //Reset viewport to origin
    function resetView()
    {
        gridView.contentX = 0
        gridView.contentY = 0
    }


    RectContainer
    {
        anchors.left    : control.left
        anchors.right   : control.right
        anchors.top     : resourceToolbar.bottom
        anchors.bottom  : control.bottom
        anchors.margins : 3
        

        FolderListModel
        {
            id              : resourceModel
            showDirs        : true
            showDirsFirst   : true
            showDotAndDotDot: true
            nameFilters     : [ "*.jpg", "*.png", "*.bmp", "*.jpeg" ]
        }

        Component
        {
            id              : imageDelegate
            ResourceBrowserItem //preview item + handler
            {
                theModel    : resourceModel
                modelIndex  : index
                
                onFileActivated: {
                    control.fileActivated( fileName )
                }

                onFolderChanged: {
                    clearSelection()                    
                }
            }
        }

        GridView
        {
            id                      : gridView
            clip                    : true
            focus                   : true
            ScrollBar.vertical      : ScrollBar { }
            anchors.fill            : parent
            layoutDirection         : Qt.LeftToRight
            cellWidth               : itemDimensions
            cellHeight              : itemDimensions
            model                   : resourceModel
            delegate                : imageDelegate

            /*MouseArea
            {
                property bool selected : false
                anchors.fill : parent
                propagateComposedEvents : true
                onClicked:
                {
                    console.log( "selecting items " + gridView.model.count + " "  + gridView.data.length)
                }
            }*/
        }
    }


    function clearSelection()
    {
        console.log("Clear Resource Selection")
    }

    function getElementByIndex( idx )
    {
        if( gridView.count <= 0  )
            return null
        
    }

   
    function selectItems( selected )
    {
        var children = gridView.contentItem.children
        for( var i in children ) {
            var child = children[i]
            if( child instanceof ResourceBrowserItem )
                child.isSelected = selected            
        }
    }


}

