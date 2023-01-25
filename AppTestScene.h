#pragma  once

#include <fmt/format.h>
#include <ScriptEngine/chaiscript.hpp>
#include "AppIncludes.h"

using namespace chaiscript;
using namespace Components;
using namespace Render;

namespace Application
{
    class RotatingNode : public SceneGraphEntity
    {
    public:

        ROOT_OBJECT(RotatingNode)
        BASE_OBJECT(SceneGraphEntity)

        static void Register( Script::ScriptEngine* script )
        {
            auto& backend = script->getScriptingBackend();
            backend.add(user_type<RotatingNode>(), GetTypeNameStatic());
            backend.add(base_class<RootObject, RotatingNode>());
            backend.add(base_class<EntityBase, RotatingNode>());
            backend.add(base_class<SceneGraphEntity, RotatingNode>());
            backend.add(fun(&RotatingNode::flipDirection), "flipDirection");
            backend.add(fun(&RotatingNode::getRotationFabs), "getRotationFabs");  
        }

        static void Register(EngineContext* context) {
            context->registerObject<RotatingNode>();
        }

        RotatingNode(EngineContext* context)
            : SceneGraphEntity(context)
        {
                     
        }


        float getRotationFabs() const
        {
            return std::fabs( Math::ToDegrees(m_rotationZ));
        }

        void flipDirection()
        {
            if ( Math::ToDegrees(m_rotationZ) > 180.0f)
            {
                m_direction = -1.0f;
            }
            else if (Math::ToDegrees(m_rotationZ) < -180.0f ) {
                m_direction = 1.0f;
            }
        }

        bool postConstructor() override {

            subscribeToEvent(CreateEventHandler(this, &RotatingNode::onBeginFrame, "TIMER_BEGIN_FRAME"));
            return EntityBase::postConstructor();
        }

       /* void                    updateTransforms() override
        {
            auto& transform = getTransform();
            transform.m_rotation = Math::EulerAngleToQuaternion(EulerAnglef(0.0, m_rotationZ, 0.0f));
            transform.m_position.setX(m_positionX);
            EntityBase::updateTransforms();
        }*/

        void onBeginFrame(Event& evt)
        {
            float time = evt.getValue<float>("PARAM_TIME_STEP");
           /* m_totalTime += time;
            m_rotationZ += (time * 0.5f * m_direction);
            m_positionX = std::sinf(m_totalTime) * 256.0f;

            if (auto cs = getContext()->getSystem<ScriptEngine>())
            {
                auto& backed     = cs->getScriptingBackend();
                auto queryString =  getInternalName() + ".getInternalName();";
                auto objName     = backed.eval<std::string>( queryString );                
                auto string = getInternalName() + ".flipDirection();";
                backed.eval(string);
            }*/
        }

        float m_rotationZ = { 0.0f  };
        float m_positionX = { 0.0f  };
        float m_totalTime = { 0.0f  };
        float m_direction = { 1.0f  };
        std::string m_script;  
    };

    class SelfDestructingEntity : public EntityBase
    {
    public:
        ROOT_OBJECT(SelfDestructingEntity)
        BASE_OBJECT(EntityBase)


        static void Register(Script::ScriptEngine* script)
        {
            using Type = SelfDestructingEntity;
            auto& backend = script->getScriptingBackend();
            backend.add(user_type<Type>(), GetTypeNameStatic());
            backend.add(base_class<EntityBase, Type>());
            backend.add(base_class<RootObject, Type>());
        }

        static void Register(EngineContext* context) {
            using Type = SelfDestructingEntity;
            context->registerObject<Type>();
        }

        SelfDestructingEntity(EngineContext* context)
            : EntityBase(context)
        {

        }

        bool    postConstructor() override {

            subscribeToEvent(CreateEventHandler(this, &SelfDestructingEntity::onBeginFrame, "TIMER_BEGIN_FRAME"));
            return EntityBase::postConstructor();
        }

        void    onBeginFrame(Event& evt)
        {
            addLogMessage( "Hello entity: " + getName() + ", alive time: " + std::to_string(m_maxTime));                   
            const auto time = evt.getValue<float>("PARAM_TIME_STEP");
            m_maxTime -= time;
            if (m_maxTime < 0) {
                getParent()->removeChild( this );
            }
        }

    private:

        float       m_maxTime = { 10.0f };

    };

    class PlanetNode : public EntityBase
    {
    public:

        ROOT_OBJECT(PlanetNode)
        BASE_OBJECT(EntityBase)

        static void Register(Script::ScriptEngine* script)
        {
            auto& backend = script->getScriptingBackend();
            backend.add(user_type<PlanetNode>(), GetTypeNameStatic());
            backend.add(base_class<RootObject, PlanetNode>());
            backend.add(base_class<EntityBase, PlanetNode>());
        }

        static void Register(EngineContext* context) {
            context->registerObject<PlanetNode>();
        }

        PlanetNode(EngineContext* context)
            : EntityBase(context)
        {

        }

        bool    postConstructor() override {
            
            subscribeToEvent(CreateEventHandler(this, &PlanetNode::onBeginFrame, "TIMER_BEGIN_FRAME"));
            return EntityBase::postConstructor();
        }

        //void    updateTransforms() override
        //{
        //    auto& transform = getTransform();
        //   // transform.m_localRotation = Math::EulerAngleToQuaternion(EulerAnglef(0.0, m_rotationZ, 0.0f));
        //    EntityBase::updateTransforms();
        //}

        void    onBeginFrame(Event& evt)
        {
            float time = evt.getValue<float>("PARAM_TIME_STEP");
            //m_rotationZ -= time * 0.5f;
        }

        float m_rotationZ = { 0.0f };
    };


    DrawPassResourcePtr CreateDrawPassResource(ResourceManager* resMan)
    {
        auto defDrawPass = std::make_shared<DrawPassResource>(resMan->getContext());
        defDrawPass->setBlendState(resMan->getResourceSafe<BlendStateResource>("_DefaultBlend"));
        defDrawPass->setDepthState(resMan->getResourceSafe<DepthStateResource>("_DefaultDepth"));
        defDrawPass->setRasterizerState(resMan->getResourceSafe<RasterizerStateResource>("_DefaultRasterizer"));
        defDrawPass->setStencilState(resMan->getResourceSafe<StencilStateResource>("_DefaultStencil"));
        defDrawPass->setColorState(resMan->getResourceSafe<ColorMaskStateResource>("_DefaultColorMask"));
        defDrawPass->setShader(resMan->getResourceSafe<ShaderResource>("_DefaultShader"));
        return defDrawPass;
    }


    //////////////////////////////////////////////////////////////////////////
     //Create gold like test material
     //////////////////////////////////////////////////////////////////////////
    bool CreateBaseTestMaterials(ResourceManager* resMan) {

        Math::Vector4f rgba = { 243.0f, 201.0f, 104.0f, 255.0f };
        rgba /= 255.0f;

        int matCount = 0;
        bool succeed = true;
        for (float metalness = 0.0f; metalness <= 1.0f; metalness += 0.10f)
            for (float roughness = 0.0f; roughness <= 1.0f; roughness += 0.10f)
            {
                //material
                MaterialParam newMaterial;
                newMaterial.setAlbedo(rgba);
                newMaterial.setMetalness(metalness);
                newMaterial.setRoughness(roughness);
                const auto matName = fmt::format("TestMaterial_0{0}", matCount);
                const auto matResource = std::make_shared<BaseMaterialResource>(resMan->getContext());
                matResource->setResourceFlags(BUILT_IN | PERSISTENT);
                matResource->setMaterial(newMaterial);
                matResource->setResourceName(matName);
                succeed &= resMan->addResource(matResource);
                //draw pass
                const auto dpName = fmt::format("TestDrawpass_0{0}", matCount);
                auto drawpass = CreateDrawPassResource(resMan);
                drawpass->setShader(resMan->getResourceSafe<ShaderResource>("MaterialShader"));
                drawpass->setStatus(RESOURCE_LOADED);
                drawpass->setResourceFlags(BUILT_IN | PERSISTENT);
                drawpass->setResourceName(dpName);

                assert(drawpass->validate());

                resMan->addResource(drawpass);         
                matCount++;
                

            }
        return succeed;
    }



    inline bool CreateTestScene(EngineContext* enginePtr)
    {
       
        
        RotatingNode::Register(enginePtr);      
        PlanetNode::Register(enginePtr);      
        SelfDestructingEntity::Register(enginePtr);
        auto resMan = enginePtr->getSystem<ResourceManager>();
        auto rootObject  = enginePtr->getWorldEntity();
        auto entSystem = enginePtr->getSystem<NodeSystem>();
        auto compSystem = enginePtr->getSystem<ComponentSystem>();
        auto evtSystem = enginePtr->getSystem<EventSystem>();

        //materials
        CreateBaseTestMaterials(resMan);
        
        auto defaultChild = rootObject->createChild<CubeEntity>();
        Transform tf = defaultChild->getTransform();        
        tf.m_scale = Vector3f(64, 64, 64);
        defaultChild->setTransform(tf);

        int count = 0;

        for (int x = -512; x <= 512; x += 128 )
        {
            for (int y = -512; y <= 512; y+= 128 )
            {
                auto clone = defaultChild->clone();             
                tf.m_position = Vector3f((float)x, (float)y, (float)0);
                clone->setTransform(tf);
                auto cloneComp = clone->getComponent<EditableComponent>();
                const auto dpName = fmt::format("TestDrawpass_0{0}", count);
                cloneComp->setDrawPass(resMan->getResourceSafe<DrawPassResource>(dpName));
                rootObject->addChild(clone);
                count++;
            }
        }        
        rootObject->createChild<SelfDestructingEntity>();

     
        //for (int i = 0; i < 1; ++i) {
        //   
        //    EntityBase* root = rootObject->createChild<EntityBase>();
        //    EntityBase* parentEnt = root;
        //    //childs 3 levels deep
        //    for (int i = 0; i < 3; ++i) {
        //        parentEnt = parentEnt->createChild<EntityBase>();
        //    }
        //    auto *child = parentEnt->createChild<CubeEntity>();            
        //    
        //    float x = static_cast<float>(i) * 100.0f;
        //    //auto childObj = rootObject->createChild<CubeEntity>();
        //    Transform tf;
        //    tf.m_position = Vector3f{ x, 0.0f, 0.0f };
        //    tf.m_scale    = Vector3f(100, 100, 100 + i );
        //    child->setTransform(tf);

        //    auto childCount = entSystem->size();
        //    auto compCount  = compSystem->size();
        //    auto evtHandlerCount = evtSystem->size();

        //    auto childClone = root->clone();
        //    rootObject->addChild(childClone);
        //    
        //    auto afterChildCount = entSystem->size();
        //    auto afterCompCount = compSystem->size();
        //    auto afterEvtHandlerCount = evtSystem->size();
        //    rootObject->removeChild(childClone);

        //    auto afterDeleteChildCount = entSystem->size();
        //    auto afterDeleteCompCount  = compSystem->size();
        //    auto afterDeleteEvtHandlerCount = evtSystem->size();

        //    tf.m_scale.m_Z = 300;
        //    tf.m_position = Vector3f{ x, 200.0f, 0.0f };

        //    
        //    
        //    //childObj->setTransform(tf);
        //  //  rootObject->addChild(childClone);

        //}


       /* 
        std::string cubeName, sphereName;        
        {
            auto sphereData = CreateSphereData( enginePtr, 8, 8, 1.0f );
            auto cubeData   = CreateCubeData( enginePtr, 1, 1, 1, 1 );
            resMan->addResource(sphereData);
            resMan->addResource(cubeData);
            cubeName = cubeData->getResourceName();
            sphereName = sphereData->getResourceName();
        }
      
        auto rootObject = enginePtr->getRootNodePtr();
        auto childPtrNew = rootObject->createChild<RotatingNode>();
        {
            auto& transform = childPtrNew->getTransform();
            transform.m_localPosition = Vector3f(0, 0, 0);
            transform.m_localScale = Vector3f(50.0f);
            const auto& mesh = childPtrNew->createComponent<MeshComponent>();
            mesh->setResourceData( resMan->getResource( cubeName ) );
        }
        Math::Vector3f offsets[4] = { { 1, 0, 0 }, { -1, 0, 0 }, { 0, 1, 0 }, { 0, -1, 0 } };
        for (int i = 0; i < 4; ++i) {
            auto childOfChild = childPtrNew->createChild<PlanetNode>();
            auto& transform = childOfChild->getTransform();
            transform.m_localPosition = offsets[i] * 200.0f;
            transform.m_localScale = Vector3f(25.0f);
            const auto& mesh = childOfChild->createComponent<MeshComponent>();
            mesh->setResourceData(resMan->getResource(sphereName));
            {
                auto childofChildOfChild = childOfChild->createChild<PlanetNode>();
                auto& transform = childofChildOfChild->getTransform();
                transform.m_localPosition = offsets[i] * 50.0f;
                transform.m_localScale = Vector3f(3.0f);
                const auto& mesh = childofChildOfChild->createComponent<MeshComponent>();
                mesh->setResourceData( resMan->getResource(sphereName) );
            }
        }*/
        return true;
    }
}