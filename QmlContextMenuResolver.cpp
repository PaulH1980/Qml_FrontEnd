#include "QmlContextMenuResolver.h"
#include "AppIncludes.h"


namespace Application
{
   
    static MenuEntry CreateMenuEntry(const std::string& name, const std::string& uuid, const std::string& objectType)
    {
        MenuEntry me;
        me.m_itemName = name;
        me.m_uuid = uuid;

        JSonObject cbArg;
        cbArg["ObjectType"]         = objectType;
        me.m_callbackArgsAsJson     = cbArg;

        return me;
    }


    static MenuEntry CreateMenuEntry(const std::string& name, const std::string& uuid, Engine::RootObject* curObject)
    {
        MenuEntry me;
        me.m_itemName = name;
        me.m_uuid = uuid;
        if (curObject) {
            JSonObject cbArg;
            cbArg["ObjectId"] = curObject->getObjectId();
            me.m_callbackArgsAsJson = cbArg;
        }
        return me;
    }

    static MenuEntry CreateSeparator()
    {
        MenuEntry me;
        me.m_isSeparator = true;
        return me;
    }

    static MenuEntry CreateSubMenuEntry(const std::string& entryName, const IO::JSonObject& subMenuData, Engine::RootObject* curObject)
    {
        MenuEntry me;
        me.m_itemName       = entryName;
        me.m_subMenuAsJson = subMenuData;
        if (curObject) {
            JSonObject cbArg;
            cbArg["ObjectId"] = curObject->getObjectId();
            me.m_callbackArgsAsJson = cbArg;
        }
        return me;
    }

    IO::JSonObject QmlContextMenuResolver::CreateJsonFromMenuEntries(const std::vector<IO::MenuEntry>& entries)
    {
        IO::JSonObject jsonObj;
        jsonObj["MenuData"] = entries;
        return jsonObj;
    }

    IO::MenuEntry QmlContextMenuResolver::CreateSeparator()
    {
        MenuEntry me;
        me.m_isSeparator = true;
        return me;
    }

  //  QString QmlContextMenuResolver::NodeContextMenuData(
  //      EngineContext* context, RootObject* curObject )
  //  {
  //      std::vector<MenuEntry> entries = {
  //          CreateMenuEntry( "Select",              "actionSelectObject",       curObject ),
  //          CreateSeparator(),
  //          CreateMenuEntry( "Inspect",             "actionZoomSelected",       curObject ),
  //          CreateMenuEntry( "Clone",               "actionCloneObject",        curObject ),
  //          CreateSubMenuEntry("Attach",
  //              CreateClassSubMenuData( context->getClassNameMap(), "actionCreateObject", curObject ).toStdString(), curObject),
  //          CreateSeparator(),          
  //          CreateMenuEntry( "Remove",              "actionDeleteObject" ,      curObject )
  //      };  
  //      return QString::fromStdString( CreateJsonFromMenuEntries( entries ).dump() );
  //   }

  //  QString QmlContextMenuResolver::ComponentContextMenuData( 
  //      EngineContext* context, RootObject* curObject)
  //  {
  //      std::vector<MenuEntry> entries = {
  //        CreateMenuEntry("Select",         "actionSelectObject",     curObject),
  //        CreateSeparator(),
  //        CreateMenuEntry("Move Up"  ,      "actionMoveUp",           curObject),
  //        CreateMenuEntry("Move Down",      "actionMoveDown",         curObject),
  //        CreateSeparator(),
  //        CreateMenuEntry("Remove",         "actionDeleteObject",     curObject)
  //      };
  //      return QString::fromStdString( CreateJsonFromMenuEntries( entries ).dump() );
  //  }

  //  QString QmlContextMenuResolver::ResourceContextMenuData(
  //      EngineContext* context, RootObject* curObject)
  //  {
  //      const auto& resourceManager = context->getSystem<ResourceManager>();
  //      std::vector<MenuEntry> entries = {
  //        CreateMenuEntry("Select",   "actionSelectObject",    curObject),
  //        CreateMenuEntry("Clone",    "actionCloneObject",     curObject),
  //        CreateSeparator(),
  //        CreateMenuEntry("Remove",   "actionDeleteObject",    curObject)
  //      };
  //      return QString::fromStdString(CreateJsonFromMenuEntries(entries).dump());
  //  }


  //  QString QmlContextMenuResolver::CreateClassSubMenuData(
  //      const Common::ClassNameMap& classMap, const std::string& uuid, RootObject* curObject )
  //  {
  //      //first group objects by base class
  //      std::map<std::string, StringVector > objectsMap;
  //     
  //      for (const auto& iter : classMap) {
  //          const auto& ci = iter.second;
  //          objectsMap[ci.m_baseName].push_back(ci.m_className);
  //      }

  //      //now create separate menu per base class
  //      std::vector<MenuEntry> menuEntriesBaseClass;        
  //      for (const auto& iter : objectsMap)
  //      {
  //          std::vector<MenuEntry> menuEntriesConcreteClass;
  //          const auto& baseName = iter.first;
  //          for (const auto& objName : iter.second) {
  //              auto me = CreateMenuEntry( objName, uuid, curObject);              
  //              JSonObject cbArg;
  //              cbArg["ObjectType"] = objName;
  //              if (curObject) 
  //                  cbArg["ObjectId"] = curObject->getObjectId();                   
  //              me.m_callBackArguments = cbArg.dump();
  //              menuEntriesConcreteClass.push_back(me);
  //          }
  //          //create sub-menu
  //          auto me = CreateSubMenuEntry(baseName, CreateJsonFromMenuEntries(menuEntriesConcreteClass).dump(), curObject );
  //          menuEntriesBaseClass.push_back(me);
  //      }

  //      return QString::fromStdString(CreateJsonFromMenuEntries(menuEntriesBaseClass).dump());
  //  }

  //  QString QmlContextMenuResolver::ResourceRootContextMenuData(EngineContext* context)
  //  {
  //      const auto& resourceManager = context->getSystem<ResourceManager>();
  //      const auto& classMap = resourceManager->getClassNameMap();
  //      std::vector<MenuEntry> entries;
  //      auto result = CreateSubMenuEntry("Create", 
  //          CreateClassSubMenuData( classMap, "actionCreateResource", nullptr ).toStdString(), nullptr );
  //      entries.push_back(result);       
  //     
  //      return QString::fromStdString(CreateJsonFromMenuEntries(entries).dump());
  //  }


  //  QString QmlContextMenuResolver::MainViewContextMenuData(EngineContext* context)
  //  {
  //      const auto& nodeClassMap = context->getClassInfoMap();
  //      std::vector<MenuEntry> entries;
  //      for (const auto&[key, value] : nodeClassMap) {
  //    
  //          MenuEntry me;
  //          me.m_itemName = value.m_className;
  //          me.m_uuid     = "actionCreateObject";
  //          //arguments for callback
  //          JSonObject cbArg;
  //          cbArg["ObjectType"] = value.m_className; 
  //          if ( INVALID_NODE_ID != context->getRootNodeId() )               
  //              cbArg["ObjectId"]   = context->getRootNodeId();   
  //          me.m_callBackArguments = cbArg.dump();
  //          entries.push_back(me);
  //      }

  //      return QString::fromStdString( CreateJsonFromMenuEntries( entries ).dump() );
  //  }

  ////#todo
  //  QString QmlContextMenuResolver::SceneNodeSubMenuData(EngineContext* context)
  //  {
  //      QString result;
  //      JSonObject json;
  //      return result;
  //  }

  //  QString QmlContextMenuResolver::ToolsSubMenuData(EngineContext* context, RootObject* curObject)
  //  {
  //      QString result;
  //      JSonObject json;
  //      return result;
  //  }

  //  QString QmlContextMenuResolver::PrimitvesSubMenuData(EngineContext* context)
  //  {
  //      QString result;
  //      JSonObject json;
  //      return result;
  //  }

  //  QString QmlContextMenuResolver::ResourceSubMenuData( Engine::EngineContext* context, const std::string& objType )
  //  {
  //      std::vector<MenuEntry> entries = {
  //        CreateMenuEntry("Create",         "actionCreateResource",     objType)
  //      };
  //      return QString::fromStdString(CreateJsonFromMenuEntries(entries).dump());
  //  }

}


