//#include "QtHeaders.h"
//#include "AppIncludes.h"
//#include "QFlowNodeFwd.h"
//
//namespace Application
//{
//    static const int CANVAS_DIMENSIONS = 256;
//    
//    
//    class QFlowCanvas : public QQuickPaintedItem
//    {
//        Q_OBJECT
//    public:
//        QFlowCanvas( QQuickItem *parent = nullptr );
//        virtual ~QFlowCanvas();
//        void    paint(QPainter *painter) override;
//
//        void    wheelEvent(QWheelEvent *event) override;
//        void    mouseMoveEvent(QMouseEvent *event) override;
//        void    mousePressEvent(QMouseEvent *event) override;
//        void    mouseReleaseEvent(QMouseEvent *event) override;
//        void    hoverMoveEvent(QHoverEvent *event) override;
//        
//
//        QColor  getBackgroundColor() const;
//        void    setBackgroundColor(QColor val);
//
//
//
//
//        Vector2f worldToScreen( float x, float y ) const;
//        Vector2f worldToPixel( float x, float y) const;
//
//        Vector2f pixelToWorld (int x, int y)const;
//        Vector2f screenToWorld(int x, int y) const;
//
//    public slots:
//        void    zoom(float factor);
//        void    zoomTo( const QFlowObject* flowObject, int numObjects = 1 );
//        void    translate(float x, float y);
//        void    zoomExtents();
//        void    lookAt( const Vector2f& worldCoord = Vector2f( .0f, .0f ) );
//
//    private:
//        void    drawBackground(QPainter *painter);
//        void    beginWorldDrawing(QPainter *painter);
//        void    endWorldDrawing(QPainter *painter);
//        
//        void    drawGrid(QPainter* painter);
//
//
//
//        QFont               m_font16Px;
//
//        QSize               m_canvasSize;
//        QColor              m_backgroundColor;
//        
//        bool                m_rightMouseDown;
//        Vector2f            m_rightMouseDownPos;
//        
//        Vector2f            m_scale;
//        Vector2f            m_translation;
//        Vector2f            m_origin;
//        float               m_zoom;
//
//        QTransform          m_transform;
//
//        QPoint              m_center;
//        QSize               m_size; 
//        QFlowObjectVector   m_canvasItems;
//    };
//
//}
//
//
