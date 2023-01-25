#pragma once
#include <Common/Enums.h>
#include <Properties/PropertyBasePtr.h>
#include "QtHeaders.h"

namespace Application
{
    constexpr int INVALID_ROLE      = -1;
    constexpr int PREFERRED_HEIGHT  = 40;

    class QmlPropertyBase : public QObject
    {
        Q_OBJECT
    public:
        QmlPropertyBase(const Properties::PropertyBasePtr& backend, QObject* parent = nullptr);
        virtual     ~QmlPropertyBase() = default;
        virtual bool        connect() { return true; }
       
      
    public slots:

        QString		        getSectionName()	const { return m_sectionName; }
        QString		        getQMLFile()		const;
        QString             getTitle()          const { return m_title; }
        QString		        getObjectType()		const { return m_objectType; }     

        QString		        getXLabel()			const { return m_xLabel; }
        QString		        getYLabel()			const { return m_yLabel; }
        QString		        getZLabel()			const { return m_zLabel; }
        QString		        getWLabel()			const { return m_wLabel; }

        int			        getPreferredHeight()const { return m_prefHeight; }
        int			        getIndex()          const { return m_indexInModel; }
        bool                isVisible()         const { return m_visible; }


        bool                hasLimitMin()       const { return m_minLimit; }
        bool                hasLimitMax()       const { return m_maxLimit; }
        bool                isRanged()          const { return hasLimitMin() && hasLimitMax(); }

        int                 getPropertyType()   const;      
        int                 getPropertyFlags()  const;

      

        /*
           @brief: Sets the index/row of this item
        */
        void		        setIndex(int idx);
        /*
            @brief: Change this property it's visibility
        */
        void		        setVisible(bool val);   
     
      
        /*
            @brief: Get/Set variant, for this class will be shared data as json
        */
        QVariant            getVariant() const;
        virtual void        setVariant(const QVariant&);      
      
        /*
           @brief: Virtual function should be overridden in child classes
        */
        virtual QVariant    getMinValue() const;
        virtual QVariant    getMaxValue() const;



               
    signals:
        void		        visibilityChanged();


    protected:
        Properties::PropertyBasePtr m_backend;

        
        QString		    m_title;
        QString         m_qmlFile;
        QString         m_sectionName;
        QString         m_objectType;
        
     
        QString         m_xLabel,
                        m_yLabel,
                        m_zLabel,
                        m_wLabel;      

        int             m_propertyType;

        int			    m_prefHeight; 
        int			    m_indexInModel;

        bool		    m_visible;
       
        bool            m_vecLabelsVisible;
        bool            m_minLimit;
        bool            m_maxLimit;
        bool            m_asSlider;      
    };
}
