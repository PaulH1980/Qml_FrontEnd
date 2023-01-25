#include "AppIncludes.h"
#include "MainApplication.hpp"
#include "QmlImageProvider.hpp"
#include "MainFrame.hpp"

static const std::string QTVersion = "qt512"; //for qml import directory

namespace Application
{
    MainFrame::MainFrame(QWindow* parent /*= nullptr*/) 
        : QQuickView( parent )        
    {

    }

    MainFrame::~MainFrame()
    {

    }

    bool MainFrame::initialize( const QSurfaceFormat& format )
    {
        setFormat(format);
        setClearBeforeRendering(!false);
        setPersistentOpenGLContext(true);
        setResizeMode(SizeRootObjectToView);
        registerConnections();        

        //init application before creating qml windows
        m_application = std::make_unique<MainApplication>(this);
        
        auto qmlMain  =  IO::FileSystemFolders::GetQMLPath() + std::string( "main.qml" );
        auto qmlImport = IO::FileSystemFolders::GetQMLPath() + QTVersion;    

        //set qml imports paths & main qml file
        engine()->addImportPath( qmlImport.c_str() );
        engine()->addImageProvider( "QmlImageProvider", new QmlImageProvider );
        setSource( QUrl::fromLocalFile( qmlMain.c_str() ) );     

        //start refresh timer
        auto *timer = new QTimer(this);
        connect( timer, &QTimer::timeout, this, &MainFrame::update );
        timer->start(16); //~60 hZ
        return true;
    }


    MainApplication& MainFrame::getApplication() const
    {
        return *m_application.get();
    }

    void MainFrame::insertFboItem(QQuickFramebufferObject*item)
    {
        std::lock_guard lock(m_modifyFboItemsLock);
        m_activeItems.insert(item);
    }

    bool MainFrame::removeFboItem(QQuickFramebufferObject*item)
    {
        std::lock_guard lock(m_modifyFboItemsLock);
        m_activeItems.erase(item);
        return true;
    }

    void MainFrame::mousePressEvent(QMouseEvent *event)
    {
        QQuickView::mousePressEvent(event);
    }

    void MainFrame::mouseMoveEvent(QMouseEvent *event)
    {
        QQuickView::mouseMoveEvent(event);
    }

    void MainFrame::mouseReleaseEvent(QMouseEvent *event)
    {
        QQuickView::mouseReleaseEvent(event);
    }

    void MainFrame::resizeEvent(QResizeEvent *event)
    {
       
        QQuickView::resizeEvent(event);
    }

    void MainFrame::update()
    {
        {
            /* std::lock_guard lock(m_modifyFboItemsLock);
             for (const auto& item : m_activeItems)
                 item->update();*/
        }
        
        QQuickView::update();
       
    }

    void MainFrame::sceneGraphInitialized()
    {
        if (m_application) 
        {
            static bool initialized = false;
            if (!initialized) {
                initialized = m_application->initialize();
            }
        }
    }

    void MainFrame::beforeSynchronizing()
    {
        if (m_application) {
            m_application->simulationStep(); //do all non-draw work
        }
        resetOpenGLState();
    }

    void MainFrame::beforeRendering()
    {
       /* if (m_application)
            m_application->simulationStep();*/
        resetOpenGLState();
    }

    void MainFrame::sceneGraphInvalidated()
    {
        resetOpenGLState();
    }

    void MainFrame::afterRendering()
    {
        resetOpenGLState();
    }

    void MainFrame::frameSwapped()
    {

    }

    void MainFrame::closing()
    {
      
    }

    void MainFrame::afterAnimating()
    {

    }

    void MainFrame::registerConnections()
    {
        connect(this, &QQuickWindow::sceneGraphInitialized, this, &MainFrame::sceneGraphInitialized, Qt::DirectConnection);
        connect(this, &QQuickWindow::beforeSynchronizing, this, &MainFrame::beforeSynchronizing, Qt::DirectConnection);
        connect(this, &QQuickWindow::beforeRendering, this, &MainFrame::beforeRendering, Qt::DirectConnection);
        connect(this, &QQuickWindow::sceneGraphInvalidated, this, &MainFrame::sceneGraphInvalidated, Qt::DirectConnection);
        connect(this, &QQuickWindow::afterRendering, this, &MainFrame::afterRendering, Qt::DirectConnection);
        connect(this, &QQuickWindow::frameSwapped, this, &MainFrame::frameSwapped, Qt::DirectConnection);
        connect(this, &QQuickWindow::afterAnimating, this, &MainFrame::afterAnimating, Qt::DirectConnection);
    }

}


