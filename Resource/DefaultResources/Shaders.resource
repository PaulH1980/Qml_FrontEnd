{
    "Resources": [
        {
          "ResourceBase": {
            "ResourceName": "FlatShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "21ee2196-6741-491d-a6f0-391b97a8dbb7",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "File": "DefaultShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "octahedron.glsl",
                  "global.glsl",
                  "FragShaderInput.glsl",
                  "lightbuffer.glsl"
                ],
                "File": "DefaultShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "IconShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "0b81a9fc-031e-48bf-aef4-6be8c3246e84",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "IconShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "IconShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "SelectionShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "f28933c2-7123-45cb-b3ea-6240b992256c",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "SelectionShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "SelectionShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "MeshShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "8c6b8ac5-4a43-4dfe-94b0-c8ead1698e4a",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "File": "MeshShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "octahedron.glsl",
                  "global.glsl",
                  "FragShaderInput.glsl",
                  "lightbuffer.glsl"
                ],
                "Defines": [
                  "USE_METALMAP",
                  "USE_NORMALMAP",
                  "USE_ROUGHNESSMAP",
                  "USE_ALBEDOMAP",
                  "COOK_BECKMANN",
                  "COOK"
                ],
                "File": "MeshShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "BrushShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "a9337da9-acef-481b-8da8-b599d2494284",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "DefaultVertexFormat.glsl",
                  "ObjectTransform.glsl",
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "File": "BrushShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "octahedron.glsl",
                  "global.glsl",
                  "FragShaderInput.glsl"
                ],
                "Defines": [],
                "File": "BrushShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "GradientBrushShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "c0e87d41-3f35-4c8f-a0d6-4ce2d2593ad3",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "DefaultVertexFormat.glsl",
                  "ObjectTransform.glsl",
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "File": "BrushShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "octahedron.glsl",
                  "global.glsl",
                  "FragShaderInput.glsl"
                ],
                "Defines": [],
                "File": "GradientBrushShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "TexturedBrushShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "db60df87-b941-4adf-bc6f-41a36ca196f9",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "DefaultVertexFormat.glsl",
                  "ObjectTransform.glsl",
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "File": "BrushShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "octahedron.glsl",
                  "global.glsl",
                  "FragShaderInput.glsl"
                ],
                "Defines": [],
                "File": "TexturedBrushShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "RayleighShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "1ee563b5-a6e9-49e9-9752-ea054a102bc8",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "Rayleigh.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl",
                  "FragShaderInput.glsl",
                  "Rayleigh.glsl"
                ],
                "Defines": [],
                "File": "Rayleigh.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "ShadowMap",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "ac02aaca-b2c7-4477-9adb-3bd4f89f1369",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "ShadowMap.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl",
                  "FragShaderInput.glsl"
                ],
                "Defines": [],
                "File": "ShadowMap.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "LineShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "2fda3dd5-a940-4bac-a60d-42144d67107d",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "LineShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "Defines": [],
                "File": "LineShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "MeshWireFrameShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "c71dde32-b69a-44fc-a1b6-a55d672b650c",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "WireframeShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl",
                  "FragShaderInput.glsl"
                ],
                "Defines": [],
                "File": "DefaultShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "LineShaderSmoothNormal",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "56f4805d-ac19-4645-ba70-1e2216c083de",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "DefaultVertexFormat.glsl",
                  "ObjectTransform.glsl",
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "File": "LineSmooth.vert"
              },
              "Geometry": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "LineShader.geom"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "Defines": [
                  "USE_DASH_TEXTURE"
                ],
                "File": "LineShaderGeom.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "LineShaderSmooth",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "8d5e4683-e516-4fc0-a626-28d6007d5c5f",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "DefaultVertexFormat.glsl",
                  "ObjectTransform.glsl",
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "File": "LineSmooth.vert"
              },
              "Geometry": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "LineSmooth.geom"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "Defines": [
                  "USE_DASH_TEXTURE"
                ],
                "File": "LineShaderGeom.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "LassoShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "8272a0dc-1010-47ff-926e-a06b5abb6d75",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "LassoShader.vert"
              },
              "Geometry": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "LineSmooth.geom"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "Defines": [],
                "File": "LineShaderGeom.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "MaterialShader",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "67fcd7f8-5f32-4980-bb51-832b6cb87f04",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "File": "MeshShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "octahedron.glsl",
                  "global.glsl",
                  "FragShaderInput.glsl",
                  "lightbuffer.glsl"
                ],
                "Defines": [
                  "COOK_BECKMANN",
                  "OUTPUT_MATERIAL",
                  "COOK"
                ],
                "File": "MeshShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "RenderAlbedoToCube",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "7de647d8-6539-485b-b904-b8a9a7a56412",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl",
                  "octahedron.glsl"
                ],
                "defines": [
                  "RENDER_ALBEDO_TO_CUBE"
                ],
                "File": "MeshShader.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "octahedron.glsl",
                  "global.glsl",
                  "FragShaderInput.glsl"
                ],
                "Defines": [
                  "RENDER_ALBEDO_TO_CUBE",
                  "USE_ALBEDOMAP"
                ],
                "File": "MeshShader.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "OriginAxis",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "0a3d6216-9022-480f-b38d-f691294cc763",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "File": "OriginAxis.vert"
              },
              "Fragment": {
                "Version": "440",
                "File": "OriginAxis.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "Irradiance",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "715607e8-f430-426c-bb98-177fa2658443",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Vertex": {
                "Version": "440",
                "Includes": [
                  "global.glsl"
                ],
                "File": "Irradiance.vert"
              },
              "Fragment": {
                "Version": "440",
                "Includes": [
                  "Irradiance.glsl"
                ],
                "File": "Irradiance.frag"
              }
            }
          }
        },
        {
          "ResourceBase": {
            "ResourceName": "ComputeTest",
            "ResourceFlags": [ "PERSISTENT" ],
            "Uuid": "287e2d41-a822-4ca2-9ca9-e926a6b7e42b",
            "ResourceType": "ShaderResource",
            "ShaderResource": {
              "Compute": {
                "Version": "440",
                "File": "Test.compute"
              }
            }
          }
        }
    ]
}