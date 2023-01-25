import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import "."

Row
{
	id						: searchBar	
	spacing 				: 5

	RowLayout
	{
		TextField 
		{
			Layout.fillHeight		: true
			Layout.maximumWidth	 	: 210
			Layout.preferredWidth	: 210
			
			id 						: textField
			//anchors.verticalCenter	: searchBar.verticalCenter
			focus					: false
			antialiasing			: true
			smooth					: true
			placeholderText 		: Style.searchboxPlaceHolderText
			style: TextFieldStyle 
			{
				textColor: Style.searchboxTextColor
				placeholderTextColor: Style.searchboxPlaceHolderTextColor
				font.pixelSize: Style.searchboxTextSize
				font.family: Style.searchboxFontName
				background: Rectangle 
				{
					id : rect
					radius: Style.searchBoxRadius
					implicitWidth: Style.searchboxWidth
					implicitHeight: Style.searchboxHeight
					border.color: textField.activeFocus ? Style.searchboxBorderFocusColor : Style.searchboxBorderColor
					border.width: 1
					color : Style.searchboxBackgroundColor
					
					 RectangularGlow {
						id: effect
						anchors.fill: rect
						glowRadius: 8
						spread: 0.3
						color: textField.activeFocus ? Qt.rgba(  100/255,   175/255, 234/255, 0.35) : "transparent"
						cornerRadius: rect.radius + glowRadius
						z : -1
					}		
				}
			}
			onFocusChanged: console.log("Focus changed " + focus)
		}
		
		DefaultButton
		{
			Layout.fillHeight			: true
			Layout.maximumWidth	 		: 80
			Layout.preferredWidth		: 80

			id 						    : searchBut
			defaultText 			    : "Submit"		
			//anchors.verticalCenter	: textField.verticalCenter		
		}
	}
	
	
	
}