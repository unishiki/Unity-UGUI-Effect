Shader "Unlit/HSVInPolarCoordinate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MousePos ("MousePos", Vector) = (0,0,0,0)
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

            #define TWO_PI 6.28318530718
            #define RADIUS_THICKNESS 0.1
            #define RADIUS 0.9
            #define RADIUS_THICKNESS_SELECTOR 0.01
            #define RADIUS_SELECTOR 0.09
            #define RECT_SCALE 230.0/450.0

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float3 hsb2rgb(float3 c)
            {
                float3 rgb = clamp(abs(fmod(c.x * 6.0 + float3(0.0, 4.0, 2.0), 6) - 3.0) - 1.0, 0, 1);
                rgb = rgb * rgb * (3.0 - 2.0 * rgb);
                return c.z * lerp(float3(1, 1, 1), rgb, c.y);
            }

            float sdCircle(float2 p, float r)
            {
                return length(p) - r;
            }
            float opAnnular(float sdf, float r)
            {
                return abs(sdf) - r;
            }
            float sdRect(float2 p, float2 b)
            {
                float2 d = abs(p) - b;
                return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
            }

            fixed4 frag (v2f i) : SV_Target
            {

                // ������ϵHSV
                fixed4 col_HSV;
                // �ѿ�������ϵת����������ϵ
                float2 toCenter = float2(0.5, 0.5) - i.uv;
                float angle = atan2(toCenter.y, toCenter.x);
                float radius = length(toCenter) * 2.0;
                // �Ƕ� (-PI, PI) ӳ�䵽 (0, 1)
                // �ǶȾ���ɫ�࣬�뾶�������Ͷ�,���ȹ̶�
                col_HSV.rgb = hsb2rgb(float3((angle / TWO_PI) + 0.5, radius, 1.0));

                // ��Բ��
                fixed4 annular;
                i.uv.y = 1.0 - i.uv.y; // uv��y������UnityĬ�ϵ�y����һ�� // https://www.unishiki.cc/2023/11/04/Mathematical-Visualization-01/
                i.uv = i.uv * 2 - 1; // ȫ����
                // ������Ļ����Ӱ��
                float w = _ScreenParams.x;
                float h = _ScreenParams.y;
                float step = 1.0 / w;
                annular = smoothstep(step, -step, opAnnular(sdCircle(i.uv, RADIUS) , RADIUS_THICKNESS));
                // ��Բ������Mask
                col_HSV.rgb *= sign(annular.r);
                col_HSV.a = annular.r;

                // СԲ�� _MousePos
                fixed4 annularInAnnular;
                fixed2 annularPos = i.uv;
                annularPos.x -= _MousePos.x;
                annularPos.y += _MousePos.y;
                annularInAnnular = smoothstep(step, -step, opAnnular(sdCircle(annularPos, RADIUS_SELECTOR) , RADIUS_THICKNESS_SELECTOR));

                // UI����
                return saturate(annularInAnnular + col_HSV) ;
            }
            ENDCG
        }
    }
}
