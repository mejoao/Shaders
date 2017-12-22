﻿Shader "Custom/Damage" {
	Properties{
		_Color1("Color", Color) = (1,1,1,1)
		_Color2("Color 2", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	_Bump("Normal map", 2D) = "bump" {}
	_Blink("Blink speed", Range(0.0, 2000.0)) = 1000
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
#pragma target 3.0

		sampler2D _MainTex;
	sampler2D _Bump;

	struct Input {
		float2 uv_MainTex;
		float2 uv_Bump;
	};

	half _Glossiness;
	half _Metallic;
	fixed4 _Color1;
	fixed4 _Color2;
	float _Blink;

	// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
	// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
	// #pragma instancing_options assumeuniformscaling
	UNITY_INSTANCING_CBUFFER_START(Props)
		// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf(Input IN, inout SurfaceOutputStandard o) {
		// Albedo comes from a texture tinted by color
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * (lerp(_Color1, _Color2, (sin(_Time.x * _Blink) + 1) / 2));
		o.Albedo = c.rgb;
		o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
		// Metallic and smoothness come from slider variables
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		o.Alpha = c.a;
	}
	ENDCG
	}
		FallBack "Diffuse"
}
