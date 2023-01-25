#pragma once
#include <QtCore/QObject>
#include <Console/LogRecipient.h>

namespace Application
{
    class QmlLogRecipient : public Log::LogRecipientBase
    {
    public:
        QmlLogRecipient( QObject* console );

        void receive( const Log::LogMessage& msg ) override;

    private:
        QObject*    m_qmlConsole;
    };

}