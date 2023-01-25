#pragma once
#include "QtHeaders.h"

namespace Application
{
    class MainFrame;

    //////////////////////////////////////////////////////////////////////////
    //\FboRendererBase
    //////////////////////////////////////////////////////////////////////////
    class FboRendererBase : public QQuickFramebufferObject::Renderer, public QObject
    {

    public:
        FboRendererBase(const QQuickFramebufferObject* item);

    protected:
        MainFrame*                      m_mainFrame;
        const QQuickFramebufferObject*  m_fboItem;
    };    

    //////////////////////////////////////////////////////////////////////////
    //\SceneRenderer
    //////////////////////////////////////////////////////////////////////////
    class SceneRenderer : public FboRendererBase    {
        Q_OBJECT
    public:      
        SceneRenderer(const QQuickFramebufferObject* item);
        QOpenGLFramebufferObject *createFramebufferObject(const QSize &size) override;
        void                      render() override;
    protected:
        void                      synchronize( QQuickFramebufferObject * theObject ) override;
    };
       
    //////////////////////////////////////////////////////////////////////////
    //\SceneRenderItem
    //////////////////////////////////////////////////////////////////////////
    class SceneRenderItem : public QQuickFramebufferObject
    {
        Q_OBJECT
    public:        
        SceneRenderItem( QQuickItem* parent = nullptr );
        QQuickFramebufferObject::Renderer *createRenderer() const override;       

    protected:

    };  


   

    //////////////////////////////////////////////////////////////////////////
    //\FlowRenderer
    //////////////////////////////////////////////////////////////////////////
    class FlowRenderer : public FboRendererBase
    {
        using QShaderPtr = std::unique_ptr<QOpenGLShader>;

        Q_OBJECT
    public:
        FlowRenderer(const QQuickFramebufferObject* item);
        QOpenGLFramebufferObject *createFramebufferObject(const QSize &size) override;
        void                      render() override;

        void                      lookAt(const QVector3D& eye, const QVector3D& obj = QVector3D( 0,0,0), const QVector3D& up = QVector3D(0, 0, 1));
        void                      setObjectRotation(float x, float y, float z);
    
            
    public slots:
        bool                      setFragmentShader(const QString& fragmentShader);
        bool                      setVertexShader(const QString& fragmentShader);
        bool                      updateFragmentShader(const QString& fragmentShader);

        void                      setRotation(const QVector3D& rot);
        void                      dolly( bool zoomOut );
        void                      reset();

    protected:
        void                      synchronize(QQuickFramebufferObject * theObject) override;      

    private:

        void                      initShader();
        void                      initCubeGeometry();

        QMatrix4x4                m_projection;
        QMatrix4x4                m_view;
        QMatrix4x4                m_objMatrix;
       
        float                     m_distance = 5.0f;
        QShaderPtr                m_vertShader;
        QShaderPtr                m_fragShader;

        QOpenGLShaderProgram      m_program;
        QOpenGLBuffer             m_arrayBuf;
        QOpenGLBuffer             m_indexBuf;
    };

    //////////////////////////////////////////////////////////////////////////
    //\FlowRenderItem
    //////////////////////////////////////////////////////////////////////////
    class FlowRenderItem : public QQuickFramebufferObject
    {
        Q_OBJECT
    public:
        FlowRenderItem(QQuickItem* parent = nullptr);
        QQuickFramebufferObject::Renderer *createRenderer() const override;

        void mouseMoveEvent(QMouseEvent *event) override;
        void mousePressEvent(QMouseEvent *event) override;
        void mouseReleaseEvent(QMouseEvent *event) override;      
        void wheelEvent(QWheelEvent *event) override;

        void setBackgroundColor(float r, float g, float b);

    public slots:
        void setRotation(const QVector3D& rot);
        void setFragmentShader(const QString& fragShader);

    signals:
        void zoomChanged(bool);
        void fragShaderChanged(const QString& fragShader);
        void rotationChanged(const QVector3D& rot);

    private:    
        bool        m_leftMouseDown = false;
        QVector2D   m_mouseDownPos,
                    m_mouseMovePos;
        QVector3D   m_oldRot;
        QVector3D   m_curRot;
        QString     m_fragShader;

    };

}
