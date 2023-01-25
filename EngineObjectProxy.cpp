#include <Engine/RootObject.h>
#include "EngineObjectProxy.hpp"

using namespace Engine;

namespace Application
{
    EngineObjectProxy::EngineObjectProxy(RootObject* object) 
        : m_backendObject(object)
    {

    }

    EngineObjectProxy::EngineObjectProxy() : EngineObjectProxy(nullptr)
    {

    }

    EngineObjectProxy::EngineObjectProxy(const EngineObjectProxy& rhs) 
        : m_backendObject(rhs.m_backendObject)
        // , m_resource( rhs.m_resource )
    {

    }

    RootObject* Application::EngineObjectProxy::getObject() const
    {
        return m_backendObject;
    }

    void EngineObjectProxy::setObject(RootObject* object)
    {
        m_backendObject = object;
    }

}

