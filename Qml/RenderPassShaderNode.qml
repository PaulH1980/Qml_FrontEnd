import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import FlowEventTypes 1.0 // event types enumerations
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

ShaderBlockNodeBase
{
    id                      : renderPassFlowNode

    Component.onCompleted:
    {
        setTitle        ( "RenderPass" )
        addOutputItem   ( "Output" , "RenderPass" )
        addInputItem    ( "Fragment Shader"   ,     ["FragmentShader"] )
        addInputItem    ( "Depth State"   ,         ["DepthState"] )
        addInputItem    ( "Blend State"   ,         ["BlendState"] )
        addInputItem    ( "Stencil State",          ["StencilState"] )
        addInputItem    ( "Color Mask"   ,          ["ColorMaskState"] )
        addInputItem    ( "Rasterizer State"   ,    ["RasterizerState"] )

        fitItemToContents()
    }
}