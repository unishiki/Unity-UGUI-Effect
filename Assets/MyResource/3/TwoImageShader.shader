Shader "Unlit/TwoImageShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TwoTex ("TwoTexture", 2D) = "white" {}
        [HDR]_Color ("Color", Color) = (1,1,1,1)
        [hideinInspector] _MousePos ("MousePos", Vector) = (0,0,0,0)
        _Redius ("Redius", float) = 40
        _Offset ("Offset", Range(0, 1)) = 0
        _Pow ("Pow", Range(0, 2)) = 1
        _ColorAmount ("ColorAmount", Range(0.5, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha

        // Alpha0
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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
            fixed4 _MousePos;
            float _Redius;
            float _Offset;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float dis = distance(_MousePos.xy, i.vertex.xy);
                col.a = saturate(col.a - smoothstep(_Redius, 0, dis) + _Offset * sign(col.a-0.1));
                return col;
            }
            ENDCG
        }
        // Image_2
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            fixed4 _MousePos;
            float _Redius;
            float _Offset;
            float _Pow;
            float _ColorAmount;

            sampler2D _TwoTex;
            float4 _TwoTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _TwoTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_TwoTex, i.uv);
                float dis = distance(_MousePos.xy, i.vertex.xy);
                col.a = saturate(smoothstep(_Redius, 0, dis) - _Offset) * _ColorAmount;
                col.a =  col.a * _Pow;
                return col;
            }
            ENDCG
        }
        // Color
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            fixed4 _MousePos;
            float _Redius;
            float _Offset;
            float4 _Color;
            float _Pow;
            sampler2D _TwoTex;
            float4 _TwoTex_ST;
            float _ColorAmount;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _TwoTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;
                float dis = distance(_MousePos.xy, i.vertex.xy);
                col.a = saturate(smoothstep(_Redius, 0, dis) - _Offset) * _ColorAmount;
                return col;
            }
            ENDCG
        }
    }
}
