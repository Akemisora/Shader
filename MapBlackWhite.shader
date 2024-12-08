Shader "Furari/Sprite_MapBlackWhite" {
    
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorBlack ("Black Tint", Color) = (0, 0, 0, 1)
        _ColorWhite ("White Tint", Color) = (1, 1, 1, 1)
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
                fixed4 color : Color;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _ColorBlack;
            float4 _ColorWhite;

            FragmentInput VertexStage(VertexInput v) {
                FragmentInput f;
                f.vertex = UnityObjectToClipPos(v.vertex);
                f.uv = TRANSFORM_TEX(v.uv, _MainTex);

                f.color = v.color;
                return f;
            }

            fixed4 FragmentStage(FragmentInput f) : SV_Target {
                fixed4 texColor = tex2D(_MainTex, f.uv);
                fixed4 mapColor = lerp(_ColorBlack, _ColorWhite, texColor.r);
                return f.color * float4(mapColor.rgb, mapColor.a * texColor.a);
            }
            ENDCG
        }
    }
}
