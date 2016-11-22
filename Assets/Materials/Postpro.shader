Shader "Hidden/Postpro"
{
	Properties
	{
		_Color1 ("Color",Color) = (0,0,0,0)
		_Color2 ("Color",Color) = (0,0,0,0)
		_MainTex ("Texture", 2D) = "white" {}
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
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _AnotherTex;

			float4 _Color1;
			float4 _Color2;

			float Derivate(float2 uv, float h){

				float dx = 0.0;
				dx+=tex2D(_MainTex, uv+float2(h,0.0)).r * tex2D(_AnotherTex, uv+float2(h,0.0)).r;
				dx-=tex2D(_MainTex, uv+float2(-h,0.0)).r * tex2D(_AnotherTex, uv+float2(-h,0.0)).r;

				dx/= 2.0*h;

				float dy = 0.0;
				dy+=tex2D(_MainTex, uv+float2(0.0,h)).r * tex2D(_AnotherTex, uv+float2(0.0,h)).r;
				dy-=tex2D(_MainTex, uv+float2(0.0,-h)).r * tex2D(_AnotherTex, uv+float2(0.0,-h)).r;

				dy/= 2.0*h;

				return 0.5*(dx*dx+dy*dy);

			}

			fixed4 frag (v2f i) : SV_Target
			{
				float der = -Derivate(1.0*i.uv,0.005);
				der=tex2D(_MainTex, i.uv).r * tex2D(_AnotherTex, i.uv).r;
				return der*lerp(_Color1,_Color2,i.uv.y);
			}
			ENDCG
		}
	}
}
