import QtQuick 2.7
import RoleEnums 1.0
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."



RectContainer
{  
    /*
        @brief: for most types can use qvariant directly
    */
    id    : listViewHolder
 
    ListView
    {
        //signal emitted when section is clicked
        signal sectionClicked( string name, bool expanded )

        id				: listViewId
        anchors.fill    : parent
        anchors.margins : 3
        clip 			: true
        orientation		: Qt.Vertical
        spacing			: 0
        model			: null
        delegate        : PropertyGridLoader{}
        section.property: "sectionName"
        section.criteria: ViewSection.FullString
        section.delegate: Component
        {
            Loader
            {
                source 			    : "PropertyGridSection.qml"
                width 		  	    : listViewId.width 
                onLoaded:
                {
                    item.sectionPressed.connect( listViewId.sectionClicked )
                    item.sectionText = section                  
                }
            }
        }
    } 

    function getModel()
    {
        return listViewId.model
    }

    function setModel( newModel )
    {
        listViewId.model = newModel
    }

    function setDelegate( val ) 
    {
        listViewId.delegate = val 
    }
    
}
