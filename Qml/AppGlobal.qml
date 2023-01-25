pragma Singleton
import QtQuick 2.7

Item 
{
    id: global
    readonly property var eventTypes    : ApplicationGlobals.engineEventTypes.EventTypeInfo 
    readonly property var vertexFormats  : ApplicationGlobals.vertexFormats
    readonly property var uniformFormats : ApplicationGlobals.uniformFormats
   

    function print2()
    {
        console.log("HELLOWORLD")
    }

    
    function eventTypeForId(  id )
    {
       var result = eventTypes.filter( x => x.EventType === id );
       if( result === null )
           console.log( "invalid id " + id );
       return result[0];
    }

    function eventTypeForShaderKeyWord( keyword)
    {
       var result =  eventTypes.filter( x => x.ShaderKeyWord === keyword );
       if( result === null )
           console.log( "invalid keyword " + keyword );
       return result[0];
    }

    function eventTypeForCppKeyWord( keyword )
    {
       var result = eventTypes.filter( x => x.CppKeyWord === keyword );
       if( result === null )
           console.log( "invalid keyword " + keyword );
       return result[0];
    }
    
    function nameFromEvent( event )
    {
        return event.EventName;
    }

    function shaderKeyWordFromEvent( event )
    {
        return event.ShaderKeyWord;
    }

    function cppKeyWordFromEvent( event )
    {
        return event.CppKeyWord;
    }

    function idFromEvent( event )
    {    
       return event.EventType;
    }

    function idFromShaderKeyWord( keyword )
    {
        var result = idFromEvent( eventTypeForShaderKeyWord( keyword ) );
        if( result === undefined )
            console.log( "invalid keyword " + keyword );
        return result;
    }
    
    function idFromCppKeyWord( keyword )
    {
        return idFromEvent( eventTypeForCppKeyWord( keyword ) );
    }
    
    function shaderKeyWordFromEventId( id )
    {
        return shaderKeyWordFromEvent ( eventTypeForId( id ) );
    }

    function cppKeyWordFromEventId( id )
    {
        return cppKeyWordFromEvent ( eventTypeForId( id ) );
    }

}
