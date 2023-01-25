#include "AppIncludes.h"
#include "QmlPropertyBase.hpp"

static const QString EmptyPropertyGrid = "PropertyGridPlaceHolder.qml";


namespace Application
{
    //QMLPropertyBase
    QmlPropertyBase::QmlPropertyBase(const PropertyBasePtr& backend, QObject* parent )
        : QObject( parent )
        , m_backend(backend) //engine property back-end
        , m_visible(true)
        , m_xLabel("X")
        , m_yLabel("Y")
        , m_zLabel("Z")
        , m_wLabel("W")
        , m_minLimit(false)
        , m_maxLimit(false)
        , m_asSlider(false)
        , m_vecLabelsVisible( false )     
        , m_indexInModel( 0 )
        , m_propertyType( INVALID_ROLE )
        , m_prefHeight(PREFERRED_HEIGHT)  

    {
        m_objectType  = QString::fromStdString( backend->getClassName() );
        m_sectionName = QString::fromStdString( backend->getCategory() );
        m_title       = QString::fromStdString( backend->getPropertyName() );      
    }

    QString QmlPropertyBase::getQMLFile() const
    {
        if (m_qmlFile.isEmpty())
            return EmptyPropertyGrid;
        return m_qmlFile;
    }

    int QmlPropertyBase::getPropertyType() const
    {
        assert(m_propertyType != INVALID_ROLE );
        return m_propertyType;
    }


    int QmlPropertyBase::getPropertyFlags() const
    {
        return static_cast<int>( m_backend->getPropertyFlags() );
    }
    
    void QmlPropertyBase::setIndex(int idx)
    {
        m_indexInModel = idx;
    }

    void QmlPropertyBase::setVisible( bool val)
    {
        if (m_visible != val) {
            m_visible = val;
            emit visibilityChanged();
        }    
    }


    QVariant QmlPropertyBase::getVariant() const
    {
        auto jsonObj = IO::JSonObject();
        jsonObj["ClassName"]         = "QmlPropertyBase";
        jsonObj["PropertyType"]      = m_propertyType;       
        jsonObj["Visible"]           = m_visible;
        jsonObj["AsSlider"]          = m_asSlider;
        jsonObj["LimitMin"]          = m_minLimit;
        jsonObj["LimitMax"]          = m_maxLimit;      

        //backend property flags
        jsonObj["PropertyFlags"] = getPropertyFlags();

        jsonObj["IndexInModel"] = m_indexInModel;        
        jsonObj["ItemHeight"]   = m_prefHeight;
        jsonObj["QmlFile"]      = m_qmlFile.toStdString();
        jsonObj["ObjectType"]   = m_objectType.toStdString();
        jsonObj["SectionName"]  = m_sectionName.toStdString();
        jsonObj["Title"]        = m_title.toStdString();

        jsonObj["Label_X"] = m_xLabel.toStdString();
        jsonObj["Label_Y"] = m_yLabel.toStdString();
        jsonObj["Label_Z"] = m_zLabel.toStdString();
        jsonObj["Label_W"] = m_wLabel.toStdString();     

        assert(m_backend);
        jsonObj["BackEndProperty"] = m_backend->toJsonObject();
        
        return QString::fromStdString( jsonObj.dump() );
    }

    void QmlPropertyBase::setVariant(const QVariant& var) 
    {
        const auto jsonObj = IO::JSonObject::parse( var.toString().toStdString() );        
        throw std::runtime_error("Not Implemented");
    }

    QVariant QmlPropertyBase::getMinValue() const
    {
        throw std::runtime_error( "Not Implemented" );
    }

    QVariant QmlPropertyBase::getMaxValue() const
    {
        throw std::runtime_error( "Not Implemented" );
    }

}