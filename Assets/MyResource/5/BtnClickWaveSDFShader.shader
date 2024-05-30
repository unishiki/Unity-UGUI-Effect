Shader "Unlit/BtnClickWaveSDFShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorLeft ("ColorLeft", Color) = (0,1,0,1)
        _ColorRight ("ColorRight", Color) = (0,0,1,1)
        [hideInInspector] _CircleScaleOffset ("CircleScaleOffset", Float) = 1 // Width / Height
        [hideInInspector] _CirclePosOffset ("CirclePosOffset", Vector) = (0,0,0,0)
        _Radius ("Radius", Float) = 1.5
        _RadiusThickness ("RadiusThickness", Float) = 0.2
        [HDR] _WaveColor ("WaveColor", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha

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
            float4 _ColorLeft;
            float4 _ColorRight;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 shape = tex2D(_MainTex, i.uv);
                fixed4 col = fixed4(lerp(_ColorLeft, _ColorRight, i.uv.x).rgb, shape.a);
                return col;
            }
            ENDCG
        }
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
            float _CircleScaleOffset;
            float _Radius;
            float4 _CirclePosOffset;
            float _RadiusThickness;
            float4 _WaveColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float sdCircle(float2 p, float r)
            {
                return length(p) - r;
            }
            float opAnnular(float sdf, float r)
            {
                return abs(sdf) - r;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 shape = tex2D(_MainTex, i.uv);
                // 全象限
                i.uv -= _CirclePosOffset.xy;
                i.uv.y = 1.0 - i.uv.y;
                i.uv = i.uv * 2 - 1;
                // 消除屏幕拉伸影响
                float w = _ScreenParams.x;
                float h = _ScreenParams.y;
                half co = w/h * _CircleScaleOffset;
                i.uv = float2(i.uv.x * co, i.uv.y);

                float step = 1.0 / w;
                fixed4 circle = smoothstep(step, -step, opAnnular(sdCircle(i.uv, _Radius) , _RadiusThickness));

                fixed4 col = fixed4(circle.rgb, shape.a);
                col.rgb = col.rgb * _WaveColor.rgb;
                col.a *= col.r;
                col.a = _WaveColor.a * col.a;
                
                return col;
            }
            ENDCG
        }
    }
}
