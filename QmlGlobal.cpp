#include "AppIncludes.h"
#include "QmlGlobal.hpp"


namespace Application
{

    QmlGlobal::QmlGlobal(QObject* parent)
        : QObject(parent)
    {
        {
            JSonObject jsonObj;
            jsonObj["EventTypeInfo"] = EventTypeTypeInfoVector;

            FileSystem::WriteText("d://EventTypes.data", jsonObj.dump(1));
            m_engineEventTypes = QJsonDocument::fromJson(QString::fromStdString(jsonObj.dump()).toUtf8()).object();
        }
        //supported vertex attributes formats
        {
            JSonObject jsonObj;
            jsonObj["SupportedFormats"] = GetSupportedVertexAttributeFormats();            
            jsonObj["ShaderTypes"]      = GetSupportedShaderFormats();
            m_vertexFormats = QJsonDocument::fromJson(QString::fromStdString(jsonObj.dump()).toUtf8()).object();
        }
        //supported uniforms
        {
            JSonObject jsonObj;
            jsonObj["SupportedFormats"] = GetSupportedUniformFormats();
            m_uniformFormats = QJsonDocument::fromJson(QString::fromStdString(jsonObj.dump()).toUtf8()).object();
        }
        {
            JSonObject  jsonObj;
            jsonObj["RegisteredEvents"] = Engine::DefaultEvents::EventDescriptors;
            FileSystem::WriteText("D://RegisteredEvents.data", jsonObj.dump(1));
        }
    }

}

