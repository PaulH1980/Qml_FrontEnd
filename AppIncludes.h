#pragma once

#include <IO/FileSystemFolder.h>
#include <IO/FileSystem.h>
#include <IO/JSonObject.h>
#include <IO/JSonSerializer.h>
#include <IO/MenuEntry.h>

#include <Math/GenMath.h>
#include <Math/AABB.h>
#include <Math/RegisterMath.h>
#include <Math/Range.h>

#include <Profiler/Profiler.h>

#include <Engine/EngineContext.h>
#include <Engine/DefaultEvents.h>
#include <Engine/EngineTimer.h>
#include <Engine/DefaultEvents.h>
#include <Engine/EventSystem.h>
#include <Engine/DefaultEvents.h>

#include <Audio/AudioSystem.h>
#include <Audio/AudioConfig.h>

#include <Physics/PhysicSystem.h>
#include <Physics/PhysicsObject.h>

#include <Commands/CommandStack.h>
#include <Commands/GlobalVariableStore.h>
#include <Commands/CommandPtr.h>
#include <Commands/CommandEvents.h>
#include <Commands/RegisterCommands.h>

#include <Graphics/GraphicsContext.h>
#include <Graphics/GraphicsSystem.h>
#include <Graphics/Camera.h>
#include <Graphics/Frustum.h>
#include <Graphics/Mesh.h>
#include <Graphics/DebugRender.h>
#include <Graphics/Gradient.h>
#include <Graphics/RegisterGraphics.h>

#include <Input/InputHandler.h>

#include <Tools/ToolSystem.h>
#include <Tools/RegisterTools.h>

#include <Console/FileRecipient.h>
#include <Console/ConsoleRecipient.h>
#include <Console/LogRecipientPtr.h>
#include <Console/Logger.h>

#include <ScriptEngine/ScriptEngine.h>


#include <Render/RegisterRenderer.h>
#include <Render/OpenGLIncludes.h>

#include <Resource/ResourceManager.h>
#include <Resource/ResourceType.h>
#include <Resource/RegisterResources.h>

#include <Properties/RegisterProperties.h>

#include <Components/ComponentSystem.h>
#include <Components/RegisterComponents.h>


#include <Scene/Octree.h>
#include <Scene/NullSceneGraph.h>
#include <Scene/BSPTree.h>
#include <Scene/BSPPortalBuilder.h>
#include <Scene/RegisterEntities.h>
#include <Scene/EntityVisitorBase.h>
#include <Scene/ObjectSelectionResult.h>
#include <Scene/SelectionSystem.h>
#include <Scene/WorldEntity.h>
#include <Scene/NodeSystem.h>





#include <Flow/FlowNodes.h>
#include <Flow/TestDriver.h>



using namespace Commands;
using namespace Resources;
using namespace Engine;
using namespace Common;
using namespace IO;
using namespace Math;
using namespace Log;
using namespace Render;
using namespace Graphics;
using namespace Scene;
using namespace Audio;
using namespace Components;
using namespace Physics;
using namespace Input;
using namespace Debug;
using namespace Properties;
using namespace Tools;
using namespace Script;