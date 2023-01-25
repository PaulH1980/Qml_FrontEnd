import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.4
import QtGraphicalEffects 1.12
import FlowEventTypes 1.0 // event types enumerations
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

FlowInputNodeBase
{
    /*
        @brief: Events will be created 'on demand' based on engine backend
                See 'FunctionDefinitions.func' for data
    */
    

    
    id                                       : control
    readonly property string name            : "ShaderBlockNodeBase" //a property is needed for using 'instanceof'
    property string description              : null;    //tooltip help    
    property var    objectData               : null;   
       
    Component.onCompleted: {
        setTitleBackgroundColor( "red" )
      
    }

    /*
        @brief: Set shader function data coming from external file
    */
    function populateFlowNode( jsonData ) {
       control.objectData  = jsonData                         //copy jsondata
       
       parseReturnType      ( jsonData )
       parseFlowNodeType    ( jsonData )
       parseAnnotations     ( jsonData ) 
       console.log( "Creating FlowNode Fields" );
       
       //Flownode from glsl function
       if( AppScripts.isDefined( jsonData.FunctionName ) )   
            parseShaderFunction( jsonData ) //Flownode from input descriptor
       else if( AppScripts.isDefined( jsonData.InputDescriptor ) )  //Input Descriptor(vec3, vec4 etc )
            parseInputDescriptors( jsonData )
       else if( AppScripts.isDefined( jsonData.EventValues ) ) //EVENTS
            parseEventValues( jsonData )   
       else if( AppScripts.isDefined( jsonData.UniformLayoutDescriptor ) ) //UBO SSBO descriptor
            parseUniformLayout( jsonData )      

       fitItemToContents()
       enableOutPorts( true )
    }      





    function parseFlowNodeType( jsonData )
    {
        if( !AppScripts.isDefined( jsonData.FlowNodeType ) )
        {
            console.log( "Undefined FlowNodeType" )
            return;
        }
        if( jsonData.FlowNodeType === "ClassBlock" )
        {
            setTitleBackgroundColor( "blueviolet" )
        }
        else if( jsonData.FlowNodeType === "ShaderBlock" )
        {
            setTitleBackgroundColor( "royalblue" )
        }
        else if( jsonData.FlowNodeType === "EventBlock" )
        {
            setTitleBackgroundColor( "green" )
        }
        else if( jsonData.FlowNodeType === "UniformShaderBlock" )
        {
             setTitleBackgroundColor( "blue" )             
        }

        else 
            console.log( "Unknown FlowNodeType " + jsonData.FlowNodeType )
    }

    function parseAnnotations( jsonData )
    {
        if( AppScripts.isDefined( jsonData.Annotations.$Title ) ){
             control.title      = jsonData.Annotations.$Title
             control.objectName = jsonData.Annotations.$Title
        }
        else
            console.log("Empty Object-Name For FlowNode")
        if( AppScripts.isDefined( jsonData.Annotations.$Description ) )
            control.description = jsonData.Annotations.$Description
        if( AppScripts.isDefined( jsonData.Annotations.$PreferredWidth ) ) {
            var preferredWidth = jsonData.Annotations.$PreferredWidth
            setWidth( preferredWidth)
        }
    }  

    function parseReturnType( jsonData )
    {
        if( AppScripts.isDefined( jsonData.ReturnType ) && jsonData.ReturnType != "void" )  
            addOutputItem( "Out" , jsonData.ReturnType, getObjectName )
    }

    /*
        @brief: Parse Shader Function Values
    */
    function parseShaderFunction( jsonData )
    {
       console.log( "parsing shader function" )
       if( AppScripts.isDefined( jsonData.FormalParameters ) )
       {
           for( let i in jsonData.FormalParameters )
           {
              const  param = jsonData.FormalParameters[i]
              if( param.ArgFlags & 0x02 ) // input see ParseShaderFunction.h
                  addInputItem( param.ArgName, [param.ArgType] )
              if( param.ArgFlags & 0x04 ) //output 
                  addOutputItem( param.ArgName, [param.ArgType] )
           }
       }
    }

    /*
        @brief: Parse Event Values
    */
    function parseEventValues( jsonData )
    {
        console.log( "parsing event values" )
        //attach output values of event
        for( let i in jsonData.EventValues ) {
           const ev = jsonData.EventValues[i]
           const evType =  ev.ValueType
           addOutputItem   ( ev.ValueName, evType, getObjectName )
       }
    }

    function parseUniformLayout( jsonData )
    {
        console.log( "parsing uniform layout" )
        for( let i in jsonData.UniformLayoutDescriptor ) {
            const ul = jsonData.UniformLayoutDescriptor[i]
            const ulType = ul.ResourceType;
            const ulName = ul.Name;
            const ulAddToUi = ul.ShowInUi
            if( ulAddToUi === "false" )
                continue          
            addOutputItem( ulName, ulType, getObjectName )
        }
    }

    function parseInputDescriptors( jsonData )
    {
        for( let i in jsonData.InputDescriptor )
        {
            var desc = jsonData.InputDescriptor[i]
            switch( desc.Type )
            {
                case "bool" : parseBoolDescriptor( desc ); break;
                case "uint" : parseUIntDescriptor( desc ); break;
                case "int"  : parseIntDescriptor( desc ); break;
                case "float": parseFloatDescriptor( desc ); break;
                case "StringEnum": parseStringEnumDescriptor( desc ); break;
                default : console.log( "Unknown Descriptor Type: " + desc.Type );
            }
        }
    }

   

    function parseBoolDescriptor( arg )
    {
         var itemArgs = {
            "height"                : 24,
            "width"                 : getContentWidth(),            
            "leftMargin"            : 8,
            "rightMargin"           : 8,           
            "showLabel"             : true,
            "labelName"             : arg.Name,
            "inputValue"            : arg.Value,
            "labelAlignment"        : Text.AlignLeft,
            "preferredLabelWidth"   : AppScripts.isDefined( arg.LabelWidth ) ? arg.LabelWidth : 96
        }; 
        var item = addItemToLayout( "LabelCheckBoxInput.qml", itemArgs )      
    }

    function parseIntDescriptor( arg )
    {
         var itemArgs = {         
            "height"                : 24,
            "width"                 : getContentWidth(),      
            "leftMargin"            : 8,
            "rightMargin"           : 8,
            "numDimensions"         : 1,
            "showLabels"            : true,
            "labelNames"            : [ arg.Name ],
            "componentValues"       : [ arg.Value ],
            "labelAlignment"        : Text.AlignLeft,
            "preferredLabelWidth"   : AppScripts.isDefined( arg.LabelWidth ) ? arg.LabelWidth : 96
        }; 
        var item = addItemToLayout( "VeciWidget.qml", itemArgs ) 
        setMinMaxForItem( arg, item );
    }

    function parseUIntDescriptor( arg )
    {
       var itemArgs = {         
            "height"                : 24,
            "width"                 : getContentWidth(),      
            "leftMargin"            : 8,
            "rightMargin"           : 8,
            "numDimensions"         : 1,
            "showLabels"            : true,
            "labelNames"            : [ arg.Name ],
            "componentValues"       : [ arg.Value ],
            "labelAlignment"        : Text.AlignLeft,
            "preferredLabelWidth"   : AppScripts.isDefined( arg.LabelWidth ) ? arg.LabelWidth : 96
        }; 
        var item = addItemToLayout( "VeciWidget.qml", itemArgs ) 
        setMinMaxForItem( arg, item );
    }


    function parseFloatDescriptor( arg )
    {
        var itemArgs = {         
            "height"                : 24,
            "width"                 : getContentWidth(),      
            "leftMargin"            : 8,
            "rightMargin"           : 8,
            "numDimensions"         : 1,
            "showLabels"            : true,
            "labelNames"            : [ arg.Name ],
            "componentValues"       : [ arg.Value ],
            "labelAlignment"        : Text.AlignLeft,
            "preferredLabelWidth"   : AppScripts.isDefined( arg.LabelWidth ) ? arg.LabelWidth : 96
        }; 
        var item = addItemToLayout( "VecfWidget.qml", itemArgs )  
        setMinMaxForItem( arg, item );
    }

    function parseStringEnumDescriptor(  arg )
    {
           //convert selection items to compatible combobox format
           var comboSelection = [];
           var selectedItem   = arg.Value
           for( var i in arg.Selection )
           {
              var item = arg.Selection[i] //#todo for gpu descriptors selection is only a string
              var selItem ={
                "Name"      : item,
                "Selected"  : selectedItem == item,
                "Index"     : i,
                "Value"     : i  //see Renderconstants.h for LUT
              }
              comboSelection.push( selItem )
           }
        
           var itemArgs = {
            "height"                : 24,
            "width"                 : getContentWidth(),            
            "leftMargin"            : 8,
            "rightMargin"           : 8,           
            "showLabel"             : true,
            "labelName"             : arg.Name,
            "inputValues"           : comboSelection,
            "labelAlignment"        : Text.AlignLeft,
            "preferredLabelWidth"   : AppScripts.isDefined( arg.LabelWidth ) ? arg.LabelWidth : 96
        }; 
        var item = addItemToLayout( "LabelComboBoxInput.qml", itemArgs )    

    }

    function parseVec2fDescriptor(  arg )
    {
        console.log("parsing vec2f")
    }

    function parseVec3fDescriptor(  arg )
    {
         console.log("parsing vec3f")
    }


    function parseVec4fDescriptor(  arg )
    {
         console.log("parsing vec4f")
    }

    function parseVec2ifDescriptor(  arg )
    {
         console.log("parsing vec2i")
    }

    function parseVec3ifDescriptor(  arg )
    {
         console.log("parsing vec3i")
    }

    function parseVec4ifDescriptor(  arg )
    {
         console.log("parsing vec4i")
    }

    function parseMat2fDescriptor( arg )
    {
         console.log("parsing mat2")
    }

    function parseMat3fDescriptor(  arg )
    {
        console.log("parsing mat3")
    }

    function parseMat4fDescriptor(  arg )
    {
        console.log("parsing mat4")
    }

    function setMinMaxForItem( arg, item )
    {
        if( AppScripts.isDefined( arg.Min ) )
        {
            item.min = arg.Min           
            item.isRanged = true
        }
        if( AppScripts.isDefined( arg.Max ) )
        {
            item.max = arg.Max           
            item.isRanged = true
        }
    }
}
