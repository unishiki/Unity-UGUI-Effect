Shader "Unlit/DrawImgShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [hideinInspector] _MousePos ("MousePos", Vector) = (0,0,0,0)
        _Size ("Size", Range(1, 200)) = 10
        _MainColor ("MainColor", Color) = (1,1,1,0)
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
            float _Size;
            fixed4 _MainColor;
            fixed4 _MousePos;
            vector _Verts[1000];
            int _VertNum;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 col = _MainColor;
                //if (col.a < 0.1)
                //{
                //     float dis = abs(distance(_MousePos.xy, i.vertex.xy));
                //     if (dis < _Size)
                //     {
                //          col.a = 1;
                //     }
                //}
                
                for (int j = 0; j <= _VertNum; j++)
                {
                    float dis = abs(distance(_Verts[j].xy, i.vertex.xy));
                    if (dis < _Size)
                    {
                         col.a = 1;
                    }
                }

                return col;
            }
            ENDCG
        }
    }
}
