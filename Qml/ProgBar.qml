import QtQuick 2.7
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import "."

Row
{
	id						: progBar	
	spacing 				: 5
	
	property int minimum	: 0
	property int maximum	: 100
	property int value		: 0
	
	RowLayout
	{
		spacing				: 4		
        
		Rectangle 
		{
			id 						: progPlaceHolder
			radius					: 5
			border.width			: 1
			
			Layout.fillHeight			: true
			Layout.maximumWidth	 		: 210
			Layout.preferredWidth		: 210
			
			border.color			: Style.progBarBorderColor	
			color					: Style.progBarBackgroundColor		
			Rectangle 
			{
				
				Behavior on width { SmoothedAnimation {  velocity: 200 } }
				
				id							: progStrip
				anchors.left 				: progPlaceHolder.left
				anchors.top					: progPlaceHolder.top
				anchors.bottom 				: progPlaceHolder.bottom
				anchors.leftMargin			: 1
				anchors.topMargin			: 1
				anchors.bottomMargin		: 1
				anchors.rightMargin			: 1
				border.width				: 1
				border.color				: Style.progStripBorderColor
				radius						: 5
				
				//color for progressbar			
				gradient					: Gradient 
				{
					GradientStop { position: 0.0; color: Style.progStripBackgroundStartColor }
					GradientStop { position: 1.0; color: Style.progStripBackgroundEndColor }
				}			
				
				property real maxRange		: maximum - minimum
				property real curRange		: value - minimum
				property int maxWidth  		: progPlaceHolder.width
				
				property real percentage	: curRange / maxRange  //[0...1]			 
				property int curWidth  		: percentage * maxWidth			 
				property int percAsInt		: percentage * 100
				 
				 
				//assign text 
				TextMetrics 
				{
					id				: textMetrics
					font.family		: Style.progBarFontName
					font.pixelSize	: Style.progBarTextSize
					text			: progStrip.percAsInt + "%"			
						
				}	
				property int textSize 		: textMetrics.width + Style.progBarTextSize
				property int minWidth 		: Math.max( maxWidth / 10, textSize )
				width 						: Math.max( minWidth, curWidth )	
				
				//draw the percentage
				Text 
				{
					text						: textMetrics.text
					font						: textMetrics.font
					color						: Style.progStripTextColor
					renderType					: Text.NativeRendering
					anchors.horizontalCenter 	: progStrip.horizontalCenter
					anchors.verticalCenter		: progStrip.verticalCenter							
				}			 
			}
		}
	
		DefaultButton
		{
			Layout.fillHeight			: true
			Layout.maximumWidth	 		: 80
			Layout.preferredWidth		: 80
			
			id 						: cancelBut
			defaultText 			: "Cancel"		
		}	
	}
	
	
	
	function cancel()
	{
		value   = minimum
		visible = false
	}
	
	function show()
	{
		visible = true
	}
	
	function setValue( val )
	{
		if( val < 0 ){
			cancel()
			return
		}
		if( val >= maximum )
			val = maximum
		value = val
	}
	
	function reset()
	{
		value = minimum;
	}
	
}