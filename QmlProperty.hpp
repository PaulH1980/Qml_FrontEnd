#pragma  once
#include <Math/GenMath.h>
#include <Math/Range.h>
#include <Math/AABB.h>
#include <Math/Vector.h>

#include "QmlPropertyBase.hpp"

namespace Application
{
    
    //////////////////////////////////////////////////////////////////////////
    //\QMLBoolProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlBoolProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:       
        QmlBoolProperty( const Properties::PropertyBasePtr& backend );
        virtual void        setVariant( const QVariant& ) override;

    public slots:
        void                setValue( bool val );
        bool                getValue() const;
    signals:
        void                boolChanged( bool );

    private:
           
    };


    //////////////////////////////////////////////////////////////////////////
    //\QMLIntegerProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlIntegerProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlIntegerProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;

    public slots:
        void                setValue(int val);
        int                 getValue() const;

    signals:
        void                integerChanged(int);

    private:

    };

    //////////////////////////////////////////////////////////////////////////
    //\QMLUnsignedProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlUnsignedProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlUnsignedProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;

    public slots:
        void                setValue(std::uint32_t val);
        std::uint32_t       getValue() const;

    signals:
        void                unsignedChanged( std::uint32_t);
    private:
    };

    //////////////////////////////////////////////////////////////////////////
    //\QMLFloatProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlFloatProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlFloatProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(float val);
    public slots:      
        float               getValue() const;

    signals:
        void                floatChanged(float);
    private:       

    };

    //////////////////////////////////////////////////////////////////////////
    //\QMLVector2Property
    //////////////////////////////////////////////////////////////////////////
    class QmlVector2Property : public QmlPropertyBase
    {
        Q_OBJECT  
    public:
        QmlVector2Property(const Properties::PropertyBasePtr& backend);
         virtual void        setVariant(const QVariant&) override;
         void                setValue(const Math::Vector2f& val);

    public slots:
        
        QVector2D           getValue() const;

    signals:
        void                vector2Changed( QVector2D);
    private:

    };

    //////////////////////////////////////////////////////////////////////////
    //\QMLVector2Property
    //////////////////////////////////////////////////////////////////////////
    class QmlVector2iProperty : public QmlPropertyBase
    {
        Q_OBJECT  
    public:
        QmlVector2iProperty(const Properties::PropertyBasePtr& backend);

        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::Vector2i& val);

    public slots:
        
        Math::Vector2i            getValue() const;

    signals:
        void                vector2iChanged(Math::Vector2i);
    private:

    };


    //////////////////////////////////////////////////////////////////////////
    //\QMLVector3Property
    //////////////////////////////////////////////////////////////////////////
    class QmlVector3Property : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlVector3Property(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::Vector3f& val);

    public slots:
       
        QVector3D           getValue() const;

    signals:
        void                vector3Changed(QVector3D);
    private:

    };

    //////////////////////////////////////////////////////////////////////////
    //\QMLVector3iProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlVector3iProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlVector3iProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::Vector3i& val);

    public slots:
        Math::Vector3i            getValue() const;

    signals:
        void                vector3iChanged(Math::Vector3i);
    private:

    };


    //////////////////////////////////////////////////////////////////////////
    //\QMLVector4Property
    //////////////////////////////////////////////////////////////////////////
    class QmlVector4Property : public QmlPropertyBase
    {
        Q_OBJECT
     public:
        QmlVector4Property(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::Vector4f& val);

    public slots:       
        QVector4D           getValue() const;
    signals:
        void                vector4Changed(QVector4D);

    private:

    };


    //////////////////////////////////////////////////////////////////////////
   //\QMLVector4Property
   //////////////////////////////////////////////////////////////////////////
    class QmlVector4iProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlVector4iProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::Vector4i& val);

    public slots:
        Math::Vector4i           getValue() const;
    signals:
        void                vector4iChanged(Math::Vector4i);

    private:

    };


    //////////////////////////////////////////////////////////////////////////
    //\QMLColorProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlColorProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlColorProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(QColor val);

    public slots:       
        QColor              getValue() const;

    signals:
        void                colorChanged( QColor );
    private:

    };

    //////////////////////////////////////////////////////////////////////////
    //\QmlTextProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlTextProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlTextProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const std::string& val);

    public slots:      
        QString             getValue() const;
  
    signals:
        void                textChanged( QString );
        

    private:

    };

    //////////////////////////////////////////////////////////////////////////
    //\QmlFileProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlFileProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlFileProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const std::string& val);

    public slots:        
        QString             getValue() const;

    signals:
        void                fileChanged(QString);
    private:
    };


    //////////////////////////////////////////////////////////////////////////
    //\QmlEnumProperty, Getters return a json string, while setters 
    //set an integer variant(single enum selection or bitmask)
    //////////////////////////////////////////////////////////////////////////
    class QmlEnumProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlEnumProperty(const Properties::PropertyBasePtr& backend);
        //as integer 
        virtual void        setVariant(const QVariant&) override;
        void                setValue(int val);
    public slots:               
        QString             getValue() const; 

    signals:
        void                enumChanged(int);

    private:

    };


    //////////////////////////////////////////////////////////////////////////
    //\QmlSelectResourceProperty: Select a resource out of a list
    //////////////////////////////////////////////////////////////////////////
    class QmlSelectResourceProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlSelectResourceProperty( const Properties::PropertyBasePtr& backend );
        //as integer 
        virtual void        setVariant(const QVariant&) override;
        void                setValue(int val);
    public slots:
        QString             getValue() const;

    signals:
        void                selectedPropertyChanged(int);

    private:

    };



    //////////////////////////////////////////////////////////////////////////
    //\QmlBBox2Property
    //////////////////////////////////////////////////////////////////////////
    class QmlBBox2Property : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlBBox2Property(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::BBox2f& val);

    public slots:        
        Math::BBox2f        getValue() const;

    signals:
        void                boundsChanged(Math::BBox2f );

    private:
    };

    //////////////////////////////////////////////////////////////////////////
    //\QmlBBox3Property
    //////////////////////////////////////////////////////////////////////////
    class QmlBBox3Property : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlBBox3Property(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::BBox3f& val);
    public slots:        
        Math::BBox3f        getValue() const;

    signals:
        void                boundsChanged(Math::BBox3f);

    private:
    };

    //////////////////////////////////////////////////////////////////////////
  //\QmlIntRangeProperty
  //////////////////////////////////////////////////////////////////////////
    class QmlIntRangedProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlIntRangedProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::IntRangedValue& val);
    public slots:
        Math::IntRangedValue      getValue() const;

    signals:
        void                intRangeChanged(Math::IntRangedValue);

    private:
    };

    //////////////////////////////////////////////////////////////////////////
    //\QmlFloatRangeProperty
    //////////////////////////////////////////////////////////////////////////
    class QmlFloatRangedProperty : public QmlPropertyBase
    {
        Q_OBJECT
    public:
        QmlFloatRangedProperty(const Properties::PropertyBasePtr& backend);
        virtual void        setVariant(const QVariant&) override;
        void                setValue(const Math::FloatRangedValue& val);
    public slots:
        Math::FloatRangedValue    getValue() const;

    signals:
        void                floatRangeChanged(Math::FloatRangedValue);

    private:
    };


}