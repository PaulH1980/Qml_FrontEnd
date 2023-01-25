import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."


DefaultTextField
{
    signal valueChanged				( var newValue )
    id                              : control
    property int  min				: -2147483647 //?according to http://doc.qt.io/qt-5/qml-qtquick-intvalidator.html
    property int  max				: 2147483647
    property int  defaultValue      : 0
    property int  currentValue      : 0
    property bool immediateUpdate   : true
    property bool allowEmptyText    : false
    property bool isRanged          : true
    font.pixelSize		            : 14
   
   // validator                       : IntValidator {bottom:min; top:max}

    Component.onCompleted: {
      
    }

    onEditingFinished:
    {
        parseAndUpdate( true )
    }

    onActiveFocusChanged:
    {
        parseAndUpdate( true)
    }

    onTextChanged:
    {
       // console.log( min  +  " " + text  + " " + text.length )
        if( text.length === 0 )
        {
            if( !allowEmptyText )
                setValue( defaultValue )
            return;
        }
        else if( immediateUpdate )
        {
            parseAndUpdate( false )
        }
    }

    function parseAndUpdate( forceValue )
    {
        var newValue = parseText()
        if( isNaN( newValue) )
        {
            if( forceValue )
                setValue( defaultValue )
            return
        }
                  
        setValue( newValue )
    }

    function parseText()
    {
        var value = Number.parseInt( text )
        return value
    }

    function clampValue( value )
    {
        if( isRanged )
        {
            if( value < min )
                value = min
            if( value > max )
                value = max
        }
       // console.log( "val " + value )
        return value
    }


    onCurrentValueChanged:
    {
        if( isNaN( currentValue ) )
            console.log( "Input Value is NaN" );
        setValue( currentValue )
    }


    function setValue( newValue )
    {
        newValue = clampValue( newValue )
        {
            text = "" + newValue
            if( currentValue != newValue )
            {
                currentValue = newValue
                control.valueChanged( currentValue )
            }
        }
    }

    function getValue()
    {
        return currentValue
    }
}
