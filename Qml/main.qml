import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

Item
{
    //emitted when one of the drop down menu items is clicked
    signal          menuItemClicked( string jsonArgs )
    signal          resourceDialogOkCancelClicked( int returnCode )
    signal          requestSceneContextMenu( int x, int y, string contextMenuData )
    /*
        @brief: Request for FlowNode edit
    */
    signal          flowNodeEditRequested( var node )
    /*
        @brief: Node was selected
    */
    signal          flowNodeSelected( var node )
    /*
        @brief: New glsl code generated
    */
    signal          flowGlslCodeGenerated( string code )

    /*
        @brief: Main tab-view changed
    */
    signal          mainViewTabChanged( int index )

    /*
        @brief: 0 = Scene Editor
                1 = Flow Editor
    */
    readonly property int defaultTab : 1 //flow

    /*
        @brief: proxy object for dragging
    */
    property var    dragProxy : null

    id 				: root
    objectName 		: "rootItem"
    focus			: true

    ConsolePopup
    {
        id          : consolePopup
    }

    MainMenuBar
    {
        id              : menubar
        anchors.left    : root.left
        anchors.right   : root.right
    }

    HeaderToolBar
    {
        anchors.left  : root.left
        anchors.right : root.right
        anchors.top   : menubar.bottom
        id            : toolBar
    }

    FooterStatusBar
    {
        id              : footer
        anchors.left    : root.left
        anchors.right   : root.right
        anchors.bottom  : root.bottom
    }   
    
   
    //tab menu bar
    MainViewTabBar
    {
         anchors.left    : root.left
         anchors.right   : root.right
         anchors.top     : toolBar.bottom
         id              : mainTabBar
    }
    
    LeftSidePanel
    {
        id              : leftSidePanel
        anchors.top     : mainTabBar.bottom
        anchors.bottom  : footer.top
        anchors.left    : root.left
    }
 
    RightSidePanel
    {
        id              : rightPanel
        anchors.top     : mainTabBar.bottom
        anchors.bottom  : footer.top
        anchors.right   : root.right
    }    

    Console
    {
        height          : 300
        anchors.bottom  : footer.top
        anchors.left    : leftSidePanel.right
        anchors.right   : rightPanel.left
        visible         : false
        id              : userConsole
    }


    MainPanel
    {
        anchors.top    : mainTabBar.bottom
        anchors.left   : leftSidePanel.right
        anchors.right  : rightPanel.left
        anchors.bottom : footer.top
        focus          : true
    }

    Component.onCompleted:
    {
        AppGlobal.print2();
        console.log( "Hello " + AppGlobal.eventTypeForId( 33 ).EventName);

    }

    function createAndReturnComponent( file, parent, args )
    {
        var component = Qt.createComponent(file);
        if (component.status !== Component.Ready) {
             console.log( "Error Creating Component: " + component.errorString() )
             return null
        }
        return  component.createObject( parent, args )    
    }

    function setToolInfo( toolInfo )
    {
        footer.toolText = toolInfo
    }

    function setSelModeInfo( sel )
    {
        footer.selModeText = sel
    }

    function showCreateResourceDialog( jsonString )
    {
        var comp           = Qt.createComponent("ResourceDialog.qml");
        var theDialog      = comp.createObject( root, {} );
        theDialog.visible  = true
    }

    function addToolMenuEntry( toolSubMenu, menuData  )
    {
        var toolsMenu = getToolsMenu();
        var menuToAddItems = toolsMenu;
        var menuAsJson = JSON.parse( menuData );             
        for( var i = 0; i < menuAsJson.MenuData.length; ++i )
        {
            var itemEntry = menuAsJson.MenuData[i];
            var toolArgs  = itemEntry.CommandArgsAsJson;
            if( ( toolArgs !== undefined ) && (toolArgs.ToolsSubMenu !== undefined) )
            {
                 menuToAddItems = toolsMenu.createSubMenu( toolsMenu, toolArgs.ToolsSubMenu );
            }  
        }
        menuToAddItems.populateMenu( menuToAddItems, menuAsJson );
        return true;
    }    

    function getToolsMenu( menuData )
    {
        var toolMenuName = "&Tools";
        var curMenu = menubar.findMenuByTitle( toolMenuName );
        if(curMenu === null ) {
            var component = Qt.createComponent("DynamicMenu.qml");
            curMenu = component.createObject ( menubar );
            menubar.addMenu(  curMenu )
            curMenu.title = toolMenuName;
        }
        return curMenu;
    }
    
    function addMenuEntry( menuTitle, menuData )
    {
        var curMenu = menubar.findMenuByTitle( menuTitle );
        //first time initialize
        if( curMenu === null ) {
            var component = Qt.createComponent("DynamicMenu.qml");
            curMenu = component.createObject ( menubar );
            menubar.addMenu(  curMenu )
            curMenu.title = menuTitle;
        }
        //only add items if menu & data is considered valid
        if( curMenu !== null && ( menuData !== null && menuData.length ) )  {
            curMenu.populateMenu( curMenu, JSON.parse( menuData ) );
            return true;
        }
        return curMenu;
    }

    function registerClassDescriptionToFlowEditor( name, jsonStr, subSection )
    {
          console.log( name )    
          FlowScripts.registerFlowNodeJson
          ( 
            name, 
            subSection, 
            JSON.parse(jsonStr), //input is a string and needed for required node-reconstruction
            getFlowTreeView(), 
            getFlowContextMenu() 
          )
    }

    /*
        @brief: Register new flow node
    */
    function registerFlowNode( jsonStr )
    {
        var jsonObj = JSON.parse( jsonStr )       
        if( jsonObj.Annotations.$ShowInUi === "false" )
            return;
            
        console.log("Registering flownode " + jsonObj.Annotations.$Title )    
        FlowScripts.registerFlowNodeJson( 
            jsonObj.Annotations.$Title,
            jsonObj.Annotations.$SubSection,
            jsonObj,
            getFlowTreeView(), 
            getFlowContextMenu() 
        )       
    }

    function setMainViewContextMenuData( xPos, yPos, contextMenuData )
    {
         requestSceneContextMenu(xPos, yPos, contextMenuData )
    }


    function getFlowTreeView()
    {
        return AppScripts.findChildByObjectName( root, "flowTreeView" )      
    }

    function getFlowContextMenu()
    {
        return AppScripts.findChildByObjectName( root, "flowContextMenu" )      
    }

    
}
