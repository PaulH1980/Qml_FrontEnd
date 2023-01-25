#pragma once
#include <Engine/EventDescriptor.h>
#include "QtHeaders.h"

namespace Application
{
    class QmlGlobal : public QObject
    {
        Q_OBJECT
        Q_PROPERTY( QJsonObject  engineEventTypes MEMBER  m_engineEventTypes CONSTANT )
        Q_PROPERTY( QJsonObject  vertexFormats MEMBER     m_vertexFormats CONSTANT)
        Q_PROPERTY( QJsonObject  uniformFormats MEMBER    m_uniformFormats CONSTANT)

    public:
        QmlGlobal(QObject* parent);      

    private:
        QJsonObject     m_engineEventTypes; //all registered engine event types
        QJsonObject     m_vertexFormats;
        QJsonObject     m_uniformFormats;
    };

}