import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."
ToolBar
{
    id          : flowToolBar

    signal      importNodes()
    signal      exportNodes()
    signal      copySelection()
    signal      pasteSelection()
    signal      cloneSelection()
    signal      groupSelection()
    signal      unGroupSelection()
    signal      clearAll()
    signal      zoomIn()
    signal      zoomOut()
    signal      zoomExtents()
    signal      compileFlowDiagram()


    Component
    {
        id : toolbarSeparator
        Rectangle
        {
            
        }
    }

    RowLayout
    {
        anchors.fill: parent
        spacing : 16

        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.folderOpen
            ToolTip.text            : qsTr("Import")
            onClicked: {
                importNodes()
            }
        }

        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.save
            ToolTip.text            : qsTr("Export")
            onClicked: {
                exportNodes()
            }
        }

        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.copy
            ToolTip.text            : qsTr("Copy")
            onClicked: {
                copySelection()
            }
        }
        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.paste
            ToolTip.text            : qsTr("Paste")
            onClicked: {
                pasteSelection()
            }
        }

        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.clone
            ToolTip.text            : qsTr("Clone")
            onClicked: {
                cloneSelection()
            }
        }
        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.remove
            ToolTip.text            : qsTr("Delete")
            onClicked: {
                exportNodes()
            }
        }


        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.searchMinus
            ToolTip.text            : qsTr("Zoom-Out")
            onClicked: {
                zoomOut()
            }
        }

        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.searchPlus
            ToolTip.text            : qsTr( "Zoom-In" )

            onClicked: {
                zoomIn()
            }
        }

        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.searchPlus
            ToolTip.text            : qsTr( "Zoom-Extents" )

            onClicked: {
                zoomExtents()
            }
        }


        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.eraser
            ToolTip.text            : qsTr( "Clear All" )

            onClicked: {
                clearAll()
            }
        }


        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.objectGroup
            ToolTip.text            : qsTr("Group Current Selection")
            onClicked: {
                groupSelection()
            }
        }
        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.objectUngroup
            ToolTip.text            : qsTr("Un-Group Current Selection")
            onClicked: {
                unGroupSelection()
            }
        }

        ToolBarButton
        {
            Layout.minimumWidth		: 32
            Layout.preferredWidth   : 32
            iconName                : FontAwesome.play
            ToolTip.text            : qsTr("Compile Current Flow")
            onClicked: {
                compileFlowDiagram()
            }

        }

        Item { Layout.fillWidth: true; height: 1 }
    }
}
