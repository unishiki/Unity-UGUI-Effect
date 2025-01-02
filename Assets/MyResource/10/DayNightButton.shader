Shader "Unlit/DayNightButton"
{
    Properties
    {
        [hideInInspector]_MainTex ("Texture", 2D) = "white" {}
        _UVScale ("UVScale", Float) = 2
        _SunPos ("SunPos", Range(-1.6, 1.6)) = -1.6
        _SunSize ("SunSize", Float) = 0.75
        _SunBlur ("SunBlur", Float) = 0.05
        _SunColor ("SunColor", Color) = (1, 0.7568627, 0.1058823, 1) // #FAAB0F
        _MoonColor ("MoonColor", Color) = (0.76862745, 0.79215686, 0.8431373, 1) // #C4CAD7

        _SunShadowLightPos1 ("ShadowLightPos1", Vector) = (-0.03, 0.04, 0, 0)
        _SunShadowLightSize1 ("ShadowLightSize1", Float) = 0.78
        _SunShadowLightPos2 ("ShadowLightPos2", Vector) = (-0.04, -0.05, 0, 0)
        _SunShadowLightSize2 ("ShadowLightSize2", Float) = 0.81
        _HighLightColor ("HighLightColor", Color) = (0.945098, 0.8705882,0.2078431,1) // #F1DE35
        _HighLightNightColor ("HighLightNightColor", Color) = (0.945098, 0.8705882,0.2078431,1) // #F1DE35
        _ShadowColor ("ShadowColor", Color) = (0,1,1,1) // #3B4B4B
        _HighLightBlur ("HighLightBlur", Float) = 0.14
        _ShadowBlur ("ShadowBlur", Float) = 0.24

        _Circle3Range ("Circle3Range", Vector) = (1.5, 2.4, 3.3, 0)
        _Circle1ColorDay ("Circle1ColorDay", Color) = (0.4941176, 0.6745098, 0.8470588, 1)
        _Circle2ColorDay ("Circle2ColorDay", Color) = (0.36862745, 0.58823529, 0.80392157, 1)
        _Circle3ColorDay ("Circle3ColorDay", Color) = (0.29019608, 0.5372549, 0.77647059, 1)
        _Circle4ColorDay ("Circle4ColorDay", Color) = (0.2627451, 0.51372549, 0.76862745, 1)

        _Circle1ColorNight ("Circle1ColorNight", Color) = (0.4, 0.4196078, 0.4862745, 1)
        _Circle2ColorNight ("Circle2ColorNight", Color) = (0.2352941, 0.27058824, 0.3529412, 1)
        _Circle3ColorNight ("Circle3ColorNight", Color) = (0.1529412, 0.1882353, 0.2705882, 1)
        _Circle4ColorNight ("Circle4ColorNight", Color) = (0.1098039, 0.14509804, 0.2470588, 1)

        _CloudPos ("CloudPos", Vector) = (0,0,0,0)
        _CloudSize ("CloudSize", Float) = 5

        _HoleCenterX ("HoleCenterX", Vector) = (0.31, -0.11, -0.31, 0)
        _HoleCenterY ("HoleCenterY", Vector) = (0.06, -0.35, 0.24, 0)
        _HoleSize ("HoleSize", Vector) = (0.24, 0.16, 0.15, 0)
        _HoleShadowSize ("HoleShadowSize", Float) = 0.02
        _HoleShadowBlur ("HoleShadowBlur", Float) = 0.1
        _HoleShadowColor ("HoleShadowColor", Color) = (0.4 ,0.4, 0.4,1)

        _StarColor ("StarColor", Color) = (1, 1, 1, 1)
        _StarsSize ("StarsSize_4", Vector) = (2.4, 2, 3.4, 1.5)
        _StarsBlink ("StarsBlink_4", Vector) = (1, 1, 1, 1)
        _StarsStrenth ("StasrStrenth_4", Vector) = (50, 50, 50, 160)
        _StarsPosX ("StarsPosX_4", Vector) = (-1.8, -1.6, -1.1, -1)
        _StarsPosY ("StarsPosY_4", Vector) = (0.3, -0.4, -1.1, -1)
        [hideInInspector] _StarsLen ("StarsLen_4", Vector) = (1, 1, 1, 1)
        [hideInInspector] _StarsRound ("StarsRound_8", Vector) = (0, 0, 0, 0)
         _StarsSizeG2 ("StarsSize_8", Vector) = (2.2, 1.6, 2.4, 3)
        _StarsBlinkG2 ("StarsBlink_8", Vector) = (1, 1, 1, 1)
        _StarsStrenthG2 ("StasrStrenth_8", Vector) = (100, 100, 80, 45)
        _StarsPosXG2 ("StarsPosX_8", Vector) = (-0.65, -0.1, 0.06, 0.4)
        _StarsPosYG2 ("StarsPosY_8", Vector) = (-0.09, -0.36, -0.48, 0.12)
        [hideInInspector] _StarsLenG2 ("StarsLen_8", Vector) = (1, 1, 1, 1)
        [hideInInspector] _StarsRoundG2 ("StarsRound_8", Vector) = (0, 0, 0, 0)

        _ShadowSize ("ShadowSize", Vector) = (3.5, 1.4, 0.64, 0.9)
        _ShadowRadius ("ShadowRadius", Float) = 1.32
        _ShadowPos ("ShadowPos", Vector) = (-0.62, 0.04, 0, 0)
        _ShadowColorOut ("ShadowColorOut", Color) = (0 , 0, 0, 1)
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
            float _UVScale;
            fixed _SunPos;
            fixed4 _BGColor;
            float _ScaleOffset;
            float _SunSize;
            float _SunBlur;
            fixed4 _SunColor;
            fixed4 _MoonColor;

            float4 _SunShadowLightPos1;
            float4 _SunShadowLightPos2;
            float _SunShadowLightSize1;
            float _SunShadowLightSize2;
            float _HighLightBlur;
            float _ShadowBlur;
            fixed4 _HighLightColor;
            fixed4 _HighLightNightColor;
            fixed4 _ShadowColor;

            fixed4 _Circle3Range;
            fixed4 _Circle1ColorDay;
            fixed4 _Circle2ColorDay;
            fixed4 _Circle3ColorDay;
            fixed4 _Circle4ColorDay;
            fixed4 _Circle1ColorNight;
            fixed4 _Circle2ColorNight;
            fixed4 _Circle3ColorNight;
            fixed4 _Circle4ColorNight;

            fixed4 _CloudPos;
            fixed _CloudSize;

            fixed4 _HoleCenterX;
            fixed4 _HoleCenterY;
            fixed4 _HoleSize;
            fixed _HoleShadowBlur;
            float _HoleShadowSize;
            fixed4 _HoleShadowColor;

            fixed4 _StarColor;
            float4 _StarsSize;
            float4 _StarsBlink;
            float4 _StarsStrenth;
            fixed4 _StarsPosX;
            fixed4 _StarsPosY;
            fixed4 _StarsLen;
            fixed4 _StarsRound;
            float4 _StarsSizeG2;
            float4 _StarsBlinkG2;
            float4 _StarsStrenthG2;
            fixed4 _StarsPosXG2;
            fixed4 _StarsPosYG2;
            fixed4 _StarsLenG2;
            fixed4 _StarsRoundG2;

            fixed4 _ShadowSize;
            fixed4 _ShadowPos;
            fixed _ShadowRadius;
            fixed4 _ShadowColorOut;

            float Circle(fixed2 uv,fixed2 center,float size,float blur)
            {
                uv = uv - center;
                uv /= size;
                float len = length(uv);
                return smoothstep(1.,1.-blur,len);
            }
            float DrawCloud(fixed2 uv,fixed2 center,float size)
            {
                uv = uv - center;
                uv /= size;
                float col = Circle(uv,fixed2(-.04,0.02),0.18,0.05);
                col += Circle(uv,fixed2(-0.22,-0.05),0.2,0.05); // L1
                col += Circle(uv,fixed2(-0.42,-0.07),0.18,0.05); // L2
                col += Circle(uv,fixed2(0.12,0),0.18,0.05); // R1
                col += Circle(uv,fixed2(0.27,0.1),0.16,0.05); // R2
                col += Circle(uv,fixed2(0.37,0.23),0.16,0.05); // R3
                return saturate(col);
                //col = col * smoothstep(-0.1,-0.1+0.01,uv.y); // cut off
            }
            float dot2(fixed2 v)
            {
                return dot(v.x, v.y);
            }
            float dot2Offset(fixed2 v, fixed2 offset)
            {
                return dot(v.x - offset.x, v.y - offset.y);
            }
            float sdRoundedCross(fixed2 p, fixed h, fixed2 center,float size)
            {
                p = p - center;
                p /= size;
                float k = 0.5 * (h + 1.0 / h);
                p = abs(p);
                return (p.x < 1.0 && p.y < p.x * (k - h) + h) ?  k - sqrt(dot2(p - fixed2(1, k))) : 1; // sqrt(min(dot2(p - fixed2(0, h)), dot2(p - fixed2(1, 0))))
            }
            float sdRoundBox(fixed2 p, fixed2 b, fixed4 r) 
            {
                r.xy = (p.x > 0.0) ? r.xy : r.zw;
                r.x  = (p.y > 0.0) ? r.x  : r.y;
                fixed2 q = abs(p) - b + r.x;
                return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
            }
            float Remap(float value, fixed2 InMinMax, fixed2 OutMinMax)
            {
                return OutMinMax.x + (value - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
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
                fixed4 col = fixed4(1,1,1,1);
                fixed4 shape = tex2D(_MainTex, i.uv);

                // UV [0, 1] -> [-1, 1]
                i.uv -= 0.5;
                i.uv *= _UVScale;
                // Apply Image(Rect) scale
                _ScaleOffset = 535.0 / 210.0;
                i.uv = float2(i.uv.x * _ScaleOffset, i.uv.y);

                /// BackGround Obj
                // 3 Circle
                fixed2 sunpos = fixed2(_SunPos, 0);
                float dis = abs(distance(i.uv, sunpos));

                if (dis < _Circle3Range.x)
                {
                    _BGColor = lerp(_Circle1ColorDay, _Circle1ColorNight, Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(0, 1)));
                }
                else if (dis < _Circle3Range.y)
                {
                    _BGColor = lerp(_Circle2ColorDay, _Circle2ColorNight, Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(0, 1)));
                }
                else if (dis < _Circle3Range.z)
                {
                    _BGColor = lerp(_Circle3ColorDay, _Circle3ColorNight, Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(0, 1)));
                }
                else
                {
                    _BGColor = lerp(_Circle4ColorDay, _Circle4ColorNight, Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(0, 1)));
                }
                // Clouds
                col = lerp(_BGColor, fixed4(0.635294,0.7568627,0.87843137,1), DrawCloud(i.uv, fixed2(_CloudPos.x - 0.04 , _CloudPos.y + 0.42 + Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(0, -2))), _CloudSize));
                col = lerp(col, fixed4(1,1,1,1), DrawCloud(i.uv, fixed2(_CloudPos.x, _CloudPos.y + Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(0, -2))), _CloudSize));
                // Stars
                float clampSunPos = clamp(_SunPos.x, -0.4, 1.6); // _SunPos.x对星星的显隐影响从这里开始生效,-0.4时全部星星未出现，作为初始状态
                // 1-4
                float star1 = sdRoundedCross(i.uv, _StarsLen.x, fixed2(_StarsPosX.x, _StarsPosY.x), _StarsSize.x) - _StarsRound.x;
                star1 = pow(star1, _StarsBlink.x * abs(sin(1.2 * clampSunPos)));
                //col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star1)) - (_StarsStrenth.x * sign(i.uv.x) * sign(i.uv.y) * dot2(i.uv)), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));//uv偏移前
                col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star1)) - (_StarsStrenth.x  * sign(i.uv.x - _StarsPosX.x) * sign(i.uv.y - _StarsPosY.x) * dot2Offset(i.uv, fixed2(_StarsPosX.x, _StarsPosY.x))), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));

                float star2 = sdRoundedCross(i.uv, _StarsLen.y, fixed2(_StarsPosX.y, _StarsPosY.y), _StarsSize.y) - _StarsRound.y;
                star2 = pow(star2, _StarsBlink.y * abs(cos(clampSunPos + 140)));
                col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star2)) - (_StarsStrenth.y  * sign(i.uv.x - _StarsPosX.y) * sign(i.uv.y - _StarsPosY.y) * dot2Offset(i.uv, fixed2(_StarsPosX.y, _StarsPosY.y))), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));

                float star3 = sdRoundedCross(i.uv, _StarsLen.z, fixed2(_StarsPosX.z, _StarsPosY.z), _StarsSize.z) - _StarsRound.z;
                star3 = pow(star3, _StarsBlink.z * abs(sin(1.1 * clampSunPos+ 60)));
                col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star3)) - (_StarsStrenth.z  * sign(i.uv.x - _StarsPosX.z) * sign(i.uv.y - _StarsPosY.z) * dot2Offset(i.uv, fixed2(_StarsPosX.z, _StarsPosY.z))), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));

                float star4 = sdRoundedCross(i.uv, _StarsLen.w, fixed2(_StarsPosX.w, _StarsPosY.w), _StarsSize.w) - _StarsRound.w;
                star4 = pow(star4, _StarsBlink.w * abs(cos(clampSunPos + 140)));
                col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star4)) - (_StarsStrenth.w  * sign(i.uv.x - _StarsPosX.w) * sign(i.uv.y - _StarsPosY.w) * dot2Offset(i.uv, fixed2(_StarsPosX.w, _StarsPosY.w))), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));
                // 5-8
                float star5 = sdRoundedCross(i.uv, _StarsLenG2.x, fixed2(_StarsPosXG2.x, _StarsPosYG2.x), _StarsSizeG2.x) - _StarsRoundG2.x;
                star5 = pow(star5, _StarsBlinkG2.x * abs(sin(clampSunPos + 60)));
                col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star5)) - (_StarsStrenthG2.x  * sign(i.uv.x - _StarsPosXG2.x) * sign(i.uv.y - _StarsPosYG2.x) * dot2Offset(i.uv, fixed2(_StarsPosXG2.x, _StarsPosYG2.x))), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));

                float star6 = sdRoundedCross(i.uv, _StarsLenG2.y, fixed2(_StarsPosXG2.y, _StarsPosYG2.y), _StarsSizeG2.y) - _StarsRoundG2.y;
                star6 = pow(star6, _StarsBlinkG2.y * abs(sin(clampSunPos + 13)));
                col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star6)) - (_StarsStrenthG2.y  * sign(i.uv.x - _StarsPosXG2.y) * sign(i.uv.y - _StarsPosYG2.y) * dot2Offset(i.uv, fixed2(_StarsPosXG2.y, _StarsPosYG2.y))), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));

                float star7 = sdRoundedCross(i.uv, _StarsLenG2.z, fixed2(_StarsPosXG2.z, _StarsPosYG2.z), _StarsSizeG2.z) - _StarsRoundG2.z;
                star7 = pow(star7, _StarsBlinkG2.z * abs(sin(1.2 * clampSunPos)));
                col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star7)) - (_StarsStrenthG2.z  * sign(i.uv.x - _StarsPosXG2.z) * sign(i.uv.y - _StarsPosYG2.z) * dot2Offset(i.uv, fixed2(_StarsPosXG2.z, _StarsPosYG2.z))), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));

                float star8 = sdRoundedCross(i.uv, _StarsLenG2.w, fixed2(_StarsPosXG2.w, _StarsPosYG2.w), _StarsSizeG2.w) - _StarsRoundG2.w;
                star8 = pow(star8, _StarsBlinkG2.w * abs(sin(clampSunPos + 110)));
                col = lerp(col, _StarColor, Remap(clamp(1.0 - smoothstep(0.0,0.1,abs(star8)) - (_StarsStrenthG2.w  * sign(i.uv.x - _StarsPosXG2.w) * sign(i.uv.y - _StarsPosYG2.w) * dot2Offset(i.uv, fixed2(_StarsPosXG2.w, _StarsPosYG2.w))), 0.6, 1), fixed2(0.6, 1), fixed2(0, 1)));



                /// Handle
                fixed sun = Circle(i.uv,sunpos,_SunSize,_SunBlur);
                col = lerp(col, lerp(_SunColor, _MoonColor, Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(0, 1))), sun);
                // 3 Hole in Handle
                fixed hole1 =  Circle(i.uv,sunpos - fixed2(_HoleCenterX.x, _HoleCenterY.x),_HoleSize.x,0.05);
                fixed hole1S =  Circle(i.uv,sunpos - fixed2(_HoleCenterX.x, _HoleCenterY.x),_HoleSize.x + _HoleShadowSize, _HoleShadowBlur);
                fixed hole2 =  Circle(i.uv,sunpos - fixed2(_HoleCenterX.y, _HoleCenterY.y),_HoleSize.y,0.05);
                fixed hole2S =  Circle(i.uv,sunpos - fixed2(_HoleCenterX.y, _HoleCenterY.y),_HoleSize.y + _HoleShadowSize, _HoleShadowBlur);
                fixed hole3 =  Circle(i.uv,sunpos - fixed2(_HoleCenterX.z, _HoleCenterY.z),_HoleSize.z,0.05);
                fixed hole3S =  Circle(i.uv,sunpos - fixed2(_HoleCenterX.z, _HoleCenterY.z),_HoleSize.z + _HoleShadowSize, _HoleShadowBlur);
                col = lerp(col, _HoleShadowColor, clamp(Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(-0.5, saturate(hole1S + hole2S + hole3S))), 0, 1)); // clamp与-0.5 为调整开始出现月球坑的时间
                col = lerp(col, fixed4(0.5882353,0.6352941,0.7137255,1), clamp(Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(-0.5, saturate(hole1 + hole2 + hole3))), 0, 1));

                // HighLight and  Shadow
                fixed2 sunpos1 = fixed2(_SunPos + _SunShadowLightPos1.x, _SunShadowLightPos1.y);
                fixed2 sunpos2 = fixed2(_SunPos + _SunShadowLightPos2.x, _SunShadowLightPos2.y);
                fixed sunShadowLight1 = Circle(i.uv,sunpos1,_SunShadowLightSize1,_HighLightBlur);
                fixed sunShadowLight2 = Circle(i.uv,sunpos2,_SunShadowLightSize2,_ShadowBlur);
                col = lerp(col, lerp(_HighLightColor, _HighLightNightColor, Remap(_SunPos, fixed2(-1.6, 1.6), fixed2(0, 1))), saturate(sunShadowLight1 - sunShadowLight2));
                col = lerp(col, _ShadowColor, saturate(-1 * (sunShadowLight1 - sunShadowLight2)));

                /// Shadow
                float ra = min(_ShadowRadius,min(_ShadowSize.x,_ShadowSize.y));
                float sdrb = sdRoundBox(i.uv + _ShadowPos.xy, _ShadowSize.xy, ra);
                col = lerp(col, _ShadowColorOut, 1.0 - smoothstep(0.0, _ShadowSize.z, abs(sdrb)));

                // Shape
                col.a *= shape.a;
                return col;
            }
            ENDCG
        }
    }
}
