#include <stack>
#include "QmlTreeViewNodeResolver.h"
#include "QtHeaders.h"
#include "AppQtRoles.hpp"
#include "AppIncludes.h"

namespace Application
{
    /*
        @brief: Creates a qt standard item, for a current scene-node,
        creates sub-items for all components & child-nodes for current node
    */
    class NodeInfoGatherer : public NodeVisitorBase
    {
    public:
        NodeInfoGatherer(QStandardItem* rootItem, ContextProvider* provider)
            : m_parentItem(rootItem) //active parent item
            , m_provider(provider)
        {          
        }

        eVisitorResult onNodeEnter(EntityBase& node) override
        { 
            return VISITATION_SUCCESS;
        }

        eVisitorResult onNodeVisit(EntityBase& node) override 
        { 
            auto contextPtr = node.getContext();
            //create a new node item
            auto* newItem = new QmlTreeViewNodeBase( &node, m_parentItem );          
            newItem->setObjectType(QtEnums::TREEVIEW_TYPE_NODE);
            newItem->setContextProvider(m_provider);
            for (const auto& compPtr : node.getComponents()) //create items for this node its components
            {
                auto* compItem = new QmlTreeViewNodeBase( compPtr, newItem );
                compItem->setObjectType(QtEnums::TREEVIEW_TYPE_COMPONENT);           
                compItem->setContextProvider(m_provider);
            }
            m_parentItem = newItem;            
            return VISITATION_SUCCESS;
        }

        eVisitorResult onNodeExit(EntityBase& node) override
        { 
            m_parentItem =  m_parentItem->parent();
            assert(m_parentItem && "Parent Item Cannot Be Null");
            return VISITATION_SUCCESS;
        }
        QStandardItem* m_parentItem;
        ContextProvider* m_provider;
    };
}





namespace Application
{

    std::uint32_t GetParentIdOfObject(RootObject* theObject)
    {
        if (auto nodePtr = dynamic_cast<EntityBase*>(theObject)) 
            return nodePtr->getParent()->getObjectId();  
        else if (auto compPtr = dynamic_cast<ComponentBase*>(theObject))
            return compPtr->getEntityId();
        assert(false && "Invalid Object");
        return INVALID_INDEX;
    }

    const int GetItemTypeForObject(RootObject* theObject)
    {
        if (auto nodePtr = dynamic_cast<EntityBase*>(theObject))
            return QtEnums::TREEVIEW_TYPE_NODE;
        else if (auto compPtr = dynamic_cast<ComponentBase*>(theObject))
            return  QtEnums::TREEVIEW_TYPE_COMPONENT;
        else if (auto resPtr = dynamic_cast<ResourceBase*>(theObject))
            return QtEnums::TREEVIEW_TYPE_RESOURCE;
        
        assert(false && "GetItemForObject");
        return -1;
    }

    /*
        @brief: Return the current resource tree-item
    */
    QmlTreeViewNodeBase* GetParentItemForResource( ContextProvider* provider, QStandardItem* resourceRootItem, RootObject* theObject )
    {
        //one time initialize of resource-tree-tem
        if (!resourceRootItem->hasChildren())
        {
            const auto& classInfoMap = provider->getContext()->getClassInfoMap();
            const auto registeredResources = classInfoMap.getClassesOfType<ResourceBase>();
            for ( const auto& classInfo : registeredResources )
            {
                 auto* child = new QmlTreeViewNodeBase();
                 child->setNodeName( QString( classInfo.m_className.c_str() ) );
                 child->setObjectType(QtEnums::TREEVIEW_TYPE_CONCRETE_RESOURCE);
                 child->setContextProvider(provider);
                 resourceRootItem->appendRow(child);
             }
        }       
        //#todo speed up + better class name checking
        for (int row = 0; row < resourceRootItem->rowCount(); ++row) {
            auto* childItem = static_cast<QmlTreeViewNodeBase*>(resourceRootItem->child(row, 0));
           
            const auto childName = childItem->data(QtEnums::TREEVIEW_NAME_ROLE).toString();
            if (childName == QString(theObject->GetTypeName().c_str() ) )           
                return childItem;            
        }
        assert( false && "Invalid Item" );
        return nullptr;
    }

    bool QmlTreeViewNodeResolver::CreateSceneItems(ContextProvider* provider, QStandardItem* parentItem )
    {
        const auto rootNode = provider->getContext()->getWorldEntity();       
        NodeInfoGatherer theVisitor( parentItem, provider );
        bool succeed = rootNode->accept(&theVisitor); 
        return succeed;
    }

    bool QmlTreeViewNodeResolver::CreateResourceItems(ContextProvider* provider,
        QStandardItem* parentItem )
    {
        bool succeed = true;
        const auto& resMan = provider->getContext()->getSystem<ResourceManager>();
        for ( const auto& resPtr : resMan->getAllResources() ) {
            succeed &= AddResource(provider, parentItem, resMan->getObjectId() );            
        }
        return succeed;
    }

    /*
        @brief: Select the appropriate object, 
        #todo this responsibility shouldn't be here
    */
    RootObject* QmlTreeViewNodeResolver::GetEngineObjectForItem( QStandardItem* rootItem)
    {
        auto* itemPtr = dynamic_cast<QmlTreeViewNodeBase*>(rootItem);
        if ( !itemPtr )
            return nullptr;
        //loop through valid/registered objects
        RootObject* backend = itemPtr->getBackendObject();
        if ( auto nodePtr = dynamic_cast<EntityBase*>(backend)) {
            return nodePtr;
        }
        else if (auto compPtr = dynamic_cast<ComponentBase*>(backend)) {
             return compPtr;
        }
        else if (auto resourcePtr = dynamic_cast<ResourceBase*>(backend)) {
            return resourcePtr;
        }
        return nullptr;
    }

    bool QmlTreeViewNodeResolver::RemoveObject
        ( ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId )
    {
        UNUSED(provider);

        auto treeItem = ItemForObjectId(rootItem, objectId);
        if (!treeItem)
            return false;

        auto parentItem = treeItem->parent();
        auto row = treeItem->index().row();
        parentItem->removeRow(row);

        return true;      
    }

    bool QmlTreeViewNodeResolver::AddResource(Engine::ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId)
    {
        return false;
    }

    //bool QmlTreeViewNodeResolver::AddObject
    //    (ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId )
    //   
    //{   
    //    auto objectPtr = provider->getContext()->getObjectBase(objectId).get();

    //    assert(objectPtr && "Object Pointer");        
    //    auto parentObject = GetParentIdOfObject(objectPtr);      
    //    auto* parentPtr = parentObject != INVALID_INDEX
    //        ? provider->getContext()->getObjectBase(parentObject).get()
    //        : nullptr;
    //    auto parentItem = ItemForObject( rootItem, parentPtr );
    //    if (!parentItem) {
    //        
    //        assert( false && "ParentItem" );
    //        return false;
    //    }

    //    auto itemType = GetItemTypeForObject(objectPtr);
    //    auto newItem = new QmlTreeViewNodeBase( objectPtr, parentItem );
    //    newItem->setObjectType(itemType);
    //    newItem->setContextProvider(provider);
    // 
    //    return true;
    //}


    bool QmlTreeViewNodeResolver::AddComponent(Engine::ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId, std::uint32_t)
    {
        return false;
    }

    //bool QmlTreeViewNodeResolver::AddResource
    //    (ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId )
    //{
    //    
    //    auto objectPtr = provider->getContext()->getObjectBase(objectId).get();
    //    const auto& theResource = SafeDownCast<ResourceBase>
    //        (provider->getContext()->getObjectBase(objectId));
    //    
    //    if (!theResource)
    //        return false;

    bool QmlTreeViewNodeResolver::AddEntity(Engine::ContextProvider* provider, QStandardItem* rootItem, std::uint32_t objectId, std::uint32_t)
    {
        return false;
    }

    //    auto resType  = QString::fromStdString( objectPtr->GetTypeName() );       
    //    //get concrete resource item
    //    auto subResourceItem = GetParentItemForResource(provider, rootItem, theResource.get());
    //    //create new item
    //    auto* newItem = new QmlTreeViewNodeBase( theResource.get(), subResourceItem);
    //    newItem->setObjectType(QtEnums::TREEVIEW_TYPE_RESOURCE);
    //    newItem->setData( resType, QtEnums::TREEVIEW_TYPE_SECTION_NAME);
    //    newItem->setContextProvider(provider);
    //    return true;
    //}

    QStandardItem* QmlTreeViewNodeResolver::ItemForObject
        (QStandardItem* rootItem, RootObject* theObject)
    {
        if (!theObject)
            return nullptr;     
        return ItemForObjectId( rootItem, theObject->getObjectId() );      
    }



    QStandardItem* QmlTreeViewNodeResolver::ItemForObjectId
        (QStandardItem* rootItem, std::uint32_t objectId)
    {
        if ( objectId == 0 )
            return nullptr;

        std::stack<QStandardItem*> itemStack;
        itemStack.push(rootItem);
        while (!itemStack.empty())
        {
            auto parentItem = itemStack.top(); itemStack.pop();
            for (int row = 0; row < parentItem->rowCount(); ++row)
            {
                auto* childItem = dynamic_cast<QmlTreeViewNodeBase*>(parentItem->child(row));
                if (childItem && childItem->getBackendObjectId() == objectId )
                    return childItem;
                itemStack.push(childItem);
            }
        }
        return nullptr;
    }

}