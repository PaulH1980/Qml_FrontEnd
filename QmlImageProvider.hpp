#pragma once
#include "QtHeaders.h"


namespace Application
{
    class QmlImageProvider : public QQuickImageProvider
    {
    public:
        QmlImageProvider();

        QPixmap requestPixmap( const QString &id, QSize *size, const QSize &requestedSize) override;
        QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
    };
}

