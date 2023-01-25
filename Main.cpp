

#include "QtHeaders.h"
#include <stack>
#include "AppIncludes.h"
#include "AppQtRoles.hpp"
#include "QmlPropertyResolver.h"
#include "FboRenderer.hpp"
#include "AppRegisterFlowNodes.hpp"
#include "EngineObjectProxy.hpp"
#include "UuidGen.hpp"
#include "MainFrame.hpp"

Q_DECLARE_SMART_POINTER_METATYPE(std::shared_ptr)


using namespace Application;

void registerEnumsToQt()
{
    QtEnums::RegisterQEnums();
    QtEngineEventTypes::Register();
}

void registerBackendProperties()
{
    QmlPropertyResolver::RegisterQmlProperties();
}

void registerTypesToQt()
{
    qRegisterMetaType<std::string>("std::string");
    qRegisterMetaType<Quatf>("Quatf");
    qRegisterMetaType<Vector4ub>("Vector4ub");
    qRegisterMetaType<Vector4f>("Vector4f");
    qRegisterMetaType<Vector3f>("Vector3f");
    qRegisterMetaType<Vector2f>("Vector2f");
    qRegisterMetaType<Vector2i>("Vector2i");
    qRegisterMetaType<BBox2f>("BBox2f");
    qRegisterMetaType<BBox3f>("BBox3f");
    qRegisterMetaType<AxisAnglef>("AxisAnglef");
    qRegisterMetaType<EngineObjectProxy>("EngineObjectProxy");
}

void registerTypesToQml()
{
    qmlRegisterType<SceneRenderItem>("SceneGraphRenderer", 1, 0, "SceneGraphRenderItem");
    qmlRegisterType<FlowRenderItem>("FlowShaderRenderer", 1, 0, "FlowShaderRenderItem");
    qmlRegisterType<UuidGen, 1>( "UuidGen", 1, 0, "UuidGen");
    qmlRegisterType<RegisterFlowNodes>("FlowEventTypes", 1, 0, "FlowEventTypes");
}


inline QSurfaceFormat createSurfaceFormat( int major = 4, int minor = 5 )
{
    QSurfaceFormat format;
    format.setMajorVersion(major);
    format.setMinorVersion(minor);
    format.setProfile(QSurfaceFormat::CompatibilityProfile);
    format.setRenderableType(QSurfaceFormat::OpenGL);
    format.setSwapBehavior(QSurfaceFormat::DoubleBuffer);
    format.setSwapInterval(1);
    format.setDepthBufferSize(24);
    format.setStencilBufferSize(8);
    format.setSamples(0);
    format.setSwapInterval(1);
    return format;
}



int main(int argc, char *argv[])
{
    qputenv( "QML_DISABLE_DISK_CACHE", "1" ); // don't use compiled QML binaries, since its gives us errors.
    qputenv( "QT_QUICK_CONTROLS_MATERIAL_THEME",     "Dark"      );
    qputenv( "QT_QUICK_CONTROLS_MATERIAL_ACCENT",    "Blue"      );
    qputenv( "QT_QUICK_CONTROLS_MATERIAL_PRIMARY",   "#252525"   ); 
    qputenv( "QT_QUICK_CONTROLS_MATERIAL_VARIANT",   "Dense"     );
    
    QApplication app(argc, argv);
    auto curFont = app.font();
    curFont.setPixelSize(22);
    app.setFont(curFont);

    registerEnumsToQt();
    registerTypesToQt();
    registerTypesToQml();
    registerBackendProperties();  

    QQuickStyle::setStyle("Material");
    try {         
        MainFrame mainFrame( nullptr );
        mainFrame.initialize( createSurfaceFormat() );
        mainFrame.setObjectName( "MainWindow" );
        mainFrame.resize(1920, 1280);
        mainFrame.show();
        return app.exec();    //run event loop
    }
    catch ( std::exception& e )
    {
        std::cout << e.what();
        return -1;
    }
    return 0;
}