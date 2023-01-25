#include "AppIncludes.h"
#include "AppQtRoles.hpp"
#include "EngineObjectProxy.hpp"

#include "QmlTreeViewNodeResolver.h"
#include "QmlTreeViewNodeBase.hpp"
#include "QmlTreeViewModel.hpp"

namespace Application
{
    static const QVariant    EmptyVariant = QVariant();
    static const QModelIndex EmptyIndex   = QModelIndex();

    QmlTreeViewModel::QmlTreeViewModel( QObject* parent /*= nullptr*/)
        : QStandardItemModel( parent )
        , m_contextProvider( nullptr )
    {               
    }

    QmlTreeViewModel::~QmlTreeViewModel()
    {
    }

    void QmlTreeViewModel::setContextProvider( ContextProvider* ecp )
    {
        m_contextProvider = ecp;
    }

    QRoleNames QmlTreeViewModel::roleNames() const
    {
        QRoleNames result;
        result[QtEnums::TREEVIEW_NAME_ROLE]         = "itemName";
        result[QtEnums::TREEVIEW_ICON_ROLE]         = "iconName";
        result[QtEnums::TREEVIEW_TYPE_CONTEXTMENU]  = "contextMenu";
        return result;
    }

    QVariant QmlTreeViewModel::data(const QModelIndex& index, int role) const
    {
        auto *itemPtr = itemFromIndex(index);
        if (!itemPtr)
            return EmptyVariant;
        switch (role) {
            case QtEnums::TREEVIEW_NAME_ROLE:      
                return itemPtr->data(role);
            case QtEnums::TREEVIEW_TYPE_CONTEXTMENU: {
                auto sceneItem = static_cast<QmlTreeViewNodeBase*>(itemPtr);
                return sceneItem->getContextMenuData();                              
            }
            default:
                break;
        }
        return EmptyVariant;
    }

    bool QmlTreeViewModel::createDefaultItems()
    {
        QStandardItem *parentItem = invisibleRootItem();
        for (const auto& itemInfo : RootItems )
        {
            auto* child = new QmlTreeViewNodeBase();
            child->setData( itemInfo.itemName, QtEnums::TREEVIEW_NAME_ROLE );  
            child->setObjectType(itemInfo.objectType);
            child->setContextProvider(m_contextProvider);
            parentItem->appendRow(child);
        }
        return true;
    }

    void QmlTreeViewModel::clearAllItems()
    {
        QStandardItem *parentItem = invisibleRootItem();
        for (const auto& itemInfo : RootItems)
        {
            auto child = parentItem->child(itemInfo.objectType, 0);
            if( child )
               child->removeRows(0, child->rowCount());
        }
    }

    void QmlTreeViewModel::resourceAdded(OBJECT_HANDLE id)
    {
        qDebug() << "Resource Added" << id;
        QmlTreeViewNodeResolver::AddResource(m_contextProvider, getItem(ITEM_RESOURCE), id);
    }

    void QmlTreeViewModel::componentAdded( OBJECT_HANDLE nodeId, OBJECT_HANDLE compId )
    {
        qDebug() << "Component Added Entity Id" << nodeId << " Comp Id" << compId;
    }

    void QmlTreeViewModel::entityAdded( OBJECT_HANDLE parentId, OBJECT_HANDLE childId)
    {
        qDebug() << "Entity Added Parent Id" <<  parentId<< " Child id" << childId;
    }

    void QmlTreeViewModel::componentRemoved(std::uint32_t id)
    {
        qDebug() << "Component Removed" << id;
        QmlTreeViewNodeResolver::RemoveObject(m_contextProvider, getItem(ITEM_SCENE), id);
    }

    void QmlTreeViewModel::resourceRemoved(std::uint32_t id)
    {
        qDebug() << "Resource Removed" << id;
        QmlTreeViewNodeResolver::RemoveObject(m_contextProvider, getItem(ITEM_RESOURCE), id);
    }

    void QmlTreeViewModel::selectObject(Engine::RootObject* objectPtr)
    {
        if (objectPtr)
        {
            qDebug() << "Node Selected" << objectPtr->GetTypeName().c_str();     
            emit newObjectSelected(EngineObjectProxy(objectPtr));
        }
    }

    void QmlTreeViewModel::entityRemoved(std::uint32_t id)
    {
        qDebug() << "Node Removed " << id;
        QmlTreeViewNodeResolver::RemoveObject(m_contextProvider, getItem(ITEM_SCENE), id);
    }

    QStandardItem* QmlTreeViewModel::getItem(eSceneItems type)
    {
        QStandardItem *parentItem = invisibleRootItem();
        return parentItem->child(type, 0);
    }
       
    void QmlTreeViewModel::itemActivated(const QModelIndex& index)
    {
        auto itemPtr = indexToItem(index);
        auto objectPtr = QmlTreeViewNodeResolver::GetEngineObjectForItem(itemPtr);       
        selectObject(objectPtr);
    }

    QStandardItem* QmlTreeViewModel::indexToItem( const QModelIndex& index ) const
    {
        if ( index.isValid() ) 
        {
            auto *parentItem = static_cast<QStandardItem*>(index.internalPointer());
            if (parentItem) { //return child of parent item pointed to by index row & column
                return parentItem->child(index.row(), index.column());  
            }
        }
        return invisibleRootItem();
    }

}

