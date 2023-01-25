#pragma once
#include "QtHeaders.h"
namespace Application
{
    class UuidGen : public QObject
    {
        Q_OBJECT
    public:
        UuidGen(QObject* parent = nullptr);

    Q_INVOKABLE
         QString   generate()const;
    private:
    };

}
