import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "."

Item
{
   
    signal          floatValuesChanged ( var values, int dimension )
  
    id              : control
   // height          : 24

    property int    leftMargin      : 0
    property int    rightMargin     : 0

    property bool   fillWidth       : true
    property int    preferredWidth  : 64
    property int    preferredLabelWidth : 16

    

    property int    numDimensions   : 1
    property int    labelAlignment  : Text.AlignRight
    property bool   showLabels      : true
    property var    labelNames      : ["X", "Y", "Z", "W"] 
    property var    componentValues : [ 0, 0, 0, 0 ]
    property bool   isRanged        : false
    property real   min				: -2147483647   //make range same as int input
    property real   max				: 2147483647
    property int    numDecimals     : 2


    function getLabelName( idx )
    {
        return control.labelNames[idx];
    }

    function getComponentValue( idx )
    {
        return componentValues[idx]
    }

    function setComponentValue( idx, val )
    {
        var modified = false
        var previousValues =  componentValues.slice()        
        componentValues[idx] = val
        
        for( var i in componentValues )
        {
            if( Math.abs(previousValues[i] - componentValues[i]) > 0.00125 )
                modified = true
        }
        if( modified )
            floatValuesChanged( componentValues, numDimensions )
    }


    function updateItems()
    {
        for( var i in componentValues )
           updateItemAt( i, getComponentValue( i ) )

    }

    function updateItemAt( idx, value )
    {
        modelRepeater.itemAt( idx).inputValue = value
    }


    RowLayout
    {
        anchors.fill          : parent    
        anchors.leftMargin    : leftMargin
        anchors.rightMargin   : rightMargin

        Repeater
        {
            model   : control.numDimensions
            id      : modelRepeater
            LabelFloatInput
            {
                Layout.fillWidth            : control.fillWidth
                preferredLabelWidth         : control.preferredLabelWidth
                showLabel                   : showLabels
                labelAlignment              : control.labelAlignment
                text                        : getLabelName( index )
                inputValue                  : getComponentValue( index )     
                isRanged                    : control.isRanged
                min                         : control.min
                max                         : control.max
                numDecimals                 : control.numDecimals

                onFloatValueChanged:
                {
                    setComponentValue( index, newValue )
                }               
            }
        }
    }     
}
