import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import FlowEventTypes 1.0 // event types enumerations
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

VertexShaderInNode
{
   id                      : control
   objectName              : "VertexShaderNode"
   property var lastPort   : null
   Component.onCompleted:
   {
      setTitle("Vertex Output")
     
      addOutputItem    ( "Position",     ["vec3"] )    //mandatory field, will be gl_Position for opengl
      addOutputItem    ( "Normal",       ["vec3"] )    //mandatory field, will be gl_Position for opengl
      addOutputItem    ( "Color",        ["vec4"] ) 
      addOutputItem    ( "Tex Coord 1",  ["vec2"] ) 
      addOutputItem    ( "Tex Coord 2",  ["vec2"] ) 
      fitItemToContents() 
   }   
}