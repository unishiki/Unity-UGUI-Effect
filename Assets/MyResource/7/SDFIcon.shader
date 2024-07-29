Shader "Unlit/SDFIcon"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} // icon图标
        [hideInInspector] _EdgeTex ("EdgeTexture", 2D) = "white" {} // 边缘sdf图形
        [HDR] _ColorEdge ("ColorEdge", Color) = (1,1,1,1)
        [HDR] _ColorMain ("ColorMain", Color) = (1,1,1,1)
        _WidthOuter ("WidthOuter", Range(0.01, 0.08)) = 0.01
        _WidthInner ("WidthInner", Range(0.01, 0.08)) = 0.04
        _RadiusOuter ("RadiusOuter", Float) = 0.4
        _RadiusInner ("RadiusInner", Float) = 0.3
        _Step ("Step", Range(.95, 1.3)) = 1.3
        _MainTexScale ("MainTexScale", Range(4, 8)) = 6
        _uvScale ("_UVScale", Range(0.31, 1.12)) = 0.6
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uvEdge : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _EdgeTex;
            float4 _MainTex_ST;
            float4 _EdgeTex_ST;
            float4 _ColorEdge;
            float4 _ColorMain;
            float _WidthOuter;
            float _WidthInner;
            float _Step;
            float _RadiusOuter;
            float _RadiusInner;
            float _MainTexScale;
            float _uvScale;

            v2f vert (appdata v)
            {
                v2f o;
                // 总体uv中心缩放
                float2 centerUV1 = float2(0.5, 0.5);
                float2 uvOffset1 = v.uv - centerUV1;
                v.uv = centerUV1 + uvOffset1 * _uvScale;

                o.vertex = UnityObjectToClipPos(v.vertex);
                // icon图标 uv中心缩放
                float2 centerUV = float2(0.5, 0.5);
                float2 uvOffset = v.uv - centerUV;
                o.uv = centerUV + uvOffset * _MainTexScale;
                // 全象限
                v.uv = v.uv * 2 - 1;
                o.uvEdge = TRANSFORM_TEX(v.uv, _EdgeTex);
                
                return o;
            }
            // 矩形sdf
            float sdRect(float2 p, float2 b)
            {
                float2 d = abs(p) - b;
                return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
            }
            
            // 菱形sdf
            float ndot(float2 a, float2 b) 
            {
                return a.x * b.x - a.y * b.y; 
            }
            float sdRhombus(float2 p, in float2 b) 
            {
                p = abs(p);
                float h = clamp(ndot(b - 2.0 * p, b) / dot(b, b), -1.0, 1.0);
                float d = length(p- 0.5 * b * float2(1.0 - _ScreenParams.y, 1.0 + _ScreenParams.y));
                return d * sign(p.x * b.y + p.y * b.x - b.x * b.y);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = fixed4(0, 0, 0, 0);
                float w = _ScreenParams.x, h = _ScreenParams.y;
                float step = 1.0 / w;
                // 定义函数
                float rect = smoothstep(step, -step, sdRect(i.uvEdge * _Step, float2(_RadiusInner, _RadiusInner))) - smoothstep(step, -step, sdRect(i.uvEdge * _Step, float2(_RadiusInner - _WidthInner, _RadiusInner - _WidthInner)));
                float rect2 = smoothstep(step, -step, sdRect(i.uvEdge * _Step, float2(_RadiusOuter, _RadiusOuter))) - smoothstep(step, -step, sdRect(i.uvEdge * _Step, float2(_RadiusOuter - _WidthOuter, _RadiusOuter - _WidthOuter)));
                float rhombus = smoothstep(step, -step, sdRhombus(i.uvEdge * (2 - _Step), float2(0.4, 0.4)));
                float final = rect + rect2;
                // 绘制
                // Edge
                c = lerp(c, 1, final);
                c.a = c.r * (1 - rhombus.r);
                c *= _ColorEdge;
                // MainTex
                fixed4 cm = tex2D(_MainTex, i.uv) * _ColorMain;
                cm.a *= sign(rhombus.r);
                return cm + c;
            }
            ENDCG
        }
    }
}
