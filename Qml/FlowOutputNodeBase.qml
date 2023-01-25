import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import "."

FlowNodeBase
{
    id                      : flowResultNodeBase
    property string name    : "FlowOutputNodeBase" //a property is needed for using 'instanceof'
    
    Component.onCompleted: {
        setTitleBackgroundColor( "green" )
    }
}
