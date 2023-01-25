#pragma once

#include <IO/MenuEntry.h>
#include "ApplicationBindings.h"
namespace Application
{
    class ApplicationInteraction;

    struct MenuData
    {
        std::string             m_menuName;
        IO::MenuEntryVector     m_itemMenus;
    };


    MenuData CreateFileMenuData( ApplicationInteraction* instance, MenuCallBackMap& callbacks);
    MenuData CreateEditMenuData( ApplicationInteraction* instance, MenuCallBackMap& callbacks);
    MenuData CreateViewMenuData( ApplicationInteraction* instance, MenuCallBackMap& callbacks);
    MenuData CreateModifyMenuData( ApplicationInteraction* instance, MenuCallBackMap& callbacks);
    MenuData CreateSelectionMenu( ApplicationInteraction* instance, MenuCallBackMap& callbacks);
    MenuData CreateWindowMenuData(ApplicationInteraction* instance, MenuCallBackMap& callbacks);
    MenuData CreateToolsMenuData( ApplicationInteraction* instance, MenuCallBackMap& callbacks);
}

