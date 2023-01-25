#pragma once

#include <map>
#include <functional>
#include <string>
#include <IO/JSonObject.h>
#include "ApplicationInteractionFwd.h"

namespace Application
{
    using MenuCallBack       = std::function< bool(const IO::JSonObject&) >;
    using MenuCallBackMap    = std::map<std::string, MenuCallBack>;   
}