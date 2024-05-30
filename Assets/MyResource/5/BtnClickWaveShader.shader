Shader "Unlit/BtnClickWaveShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorLeft ("ColorLeft", Color) = (0,1,0,1)
        _ColorRight ("ColorRight", Color) = (0,0,1,1)
        _Radius ("Radius", Float) = 1
        _RadiusThickness ("RadiusThickness", Float) = 1
        _WaveAlpha ("WaveAlpha", Range(0, 1)) = 0.5
        [HDR] _WaveColor ("WaveColor", Color) = (1,1,1,1)
        [hideInInspector] _CircleScaleOffset ("CircleScaleOffset", Float) = 1 // Width / Height
        [hideInInspector] _MouseUVPos ("MouseUVPos", Vector) = (0,0,0,0)
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
            float4 _ColorLeft;
            float4 _ColorRight;
            float _Radius;
            float _RadiusThickness;
            float _CircleScaleOffset;
            float _WaveAlpha;
            float4 _WaveColor;
            float4 _MouseUVPos;

            fixed4 PixelColor(float2 uv)
            {
                // 将uv原点移到中心
                uv -= _MouseUVPos.xy;
                uv = uv * 2 - 1;
                // 离uv坐标原点的距离，排除屏幕长宽比、图片长宽比的影响
                float2 dv = float2(uv.x, uv.y)* float2(_ScreenParams.x / _ScreenParams.y * _CircleScaleOffset, 1);
                float d = sqrt(pow(dv.x, 2) + pow(dv.y, 2));
                // 用小圆减大圆 得到圆环
                fixed3 c = smoothstep(_Radius-_RadiusThickness, _Radius, d) - smoothstep(_Radius, _Radius+_RadiusThickness, d);

                return fixed4(c * _WaveColor.rgb, saturate(c.g)); // -0.5
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
                fixed4 shape = tex2D(_MainTex, i.uv);
                fixed4 wave = PixelColor(i.uv);
                wave.rgb *= _WaveColor.rgb;
                wave.a *= shape.a * _WaveAlpha;
                return wave;
            }
            ENDCG
        }
    }
}
