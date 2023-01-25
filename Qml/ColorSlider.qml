import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "."

Item
{
    signal                          sliderValueChanged( var sliderVal );
    
    property alias value            : control.value
    property string name            : "RGB"
    property bool  alphaEnabled      : false

    property color startColor       : Qt.rgba( 0, 0, 0, 1 )
    property color endColor         : Qt.rgba( 1, 1, 1, 1 )
    id                              : controlHolder
    height                          : 24
    width                           : 150
    implicitHeight                  : 24

    Slider
    {
        anchors.fill    : parent
        id              : control
        value           : 128
        from            : 0
        to              : 255

        background: Item
        {
            anchors.fill       : parent
            implicitHeight     : 24
            id                 : backgroundItem
            
            Image
            {
                id              : checkerboard
                smooth          : false
                anchors.fill    : parent
                fillMode        : Image.Tile
                visible         : false
                source          : "image://QmlImageProvider/CheckerBoard"
            }

            OpacityMask
            {
                anchors.fill: parent
                source:checkerboard
                maskSource: Rectangle
                {
                    width: checkerboard.width
                    height:checkerboard.height
                    radius: 4
                    visible: false // this also needs to be invisible or it will cover up the image
                }
            }

            LinearGradient //https://stackoverflow.com/questions/42741789/qt-qml-how-to-add-lineargradient-to-a-rectangle-with-a-border
            {
                id                  : gradient
                anchors.fill        : parent
                visible             : false
                source              : checkerboard
                start: Qt.point(0, 0)
                end: Qt.point(checkerboard.width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: startColor }
                    GradientStop { position: 1.0; color: endColor }
                }
            }

            OpacityMask
            {
                anchors.fill: parent
                source:gradient
                maskSource: Rectangle
                {
                    width : backgroundItem.width
                    height: backgroundItem.height
                    radius: 4
                    visible: false // this also needs to be invisible or it will cover up the image
                }
            }

            Rectangle
            {
                anchors.fill           : parent
                color                  : "transparent"
                border.color           : Qt.rgba(20/255, 20/255, 20/255, 1)
                radius                 : 4
                border.width           : 1

            }
        }
    }

    onValueChanged:
    {
        sliderValueChanged( value )
    }

    
    function setValue( val )
    {
        if( Math.abs( val - value ) >= 0.001 ){
            value = val;
          //  console.log( value )
        }
    }

    function setAlphaEnabled( enabled )
    {
        startColor.a = enabled ? 0.0 : 1.0
    }

    function updateBackground( r, g, b, channel )
    {
        var start = [ r, g, b ]
        var end   = [ r, g, b ]

        for( var i = 0; i < 3; ++i ) {
            if( i === channel ){
                start[i] = 0.0
                end[i]   = 1.0
            }
        }

        startColor = Qt.rgba( start[0], start[1], start[2], 1.0 )
        endColor   = Qt.rgba( end[0], end[1], end[2], 1.0 )
    }
}
