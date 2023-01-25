import QtQuick 2.7
import QtQml.Models 2.1
ObjectModel
{
    id                      : objModelId
    PropertyGridColor
    {
        anchors.left  : parent.left
        anchors.right : parent.right
        height        : getHeight()
        visible       : true
        propertyDataJson :
        {
            "Value" : {
                "X" : constantValue.r,
                "Y" : constantValue.g,
                "Z" : constantValue.b,
                "W" : constantValue.a
            }
        }
        Component.onCompleted:
        {
            updateItem()
        }

        onPropertyChanged:
        {
            constantValue.r = value.X
            constantValue.g = value.Y
            constantValue.b = value.Z
            constantValue.a = value.W
            previewItem.color = constantValue
        }
    }
}
