

struct MaterialParam
{
    vec4    m_albedoVal;
    vec4    m_emissive;
    float   m_opacity;
    float   m_metalNess;
    float   m_roughness;
    float   m_ao;

    float   m_ior;
    float   m_ssDepth;

    float   m_pad[2];
};


struct LightInfo
{
    vec3 			m_position;		
    float           m_radius;       //16
    
    vec3 			m_color;   		
    float           m_intensity;    //32

    vec3			m_direction;	
    int             m_type;         //48

    float 		    m_spotAngle;	//52
    float 		    m_spotCutOff;	//56

    float           m_padding[2]; 
};

