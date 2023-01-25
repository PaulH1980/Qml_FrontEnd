fimport QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.1
import "."

PropertyGridItemBase 
{

    id									: textureInputId
    mPropHeight							: 100
    property int imageRectHeight		: 96
    property int imageHeight			: imageRectHeight - 4

    RowLayout
    {
        anchors.fill	: parent
        anchors.margins : 2
        spacing			: 2

        Rectangle
        {
            Layout.preferredHeight	: mPropHeight
            Layout.minimumWidth	 	: Style.rightSidePanelTitleWidth
            Layout.maximumWidth	 	: Style.rightSidePanelTitleWidth
            Layout.preferredWidth	: Style.rightSidePanelTitleWidth
            anchors.top				: parent.top
            id						: titleId
            color					: Style.defaultBackGroundColor
            Text
            {
                id						  	: textId
                width						: parent.width
                text					  	: mDescription
                font.pixelSize			  	: Style.defaultFontSize
                font.family				  	: Style.defaultFont
                color					  	: "White"
                horizontalAlignment			: Text.AlignLeft
                anchors.centerIn			: parent
            }
        }

        Item
        {
            Layout.preferredHeight	: imageRectHeight
            Layout.preferredWidth	: 160
            anchors.top				: parent.top
            id						: itemPlaceHolder
        }

        Rectangle //texture preview
        {
            id						: texturePreview
            width					: imageRectHeight
            height					: imageRectHeight
            color					: Style.defaultBackGroundColor
            border.width			: 1
            border.color			: "Black"
            Image
            {
                id					: imageId
                anchors.centerIn	: parent
                width				: imageHeight
                height				: imageHeight
                sourceSize.width	: imageHeight
                sourceSize.height	: imageHeight

                asynchronous 		: true
                source				: textureInputId.mImageSource
            }
            MouseArea
            {
                anchors.fill 	: texturePreview
                acceptedButtons : Qt.LeftButton
                cursorShape		: Qt.PointingHandCursor

                onClicked:
                {
                    fileDialog.open()
                }
            }
        }
    }

    FileDialog
    {
        id: fileDialog
        selectExisting	: true
        selectMultiple	: false
        //folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        title: "Please Choose A File"
        nameFilters: [ "Image Files (*.png *.jpg *.jpeg *.bmp *.tga)",
            "JPG Files (*.jpg)",
            "PNG Files (*.png)",
            "BMP Files (*.bmp)",
            "TGA Files (*.tga)"
        ]
        onAccepted: {
            //console.log("You chose: " + fileDialog.fileUrls)
            textureInputId.mImageSource = fileDialog.fileUrl
            close();
        }
        onRejected:
        {
            close()
        }
    }
}
