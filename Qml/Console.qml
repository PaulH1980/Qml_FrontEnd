
import QtQuick 2.7
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
//import FileSystem 1.0
import "."

Rectangle
{

    readonly property color logColorInfo 	: Qt.rgba( 1.0, 1.0, 1.0,  1 )
    readonly property color logColorSucces 	: Qt.rgba( 0.5, 1.0, 0.5,  1 )
    readonly property color logColorDebug	: Qt.rgba( 1.0, 1.0, 0.25, 1 )
    readonly property color logColorWarning : Qt.rgba( 1.0, 0.5, 0.0,  1 )
    readonly property color logColorError 	: Qt.rgba( 1.0, 0.0, 0.0,  1 )
    readonly property var commandList	:
        [
        //"app_new","app_save", "app_saveAs", "app_open", "app_clear", "app_quit",
        //"edit_undo", "edit_redo", "edit_options",
        "con_clear", "con_dump", "con_listCmds", "con_clrHistory", "con_close",
        "misc_list_resources",
        "script_load", "script_run"
    ]

    property AutoComplete autoComplete 	: AutoComplete{ id : autoComplete }

    objectName							: "userConsole"
    id									: userConsole
    color								: Style.lightBackGroundColor
    border.width						: 2
    border.color						: "black"

    ColumnLayout
    {
        anchors.fill		: parent
        spacing 			: 0
        Flickable
        {
            Layout.fillWidth	 	: true
            Layout.fillHeight		: Style.defaultFontSize + 8
            ScrollBar.vertical		: ScrollBar { }

            TextArea.flickable	: TextArea
            {
                readOnly					: true
                id							: logText
                wrapMode					: TextArea.Wrap
                font.pixelSize			  	: Style.defaultFontSize
                font.family				  	: Style.defaultFont
                color					  	: "White"
                textFormat					: Text.RichText
                smooth					: true
                focus					: false
                antialiasing			: true
                background: Rectangle
                {
                    width  		: parent.width
                    height 		: parent.height
                    color		: Style.defaultBackGroundColor
                    border.color: Style.defaultBorderColor
                    border.width: 1
                }
            }
        }//flickable
        TextField
        {
            property bool fromSuggestion	: false //if 'true' then text changed won't get propagated to the autocompleter

            Layout.fillWidth	 			: true
            Layout.minimumHeight			: Style.defaultFontSize + 8

            id								: consoleInputText
            wrapMode						: TextArea.NoWrap
            font.pixelSize					: Style.defaultFontSize
            font.family						: Style.defaultFont
            color							: Style.consoleInputTextColor
            smooth							: true
            antialiasing					: true

            background: Rectangle
            {
                width  			: parent.width
                height 			: parent.height
                color			: Style.lightBackGroundColor
                border.color	: Style.defaultBorderColor
                border.width	: 1
            }
            onAccepted:
            {
                var txt = consoleInputText.text
                if( txt.length > 0 )
                {
                    parseInputString(txt);
                    clearInput()
                }
            }
            onTextChanged: //really needed 'textChanging' here
            {
                if( !consoleInputText.fromSuggestion )
                {
                    autoComplete.searchString =  consoleInputText.text
                }
            }
            /*
                Tab key will give the next match in the dictionary,
                up & down keys will iterate through previous succesful commands
            */
            Keys.onPressed:
            {
                consoleInputText.fromSuggestion = false
                if( event.key === Qt.Key_Up)
                {
                    event.accepted = true
                    var cmd = autoComplete.getPreviousCommand()
                    setInputCommand( cmd, true )
                }
                else if( event.key === Qt.Key_Down)
                {
                    event.accepted = true
                    var cmd = autoComplete.getNextCommand()
                    setInputCommand( cmd, true )

                }
                else if( event.key === Qt.Key_Tab)
                {
                    event.accepted = true
                    if(consoleInputText.text.length > 0 )
                    {
                        var nextItem = autoComplete.getNextItem( consoleInputText.text )
                        setInputCommand( nextItem, true )
                    }
                }
            }
        }
    }

    function setInputCommand( cmd, isSuggestion )
    {
        if( cmd !== "" )
        {
            consoleInputText.fromSuggestion = isSuggestion
            consoleInputText.text = cmd
            consoleInputText.select( 0, cmd.length )
        }
    }

    Component.onCompleted:
    {
        buildDictionary()
    }

    function parseInputString( txt )
    {
        var commandList = txt.split(" ")
        var succes  = false
        switch( commandList[0] )
        {
        case 'con_listCmds':
            succes = printCommands()
            break;
        case 'con_clear':
            succes = clearLog()
            break;
        case 'con_clrHistory':
            succes = clearConHistory()
            break;
        case 'con_close':
            succes = closeConsole()
            break;
        case 'con_dump':
            succes = writeConsoleToFile( commandList[1] )
            break;
        case 'script_load':
            succes = loadScript( commandList[1] )
            break;
        case 'misc_list_resources':
            succes = listResources()
            break;
        default:
            //generate a sub array, with first name omitted
            var subArray = commandList.slice( 1, commandList.length );
            succes = CommandList.executeQt( commandList[0], subArray )
        }
        if( succes )
        {
            autoComplete.addItemToCommandHistory( txt )
            //addLogMessage( "[Executed command]\t\t" + txt, true, logColorSucces )
        }
    }


    function printCommands()
    {
        addLogMessage("*******CommandList*******\n", true, logColorInfo);
        for( var i = 0; i < autoComplete.registeredItems.length; i++ )
            addLogMessage( autoComplete.registeredItems[i], true, logColorInfo )
        return true
    }

    function listResources()
    {
        ResourceManager.printAllResources()
        return true
    }


    function close()
    {
        autoComplete.searchString = ""
        consoleInputText.text 	  = ""
    }

    function open()
    {
        consoleInputText.forceActiveFocus()
    }



    function closeConsole( )
    {
        userConsole.parent.close()
        return true;
    }

    function loadScript( fileName )
    {
        var result = validateFileName( fileName )
        if( !result )
            return false;

        var value = ScriptEngine.loadAndRunScript( fileName, result )
        return result
    }

    function clearInput()
    {
        consoleInputText.text = ""
        return true
    }

    function clearConHistory()
    {
        autoComplete.clearHistory()
        return true
    }

    function clearLog()
    {
        logText.text = ""
        return true
    }


    function registerConsoleVar( cvar )
    {
        commandList.push( cvar )
        buildDictionary()
    }

    function unRegisterConsoleVar( cvar )
    {
        var index = commandList.indexOf( cvar  )
        if( index == -1 )
            return

        commandList.remove( index )
        buildDictionary()
    }

    function buildDictionary()
    {
        autoComplete.beginRebuild()
        for( var i = 0 ; i <  commandList.length; ++i )
            autoComplete.registerNewItem( commandList[i] )
        autoComplete.finishRebuild()
    }

    function validateFileName( fileName, mustExist )
    {
        if( fileName === undefined || fileName === null )
        {
            addColoredLogMessage(  "[File name undefined]", logColorError )
            return false;
        }
        if( mustExist && !FileSystem.fileExists( fileName ) )
        {
            addColoredLogMessage( "[File not found]\t\t" + fileName, logColorError )
            return false
        }
        return true;
    }

    function writeConsoleToFile( fileName )
    {
        var result = validateFileName( fileName, false )
        if( !result )
            return false;

        return FileSystem.writeTextFile( logText.text, fileName )
    }

    function rgbToHex(r, g, b)
    {
        return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
    }

    function makeColoredText( txt, red, green, blue )
    {
        var prep  = "<font color= \"" + rgbToHex( Math.round(red), Math.round(green), Math.round(blue) ) + "\">"
        var result = prep + txt + "<\font>"
        return result
    }

    function getTimeString()
    {
        var currentDate = new Date()
        var dateString = " [ " + currentDate.toLocaleTimeString(locale, Locale.LongFormat) + " ] ";
        return dateString
    }

    function addLogMessage( txt, rgb )
    {
        addColoredLogMessage( txt, rgb ); //add color tags
    }

    function addColoredLogMessage( txt, rgb )
    {
        logText.append( makeColoredText( txt, rgb.r * 255.0,rgb.g * 255.0, rgb.b * 255.0 ) )
    }



}
