#include <Graphics/DebugRender.h>
#include <Components/SkyBoxComponent.h>
#include "AppIncludes.h"
#include "ClientEntity.h"


using namespace chaiscript;


inline int					getMouseWheelDelta(Engine::Event& evt)
{
    return evt.getValue<int>("MOUSE_WHEEL_DELTA");
}


namespace
{
    Math::Vector3f FORWARD(0.0f, 0.0f, -1.0f);
    Math::Vector3f BACKWARD(0.0f, 0.0f, 1.0f);
    Math::Vector3f LEFT(-1.0f, 0.0f, 0.0f);
    Math::Vector3f RIGHT(1.0f, 0.0f, 0.0f);
}

namespace Application
{
    void ClientEntity::Register(Engine::EngineContext* context)
    {
        context->registerObject<ClientEntity>();
        context->registerClassInfo<CameraControllerBase>();
        context->registerObject<ArcBallController>();       
    }

    void ClientEntity::Register(Script::ScriptEngine* script)
    {
        
        auto& backend = script->getScriptingBackend();
        backend.add(chaiscript::user_type<ClientEntity>(), GetTypeNameStatic() );
        backend.add(chaiscript::base_class<RootObject, ClientEntity>());
        backend.add(chaiscript::base_class<EntityBase, ClientEntity>());
        backend.add(chaiscript::base_class<SceneGraphEntity, ClientEntity>());

        backend.add(fun(&ClientEntity::getCameraComponent), "getCameraComponent");
        backend.add(fun(&ClientEntity::getSkyBoxComponent), "getSkyBoxComponent");
        backend.add(fun([](const ClientEntity* ent) -> std::string { return "HELLO"; }), "PrintHello" );
    }

    //////////////////////////////////////////////////////////////////////////
    //
    //////////////////////////////////////////////////////////////////////////
    ClientEntity::ClientEntity(Engine::EngineContext* context)
        : SceneGraphEntity(context)
    {
      
    }

    ClientEntity::~ClientEntity()
    {

    }


   

    bool ClientEntity::postConstructor()
    {
        if (!SceneGraphEntity::postConstructor())
            return false;

        m_clientCamera    = createComponent<CameraComponent>();
        m_inputController = createComponent<ArcBallController>();       
        m_skyBox          = createComponent<SkyBoxComponent>();
        m_inputController->setCamera( m_clientCamera->getCamera() );  

        subscribeToEvent( CreateEventHandler(this, &ClientEntity::beginFrame ,           "TIMER_BEGIN_FRAME" ) );
        subscribeToEvent( CreateEventHandler(this, &ClientEntity::onResizeApplication,   "RESIZE" ) );
        subscribeToEvent( CreateEventHandler(this, &ClientEntity::sceneLoaded,           "SCENE_LOADED" ) );
        subscribeToEvent( CreateEventHandler(this, &ClientEntity::onLookAtEvent,         "CAMERA_LOOK_AT" ) );

        return true;
    }

    void ClientEntity::beginFrame(Engine::Event& evt)
    {
        auto varStore = getContext()->getSystem<GlobalVariableStore>();
        auto camera   = getComponent<CameraComponent>()->getCamera();

        //fallback values 
        float camFov = camera->getFov();
        float fNear  = camera->getNear();
        float fFar   = camera->getFar();
        bool ortho   = camera->isOrtho();

        varStore->queryVariable("client_cam_fov", camFov);
        varStore->queryVariable("client_cam_near", fNear);
        varStore->queryVariable("client_cam_far", fFar);
        varStore->queryVariable("client_cam_ortho", ortho);

        camera->setFov(camFov);
        camera->setNear(fNear);
        camera->setFar(fFar);
        camera->setOrtho(ortho);
    }


    void ClientEntity::sceneLoaded(Engine::Event& evt)
    {
        
    }

    void ClientEntity::onResizeApplication(Engine::Event& evt)
    {
        int w, h;
        evt.getValue("RESIZE_WIDTH",  w);
        evt.getValue("RESIZE_HEIGHT", h);
        auto camera = getComponent<CameraComponent>()->getCamera();
        camera->resize(w, h);        
    }

    void ClientEntity::onLookAtEvent( Engine::Event& evt )
    {
        const auto eye    = evt.getValue<Vector3f>("EYE");
        const auto target = evt.getValue<Vector3f>("TARGET");
        const auto up     = evt.getValue<Vector3f>("UP");
        m_inputController->lookAt(eye, target, up);
    }

    CameraComponent* ClientEntity::getCameraComponent() const
    {
        return m_clientCamera;
    }

    SkyBoxComponent* ClientEntity::getSkyBoxComponent() const
    {
        return m_skyBox;
    }


    CameraControllerBase::CameraControllerBase(Engine::EngineContext* context)
        : InputComponent( context )
        , m_cameraPtr( nullptr )
        , m_cameraMovementFlags( ALLOW_CAMERA_ALL )
        , m_distance( 128.0f )
        , m_pitch( 0.0f )
        , m_yaw( 0.0f )
        , m_roll( 0.0f )
    {        
        subscribeToEvent(CreateEventHandler(this, &CameraControllerBase::onMouseWheel, "MOUSE_WHEEL"));
    }

    void CameraControllerBase::setCamera( Camera* camPtr )
    {
        m_cameraPtr = camPtr;
    }

    void CameraControllerBase::setCameraFlags(std::uint32_t flags)
    {
        m_cameraMovementFlags = flags;
    }


    void CameraControllerBase::setDistance(float distance)
    {
        if (distance < 0.000125f)
            distance = 0.000125f;
        m_distance = distance;
    }

    void CameraControllerBase::setPitch(float pitch)
    {
        m_pitch = pitch;
    }

    void CameraControllerBase::setYaw(float yaw)
    {
        m_yaw = yaw;
    }

    void CameraControllerBase::setCenter(const Vector3f& center)
    {
        m_center = center;
    }

    Camera* CameraControllerBase::getCamera() const
    {
        return m_cameraPtr;
    }

    void CameraControllerBase::dolly(bool forward)
    {
        const auto ratio = forward
            ? 1 / 1.1f
            : 1.1f;

        setDistance( m_distance * ratio );
    }

    void CameraControllerBase::setSize(int w, int h)
    {
        m_width = w;
        m_height = h;
    }

    void CameraControllerBase::onMouseWheel(Engine::Event& evt)
    {
        const bool zoomIn = getMouseWheelDelta(evt) > 0;
        dolly(zoomIn);
    }

    void ArcBallController::Register(Engine::EngineContext* contextPtr)
    {
        contextPtr->registerObject<ArcBallController>();
    }

    void ArcBallController::Register(Script::ScriptEngine* script)
    {
        auto& backend = script->getScriptingBackend();
        backend.add(user_type<ArcBallController>(), GetTypeNameStatic());
        backend.add(base_class<InputComponent,  CameraControllerBase>());
        backend.add(base_class<CameraControllerBase, ArcBallController>());
    }

    //////////////////////////////////////////////////////////////////////////
    //ArcBallController
    //////////////////////////////////////////////////////////////////////////
    ArcBallController::ArcBallController(Engine::EngineContext* context)
        : CameraControllerBase( context )      
        , m_mouseSpeed(0.005f)
    {
        setDistance(1024.0f);
        m_pitch = static_cast<float>(HALF_PI);
    }

    void ArcBallController::prepare()
    {

    }

    void ArcBallController::input(float timeStep)
    {
        auto HandleMouse = [this](const auto& inputSystem) -> void
        {
            if (inputSystem->isMouseDown( LEFT_BUTTON | RIGHT_BUTTON))
            {
                const Vector2i mousePos = { inputSystem->getMouseMoveX(), inputSystem->getMouseMoveY() };
                
                if (m_mouseDownPos == Vector2i::ZERO)
                    m_mouseDownPos = mousePos;
                
                const auto deltaPos = (m_mouseDownPos - mousePos).convertTo<float>();
                //handle mouse look
                if ( inputSystem->isMouseDown( LEFT_BUTTON ) ) {                    
                    const auto pitchYaw = deltaPos * m_mouseSpeed;
                    setYaw( m_yaw + pitchYaw.getX() );
                    setPitch( m_pitch + pitchYaw.getY() );
                }               
                else if ( inputSystem->isMouseDown( RIGHT_BUTTON ) )  //handle panning
                {
                    pan( deltaPos.getX(), deltaPos.getY() );
                }
                m_mouseDownPos = mousePos;
            }
            else
                m_mouseDownPos = Vector2i::ZERO;
        };       

        HandleMouse( getContext()->getSystem<InputHandler>() );

        apply();
    }

    void ArcBallController::apply()
    {
        static const Vector3f VecForward(.0f, .0f, 1.f);   
        const auto rotCombined = getRotation();
        const auto newDirection = rotCombined.conjugated().transformNormal( VecForward );        
        //update node transform
        auto& nodeTrans = getEntity()->getTransform();
        nodeTrans.m_localPosition = ( newDirection * m_distance ) + m_center;
        nodeTrans.m_localRotation = rotCombined;
        //update camera
        const auto camPtr = getEntity()->getComponent<CameraComponent>();
        camPtr->updateCameraTransform();
    }

    void ArcBallController::lookAt( const Vector3f& eye, const Vector3f& target, const Vector3f& up)
    {
        const auto dir = (target - eye).getNormalized();
        const auto side = dir.cross(up).getNormalized();
        const auto newUp = side.cross(dir).getNormalized();
        const Matrix3f rotMat = { side, newUp, dir * -1.0f };
        const auto ea = Matrix3ToEulerAngle(rotMat);              
        
        setPitch( std::abs( ea.getPitch() ) ); //pitch is in [0...PI] Range
        setYaw( ea.getYaw() );
        setDistance( target.distance( eye ) );
        setCenter( target );       
    }

    void ArcBallController::pan( float x, float y )
    {
        static const Vector3f VecRight(1.f, 0.f, 0.f);
        static const Vector3f VecUp( 0.f, 1.f, 0.f);
        const auto camPtr   = getCamera();
        const auto rotCombined = getRotation().conjugated();
        const auto newRight = rotCombined.transformNormal(VecRight);
        const auto newUp    = rotCombined.transformNormal(VecUp);
        
        Math::Vector2f  xyProjCenter,
                        xyProjRight;
        bool succeed = true;
        succeed &= camPtr->projectOntoViewport( m_center, xyProjCenter );
        succeed &= camPtr->projectOntoViewport( m_center + newRight, xyProjRight );
        if ( !succeed )
            return;
        //calculate per pixel offsets 
        const auto ratio = camPtr->getHeight() / static_cast<float>(camPtr->getWidth());
        const auto dist = xyProjCenter.distance(xyProjRight);
        const auto xUnits = x / dist;
        const auto yUnits = y / ( dist * ratio );
        //Calculate & set new point of interest
        auto newCenter = m_center;       
        newCenter += newRight * xUnits;
        newCenter += newUp * (yUnits * -1.0f );
        setCenter(newCenter);
    }   

    Quatf ArcBallController::getRotation() const
    {
        const auto rotQuatX = AxisAngleToQuaternion(AxisAnglef(1.0f, 0.0f, 0.0f, m_pitch));
        const auto rotQuatZ = AxisAngleToQuaternion(AxisAnglef(0.0f, 0.0f, 1.0f, m_yaw));
        return  (rotQuatZ * rotQuatX).getNormalized();
    }
}


