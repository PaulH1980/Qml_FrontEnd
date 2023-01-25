import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtQuick.Dialogs 1.2 

import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts

Item
{
    id      : flowWidget
    focus   : true

    FlowToolBar
    {
        anchors.left  : parent.left
        anchors.right : parent.right
        anchors.top   : parent.top
        id            : flowToolbar //contextual toolbar for scene
                
        onImportNodes: {
            importFlowSelectionDialog.open()
        }
        onExportNodes: {
            exportFlowSelectionDialog.jsonStr = JSON.stringify( flowRenderControl.serialize() )
            exportFlowSelectionDialog.open()                            
        }
        
        onCopySelection: {
            flowRenderControl.copySelection()
        }
        onPasteSelection:{
            flowRenderControl.pasteSelection()
        }
        onCloneSelection:{
            flowRenderControl.cloneSelection()
        }
        onUnGroupSelection:{

        }
        onGroupSelection:{

        }      
      
        onZoomIn: {
            flowRenderControl.zoomCentered( true )
        }
        onZoomOut:{
            flowRenderControl.zoomCentered( false )
        }
        onZoomExtents: {
            flowRenderControl.zoomExtents()
        }
        onCompileFlowDiagram:{
            flowRenderControl.compileAndRun()
        }
        onClearAll: {
             flowRenderControl.clearAll()
        }
    }

    Popup {
        property alias objModel : view.model
        id                      : popup
        x                       : 100
        y                       : 100
        width                   : Style.defaultPropertyWidth
        height                  : 300
        focus                   : true
        closePolicy             : Popup.CloseOnEscape | Popup.CloseOnPressOutside

        contentItem : RectContainer
        {
            anchors.fill    : parent
            anchors.margins : 3
            ListView 
            {
                id                  : view
                anchors.fill        : parent          
            }
        }
    }

    
    FlowRenderControl
    {
        id               : flowRenderControl
        anchors.top      : flowToolbar.bottom
        anchors.left     : parent.left
        anchors.right    : parent.right
        anchors.bottom   : parent.bottom

        onFlowDiagramCompiled:
        {
            if( succeed )
                flowGlslCodeGenerated( code )       
        }

        Connections
        {
            target              : root
            onFlowNodeEditRequested:
            {
                 var model      = node.getPropertyModel();
                 popup.objModel = model
                 popup.height   = model.get(0).getHeight()  + 30
                 popup.open()
            }  
        }
    }

    FileDialog //export dialog
    {
        id                      : exportFlowSelectionDialog
        title                   : qsTr("Export Flow Selection")
        nameFilters             : ["Flow Nodes (*.flow)"]
        selectExisting          : false
        property string jsonStr : null
        onAccepted              : {
            AppScripts.saveFile(  exportFlowSelectionDialog.fileUrl, jsonStr )
            console.log( "Selection Exported To " +  exportFlowSelectionDialog.fileUrl )
        }
    }

    FileDialog //import dialog
    {
        id                      : importFlowSelectionDialog
        title                   : qsTr("Import Flow Selection")
        nameFilters             : ["Flow Nodes (*.flow)"]       
        onAccepted              : {
            var jsonStr = AppScripts.openFile( importFlowSelectionDialog.fileUrl )
            if( jsonStr.length ) {   
                var jsonObj = JSON.parse( jsonStr )
                if( jsonObj )
                    flowRenderControl.deSerialize( jsonObj )
            }           
        }
    }    
}


