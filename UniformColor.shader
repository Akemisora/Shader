Shader "Furari/UniformColor" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", COLOR) = (1, 1, 1, 1)
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }
        LOD 100
        Cull Off
        Lighting Off
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            CGPROGRAM
            #pragma vertex VertexStage
            #pragma fragment FragmentStage
            #include "UnityCG.cginc"

            struct VertexInput {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct FragmentInput {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            FragmentInput VertexStage (VertexInput v) {
                FragmentInput f;
                f.vertex = UnityObjectToClipPos(v.vertex);
                f.uv = TRANSFORM_TEX(v.uv, _MainTex);
                f.color = v.color * _Color;
                return f;
            }

            fixed4 FragmentStage (FragmentInput f) : SV_Target {
                float4 col = f.color;
                col.a *= tex2D(_MainTex, f.uv).a;
                return col;
            }
            ENDCG
        }
    }
}
