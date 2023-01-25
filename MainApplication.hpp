#pragma once

#include <Properties/PropertyProvider.h>
#include <Engine/RootObjectPtr.h>
#include "EngineObjectProxy.hpp"
#include "ApplicationInteraction.h"
#include "ApplicationBindings.h"
#include "ClientEntityFwd.h"
#include "QtHeaders.h"


namespace Application
{
    class ObjectPropertyModel;
    class QmlTreeViewModel;
    class QmlGlobal;
   
    /*
        @brief: Main Application, serves as a communication layer between QML-Frontend and the 
        Engine Backend.    
    */
    class MainApplication : public QObject, public ApplicationInteraction
    {
       Q_OBJECT
    public:

        MainApplication(QQuickView* parent);
        bool                    initialize();        
        void                    shutDown();   

        std::string             openFileDialog(const FileDialogOptions&) override;

        std::string             saveFileDialog(const FileDialogOptions&) override;
        
       
    public slots:

        //input events from Qt  front-end
        void				    mouseDown(int x, int y, int mouseButton);
        void				    mouseUp(int x, int y, int mouseButton);
        void				    mouseDrag(int x, int y, int mouseButton);
        void				    keyDown(int keyCode, int nativeCode, int kMod);
        void				    keyUp(int keyCode, int nativeCode, int kMod);
        void				    mouseWheel(int delta, int buttons, int kMod);
        void				    mouseMove(int x, int y, int mouseButtons);
        void				    mouseDoubleClicked(int x, int y, int mouseButton, int mods);
        void				    mouseClick(int x, int y, int mouseButton);   
        void                    requestContextMenu( int x, int y, int w, int h );
        void                    setContextMenuData(int x, int y, QString jsonData );

        void                    addEventDescription(QString eventDef);
        void                    addFlowNodeDescription( QString flowNodeDef );

        
        /*
            @brief: Selection from TreeView/SceneModel
        */
        void                    selectObject( EngineObjectProxy );     
        /*
            @brief: Tool Activated, show tool options
        */
        void                    setActiveTool(EngineObjectProxy);
        void                    updateActiveTool(EngineObjectProxy);
        void                    closeCurrentTool();
        
                          
        
        /*
            @brief: Handle 'Cancel' or 'Ok' Requests, onCancel set the scratch model to nullptr
            while on 'Ok' add resource to resource manager
        */
        void                    processResourceDialogReturnCode(int val);

        /*
            @brief: Clears and re-popuplate UI, generally 
            happens whenever a complete scene changed( e.g. loaded )
        */
        void                    clearAndRebuildUI();

        /*
            @brief: Resets UI to its default state
        */
        void                    resetUI();     
        
        /*
            From QML --> C++ backend, NOTE we're using a string as UUID right now            
        */
        void                    onQmlMenuItemClicked( QString jsonData );

        /*
            @brief: Resize application
        */
        void                    resize( int w, int h );   

        /*
            @brief: expose engine built in types to qml
        */
        void                    registerEngineTypesToQml();


    signals:
        void                    sceneLoaded();  
        void                    sceneCleared(); 
      
        /*
            @brief: Arguments are ParentId, ChildId 
        */
        void                    entityAdded( std::uint32_t, std::uint32_t );
        void                    entityRemoved(std::uint32_t);

        void                    resourceRemoved(std::uint32_t);
        void                    resourceAdded(std::uint32_t);

        void                    componentAdded(std::uint32_t, std::uint32_t);
        void                    componentRemoved(std::uint32_t);       

        void                    toolActivated(EngineObjectProxy);
        void                    toolUpdated(EngineObjectProxy);
        void                    toolClosed();

        void                    contextMenuResponse(int, int, QString );
        void                    flowNodeDescriptionParsed(QString);
        void                    eventDescriptionParsed(QString);
     


    private:
        bool                    registerLogRecipients();
        bool                    registerConnections();
        bool                    registerEventCallbacks();
      

        bool                    createMenuItemsAndCallbacks();
       
        void                    setToolInfo(const std::string& info);
        void                    setSelectionInfo( const std::string& info);

        void                    addToDictionary(std::string name);
        void                    removeFromDictionary(std::string name);
#

        /*
           @brief: Tool Events
        */
        void                    onToolRegistered(Engine::Event& evt); //new tool registered
        void                    onToolActivated(Engine::Event& evt);
        void                    onToolClosed(Engine::Event&evt);


        /*
            @brief: New shader/event/class description parsed
        */
        void                    onFlowNodeDescriptionParsed(Engine::Event&evt);
        void                    onEventDescriptionParsed(Engine::Event&evt);


        /*
           @brief: Global Variables changed
        */
        void                    onGlobalVariableAdded(Engine::Event& evt);
        void                    onGlobalVariableRemoved(Engine::Event& evt);
        
        /*
            @brief: Object modification
        */
        void                    onObjectSelectionChanged(Engine::Event& evt);
        void                    onObjectCreated(Engine::Event& evt);
        void                    onObjectRemoved(Engine::Event& evt);
        void                    onContextMenuResponse(Engine::Event& evt);

        /*
            @brief: Transform changing, notify UI
        */
        void                    onTransformChanging(Engine::Event& evt);
        void                    onActiveToolUpdated(Engine::Event& evt);

        /*
            @brief: Transform changed, create undo point
        */
        void                    onTransformChanged(Engine::Event& evt);


        /*
            @brief: Scene has been loaded
        */
        void                    onSceneLoaded(Engine::Event& evt);


        /*
            @brief: Object was modified
        */
        void                    onObjectModified(Engine::Event& evt);


        /*
            @brief: Component or Node added to scene
        */
        void                    onNodeAdded(Engine::Event& evt);
        void                    onComponentAdded(Engine::Event& evt);

        /*
            @brief: Component or Node removed from scene
        */
        void                    onNodeRemoved(Engine::Event& evt);
        void                    onComponentRemoved(Engine::Event& evt);

        /*
            @brief: Resource added or removed
        */
        void                    onResourceAdded(Engine::Event& evt);
        void                    onResourceRemoved(Engine::Event& evt);

        

        QQuickView*             getMainWindow() const;
        QQmlContext*            getRootContext() const;
        QQuickItem*             getRootObject() const;
        
        QQuickView*             m_parent;
        MenuCallBackMap         m_callbacks;
        ObjectPropertyModel*    m_propertyModel; //Communicate Object properties from backend to QML layer
        ObjectPropertyModel*    m_resourceModel; //#todo remove duplicate code!, this is only used for creating a dialog 
                                                 //when creating a new resource
        QmlTreeViewModel*       m_sceneModel;    //contains a simplified view of the scene
        QmlGlobal*              m_appglobals;
       
    };
}