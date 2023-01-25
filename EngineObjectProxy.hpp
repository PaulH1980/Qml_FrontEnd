#pragma once
#include "QtHeaders.h"

#include <Engine/RootObjectPtr.h>
namespace Application
{
    /*
        @brief: Class that holds an backend-objects so it can 
        passed in signal/slot connections
    */
    class EngineObjectProxy : public QObject
    {
        Q_OBJECT
    public:
        EngineObjectProxy();

        EngineObjectProxy(const EngineObjectProxy& rhs);

        EngineObjectProxy(Engine::RootObject* object);


        Engine::RootObject*     getObject() const;

        void                    setObject(Engine::RootObject* object);



    private:
        Engine::RootObject*     m_backendObject;      
    };
}

Q_DECLARE_METATYPE(Application::EngineObjectProxy)