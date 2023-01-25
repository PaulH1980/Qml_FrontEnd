#include "AppIncludes.h"
#include "AppException.h"
#include "QtHeaders.h"

#include "QmlPropertyResolver.h"


namespace Application
{
    QmlPropertyFactory QmlPropertyResolver::g_propertyFactory;

    bool  QmlPropertyResolver::RegisterQmlProperties()
    {
        bool success = true;
        //base types
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlBoolProperty>(BoolProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlIntegerProperty>(IntegerProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlUnsignedProperty>(UnsignedProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlFloatProperty>(FloatProperty::GetClassNameStatic());
        //vectors
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlVector2Property>(Vector2fProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlVector3Property>(Vector3fProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlVector4Property>(Vector4fProperty::GetClassNameStatic());
        //strings colors
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlColorProperty>(ColorProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlEnumProperty>(EnumProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlFileProperty>(FileProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlTextProperty>(TextProperty::GetClassNameStatic());
        //bounding boxes
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlBBox2Property>(BBox2Property::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlBBox3Property>(BBox3Property::GetClassNameStatic());
        //plane & rotations
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlVector4Property>(RotationProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlVector4Property>(PlaneProperty::GetClassNameStatic());
        //integer variants
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlVector2iProperty>(Vector2iProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlVector3iProperty>(Vector3iProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlVector4iProperty>(Vector4iProperty::GetClassNameStatic());
        //selection 
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlSelectResourceProperty>(SelectResourceProperty::GetClassNameStatic());

        //ranges
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlIntRangedProperty>(IntegerClampedProperty::GetClassNameStatic());
        success &= QmlPropertyResolver::RegisterQmlProperty<QmlFloatRangedProperty>(FloatClampedProperty::GetClassNameStatic());

        return success;
    }

    QmlPropertyVector QmlPropertyResolver::ResolveQmlProperties( const PropertyVector& properties  )
    {
        QmlPropertyVector result;
        for (const auto& prop : properties) {
            //resolve a single properties
            auto tmpResult = ResolveQmlProperties( prop );
            result.insert(result.end(), tmpResult.begin(), tmpResult.end());
        }
        return result;
    }

    QmlPropertyVector QmlPropertyResolver::ResolveQmlProperties( const PropertyBasePtr& backend)
    {
        QmlPropertyVector result;
        //list property can contain multiple properties
        if ( auto listProperty = std::dynamic_pointer_cast<ListProperty>( backend ) )
            result = ResolveQmlProperties( listProperty->getPropertyVector() );
        else {
            if ( 0 == ( backend->getPropertyFlags() & PROPERTY_NO_UI ) ) {
                auto prop = g_propertyFactory.spawn(backend->getClassName(), backend);
                if (!prop)
                    throw ApplicationException("Property Not Registered For BackEnd: " + backend->getClassName());              
                result.emplace_back(prop);                
            }
        }
        return result;
    }

   QmlPropertyVector QmlPropertyResolver::ResolveQmlProperties(  PropertyProvider& provider)
   {
      return ResolveQmlProperties( provider.getPropertyVector() );
   }  
}
