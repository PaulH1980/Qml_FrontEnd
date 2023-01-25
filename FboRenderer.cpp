#include "MainFrame.hpp"
#include "AppIncludes.h"
#include "MainApplication.hpp"
#include "FboRenderer.hpp"

namespace Application
{
    struct VertexData
    {
        QVector3D position;
        QVector2D texCoord;
    };

    const char* defaultShaderVert =
        "#version 400																	\n"
        "#extension GL_ARB_explicit_uniform_location : enable                           \n"
        "layout( location = 0 ) in vec3		vertIn;										\n"
        "layout( location = 1 ) in vec4		rgbaIn;										\n"
        "layout( location = 2 ) in vec2		uvIn;										\n"
        "layout( location = 3 ) in float    pointSizeIn;								\n"
        "uniform mat4	wvp;									                        \n"
        "uniform mat4	objTransform;						    	                    \n"
        "out vec4		rgba;															\n"
        "out vec2		uv;																\n"
        "																				\n"
        "void main()																	\n"
        "{																				\n"
        "	gl_Position = wvp * (objTransform * vec4( vertIn, 1.0 ) );				    \n"
        "	gl_PointSize =	pointSizeIn;												\n"
        "	rgba = rgbaIn;																\n"
        "	uv = uvIn;																	\n"
        "}																				\n";

    const char* defaultShaderFrag =
        "#version 400																	\n"
        "in vec4 rgba;																	\n"
        "in vec2 uv;																	\n"
        "																				\n"
        "uniform sampler2D tex_0;														\n"
        "uniform int gDrawText = 0;														\n"
        "																				\n"
        "const float smoothing = 1.0/32.0;												\n"
        "layout( location = 0 ) out vec4 FragColor;										\n"
        "void main()																	\n"
        "{																				\n"
        "	    vec4 texColor = vec4( texture( tex_0, uv ).rgb, 1.0 );  				\n"
        "		FragColor = vec4( 0, 1, 0, 1 );											\n"
        "																				\n"
        "}																				\n"
        "																				\n";



    FboRendererBase::FboRendererBase(const QQuickFramebufferObject* item)
        : m_fboItem(item)
        , m_mainFrame(dynamic_cast<MainFrame*>(item->window()))
    {
        assert(m_mainFrame && "Invalid MainFrame");
    }

    SceneRenderer::SceneRenderer(const QQuickFramebufferObject* item)
        : FboRendererBase(item)
    {

    }

    QOpenGLFramebufferObject * SceneRenderer::createFramebufferObject(const QSize &size)
    {
        QOpenGLFramebufferObjectFormat format;
        format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
        format.setSamples(4);
        m_mainFrame->getApplication().resize(size.width(), size.height());
        return new QOpenGLFramebufferObject(size, format);
    }

    void SceneRenderer::render()
    {
        m_mainFrame->getApplication().present(); //draw world
        m_mainFrame->resetOpenGLState();
        this->update(); //
    }

    void SceneRenderer::synchronize(QQuickFramebufferObject * theObject)
    {
        Renderer::synchronize(theObject);
    }

    SceneRenderItem::SceneRenderItem(QQuickItem* parent)
        : QQuickFramebufferObject(parent)
    {
    }

    QQuickFramebufferObject::Renderer* SceneRenderItem::createRenderer() const
    {
        return new SceneRenderer(this);
    }





    //////////////////////////////////////////////////////////////////////////
    //\Brief: FlowRenderItem
    //////////////////////////////////////////////////////////////////////////
    FlowRenderItem::FlowRenderItem(QQuickItem* parent /*= nullptr*/)
        : QQuickFramebufferObject(parent)
    {
        setAcceptedMouseButtons(Qt::AllButtons);
    }


    QQuickFramebufferObject::Renderer * FlowRenderItem::createRenderer() const
    {
        auto renderer = new FlowRenderer(this);
        connect(this, &FlowRenderItem::rotationChanged, renderer, &FlowRenderer::setRotation);
        connect(this, &FlowRenderItem::fragShaderChanged, renderer, &FlowRenderer::updateFragmentShader);
        connect(this, &FlowRenderItem::zoomChanged, renderer, &FlowRenderer::dolly);
        return renderer;
    }

    void FlowRenderItem::mouseMoveEvent(QMouseEvent *event)
    {
        if (m_leftMouseDown) {
            m_mouseMovePos = QVector2D(event->x(), event->y());
            auto mouseDelta = m_mouseMovePos - m_mouseDownPos;
            auto newRot = m_oldRot + QVector3D(0, 0, mouseDelta.x() * .33f);
            setRotation(newRot);
        }
    }

    void FlowRenderItem::mousePressEvent(QMouseEvent *event)
    {
        if (event->button() == Qt::LeftButton) {
            m_leftMouseDown = true;
            m_mouseDownPos = QVector2D(event->x(), event->y());
            m_curRot = m_oldRot;
        }
    }

    void FlowRenderItem::mouseReleaseEvent(QMouseEvent *event)
    {
        if (event->button() == Qt::LeftButton) {
            m_leftMouseDown = false;
            m_mouseDownPos = m_mouseMovePos = QVector2D(event->x(), event->y());
            m_oldRot = m_curRot;
        }
    }


    void FlowRenderItem::wheelEvent(QWheelEvent *event)
    {
        if (event->delta() > 0)
            emit zoomChanged(true);
        else
            emit zoomChanged(false);
    }

    void FlowRenderItem::setBackgroundColor(float r, float g, float b)
    {

    }

    void FlowRenderItem::setRotation(const QVector3D& rot)
    {
        if (m_curRot != rot)
        {
            m_curRot = rot;
            emit rotationChanged(rot);
        }
    }

    void FlowRenderItem::setFragmentShader(const QString& fragShader)
    {
        if (m_fragShader != fragShader)
        {
            m_fragShader = fragShader;
            emit fragShaderChanged(fragShader);
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // FlowRenderer
    //////////////////////////////////////////////////////////////////////////
    FlowRenderer::FlowRenderer(const QQuickFramebufferObject* item)
        : FboRendererBase(item)
        , m_indexBuf(QOpenGLBuffer::IndexBuffer)
    {
        //  auto result = initializeOpenGLFunctions();
         // assert(result && "Initialize OpenGLFunctions");
        lookAt(QVector3D(m_distance * -1.0f, 0, 0));
        initCubeGeometry();
        initShader();
    }

    QOpenGLFramebufferObject * FlowRenderer::createFramebufferObject(const QSize &size)
    {
        QOpenGLFramebufferObjectFormat format;
        format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
        format.setSamples(4);
        m_projection.setToIdentity();
        m_projection.perspective(45.0, size.width() / (float)size.height(), 0.01f, 1000.0f);
        return new QOpenGLFramebufferObject(size, format);

    }

    void FlowRenderer::render()
    {
        auto* gl = QOpenGLContext::currentContext()->functions();
        const auto wvp = m_view * m_projection;

        glEnable(GL_DEPTH_TEST);
        glEnable(GL_CULL_FACE);
        glClearColor(0.0, 0.0, 0.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        m_program.bind();
        m_program.setUniformValue( "wvp", m_projection * m_view);
        m_program.setUniformValue( "objTransform", m_objMatrix);

        m_arrayBuf.bind();
        m_indexBuf.bind();

        // Offset for position
        quintptr offset = 0;
        m_program.enableAttributeArray(0);
        m_program.setAttributeBuffer(0, GL_FLOAT, offset, 3, sizeof(VertexData));
        // Offset for texture coordinate
        offset += sizeof(QVector3D);
        m_program.enableAttributeArray(2);
        m_program.setAttributeBuffer(2, GL_FLOAT, offset, 2, sizeof(VertexData));
        gl->glDrawElements(GL_TRIANGLE_STRIP, 34, GL_UNSIGNED_SHORT, 0);

       // m_mainFrame->resetOpenGLState();

    }

    void FlowRenderer::lookAt(const QVector3D& eye, const QVector3D& obj, const QVector3D& up /*= QVector3D(0, 0, 1)*/)
    {
        m_view.setToIdentity();
        m_view.lookAt(eye, obj, up);
        update();
    }

    void FlowRenderer::setObjectRotation(float x, float y, float z)
    {
        QMatrix4x4 xRot, yRot, zRot;
        xRot.rotate(x, QVector3D(1, 0, 0));
        yRot.rotate(y, QVector3D(0, 1, 0));
        zRot.rotate(z, QVector3D(0, 0, 1));

        m_objMatrix = zRot * yRot * xRot;
        update();
    }



    bool FlowRenderer::setFragmentShader(const QString& fragmentShader)
    {
        QShaderPtr frag = std::make_unique<QOpenGLShader>(QOpenGLShader::Fragment);
        if (!frag->compileSourceCode(fragmentShader.toStdString().c_str()))
            return false;
        
        if( m_fragShader )
            m_program.removeShader(m_fragShader.get());
        m_fragShader = std::move(frag);

        return m_program.addShader(m_fragShader.get());
    }

    bool FlowRenderer::setVertexShader(const QString& code)
    {
        QShaderPtr vertex = std::make_unique<QOpenGLShader>(QOpenGLShader::Vertex);
        if (!vertex->compileSourceCode(code.toStdString().c_str()))
            return false;
        
        if (m_vertShader)
            m_program.removeShader(m_vertShader.get());
        m_vertShader = std::move(vertex);

        return m_program.addShader(m_vertShader.get()); 
    }

    bool FlowRenderer::updateFragmentShader(const QString& fragmentShader)
    {
        if (!setFragmentShader(fragmentShader))
            return false;
        bool succeed = m_program.link();
        if ( succeed )
            update();
        return succeed;       
    }

    void FlowRenderer::setRotation(const QVector3D& rot)
    {
        setObjectRotation( rot.x(), rot.y(), rot.z() );
    }

    void FlowRenderer::dolly(bool zoomOut)
    {
        m_distance *= zoomOut ? 1.2f : 0.8f;
        if (m_distance < 2.5f)
            m_distance = 2.5f;
        lookAt( QVector3D(m_distance * -1.0f, 0, 0));
    }

    void FlowRenderer::reset()
    {
        m_distance = 5.0f;
        lookAt( QVector3D(m_distance * -1.0f, 0, 0));
        setRotation({ 0, 0, 0 });
    }

    void FlowRenderer::synchronize(QQuickFramebufferObject * theObject)
    {

    }

    void FlowRenderer::initShader()
    {
        bool succeed = true;

        succeed &= setVertexShader(defaultShaderVert);
        succeed &= setFragmentShader(defaultShaderFrag);

        succeed &= m_program.link();
        succeed &= m_program.bind();

        assert(succeed && "CompileShader");
    }

    void FlowRenderer::initCubeGeometry()
    {
        m_arrayBuf.create();
        m_indexBuf.create();


        // For cube we would need only 8 vertices but we have to
   // duplicate vertex for each face because texture coordinate
   // is different.
        VertexData vertices[] = {
            // Vertex data for face 0
            {QVector3D(-1.0f, -1.0f,  1.0f), QVector2D(0.0f, 0.0f)},  // v0
            {QVector3D(1.0f, -1.0f,  1.0f), QVector2D(0.33f, 0.0f)}, // v1
            {QVector3D(-1.0f,  1.0f,  1.0f), QVector2D(0.0f, 0.5f)},  // v2
            {QVector3D(1.0f,  1.0f,  1.0f), QVector2D(0.33f, 0.5f)}, // v3

            // Vertex data for face 1
            {QVector3D(1.0f, -1.0f,  1.0f), QVector2D(0.0f, 0.5f)}, // v4
            {QVector3D(1.0f, -1.0f, -1.0f), QVector2D(0.33f, 0.5f)}, // v5
            {QVector3D(1.0f,  1.0f,  1.0f), QVector2D(0.0f, 1.0f)},  // v6
            {QVector3D(1.0f,  1.0f, -1.0f), QVector2D(0.33f, 1.0f)}, // v7

            // Vertex data for face 2
            {QVector3D(1.0f, -1.0f, -1.0f), QVector2D(0.66f, 0.5f)}, // v8
            {QVector3D(-1.0f, -1.0f, -1.0f), QVector2D(1.0f, 0.5f)},  // v9
            {QVector3D(1.0f,  1.0f, -1.0f), QVector2D(0.66f, 1.0f)}, // v10
            {QVector3D(-1.0f,  1.0f, -1.0f), QVector2D(1.0f, 1.0f)},  // v11

            // Vertex data for face 3
            {QVector3D(-1.0f, -1.0f, -1.0f), QVector2D(0.66f, 0.0f)}, // v12
            {QVector3D(-1.0f, -1.0f,  1.0f), QVector2D(1.0f, 0.0f)},  // v13
            {QVector3D(-1.0f,  1.0f, -1.0f), QVector2D(0.66f, 0.5f)}, // v14
            {QVector3D(-1.0f,  1.0f,  1.0f), QVector2D(1.0f, 0.5f)},  // v15

            // Vertex data for face 4
            {QVector3D(-1.0f, -1.0f, -1.0f), QVector2D(0.33f, 0.0f)}, // v16
            {QVector3D(1.0f, -1.0f, -1.0f), QVector2D(0.66f, 0.0f)}, // v17
            {QVector3D(-1.0f, -1.0f,  1.0f), QVector2D(0.33f, 0.5f)}, // v18
            {QVector3D(1.0f, -1.0f,  1.0f), QVector2D(0.66f, 0.5f)}, // v19

            // Vertex data for face 5
            {QVector3D(-1.0f,  1.0f,  1.0f), QVector2D(0.33f, 0.5f)}, // v20
            {QVector3D(1.0f,  1.0f,  1.0f), QVector2D(0.66f, 0.5f)}, // v21
            {QVector3D(-1.0f,  1.0f, -1.0f), QVector2D(0.33f, 1.0f)}, // v22
            {QVector3D(1.0f,  1.0f, -1.0f), QVector2D(0.66f, 1.0f)}  // v23
        };

        // Indices for drawing cube faces using triangle strips.
        // Triangle strips can be connected by duplicating indices
        // between the strips. If connecting strips have opposite
        // vertex order then last index of the first strip and first
        // index of the second strip needs to be duplicated. If
        // connecting strips have same vertex order then only last
        // index of the first strip needs to be duplicated.
        GLushort indices[] = {
             0,  1,  2,  3,  3,     // Face 0 - triangle strip ( v0,  v1,  v2,  v3)
             4,  4,  5,  6,  7,  7, // Face 1 - triangle strip ( v4,  v5,  v6,  v7)
             8,  8,  9, 10, 11, 11, // Face 2 - triangle strip ( v8,  v9, v10, v11)
            12, 12, 13, 14, 15, 15, // Face 3 - triangle strip (v12, v13, v14, v15)
            16, 16, 17, 18, 19, 19, // Face 4 - triangle strip (v16, v17, v18, v19)
            20, 20, 21, 22, 23      // Face 5 - triangle strip (v20, v21, v22, v23)
        };

        // Transfer vertex data to VBO 0
        m_arrayBuf.bind();
        m_arrayBuf.allocate(vertices, 24 * sizeof(VertexData));

        // Transfer index data to VBO 1
        m_indexBuf.bind();
        m_indexBuf.allocate(indices, 34 * sizeof(GLushort));
    }

}

