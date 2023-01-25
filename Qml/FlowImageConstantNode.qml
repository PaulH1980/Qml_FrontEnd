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
    objectName                  : "FlowImageIn"
    property var  previewImage  : null

    Component.onCompleted:
    {
        setTitle        ( "Texture2d"  )
        addOutputItem   ( "RGBA"       , "vec4",    getObjectName )
        addOutputItem   ( "R"          , "float",   function(){ return getObjectName() + ".x" } )
        addOutputItem   ( "G"          , "float",   function(){ return getObjectName() + ".y" } )
        addOutputItem   ( "B"          , "float",   function(){ return getObjectName() + ".z" } )
        addOutputItem   ( "A"          , "float",   function(){ return getObjectName() + ".w" } )

        addInputItem    ( "UV", ["vec2"] )     
        addInputItem    ( "SamplerState", ["SamplerState"] )
        
        var previewItemArgs = {
            "x"                 : 8,
            "y"                 : 40,
            "height"            : 96,
            "width"             : 96,           
        };
        previewImage = addPreviewItemToBase( "ImageComponent.qml", previewItemArgs )
        fitItemToContents()       
    }


    function setImage( fileName ) 
    {
        if( !previewImage )
            throw new Error("Invalid Preview Item" ) 
        previewImage.imgSource = fileName
        console.log( fileName )
    }

    function toCpp()
    {
        
    }

    function toGlsl()
    {
        var genCode = "sampler2d " + getObjectName() + ";\n"
        return genCode;
    }
}
