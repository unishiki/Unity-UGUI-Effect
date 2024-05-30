Shader "Unlit/SliderShader01"
{
    Properties
    {
        _MaskTex ("MaskTexture", 2D) = "white" {}
        _ColorTex ("ColorTexture", 2D) = "white" {}
        _ColorStrength ("ColorStrength", Range(1, 1.2)) = 1.0
        _UVScale ("UVScale", Range(0, 1)) = 0.25
        [hideInInspector] _OffsetX ("OffsetX", Float) = 0
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
                float2 uv1 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            sampler2D _ColorTex;
            float4 _ColorTex_ST;
            float _ColorStrength;
            float _UVScale;
            float _OffsetX;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _ColorTex);
                o.uv1 = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.uv *= _UVScale;
                i.uv.x = i.uv.x + _OffsetX;

                fixed4 col = tex2D(_ColorTex, i.uv);
                fixed4 shape = tex2D(_MaskTex, i.uv1);
                col.a = shape.a;
                return col * _ColorStrength;
            }
            ENDCG
        }
    }
}
