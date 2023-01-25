{
  "Resources": [
    {
      "ResourceBase": {
        "ResourceName": "DrawSkyBox",
        "Uuid": "70c0e42-4731-40bd-8ca1-335aba15b0fb",
        "LoadPolicy": "LOAD_POLICY_EAGER",
        "ResourceFlags": [ "PERSISTENT" ],
        "ResourcePath": "",
        "ResourceType": "DrawPassResource",
        "DrawPassResource": {
          "DepthStateResource": {
            "ResourceReference": "_DefaultDepthDisabled"
          },
          "BlendStateResource": {
            "ResourceReference": "_DefaultBlend"
          },
          "RasterizerStateResource": {
            "ResourceReference": "_DefaultRasterizer"
          },
          "ColorMaskStateResource": {
            "ResourceReference": "_DefaultColorMask"
          },
          "StencilStateResource": {
            "ResourceReference": "_DefaultStencil"
          },
          "ShaderResource": {
            "ResourceReference": "RayleighShader"
          },
          "TextureResource": [],
          "MaterialResource": []
        }
      }
    },
    {
      "ResourceBase": {
        "ResourceName": "DefaultDrawPass",
        "Uuid": "7efbc4d28-3bf5-46c9-9725-e5be3ec95838",
        "LoadPolicy": "LOAD_POLICY_EAGER",
        "ResourceFlags": [ "PERSISTENT" ],
        "ResourcePath": "",
        "ResourceType": "DrawPassResource",
        "DrawPassResource": {
          "ShaderResource": {
            "ResourceReference": "MeshShader"
          },
          "TextureResource": [
            {
              "ResourceReference": "_DefaultAlbedo",
              "UniformName": "albedoTex"
            }
          ],
          "MaterialResource": []
        }
      }
    },
    {
      "ResourceBase": {
        "ResourceName": "DrawWireFrame",
        "Uuid": "64abee72-79d5-478f-8f37-f7ae25f3db2c",
        "LoadPolicy": "LOAD_POLICY_EAGER",
        "ResourceFlags": [ "PERSISTENT" ],
        "ResourcePath": "",
        "ResourceType": "DrawPassResource",
        "DrawPassResource": {
          "DepthStateResource": {
            "ResourceReference": "_DefaultDepthDisabled"
          },
          "BlendStateResource": {
            "ResourceReference": "_DefaultBlend"
          },
          "RasterizerStateResource": {
            "ResourceReference": "_DefaultRasterizer"
          },
          "ColorMaskStateResource": {
            "ResourceReference": "_DefaultColorMask"
          },
          "StencilStateResource": {
            "ResourceReference": "_DefaultStencil"
          },
          "ShaderResource": {
            "ResourceReference": "MeshWireFrameShader"
          },
          "TextureResource": [],
          "MaterialResource": []
        }
      }
    },
    {
      "ResourceBase": {
        "ResourceName": "GrayMaterialDrawPass",
        "Uuid": "991de57d-b399-4ca3-b0f5-2c43328ebf3b",
        "LoadPolicy": "LOAD_POLICY_EAGER",
        "ResourcePath": "",
        "ResourceType": "DrawPassResource",
        "DrawPassResource": {
          "ShaderResource": {
            "ResourceReference": "MeshShader"
          },
          "TextureResource": [],
          "MaterialResource": [
            {
              "ResourceReference": "GrayMaterial",
              "UniformName": "MaterialUbo"
            }
          ]
        }
      }
    },
    {
          "ResourceBase": {
            "ResourceName": "MeshDrawPass",
            "Uuid": "991de57d-b399-4ca3-b0f5-2c43328ebf3b",
            "LoadPolicy": "LOAD_POLICY_EAGER",
            "ResourcePath": "",
            "ResourceType": "DrawPassResource",
            "DrawPassResource": {
              "ShaderResource": {
                "ResourceReference": "MeshShader"
              },
              "TextureResource": [],
              "MaterialResource": [
                {
                  "ResourceReference": "GrayMaterial",
                  "UniformName": "MaterialUbo"
                }
              ]
            }
          }
        }
        ]
      }