#include <Common/StringTools.h>
#include "UuidGen.hpp"

namespace Application
{

    UuidGen::UuidGen(QObject* parent /*= nullptr*/) 
        : QObject(parent)
    {

    }

   QString UuidGen::generate() const
   {
       return QString::fromStdString( Common::GenerateUuid( ) );
   }
}

