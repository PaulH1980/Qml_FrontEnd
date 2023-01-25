import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowOutputNodeBase
{
    id                        : flowPixelShaderOutput
    property bool isQmlShader : false //qml compatible shader

    Component.onCompleted:
    {
        setTitle        ( "Pixel Shader" )
        addInputItem    ( "Albedo" ,     [FlowConfig.vec3fMask] )
        if( !isQmlShader ) {
            addInputItem    ( "Normal" ,     [FlowConfig.vec3fMask] )
            addInputItem    ( "Emissive",    [FlowConfig.vec3fMask] )
            addInputItem    ( "PlaceHolder", [FlowConfig.vec3fMask] )
        }
        addInputItem    ( "Opacity" ,     [FlowConfig.vec1fMask] )
        if( !isQmlShader ) {
            addInputItem    ( "Height" ,      [FlowConfig.vec1fMask] )
            addInputItem    ( "Roughness" ,   [FlowConfig.vec1fMask] )
            addInputItem    ( "Metalness",    [FlowConfig.vec1fMask] )
        }
        fitItemToContents()
    }

    onInPortConnectionRemoved:
    {
        
    }

    function toCpp()
    {
        
    }

    function toGlsl()
    {
        var shaderOutputs =[]
        if( isQmlShader )
        {
            shaderOutputs = [ "gl_FragColor.rgb = ",
                             "gl_FragColor.a = "
                    ]
        }
        else
        {
            shaderOutputs = [ "gl_FragData[0].rgb = ",
                             "gl_FragData[1].rgb = ",
                             "gl_FragData[2].rgb = ",
                             "gl_FragData[3].rgb = ",

                             "gl_FragData[0].a = ",
                             "gl_FragData[1].a = ",
                             "gl_FragData[2].a = ",
                             "gl_FragData[3].a = "
                    ]
        }
        
        var genCode = ""
        const inputPorts = getInputPorts()
        for( var i in inputPorts ) {
            const connection = inputPorts[i].incomingConnection
            if( connection !== null ) {
                const curLayer = shaderOutputs[i] + connection.getVariableName() + ";\n"
                genCode += curLayer;
            }
        }

        return genCode;
    }

    function reset()
    {

    }

}
