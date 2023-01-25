#include "AppTestScene.h"
#include "AppIncludes.h"
#include "ClientEntity.h"
#include "AppException.h"
#include "EngineObjectProxy.hpp"
#include "ApplicationInteraction.h"


namespace
{

    
    /*
        @brief: Serialize Scene to a file
    */
    inline bool SerializeScene(EngineContext* context, const std::string& fileName )
    {
        Event newEvent("SERIALIZE_SCENE");
        newEvent.setValue("NAME", fileName);   
        context->getEventSystem()->postEvent(newEvent);    
        return true;
    }   
    
    /*
        @brief: Look at specific direction
    */
    inline bool PostLookAtEvent(EngineContext* context, 
        const Math::Vector3f& eye, 
        const Math::Vector3f& target, 
        const Math::Vector3f& up)
    {
        Event evt("CAMERA_LOOK_AT");
        evt.setValue("EYE", eye);
        evt.setValue("TARGET", target);
        evt.setValue("UP", up);
        context->getEventSystem()->postEvent(evt);
        return true;
    }

    /*
        @brief: Post zoom-to commands keeps camera's current viewing direction
    */
    inline bool PostZoomToBounds(const CameraComponent* activeCamera, const BBox3f& bounds)
    {
        if (!bounds.isValid()) {
            activeCamera->getContext()->getSystem<Logger>()->addMessage(
                std::string("Invalid Bounds For:  ") + __FUNCTION__, LOG_LEVEL_WARNING);
            return false;
        }
        const auto center   = bounds.getCenter();
        const auto distance = bounds.getSize().getMaxValue() * 1.5f;
        const auto viewmat  = activeCamera->getCamera()->getViewMatrix(true);
        const auto viewDir  = viewmat.getDirection();
        const auto upVec    = viewmat.getUp();
        const auto eyePos   = center + (viewDir * distance);

        return PostLookAtEvent( activeCamera->getContext(), eyePos, center, upVec );
    }

    inline std::uint32_t GetObjectIdFromJson(const IO::JSonObject& obj)
    {
        if (std::end(obj) == obj.find("ObjectId"))
            return INVALID_NODE_ID;
        return  obj["ObjectId"].get<std::uint32_t>();
    }

    inline std::string GetObjectTypeFromJson(const IO::JSonObject& obj)
    {
       if (std::end(obj) == obj.find("ObjectType"))
            return "";
        return  obj["ObjectType"].get<std::string>();
    }
}


namespace Application
{

    ApplicationInteraction::ApplicationInteraction()
        : m_contextPtr(std::make_unique<EngineContext>())
    {
        EventSubscriber::setContextProvider(this);
    }

    void ApplicationInteraction::simulationStep()
    {
        m_contextPtr->simulationStep();       
    }


    void ApplicationInteraction::present()
    {
        getContext()->present();
        if (auto renderer = m_contextPtr->getSystem<RenderBase>()) {
            if (renderer->getStatus() != RENDERER_NO_ERROR)
                throw ApplicationException("Invalid Render State");
        }
    }

    EngineContext* ApplicationInteraction::getContext() const
    {
        return m_contextPtr.get();
    }

    bool ApplicationInteraction::initializeSubSystems()
    {
        bool success = true;      
        //init & start audio system
        if (auto audioSys = getContext()->getSystem<AudioSystem>()) {
            success &= audioSys->initialize();
            success &= audioSys->start();
        }
        return success;
    }




    bool ApplicationInteraction::initializeDefaultObjects()
    {
        auto worldEntity = m_contextPtr->getWorldEntity();
        worldEntity->setSceneGraph(std::make_shared<NullSceneGraph>());
        m_clientPtr     = worldEntity->createChild<ClientEntity>();
        worldEntity->setMainView(m_clientPtr);
        m_sceneGraphPtr = worldEntity->getSceneGraph();
       
#if _DEBUG
        CreateTestScene( m_contextPtr.get() );
#endif

        /*  if (  )
          {
              auto evtSystem = m_contextPtr->getSystem<EventSystem>();
              evtSystem->postEvent(Event(EVENT_TYPE(SCENE_LOADED)));
          }*/
        {
            auto evtSystem = m_contextPtr->getSystem<EventSystem>();
            evtSystem->postEvent(Event("SCENE_LOADED"));            
            //getContext()->pushEvent(Event(EVENT_TYPE(SCENE_LOADED)));           
        }

#if _DEBUG
        auto& scriptEngine = m_contextPtr->getSystem<ScriptEngine>()->getScriptingBackend();
        auto result     = scriptEngine.eval(R"(__Logger.addMessage("HELLO");)");
#endif
        return true;
    }



    bool ApplicationInteraction::initializeDefaultTools()
    {
        Tools::Register( getContext() );
        return true;
    }


    bool ApplicationInteraction::initializeDefaultScripts()
    {
        const auto scriptsPath = IO::FileSystemFolders::GetGlobalScriptsPath();
        return true;
    }

    void ApplicationInteraction::postEvents()
    {
        //getContext()->flushEvents();
    }

    bool ApplicationInteraction::requestContextMenuData(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::registerConsoleVars()
    {
        auto varStore = getContext()->getSystem<GlobalVariableStore>();
        bool success = true;

        success &= varStore->setVariable("phys_gravity", Vector3f(0.0f, 0.0f, -9.8f));
        success &= varStore->setVariable("phys_show_debug_bounds", false);
        success &= varStore->setVariable("phys_show_contact_points", false);

        success &= varStore->setVariable("dbg_show_profiler", false);
        success &= varStore->setVariable("dbg_clipped_portal_interval", 10000);
        success &= varStore->setVariable("dbg_show_portal_time", 5000);
        success &= varStore->setVariable("dbg_show_portal_frustum", false);
        success &= varStore->setVariable("dbg_show_portals", false);
        success &= varStore->setVariable("dbg_render_from_mirror", 0);
        success &= varStore->setVariable("dbg_init_qml_flownodes", false); //don't created qml flownodes( since parsing is slow for now )

        success &= varStore->setVariable("r_ambient", Vector4f(0.2f, 0.2f, 0.2f, 1.0f));
        success &= varStore->setVariable("r_sunpos", Vector4f(100.0f, 100.0f, 100.0f, 100.0f));
        success &= varStore->setVariable("r_maxDistSurfacePortal", 96.0f * 96.0f); //squared distance to tag surface portals
        success &= varStore->setVariable("r_maxDrawDistancePortal", 512.0f * 512.0f);
        success &= varStore->setVariable("r_drawSky", 1);
        success &= varStore->setVariable("r_drawTransparent", 1);
        success &= varStore->setVariable("r_drawSolid", 1);
        success &= varStore->setVariable("r_drawPortals", 1);
        success &= varStore->setVariable("r_lightmapScale", 1.0f);

        return success;
    }

    bool ApplicationInteraction::registerSubSystems()
    {
        bool success = true;
        auto contextPtr = getContext();

        success &= contextPtr->registerSystem<InputHandler>();
        success &= contextPtr->registerSystem<PhysicsSystem>();
        success &= contextPtr->registerSystem<AudioSystem>();
        success &= contextPtr->registerSystem<CommandStack>();
        success &= contextPtr->registerSystem<Profiler>();
        success &= contextPtr->registerSystem<GlobalVariableStore>();
        //Init renderer
        success &= contextPtr->registerSystem<OpenGLRenderer>(RenderBase::GetTypeNameStatic());
        //These systems all rely on hardware render backend, initialize them after the renderer
        success &= contextPtr->registerSystem<GraphicsSystem>();
        success &= contextPtr->registerSystem<ResourceManager>();
        success &= contextPtr->registerSystem<DebugRender>();
        //tools rely on shaders( #TODO fix dependency )
        success &= getContext()->createDefaultResources();

        //2d graphics context
        success &= contextPtr->registerSystem<GraphicsContext>();

        success &= contextPtr->registerSystem<ToolSystem>();
        success &= contextPtr->registerSystem<SelectionSystem>();

        return success;
    }


    bool ApplicationInteraction::registerDefaultObjects()
    {
        bool success = true;       
        Scene::Register(getContext());
        Components::Register(getContext());
        Properties::Register(getContext());
        Graphics::Register(getContext());
        ClientEntity::Register(getContext());      
        return success;
    }


   

    bool ApplicationInteraction::newProject(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::openProject(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::saveProject( const IO::JSonObject& obj )
    {
        if (m_lastSaveFile.empty()) {
            const IO::JSonObject dummy;
            return saveProjectAs( dummy );
        }      

        return SerializeScene( getContext(), m_lastSaveFile );
    }

    bool ApplicationInteraction::saveProjectAs(const IO::JSonObject& obj)
    {
        char const * FilePatterns[1] = { "*.scene" };
        
     /*   
        const auto fileName = tinyfd_saveFileDialog( "Save Project As", "D://", 1, FilePatterns, 0);
        if (!fileName)
            return false;*/
        const auto result = SerializeScene( getContext(), "d://test.scene" );
        /*if (result)
            m_lastSaveFile = fileName;*/
        return result;
    }

    bool ApplicationInteraction::importPointCloud(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::exportPointCloud(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::undo(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        auto commands = m_contextPtr->getSystem<CommandStack>();
        commands->undoAction();
        return true;
    }

    bool ApplicationInteraction::redo(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        auto commands = m_contextPtr->getSystem<CommandStack>();
        commands->redoAction();
        return true;
    }

    bool ApplicationInteraction::cut(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::copy(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::duplicate(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::paste(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::selectAll(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::unselectAll(const IO::JSonObject& obj)
    {

        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::deleteSelect(const IO::JSonObject& obj)
    {

        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::options(const IO::JSonObject& obj)
    {

        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::setDisplayRGB(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::setDisplayIntensity(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::setDisplayHeight(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::setDisplayNormals(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::setBackgroundGradient(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::setBackgroundSkyBox(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::toggleFilterPoints(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::toggleFilterLabels(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::toggleFilterMeasures(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::toggleFilterMeshes(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::toggleFilterLines(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::toggleFilterOverlay(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::setProjModeOrtho(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::setProjModePersp(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);


        return true;
    }

    bool ApplicationInteraction::zoomExtents(const IO::JSonObject& obj)
    {
        const auto bbox = getContext()->getWorldEntity()->getWorldBounds();
        return PostZoomToBounds(m_clientPtr->getComponent<CameraComponent>(), bbox);
    }

    bool ApplicationInteraction::zoomExtentsSelected(const IO::JSonObject& obj)
    {
        const auto ss = getContext()->getSystem<SelectionSystem>();
        const auto bounds = ss->getSelectionBounds();
        return PostZoomToBounds( m_clientPtr->getComponent<CameraComponent>(), bounds);
    }

    bool ApplicationInteraction::camViewTop(const IO::JSonObject& obj)
    {
        const auto bbox = getContext()->getWorldEntity()->getWorldBounds();
        const auto center = bbox.getCenter();
        const auto target = bbox.getSize() * 1.0f;
        const auto eye = Vector3f{ center[0], center[1] , center[2] + target[2] };
        const auto up = Vector3f{ 0, 1, 0 };
        return PostLookAtEvent(getContext(), eye, center, up);
    }

    bool ApplicationInteraction::camViewFront(const IO::JSonObject& obj)
    {
        const auto bbox = getContext()->getWorldEntity()->getWorldBounds();
        const auto center = bbox.getCenter();
        const auto target = bbox.getSize() * 1.0f;
        const auto eye = Vector3f{ center[0], center[1] - target[1], center[2] };
        const auto up = Vector3f{ 0, 0, 1 };
        return PostLookAtEvent(getContext(), eye, center, up);
    }

    bool ApplicationInteraction::camViewLeft(const IO::JSonObject& obj)
    {
        const auto bbox = getContext()->getWorldEntity()->getWorldBounds();
        const auto center = bbox.getCenter();
        const auto target = bbox.getSize() * 1.0f;
        const auto eye = Vector3f{ center[0] - target[0], center[1] , center[2] };
        const auto up = Vector3f{ 0, 0, 1 };
        return PostLookAtEvent(getContext(), eye, center, up);
    }

    bool ApplicationInteraction::camViewBottom(const IO::JSonObject& obj)
    {
        const auto bbox = getContext()->getWorldEntity()->getWorldBounds();
        const auto center = bbox.getCenter();
        const auto target = bbox.getSize() * 1.0f;
        const auto eye = Vector3f{ center[0], center[1] , center[2] - target[2] };
        const auto up = Vector3f{ 0, 1, 0 };
        return PostLookAtEvent(getContext(), eye, center, up);
    }

    bool ApplicationInteraction::camViewRight(const IO::JSonObject& obj)
    {
        const auto bbox = getContext()->getWorldEntity()->getWorldBounds();
        const auto center = bbox.getCenter();
        const auto target = bbox.getSize() * 1.0f;
        const auto eye = Vector3f{ center[0] + target[0], center[1] , center[2] };
        const auto up = Vector3f{ 0, 0, 1 };
        return PostLookAtEvent(getContext(), eye, center, up);
    }

    bool ApplicationInteraction::camViewBack(const IO::JSonObject& obj)
    {
        const auto bbox = getContext()->getWorldEntity()->getWorldBounds();
        const auto center = bbox.getCenter();
        const auto target = bbox.getSize() * 1.0f;
        const auto eye = Vector3f{ center[0], center[1] + target[1] , center[2] };
        const auto up = Vector3f{ 0, 0, 1 };
        return PostLookAtEvent(getContext(), eye, center, up);

    }

    bool ApplicationInteraction::addView(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::gradientEditor(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::closeApplication(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::minimizeApplication(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::maximizeApplication(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::limitBoxToggle(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);


        return true;
    }

    bool ApplicationInteraction::limitBoxRotate(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::limitBoxScale(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::limitBoxTranslate(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::addLabel(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::addMeasurement(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::debugSpawnCubes(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        return true;
    }

    bool ApplicationInteraction::debugRemoveCubes(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::clearPropGrid(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::randomPropGrid(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::clearSceneTree(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::changeSelectionMode(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::selectionModeNone(const IO::JSonObject& obj)
    {
        auto selSystem = getContext()->getSystem<SelectionSystem>();
        if (!selSystem)
            return false;
        selSystem->changeSelectionMode(SELECTION_NONE);
        return true;
    }

    bool ApplicationInteraction::selectionModeVoxels(const IO::JSonObject& obj)
    {
        auto selSystem = getContext()->getSystem<SelectionSystem>();
        if (!selSystem)
            return false;
        selSystem->changeSelectionMode(SELECTION_VOXELS);
        return true;
    }

    bool ApplicationInteraction::selectionModeVertices(const IO::JSonObject& obj)
    {
        auto selSystem = getContext()->getSystem<SelectionSystem>();
        if (!selSystem)
            return false;
        selSystem->changeSelectionMode(SELECTION_VERTICES);
        return true;
    }

    bool ApplicationInteraction::selectionModeEdges(const IO::JSonObject& obj)
    {
        auto selSystem = getContext()->getSystem<SelectionSystem>();
        if (!selSystem)
            return false;
        selSystem->changeSelectionMode(SELECTION_EDGES);
        return true;
    }

    bool ApplicationInteraction::selectionModeFaces(const IO::JSonObject& obj)
    {
        auto selSystem = getContext()->getSystem<SelectionSystem>();
        if (!selSystem)
            return false;
        selSystem->changeSelectionMode(SELECTION_FACES);
        return true;
    }

    bool ApplicationInteraction::selectionModeObjects(const IO::JSonObject& obj)
    {
        auto selSystem = getContext()->getSystem<SelectionSystem>();
        if (!selSystem)
            return false;
        selSystem->changeSelectionMode(SELECTION_OBJECTS);
        return true;
    }

    bool ApplicationInteraction::nullFunction(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return false;
    }

    bool ApplicationInteraction::groupObjects(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::unGroupObjects(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::duplicateSelection(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::removeObject(const IO::JSonObject& obj)
    {
        throw std::runtime_error("Not Implemented");
        
        /*getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        auto objectId = GetObjectIdFromJson(obj);
        if (objectId == INVALID_NODE_ID)
            return false;
        auto objPtr = getContext()->getObjectBase(objectId);
        if (!objPtr)
            return false;

        const auto resman = getContext()->getSystem<ResourceManager>();
        if (auto resPtr = std::dynamic_pointer_cast<ResourceBase>(objPtr))
            return resman->removeResource(resPtr);

        else if (auto nodePtr = std::dynamic_pointer_cast<Node>(objPtr)) {
            auto parent = nodePtr->getParent();
            assert(parent != INVALID_INDEX);
            auto parentPtr = getContext()->getObjectConcrete<Node>(parent);
            return parentPtr->removeChild(objectId);
        }
        else if (auto compPtr = std::dynamic_pointer_cast<ComponentBase>(objPtr)) {
            auto parent = getContext()->getObjectConcrete<Node>(compPtr->getNode());
            return parent->removeComponent(objectId);
        }*/
        return false;
    }



    bool ApplicationInteraction::createObject(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);

        auto objectId       = GetObjectIdFromJson(obj);
        auto objectType     = GetObjectTypeFromJson(obj);
        throw std::runtime_error("Not Implemented");     
        return true;
    }



    bool ApplicationInteraction::zoomToObject(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage( __FUNCTION__, LOG_LEVEL_DEBUG );
        return true;
    }

    bool ApplicationInteraction::cloneObject(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }


    bool ApplicationInteraction::createScratchResource(const IO::JSonObject& obj)
    {
        const auto resourceType = GetObjectTypeFromJson(obj);
        auto resMan = getContext()->getSystem<ResourceManager>();
        auto newObj = resMan->createResource(resourceType);
        assert(newObj && "Unregistered Resource");
        m_scratchResource = newObj;
        return true;
    }

    bool ApplicationInteraction::selectObject(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::moveUp(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::moveDown(const IO::JSonObject& obj)
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        return true;
    }

    bool ApplicationInteraction::activateTool( const IO::JSonObject& obj )
    {
        getContext()->getSystem<Logger>()->addMessage(__FUNCTION__, LOG_LEVEL_DEBUG);
        /*  auto toolSystem = m_contextPtr->getSystem<ToolSystem>();
          assert(toolSystem && "ToolSystem Not Found");
          return toolSystem->activateTool(obj);*/

        Event newEvent( "ACTIVATE_TOOL_REQUEST" );
        newEvent.setValue( "TOOL_ARGS", obj.dump( 0 ) );
        postEvent(newEvent);
        return true;
    }

    bool ApplicationInteraction::openAndExecuteScriptFile( const IO::JSonObject& obj )
    {
        auto FailWithWarning = [this](const std::string& msg) {
            getContext()->addLogMessage( msg, LOG_LEVEL_WARNING );
            return false;
        };

        const auto scriptSystem = getContext()->getSystem<ScriptEngine>();
        if (!scriptSystem)
            return FailWithWarning("Script Engine Not Registered");
        
        FileDialogOptions options = {
            std::string("Execute Script"),
            std::string(""),
            std::string("Script Files (*.vscr)")
        };

        auto scriptFile = openFileDialog(options);        
        if( scriptFile.empty() ) //file exists?
            return FailWithWarning("Not A Script");

        auto scriptData = IO::FileSystem::ReadText(scriptFile);
        if (scriptData.empty()) //contains data?
            return FailWithWarning("Empty Script Data");
        //post event that eventually will be picked up by script engine
        Event newEvent("EXECUTE_SCRIPT");
        newEvent.setValue("SCRIPT_DATA", scriptData);
        postEvent(newEvent);
        return true;
    }

}