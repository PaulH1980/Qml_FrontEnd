import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowUnaryNode
{
    id                      : negateNode   
    objectName              : "Negate"

    Component.onCompleted:
    {
        setTitle        ( "Negate" )
        addOutputItem   ( "Out", FlowConfig.noneMask , getObjectName  )
        addInputItem    ( "In" , FlowConfig.anyMask )        
        fitItemToContents()
    }
}