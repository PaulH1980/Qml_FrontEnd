
#include "AppException.h"
#include "QmlLogRecipient.h"
#include "AppIncludes.h"
#include <Engine/ObjectContextMenuResolver.h>
#include <Render/ParseShaderFunctions.h>
#include "EngineObjectProxy.hpp"
#include "QmlProperty.hpp"
#include "QmlPropertyResolver.h"
#include "QmlTreeViewNodeResolver.h"
#include "QmlMainMenu.h"

#include "ClientEntity.h"
#include "ObjectPropertyModel.hpp"
#include "QmlTreeViewModel.hpp"
#include "PropertyGenerator.h"
#include "MainApplication.hpp"
#include "QmlGlobal.hpp"

namespace Application
{
      
     MainApplication::MainApplication(QQuickView* parent)
        : QObject(parent)        
        , m_parent( parent )
        , m_propertyModel( new ObjectPropertyModel( this ) )
        , m_resourceModel( new ObjectPropertyModel( this ) )
        , m_sceneModel( new QmlTreeViewModel( this ) )
        , m_appglobals( new QmlGlobal(this) )
    {
        
        m_sceneModel->setContextProvider(this);   
        m_propertyModel->setContextProvider(this);
        m_resourceModel->setContextProvider(this);     

        getRootContext()->setContextProperty( "ApplicationGlobals", m_appglobals    );
        getRootContext()->setContextProperty( "MainApplication",    this            );
        getRootContext()->setContextProperty( "PropertyModel",      m_propertyModel );
        getRootContext()->setContextProperty( "SceneModel",         m_sceneModel    );
        getRootContext()->setContextProperty( "ResourceModel",      m_resourceModel );    

        FileSystemFolders::SetGlobalRootPath(FileSystem::GetExecutablePathWithSeperator() + "data/");
    }
        

    bool MainApplication::initialize()
    {
        bool success = true;        
       
        //try to initialize everything required for app
        success &= registerSubSystems();
        success &= registerDefaultObjects();
        success &= registerEventCallbacks();       
        success &= registerConnections();
       
        success &= registerConsoleVars();        
        //#todo this is too slow since qml textfield buffers everything
        //success &= registerLogRecipients();

        success &= createMenuItemsAndCallbacks();
     
        success &= initializeSubSystems();
        //tools should be initialized before creating a rootnode & camera component,
        //since they both listen to activeCamera events
        success &= initializeDefaultTools();
        success &= initializeDefaultObjects();       
        success &= initializeDefaultScripts();


        if (!success)
            throw ApplicationException("Failed To Initialize Application");

        Engine::GetSharedNodeContextMenuData(getContext(), -1 );
        
        return success;
    }

    void MainApplication::shutDown()
    {

    }  

  

    std::string MainApplication::openFileDialog( const FileDialogOptions& options )
    {
        const auto result = QFileDialog::getOpenFileName(nullptr,
            QString::fromStdString(options.m_title),
            QString::fromStdString(options.m_folder),
            QString::fromStdString(options.m_filter));
        return result.toStdString();
    }

    std::string MainApplication::saveFileDialog( const FileDialogOptions& options)
    {
        const auto result = QFileDialog::getSaveFileName(nullptr,
            QString::fromStdString(options.m_title),
            QString::fromStdString(options.m_folder),
            QString::fromStdString(options.m_filter));
        return result.toStdString();
    }

    

    bool MainApplication::registerLogRecipients()
    {
        auto logger = getContext()->getSystem<Logger>();
        auto*console = getRootObject()->findChild<QObject*>("userConsole");
        if (!logger || !console)
            return false;

        bool success = true;
        //success &= logger->addRecipient(std::make_shared<ConsoleRecipient>());
        success &= logger->addRecipient(std::make_shared<QmlLogRecipient>(console));
        return success;
    }

    bool MainApplication::registerConnections()
    {
        bool success = true;
      
        connect(getRootObject(), SIGNAL(menuItemClicked(QString)),
            this, SLOT(onQmlMenuItemClicked(QString)));
        //rebuild UI on scene loaded signal
        connect( this, SIGNAL(sceneLoaded()), this, SLOT( clearAndRebuildUI() ) );
        //selection from TreeView
        connect(m_sceneModel, SIGNAL(newObjectSelected(EngineObjectProxy)),
            this, SLOT(selectObject(EngineObjectProxy)), Qt::QueuedConnection);               

        connect(this, &MainApplication::toolActivated, this, &MainApplication::setActiveTool, Qt::ConnectionType::QueuedConnection);
        connect(this, &MainApplication::toolClosed, this, &MainApplication::closeCurrentTool, Qt::ConnectionType::QueuedConnection);
        connect(this, &MainApplication::toolUpdated, this, &MainApplication::updateActiveTool,Qt::ConnectionType::QueuedConnection);
        connect(this, &MainApplication::contextMenuResponse, this, &MainApplication::setContextMenuData, Qt::ConnectionType::QueuedConnection);

        connect(this, &MainApplication::flowNodeDescriptionParsed, this, &MainApplication::addFlowNodeDescription, Qt::ConnectionType::QueuedConnection);
        connect(this, &MainApplication::eventDescriptionParsed, this, &MainApplication::addEventDescription, Qt::ConnectionType::QueuedConnection);

        //treeview events
        connect(this, &MainApplication::componentAdded,  m_sceneModel, &QmlTreeViewModel::componentAdded, Qt::ConnectionType::QueuedConnection);
        connect(this, &MainApplication::entityAdded,       m_sceneModel, &QmlTreeViewModel::entityAdded,Qt::ConnectionType::QueuedConnection);
        connect(this, &MainApplication::resourceAdded,   m_sceneModel, &QmlTreeViewModel::resourceAdded, Qt::ConnectionType::QueuedConnection);

        connect(this, &MainApplication::componentRemoved,   m_sceneModel, &QmlTreeViewModel::componentRemoved, Qt::ConnectionType::QueuedConnection);
        connect(this, &MainApplication::entityRemoved,        m_sceneModel, &QmlTreeViewModel::entityRemoved, Qt::ConnectionType::QueuedConnection);
        connect(this, &MainApplication::resourceRemoved,    m_sceneModel, &QmlTreeViewModel::resourceRemoved, Qt::ConnectionType::QueuedConnection);

        //process return code from resource dialog
        connect( getRootObject(), SIGNAL(resourceDialogOkCancelClicked(int)),
                this, SLOT(processResourceDialogReturnCode(int)));      
        
        return success;
    }


    bool MainApplication::registerEventCallbacks()
    {
       /* EventHandler handler;
        handler.bind<MainApplication, &MainApplication::onToolRegistered>(this);*/
        
        
        subscribeToEvent(  CreateEventHandler(this, &MainApplication::onToolRegistered,  "TOOL_REGISTERED"));        
        subscribeToEvent(  CreateEventHandler(this, &MainApplication::onToolActivated,   "TOOL_ACTIVATED"));
        subscribeToEvent(  CreateEventHandler(this, &MainApplication::onToolClosed,      "TOOL_CLOSED"));
        
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onSceneLoaded,             "SCENE_LOADED"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onGlobalVariableAdded,     "GLOBALVAR_LIST_ADDED"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onGlobalVariableRemoved,   "GLOBALVAR_LIST_REMOVED"));
        
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onNodeAdded,        "NODE_ADDED"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onComponentAdded,   "COMPONENT_ADDED"));
                                                                    
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onNodeRemoved,      "NODE_REMOVED"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onComponentRemoved, "COMPONENT_REMOVED"));
                                                                    
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onResourceRemoved, "RESOURCE_REMOVED"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onResourceAdded,   "RESOURCE_ADDED"));
                                                                    
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onObjectSelectionChanged, "SELECTION_CHANGED"));
                                                                    
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onTransformChanging,"TRANSFORM_GIZMO_CHANGING"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onTransformChanged, "TRANSFORM_GIZMO_CHANGED"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onActiveToolUpdated,"TOOL_UPDATED"));
                                                                    
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onContextMenuResponse, "CONTEXT_MENU_RESPONSE"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onEventDescriptionParsed, "EVENT_DESCRIPTION_PARSED"));
        subscribeToEvent( CreateEventHandler(this, &MainApplication::onFlowNodeDescriptionParsed,"FLOW_NODE_DESCRIPTION_PARSED"));

         
        return true;
    }
    
    //bool MainApplication::registerContextMenuDataToUI()
    //{
    //    //Add menu entries to qml-engine
    //    QQuickItem* rootObject = getRootObject();
    //    const char* funcName = "setMainViewContextMenuData";
    //    auto contextMenuData = QmlContextMenuResolver::MainViewContextMenuData(getContext());
    //    QMetaObject::invokeMethod(rootObject, funcName,
    //            Q_ARG(QVariant, contextMenuData ),
    //            Q_ARG(QVariant, "" ),
    //            Q_ARG(QVariant, "" ) );
    //    return true;
    //}

    //bool MainApplication::registerEngineEventsToUI()
    //{
    //    //Add menu entries to qml-engine
    //    QQuickItem* rootObject = getRootObject();
    //    const char* funcName = "registerEngineEventToFlowEditor";
    //    //( name, jsonObj, subSection ="" )
    //    const auto& regEvents = getContext()->getSystem<EventSystem>();
    //    for (const auto& [key, value] : regEvents->getRegisteredEvents())
    //    {
    //        const auto  eventName = value.getEventName();
    //        const auto  subSection = value.m_uiSubSection;
    //        const auto  jsonStr    = value.toJsonObject().dump(0);
    //     
    //        QMetaObject::invokeMethod(rootObject, funcName,
    //            Q_ARG( QVariant, eventName.c_str() ), //eventname
    //            Q_ARG( QVariant, jsonStr.c_str() ) , //jsonstr
    //            Q_ARG( QVariant, subSection.c_str() )                //subsection
    //            );
    //    }
    //    return true;
    //}


    void MainApplication::addFlowNodeDescription( QString shaderFuncDef )
    {
        QQuickItem* rootObject = getRootObject();
        const char* funcName = "registerFlowNode";     

        auto gvs = getContext()->getSystem<GlobalVariableStore>();
        bool initFlowNodes = true;
        gvs->queryVariable("dbg_init_qml_flownodes", initFlowNodes);

        if( initFlowNodes)
            QMetaObject::invokeMethod( rootObject, funcName, Q_ARG( QVariant, shaderFuncDef ) );     
    }

    void MainApplication::addEventDescription(QString eventDef)
    {

        QQuickItem* rootObject = getRootObject();
        const char* funcName = "registerFlowNode";
        auto gvs = getContext()->getSystem<GlobalVariableStore>();
        bool initFlowNodes = true;
        gvs->queryVariable("dbg_init_qml_flownodes", initFlowNodes);

        if(initFlowNodes)
            QMetaObject::invokeMethod(rootObject, funcName, Q_ARG(QVariant, eventDef));
    }

    /*
        @brief: retrieves a json string, that will get validated,
        and dispatches a callback
    */
    void MainApplication::onQmlMenuItemClicked( QString jsonData )
    {
        const auto& logger = getContext()->getSystem<Logger>();

        const auto jsonStr = jsonData.toStdString();
        auto jsonObj = JSonObject::parse( jsonStr );
        if ( (std::end(jsonObj) == jsonObj.find( "Uuid" ) ) ) {
            logger->addMessage("Invalid Json-Data", LOG_LEVEL_WARNING);
            return;
        }
        //fetch callback name
        const auto callback = jsonObj["Uuid"].get<std::string>();
        const auto it = m_callbacks.find(callback);
        if ( std::end( m_callbacks ) == it ) {
            logger->addMessage( "Callback Not Registered: " + callback, LOG_LEVEL_WARNING );
            return;
        }               
        JSonObject payLoad = jsonObj["CommandArgsAsJson"];           
        //dispatch callback
        it->second(payLoad);
    }

    void MainApplication::clearAndRebuildUI()
    {
        resetUI();       
        QmlTreeViewNodeResolver::CreateSceneItems( this, m_sceneModel->getItem( ITEM_SCENE ) );
        QmlTreeViewNodeResolver::CreateResourceItems( this, m_sceneModel->getItem( ITEM_RESOURCE  ) );
    }   

    void MainApplication::resetUI()
    {
        m_sceneModel->clear();
        m_sceneModel->createDefaultItems();
        m_propertyModel->clear();
    }

    QQuickView* MainApplication::getMainWindow() const
    {
        return m_parent;
    }

    QQmlContext* MainApplication::getRootContext() const
    {
        return getMainWindow()->rootContext();
    }

    QQuickItem* MainApplication::getRootObject() const
    {
        return getMainWindow()->rootObject();
    }

    void MainApplication::resize(int w, int h)
    {
        if (w <= 0 || h <= 0)
            return;
        Event evt("RESIZE");
        evt.setValue("RESIZE_WIDTH", w);
        evt.setValue("RESIZE_HEIGHT", h);
        postEvent(evt);
    }

    void MainApplication::registerEngineTypesToQml()
    {
        
    }

    void MainApplication::mouseDown(int x, int y, int mouseButton)
    {
        Event newEvent("MOUSE_DOWN");
        newEvent.setValue("MOUSE_X", x);
        newEvent.setValue("MOUSE_Y", y);
        newEvent.setValue("MOUSE_BUTTON", mouseButton);
        postEvent(newEvent);
    }
    
    void MainApplication::mouseUp(int x, int y, int mouseButton)
    {
        Event newEvent("MOUSE_UP");
        newEvent.setValue("MOUSE_X", x);
        newEvent.setValue("MOUSE_Y", y);
        newEvent.setValue("MOUSE_BUTTON", mouseButton);
        postEvent(newEvent);
    }

    void MainApplication::mouseDrag( int x, int y, int mouseButton )
    {
        //drag not supported by engine
        (x);
        (y);
        (mouseButton);
    }

    void MainApplication::keyDown(int keyCode, int nativeCode, int kMod)
    {
        Event newEvent("KEY_DOWN");
        newEvent.setValue("KEY_CODE", keyCode);
        newEvent.setValue("SCAN_CODE", nativeCode);
        newEvent.setValue("KEY_MODIFIERS", kMod);
        postEvent(newEvent);
    }

    void MainApplication::keyUp(int keyCode, int nativeCode, int kMod)
    {
        Event newEvent("KEY_UP");
        newEvent.setValue("KEY_CODE", keyCode);
        newEvent.setValue("SCAN_CODE", nativeCode);
        newEvent.setValue("KEY_MODIFIERS", kMod);
        postEvent(newEvent);
    }

    void MainApplication::mouseWheel(int delta, int buttons, int kMod)
    {
        Event newEvent("MOUSE_WHEEL");
        newEvent.setValue("MOUSE_WHEEL_DELTA", delta);
        newEvent.setValue("MOUSE_BUTTONS", buttons);
        newEvent.setValue("KEY_MODIFIERS", kMod);
        postEvent(newEvent);
    }

    void MainApplication::mouseMove(int x, int y, int mouseButtons)
    {
        Event newEvent("MOUSE_MOVE");
        newEvent.setValue("MOUSE_BUTTONS", mouseButtons);
        newEvent.setValue("MOUSE_X", x);
        newEvent.setValue("MOUSE_Y", y);
        postEvent(newEvent);
    }

    void MainApplication::mouseDoubleClicked(int x, int y, int mouseButton, int mods)
    {
        Event newEvent("MOUSE_DOUBLE_CLICKED");
        newEvent.setValue("MOUSE_BUTTON", mouseButton);
        newEvent.setValue("MOUSE_X", x);
        newEvent.setValue("MOUSE_Y", y);
        newEvent.setValue("KEY_MODIFIERS", mods);
        postEvent(newEvent);
    }

    void MainApplication::mouseClick(int x, int y, int mouseButton)
    {
        Event newEvent( "MOUSE_CLICKED" );
        newEvent.setValue( "MOUSE_BUTTON", mouseButton);
        newEvent.setValue( "MOUSE_X", x);
        newEvent.setValue( "MOUSE_Y", y);
        postEvent(newEvent);
    }    

 

    void MainApplication::requestContextMenu(int x, int y, int w, int h)
    {
        Event newEvent("CONTEXT_MENU_REQUEST");       
        newEvent.setValue("MOUSE_X", x);
        newEvent.setValue("MOUSE_Y", y);
        newEvent.setValue("WIDTH",   w);
        newEvent.setValue("HEIGHT",  h);
        postEvent(newEvent);
    }

    void MainApplication::setContextMenuData(int x, int y, QString jsonData)
    {
        QQuickItem* rootObject = getRootObject();
        const char* funcName = "setMainViewContextMenuData";

        QMetaObject::invokeMethod(rootObject, funcName,
            Q_ARG(QVariant, x),
            Q_ARG(QVariant, y),
            Q_ARG(QVariant, jsonData));
    }

    
    bool MainApplication::createMenuItemsAndCallbacks()
    {
        using namespace std::placeholders;        
        
        auto RegisterCallBack = [this](const std::string& name, MenuCallBack cb) {
            if (m_callbacks.find(name) != std::end(m_callbacks)) {
                getContext()->getSystem<Logger>()->addLogMessage("Duplicate Callback: " + name, LOG_LEVEL_WARNING);
                return false;
            }
            m_callbacks[name] = cb;
            return true;
        };

        auto AddMenuEntry = [this](const MenuData& menu) -> bool
        {
            auto rootObject      = getRootObject();
            const char* funcName = "addMenuEntry";
            const auto menuTitle = QString(menu.m_menuName.c_str());
            const auto menuData  = QString(QmlContextMenuResolver::CreateJsonFromMenuEntries(menu.m_itemMenus).dump().c_str() );
            return QMetaObject::invokeMethod(rootObject, funcName,
                Q_ARG(QVariant, menuTitle),
                Q_ARG(QVariant, menuData));
        };
        
        bool succeed = true;  
        succeed &= AddMenuEntry( CreateFileMenuData( this, m_callbacks ) );
        succeed &= AddMenuEntry( CreateEditMenuData( this, m_callbacks ) );
        succeed &= AddMenuEntry( CreateViewMenuData( this, m_callbacks ) );
        succeed &= AddMenuEntry( CreateSelectionMenu( this, m_callbacks ) );
        succeed &= AddMenuEntry( CreateToolsMenuData( this, m_callbacks ) );

        /*
            Create Misc. callbacks, See Tools.h & qmlMenuItemResolver for additional callbacks
        */        
        succeed &= RegisterCallBack("actionSelectObject", std::bind<bool>( &ApplicationInteraction::selectObject, this, _1 ) );
        succeed &= RegisterCallBack("actionZoomToObject", std::bind<bool>( &ApplicationInteraction::zoomToObject, this, _1));
        succeed &= RegisterCallBack("actionCloneObject",  std::bind<bool>( &ApplicationInteraction::cloneObject, this, _1));
        succeed &= RegisterCallBack("actionDeleteObject", std::bind<bool>(&ApplicationInteraction::removeObject, this, _1));
        succeed &= RegisterCallBack("actionMoveUp", std::bind<bool>(&ApplicationInteraction::cloneObject, this, _1));
        succeed &= RegisterCallBack("actionMoveDown", std::bind<bool>(&ApplicationInteraction::removeObject, this, _1));
        succeed &= RegisterCallBack("actionCreateResource", std::bind<bool>(&ApplicationInteraction::createScratchResource, this, _1));
        succeed &= RegisterCallBack("actionCreateObject", std::bind<bool>(&ApplicationInteraction::createObject, this, _1));
        succeed &= RegisterCallBack("actionActivateTool",   std::bind<bool>(&ApplicationInteraction::activateTool, this, _1));
        succeed &= RegisterCallBack("actionShowContextMenu", std::bind<bool>(&ApplicationInteraction::requestContextMenuData, this, _1));
        
        return succeed;
    }

    void MainApplication::selectObject(EngineObjectProxy eop)
    {
        m_propertyModel->clear();
        QmlPropertyVector result;
       

        //auto result = QmlPropertyResolver::ResolveQmlProperties(*eop.getObject());
        m_propertyModel->setProperties(result);        
    }


    void MainApplication::updateActiveTool(EngineObjectProxy eop)
    {
        auto toolPtr = dynamic_cast<ToolBase*>(eop.getObject());
        assert(toolPtr);
        setActiveTool(eop);
    }


    void MainApplication::setActiveTool(EngineObjectProxy eop)
    {
        auto toolPtr = dynamic_cast<ToolBase*>(eop.getObject());
        assert(toolPtr);
        selectObject(eop);     
        setToolInfo( toolPtr->getToolName() );
    }

    void MainApplication::closeCurrentTool()
    {
        m_propertyModel->clear();
        setToolInfo("");
    }

    void MainApplication::processResourceDialogReturnCode(int returnCode)
    {
        if (QMessageBox::Ok == returnCode)
        {
            //add resource to resource manager
        }
        else if (QMessageBox::Cancel == returnCode)
        {
            m_scratchResource = nullptr;
        }
        else
        {
            assert( false && "Invalid Return Code" );
        }
    }

    

    

    void MainApplication::addToDictionary(std::string name)
    {
        auto* console = getRootObject()->findChild<QObject*>("userConsole");
        QMetaObject::invokeMethod( console, "registerConsoleVar", Q_ARG( QVariant, QString( name.c_str() ) ) );
    }

    void MainApplication::removeFromDictionary(std::string name)
    {
        auto* console = getRootObject()->findChild<QObject*>("userConsole");
        QMetaObject::invokeMethod( console, "unRegisterConsoleVar", Q_ARG( QVariant, QString( name.c_str() ) ) );
    }


    void MainApplication::onToolRegistered(Engine::Event& evt)
    {
        const auto toolName = evt.getValue<std::string>("TOOL_CLASSNAME");
        const auto toolPtr = getContext()->getSystem<ToolSystem>()->getTool(toolName);
        //fetch all menu entries
        MenuEntryVector entries;
        for (int i = 0; i < toolPtr->getNumTools(); ++i) {
            const auto me = toolPtr->getMenuItemInfo(i);
            entries.push_back(me);         
        }
        //Add menu entries to qml-engine
        QQuickItem* rootObject = getRootObject();
        const char* funcName = "addToolMenuEntry";
        const auto  jsonStr  = QmlContextMenuResolver::CreateJsonFromMenuEntries(entries).dump();
        QMetaObject::invokeMethod(rootObject, funcName,
            Q_ARG(QVariant, ""), Q_ARG(QVariant, jsonStr.c_str()));     
    }


    void MainApplication::setToolInfo(const std::string& info)
    {
        QMetaObject::invokeMethod(getRootObject(),
            "setToolInfo",
            Q_ARG(QVariant, info.c_str() )
        );
    }

    void MainApplication::setSelectionInfo(const std::string& info)
    {
        QMetaObject::invokeMethod( getRootObject(),
            "setSelModeInfo",
            Q_ARG( QVariant, info.c_str() )
        );
    }

    void MainApplication::onToolActivated(Event& evt)
    {
        const auto toolName = evt.getValue<std::string>("ACTIVE_TOOL");
        const auto toolPtr = getContext()->getSystem<ToolSystem>()->getActiveTool();

        EngineObjectProxy eop( toolPtr.get() );     
        emit toolActivated(eop);        
    }


    void MainApplication::onToolClosed( Event&evt )
    {
        (evt);
        emit toolClosed(); 

    }

    void MainApplication::onFlowNodeDescriptionParsed(Engine::Event&evt)
    {
        const auto jsonStr = evt.getValue<std::string>("JSON_DESCRIPTION");
        emit flowNodeDescriptionParsed(QString::fromStdString(jsonStr));
    }

    void MainApplication::onEventDescriptionParsed(Engine::Event&evt)
    {
        const auto jsonStr = evt.getValue<std::string>("EVENT_DESC_INFO");
        emit eventDescriptionParsed(QString::fromStdString(jsonStr));
    }

    void MainApplication::onGlobalVariableAdded(Event& evt)
    {
        auto name = evt.getValue<std::string>("GLOBAL_VARNAME"); 
        addToDictionary(name);
    }

    void MainApplication::onGlobalVariableRemoved(Event& evt)
    {
        auto name = evt.getValue<std::string>("GLOBAL_VARNAME");
        removeFromDictionary(name);
    }    

    void MainApplication::onObjectSelectionChanged( Engine::Event& evt )
    {
        auto objCount = evt.getValue<int>("SELECTION_COUNT");        
        if ( !objCount)
        {
            //disable selection tools
        }
        else 
        {
            auto result = evt.getValue<Scene::ObjectSelectionVector>("SELECTION");
            if ( 1 == objCount ) //single object
            {
                auto objectPtr = getContext()->getEntity( result[0].m_objectId );
                if( objectPtr )
                    m_sceneModel->selectObject( objectPtr );

            }
            else  //multiple selections
            {

            }
        }
    }

    void MainApplication::onResourceAdded(Engine::Event& evt)
    {
        const auto nodeId = evt.getValue<std::uint32_t>("RESOURCE_ID");
        emit resourceAdded(nodeId);
    }

    void MainApplication::onResourceRemoved(Engine::Event& evt)
    {
        const auto nodeId = evt.getValue<std::uint32_t>("RESOURCE_ID");
        emit resourceRemoved(nodeId);
    }

    void MainApplication::onContextMenuResponse(Engine::Event& evt)
    {
        auto xPos    = evt.getValue<int>("MOUSE_X");
        auto yPos    = evt.getValue<int>("MOUSE_Y");
        auto jsonStr = evt.getValue<std::string>("CONTEXT_MENU_STRING");
       
       
        emit contextMenuResponse(xPos, yPos, QString::fromStdString( jsonStr) );
    }

    void MainApplication::onTransformChanging(Engine::Event& evt)
    {
        (evt);
        //  qDebug() << "Transform Changing";
    }

    void MainApplication::onActiveToolUpdated(Engine::Event& evt)
    {
        const auto toolName = evt.getValue<std::string>("ACTIVE_TOOL");
        const auto toolPtr = getContext()->getSystem<ToolSystem>()->getActiveTool();
        assert( toolPtr->GetTypeName() == toolName );
        EngineObjectProxy eop(toolPtr.get());
        emit toolUpdated(eop);
    }

    void MainApplication::onTransformChanged(Engine::Event& evt)
    {
        (evt);
    }

    void MainApplication::onSceneLoaded(Engine::Event& evt)
    {
        (evt);
        emit sceneLoaded();
    }

    void MainApplication::onNodeAdded( Engine::Event& evt )
    {
        const auto entityId = evt.getValue<std::uint32_t>("NODE_ID");  
        const auto parentId = evt.getValue<std::uint32_t>("PARENT_ID");
        emit entityAdded( parentId, entityId );
    }

    void MainApplication::onComponentAdded(Engine::Event& evt)
    {
        const auto entityId = evt.getValue<std::uint32_t>("NODE_ID");
        const auto compId = evt.getValue<std::uint32_t>("COMPONENT_ID");       
        emit componentAdded( entityId, compId );
    }

    void MainApplication::onNodeRemoved(Engine::Event& evt)
    {
        const auto nodeId = evt.getValue<std::uint32_t>("NODE_ID");
        emit entityRemoved( nodeId );     
    }

    void MainApplication::onComponentRemoved(Engine::Event& evt)
    {
        const auto compId   = evt.getValue<std::uint32_t>("COMPONENT_ID"); 
        emit componentRemoved( compId );
    }

}

