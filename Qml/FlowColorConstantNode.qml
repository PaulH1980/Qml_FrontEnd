import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import QtQml.Models 2.1
import "."

FlowConstValueNode
{
    id                          : control
    constantValue               : Qt.rgba( 0.5, 0.5, 0.5, 1.0 )
    objectName                  : "FlowColorIn"
       

    Component.onCompleted:
    {
        setWidth        ( 256     )
        setTitle        ( "Color" )
        addOutputItem   ( "RGBA"   , FlowConfig.vec4fMask, getObjectName )
        addOutputItem   ( "R"      , FlowConfig.vec1fMask,  function(){ return getObjectName() + ".x" } )
        addOutputItem   ( "G"      , FlowConfig.vec1fMask,  function(){ return getObjectName() + ".y" } )
        addOutputItem   ( "B"      , FlowConfig.vec1fMask,  function(){ return getObjectName() + ".z" } )
        addOutputItem   ( "A"      , FlowConfig.vec1fMask,  function(){ return getObjectName() + ".w" } )
        
        var previewItemArgs = {
            "x"                 : 8,
            "y"                 : 8,
            "width"             : 196,
            "rgba"              : constantValue,
            "leftMargin"        : 0,
            "rightMargin"       : 0,
            "showLabels"        : true,
            "redLabel"          : "R:",
            "greenLabel"        : "G:",
            "blueLabel"         : "B:",
            "alphaLabel"        : "A:",
            "labelWidth"        : 24,
            "colorWheelBackground" : "transparent"
        };
        previewItem = addPreviewItemToBase( "ColorWidget.qml", previewItemArgs )

        

        fitItemToContents()
        
        setHeight       ( 320  )
        enableOutPorts  ( true )
    }
    
    function toCpp()
    {
        
    }

    function toGlsl()
    {
        var genCode = "vec4 " + getObjectName()
                + " = " + "vec4( "
                + (constantValue.r).toFixed(4) + ", "
                + (constantValue.g).toFixed(4) + ", "
                + (constantValue.b).toFixed(4) + ", "
                + (constantValue.a).toFixed(4) + " );\n"
        return genCode;
    }

    Connections 
    {
       target : previewItem
       onColorChanged :
       {
            constantValue = newColor
       }
    }
}
