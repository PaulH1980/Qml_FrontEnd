import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."
ToolBar
{
    id          : control

    //can be added together by mask
    readonly property var    resourceExtensions: 
    [
         ["*.jpg", "*.png", "*.bmp", "*.jpeg"],
         ["*.vert", "*.frag", "*.geo", "*.comp"],
         ["*.wav", "*.ogg"],
         ["*.obj", "*.mesh"],
         ["*.flow",]
    ]

    signal      setIconSize( int value )
    signal      setFilenameFilter( var fileExtensions )

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

        Item {
            height                  : 32
            Layout.minimumWidth		: 16
            Layout.preferredWidth   : 16
        }

        ResourceComboBox
        {
            text  : "Icon Size:"
            width : 256
            model :  ListModel
            {
                ListElement { key: "Small";  value: 64  }     //pixels
                ListElement { key: "Medium"; value: 128 }     //pixels
                ListElement { key: "Large";  value: 256 }     //pixels
            }

            onComboBoxValueChanged:
            {
                setIconSize( value )
            }
        }

        ResourceComboBox
        {
            text : "Filter By:"
            width : 256
            model :  ListModel
            {
                ListElement { key: "Images";  value: 0x1            }    //mask
                ListElement { key: "Shaders"; value: 0x2            }    //mask
                ListElement { key: "Sounds";  value: 0x4            }    //mask
                ListElement { key: "Meshes";  value: 0x8            }    //mask
                ListElement { key: "Flow Events";    value: 0x10           }    //mask
                ListElement { key: "All";     value: 0xFFFFFFFF     }    //mask
            }

            onComboBoxValueChanged:{
                 setFilenameFilter( getCombinedFileExtensions( value ) )
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
        //fill remaining witdth
        Item { Layout.fillWidth: true; height: 1 }
    }

    function getCombinedFileExtensions( mask )
    {
        var result = []
        for( var i = 0; i < 5; ++i ) {
            const setBits = mask & ( 1 << i )            
            if( 0 !== setBits ){
                result = result.concat( resourceExtensions[i] ) 
            }
        }
        return result        
    }

}
