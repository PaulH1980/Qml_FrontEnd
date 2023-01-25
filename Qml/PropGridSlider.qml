import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "."

PropertyGridItemBase 
{
	anchors.left					: parent.left	
	id								: sliderId
	
	onSliderValueLoaded:
	{
		rangeSlider.from 	 	= sliderId.mSliderValues[0]
		rangeSlider.to	 	 	= sliderId.mSliderValues[1]
		rangeSlider.setValues( sliderId.mSliderValues[2], sliderId.mSliderValues[3] )
		rangeSlider.stepSize 	= sliderId.mSliderValues[4]
		rangeSlider.isInteger 	= sliderId.mSliderValues[5]
	}
	
	RowLayout 
	{
		anchors.fill	: parent
		anchors.margins : 2
		spacing			: 2
			
		Rectangle 
		{
			Layout.fillHeight		: true
			Layout.minimumWidth	 	: Style.rightSidePanelTitleWidth
			Layout.maximumWidth	 	: Style.rightSidePanelTitleWidth
			Layout.preferredWidth	: Style.rightSidePanelTitleWidth
			id						: titleId
			color					: Style.defaultBackGroundColor	
			Text 
			{
				id						  	: textId
				width						: parent.width
				text					  	: sliderId.mDescription
				font.pixelSize			  	: Style.defaultFontSize
				font.family				  	: Style.defaultFont
				color					  	: "White"
				horizontalAlignment			: Text.AlignLeft
				anchors.centerIn			: parent
				smooth						: true			
			}					
		}
		CustomRangeSlider
		{
			Layout.fillWidth	 		: true
			Layout.fillHeight			: true
			Layout.minimumWidth	 		: 128	
			id							: rangeSlider
			
			property bool isInteger	 	: false			
			property real handleDims 	: 26
		
			function getXLocationForValue( val )
			{
				var result =rangeSlider.leftPadding + val * (rangeSlider.availableWidth - rangeSlider.handleDims)
				return result;
			}	

			CustomToolTip 
			{
				parent	: rangeSlider.first.handle
				visible	: rangeSlider.first.pressed
				text	: rangeSlider.first.value.toFixed( rangeSlider.isInteger ? 0 : 1 )
			}	

			CustomToolTip  
			{
				parent	: rangeSlider.second.handle
				visible	: rangeSlider.second.pressed
				text	: rangeSlider.second.value.toFixed(rangeSlider.isInteger ? 0 : 1)				
			}					
				
			background: Rectangle 
			{
				x: rangeSlider.leftPadding
				y: rangeSlider.topPadding + rangeSlider.availableHeight / 2 - height / 2
				implicitWidth: 200
				implicitHeight: 4
				width: rangeSlider.availableWidth
				height: implicitHeight
				radius: 2
				color: "#f0f0f0"
			
				Rectangle 
				{
					x	 : rangeSlider.getXLocationForValue( rangeSlider.first.visualPosition )//rangeSlider.leftPadding + rangeSlider.first.visualPosition * (rangeSlider.availableWidth - width)
					width: rangeSlider.getXLocationForValue( rangeSlider.second.visualPosition ) - x
					height: parent.height
					color: "#21beFF"
					radius: 2
				}
			}

			first.handle: Rectangle 
			{
				x				: rangeSlider.getXLocationForValue( rangeSlider.first.visualPosition )
				y				: rangeSlider.topPadding + rangeSlider.availableHeight / 2 - height / 2
				implicitWidth	: rangeSlider.handleDims
				implicitHeight	: rangeSlider.handleDims
				radius			: rangeSlider.handleDims / 2
				border.width 	: 1
				color			: rangeSlider.first.pressed ? "#21beff" : "#f0f0f0"
				border.color	: "black"
			}
		
			second.handle: Rectangle 
			{
				x				: rangeSlider.getXLocationForValue( rangeSlider.second.visualPosition )
				y				: rangeSlider.topPadding + rangeSlider.availableHeight / 2 - height / 2
				implicitWidth	: rangeSlider.handleDims
				implicitHeight	: rangeSlider.handleDims
				radius			: rangeSlider.handleDims / 2
				border.width 	: 1
				color			: rangeSlider.second.pressed ? "#21beff" : "#f0f0f0"
				border.color	: "black"
			}				
		}//Range Slider
	}//RowLayout	
}