#pragma once

#include <Common/ClassInfo.h>
#include <Engine/EngineContextPtr.h>
#include <Engine/RootObjectPtr.h>
#include <IO/MenuEntry.h>
#include <IO/JSonObject.h>
#include "QtHeaders.h"

namespace Application
{
   
    /*
        @brief: This class creates context menu entries for the various UI 
        Widgets, all menu data is return as json-string
    */
    class QmlContextMenuResolver
    {
    public:              
        /*
            @brief: Create a json from menu entries
        */
        static IO::JSonObject   CreateJsonFromMenuEntries(const std::vector<IO::MenuEntry>& entries);

        /*
            @brief: Create a menu entry separator
        */
        static IO::MenuEntry    CreateSeparator();    

        ///*
        //    @brief: Scene-node contextmenu data, this will pop-up when 
        //    user clicks on a node item
        //*/
        //static QString          NodeContextMenuData( Engine::EngineContext*, Engine::RootObject* curObject = nullptr );

        ///*
        //    @brief: Component menu data, will pop-up when user clicks on a 
        //    component item
        //*/
        //static QString      ComponentContextMenuData(Engine::EngineContext* , Engine::RootObject* curObject = nullptr);


        ///*
        //    @brief: Create a sub menu for class <--> child data, uuid will be the command to do with the class name
        //*/
        //static QString      CreateClassSubMenuData( 
        //    const Common::ClassNameMap& classMap, const std::string& uuid, Engine::RootObject* curObject = nullptr);

        ///*
        //  @brief: Resource menu data, will pop-up when user clicks on a
        //  component item
        //*/
        //static QString      ResourceContextMenuData(Engine::EngineContext*, Engine::RootObject* curObject = nullptr);
        //
        ///*
        //    @brief: Context Menu for Resource-Root data
        //*/
        //static QString      ResourceRootContextMenuData(Engine::EngineContext*);


        ///*
        //    @brief: Main view menu data, will pop-up when user clicks in the 
        //    main viewport
        //*/
        //static QString      MainViewContextMenuData( Engine::EngineContext* );
        //
        ///*
        //    @brief: Sub-Menu of all user creatable scene-nodes
        //*/
        //static QString      SceneNodeSubMenuData( Engine::EngineContext* );

        ///*
        //    @brief: Sub-Menu of all tools
        //*/
        //static QString      ToolsSubMenuData(Engine::EngineContext*, Engine::RootObject* curObject = nullptr);

        ///*
        //    @brief: Sub-Menu of user creatable primitives
        //*/
        //static QString      PrimitvesSubMenuData(Engine::EngineContext*);

        ///*
        //    @brief: Create context menu for sub-resource menu items
        //*/
        //static QString      ResourceSubMenuData( Engine::EngineContext*, const std::string& objType );



    };
}