{
  "Resources": [
    {
      "FlowNodeInfo": {
        "Annotations": {
          "$Name": "ViewPortParameters",
          "$ShowInUi": true,
          "$SubSection": "Input/GpuBuffers",
          "$PreferredWidth": 240,
          "$Title": "ViewPortParameters"
        },
        "FlowNodeType": "UniformShaderBlock"
      },
      "ResourceBase": {
        "ResourceName": "ViewPortParameters",
        "Uuid": "0d113ed5-6aa6-47b7-9b9f-4819c314d76b",
        "ResourceType": "GpuBufferResource",
        "ResourceFlags": [
          "PERSISTENT"
        ],
        "GpuBufferResource": {
          "MaxInstances": 32,
          "Access": "WRITE_ONLY",
          "Type": "SHADER_STORAGE_BUFFER",
          "Usage": "DYNAMIC_DRAW",
          "BindLocation": 1
        },
        "UniformLayoutDescriptor": [
          {
            "Type": "mat4",
            "Name": "WorldToView",
            "ShowInUi": true
          },
          {
            "Type": "mat4",
            "Name": "WorldToViewInv",
            "ShowInUi": true
          },
          {
            "Type": "mat4",
            "Name": "WorldToViewPrev",
            "ShowInUi": true
          },
          {
            "Type": "mat4",
            "Name": "Projection",
            "ShowInUi": true
          },
          {
            "Type": "mat4",
            "Name": "View",
            "ShowInUi": true
          },
          {
            "Type": "mat4",
            "Name": "Normal",
            "ShowInUi": true
          },
          {
            "Type": "mat4",
            "Name": "Ortho",
            "ShowInUi": true
          },
          {
            "Type": "mat4",
            "Name": "Sky",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "Name": "Position",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "Name": "Ambient",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "Name": "SunDirection",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "ArraySize": 6,
            "Name": "ClipPlanes",
            "ShowInUi": true
          },
          {
            "Type": "vec2",
            "Name": "FrameBuffer",
            "ShowInUi": true
          },
          {
            "Type": "vec2",
            "Name": "FrameBufferInv",
            "ShowInUi": true
          },
          {
            "Type": "vec2",
            "Name": "FrameBufferStart",
            "ShowInUi": true
          },
          {
            "Type": "vec2",
            "Name": "NearFar",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "RootSize",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "PixelScale",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "FrameTime",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "ProgramTime",
            "ShowInUi": true
          },
          {
            "Type": "int",
            "Name": "FrameNumber",
            "ShowInUi": true
          },
          {
            "Type": "uint",
            "Name": "ClipPlaneMask",
            "ShowInUi": true
          },
          {
            "Type": "int",
            "Name": "Padding",
            "ArraySize": 2,
            "ShowInUi": false
          }
        ]
      }
    },
    {
      "FlowNodeInfo": {
        "Annotations": {
          "$Name": "LightBuffer",
          "$ShowInUi": true,
          "$SubSection": "Input/GpuBuffers",
          "$PreferredWidth": 240,
          "$Title": "LightBuffer"
        },
        "FlowNodeType": "UniformShaderBlock"
      },
      "ResourceBase": {
        "ResourceName": "LightBuffer",
        "Uuid": "43388c72-5edb-41f8-bd2c-fb5467cdf9fa",
        "ResourceType": "GpuBufferResource",
        "ResourceFlags": [
          "PERSISTENT"
        ],
        "GpuBufferResource": {
          "MaxInstances": 16384,
          "FlowNodeType": "UniformShaderBlock",
          "Access": "WRITE_ONLY",
          "Type": "SHADER_STORAGE_BUFFER",
          "Usage": "DYNAMIC_DRAW",
          "BindLocation": 2
        },
        "UniformLayoutDescriptor": [
          {
            "Type": "vec4",
            "Name": "PositionAndRadius",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "Name": "ColorAndIntensity",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "Name": "DirectionAndType",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "SpotAngle",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "SpotCutOff",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "Padding",
            "ShowInUi": false,
            "ArraySize": 2
          }
        ]
      }
    },
    {
      "FlowNodeInfo": {
        "Annotations": {
          "$Name": "ObjectTransforms",
          "$ShowInUi": false,
          "$SubSection": "Input/GpuBuffers",
          "$PreferredWidth": 240,
          "$Title": "ObjectTransforms"
        },
        "FlowNodeType": "UniformShaderBlock"
      },
      "ResourceBase": {
        "ResourceName": "ObjectTransforms",
        "Uuid": "ba3946f3-c644-476c-891d-c7c236a0c763",
        "ResourceType": "GpuBufferResource",
        "ResourceFlags": [
          "PERSISTENT"
        ],
        "GpuBufferResource": {
          "MaxInstances": 1048576,
          "FlowNodeType": "UniformShaderBlock",
          "Access": "WRITE_ONLY",
          "Type": "SHADER_STORAGE_BUFFER",
          "Usage": "DYNAMIC_DRAW",
          "BindLocation": 3
        },
        "UniformLayoutDescriptor": [
          {
            "Type": "mat4",
            "Name": "ObjectTransform",
            "ShowInUi": false
          }
        ]
      }
    },
    {
      "FlowNodeInfo": {
        "Annotations": {
          "$Name": "MaterialTextured",
          "$ShowInUi": true,
          "$SubSection": "Input/GpuBuffers",
          "$PreferredWidth": 240,
          "$Title": "MaterialTextured"
        },
        "FlowNodeType": "UniformShaderBlock"
      },
      "ResourceBase": {
        "ResourceName": "MaterialTextured",
        "Uuid": "b811df5b-0e86-48f6-8c19-c149cbd2c5d5",
        "ResourceType": "GpuBufferResource",
        "ResourceFlags": [
          "PERSISTENT"
        ],
        "GpuBufferResource": {
          "FlowNodeType": "UniformShaderBlock",
          "Access": "WRITE_ONLY",
          "Type": "SHADER_STORAGE_BUFFER",
          "Usage": "DYNAMIC_DRAW",
          "MaxInstances": 16384,
          "BindLocation": 4
        },
        "UniformLayoutDescriptor": [
          {
            "Type": "uint64",
            "Name": "Sampler0",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler1",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler2",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler3",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler4",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler5",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler6",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler7",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler8",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler9",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler10",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler11",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler12",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler13",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler14",
            "ShowInUi": true
          },
          {
            "Type": "uint64",
            "Name": "Sampler15",
            "ShowInUi": true
          }
        ]
      }
    },
    {
      "FlowNodeInfo": {
        "Annotations": {
          "$Name": "Material",
          "$ShowInUi": true,
          "$SubSection": "Input/GpuBuffers",
          "$PreferredWidth": 240,
          "$Title": "MaterialUbo"
        },
        "FlowNodeType": "UniformShaderBlock"
      },
      "ResourceBase": {
        "ResourceName": "Material",
        "Uuid": "ce32962d-313b-46da-8a33-cd9fd9b44a73",
        "ResourceType": "GpuBufferResource",
        "ResourceFlags": [
          "PERSISTENT"
        ],
        "GpuBufferResource": {
          "FlowNodeType": "UniformShaderBlock",
          "Access": "WRITE_ONLY",
          "Type": "UNIFORM_BUFFER",
          "Usage": "DYNAMIC_DRAW",
          "MaxInstances": 16384,
          "BindLocation": 5
        },
        "UniformLayoutDescriptor": [
          {
            "Type": "vec4",
            "Name": "Albedo",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "Name": "Emissive",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "Opacity",
            "ShowInUi": true,
            "Min": 0.0,
            "Max": 1.0
          },
          {
            "Type": "float",
            "Name": "Metalness",
            "ShowInUi": true,
            "Min": 0.0,
            "Max": 1.0
          },
          {
            "Type": "float",
            "Name": "Roughness",
            "ShowInUi": true,
            "Min": 0.0,
            "Max": 1.0
          },
          {
            "Type": "float",
            "Name": "AmbientOcclusion",
            "ShowInUi": true,
            "Min": 0.0,
            "Max": 1.0
          },
          {
            "Type": "float",
            "Name": "IndexOfRefraction",
            "ShowInUi": true,
            "Min": 0.0,
            "Max": 1.0
          },
          {
            "Type": "float",
            "Name": "SubSurfaceDepth",
            "ShowInUi": true,
            "Min": 0.0,
            "Max": 1.0
          },
          {
            "Type": "float",
            "Name": "Height",
            "ShowInUi": true,
            "Min": 0.0
          },
          {
            "Type": "float",
            "Name": "ClearCoat",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "ClearCoatStrength",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "Anisotropic",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "Padding",
            "ArraySize" : 2,
            "ShowInUi": false
          }
        ]
      }
    },
    {
      "FlowNodeInfo": {
        "Annotations": {
          "$Name": "SkyBox",
          "$ShowInUi": true,
          "$SubSection": "Input/GpuBuffers",
          "$PreferredWidth": 240,
          "$Title": "SkyBoxBuffer"

        },
        "FlowNodeType": "UniformShaderBlock"
      },
      "ResourceBase": {
        "ResourceName": "SkyBox",
        "ResourceFlags": [
          "PERSISTENT"
        ],
        "Uuid": "4d547a7f-e691-4524-9b7c-4679f905129c",
        "ResourceType": "GpuBufferResource",
        "GpuBufferResource": {
          "Name": "SkyBox",
          "Size": 64,
          "FlowNodeType": "UniformShaderBlock",
          "Access": "WRITE_ONLY",
          "Type": "SHADER_STORAGE_BUFFER",
          "Usage": "DYNAMIC_DRAW",
		  "MaxInstances": 32,
          "BindLocation": 6
        },
        "UniformLayoutDescriptor": [
          {
            "Type": "vec4",
            "Name": "Origin",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "Name": "SunPosition",
            "ShowInUi": true
          },
          {
            "Type": "vec4",
            "Name": "RayLeighScatCoeff",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "Intensity",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "RadiusPlanet",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "RadiusAtmos",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "MieScatCoeff",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "MieScatDir",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "MieScaleHeight",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "RayLeighScaleHeight",
            "ShowInUi": true
          },
          {
            "Type": "float",
            "Name": "Padding",
            "ShowInUi": false
          }
        ]
      }
    }
  ]
}