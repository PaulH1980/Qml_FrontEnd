import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "."

Item
{
    signal valueChanged				( var newValue )

    function getValue() {
        return Number.fromLocaleString( numberInputId.mValue )
    }

    property alias labelId			: idLabel
    property color mColor 			: Qt.rgba( 255/255, 255/255, 255/255, 1)
    property color mTextColor 		: Qt.rgba( 0/255, 0/255, 0/255, 1)
    property string mText			: ""
    property bool isFloatingPoint	: true
    property bool isBounded			: false
    property real min				: 0
    property real max				: 0
    property int  textMargin		: Style.defaultFontSize / 4

    property alias mValue			: textFieldId.text
    property alias textFieldFocus	: textFieldId.activeFocus
    property alias mNumDecimals		: doubleValidator.decimals
    property alias mLabelVisible    : idLabel.visible


    height 							: 24
    width							: 96
    id								: numberInputId

    Label
    {
        id     						: idLabel
        visible                     : false
    }

    DefaultTextField
    {
        DoubleValidator
        {
            id          : doubleValidator
            notation    : DoubleValidator.StandardNotation
            decimals    : 3
        }

        IntValidator
        {
            id          : intValidator
        }

        validator 				: numberInputId.isFloatingPoint ? doubleValidator : intValidator

        id						: textFieldId
        smooth					: true
        antialiasing			: true
        focus					: false

        anchors.left 			: idLabel.visible
                                  ? idLabel.right
                                  : parent.left
        anchors.leftMargin		: -1
        anchors.top				: numberInputId.top
        anchors.bottom			: numberInputId.bottom
        width		 			: idLabel.visible
                                  ? numberInputId.width - idLabel.width
                                  : numberInputId.width
        text 					: ""

        onTextChanged:
        {
            //console.log( "text is "  + text )
            //if( isFloatingPoint ) //round to decimals
            //	text =   parseFloat( text ).toFixed(  numberInputId.mNumDecimals )

        }

        onEditingFinished:
        {
            if( text.length == 0 )
                text = isBounded ? min : 0
            numberInputId.valueChanged( Number.fromLocaleString( text ) )
            if( !isFloatingPoint )
                text =   parseFloat( text ).toFixed(  numberInputId.mNumDecimals )
        }



        Component.onCompleted:
        {
            if( numberInputId.isBounded )
            {
                validator.top    = numberInputId.max
                validator.bottom = numberInputId.min
            }
        }
    }

    Component.onCompleted:
    {
        
    }


}
