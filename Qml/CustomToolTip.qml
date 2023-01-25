
import QtQuick 2.8
import QtQuick.Templates 2.1 as T
import QtQuick.Controls.Universal 2.1
import "."

T.ToolTip 
{
    id: control

    x: parent ? (parent.width - implicitWidth) / 2 : 0
    y: -implicitHeight - 16

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)

    margins: 8
    padding: 8
    topPadding: padding - 3
    bottomPadding: padding - 1

    closePolicy: T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent | T.Popup.CloseOnReleaseOutsideParent

    contentItem: Text {
        text						: control.text
        font.pixelSize				: 16
		font.family					: "Helvetica"
		color						: "White"
        opacity						: enabled ? 1.0 : 0.2
    }

    background: Rectangle {
        color			: Style.lightBackGroundColor
        border.color	: Style.defaultBorderColor
        border.width	: 1 // ToolTipBorderThemeThickness
    }
}