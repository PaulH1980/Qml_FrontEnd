#include <Console/LogMessage.h>
#include "QtHeaders.h"
#include "QmlLogRecipient.h"

namespace Application
{

    QmlLogRecipient::QmlLogRecipient( QObject* console )
        : m_qmlConsole( console )
    {
    }

    void QmlLogRecipient::receive(const Log::LogMessage& msg)
    {
        QMetaObject::invokeMethod(m_qmlConsole,
            "addLogMessage",
            Q_ARG( QVariant, msg.m_message.c_str() ),
            Q_ARG( QVariant, QColor( msg.m_color[0], msg.m_color[1], msg.m_color[2], msg.m_color[3] ) )
        );
    }
}