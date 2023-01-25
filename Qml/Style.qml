import QtQuick 2.7
pragma Singleton

QtObject 
{
    readonly property string defaultFont				 		: "Helvetica"
    readonly property int    defaultFontSize				 	: 20
    readonly property color  defaultFontColor				 	: "White"


    readonly property color defaultBackGroundColor 		 		: Qt.rgba(48/255, 48/255, 48/255, 1)
    readonly property color lightBackGroundColor 		 		: Qt.rgba(80/255, 80/255, 80/255, 1)
    readonly property color defaultBorderColor		 			: Qt.rgba(17/255, 17/255, 17/255, 1)

    readonly property color  defaultTextFieldBorderColor		: Qt.rgba(  0/255,   0/255, 0/255, 1)
    readonly property color  defaultTextFieldBorderFocusColor	: Qt.rgba(  100/255,   175/255, 234/255, 1)
    readonly property color  defaultTextFieldTextColor			: "White"

    readonly property color  comboBoxBackgroundColor			: Qt.rgba(57/255, 57/255, 57/255, 1)
    readonly property color  comboBoxBackgroundSelectedColor	: Qt.rgba(57/255, 57/255, 192/255, 1)
    readonly property color  comboBoxBackgroundHighLightColor	: Qt.rgba(32/255, 128/255, 128/255, 1)

    readonly property color  consoleInputTextColor				: Qt.rgba(57/255, 192/255, 0/255, 1)


    //header
    readonly property color headerColor 		 			: Qt.rgba(34/255, 34/255, 34/255, 1)
    readonly property color headerBorderColor 				: Qt.rgba(17/255, 17/255, 17/255, 1)
    readonly property int   headerRadius 	 				: 10



    //default button properties
    readonly property color buttonDefaultColor				: Qt.rgba( 26/255,  26/255,  26/255, 1)
    readonly property color buttonDefaultBorderColor		: Qt.rgba( 17/255,   17/255, 17/255, 1)
    readonly property color buttonHoverColor				: Qt.rgba( 17/255,   17/255, 17/255, 1)
    readonly property color buttonBorderHoverColor			: Qt.rgba( 17/255,   17/255, 17/255, 1)
    readonly property color buttonPressedColor				: Qt.rgba( 17/255,   17/255, 17/255, 1)
    readonly property color buttonPressedBorderColor		: Qt.rgba( 77/255,  144/255, 255/255, 1)
    readonly property color buttonTextColor					: Qt.rgba( 255/255, 255/255, 255/255, 1)
    readonly property string buttonDefaultText 				: "Hello World"
    readonly property string buttonTextFontName				: "Helvetica"
    readonly property int   buttonTextMargin				: 10
    readonly property int   buttonRadius					: 6
    readonly property int   buttonBorderSize				: 1
    readonly property int   buttonTextSize					: 20

    //rounded rectangle
    readonly property real 	roundRectAlpha					: 1.0
    readonly property color roundRectFillColor 				: Qt.rgba( 255/255, 255/255, 255/255, 1)
    readonly property color roundRectLineColor 				: Qt.rgba(  0/255,   0/255, 0/255, 1)
    readonly property real  roundRectBorderSize        		: 0;
    readonly property real  roundRectRadius           		: 0;


    readonly property color  searchboxBackgroundColor			: Qt.rgba(   57/255,   57/255, 57/255, 1)
    readonly property color  searchboxTextColor				: Qt.rgba(  255/255,   255/255, 255/255, 1)
    readonly property color  searchboxPlaceHolderTextColor	: Qt.rgba(  128/255,   128/255, 128/255, 1)
    readonly property color  searchboxBorderColor				: Qt.rgba(  0/255,   0/255, 0/255, 1)
    readonly property color  searchboxBorderFocusColor		: Qt.rgba(  100/255,   175/255, 234/255, 1)
    readonly property int    searchboxHeight					: 36
    readonly property int    searchboxWidth					: 220
    readonly property string searchboxFontName				: "Helvetica"
    readonly property string searchboxPlaceHolderText		: "Search"
    readonly property int 	searchboxTextSize	 			: 20
    readonly property int 	searchBoxRadius		 			: 6


    readonly property color  progBarBackgroundColor			: Qt.rgba(   57/255,   57/255, 57/255, 1)
    readonly property color  progBarBorderColor				: Qt.rgba(  0/255,   0/255, 0/255, 1)


    readonly property color  progStripBackgroundStartColor	: Qt.rgba(  33/255,    66/255,   101/255, 1)
    readonly property color  progStripBackgroundEndColor		: Qt.rgba(  66/255,   139/255,  202/255, 1)

    readonly property color  progStripBorderColor			: Qt.rgba(  128/255,   128/255, 128/255, 1)
    readonly property color  progStripTextColor				: Qt.rgba(  255/255,   255/255, 255/255, 1)
    readonly property int    progBarWidth					: 250
    readonly property int    progBarHeight					: 36
    readonly property string progBarFontName					: "Helvetica"
    readonly property string progBarPlaceHolderText			: "Search"
    readonly property int 	progBarTextSize	 				: 20
    readonly property int 	progBarRadius		 			: 6


    //header
    readonly property color  leftSidePanelColor              : Qt.rgba(34/255, 34/255, 34/255, 1)
    readonly property color  leftSidePanelBorderColor 		: Qt.rgba(17/255, 17/255, 17/255, 1)
    readonly property int    leftSidePanelRadius 	 		: 10
    readonly property int    leftSidePanelBorderWidth		: 1
    readonly property int    leftSidePanelWidth              : 350
    readonly property int    leftSidePanelTitleWidth         : 124
    readonly property string leftSidePanelFontName			: "Helvetica"
    readonly property int 	leftSidePanelTextSize	 		: 20
    readonly property int    treeViewItemDefaultHeight       : 32

    //header
    readonly property color rightSidePanelColor 		 	: Qt.rgba(50/255, 50/255, 50/255, 1)
    readonly property color rightSidePanelBorderColor 		: Qt.rgba(17/255, 17/255, 17/255, 1)
    readonly property int   rightSidePanelRadius 	 		: 10
    readonly property int   rightSidePanelBorderWidth		: 1
    readonly property int   rightSidePanelWidth 	 		: 350
    readonly property int   rightSidePanelTitleWidth		: 124
    readonly property string rightSidePanelFontName			: "Helvetica"
    readonly property int 	rightSidePanelTextSize	 		: 20

    readonly property int   defaultPropertyWidth            : rightSidePanelWidth




}
