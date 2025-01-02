Shader "Unlit/MaskedPaint"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		//_Mask("Mask Texture", 2D) = "white" {}
		_Brush("Brush Texture", 2D) = "white" {}
		[HideInInspector]_BrushPos("Mask Position", Vector) = (0.5,0.5,0.0,0.0)
		_BrushSize("Mask Size", Range(0, 10)) = 1.0
		_BrushRotation("Rotation", Range(0, 360)) = 0
		_BrushTint("Mask Tint", Color) = (1,1,1,1)
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		Cull Off
		ZWrite Off
		ZTest Always

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
		//	sampler2D _Mask;
			sampler2D _Brush;

			float4 _BrushPos;
			float _BrushSize;
			float _BrushRotation;
			float4 _BrushTint;

			float4 _Brush_TexelSize;
			float4 _MainTex_TexelSize;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed2 posWithRotation(fixed2 pos) {
				fixed rad = radians(_BrushRotation);
				fixed _s = sin(rad);
				fixed _c = cos(rad);
				float2x2 mat = float2x2(_c, _s, -_s, _c);
				//mat *= 0.5;
			//	mat += 0.5;
				//mat = mat * 2 - 1;
				
				pos -= 0.5;
				pos = mul(pos, mat);
				pos += 0.5;
				return pos;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
			//	fixed clip = tex2D(_Mask, i.uv).r;
				
				fixed scale = (_BrushSize * _Brush_TexelSize.z * _MainTex_TexelSize.x);
				//fixed2 pos = clamp( i.uv - (_MaskPos.xy - 0.5 * scale ) , 0, 1);
				fixed2 pos = i.uv - (_BrushPos.xy - 0.5 * scale);
				pos = posWithRotation(pos / scale);

				fixed4 _maskCol = fixed4(1,1,1,0);
				if(pos.x > 0 && pos.x < 1 && pos.y > 0 && pos.y < 1)
					_maskCol = tex2D(_Brush, pos) * _BrushTint;

				return lerp(col, float4(_maskCol.rgb,1.0), _maskCol.a);
			}
			ENDCG
		}
	}
}