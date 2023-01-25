
import QtQuick 2.7

Component
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
            //subscribe to section header clicks
            target : listViewId
            onSectionClicked:
            {
                item.sectionClicked( name, expanded )
                console.log( 'clicked' )
            }
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
