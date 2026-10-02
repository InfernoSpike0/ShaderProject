Shader "Shader YourName/FirstShaderURP"
{    
    Properties
    { 
        // Q1: Which two properties can be controlled through the Material
        // Inspector? What type of data does each property represent?

        _BaseColor("Base Color", Color) = (1, 1, 1, 1)
        _BaseMap("Base Map", 2D) = "white"
    }

    SubShader
    {        
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }

        Pass
        {            
            HLSLPROGRAM

            // Q2: Which shader stages do the following two directives define?
            // What functions are associated with each stage?

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            

            struct Attributes
            {
                // Q3: What information do POSITION and TEXCOORD0 provide
                // to the vertex shader?

                float4 positionOS : POSITION; 
                float2 uv         : TEXCOORD0;
            };

            struct Varyings
            {
                // Q4: Why must positionHCS use SV_POSITION?
                // Why does uv use TEXCOORD0?

                float4 positionHCS : SV_POSITION;
                float2 uv          : TEXCOORD0;
            };

            // Q5: What is the purpose of declaring both a texture
            // and a sampler? What role does each one perform?

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)

                // Q6: Why are these variables declared inside
                // the UnityPerMaterial constant buffer?
                //
                // What is the purpose of the _ST suffix in _BaseMap_ST?

                half4 _BaseColor;  
                float4 _BaseMap_ST;

            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                // Q7: What coordinate space does positionOS represent?
                // What coordinate space is produced by TransformObjectToHClip()?
                //
                // Why is this transformation necessary before the vertex
                // can be rendered?

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);

                // Q8: What happens to the UV coordinates here?
                //
                // Predict what will happen to the texture if its Tiling
                // is changed from (1,1) to (2,2) in the Material Inspector.

                OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // Q9: Explain the purpose of each of the three arguments
                // passed to SAMPLE_TEXTURE2D().
                //
                // Where do the UV coordinates used here originate?

                half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);

                // Q10: Predict the result if _BaseColor is set to
                // (1, 0, 0, 1). How would white, gray, and blue areas
                // of the original texture be affected?
                //
                // Explain why multiplication is used here instead of addition.

                half4 finalColor = color * _BaseColor;

                // Q11: Modify the shader so that it displays ONLY _BaseColor
                // and ignores the texture.
                //
                // Q12: Modify it again so that it displays ONLY the texture
                // and ignores _BaseColor.
                //
                // What is the minimum code change required in each case?

                return finalColor;
            }

            ENDHLSL
        }
    }
}