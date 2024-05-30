Shader "Unlit/RotationShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Rotation ("Rotation", Range(0, 90)) = 0
        [hideInInspector] _OffsetX ("OffsetX", Float) = 0 // _OffsetX = _PosX - _Width * 0.5;
        [hideInInspector] _UVOffset ("UVOffset", Float) = 0
        _UVScale ("UVScale", Range(0, 1)) = 0.01
        _FlowSpeed ("FlowSpeed", Float) = -3
        [hideInInspector] _BlendAmount ("BlendAmount", Range(0, 1)) = 0 // 0 Flowing 1 Solid color
        [hideInInspector] _SolidColor ("SolidColor", Color) = (0, 0, 0, 1)
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
            float _Rotation;
            float _OffsetX;
            float _UVScale;
            float _UVOffset;
            float _FlowSpeed;
            float _BlendAmount;
            float4 _SolidColor;

            float4x4 M_Rotate()
            {                
                return float4x4(cos(radians(_Rotation)), -sin(radians(_Rotation)), 0, 0,
                                sin(radians(_Rotation)),  cos(radians(_Rotation)), 0, 0,
                                                      0,                        0, 1, 0,
                                                      0,                        0, 0, 1);
            }

            v2f vert (appdata v)
            {
                v2f o;
                // uvScale
                v.uv *= _UVScale;
                // uvFlow
                v.uv.x += _Time.x * _FlowSpeed;
                // Rotate
                v.vertex.x -= _OffsetX;
                v.vertex = mul(M_Rotate(), v.vertex);
                v.vertex.x += _OffsetX;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float uv_x = i.uv.x + _UVOffset;
                fixed4 col = tex2D(_MainTex, uv_x);
                col = (1 - _BlendAmount) * col + _BlendAmount * _SolidColor;
                return col;
            }
            ENDCG
        }
    }
}
