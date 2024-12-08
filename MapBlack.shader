Shader "Furari/Sprite_MapBlack" {
    
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
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
            #include "UnityCG.cginc"

            #pragma vertex VertexStage
            #pragma fragment FragmentStage

            struct VertexInput {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct FragmentInput {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            FragmentInput VertexStage(VertexInput v) {
                FragmentInput f;
                f.vertex = UnityObjectToClipPos(v.vertex);
                f.uv = TRANSFORM_TEX(v.uv, _MainTex);

                f.color = _Color * v.color;
                f.color.rgb = 1 - f.color.rgb;
                return f;
            }

            fixed4 FragmentStage(FragmentInput f) : SV_Target {
                fixed4 col = tex2D(_MainTex, f.uv);
                col.rgb = (col.rgb - 1) * f.color.rgb + 1;
                col.a *= f.color.a;
                //col.rgb = 1 - (1 - col.rgb) * (1 - _Color.rgb * i.color);     // actual form before moved to vertex shader.
                return col;
            }
            ENDCG
        }
    }
}
