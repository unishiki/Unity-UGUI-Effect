Shader "Unlit/Btn1Shader"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _MousePos ("MousePos", Vector) = (0,0,0,0)
        _ColorRedius ("ColorRedius", float) = 40
        _Color ("Color", Color) = (0,0,0,1)
        _ColorOffset ("ColorOffset", Range(0, 1)) = 0
        _ColorPow ("ColorPow", Range(0, 1)) = 0.5
        _BorderTex ("BorderTex", 2D) = "white" {}
        _BorderColorMul ("BorderColorPow", float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        // Alpha0
        //Pass
        //{
        //    CGPROGRAM
        //    #pragma vertex vert
        //    #pragma fragment frag

        //    #include "UnityCG.cginc"

        //    struct appdata
        //    {
        //        float4 vertex : POSITION;
        //        float2 uv : TEXCOORD0;
        //    };

        //    struct v2f
        //    {
        //        float2 uv : TEXCOORD0;
        //        float4 vertex : SV_POSITION;
        //    };

        //    sampler2D _MainTex;
        //    float4 _MainTex_ST;
        //    fixed4 _MousePos;
        //    float _ColorRedius;
        //    float _ColorOffset;

        //    v2f vert (appdata v)
        //    {
        //        v2f o;
        //        o.vertex = UnityObjectToClipPos(v.vertex);
        //        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        //        return o;
        //    }

        //    fixed4 frag (v2f i) : SV_Target
        //    {
        //        fixed4 col = tex2D(_MainTex, i.uv);
        //        float dis = distance(_MousePos.xy, i.vertex.xy);
        //        //if (dis < _ColorRedius)
        //        //{
        //        //    col.a = 0;
        //        //}
        //        col.a = saturate(col.a - smoothstep(_ColorRedius, 0, dis) + _ColorOffset * sign(col.a-0.1));
        //        return col;
        //    }
        //    ENDCG
        //}
        // MainTex
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
                return col;
            }
            ENDCG
        }
        // MainColor
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                // Ô­Í¼ÐÎ×´mask
                float4 vert : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;

                float2 uv : TEXCOORD0;
                float4 vert : TEXCOORD1;
            };


            fixed4 _MousePos;
            float4 _Color;
            float _ColorRedius;
            float _ColorOffset;
            float _ColorPow;

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.vert = UnityObjectToClipPos(v.vert);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                float dis = distance(_MousePos.xy, i.vertex.xy);
                float4 addColor = _Color;
                addColor.a = saturate(smoothstep(_ColorRedius, 0, dis) - _ColorOffset * sign(col.a-0.1));
                addColor.a =  addColor.a * col.a * _ColorPow;
                return addColor;
            }
            ENDCG
        }
        // Border Color
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertexBorder : POSITION;
                float2 uvBorder : TEXCOORD0;
            };

            struct v2f
            {
                float2 uvBorder : TEXCOORD0;
                float4 vertexBorder : SV_POSITION;
            };

            sampler2D _BorderTex;
            float4 _BorderTex_ST;
            fixed4 _MousePos;
            float _ColorRedius;
            fixed4 _Color;
            float _BorderColorMul;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertexBorder = UnityObjectToClipPos(v.vertexBorder);
                o.uvBorder = TRANSFORM_TEX(v.uvBorder, _BorderTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_BorderTex, i.uvBorder);

                float dis = distance(_MousePos.xy, i.vertexBorder.xy);
                
                col = col + sign(col.a) * smoothstep(_ColorRedius, 0, dis) * _Color * _BorderColorMul;
                return col;
            }
            ENDCG
        }
    }
}
