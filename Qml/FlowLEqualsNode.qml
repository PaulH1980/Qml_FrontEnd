import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowBinaryNode
{
    id                      : minusNode
    operation               : FlowConfig.lEqualsOperation

    Component.onCompleted:
    {
        setTitle        ( "Less Equal" )
        addOutputItem   ( "Out" , FlowConfig.noneMask )
        addInputItem    ( "A"   , [FlowConfig.vec1fMask, FlowConfig.vec1iMask] )
        addInputItem    ( "B"   , [FlowConfig.vec1fMask, FlowConfig.vec1iMask] )
        fitItemToContents()
    }
}
