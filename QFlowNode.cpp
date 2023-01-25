#include <Math/Vector.h>
#include "QFlowNode.hpp"

using namespace Math;
namespace Application
{

    QFlowObject::QFlowObject(QObject* parent /*= nullptr*/)
        : QObject( parent )
    {

    }

    BBox2i QFlowObject::getBounds() const
    {
        auto min = Vector2i(m_position.x(), m_position.y());
        auto max = Vector2i( m_position.x() + m_size.width(), m_position.y() + m_size.height());
        return BBox2i( min, max );
    }

    //////////////////////////////////////////////////////////////////////////
    //QFlowNode
    //////////////////////////////////////////////////////////////////////////
    QFlowNode::QFlowNode(QObject* parent /*= nullptr*/)
        : QFlowObject( parent )
    {

    }

    //////////////////////////////////////////////////////////////////////////
    //QFlowPort
    //////////////////////////////////////////////////////////////////////////
    QFlowPort::QFlowPort(QFlowNode* parent)
        : QFlowObject(parent)
    {

    }
    
    //////////////////////////////////////////////////////////////////////////
    //QFlowConnection
    //////////////////////////////////////////////////////////////////////////
    QFlowConnection::QFlowConnection(QObject* parent /*= nullptr*/)
        : QFlowObject(parent)
    {

    }

}

