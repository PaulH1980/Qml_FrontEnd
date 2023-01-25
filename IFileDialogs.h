#pragma once

#include <vector>
#include <string>

namespace Application
{
    struct FileDialogOptions {
        std::string m_title;
        std::string m_folder;
        std::string m_filter;
    };    
    
    class IFileDialogs
    {
    public: 
       
        /*
            @brief: Create a new open file dialog
        */
        virtual std::string   openFileDialog( const FileDialogOptions& ) = 0;
        
        /*
            @brief: Create a new open file dialog
        */
        virtual std::string   saveFileDialog( const FileDialogOptions& ) = 0;
    };
    
    
   
}
 