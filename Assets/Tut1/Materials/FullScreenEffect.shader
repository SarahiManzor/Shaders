Shader "Custom/FullScreenEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Dissipate("Dissapate", Range(1.0,255.0)) = 1.0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float1 _Dissipate;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv + float2(0, sin(i.vertex.x/100 + _Time[1])/100));
				// just invert the colors
				//col = 1 - col;
				//col.r = 1;
				//col.g = 1;
				//col.b = 1;
				col.r = (int)((col.r * 255.0) / _Dissipate) / 255.0 * _Dissipate;
				col.g = (int)((col.g * 255.0) / _Dissipate) / 255.0 * _Dissipate;
				col.b = (int)((col.b * 255.0) / _Dissipate) / 255.0 * _Dissipate;
				return col;
			}
			ENDCG
		}
	}
}
