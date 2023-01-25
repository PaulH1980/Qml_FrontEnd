#pragma once

#pragma once
#include <Resource/ResourceBasePtr.h>
#include <Engine/EngineContextPtr.h>
#include <Engine/ContextProvider.h>
#include <Engine/EventSubscriber.h>
#include <Engine/EventSystem.h>
#include <Scene/WorldEntityFwd.h>
#include <Scene/SceneGraphBasePtr.h>
#include <Components/SkyBoxComponentFwd.h>
#include <Components/CameraComponentFwd.h>

#include "QtHeaders.h"

namespace Application
{
    class RegisterFlowNodes : public QObject
    {
        Q_OBJECT
    public:
        Q_ENUMS(eEventTypes)
   // qmlRegisterType<QtEnums>("RoleEnums", 1, 0, "InspectorRoles");
    };

    

}