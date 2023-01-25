import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

DefaultTextField
{
    signal valueChanged				( var newValue )

    id                              : control
    property real min				: -2147483647   //make range same as int input
    property real max				: 2147483647
    property real defaultValue      : 0
    property real currentValue      : 0    
    property int  numDecimals       : 2
    property bool immediateUpdate   : true
    property bool allowEmptyText    : true
    property bool isRanged          : true
    font.pixelSize		            : 14
    Component.onCompleted:
    {
      
    }

    onEditingFinished:
    {
        parseAndUpdate( true )
    }

    onActiveFocusChanged:
    {
        parseAndUpdate( true )
    }

    onCurrentValueChanged:
    {
        if( isNaN( currentValue ) )
            console.log( "Input Value is NaN" );
        setValue( currentValue )
    }

    onTextChanged:
    {
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
        var newValue = Number.parseFloat( text )
        if( isNaN( newValue) ) //handle nans
        {
            if( forceValue )
                setValue( defaultValue )
            return
        }
                  
        setValue( newValue )
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
        return value
    }

    function getValue()
    {
        return currentValue
    }
    
    function setValue( newValue )
    {
        newValue = clampValue( newValue )
        text = "" + newValue
        if( currentValue !== newValue )
        {
            currentValue = newValue           
            control.valueChanged( currentValue )
        }
    }
}
