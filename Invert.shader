Shader "Furari/Invert" {

    Properties {
        _MainTex ("Mask Texture", 2D) = "white" {}
    }

    SubShader {

        Tags { "Queue" = "Transparent" }

        Blend OneMinusDstColor OneMinusSrcAlpha
        BlendOp Add

        Pass {

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "UnityCG.cginc"


            struct VertInput {
                float3 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct FragInput {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;

            FragInput Vertex(VertInput vi) {
                FragInput fi;
                fi.vertex = UnityObjectToClipPos(vi.vertex);
                fi.uv = vi.uv;
                return fi;
            }

            float4 Fragment(FragInput fi) : SV_TARGET {
                float4 col = tex2D(_MainTex, fi.uv);
                return col.aaaa;
            }
            ENDHLSL
        }
    }
}
