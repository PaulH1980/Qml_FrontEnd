#include "AppQtRoles.hpp"
#include "AppException.h"
#include "AppIncludes.h"
#include "QmlProperty.hpp"

//https://stackoverflow.com/questions/42829568/how-and-when-to-use-q-declare-metatype/42829904
Q_DECLARE_METATYPE(Math::BBox2f);
Q_DECLARE_METATYPE(Math::BBox3f);
Q_DECLARE_METATYPE(Math::BBox2i);
Q_DECLARE_METATYPE(Math::BBox3i);
Q_DECLARE_METATYPE(Math::Vector2i);
Q_DECLARE_METATYPE(Math::Vector3i);
Q_DECLARE_METATYPE(Math::Vector4i);
Q_DECLARE_METATYPE(Math::Vector2f);
Q_DECLARE_METATYPE(Math::Vector3f);
Q_DECLARE_METATYPE(Math::Vector4f);

namespace Application
{
    //////////////////////////////////////////////////////////////////////////
    //\QMLBoolProperty
    //////////////////////////////////////////////////////////////////////////
    QmlBoolProperty::QmlBoolProperty( const PropertyBasePtr& backend ) 
        : QmlPropertyBase(backend)
    {
        m_qmlFile = "PropertyGridBool.qml";
        m_propertyType    = QtEnums::BOOL_ROLE;
    }

    void QmlBoolProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<bool>();
        setValue(value);
    }

    void QmlBoolProperty::setValue(bool val)
    {
        auto prop = std::static_pointer_cast<BoolProperty>(m_backend);
        auto curVal = prop->getValue();
        if (val != curVal)
        {
            prop->setValue(val);
            emit boolChanged(val);
        }
    }

    bool QmlBoolProperty::getValue() const
    {
        return std::static_pointer_cast<BoolProperty>(m_backend)->getValue();
    }

    //////////////////////////////////////////////////////////////////////////
    //\QMLUnsignedProperty
    //////////////////////////////////////////////////////////////////////////
    QmlUnsignedProperty::QmlUnsignedProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase(backend)
    {
        m_qmlFile = "PropertyGridInt.qml";
        m_propertyType = QtEnums::UNSIGNED_ROLE;
    }


    void QmlUnsignedProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<std::uint32_t>();
        setValue(value);
    }

    void QmlUnsignedProperty::setValue(std::uint32_t val)
    {
        auto prop = std::static_pointer_cast<UnsignedProperty>(m_backend);
        auto curVal = prop->getValue();
        if (val != curVal)
        {
            prop->setValue(val);
            emit unsignedChanged(val);
        }
    }

    std::uint32_t QmlUnsignedProperty::getValue() const
    {
        return std::static_pointer_cast<UnsignedProperty>(m_backend)->getValue();
    }

    //////////////////////////////////////////////////////////////////////////
    //\QMLIntegerProperty
    //////////////////////////////////////////////////////////////////////////
    QmlIntegerProperty::QmlIntegerProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase( backend )
    {
        m_qmlFile = "PropertyGridInt.qml";
        m_propertyType = QtEnums::INTEGER_ROLE;
    }


    void QmlIntegerProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<int>();
        setValue(value);
    }

    void QmlIntegerProperty::setValue(int val)
    {
        auto prop = std::static_pointer_cast<IntegerProperty>(m_backend);
        auto curVal = prop->getValue();
        if ( val != curVal )
        {
            prop->setValue(val);
            emit integerChanged(val);
        }       
    }

    int QmlIntegerProperty::getValue() const
    {
        return std::static_pointer_cast<IntegerProperty>(m_backend)->getValue();
    }

    //////////////////////////////////////////////////////////////////////////
    //\QMLFloatProperty
    //////////////////////////////////////////////////////////////////////////
    QmlFloatProperty::QmlFloatProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase( backend )
    {
        m_qmlFile = "PropertyGridFloat.qml";
        m_propertyType = QtEnums::FLOAT_ROLE;
    }

    void QmlFloatProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<float>();
        setValue(value);
    }

    void QmlFloatProperty::setValue(float val)
    {
        auto prop = std::static_pointer_cast<FloatProperty>(m_backend);
        auto curVal = prop->getValue();
        if ( std::fabs( val - curVal ) > 0.00125f )
        {
            prop->setValue(val);
            emit floatChanged(val);
        }
    }

    float QmlFloatProperty::getValue() const
    {
        return std::static_pointer_cast<FloatProperty>(m_backend)->getValue();
    }


    //////////////////////////////////////////////////////////////////////////
    // //\QmlVector2Property
    //////////////////////////////////////////////////////////////////////////
    QmlVector2Property::QmlVector2Property( const PropertyBasePtr& backend)
        : QmlPropertyBase( backend )
    {
        m_qmlFile = "PropertyGridVector2f.qml";
        m_propertyType = QtEnums::VECTOR2_ROLE;
    }

    void QmlVector2Property::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<Vector2f>();
        setValue( value );
    }

    void QmlVector2Property::setValue(const Vector2f& newVal)
    {
        auto prop = std::static_pointer_cast<Vector2fProperty>(m_backend);
        auto curVal = prop->getValue();
        if (!curVal.equals(newVal, 0.00125f ) )
        {
            prop->setValue(newVal);
            emit vector2Changed(getValue());
        }
    }

    QVector2D QmlVector2Property::getValue() const
    {
       auto val = std::static_pointer_cast<Vector2fProperty>(m_backend)->getValue();
       return QVector2D(val.getX(), val.getY());       
    }

    //////////////////////////////////////////////////////////////////////////
    //\QmlVector2iProperty
    //////////////////////////////////////////////////////////////////////////
    QmlVector2iProperty::QmlVector2iProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase(backend)
    {
        m_qmlFile = "PropertyGridVector2i.qml";
        m_propertyType = QtEnums::VECTOR2I_ROLE;
    }


    void QmlVector2iProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<Vector2i>();
        setValue(value);
    }

    void QmlVector2iProperty::setValue(const Vector2i& val)
    {
        auto prop = std::static_pointer_cast<Vector2iProperty>(m_backend);
        auto curVal = prop->getValue();
        if (!curVal.equals(val, 0))
        {
            prop->setValue(val);
            emit vector2iChanged(getValue());
        }
    }

    Vector2i QmlVector2iProperty::getValue() const
    {
        return std::static_pointer_cast<Vector2iProperty>(m_backend)->getValue();
    }



    //////////////////////////////////////////////////////////////////////////
    // //\QmlVector3Property
    //////////////////////////////////////////////////////////////////////////
    QmlVector3Property::QmlVector3Property(const PropertyBasePtr& backend)
        : QmlPropertyBase( backend )
    {
        m_qmlFile = "PropertyGridVector3f.qml";
        m_propertyType = QtEnums::VECTOR3_ROLE;
    }

   

    void QmlVector3Property::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<Vector3f>();
        setValue(value);
    }

    void QmlVector3Property::setValue(const Vector3f& newVal)
    {
        auto prop = std::static_pointer_cast<Vector3fProperty>(m_backend);
        auto curVal = prop->getValue();
        if (!curVal.equals( newVal, 0.00125f))
        {
            prop->setValue(newVal);
            emit vector3Changed(getValue());
        }
    }

    QVector3D QmlVector3Property::getValue() const
    {
        auto val = std::static_pointer_cast<Vector3fProperty>(m_backend)->getValue();
        return QVector3D(val.getX(), val.getY(), val.getZ());
    }


    //////////////////////////////////////////////////////////////////////////
    //\QmlVector4iProperty
    //////////////////////////////////////////////////////////////////////////
    QmlVector3iProperty::QmlVector3iProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase(backend)
    {
        m_qmlFile = "PropertyGridVector3i.qml";
        m_propertyType = QtEnums::VECTOR3I_ROLE;
    }


    void QmlVector3iProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<Vector3i>();
        setValue(value);
    }

    void QmlVector3iProperty::setValue(const Vector3i& val)
    {
        auto prop = std::static_pointer_cast<Vector3iProperty>(m_backend);
        auto curVal = prop->getValue();
        if (!curVal.equals(val, 0))
        {
            prop->setValue(val);
            emit vector3iChanged(getValue());
        }
    }

    Vector3i QmlVector3iProperty::getValue() const
    {
        return std::static_pointer_cast<Vector3iProperty>(m_backend)->getValue();
    }


    //////////////////////////////////////////////////////////////////////////
    //\QmlVector4Property
    //////////////////////////////////////////////////////////////////////////
    QmlVector4Property::QmlVector4Property(const PropertyBasePtr& backend)
        : QmlPropertyBase( backend )
    {
        m_qmlFile = "PropertyGridVector4f.qml";
        m_propertyType = QtEnums::VECTOR4_ROLE;
    }

    void QmlVector4Property::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<Vector4f>();
        setValue(value);
    }

    void QmlVector4Property::setValue( const Vector4f& newVal )
    {
        auto prop = std::static_pointer_cast<Vector4fProperty>(m_backend);
        auto curVal = prop->getValue();
        if (!curVal.equals(newVal, 0.00125f))
        {
            prop->setValue(newVal);
            emit vector4Changed(getValue());
        }
    }

    QVector4D QmlVector4Property::getValue() const
    {
        auto val = std::static_pointer_cast<Vector4fProperty>(m_backend)->getValue();
        return QVector4D(val.getX(), val.getY(), val.getZ(), val.getW() );
    }

    //////////////////////////////////////////////////////////////////////////
    //\QmlVector4iProperty
    //////////////////////////////////////////////////////////////////////////
    QmlVector4iProperty::QmlVector4iProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase(backend)
    {
        m_qmlFile = "PropertyGridVector4i.qml";
        m_propertyType = QtEnums::VECTOR4I_ROLE;
    }

    void QmlVector4iProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<Vector4i>();
        setValue(value);
    }

    void QmlVector4iProperty::setValue(const Vector4i& newVal)
    {
        auto prop = std::static_pointer_cast<Vector4iProperty>(m_backend);
        auto curVal = prop->getValue();
        if (!curVal.equals( newVal, 0 ))
        {
            prop->setValue(newVal);
            emit vector4iChanged(newVal);
        }
    }

    Vector4i QmlVector4iProperty::getValue() const
    {
        auto val = std::static_pointer_cast<Vector4iProperty>(m_backend)->getValue();
        return val;
    }


    //////////////////////////////////////////////////////////////////////////
    //\QmlColorProperty
    //////////////////////////////////////////////////////////////////////////
    QmlColorProperty::QmlColorProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase(backend)
    {
        m_qmlFile = "PropertyGridColor.qml";
        m_propertyType  = QtEnums::COLOR_ROLE;
    }

   
    void QmlColorProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto rgba = jsonObj["Value"].get<Vector4f>() * 255.0f;
       
        setValue( QColor::fromRgb( rgba[0], rgba[1], rgba[2], rgba[3]));
    }

    void QmlColorProperty::setValue(QColor val)
    {
        const float invVal = 1.0f / 255.0f;
        Vector4f newVal(val.red() * invVal, val.green() * invVal, val.blue()* invVal, val.alpha() * invVal);
        auto prop = std::static_pointer_cast<ColorProperty>(m_backend);
        auto curVal = prop->getValue();
        if (!curVal.equals(newVal, 0.00125f))
        {
            prop->setValue(newVal);
            emit colorChanged(getValue());
        }
    }

  
    QColor QmlColorProperty::getValue() const
    {
        auto rgba = (std::static_pointer_cast<ColorProperty>(m_backend)->getValue() * 255.0f).convertTo<int>();
        return QColor(rgba[0], rgba[1], rgba[2], rgba[3]);
    }

    //////////////////////////////////////////////////////////////////////////
    //\QmlTextProperty
    //////////////////////////////////////////////////////////////////////////
    QmlTextProperty::QmlTextProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase( backend )
    {
        m_qmlFile = "PropertyGridText.qml";
        m_propertyType = QtEnums::TEXTINPUT_ROLE;
    }

   
    void QmlTextProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<std::string>();
        setValue(value);
    }

    void QmlTextProperty::setValue(const std::string& newVal)
    {
        auto prop = std::static_pointer_cast<TextProperty>(m_backend);
        auto curVal = prop->getValue();
        if (curVal != newVal )
        {
            prop->setValue(newVal);
            emit textChanged( getValue() );
        }
    }

    QString QmlTextProperty::getValue() const
    {
        return QString::fromStdString(std::static_pointer_cast<TextProperty>(m_backend)->getValue());
    }

    //////////////////////////////////////////////////////////////////////////
    //\QmlEnumProperty
    //////////////////////////////////////////////////////////////////////////
    QmlEnumProperty::QmlEnumProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase( backend )
    {
       m_qmlFile = "PropertyGridEnum.qml";
       m_propertyType = QtEnums::ENUM_ROLE;
    }

    void QmlEnumProperty::setVariant( const QVariant& val )
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<int>();
        setValue(value);
    }

    void QmlEnumProperty::setValue(int val)
    {
        auto enumProp = std::static_pointer_cast<EnumProperty>(m_backend);
        auto curVal = enumProp->getValue();
        if (curVal != val) {
            enumProp->setValue(val);        
            emit enumChanged(val);
        }
    }

    QString QmlEnumProperty::getValue() const
    {
        auto enumProp = std::static_pointer_cast<EnumProperty>(m_backend);
        auto jsonStr = enumProp->toJsonObject().dump();
        return QString::fromStdString(jsonStr);
    }



    //////////////////////////////////////////////////////////////////////////
    //\brief: Qml Select Resource Property
    //////////////////////////////////////////////////////////////////////////
    QmlSelectResourceProperty::QmlSelectResourceProperty(const PropertyBasePtr& backend)
        : QmlPropertyBase( backend )
    {
        m_qmlFile = "PropertyGridEnum.qml";
        m_propertyType = QtEnums::ENUM_ROLE;
    }

    void QmlSelectResourceProperty::setVariant(const QVariant& val)
    {
        const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
        auto value = jsonObj["Value"].get<int>();
        setValue(value);
    }

    void QmlSelectResourceProperty::setValue(int val)
    {
        auto enumProp = std::static_pointer_cast<SelectResourceProperty>(m_backend);
        auto curVal = enumProp->getCurrentSelection();
        if (curVal != val) {
            enumProp->setCurrentSelection(val);
            emit selectedPropertyChanged(val);
        }
    }

    QString QmlSelectResourceProperty::getValue() const
    {
        auto enumProp = std::static_pointer_cast<SelectResourceProperty>(m_backend);
        auto jsonStr = enumProp->toJsonObject().dump();
        return QString::fromStdString(jsonStr);
    }


   //////////////////////////////////////////////////////////////////////////
   //\QmlFileProperty
   //////////////////////////////////////////////////////////////////////////
   QmlFileProperty::QmlFileProperty(const PropertyBasePtr& backend)
       : QmlPropertyBase( backend )
   {
       m_qmlFile = "PropertyGridFile.qml";
       m_propertyType = QtEnums::FILE_SOURCE_ROLE;
   }

  

   void QmlFileProperty::setVariant(const QVariant& val)
   {
       const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
       auto value = jsonObj["Value"].get<std::string>();
       setValue(value);
   }

   void QmlFileProperty::setValue(const std::string& newVal )
   {
       auto prop = std::static_pointer_cast<TextProperty>(m_backend);
       auto curVal = prop->getValue();
       if (curVal != newVal)
       {
           prop->setValue(newVal);
           emit fileChanged(getValue());
       }
   }

   QString QmlFileProperty::getValue() const
   {
       auto myVal = std::static_pointer_cast<FileProperty>(m_backend)->getValue();
       return QString::fromStdString(myVal);       
   }


   //////////////////////////////////////////////////////////////////////////
   //\QmlBBox2Property
   //////////////////////////////////////////////////////////////////////////
   QmlBBox2Property::QmlBBox2Property(const PropertyBasePtr& backend)
       : QmlPropertyBase(backend)
   {
       //throw std::runtime_error("Not Implemented");

       m_propertyType = QtEnums::BBOX2_ROLE;
   }

   void QmlBBox2Property::setVariant(const QVariant& val)
   {
       const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
       auto value = jsonObj["Value"].get<BBox2f>();
       setValue(value);
   }

   void QmlBBox2Property::setValue(const BBox2f& newVal )
   {
       auto curProp = std::static_pointer_cast<BBox2Property>(m_backend);
       auto curVal  = curProp->getValue();
       if (!curVal.equals(newVal))
       {
           curProp->setValue(newVal);
           emit boundsChanged(getValue());
       }
   }

   BBox2f QmlBBox2Property::getValue() const
   {
       return std::static_pointer_cast<BBox2Property>(m_backend)->getValue();
   }


   //////////////////////////////////////////////////////////////////////////
   //\QmlBBox3Property
   //////////////////////////////////////////////////////////////////////////
   QmlBBox3Property::QmlBBox3Property(const PropertyBasePtr& backend)
       : QmlPropertyBase(backend)
   {
        m_propertyType = QtEnums::BBOX3_ROLE;
   }


   void QmlBBox3Property::setVariant(const QVariant& val)
   {
       const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
       auto value = jsonObj["Value"].get<BBox3f>();
       setValue(value);
   }

   void QmlBBox3Property::setValue(const BBox3f& newVal)
   {
       auto curProp = std::static_pointer_cast<BBox3Property>(m_backend);
       auto curVal = curProp->getValue();
       if (!curVal.equals(newVal))
       {
           curProp->setValue(newVal);
           emit boundsChanged(getValue());
       }
   }

   BBox3f QmlBBox3Property::getValue() const
   {
       return std::static_pointer_cast<BBox3Property>(m_backend)->getValue();
   }



   QmlIntRangedProperty::QmlIntRangedProperty(const PropertyBasePtr& backend)
       : QmlPropertyBase(backend)
   {
       m_propertyType = QtEnums::INT_RANGE_ROLE;
       m_qmlFile = "PropertyGridIntSlider.qml";
   }

   void QmlIntRangedProperty::setVariant(const QVariant& val)
   {
       const auto jsonObj = IO::JSonObject::parse( val.toString().toStdString());
       auto value = jsonObj["Value"].get<IntRangedValue>();
       setValue(value);
   }

   void QmlIntRangedProperty::setValue(const IntRangedValue& newVal)
   {
       auto curProp = std::static_pointer_cast<IntegerClampedProperty>(m_backend);
       auto curVal = curProp->getValue();
       if (!curVal.equals(newVal))
       {
           curProp->setValue(newVal);
           emit intRangeChanged( getValue() );
       }
   }

   IntRangedValue QmlIntRangedProperty::getValue() const
   {
       return std::static_pointer_cast<IntegerClampedProperty>(m_backend)->getValue();
   }
   
   //////////////////////////////////////////////////////////////////////////
   //\QmlFloatRangeProperty
   //////////////////////////////////////////////////////////////////////////
   QmlFloatRangedProperty::QmlFloatRangedProperty(const PropertyBasePtr& backend) 
       : QmlPropertyBase(backend)
   {
       m_propertyType = QtEnums::FLOAT_RANGE_ROLE;
       m_qmlFile = "PropertyGridFloatSlider.qml";
   }

   void QmlFloatRangedProperty::setVariant(const QVariant& val)
   {
       const auto jsonObj = IO::JSonObject::parse(val.toString().toStdString());
       auto value = jsonObj["Value"].get<FloatRangedValue>();
       setValue(value);
   }

   void QmlFloatRangedProperty::setValue(const FloatRangedValue& newVal)
   {
       auto curProp = std::static_pointer_cast<FloatClampedProperty>(m_backend);
       auto curVal = curProp->getValue();
       if (!curVal.equals(newVal))
       {
           curProp->setValue(newVal);
           emit floatRangeChanged(getValue());
       }
   }

   Math::FloatRangedValue QmlFloatRangedProperty::getValue() const
   {
       return std::static_pointer_cast<FloatClampedProperty>(m_backend)->getValue();
   }

   

}
