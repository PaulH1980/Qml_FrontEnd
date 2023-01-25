{
  "Resources": [
    {
      "ResourceBase": {
        "ResourceName": "SkyBoxTechnique",
        "Uuid": "0fee9cbf-e738-4396-89b8-00aff85d0549",
        "LoadPolicy": "LOAD_POLICY_EAGER",
        "ResourcePath": "",
        "ResourceType": "TechniqueResource",
        "TechniqueResource": {
          "DrawPasses": [
            {
              "DrawPassResource": {
                "ResourceReference": "DrawSkyBox",
                "Enabled": true,
                "Name": "DefaultSkyBoxTechnique"
              }
            }
          ]
        }
      }
    },
    {
      "ResourceBase": {
        "ResourceName": "WireFrameTechnique",
        "Uuid": "15d59b1-2fd0-497a-9acc-2577916fbc30",
        "LoadPolicy": "LOAD_POLICY_EAGER",
        "ResourcePath": "",
        "ResourceType": "TechniqueResource",
        "TechniqueResource": {
          "DrawPasses": [
            {
              "DrawPassResource": {
                "ResourceReference": "DrawWireFrame",
                "Enabled": true,
                "Name": "DrawWireFrame"
              }
            }
          ]
        }
      }
    }
  ]
}