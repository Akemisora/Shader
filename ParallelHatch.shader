Shader "Furari/ParallelHatch" {

    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", COLOR) = (1, 1, 1, 1)
        _Frequency ("Frequency", Float) = 1
        _PhaseShift ("Phase Shift", Float) = 0
        _Fill ("Fill", Range(0, 1)) = 0.5
        [Angle] _Rotation ("Rotation", Vector) = (1, 0, 1, 0)
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
            float _Frequency;
            float _PhaseShift;
            float _Fill;
            float4 _Rotation;

            FragmentInput VertexStage (VertexInput v) {
                FragmentInput f;
                f.vertex = UnityObjectToClipPos(v.vertex);
                f.uv = TRANSFORM_TEX(v.uv, _MainTex);
                f.color = v.color;
                return f;
            }

            fixed4 FragmentStage (FragmentInput f) : SV_Target {
                float x = dot(f.uv, _Rotation.xy);
                float freq = step(1, frac(x * _Frequency + _PhaseShift) + _Fill);
                float4 col = tex2D(_MainTex, f.uv) * f.color;
                return lerp(col, float4(_Color.xyz, col.a), freq);
            }
            ENDCG
        }
    }
}
