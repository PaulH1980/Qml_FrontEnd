#pragma once
#include <memory>
#include "ApplicationInteractionFwd.h"

namespace Application
{
    using ApplicationInteractionPtr         = std::shared_ptr<ApplicationInteraction>;
    using ApplicationInteractionUniquePtr   = std::unique_ptr<ApplicationInteraction>;
}