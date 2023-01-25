import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowArithmetricNode
{
    id                        : splitRotation

    Component.onCompleted:
    {
        setTitle        ( "Split Rotation" )
        addOutputItem   ( "Pitch"   )
        addOutputItem   ( "Roll"    )
        addOutputItem   ( "Yaw"     )       
        addInputItem    ( "In"      )              
        fitItemToContents()
    }   
}