#include <Math/GenMath.h> //random
#include "AppQtRoles.hpp"
#include "QmlProperty.hpp"
//#include "QmlPropertyResolver.h"    
#include "QtHeaders.h"
#include "AppException.h"
#include "AppIncludes.h"

#include "ObjectPropertyModel.hpp"


namespace Application
{
    ObjectPropertyModel::ObjectPropertyModel( QObject *parent)
        : QAbstractListModel(parent)   
        , m_contextProvider( nullptr )
    {
    }

    void ObjectPropertyModel::setContextProvider( Engine::ContextProvider* ecp )
    {
        m_contextProvider = ecp;
    }

    QVariant ObjectPropertyModel::data(const QModelIndex &index, int role /* = Qt::DisplayRole */) const
    {
        const auto rowIdx = index.row();
        if ( rowIdx < 0 || rowIdx >= numItems() ) 
            return QVariant();       

        const auto& curProp = m_properties[rowIdx];
        switch (role)
        {
            case QtEnums::INSPECTOR_ROLE:
                return curProp->getPropertyType();       
            case QtEnums::GROUP_ROLE:
                return curProp->getSectionName();
            case QtEnums::QML_ROLE:
                return curProp->getQMLFile();
            case QtEnums::TITLE_ROLE:
                return curProp->getTitle();
            case QtEnums::VISIBLE_ROLE:
                return curProp->isVisible();
            case QtEnums::INDEX_ROLE:
                return curProp->getIndex();
            case QtEnums::JSON_OBJECT_ROLE:
                return curProp->getVariant();
        }

        return QVariant();
    }

    Qt::ItemFlags ObjectPropertyModel::flags(const QModelIndex &index) const
    {
        if (!index.isValid())
            return Qt::ItemIsEnabled;

        return QAbstractItemModel::flags(index) | Qt::ItemIsEditable;
    }

    bool ObjectPropertyModel::removeRows(int row, int count, const QModelIndex &parent)
    {
        if (m_properties.empty())
            return false;
        
        const int end    = row + count;
        const auto start = m_properties.begin();
        beginRemoveRows(parent, row, end - 1);
        m_properties.erase(start + row, start + end);
        endRemoveRows();
        return true;
    }

    int ObjectPropertyModel::rowCount(const QModelIndex &parent) const
    {
        return  static_cast<int>( m_properties.size() );
    }

    bool ObjectPropertyModel::setData( const QModelIndex &index, const QVariant &val, int role )
    {
        const int rowIdx = index.row();
        validateIndex(rowIdx);
        const auto& curProp    = m_properties[rowIdx];       
        switch (role)
        {
            case QtEnums::VISIBLE_ROLE:
                curProp->setVisible( val.value<bool>() );
                break;       
            
            case QtEnums::ENUM_ROLE:
            case QtEnums::UNSIGNED_ROLE:
            case QtEnums::INTEGER_ROLE:
            case QtEnums::FLOAT_ROLE:
            case QtEnums::COLOR_ROLE:
            case QtEnums::BOOL_ROLE:
            case QtEnums::TEXTINPUT_ROLE:
            case QtEnums::VECTOR2_ROLE:
            case QtEnums::VECTOR2I_ROLE:
            case QtEnums::VECTOR3_ROLE:
            case QtEnums::VECTOR3I_ROLE:
            case QtEnums::VECTOR4_ROLE:
            case QtEnums::VECTOR4I_ROLE:
            case QtEnums::BBOX2_ROLE:
            case QtEnums::BBOX3_ROLE:
            case QtEnums::INT_RANGE_ROLE:
            case QtEnums::FLOAT_RANGE_ROLE:
            {
                curProp->setVariant(val);
                break;
            }
        } 
        //emit dataChanged(index, index);        
        return true;          
    }

    void ObjectPropertyModel::clear()
    {
        beginResetModel();
        const auto rows = numItems();
        if( rows )
             removeRows(0, rows );
        endResetModel();
    }

    bool ObjectPropertyModel::setProperties( const QmlPropertyVector& properties )
    {
        const auto numProps = static_cast<int>(properties.size());        
        if (0 == numProps )
            return false;     
        clear();
        m_properties = properties;
        for (int i = 0; i < numProps; ++i)
            m_properties[i]->setIndex(i);
        beginInsertRows( QModelIndex(), 0, numProps - 1 );
        
        endInsertRows();
        return true;
    }

    bool ObjectPropertyModel::updateData(int row, const QVariant &value, int role)
    {
        auto idx = createIndex(row, 0);
        return setData(idx, value, role);
    }


    bool ObjectPropertyModel::updateDataFromJson(int row, const QVariant& value, int role)
    {
        auto idx = createIndex(row, 0);
        return setData(idx, value, role);    
    }

    void ObjectPropertyModel::updateExistingProperties()
    {
        if( !m_properties.empty())
            emit dataChanged(index(0), index( static_cast<int>(m_properties.size()) - 1));
    }

    void ObjectPropertyModel::toggleVisibility(int i)
    {
        validateIndex(i);
        QVariant value = !m_properties[i]->isVisible();
        auto idx = createIndex(i, 0);
        setData(idx, value, QtEnums::VISIBLE_ROLE);
    }

    int ObjectPropertyModel::numItems() const
    {
        return static_cast<int>(m_properties.size());
    }

    QString ObjectPropertyModel::getSectionName(int i) const
    {
        validateIndex(i);
        return m_properties[i]->getSectionName();
    }

    bool ObjectPropertyModel::validateIndex(int idx) const
    {
        assert(idx >= 0 && idx < numItems() );
        return true;
    }


    QRoleNames ObjectPropertyModel::roleNames() const
    {
        QRoleNames roles;

        roles[QtEnums::TITLE_ROLE]           = "inputTitle";
        roles[QtEnums::INDEX_ROLE]           = "itemIndex";
        roles[QtEnums::VISIBLE_ROLE]         = "isVisible";
        roles[QtEnums::INSPECTOR_ROLE]       = "roleType";
      
        roles[QtEnums::BOOL_ROLE]            = "boolValue";
        roles[QtEnums::INTEGER_ROLE]         = "intValue";
        roles[QtEnums::FLOAT_ROLE]           = "floatValue";
        roles[QtEnums::VECTOR2_ROLE]         = "vec2Value";
        roles[QtEnums::VECTOR3_ROLE]         = "vec3Value";
        roles[QtEnums::VECTOR4_ROLE]         = "vec4Value";
        roles[QtEnums::COLOR_ROLE]           = "colorValue";
        roles[QtEnums::BBOX2_ROLE]           = "bbox2Value";
        roles[QtEnums::BBOX3_ROLE]           = "bbox3Value";

        roles[QtEnums::GROUP_ROLE]           = "sectionName";
        roles[QtEnums::QML_ROLE]             = "qmlFile";  
        roles[QtEnums::TEXTINPUT_ROLE]       = "textValue";      
        roles[QtEnums::IMAGE_ROLE]           = "imgSource";
        roles[QtEnums::ENUM_ROLE]            = "comboBoxValues";
        roles[QtEnums::JSON_OBJECT_ROLE]     = "dataAsJson";
       
        roles[QtEnums::X_LABEL_ROLE]         = "xLabel";
        roles[QtEnums::Y_LABEL_ROLE]         = "yLabel";
        roles[QtEnums::Z_LABEL_ROLE]         = "zLabel";
        roles[QtEnums::W_LABEL_ROLE]         = "wLabel";  
        roles[QtEnums::PROPERTY_FLAGS_ROLE]   = "backendFlags";

        return roles;
    }
}