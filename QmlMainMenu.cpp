#include "QmlMainMenu.h"
#include "QmlContextMenuResolver.h"
#include "ApplicationInteraction.h"
#include "AppIncludes.h"

using namespace std::placeholders;

namespace Application
{

    MenuData CreateFileMenuData(ApplicationInteraction* appPtr, MenuCallBackMap& callbacks)
    {
        callbacks["actionNew"]      = std::bind<bool>(&ApplicationInteraction::newProject, appPtr, _1 );
        callbacks["actionOpen"]     = std::bind<bool>(&ApplicationInteraction::openProject, appPtr, _1);
        callbacks["actionImport"]   = std::bind<bool>(&ApplicationInteraction::importPointCloud, appPtr, _1);
        callbacks["actionExport"]   = std::bind<bool>(&ApplicationInteraction::exportPointCloud, appPtr, _1);
        callbacks["actionSave"]     = std::bind<bool>(&ApplicationInteraction::saveProject, appPtr, _1);
        callbacks["actionSaveAs"]   = std::bind<bool>(&ApplicationInteraction::saveProjectAs, appPtr, _1);
        callbacks["actionExit"]     = std::bind<bool>(&ApplicationInteraction::closeApplication, appPtr, _1);
        callbacks["actionExecScript"] = std::bind<bool>(&ApplicationInteraction::openAndExecuteScriptFile, appPtr, _1);


        MenuEntryVector fileMenuMev = {
          CreateMenuEntry("&New",      "actionNew"      ).setShortCut("Ctrl+N"),
          CreateMenuEntry("&Open",     "actionOpen"     ).setShortCut("Ctrl+O"),
          CreateSeparator(),
          CreateMenuEntry("&Import",   "actionImport"   ).setShortCut("Ctrl+I"),
          CreateMenuEntry("&Export",   "actionExport"   ).setShortCut("Ctrl+E"),
          CreateSeparator(),
          CreateMenuEntry("&Load Script",  "actionExecScript"),
          CreateSeparator(),
          CreateMenuEntry("&Save",     "actionSave"     ).setShortCut("Ctrl+S"),
          CreateMenuEntry("S&ave As",  "actionSaveAs"   ).setShortCut("Ctrl+A"),
          CreateSeparator(),
          CreateMenuEntry("E&xit",     "actionExit"     ),
        };

        MenuData result;
        result.m_menuName  = "&File";
        result.m_itemMenus = fileMenuMev;
        return result;
    }

    MenuData CreateEditMenuData(ApplicationInteraction* appPtr, MenuCallBackMap& callbacks)
    {
        callbacks["actionCut"] = std::bind<bool>(&ApplicationInteraction::cut, appPtr, _1);
        callbacks["actionCopy"] = std::bind<bool>(&ApplicationInteraction::copy, appPtr, _1);
        callbacks["actionDuplicate"] = std::bind<bool>(&ApplicationInteraction::duplicate, appPtr, _1);
        callbacks["actionPaste"] = std::bind<bool>(&ApplicationInteraction::paste, appPtr, _1);
        callbacks["actionUndo"] = std::bind<bool>(&ApplicationInteraction::undo, appPtr, _1);
        callbacks["actionRedo"] = std::bind<bool>(&ApplicationInteraction::redo, appPtr, _1);

        callbacks["actionSelectAll"] = std::bind<bool>(&ApplicationInteraction::selectAll, appPtr, _1);
        callbacks["actionUnSelectAll"] = std::bind<bool>(&ApplicationInteraction::unselectAll, appPtr, _1);
        callbacks["actionDeleteSelection"] = std::bind<bool>(&ApplicationInteraction::deleteSelect, appPtr, _1);        
        callbacks["actionOption"] = std::bind<bool>(&ApplicationInteraction::options, appPtr, _1);

        MenuEntryVector editMenuMev = {
             CreateMenuEntry("&Cut",      "actionCut"       ).setShortCut( "Ctrl+X"),
             CreateMenuEntry("C&opy",     "actionCopy"      ).setShortCut( "Ctrl+C"),
             CreateMenuEntry("&Paste",    "actionPaste"     ).setShortCut( "Ctrl+V"),
             CreateMenuEntry("&Duplicate","actionDuplicate" ).setShortCut("Ctrl+D"),
             CreateSeparator(),
             CreateMenuEntry("&Undo",     "actionUndo"      ).setShortCut("Ctrl+Z"),
             CreateMenuEntry("&Redo",     "actionRedo"      ).setShortCut("Ctrl+Y"),
             CreateSeparator(),       
             CreateMenuEntry("&Select All",       "actionSelectAll"         ).setShortCut("Ctrl+A"),
             CreateMenuEntry("U&nselect All",     "actionUnSelectAll"       ).setShortCut("Ctrl+U"),
             CreateMenuEntry("D&elete Selection", "actionDeleteSelection"   ).setShortCut("Del"),
             CreateSeparator(),            
             CreateMenuEntry("Op&tions",     "actionOption").setShortCut("Ctrl+Shift+O"),
        };
        MenuData result;
        result.m_menuName = "&Edit";
        result.m_itemMenus = editMenuMev;
        return result;
    }

    /*
        Creates sub menu entries first before creating the main menu
    */
    MenuData CreateViewMenuData(ApplicationInteraction* appPtr, MenuCallBackMap& callbacks)
    {
       
        callbacks["actionViewRgb"]          = std::bind<bool>(&ApplicationInteraction::setDisplayRGB,       appPtr, _1);
        callbacks["actionViewNormals"]      = std::bind<bool>(&ApplicationInteraction::setDisplayNormals,   appPtr, _1);
        callbacks["actionViewReflectance"]  = std::bind<bool>(&ApplicationInteraction::setDisplayIntensity, appPtr, _1);
        callbacks["actionViewHeight"]       = std::bind<bool>(&ApplicationInteraction::setDisplayHeight,    appPtr, _1);       

        
        //create sub menus first        
        MenuEntryVector displaySubMenu = {
               CreateMenuEntry("&Rgb",           "actionViewRgb"            ),
               CreateMenuEntry("&Normals",       "actionViewNormals"        ),
               CreateMenuEntry("R&eflectance",   "actionViewReflectance"    ),              
               CreateMenuEntry("&Height",        "actionViewHeight"         )
        };

        callbacks["actionBackgroundGradient"] = std::bind<bool>(&ApplicationInteraction::setBackgroundGradient, appPtr, _1);
        callbacks["actionBackgroundSkyBox"]   = std::bind<bool>(&ApplicationInteraction::setBackgroundSkyBox, appPtr, _1);
        MenuEntryVector backgroundSubMenu = {
             CreateMenuEntry("&Gradient",       "actionBackgroundGradient"  ),
             CreateMenuEntry("&Sky Box",        "actionBackgroundSkyBox"    ),           
        };

        callbacks["actionFilterVoxels"]   = std::bind<bool>(&ApplicationInteraction::toggleFilterPoints, appPtr, _1);
        callbacks["actionFilterMeshes"]   = std::bind<bool>(&ApplicationInteraction::toggleFilterMeshes, appPtr, _1);
        callbacks["actionFilterLines"]    = std::bind<bool>(&ApplicationInteraction::toggleFilterLines, appPtr, _1);
        callbacks["actionFilterLabels"]   = std::bind<bool>(&ApplicationInteraction::toggleFilterLabels, appPtr, _1);
        callbacks["actionFilterOverlays"] = std::bind<bool>(&ApplicationInteraction::toggleFilterOverlay, appPtr, _1);

        MenuEntryVector filterSubMenu = {
               CreateMenuEntry("&Voxels",        "actionFilterVoxels" ),
               CreateMenuEntry("&Meshes",        "actionFilterMeshes" ),
               CreateMenuEntry("L&ines",         "actionFilterLines" ),
               CreateMenuEntry("&Labels",        "actionFilterLabels" ),       
               CreateMenuEntry("&Overlay",       "actionFilterOverlays" ),             
        };

        callbacks["actionPerspective"] = std::bind<bool>(&ApplicationInteraction::setProjModePersp, appPtr, _1);
        callbacks["actionOrtographic"] = std::bind<bool>(&ApplicationInteraction::setProjModeOrtho, appPtr, _1);
        MenuEntryVector projectionSubMenu = {
              CreateMenuEntry("&Perspective",        "actionPerspective"    ).setShortCut("Shift+P"),
              CreateMenuEntry("&OrthoGraphic",       "actionOrthographic"   ).setShortCut("Shift+O"),
        };


        callbacks["actionZoomExtents"] = std::bind<bool>(&ApplicationInteraction::zoomExtents, appPtr, _1);
        callbacks["actionZoomSelected"] = std::bind<bool>(&ApplicationInteraction::zoomExtentsSelected, appPtr, _1);
        MenuEntryVector zoomSubMenu = {
             CreateMenuEntry("&Extents",        "actionZoomExtents"     ).setShortCut("Shift+Z"),
             CreateMenuEntry("&Selected",       "actionZoomSelected"    ).setShortCut("Shift+S"),
        };
        callbacks["actionOrientationTop"] = std::bind<bool>(&ApplicationInteraction::camViewTop, appPtr, _1);
        callbacks["actionOrientationFront"] = std::bind<bool>(&ApplicationInteraction::camViewFront, appPtr, _1);
        callbacks["actionOrientationLeft"] = std::bind<bool>(&ApplicationInteraction::camViewLeft, appPtr, _1);
        callbacks["actionOrientationBottom"] = std::bind<bool>(&ApplicationInteraction::camViewBottom, appPtr, _1);
        callbacks["actionOrientationBack"] = std::bind<bool>(&ApplicationInteraction::camViewBack, appPtr, _1);
        callbacks["actionOrientationRight"] = std::bind<bool>(&ApplicationInteraction::camViewRight, appPtr, _1);


        MenuEntryVector orientationSubMenu = {
             CreateMenuEntry("&Top", 	"actionOrientationTop"      ).setShortCut("Shift+0"),
             CreateMenuEntry("&Front", 	"actionOrientationFront"    ).setShortCut("Shift+1"),
             CreateMenuEntry("&Left", 	"actionOrientationLeft"     ).setShortCut("Shift+2"),
             CreateMenuEntry("&Bottom", "actionOrientationBottom"   ).setShortCut("Shift+3"),
             CreateMenuEntry("B&ack", 	"actionOrientationBack"     ).setShortCut("Shift+4"),
             CreateMenuEntry("&Right", 	"actionOrientationRight"    ).setShortCut("Shift+5")
        };

        callbacks["actionAddViewState"] = std::bind<bool>(&ApplicationInteraction::addView, appPtr, _1);
        MenuEntryVector viewMenu = 
        {
            CreateSubMenuEntry("&Display",       displaySubMenu      ),
            CreateSubMenuEntry("&Background",    backgroundSubMenu   ),
            CreateSubMenuEntry("&Filter",        filterSubMenu       ),
            CreateSeparator(),
            CreateSubMenuEntry("&Projection",    projectionSubMenu   ),
            CreateSubMenuEntry("&Zoom",          zoomSubMenu         ),
            CreateSubMenuEntry("&Orientation",   orientationSubMenu  ),
            CreateSeparator(),
            CreateMenuEntry("&Add View State", "actionAddViewState" ).setShortCut("Shift+V")
        };
                       
        MenuData result;        
        result.m_menuName = "&View";
        result.m_itemMenus = viewMenu;
        return result;
    }

    MenuData CreateModifyMenuData(ApplicationInteraction* instance, MenuCallBackMap& callbacks)
    {
        MenuData result;
        return result;
    }

    MenuData CreateSelectionMenu(ApplicationInteraction* appPtr , MenuCallBackMap& callbacks)
    {
        
        callbacks["actionSelectionModeNone"] = std::bind<bool>(&ApplicationInteraction::selectionModeNone, appPtr, _1);
        callbacks["actionSelectionModeVoxels"] = std::bind<bool>(&ApplicationInteraction::selectionModeVoxels, appPtr, _1);
        callbacks["actionSelectionModeVertices"] = std::bind<bool>(&ApplicationInteraction::selectionModeVertices, appPtr, _1);
        callbacks["actionSelectionModeEdges"] = std::bind<bool>(&ApplicationInteraction::selectionModeEdges, appPtr, _1);
        callbacks["actionSelectionModeFaces"] = std::bind<bool>(&ApplicationInteraction::selectionModeFaces, appPtr, _1);
        callbacks["actionSelectionModeObjects"] = std::bind<bool>(&ApplicationInteraction::selectionModeObjects, appPtr, _1);

        MenuEntryVector selectionSubMenu = {
            CreateMenuEntry("&None", 	    "actionSelectionModeNone"       , "").setShortCut("Ctrl+0").setGroupName("SelType"),
            CreateMenuEntry("&Objects", 	"actionSelectionModeObjects"    , "").setShortCut("Ctrl+1").setGroupName("SelType"),
            CreateSeparator(),
            CreateMenuEntry("Vo&xels", 	    "actionSelectionModeVoxels"     , "").setShortCut("Ctrl+2").setGroupName("SelType"),
            CreateMenuEntry("&Vertices", 	"actionSelectionModeVertices"   , "").setShortCut("Ctrl+3").setGroupName("SelType"),
            CreateMenuEntry("&Edges", 	    "actionSelectionModeEdges"      , "").setShortCut("Ctrl+4").setGroupName("SelType"),
            CreateMenuEntry("&Faces", 	    "actionSelectionModeFaces"      , "").setShortCut("Ctrl+5").setGroupName("SelType")
        };       


        callbacks["actionGroupObjects"] = std::bind<bool>(&ApplicationInteraction::groupObjects, appPtr, _1);
        callbacks["actionUngroupObjects"] = std::bind<bool>(&ApplicationInteraction::unGroupObjects, appPtr, _1);

        MenuEntryVector groupSubMenu = {
           CreateMenuEntry("&Group", 	    "actionGroupObjects"       , "").setShortCut("Ctrl+G"),
           CreateMenuEntry("&Un-Group", 	"actionUngroupObjects"     , "").setShortCut("Ctrl+H")
        };

        callbacks["actionDuplicate"] = std::bind<bool>(&ApplicationInteraction::duplicateSelection, appPtr, _1);

        MenuEntryVector selectionMenu =
        {
          CreateSubMenuEntry("&Type",    selectionSubMenu),
          CreateSubMenuEntry("&Group",   groupSubMenu ),
          CreateSeparator(),
          CreateMenuEntry("&Duplicate", "actionDuplicate", "" ).setShortCut("Ctrl+D")
        };

        MenuData result;
        result.m_menuName = "&Selection";
        result.m_itemMenus = selectionMenu;
        return result;
    }

    MenuData CreateWindowMenuData(ApplicationInteraction* instance, MenuCallBackMap& callbacks)
    {
        MenuData result;
        return result;
    }

    MenuData CreateToolsMenuData(ApplicationInteraction* appPtr, MenuCallBackMap& callbacks)
    {
        MenuData result;
        result.m_menuName = "&Tools";      
        return result;
    }

}