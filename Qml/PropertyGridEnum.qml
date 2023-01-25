import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4

import "."

PropertyGridItemBase
{
    id								: comboBoxId
    mPropHeight						: 64
    //the listmodel will be filled from a json object
    ListModel {
        id: comboBoxModel
    }

    /*
        @brief: Should be called directly after constructing item
    */
    function updateItem() //virtual
    {
        var enumVals  = propertyDataJson.EnumValNames;
        for ( var index in enumVals )
            comboBoxModel.append( enumVals[index] )

        //create & assign values to combobox
        control.currentIndex = getComboBoxIndex();
        control.displayText  = createComboText();
    }

    /*
        @brief: Create's combo display text, concatenates string values
        if multi-select
    */
    function createComboText()
    {
        var result  = "";
        var enumVals  = propertyDataJson.EnumValNames;
        var selectionCount = 0;
        for ( var index in enumVals ){
            var curVal = enumVals[index];
            if( curVal.Selected ){
                if( selectionCount )
                    result += ", ";

                result += curVal.Name;
                selectionCount++;
            }
        }
        return result;
    }

    /*
        @brief: Return true if this combobox represents a enum-bitfield
    */
    function isBitField()
    {
        var bitMask   = propertyDataJson.PropertyBase.Flags;
        var mask = (bitMask & PropertyFlags.enumAsBitmask) != 0;
        return mask;
    }

    /*
        @brief: Return current index of combobox, return -1 if this is a
        bitmask, and multiple or none selections are possible
    */
    function getComboBoxIndex()
    {
        var enumVals  = propertyDataJson.EnumValNames;
        for ( var index in enumVals ){
            if(enumVals[index].Selected )
                return enumVals[index].Index;
        }
        return -1; //invalid or bitmask
    }


    function isSelected( idx  ) {
        return  propertyDataJson.EnumValNames[idx].Selected;
    }

    function setSelected( idx, selected ) {
        propertyDataJson.EnumValNames[idx].Selected = selected
    }

    /*
        @brief: Unselect all items
    */
    function unselectAll() {
        var enumVals  =  propertyDataJson.EnumValNames;
        for ( var index in enumVals )
            setSelected( index, false )
    }


    function getComboItemBackGroundColor(  highlight, selected )
    {
        if( highlight && selected ) //mouse over selected item
            return Style.comboBoxBackgroundSelectedColor
        else if( highlight ) //mouseover
            return Style.comboBoxBackgroundHighLightColor
        else if( selected )
            return Style.comboBoxBackgroundSelectedColor
        return Style.comboBoxBackgroundColor;
    }

    /*
        @brief: Update json (combined) value and emit signal
    */
    function updateAndEmitJson()
    {
        var bitMask = 0;
        var enumVals  = propertyDataJson.EnumValNames;
        for ( var index in enumVals ){
            if(enumVals[index].Selected )
                bitMask |= enumVals[index].Value;
        }
        propertyDataJson.Value = bitMask;        //update Value
        jsonObjectChanged( propertyDataJson )   //emit signal
        propertyChanged( propertyDataJson.Value ) //emit property changed signal
    }


    ColumnLayout {
        anchors.fill         : parent
        anchors.topMargin    : 2
        anchors.bottomMargin : 2
        spacing              : 4
        Rectangle
        {
            Layout.minimumHeight           : 1
            Layout.maximumHeight           : 1
            Layout.leftMargin              : 16
            Layout.rightMargin             : 16
            Layout.fillWidth               : true

            color                          : Qt.rgba(80/255, 80/255, 80/255, 1)
        }

        PropertyGridName
        {
            Layout.leftMargin       : 32
            Layout.fillWidth        : true
        }

        Component
        {
            id	: comboItemDelegate

            Rectangle
            {
                id				: comboBoxItem
                anchors.left  	: control.left
                anchors.right 	: control.right
                height			: control.height
                color			: Style.comboBoxBackgroundColor
                smooth			: true
                border.width	: 2
                border.color 	: "black"
            }
        }


        ComboBox {

            id						: control
            Layout.minimumHeight    : 24
            Layout.maximumHeight    : 24
            Layout.leftMargin       : 56
            Layout.rightMargin      : 56
            Layout.fillWidth        : true
            currentIndex			: mComboBoxSelection //display index
            displayText				: ""
            model                   : comboBoxModel

            contentItem: Text
            {
                id						: buttonTextId
                width					: parent.width
                text                    : control.displayText
                font.pixelSize			: Style.defaultFontSize
                font.family				: Style.defaultFont
                elide					: Text.ElideRight
                verticalAlignment		: Text.AlignVCenter
                horizontalAlignment		: Text.AlignLeft
                color					: "White"
                anchors.fill            : parent
                anchors.leftMargin		: 16
                anchors.rightMargin     : 48 // make place for drop down arrow/icon
            }
            delegate: ItemDelegate
            {

                property bool mItemSelected : isSelected( index )
                highlighted		: control.highlightedIndex == index //mouse over
                width			: control.width
                height			: control.height
                id				: theDelegate

                /*
                    @brief: Toggle this item
                */
                function        toggle()
                {
                    mItemSelected = !mItemSelected;
                    setSelected( index, mItemSelected );
                    control.displayText = createComboText();
                }

                /*
                    @brief: Unselects all items then selects this item
                */
                function selectItem()
                {
                    unselectAll();
                    mItemSelected = true;
                    setSelected( index, mItemSelected );
                    control.displayText = createComboText();
                }

                contentItem: Item
                {
                    anchors.fill                : parent
                    Text
                    {
                        id                      : iconId
                        font.family				: FontAwesome.fontFamily
                        text					: FontAwesome.check
                        font.pointSize			: 16
                        color					: "White"

                        anchors.verticalCenter  : parent.verticalCenter
                        anchors.left 			: parent.left
                        anchors.leftMargin		: 8
                        visible					: mItemSelected //draw checker only if selected
                    }
                    Text //place text on the right of checker icon
                    {
                        anchors.left 		    	: iconId.right
                        anchors.right               : parent.right
                        anchors.verticalCenter      : parent.verticalCenter
                        anchors.leftMargin          : 8

                        text                        : Name //see propertyDataJson
                        font.pixelSize			  	: Style.defaultFontSize
                        font.family				  	: Style.defaultFont
                        color					  	: mItemSelected
                                                      ? "White"
                                                      : "Gray"
                        elide						: Text.ElideRight
                        verticalAlignment			: Text.AlignVCenter
                        horizontalAlignment			: Text.AlignLeft
                    }

                    MouseArea
                    {
                        anchors.fill                : parent
                        onClicked:
                        {
                            if( comboBoxPopup.visible )
                            {
                                var currentItem = listview.currentItem
                                if( currentItem ) {
                                    //multiselect combobox
                                    if( isBitField() ) {
                                        currentItem.toggle()
                                        updateAndEmitJson();
                                    }
                                    else{ //regular combobox
                                        currentItem.selectItem();
                                        updateAndEmitJson();
                                        comboBoxPopup.visible = false //close combo box
                                    }
                                }
                            }
                        }
                    }
                }

                onPressedChanged:
                {
                    /*if( pressed && comboBoxPopup.visible ) {
                        var currentItem = listview.currentItem
                        if( currentItem ) {
                            //multiselect combobox
                            if( isBitField() )
                                 currentItem.toggle()
                            else //regular combobox
                                currentItem.selectItem();

                            updateAndEmitJson();
                        }
                    }*/
                }
            }

            background: Rectangle
            {
                color			: control.pressed
                                  ? Style.comboBoxBackgroundSelectedColor
                                  : Style.comboBoxBackgroundColor
                smooth			: true
                border.width	: 1
                border.color	: "black"
                anchors.fill 	: parent
            }

            popup: Popup
            {
                id              : comboBoxPopup
                y				: control.height
                width			: control.width
                implicitHeight	: listview.contentHeight
                padding			: 0
                modal			: true
                closePolicy     : Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

                contentItem     : Item
                {
                    anchors.fill : parent;
                    Rectangle
                    {
                        anchors.fill:  parent
                        color       : "Black"

                        ListView
                        {
                            anchors.fill        : parent
                            anchors.leftMargin  : 1
                            anchors.rightMargin : 1
                            anchors.bottomMargin: 1
                            id                  : listview
                            clip                : true
                            model               : control.popup.visible
                                                  ? control.delegateModel
                                                  : null
                            currentIndex        : control.highlightedIndex
                            focus               : true
                        }
                    }
                }
            }//popup

            indicator: Canvas
            {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 16
                height: 10
                contextType: "2d"

                Connections {
                    target: control
                    onPressedChanged: canvas.requestPaint()
                }

                onPaint: {
                    var context = getContext("2d");
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control.pressed ? "#17a81a" : "white";
                    context.fill();
                }
            }
        }
    }

}


