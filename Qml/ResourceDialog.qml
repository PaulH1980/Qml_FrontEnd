import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 2.4

import RoleEnums 1.0





Dialog{
    id          : resourceDialog;
    objectName  : "resourceDialog"

    width  : 640
    height : 480
    title: "Create Resource"
    standardButtons: Dialog.Ok | Dialog.Cancel
    onAccepted: {
        root.resourceDialogOkCancelClicked(Dialog.Ok);
    }
    onRejected: {
        root.resourceDialogOkCancelClicked(Dialog.Cancel);
    }


    function toggleGroupVisibility( name )
    {
        var numItems = listViewId.model.numItems();
        for( var i = 0; i < numItems; ++i  )
        {
            if( listViewId.model.getSectionName(i) === name )
            {
                listViewId.model.toggleVisibility( i )
            }
        }
    }

    ListView
    {
        signal sectionClicked(string name)

        onSectionClicked: {
            toggleGroupVisibility( name )
        }

        id				: listViewId
        width 			: parent.width
        height 			: parent.height
        clip 			: true
        orientation		: Qt.Vertical
        spacing			: 0
        model			: ResourceModel
        delegate: Component
        {
            Loader
            {
                source				: qmlFile //defined as role
                width 				: parent.width
                height  			: item.getHeight()
                visible				: isVisible
                onLoaded:
                {
                    item.mRoleType        = roleType;
                    item.mIndexOf         = itemIndex;
                    item.mDescription	  = inputTitle;
                    item.mJsonObj         = JSON.parse(dataAsJson); //includes global data
                    item.propertyDataJson = item.mJsonObj.BackEndProperty;
                }

                Component.onCompleted:
                {
                    item.updateItem(); //'virtual function' call
                }

                Connections
                {
                    target: item
                    onJsonObjectChanged:
                    {
                        var jsonString = JSON.stringify( jsonObject );
                        listViewId.model.updateDataFromJson( item.mIndexOf, jsonString, item.mRoleType );
                    }
                }
            }
        }
        section.property: "sectionName"
        section.criteria: ViewSection.FullString
        section.delegate: Component
        {
            Loader
            {
                source 			: "PropertyGridSection.qml"
                width 		  	: listViewId.width

                Component.onCompleted:
                {
                    item.sectionPressed.connect( listViewId.sectionClicked )
                }
            }
        }
    }
}


