#include "QmlImageProvider.hpp"
#include "AppIncludes.h"

namespace Application
{

    QPixmap CreateCheckerBoard(QSize* size)
    {
        auto SetPixel = [](QImage& theImage, int x, int y, int w, int h, const QColor& color)
        {
            const auto xStart = x;
            const auto xEnd = xStart + w;
            const auto yStart = y;
            const auto yEnd = yStart + h;
            
            for (int i = xStart; i < xEnd; ++i) {
                for (int j = yStart; j < yEnd; ++j) {
                    theImage.setPixelColor( i, j, color );
                }
            }
        };

        const int width = 8;
        const int height = 8;
        const int blockSizeX = width / 2;
        const int blockSizeY = height / 2;

        QImage image(width, height, QImage::Format_RGBA8888);

        int blockCount = 0;
        for (int w = 0; w < width; w += blockSizeX)
        {
            for ( int h = 0; h < height; h += blockSizeY)
            {
                QColor color = blockCount & 0x01 ? QColor(255, 255, 255, 255) : QColor(0, 0, 0, 255);
                SetPixel( image, w, h, blockSizeX, blockSizeY, color);
                blockCount++;
            }
            blockCount++;
        }

        if (size)
            *size = QSize(width, height);

        return QPixmap::fromImage(image);
       
    }


    QmlImageProvider::QmlImageProvider() 
        : QQuickImageProvider(QQuickImageProvider::Pixmap)
    {

    }

    QPixmap QmlImageProvider::requestPixmap( const QString &id, QSize *size, const QSize &requestedSize )
    {
        //built in types
        if (id.toLower() == "checkerboard")
            return CreateCheckerBoard( size );
        else
        {

        }
        throw "Not Implemented";

    }

    QImage QmlImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
    {
        QImage ret;
        return ret;
    }

}

