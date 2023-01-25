#pragma once
#include "QtHeaders.h"
#include <Engine/EventDescriptor.h>
#include <Render/VertexLayout.h>
#include <vector>

namespace Application
{

    class QtEngineEventTypes : public QObject
    {
        Q_OBJECT
    public:
        Q_ENUMS(eEventTypes);

        static void Register() {
            qmlRegisterType<QtEngineEventTypes>( "EngineEventTypes", 1, 0, "EventTypes" );
        }
    };
    
    class QtEnums : public QObject
    {
        Q_OBJECT

    public:
        enum ERoleName
        {
            PROPERTY_GRID_START = Qt::UserRole + 1,
            GROUP_ROLE = PROPERTY_GRID_START,
            QML_ROLE,	    //qml file
            INSPECTOR_ROLE, //describes which type of qml-property we are parsing
            //Shared among all properties
            TITLE_ROLE,
            INDEX_ROLE,
            HEIGHT_ROLE,
            VISIBLE_ROLE,
            X_LABEL_ROLE,
            Y_LABEL_ROLE,
            Z_LABEL_ROLE,
            W_LABEL_ROLE,
            PROPERTY_FLAGS_ROLE, //backend property flags
            LIMIT_MIN_ROLE,     //Query if the property has min or max values
            LIMIT_MAX_ROLE,     //Query if the property has min or max values

            //sub-classed roles
            VARIANT_ROLE_START,
            BOOL_ROLE = VARIANT_ROLE_START,
            UNSIGNED_ROLE,      //signed input field
            INTEGER_ROLE,       //integer input field
            FLOAT_ROLE,		    //float input field
            VECTOR2_ROLE,		//vector2 input field
            VECTOR2I_ROLE,      //vector2 integer
            VECTOR3_ROLE,		//vector3 input field
            VECTOR3I_ROLE,      //vector2 integer
            VECTOR4_ROLE,       //vector4 input field          
            VECTOR4I_ROLE,      //vector2 integer
            PLANE_ROLE,         //vector4 input field
            ROTATION_ROLE,      //vector4 input field
            COLOR_ROLE,	        //color input field          
            TEXTINPUT_ROLE,		//text/string input field
            FILE_SOURCE_ROLE,   //File input field           
            IMAGE_ROLE,         //Image input field   
            BBOX2_ROLE,
            BBOX3_ROLE,
            INT_RANGE_ROLE,
            FLOAT_RANGE_ROLE,

            ENUM_ROLE,
            SLIDER_ROLE,        //if ranged and 
            JSON_OBJECT_ROLE,

            VARIANT_ROLE_END = SLIDER_ROLE,           

            PROPERTY_GRID_END = VARIANT_ROLE_END,
            
            TREEVIEW_START,
            TREEVIEW_NAME_ROLE = TREEVIEW_START,
            TREEVIEW_ICON_ROLE,      
            //types
            TREEVIEW_TYPE_UNKNOWN,
            TREEVIEW_TYPE_RESOURCE,
            TREEVIEW_TYPE_COMPONENT,
            //root nodes
            TREEVIEW_TYPE_NODE_ROOT,
            TREEVIEW_TYPE_RESOURCE_ROOT,
            TREEVIEW_TYPE_SCENE_ROOT,
            TREEVIEW_TYPE_MEASURE_ROOT,
            TREEVIEW_TYPE_STATE_ROOT,
            TREEVIEW_TYPE_GROUP_ROOT,
            TREEVIEW_TYPE_CONCRETE_RESOURCE,

            TREEVIEW_TYPE_NODE,
            TREEVIEW_TYPE_MEASURE,
            TREEVIEW_TYPE_VIEWSTATE,
            TREEVIEW_TYPE_SECTION_NAME,
            TREEVIEW_TYPE_CONTEXTMENU,
            TREEVIEW_END = TREEVIEW_TYPE_VIEWSTATE,

            BUTTON_OK,
            BUTTON_CANCEL
            
        };
        Q_ENUMS(ERoleName)

        static void RegisterQEnums();        
    };
}