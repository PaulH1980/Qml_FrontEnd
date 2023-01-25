import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowArithmetricNode
{
    id                        : splitRgba

    Component.onCompleted:
    {
        setTitle        ( "Split Rgba" )
        addOutputItem   ( "R"   ,  FlowConfig.vec1fMask  , function(){ return getObjectName() + ".r" } ) 
        addOutputItem   ( "G"   ,  FlowConfig.vec1fMask  , function(){ return getObjectName() + ".g" } ) 
        addOutputItem   ( "B"   ,  FlowConfig.vec1fMask  , function(){ return getObjectName() + ".b" } ) 
        addOutputItem   ( "A"   ,  FlowConfig.vec1fMask  , function(){ return getObjectName() + ".a" } ) 
        addInputItem    ( "In",    [FlowConfig.vec4fMask]  )    
        fitItemToContents()
    }   
}