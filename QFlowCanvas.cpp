//#include "AppIncludes.h"
//#include "QFlowNode.hpp"
//#include "QFlowCanvas.hpp"
//namespace Application
//{
//    inline void DrawGrid(QPainter* painter)
//    {
//
//    }
//
//    inline Vector2f QPointToVector2(const QPoint& pt)
//    {
//        return Vector2f(pt.x(), pt.y());
//    }
//
//    QFlowCanvas::QFlowCanvas(QQuickItem *parent /*= 0*/)
//        : QQuickPaintedItem(parent)
//        , m_zoom( 1.0f )
//    {
//        setRenderTarget( QQuickPaintedItem::FramebufferObject );
//        setAcceptedMouseButtons(Qt::AllButtons);
//        setFlag(ItemAcceptsInputMethod, true);
//        setPerformanceHint(QQuickPaintedItem::FastFBOResizing);
//        setAntialiasing(true);       
//        setMipmap(true);
//        
//        m_font16Px = QFont("Helvetica", 16);
//        //m_font16Px.setStyleHint(QFont::Helvetica,  QFont::PreferAntialias);
//        m_font16Px.setStyleStrategy((QFont::NoSubpixelAntialias));
//        m_backgroundColor.setRgb(25, 25, 25, 255);
//    }
//
//    QFlowCanvas::~QFlowCanvas()
//    {
//
//    }
//
//    void QFlowCanvas::paint(QPainter *painter)
//    {
//        m_canvasSize = size().toSize();
//
//        drawBackground(painter);
//        
//        beginWorldDrawing(painter); 
//
//        drawGrid(painter);        
//        
//        endWorldDrawing(painter);        
//    }
//
//
//    void QFlowCanvas::drawBackground( QPainter *painter )
//    {
//        
//        painter->fillRect(0, 0, m_canvasSize.width(), m_canvasSize.height(), getBackgroundColor());
//    }
//
//
//    void QFlowCanvas::beginWorldDrawing(QPainter *painter)
//    {
//        painter->save();
//        const auto oneOverZoom = 1.0f / m_zoom;
//        auto scaleTrans = QTransform::fromScale( oneOverZoom, oneOverZoom );
//        painter->setTransform( m_transform * scaleTrans );
//        painter->setRenderHints(QPainter::TextAntialiasing | QPainter::Antialiasing);
//        painter->setFont(m_font16Px);
//    }
//
//    void QFlowCanvas::endWorldDrawing(QPainter *painter)
//    {
//        painter->restore();
//    }
//
//    void QFlowCanvas::drawGrid(QPainter* painter)
//    {
//        static const QColor innerGridColor(64, 64, 64, 255);
//        static const QColor outerGridColor(96, 96, 96, 255);
//
//        /* auto grad = Graphics::Gradient();
//         grad.addColor(GradientColor({ { 1.0f, 0.0f, 0.0f, 1.0f }, 0.0f }));
//         grad.addColor(GradientColor({ { 0.0f, 1.0f, 0.0f, 1.0f }, 0.5f }));
//         grad.addColor(GradientColor({ { 0.0f, 0.0f, 1.0f, 1.0f }, 1.0f }));
//         painter->setPen(Qt::SolidLine);*/
//       // painter->setBackgroundMode(Qt::OpaqueMode);
//        painter->fillRect(-256, -256, 512, 512, QColor( 0, 128, 128, 255 ));
//        painter->setBrush(Qt::white);     
//        painter->setPen(Qt::white);
//
//        QPainterPath textPath;
//        textPath.addText( 0, 0, m_font16Px, "Hello world" );
//        painter->drawPath( textPath );
//        
//        //painter->drawText(QPoint( 0, 0 ), "Hello World");
//    }
//
//    void QFlowCanvas::wheelEvent(QWheelEvent *event)
//    {
//        if (event->delta() > 0)
//            m_zoom *= 0.9f;
//        else
//            m_zoom *= (1.0f) / 0.9f;       
//       
//        update();
//    }
//
//    void QFlowCanvas::mouseMoveEvent(QMouseEvent *event)
//    {
//        const auto mousePos = QPoint(event->x(), event->y());        
//        if ( event->buttons() & Qt::MouseButton::RightButton && m_rightMouseDown)
//        {
//            auto mouseMovePos = QPointToVector2( mousePos );
//            m_translation     = m_origin + ( ( mouseMovePos - m_rightMouseDownPos ) * m_zoom );          
//            
//            m_transform  = QTransform::fromTranslate( m_translation.getX(), m_translation.getY() );
//            update();
//        }      
//        qDebug() << __FUNCTION__;
//      
//    }
//
//    void QFlowCanvas::mousePressEvent(QMouseEvent *event)
//    {
//        const auto mousePos = QPoint(event->x(), event->y());
//        if ( event->button() == Qt::MouseButton::RightButton)
//        {
//            m_rightMouseDownPos = QPointToVector2( mousePos );
//            m_rightMouseDown    = true;
//            update();
//        }
//        else if (event->button() == Qt::MouseButton::LeftButton)
//        {
//          
//            qDebug() << "World position is " << screenToWorld( event->x(), event->y()).toString().c_str();
//
//            qDebug() << "Screen position is " << worldToScreen( 0, 0 ).toString().c_str();
//
//        }
//        qDebug() << __FUNCTION__;       
//    }
//
//
//
//    void QFlowCanvas::mouseReleaseEvent(QMouseEvent *event)
//    {
//        const auto mousePos = QPoint(event->x(), event->y());
//        if (event->button() == Qt::MouseButton::RightButton)
//        {
//            m_origin         = m_translation;
//            m_transform      = QTransform::fromTranslate( m_translation.getX(), m_translation.getY() );
//            m_rightMouseDown = false;
//            m_translation = Vector2f(0, 0);
//            update();
//        }
//        qDebug() << __FUNCTION__;
//      
//    }
//
//    void QFlowCanvas::hoverMoveEvent(QHoverEvent *event)
//    {
//        qDebug() << __FUNCTION__;
//    }
//
//    QColor QFlowCanvas::getBackgroundColor() const
//    {
//        return m_backgroundColor;
//    }
//
//    void QFlowCanvas::setBackgroundColor(QColor val)
//    {
//        m_backgroundColor = val;
//    }
//
//    Vector2f QFlowCanvas::worldToScreen(float x, float y) const
//    {
//        return pixelToWorld(x, y) + m_origin;
//    }
//
//    Vector2f QFlowCanvas::worldToPixel(float x, float y) const
//    {
//        const auto invZoom = 1.0f / m_zoom;
//        return Vector2f(x, y) * invZoom;
//    }
//
//    Vector2f QFlowCanvas::pixelToWorld(int x, int y) const
//    {
//        return Vector2f( x, y ) * m_zoom;
//    }
//
//    Vector2f QFlowCanvas::screenToWorld( int x, int y ) const
//    {
//        auto point = pixelToWorld( x, y ) - m_origin;
//        return point;
//    }
//
//    void QFlowCanvas::zoom(float factor)
//    {
//        m_zoom = factor;
//    }
//
//    void QFlowCanvas::zoomTo(const QFlowObject* flowObject, int numObjects /*= 1 */)
//    {
//
//    }
//
//    void QFlowCanvas::translate(float x, float y)
//    {
//
//    }
//
//    void QFlowCanvas::zoomExtents()
//    {
//
//    }
//
//
//
//    void QFlowCanvas::lookAt(const Vector2f& worldCoord /*= Vector2f( .0f, .0f ) */)
//    {
//        auto pixOffset = worldToScreen( worldCoord.getX(), worldCoord.getY() );
//    }
//
//}
