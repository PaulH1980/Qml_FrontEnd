import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

Item
{
    
    signal colorChanged( var newColor )

    property alias showColorWheel       : colorWheelId.visible
    property alias colorWheelBackground : colorWheelId.bgColor

    property alias showSliderInput  : colorSliderId.visible
    
    property bool suppresSignals    : false
    property bool showAlpha         : true
    property bool showRGB           : true // if false show hsv control
    property bool showLabels        : true
    property bool showTextInput     : true

    property string redLabel       : "Red"
    property string greenLabel     : "Green"
    property string blueLabel      : "Blue"
    property string alphaLabel     : "Alpha"

    property int  labelWidth       : 32
    property int  sliderHeight  : 24
    property int  leftMargin    : 32
    property int  rightMargin   : 32
    property color rgba         : Qt.rgba( 0, 0, 0, 1 )
    id                          : control
    implicitHeight              : 280

    ColumnLayout
    {
        anchors.fill         : parent
        anchors.topMargin    : 2
        spacing              : 4
        id                   : colLayout

        ColorWheel
        {
            width                          : 128
            height                         : 128
            implicitHeight                 : 128
            Layout.alignment               : Qt.AlignHCenter
            id                             : colorWheelId

            onHsvChanged:
            {
                updateFromWheel()
            }
        }
        ColumnLayout
        {
            spacing              : 4
            id                   : colorSliderId
            RowLayout
            {
                Layout.minimumHeight           : sliderHeight
                Layout.maximumHeight           : sliderHeight
                Layout.preferredHeight         : sliderHeight
                Layout.leftMargin              : leftMargin
                Layout.rightMargin             : rightMargin
                Layout.fillWidth               : true

                DefaultLabel
                {
                    visible                   : showLabels
                    text                      : redLabel
                    Layout.preferredWidth     : labelWidth
                    horizontalAlignment       : Text.AlignRight
                }
                ColorSlider
                {
                    Layout.fillWidth           : true
                    height                     : sliderHeight
                    implicitHeight             : sliderHeight
                    id                         : redSlider

                    onSliderValueChanged :
                    {
                        updateFromSlider()
                    }
                }
                IntegerInput
                {
                    Layout.preferredWidth    : 32
                    id                       : redInput
                    min                      : 0;
                    max                      : 255
                    isRanged                 : true
                    visible                  : showTextInput

                    onValueChanged :
                    {
                        updateFromIntInput()
                    }
                }
            }
            RowLayout
            {
                Layout.minimumHeight           : sliderHeight
                Layout.maximumHeight           : sliderHeight
                Layout.preferredHeight         : sliderHeight
                Layout.leftMargin              : leftMargin
                Layout.rightMargin             : rightMargin
                Layout.fillWidth               : true

                DefaultLabel
                {
                    visible                     : showLabels
                    Layout.preferredWidth       : labelWidth
                    text                        : greenLabel
                    horizontalAlignment         : Text.AlignRight
                }
                ColorSlider
                {
                    Layout.fillWidth            : true
                    height                      : sliderHeight
                    id                          : greenSlider

                    onSliderValueChanged :
                    {
                        updateFromSlider()
                    }
                }
                IntegerInput
                {
                    Layout.preferredWidth    : 32
                    id                       : greenInput
                    min                      : 0
                    max                      : 255
                    isRanged                 : true
                    visible                  : showTextInput

                    onValueChanged :
                    {
                        updateFromIntInput()
                    }
                }
            }

            RowLayout
            {
                Layout.minimumHeight           : sliderHeight
                Layout.maximumHeight           : sliderHeight
                Layout.preferredHeight         : sliderHeight
                Layout.leftMargin              : leftMargin
                Layout.rightMargin             : rightMargin
                Layout.fillWidth               : true

                DefaultLabel
                {
                    visible                     : showLabels
                    text                        : blueLabel
                    Layout.preferredWidth       : labelWidth
                    horizontalAlignment         : Text.AlignRight
                }
                ColorSlider
                {
                    Layout.fillWidth            : true
                    id                          : blueSlider
                    height                      : sliderHeight

                    onSliderValueChanged :
                    {
                        updateFromSlider()
                    }
                }
                IntegerInput
                {
                    Layout.preferredWidth    : 32
                    id                       : blueInput
                    min                      : 0;
                    max                      : 255
                    isRanged                 : true
                    visible                  : showTextInput
                    onValueChanged :
                    {
                        updateFromIntInput()
                    }
                }

            }

            RowLayout
            {
                Layout.minimumHeight             : sliderHeight
                Layout.maximumHeight             : sliderHeight
                Layout.preferredHeight           : sliderHeight
                Layout.leftMargin                : leftMargin
                Layout.rightMargin               : rightMargin
                Layout.fillWidth                 : true

                DefaultLabel
                {
                    visible               : showLabels
                    text                  : alphaLabel
                    Layout.preferredWidth : labelWidth
                    horizontalAlignment         : Text.AlignRight
                }

                ColorSlider
                {
                    Layout.fillWidth               : true
                    height                         : sliderHeight
                    implicitHeight                 : sliderHeight
                    id                             : alphaSlider

                    Component.onCompleted  :
                    {
                        setAlphaEnabled( true )
                    }

                    onSliderValueChanged :
                    {
                        updateFromSlider()
                        //colorChanged( getRgba() )
                    }
                }
                IntegerInput
                {
                    Layout.preferredWidth    : 32
                    id                       : alphaInput
                    min                      : 0
                    max                      : 255
                    isRanged                 : true
                    visible                  : showTextInput

                    onValueChanged :
                    {
                        updateFromIntInput()
                    }
                }
            }
            
        }
    }

    function updateFromIntInput()
    {
        var r = redInput.currentValue / 255.0
        var g = greenInput.currentValue / 255.0
        var b = blueInput.currentValue/ 255.0
        var a = alphaInput.currentValue / 255.0

        updateRgba( r, g, b, a )
    }


    function updateRgba( r, g, b, a )
    {
        
        var prevRgba = getRgba()
        
        setRgb( r, g, b )
        setAlpha( a )
        
        if( !Qt.colorEqual( prevRgba, getRgba() ) )
        {
            colorChanged( rgba )
        }
    }

    function  updateFromSlider()
    {
        var r = redSlider.value   / 255.0
        var g = greenSlider.value / 255.0
        var b = blueSlider.value  / 255.0
        var a = alphaSlider.value / 255.0

        updateRgba( r, g, b, a )

    }

    function updateFromWheel()
    {
        var h = colorWheelId.hue / 359.0
        var s = colorWheelId.sat / 255.0
        var v = colorWheelId.val / 255.0
        var hsv = Qt.hsva( h, s, v, rgba.a )

        updateRgba ( hsv.r, hsv.g, hsv.b, rgba.a )
    }

    function getRgba()
    {
        return Qt.rgba( rgba.r, rgba.g, rgba.b, rgba.a );
    }


    function setRgb( r, g, b )
    {
        
        var rgb = Qt.rgba( r, g, b, 1.0 ) //range is [0..1]
        
        redSlider.updateBackground   ( r, g, b, 0 )
        greenSlider.updateBackground ( r, g, b, 1 )
        blueSlider.updateBackground  ( r, g, b, 2 )

        //convert to integer range
        colorWheelId.setHsv( Math.floor( Math.abs( rgb.hsvHue * 359.0 ) ),
                            Math.floor( Math.abs( rgb.hsvSaturation * 255.0 ) ),
                            Math.floor( Math.abs( rgb.hsvValue * 255.0 ) ) );

        redSlider.setValue  ( Math.floor( r * 255 ) )
        greenSlider.setValue( Math.floor( g * 255 ) )
        blueSlider.setValue ( Math.floor( b * 255 ) )

        redInput.setValue   ( Math.floor( r * 255 ) )
        greenInput.setValue ( Math.floor( g * 255 ) )
        blueInput.setValue  ( Math.floor( b * 255 ) )

        rgba.r = r
        rgba.g = g
        rgba.b = b
    }

    function setAlpha( a )
    {
        alphaSlider.setValue( Math.floor( a * 255 ) )
        alphaInput.setValue(  Math.floor( a * 255 ) )
        rgba.a = a
    }
}

