#pragma once

#include <Engine/EngineContextPtr.h>
#include "Engine/RootObjectPtr.h"
#include <Common/Patterns.h>
#include <Engine/ContextProvider.h>
#include "QmlContextMenuResolver.h"
#include "QmlTreeViewNodeBase.hpp"
#include "QmlTreeViewModel.hpp"
#include "QmlTreeViewNodeBase.hpp"

namespace Application
{
    /*
        @brief: Utility class used for resolving qml-properties from engine/backend properties
    */
    class QmlTreeViewNodeResolver
    {
        using RootObject = Engine::RootObject;
    public:

        /*
            @brief: Create treeview scene items
        */
        static bool             CreateSceneItems( Engine::ContextProvider* provider, QStandardItem* rootItem );
        
        /*
            @brief: Create treeview resource items
        */
        static bool             CreateResourceItems(Engine::ContextProvider* provider, QStandardItem* rootItem );
        
        /*
            @brief: Returns an object that can be used for modification, return nullptr upon failure
        */
        static RootObject*      GetEngineObjectForItem(  QStandardItem* rootItem );

        /*
            @brief: Removes an item from the tree view   
        */
        static bool             RemoveObject(Engine::ContextProvider* provider, QStandardItem* rootItem,  std::uint32_t objectId );


        /*
            @brief: Add Component or node
        */
       // static bool             AddObject(Engine::ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId);

       
        /*
            @brief: Add a resource
        */
        static bool             AddResource (Engine::ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId);
        

        /*
            
        */
        static bool             AddComponent(Engine::ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId, std::uint32_t);
        
        /*

       */
        static bool             AddEntity(Engine::ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId, std::uint32_t);

        /*
            @brief: Returns the standard item that contains engine-object, or nullptr if not found
        */
        static QStandardItem*   ItemForObject( QStandardItem* rootItem,  Engine::RootObject* theObject );

        /*
            @brief: Return an item for an engine object id
        */
        static QStandardItem*   ItemForObjectId( QStandardItem* rootItem, std::uint32_t objectId );
    };
}




