#pragma once
#include "QtHeaders.h"
#include <Engine/ContextProvider.h>
#include <Engine/RootObjectPtr.h>

namespace Application 
{
    class QmlTreeViewNodeBase : public QStandardItem
    {
  
    public:
        QmlTreeViewNodeBase( QmlTreeViewNodeBase* parentPtr = nullptr);
        QmlTreeViewNodeBase( Engine::RootObject* backend, QStandardItem* parentPtr = nullptr );
        
        virtual ~QmlTreeViewNodeBase() = default;
        
        template<class ...Args>
        static std::shared_ptr<QmlTreeViewNodeBase> SharedNew( Args... args )
        {
            auto newNode = std::make_shared<QmlTreeViewNodeBase>(args);
            bool succeed = true;
            if (auto parentPtr = newNode->getParentItem())
                succeed &= parentPtr->addChild(newNode);
            if (!succeed)
                return nullptr;
            return newNode;
        }

        const QString&              getNodeName() const;
        void                        setNodeName(const QString& name);       
       

       
        int                         getObjectType() const;
        void                        setObjectType( int val );




        virtual QString             getContextMenuData() const;
       

        void                        setContextProvider(Engine::ContextProvider*);
        Engine::ContextProvider*    getContexProvider() const;

        std::uint32_t               getBackendObjectId() const;
        Engine::RootObject*         getBackendObject() const;


    private:
        //backend model may be null, also can't use shared_ptr as UI is oblivious of underlying engine and
        //otherwise it might hold on pointers that required deletion in Engine
        std::uint32_t                       m_backendId;
        Engine::ContextProvider*            m_contextProvider;
        int                                 m_objectType;       
        QString                             m_nodeName;     
    };
}
