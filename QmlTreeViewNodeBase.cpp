#include "AppIncludes.h"
#include "AppException.h"
#include "AppQtRoles.hpp"
#include "QmlContextMenuResolver.h"
#include "QmlTreeViewNodeBase.hpp"

namespace Application
{
    QmlTreeViewNodeBase::QmlTreeViewNodeBase( QmlTreeViewNodeBase* parentPtr /*= nullptr*/ )
        : QmlTreeViewNodeBase( nullptr, nullptr )
    {

    }
    
    QmlTreeViewNodeBase::QmlTreeViewNodeBase(Engine::RootObject* backend, QStandardItem* parentPtr )
        : m_objectType(QtEnums::TREEVIEW_TYPE_UNKNOWN)       
        , m_backendId( 0 )
    {
        if ( backend ) 
        {
            m_backendId = backend->getObjectId();
            setNodeName( QString::fromStdString( backend->getName() ) );
        }
        if (parentPtr)
            parentPtr->appendRow( this );
    }



    const QString& QmlTreeViewNodeBase::getNodeName() const
    {
        return m_nodeName;
    }

    void QmlTreeViewNodeBase::setNodeName(const QString& name)
    {
        m_nodeName = name;
        setData( name, QtEnums::TREEVIEW_NAME_ROLE );
    }


    Engine::RootObject* QmlTreeViewNodeBase::getBackendObject() const
    {
        if (m_contextProvider) {
            switch (m_objectType)
            {
            case QtEnums::TREEVIEW_TYPE_CONCRETE_RESOURCE:
                break;
            case QtEnums::TREEVIEW_TYPE_NODE:
                break;
            case QtEnums::TREEVIEW_TYPE_COMPONENT:
                break;
            }
        }
        return nullptr;
    }

    int QmlTreeViewNodeBase::getObjectType() const
    {
        return m_objectType;
    }

    void QmlTreeViewNodeBase::setObjectType(int val)
    {
        m_objectType = val;
    }

    QString QmlTreeViewNodeBase::getContextMenuData() const
    {
        auto objectPtr = getBackendObject();
        auto contextPtr = getContexProvider()->getContext();
        assert(contextPtr && "No Context Provider Specified");
        switch (m_objectType)
        {
            case QtEnums::TREEVIEW_TYPE_COMPONENT: //show component context menu
          //      return QmlContextMenuResolver::ComponentContextMenuData(contextPtr, objectPtr);
            case QtEnums::TREEVIEW_TYPE_NODE: //show context menu for current node
           //     return QmlContextMenuResolver::NodeContextMenuData(contextPtr, objectPtr);
            case QtEnums::TREEVIEW_TYPE_RESOURCE: //show context menu for current resource
             //   return QmlContextMenuResolver::ResourceContextMenuData(contextPtr, objectPtr);
            case QtEnums::TREEVIEW_TYPE_RESOURCE_ROOT: //show context menu for all create-components
           //     return QmlContextMenuResolver::ResourceRootContextMenuData(contextPtr);        
            case QtEnums::TREEVIEW_TYPE_CONCRETE_RESOURCE: //create new concrete resource context menu
           //     return QmlContextMenuResolver::ResourceSubMenuData(contextPtr, getNodeName().toStdString());
                return EmptyQString;
        }        
        return EmptyQString;
    }


    void QmlTreeViewNodeBase::setContextProvider(ContextProvider* eop)
    {
        m_contextProvider = eop;
    }

    ContextProvider* QmlTreeViewNodeBase::getContexProvider() const
    {
        return m_contextProvider;
    }

    std::uint32_t QmlTreeViewNodeBase::getBackendObjectId() const
    {
        return m_backendId;
    }

}

