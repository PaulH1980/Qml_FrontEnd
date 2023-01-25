#pragma once
#include <exception>
#include <string>

namespace Application
{
    class ApplicationException : public std::exception
    {
    public:

        ApplicationException(const std::string& what)
            : m_what(what)
        {

        }
        const char* what() const override
        {
            return m_what.data();
        }

    private:
        std::string m_what;
    };
}