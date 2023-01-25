#pragma once
#include <Resource/ResourceBasePtr.h>
#include <Engine/EngineContextPtr.h>
#include <Engine/ContextProvider.h>
#include <Engine/EventSubscriber.h>
#include <Scene/WorldEntityFwd.h>
#include <Scene/SceneGraphBasePtr.h>
#include <Components/SkyBoxComponentFwd.h>
#include <Components/CameraComponentFwd.h>
#include "IFileDialogs.h"
#include "ClientEntityFwd.h"

namespace Application
{
    /*
        @brief: Main Application Interaction, 
    */
    class ApplicationInteraction : 
        public Engine::EventSubscriber, 
        public Engine::ContextProvider,
        public IFileDialogs
    {
    public:

        ApplicationInteraction();
        virtual ~ApplicationInteraction() = default;

       
        Engine::EngineContext*  getContext() const override;
      
        bool                    registerConsoleVars();
        bool                    registerSubSystems();  
        bool                    registerDefaultObjects();
        bool                    initializeSubSystems();
        
        bool                    initializeDefaultObjects();
        bool                    initializeDefaultTools();
        bool                    initializeDefaultScripts();

        /*
            @brief: Process Events
        */
        void                    postEvents();

        /*
            @brief: Run a simulation step
        */
        void                    simulationStep();   

        /*
            @brief: Present results of simulation step
        */
        void                    present();

        /*
            @brief: All action currently supported, this is probably to verbose, and should 
            be refactored/consolidated, & moved to specialized classes when time is available
        */
        bool                    activateTool( const IO::JSonObject& obj );
      

        bool                    removeObject(const IO::JSonObject& obj);
        bool                    createObject(const IO::JSonObject& obj);
        bool                    zoomToObject(const IO::JSonObject& obj);
        bool                    cloneObject(const IO::JSonObject& obj);
        bool                    createScratchResource(const IO::JSonObject& obj);
        bool                    selectObject(const IO::JSonObject& obj);

        bool                    moveUp(const IO::JSonObject& obj);
        bool                    moveDown(const IO::JSonObject& obj);

        bool                    newProject(const IO::JSonObject& obj);
        bool                    openProject(const IO::JSonObject& obj);
        bool                    saveProject(const IO::JSonObject& obj);
        bool                    saveProjectAs(const IO::JSonObject& obj);
        bool                    importPointCloud(const IO::JSonObject& obj);
        bool                    exportPointCloud(const IO::JSonObject& obj);
        bool                    openAndExecuteScriptFile(const IO::JSonObject& obj);

        bool                    undo(const IO::JSonObject& obj);
        bool                    redo(const IO::JSonObject& obj);
        bool                    cut(const IO::JSonObject& obj);
        bool                    copy(const IO::JSonObject& obj);
        bool                    duplicate(const IO::JSonObject& obj);
        bool                    paste(const IO::JSonObject& obj);
        bool                    selectAll(const IO::JSonObject& obj);
        bool                    unselectAll(const IO::JSonObject& obj);
        bool                    deleteSelect(const IO::JSonObject& obj);
        bool                    options(const IO::JSonObject& obj);

        bool                    setDisplayRGB(const IO::JSonObject& obj);
        bool                    setDisplayIntensity(const IO::JSonObject& obj);
        bool                    setDisplayHeight(const IO::JSonObject& obj);
        bool                    setDisplayNormals(const IO::JSonObject& obj);

        bool                    setBackgroundGradient(const IO::JSonObject& obj);
        bool                    setBackgroundSkyBox(const IO::JSonObject& obj);

        bool                    toggleFilterPoints(const IO::JSonObject& obj);
        bool                    toggleFilterLabels(const IO::JSonObject& obj);
        bool                    toggleFilterMeasures(const IO::JSonObject& obj);
        bool                    toggleFilterMeshes(const IO::JSonObject& obj);
        bool                    toggleFilterLines(const IO::JSonObject& obj);
        bool                    toggleFilterOverlay(const IO::JSonObject& obj);

        bool                    setProjModeOrtho(const IO::JSonObject& obj);
        bool                    setProjModePersp(const IO::JSonObject& obj);

        bool                    zoomExtents(const IO::JSonObject& obj);
        bool                    zoomExtentsSelected(const IO::JSonObject& obj);

        bool                    camViewTop(const IO::JSonObject& obj);
        bool                    camViewFront(const IO::JSonObject& obj);
        bool                    camViewLeft(const IO::JSonObject& obj);
        bool                    camViewBottom(const IO::JSonObject& obj);
        bool                    camViewRight(const IO::JSonObject& obj);
        bool                    camViewBack(const IO::JSonObject& obj);

        bool                    addView(const IO::JSonObject& obj);
        bool                    gradientEditor(const IO::JSonObject& obj);

        bool                    closeApplication(const IO::JSonObject& obj);
        bool                    minimizeApplication(const IO::JSonObject& obj);
        bool                    maximizeApplication(const IO::JSonObject& obj);

        bool                    limitBoxToggle(const IO::JSonObject& obj);
        bool                    limitBoxRotate(const IO::JSonObject& obj);
        bool                    limitBoxScale(const IO::JSonObject& obj);
        bool                    limitBoxTranslate(const IO::JSonObject& obj);

        bool                    addLabel(const IO::JSonObject& obj);
        bool                    addMeasurement(const IO::JSonObject& obj);

        bool                    debugSpawnCubes(const IO::JSonObject& obj);
        bool                    debugRemoveCubes(const IO::JSonObject& obj);

        bool                    clearPropGrid(const IO::JSonObject& obj);
        bool                    randomPropGrid(const IO::JSonObject& obj);
        bool                    clearSceneTree(const IO::JSonObject& obj);

        bool                    changeSelectionMode(const IO::JSonObject& obj);
        
        bool                    selectionModeNone(const IO::JSonObject& obj);
        bool                    selectionModeVoxels(const IO::JSonObject& obj);
        bool                    selectionModeVertices(const IO::JSonObject& obj);
        bool                    selectionModeEdges(const IO::JSonObject& obj);
        bool                    selectionModeFaces(const IO::JSonObject& obj);
        bool                    selectionModeObjects(const IO::JSonObject& obj);

        bool                    nullFunction(const IO::JSonObject& obj);

        bool                    groupObjects(const IO::JSonObject& obj);
        bool                    unGroupObjects(const IO::JSonObject& obj);
        bool                    duplicateSelection(const IO::JSonObject& obj);

        /*
            @brief: Return context menu data as a json string
        */
        bool                     requestContextMenuData( const IO::JSonObject& obj );
                     

    protected:
        Engine::EngineContextUniquePtr      m_contextPtr;       
        std::shared_ptr<Scene::WorldEntity> m_rootNode;
        ClientEntity*                       m_clientPtr;
        Scene::SceneGraphPtr                m_sceneGraphPtr;
        Resources::ResourceBasePtr          m_scratchResource;  //resource we're currently working with
        std::string                         m_lastSaveFile;

    private:
       
    };
}