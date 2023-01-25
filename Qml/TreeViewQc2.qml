import QtQuick 2.7
import QtQuick.Controls 2.2
import "Scripts/AppScripts.js" as AppScripts

Column {
    width: parent.width
    height: parent.height
    

    property alias model        : columnRepeater.model
    property string qmlDelegate : "TreeItemQc2.qml"
 

    ListView {
        
        id                  : columnRepeater
        delegate            : accordion
        width               : parent.width
        height              : parent.height
        spacing             : 5
        clip                : true
        model               : ListModel { }
        ScrollBar.vertical  : ScrollBar { }
    }

    Component {
        id                  : accordion

        Column {
            id              : itemColumn
            width           : parent.width
            spacing     : 5

            Loader {
                id      : itemLoader
                source  : qmlDelegate
                onLoaded:
                {
                    item.object = itemColumn.ListView.view.model.get( index ) //store whole json object in delegate 
                    item.indexOf = index //index of item in listview
                    //each item should at least have a 'type' and a 'label'
                    item.text = item.object.label
                    item.type = item.object.type  
                }
            }

            ListView {
                
                id          : subentryColumn
                x           : 20
                spacing     : 5
                width       : parent.width - x
                height      : childrenRect.height * opacity
                visible     : opacity > 0
                opacity     : itemLoader.item.expanded ? 1 : 0
                delegate    : accordion
                model       : childrens ? childrens : []
                interactive : false
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }            
        }
    }

    function clear()
    {
        model.clear()
    }

    function addItem( sectionName, jsonObj )
    {
        var section = createSection( sectionName )
        if( section === null ) {
             throw new Error( "Create Section Failed" )
        }
        section = findSection( sectionName )
        var curModel = section.childrens       
        curModel.append( jsonObj )
    }


    function findSectionInModel( curModel, sectionName  ) {
        for( var i = 0; i < curModel.count; ++i ) {
            const child    = curModel.get( i )
            if( child.label === sectionName && child.type === "section" ) 
                return child            
        }
        return null
    }


    /*
        @brief: Create a new section, return model of section
    */
    function createSection( splitPaths  ) {
        var curModel = model       
        for( var i in splitPaths ) {
            var curPath = splitPaths[i]           
            var result  = findSectionInModel( curModel, curPath )
            if( result === null ){ //no (sub) item found create new
                var obj = {
                    "childrens" : [],
                    "label" : curPath,
                    "type" : "section"
                };
                const index   = curModel.count
                curModel.append( obj )                
                result = curModel.get( index )
            }
            if( result )//adjust model for next iteration
                curModel = result.childrens
            else{ //oops
                curModel = null
                throw new Error( "Invalid Model" )
            };
        }
        return curModel
    }

    function findSection( splitPaths ) {
        var curModel = model        
        var result = null;
        for( var i in splitPaths ) {
            const curPath = splitPaths[i]           
            result  = findSectionInModel( curModel, curPath )
            if( result === null )
                return null
            curModel = result.childrens
        }
        //made it all the way to the end section found
        return result
    }

}
