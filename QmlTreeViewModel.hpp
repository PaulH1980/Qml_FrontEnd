#pragma once
#include <Common/EnumString.h>
#include <Engine/ContextProvider.h>
#include <Engine/ObjectHandle.h>
#include <Engine/RootObjectPtr.h>
#include "EngineObjectProxy.hpp"
#include "AppQtRoles.hpp"

namespace Application
{
   

    struct ItemInfo
    {
        const char* itemName;
        int         itemIndex;
        int         objectType;
    };

    enum eSceneItems
    {
        ITEM_SCENE      = 0,
        ITEM_RESOURCE ,
        ITEM_STATE,
        ITEM_GROUP    ,
        NUM_ITEMS
    };

    const ItemInfo RootItems[NUM_ITEMS] =
    {
        { "Scene",      ITEM_SCENE    , QtEnums::TREEVIEW_TYPE_SCENE_ROOT    },
        { "Resources",  ITEM_RESOURCE , QtEnums::TREEVIEW_TYPE_RESOURCE_ROOT },
        { "States",     ITEM_STATE    , QtEnums::TREEVIEW_TYPE_STATE_ROOT    },
        { "Groups",     ITEM_GROUP    , QtEnums::TREEVIEW_TYPE_GROUP_ROOT    }
    };
    
    class QmlTreeViewModel : public QStandardItemModel
    {
        Q_OBJECT
    public:

        QmlTreeViewModel(QObject* parent = nullptr);
        virtual ~QmlTreeViewModel();
        void                    setContextProvider( Engine::ContextProvider* );

    public slots:


        QRoleNames              roleNames() const override;
        QVariant                data( const QModelIndex& index, int role ) const override;

        bool                    createDefaultItems();
        void                    clearAllItems();

        void                    resourceAdded(OBJECT_HANDLE id );
        void                    componentAdded( OBJECT_HANDLE nodeId, OBJECT_HANDLE compId );
        void                    entityAdded( OBJECT_HANDLE parentId, OBJECT_HANDLE childId );

        void                    entityRemoved( std::uint32_t id);
        void                    componentRemoved( std::uint32_t id );
        void                    resourceRemoved( std::uint32_t id );

        void                    selectObject(Engine::RootObject* objectPtr);


        /*
            @brief: Return a 'parent' item (direct ancestors ) of the root
        */
        QStandardItem*          getItem( eSceneItems type );
        void                    itemActivated( const QModelIndex& index );
        QStandardItem*          indexToItem(const QModelIndex& index) const;

    signals:
        void                    newObjectSelected( EngineObjectProxy );
                       
    private:
        Engine::ContextProvider*  m_contextProvider;

    };

  

}