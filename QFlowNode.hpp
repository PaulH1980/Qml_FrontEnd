#pragma once
#include <Math/AABB.h>
#include "QtHeaders.h"

namespace Application
{
    class QFlowObject : public QObject
    {
        Q_OBJECT
    public:
        QFlowObject(QObject* parent = nullptr);

        Math::BBox2i      getBounds() const;


    private:
        
        QPoint      m_position;
        QSize       m_size;
    };
        
    
    class QFlowNode : public QFlowObject
    {
        Q_OBJECT
    public:
        QFlowNode(QObject* parent = nullptr);
    };

    /*
        @brief: QFlowConnection, a connection between two distinct QFlowPorts
    */
    class QFlowConnection : public QFlowObject
    {
        Q_OBJECT
    public:
        QFlowConnection(QObject* parent = nullptr);
    };


    /*
        @brief: QFlowPort, this is part of a QFlowNode
    */
    class QFlowPort : public QFlowObject
    {
        Q_OBJECT
    public:
        QFlowPort(QFlowNode* parent);
    };


    
}