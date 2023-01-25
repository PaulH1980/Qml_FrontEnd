import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowUnaryNode
{
    id                        : conversionNodeNode
    property int  inputType   : FlowConfig.pendingOperand
    property int  outputType  : FlowConfig.pendingOperand

    Component.onCompleted:
    {
        setTitle        ( "FromTo" )
        addOutputItem   ( "Out", FlowConfig.noneMask, getObjectName  )
        addInputItem    ( "In" , FlowConfig.anyMask )
        fitItemToContents()
    }
}
