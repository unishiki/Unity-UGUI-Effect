Shader "Unlit/HSVInRect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MousePos ("MousePos", Vector) = (0,0,0,0)
        [hideInInspector] _ColorSelected ("ColorSelected", Color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Transparent"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define RADIUS_THICKNESS_SELECTOR 0.01
            #define RADIUS_SELECTOR 0.09

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MousePos;
            float4 _ColorSelected;

            float sdCircle(float2 p, float r)
            {
                return length(p) - r;
            }
            float opAnnular(float sdf, float r)
            {
                return abs(sdf) - r;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col_S;
                fixed4 col_V;
                col_S.rgb = lerp(fixed3(1,1,1), _ColorSelected.rgb, i.uv.x);
                col_S.a = 1;
                col_V.rgb = i.uv.yyy;
                col_V.a = 1;

                i.uv.y = 1.0 - i.uv.y;
                i.uv = i.uv * 2 - 1;
                float w = _ScreenParams.x;
                float h = _ScreenParams.y;
                float step = 1.0 / w;

                fixed4 annularInAnnular;
                fixed2 annularPos = i.uv;
                annularPos.x -= _MousePos.x;
                annularPos.y += _MousePos.y;
                annularInAnnular = smoothstep(step, -step, opAnnular(sdCircle(annularPos, RADIUS_SELECTOR) , RADIUS_THICKNESS_SELECTOR));

                return saturate(col_V * col_S + annularInAnnular);
            }
            ENDCG
        }
    }
}
