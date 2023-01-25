import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import "."

Item
{ 
  
    signal selectionChanged( var sender, var selection )
    id  : control       
    
    /* Each item is defined internally as:

            "Name"      : string,
            "Selected"  : bool
            "Value"     : int
            "Index"     : int
    */
    property var  comboBoxItems : []   
    property var  selectedItems : []
    property int  comboBoxIndex : -1    

    property alias comboBoxText                 : comboBox.displayText    

    property int  textSize                      : Style.defaultFontSize
    property int  dropDownCaretWidth            : textSize / 1.5
    property bool isMultiSelect                 : false
    property int  dropDownCaretRightPadding     : 4    
    property int  dropDownMenuWidth             : 128   



    //the listmodel will be filled from a json object
    ListModel {
        id  : comboBoxModel
    }

    //append items to listmodel & update displayed text
    Component.onCompleted:
    {
        for( var i in comboBoxItems )
            comboBoxModel.append( comboBoxItems[i] )      
        dropDownMenuWidth = calcComboBoxImplicitWidth( comboBox ) * 1.5     
        comboBoxText = createComboText()       
    }

 /* 
    ComboBoxHacks.js 
    //https://stackoverflow.com/questions/45029968/how-do-i-set-the-combobox-width-to-fit-the-largest-item
 */
function calcComboBoxImplicitWidth(cb) 
{
     var widest = 0
     if (cb.count===0) return cb.width
     var originalCI = cb.currentIndex
     if (originalCI < 0) return cb.width // currentIndex deleted item
     do {
       widest = Math.max(widest, cb.contentItem.contentWidth)
       cb.currentIndex = (cb.currentIndex + 1) % cb.count
     } while(cb.currentIndex !== originalCI)

     return widest + cb.contentItem.leftPadding + cb.contentItem.rightPadding
                   + cb.indicator.width
}


   
    
   /*
        @brief: Create's combo display text, concatenates string values
        if multi-select
     */
    function createComboText()
    {
          var result  = "";         
          var selectionCount = 0;
          for ( var index in comboBoxItems ){
              var curVal = comboBoxItems[index];
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
         return isMultiSelect
      }

      /*
          @brief: Return current index of combobox, return -1 if this is a
          bitmask, and multiple or none selections are possible
      */
      function getComboBoxIndex()
      {
          for ( var index in comboBoxItems ){
              if(comboBoxItems[index].Selected )
                  return comboBoxItems[index].Index;
          }
          return -1; //invalid or bitmask
      }


      function isSelected( idx  ) {
          return  comboBoxItems[idx].Selected;
      }

      function setSelected( idx, selected ) {
          comboBoxItems[idx].Selected = selected
      }

      /*
          @brief: Unselect all items
      */
      function unselectAll() {         
          for ( var index in comboBoxItems )
              setSelected( index, false )
      }




      function getComboItemBackGroundColor( highlight, selected )
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
         var selection = getSelectedItems()       
         selectionChanged( control, selection )
      }


      function getSelectedItems()
      {
         var result = []
         for ( var index in comboBoxItems ) {
            if( comboBoxItems[index].Selected )
                result.push( comboBoxItems[index] )
         }
         return result
      }


    ComboBox
    {

        id                      : comboBox
        anchors.fill            : parent
        currentIndex			: control.comboBoxIndex //display index
        displayText			    : ""
        model                   : comboBoxModel  

        contentItem: Text
        {
            id						: buttonTextId
            width					: parent.width
            text                    : comboBox.displayText
            font.pixelSize			: textSize
            font.family				: Style.defaultFont
            elide					: Text.ElideRight
            verticalAlignment		: Text.AlignVCenter
            horizontalAlignment		: Text.AlignLeft
            color					: "White"
            anchors.fill            : parent
            anchors.leftMargin		: 4
            anchors.rightMargin     : dropDownCaretWidth + dropDownCaretRightPadding // make place for drop down arrow/icon
        }
        delegate: ItemDelegate
        {
            property bool   mItemSelected : isSelected( index )
            highlighted		: comboBox.highlightedIndex == index //mouse over
            width			: dropDownMenuWidth
            height			: comboBox.height
            id				: theDelegate

            /*
                        @brief: Toggle this item
                    */
            function        toggle()
            {
                mItemSelected = !mItemSelected;
                setSelected( index, mItemSelected );
                comboBox.displayText = createComboText();
            }

            /*
                        @brief: Unselects all items then selects this item
                    */
            function selectItem()
            {
                unselectAll();
                mItemSelected = true;
                setSelected( index, mItemSelected );
                comboBox.displayText = createComboText();
            }

            contentItem: Item
            {
                anchors.fill                : parent
                Text
                {
                    id                      : iconId
                    font.family				: FontAwesome.fontFamily
                    text					: FontAwesome.check
                    font.pointSize			: textSize
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
                    font.pixelSize			  	: textSize
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
                if( pressed && comboBoxPopup.visible ) 
                {
                     var currentItem = listview.currentItem
                     if( currentItem ) 
                     {
                         //multiselect combobox
                         if( isBitField() )
                              currentItem.toggle()
                         else //regular combobox
                             currentItem.selectItem();

                         updateAndEmitJson();
                     }
                }
            }
        }

        background: Rectangle
        {
            color			: comboBox.pressed
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
            y				: comboBox.height
            width			: control.dropDownMenuWidth
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
                        model               : comboBox.popup.visible
                                              ? comboBox.delegateModel
                                              : null
                        currentIndex        : comboBox.highlightedIndex
                        focus               : true
                    }
                }
            }
        }//popup

        indicator: Canvas
        {
            id: canvas
            x : comboBox.width - (dropDownCaretWidth +  dropDownCaretRightPadding)
            y : comboBox.topPadding + (comboBox.availableHeight - height) / 2
            width: dropDownCaretWidth
            height: width / 1.5
            contextType: "2d"

            Connections {
                target: comboBox
                onPressedChanged: canvas.requestPaint()
            }

            onPaint: {
                var context = getContext("2d");
                context.reset();
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width / 2, height);
                context.closePath();
                context.fillStyle = comboBox.pressed ? "#17a81a" : "white";
                context.fill();
            }
        }
    }
}

