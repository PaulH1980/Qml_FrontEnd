#pragma once

#include <Common/Patterns.h>
#include <Properties/PropertyBase.h>
#include <Properties/PropertyProvider.h>
#include "QmlTreeViewNodeBase.hpp"
#include "QmlProperty.hpp"
#include "QmlPropertyBase.hpp"
#include "QmlPropertyVector.h"

namespace Application
{   
    using QmlPropertyFactory = Common::ObjectFactory<QmlPropertyBase, const PropertyBasePtr& >;

    /*
        @brief: Used for resolving qml-properties from engine/backend properties
    */
    class QmlPropertyResolver
    {
    public:        

        /*
            @brief: Register built-in properties, so they can be queried in qml/qt
        */
        static bool                 RegisterQmlProperties();

        static QmlPropertyVector    ResolveQmlProperties( Properties::PropertyProvider&);
        static QmlPropertyVector    ResolveQmlProperties( const Properties::PropertyVector& );
        static QmlPropertyVector    ResolveQmlProperties( const Properties::PropertyBasePtr&);

        template<class T>
        static bool RegisterQmlProperty(const std::string& name) {
            return g_propertyFactory.registerObject<T>(name);
        }


    private:
        static QmlPropertyFactory g_propertyFactory;
    };


  
   
    
}