import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowNodeBase
{
    id                        : ifElseNode   

    Component.onCompleted:
    {
        setTitle        ( "If Else" )
        addOutputItem   ( "Out"     , FlowConfig.noneMask )     
        addInputItem    ( "Test"    , [FlowConfig.boolMask] )
        addInputItem    ( "True"    , [FlowConfig.anyMask] )    //pass through if outcome of test is true
        addInputItem    ( "False"   , [FlowConfig.anyMask] )    //pass through if outcome of test is false
        fitItemToContents()
    }
}
