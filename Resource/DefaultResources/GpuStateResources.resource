 {
    "Resources": [
        {
          "ResourceBase": {
            "ResourceName": "EnabledColorMask",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "ad2a9734-31cb-46c0-b949-05747beebca7",
            "ResourceType": "ColorMaskStateResource",
            "ColorMaskStateResource": {
              "RedMask": true,
              "GreenMask": true,
              "BlueMask": true,
              "AlphaMask": true
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "DisabledColorMask",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "58c73f1b-97f6-4fa7-8665-3547e15e0459",
            "ResourceType": "ColorMaskStateResource",
            "ColorMaskStateResource": {
              "RedMask":   false,
              "GreenMask": false,
              "BlueMask":  false,
              "AlphaMask": false
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "NoAlphaWrite",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "8adea0da-f8d5-416d-9a2e-cfd5780ea246",
            "ResourceType": "ColorMaskStateResource",
            "ColorMaskStateResource": {
              "RedMask": true,
              "GreenMask": true,
              "BlueMask": true,
              "AlphaMask": false
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "NoColorWrite",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "7cf5a344-dbfb-4d32-b168-7f471363d2d5",
            "ResourceType": "ColorMaskStateResource",
            "ColorMaskStateResource": {
              "RedMask": false,
              "GreenMask": false,
              "BlueMask": false,
              "AlphaMask": true
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "DefaultStencil",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "72ab04a9-ba9c-4f26-b179-8ca83ad4feec",
            "ResourceType": "StencilStateResource",
            "StencilStateResource": {
              "StencilFunc": "ALWAYS",
              "StencilRefFunc": 0,
              "StencilMaskFunc": 255,
              "StencilFail": "KEEP",
              "DepthFail": "KEEP",
              "StencilDepthPass": "KEEP",
              "StencilEnable": false,
              "StencilEnabled": false,
              "StencilMaskVal": 255
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "DefaultBlend",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "a70823b8-acbb-4f49-ac7e-6effe34a8586",
            "ResourceType": "BlendStateResource",
            "BlendStateResource": {
              "SrcFactorRGB": "ONE",
              "DstFactorRGB": "ZERO",
              "SrcFactorAlpha": "ONE",
              "DstFactorAlpha": "ZERO",
              "BlendModeRGB": "FUNC_ADD",
              "BlendModeAlpha": "FUNC_ADD",
              "BlendSeparate": false,
              "Enabled": false
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "AlphaBlend",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "815ff357-f34d-449e-8852-09ab7827286a",
            "ResourceType": "BlendStateResource",
            "BlendStateResource": {
              "SrcFactorRGB": "SRC_ALPHA",
              "DstFactorRGB": "ONE_MINUS_SRC_ALPHA",
              "SrcFactorAlpha": "SRC_ALPHA",
              "DstFactorAlpha": "ONE_MINUS_SRC_ALPHA",
              "BlendModeRGB": "FUNC_ADD",
              "BlendModeAlpha": "FUNC_ADD",
              "BlendSeparate": false,
              "Enabled": true
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "DefaultDepth",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "b0e256c1-3e27-4c12-b01c-2cdf5c75d1e6",
            "ResourceType": "DepthStateResource",
            "DepthStateResource": {
              "DepthMask": true,
              "DepthTest": true,
              "MinDepth": 0,
              "MaxDepth": 1,
              "Enabled": true,
              "DepthFunc": "LEQUAL"
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "DepthDisabled",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "fe7df9f9-5bd1-4f2e-a9c2-cbb14a6d4330",
            "ResourceType": "DepthStateResource",
            "DepthStateResource": {
              "DepthMask": false,
              "DepthTest": false,
              "MinDepth": 0,
              "MaxDepth": 1,
              "Enabled": true,
              "DepthFunc": "ALWAYS"
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "DepthBuffer",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "8bc1b82e-3c54-4d24-b2ae-5bcd28ceab5a",
            "ResourceType": "SamplerStateResource",
            "SamplerStateResource": {
              "MagFilter": "LINEAR",
              "MinFilter": "LINEAR",
              "WrapR": "CLAMP_TO_EDGE",
              "WrapS": "CLAMP_TO_EDGE",
              "WrapT": "CLAMP_TO_EDGE",
              "DepthCompareFunc": "LEQUAL",
              "TextureCompareMode": "COMPARE_R_TO_TEXTURE",
              "DepthTextureMode": "LUMINANCE",
              "MipMaps": false,
              "AutoGenMips": false,
              "Aniso": 0
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "DefaultSampler",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "ae481cf7-052c-4994-9787-adcbff1c7071",
            "ResourceType": "SamplerStateResource",
            "SamplerStateResource": {
              "MagFilter": "LINEAR",
              "MinFilter": "LINEAR",
              "WrapR": "REPEAT",
              "WrapS": "REPEAT",
              "WrapT": "REPEAT",
              "DepthCompareFunc": "NONE",
              "TextureCompareMode": "NONE",
              "DepthTextureMode": "NONE",
              "MipMaps": false,
              "AutoGenMips": false,
              "Aniso": 0
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "Nearest",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "d4868780-be82-4e40-9707-e3df14e8ccc7",
            "ResourceType": "SamplerStateResource",
            "SamplerStateResource": {
              "MagFilter": "NEAREST",
              "MinFilter": "NEAREST",
              "WrapR": "REPEAT",
              "WrapS": "REPEAT",
              "WrapT": "REPEAT",
              "DepthCompareFunc": "NONE",
              "TextureCompareMode": "NONE",
              "DepthTextureMode": "NONE",
              "MipMaps": false,
              "AutoGenMips": false,
              "Aniso": 0
            }
          }
        },
        {
            "ResourceBase": {
                "ResourceName": "DefaultRasterizer",
                "Uuid": "56cc4024-108b-4323-995b-d2df1da191b1",
                "ResourceType": "RasterizerStateResource",
                "RasterizerStateResource": {
                    "CullMode": "BACK",
                    "FrontFace": "CCW",
                    "FillMode": "FILL",
                    "PolyModeFace": "FRONT_AND_BACK",
                    "MultiSample": false,
                    "Enabled": true,
                    "Scissor": true
                }
            }
        },
        {
          "ResourceBase": {
            "ResourceName": "DisableCull",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "61d797da-7367-438d-bc70-bc6bb6839596",
            "ResourceType": "RasterizerStateResource",
            "RasterizerStateResource": {
              "CullMode": "BACK",
              "FrontFace": "CCW",
              "FillMode": "FILL",
              "PolyModeFace": "FRONT_AND_BACK",
              "Enabled": false,
              "MultiSample": false,
              "Scissor": true
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "CullClockWise",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "3957b02b-9e9e-471e-858a-01b6cd3ff2bb",
            "ResourceType": "RasterizerStateResource",
            "RasterizerStateResource": {
              "CullMode": "BACK",
              "FrontFace": "CW",
              "FillMode": "FILL",
              "PolyModeFace": "FRONT_AND_BACK",
              "Enabled": true,
              "MultiSample": false,
              "Scissor": true
            }
          }
        }
    ]
}