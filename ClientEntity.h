#include <Components/CameraComponentFwd.h>
#include <Components/SkyBoxComponentFwd.h>
#include <Components/InputComponent.h>
#include <Scene/SceneGraphEntity.h>

using namespace Scene;
namespace Application{

  
    const Vector3f CAMERA_UP = { 0.0f, 1.0f, 0.0f };

    enum eCameraControllerFlags
    {
        ALLOW_CAMERA_TRANSLATE_X     = 0x01,     //movement in x plane 
        ALLOW_CAMERA_TRANSLATE_Y     = 0x02,     //movement in y plane
        ALLOW_CAMERA_TRANSLATE_Z     = 0x04,     //movement in z direction
        ALLOW_CAMERA_ROTATE          = 0x08,
        ALLOW_CAMERA_ALL             = 0xFFFFFFFF
    };

    

    class CameraControllerBase : public InputComponent
    {
    public:
        ROOT_OBJECT(CameraControllerBase)
        BASE_OBJECT(InputComponent)

        CameraControllerBase(Engine::EngineContext* context);
       

        /*
          @brief: Control this camera
        */
        virtual void				setCamera(Camera* cam);

        /*
            @brief: Constrain/Allow Camera transform
        */
        virtual void                setCameraFlags(std::uint32_t flags);

        /*
          @brief: Handle mouse wheel, dolly camera by default
        */
        virtual void                onMouseWheel(Engine::Event& evt);

        /*
           @brief: Set camera distance to POI
        */
        virtual void                setDistance(float distance);

        /*
            @brief: Set rotation around point of interest ( x plane )
        */
        virtual void                setPitch(float pitch);

        /*
            @brief: Sets rotation around point of interest( z-plane )
        */
        virtual void                setYaw(float yaw);
        
        /*
           @brief: Set camera point of interest
        */
        virtual void                setCenter(const Vector3f& center);

        /*
           @brief: Returns the camera associated with this controller
        */
        virtual Camera*            getCamera() const;
        
        /*
           @brief: Movement in camera z direction
        */
        virtual void                dolly(bool forward);

        /*
            @brief: Set new camera dimensions
        */
        virtual void                setSize(int w, int h);              
        
        /*
            @brief: Prepare for movement
        */
        virtual void                prepare() = 0;
                
        /*
            @brief: Handle client input
        */
        virtual void                input(float timeStep) = 0;

        /*
            @brief: Calculate camera transform etc.
        */
        virtual void                apply() = 0;      

        /*
            @brief: Directly aim camera
        */
        virtual void                lookAt( const Vector3f& eye, const Vector3f& center, const Vector3f& up ) = 0;        
        
        /*
            @brief: Movement in camera x, y plane
        */
        virtual void                pan( float, float ) = 0;      
       
      

      protected:
        Camera*                     m_cameraPtr = {nullptr};         //active camera
        std::uint32_t               m_cameraMovementFlags;
        int                         m_width,
                                    m_height;
        Vector3f                    m_center;       //point of interest
        float                       m_distance;     //distance to point of interest
        
        float                       m_pitch, 
                                    m_yaw,
                                    m_roll;   
        Vector2i                    m_mouseDownPos;


    private:

        
    };    
    
    /*
        @brief: Semi-Arcball camera controller where the camera cannot 'roll' or tip over 
    */
    class ArcBallController : public CameraControllerBase
    {
    public:
        ROOT_OBJECT(ArcBallController)
        BASE_OBJECT(CameraControllerBase)

        static void                 Register( Engine::EngineContext* contextPtr );
        static void                 Register(Script::ScriptEngine*);


        ArcBallController(Engine::EngineContext*);

        void                        prepare( )override;
        void                        input( float timeStep ) override;
        void                        apply()override;
        /*
            @brief: Directly aim camera
        */
        virtual void                lookAt(const Vector3f& eye, const Vector3f& center, const Vector3f& up) override;
        /*
            @brief: Movement in camera x, y plane
        */
        virtual void                pan( float, float ) override;
      

    private:
        Quatf                       getRotation() const;
       

        float				m_mouseSpeed;
        float				m_cameraSpeed;      

    };

    

    class ClientEntity : public SceneGraphEntity
    {
        ROOT_OBJECT(ClientEntity)
        BASE_OBJECT(SceneGraphEntity)
    public:

        static void Register(Engine::EngineContext* context);
        static void Register(Script::ScriptEngine* script);

        ClientEntity(Engine::EngineContext* context);
        virtual ~ClientEntity();       
        bool postConstructor() override;

    private:

        /*
            @brief: Begin a new frame
        */
        void								beginFrame(Engine::Event& evt);
        /*
            @brief: Scene loaded event
        */
        void								sceneLoaded(Engine::Event& evt);
        /*
            @brief: Application window was resize
        */
        void                                onResizeApplication(Engine::Event& evt);

        /*
            @brief: Handle Lookat event
        */
        void                                onLookAtEvent(Engine::Event& evt);

        /*
            @brief: Return camera component
        */
        Components::CameraComponent*        getCameraComponent() const;

        /*
            @brief: Return Sky box component
        */
        Components::SkyBoxComponent*        getSkyBoxComponent() const;



        CameraControllerBase*                   m_inputController = { nullptr };
        Components::CameraComponent*		    m_clientCamera = { nullptr };
        Components::SkyBoxComponent*            m_skyBox = { nullptr };
    };

}