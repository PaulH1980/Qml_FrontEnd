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
      setTitle("Vertex In/Out")
     
      addInputItem    ( "Position",  ["vec4"]  )    //mandatory field, will be gl_Position for opengl
      addInputItem    ( "PointSize", ["float"] )    //[optional] pointsize field
      addNewItem()
      fitItemToContents() 
   }   

   function addNewItem( )
   {
      lastPort = addInputItem( "New", ["any"] )
      lastPort.connectionAdded.connect( newConnectionAdded )
   }

   function newConnectionAdded( portId, connection )
   {
        const outPort = connection.getOutputPort()
        
        console.assert( outPort instanceof FlowPortBaseOut, "Not An Output Port" )
        
        const name = connection.getOutputPort().text
        const type = connection.getOutputPort().outputType
        addOutputItem( name, type, getObjectName ) //add new output item
        
        console.log( "New Connection: " +  name  + " "  + type )  
        connection.getInputPort().text = name         
        
        //added to the last, create new input port
        if( lastPort === portId ) 
        {
            addNewItem()            
        }

        fitItemToContents() 
   }
}