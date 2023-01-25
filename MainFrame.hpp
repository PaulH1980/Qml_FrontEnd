#pragma once
#include <memory>
#include <unordered_set>

#include <Engine/EventSubscriber.h>

#include "ApplicationInteractionPtr.h"
#include "QtHeaders.h"


namespace Application
{
    class MainApplication;

    using ActiveFrameBufferItems = std::unordered_set<QQuickFramebufferObject*>;
    
    class MainFrame : public QQuickView
    {
        Q_OBJECT
    public:
        MainFrame( QWindow* parent = nullptr );
        virtual ~MainFrame();   

        bool initialize( const QSurfaceFormat& format );
        MainApplication&    getApplication() const;

        void insertFboItem(QQuickFramebufferObject*item);
        bool removeFboItem(QQuickFramebufferObject*item);

    protected:
        void mousePressEvent(QMouseEvent *event) override;
        void mouseMoveEvent(QMouseEvent *event) override;
        void mouseReleaseEvent(QMouseEvent *event) override;        
        void resizeEvent(QResizeEvent *event) override;
        void update();        

    private:
        void sceneGraphInitialized();
        void beforeSynchronizing();
        void beforeRendering();
        void sceneGraphInvalidated();
        void afterRendering();
        void frameSwapped();
        void closing();
        void afterAnimating();
        void registerConnections();

        std::unique_ptr<MainApplication>    m_application;
        ActiveFrameBufferItems              m_activeItems;
        std::mutex                          m_modifyFboItemsLock;
    };
}