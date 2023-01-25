#pragma once
#include <Common/Reflection.h>
#include <Properties/PropertyBasePtr.h>
#include <Properties/PropertyVector.h>
namespace Application
{
    
    /*
       @brief: Only Resources & Entities are supported 
    */
    template<class T>
    class PropertyGenerator {
    public:
        PropertyGenerator(T* instance) : m_instance(instance) { };

        Properties::PropertyVector  getProperties()
        {
            m_reflInstance = rttr::instance(*m_instance);
            return getPropertiesInternal( m_reflInstance.get_type() );
        }

    private:
        Properties::PropertyVector  getPropertiesInternal( rttr::type& reflType ) 
        {
            if (!reflType.is_valid())
                return{};
            if (!reflType.is_class())
                return {};
            const auto props = reflType.get_properties();
            for (const auto& prop : props)
            {

            }
            return {};
        }

        T*              m_instance;
        rttr::instance  m_reflInstance;

    };
}
