#include "AppQtRoles.hpp"

namespace Application
{
    void QtEnums::RegisterQEnums()
    {
        qmlRegisterType<QtEnums>("RoleEnums", 1, 0, "InspectorRoles");
    }
}