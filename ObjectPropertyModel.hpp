#pragma once

#include <Resource/ResourceBasePtr.h>

#include "QmlPropertyVector.h"
#include <Engine/ContextProvider.h>
#include "EngineObjectProxy.hpp"

#include "QtHeaders.h"

namespace Application
{
   
    class ObjectPropertyModel : public QAbstractListModel
    {
        Q_OBJECT
        Q_PROPERTY(int  count			READ	numItems)

    public:
            
        ObjectPropertyModel( QObject *parent = nullptr );
        void                    setContextProvider(Engine::ContextProvider*);

    public slots:

        QVariant				data        ( const QModelIndex &index, int role /* = Qt::DisplayRole */) const override;
        Qt::ItemFlags			flags       ( const QModelIndex &index) const override;
        bool					removeRows  ( int row, int count, const QModelIndex &parent = QModelIndex() ) override;
        int						rowCount    ( const QModelIndex &parent ) const override;
        bool					setData     ( const QModelIndex &index, const QVariant &value, int role ) override;

        void					clear();
        bool					setProperties( const QmlPropertyVector& properties );
        void					toggleVisibility( int idx );
        int						numItems() const;
        QString					getSectionName(int idx) const;
        bool					updateData( int row, const QVariant &value, int role );    
        bool                    updateDataFromJson(int row, const QVariant& value, int role);
               
        void                    updateExistingProperties();

    protected:
        
        QRoleNames				roleNames() const override;

    private:
        bool                    validateIndex( int idx ) const;
        QmlPropertyVector           m_properties; //current properties to display
        Engine::ContextProvider*      m_contextProvider;
        std::weak_ptr<Resources::ResourceBase> m_currentObject;

    };

}


