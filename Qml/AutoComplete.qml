import QtQuick 2.7
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import "."

QtObject 
{	
    property int maxHistoryItems	 	: 50 //TODO implement
    property int curCommandHistorIdx	: 0  //current index of command history
    property var registeredItems 		: [] //alphabetically sorted list of string( commands )
    property var commandHistory  		: [] //past commands will be stored here
    property string searchString		: "" //current search string


    function beginRebuild()
    {
        clearDictionary()
    }

    function registerNewItem( newItem )
    {
        registeredItems.push( newItem )
    }

    function removeItem ( theItem )
    {
        var indx = indexOf( theItem )
        if( indx === -1 )
            return false
        registeredItems.remove( indx )
        return true;
    }

    function finishRebuild()
    {
        registeredItems.sort()
    }

    function clearDictionary()
    {
        registeredItems = []
    }

    function indexOf( theItem )
    {
        return registeredItems.indexOf( theItem )
    }

    function addItemToCommandHistory( historyItem )
    {
        var numItems = commandHistory.length
        //don't add if top of the stack is  the same
        if( numItems && commandHistory[numItems-1]  === historyItem )
            return;
        curCommandHistorIdx = numItems + 1;
        commandHistory.push( historyItem )
    }

    function clearHistory()
    {
        curCommandHistorIdx= 0;
        commandHistory = []
    }

    //Return the previous command from history, or an empty string if
    //we reach the beginning
    function getPreviousCommand( )
    {
        if( curCommandHistorIdx > 0 )
            return commandHistory[--curCommandHistorIdx]
        return ""
    }

    //Return the next command from history, or an empty string if
    //we reached the end
    function getNextCommand( )
    {
        var numItems = commandHistory.length
        if( (curCommandHistorIdx + 1) < numItems )
            return commandHistory[++curCommandHistorIdx]

        return ""
    }

    /*
        Does a 'guess' to retrieve a best string guess, based on partial user input
    */
    function getNextItem( curItem )
    {
        var indices = indexOfBestItem( searchString )
        if( indices.length === 0 )
            return ""
        for( var i = 0; i < indices.length; ++i )
        {
            var idx 	= indices[i]
            var next 	= (i+1)%indices.length
            if( registeredItems[idx] === curItem )
            {
                var idxNext = indices[next]
                return registeredItems[idxNext]
            }
        }
        return registeredItems[indices[0]]	//return the first found item
    }

    //Helper function for 'getNextItem()'
    function indexOfBestItem( curItem )
    {
        var result =[]
        if( searchString.length == 0 )
            return result
        for( var i = 0; i < registeredItems.length; ++i )
            if( registeredItems[i].startsWith( curItem ) )
                result.push( i )
        return result
    }
}
