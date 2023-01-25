#pragma once
#include <vector>
#include <memory>

namespace Application
{
    class QFlowObject;
    using QFlowObjectUptr   = std::unique_ptr<QFlowObject>;
    using QFlowObjectVector = std::vector<QFlowObjectUptr>;
}