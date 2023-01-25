pragma Singleton
import UuidGen 1.0
import QtQuick 2.7

QtObject
{
    
    
    readonly property real   flowVersion               : 0.01

    readonly property int    flowPortInput             : 1
    readonly property int    flowPortOutput            : 2

    readonly property int    flowPreviewItemSize       : 128
    readonly property var    uuidGen                   : UuidGen{}

    readonly property color  acceptConnectionColor     : Qt.rgba( 0, 1, 1, 1 )
    readonly property color  connectedColor            : Qt.rgba( 0/255,    255/255,  128/255, 1)
    readonly property color  unConnectedColor          : Qt.rgba( 128/255,  128/255,  160/255, 1)
    readonly property color  pressedColor              : Qt.rgba( 0/255,    192/255,  255/255, 1)
    readonly property color  enabledColor              : Qt.rgba( 64/255,   128/255,  255/255, 1 )
    readonly property color  disabledColor             : Qt.rgba( 128/255,  128/255,  128/255, 1 )

    //operand enums
    readonly property int pendingOperand        : -1
    readonly property int boolOperand           : 0
    //
    readonly property int intOperand            : 1
    readonly property int floatOperand          : 2
    //vectors
    readonly property int vec2iOperand          : 3
    readonly property int vec2fOperand          : 4
    readonly property int vec3iOperand          : 5
    readonly property int vec3fOperand          : 6
    readonly property int vec4iOperand          : 7
    readonly property int vec4fOperand          : 8
    readonly property int colorOperand          : 9

    readonly property int rotationOperand       : 10
    readonly property int stringOperand         : 11
    readonly property int texture1dOperand      : 12
    readonly property int texture2dOperand      : 13
    readonly property int texture3dOperand      : 14
    readonly property int textureCubeOperand    : 15
    readonly property int imageOperand          : 16

 
    

    readonly property string stringMask            : "std::string" //no string in glsl
    readonly property string boolMask              : "bool"
    
    readonly property string vec1iMask             : "int"
    readonly property string vec2iMask             : "ivec2"
    readonly property string vec3iMask             : "ivec3"
    readonly property string vec4iMask             : "ivec4"

    readonly property string vec1uiMask            : "uint"
    readonly property string vec2uiMask            : "uivec2"
    readonly property string vec3uiMask            : "uivec3"
    readonly property string vec4uiMask            : "uivec4"

    readonly property string vec1fMask             : "float"
    readonly property string vec2fMask             : "vec2"
    readonly property string vec3fMask             : "vec3"
    readonly property string vec4fMask             : "vec4"

    readonly property string mat2fMask             : "mat2"
    readonly property string mat3fMask             : "mat3"
    readonly property string mat4fMask             : "mat4"
    
    readonly property string noneMask              : "none"
    readonly property string anyMask               : "any"
    
    //accept any operand
    readonly property int anyOperand            : 17
    //from 'int' to color operand'
    readonly property int anyMathOperand        : 18
    //vector components including rgba
    readonly property int anyVectorOperand      : 19

    readonly property int pendingOperation      : -1

    //binary operations enums
    readonly property int plusOperation         : 1
    readonly property int minusOperation        : 2
    readonly property int mulOperation          : 3
    readonly property int divOperation          : 4
    readonly property int moduloOperation       : 5 //modulo on int, fract on float


    function operandToTypeName( operandType )
    {
       return operandType;
    }

    function typeToGlslType( operandType )
    {
       return operandType;
    }
}
