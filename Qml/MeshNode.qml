import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import FlowEventTypes 1.0 // event types enumerations
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

FlowOutputNodeBase
{
   id                      : control
   objectName              : "VertexShader"
   property var lastPort   : null
   Component.onCompleted:
   {
      setTitle("Vertex Output") 
     
      addInputItem    ( "Position",  ["vec4"]  )    //mandatory field, will be gl_Position for opengl
      addInputItem    ( "PointSize", ["float"] )    //optional pointsize field
      addNewItem()
      fitItemToContents() 
   }   

   function addNewItem( )
   {
      lastPort = addInputItem( "New", ["any"] )
      lastPort.connectionAdded.connect( newConnectionAdded )
   }

   function newConnectionAdded(portId, connection)
   {
        if( lastPort === portId )
        {
            addNewItem()
            fitItemToContents() 
        }
   }
}