Shader "Xcqy/DynamicFogOnlyFog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex ("Noise (RGB)", 2D) = "white" {}
		_FogAlpha ("Alpha", Range (0, 1)) = 0.8
		_FogDistance ("Distance Params", Vector) = (0.1, 0.001, 1.0, 0.15)
		_FogHeightData ("Baseline Height", Vector) = (1,0,0,0.1)  // x = height, y = base height, z = clipping minimum height, w = height fall off
		_FogColor ("Color", Color) = (1,1,1,1)
		_FogColor2 ("Color 2", Color) = (1,1,1,1)
		_FogNoiseData ("Noise Data", Vector) = (0,0,0,0.1)
		_FogSpeed ("Speed", Range (0, 0.5)) = 0.1
		_FogOfWarCenter("Fog Of War Center", Vector) = (0,0,0)
		_FogOfWarSize("Fog Of War Size", Vector) = (1,1,1)
		_FogOfWar ("Fog of War Mask", 2D) = "white" {}
		_FogDither ("Fog Dither Strength", Float) = 0.03
	}
	SubShader {
    ZTest Always Cull Off ZWrite Off
   	Fog { Mode Off }
	Pass{

	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma fragmentoption ARB_precision_hint_fastest
	#pragma target 3.0
	#include "UnityCG.cginc"

	sampler2D _NoiseTex;
	float4 _FogDistance; // x = min distance, y = min distance falloff, x = max distance, y = max distance fall off
	float4 _FogHeightData;
	float4 _FogNoiseData; // x = noise, y = turbulence, z = depth attenuation
	float _FogSpeed;
	fixed4 _FogColor, _FogColor2;

	sampler2D _MainTex;
	sampler2D_float _CameraDepthTexture;
	float4 _MainTex_ST;
	fixed _FogAlpha;
	float4 _MainTex_TexelSize;
	fixed  _FogDither;

    float4x4 _ClipToWorld;

    struct appdata {
    	float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
    };

	struct v2f {
	    float4 pos : SV_POSITION;
	    float2 uv: TEXCOORD0;
    	float2 depthUV : TEXCOORD1;
    	float3 cameraToFarPlane : TEXCOORD2;
	};

	v2f vert(appdata v) {
    	v2f o;
    	o.pos = UnityObjectToClipPos(v.vertex);
    	o.uv = UnityStereoScreenSpaceUVAdjust(v.texcoord, _MainTex_ST);
    	o.depthUV = o.uv;
   	      
    	#if UNITY_UV_STARTS_AT_TOP
    	if (_MainTex_TexelSize.y < 0) {
	        // Depth texture is inverted WRT the main texture
    	    o.depthUV.y = 1 - o.depthUV.y;
    	}
    	#endif
               
    	// Clip space X and Y coords
    	float2 clipXY = o.pos.xy / o.pos.w;
               
    	// Position of the far plane in clip space
    	float4 farPlaneClip = float4(clipXY, 1, 1);
               
    	// Homogeneous world position on the far plane
    	farPlaneClip *= float4(1,_ProjectionParams.x,1,1);    	

   		#if UNITY_SINGLE_PASS_STEREO
    	_ClipToWorld = mul(_ClipToWorld, unity_CameraInvProjection);
    	#endif
    	float4 farPlaneWorld4 = mul(_ClipToWorld, farPlaneClip);
               
    	// World position on the far plane
    	float3 farPlaneWorld = farPlaneWorld4.xyz / farPlaneWorld4.w;
               
    	// Vector from the camera to the far plane
    	o.cameraToFarPlane = farPlaneWorld - _WorldSpaceCameraPos;
 
    	return o;
	}

	//Fragment Shader
	fixed4 frag (v2f i) : SV_Target {
   		fixed4 color = tex2D(_MainTex, i.uv);

    	// Reconstruct the world position of the pixel
		float depth = Linear01Depth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.depthUV)));
		if (depth > _FogDistance.z) return color;
		
    	float3 worldPos = (i.cameraToFarPlane * depth) + _WorldSpaceCameraPos;
		worldPos.y -= _FogHeightData.y;
    	if (worldPos.y<_FogHeightData.z || worldPos.y>_FogHeightData.x+_FogNoiseData.y) return color;

		
    	// Compute noise
		float noise = tex2D(_NoiseTex, worldPos.xz * _FogNoiseData.w * 0.1 + _Time[1]*_FogSpeed).g;
		float nt = noise * _FogNoiseData.y;
		noise /= (depth*_FogNoiseData.z); // attenuate with distance

		// Compute ground fog color		
		worldPos.y -= nt;
		float d = (depth-_FogDistance.x)/_FogDistance.y;
		float dmax = (_FogDistance.z - depth) / _FogDistance.w;
		d = min(d, dmax);
		float fogHeight = _FogHeightData.x + nt;
		float h = (fogHeight - worldPos.y) / (fogHeight*_FogHeightData.w);
		float groundColor = saturate(min(d,h))*saturate(_FogAlpha*(1-noise*_FogNoiseData.x));
		
		
		// Compute final blended fog color
		fixed4 fogColor = lerp(_FogColor, _FogColor2, saturate(worldPos.y / fogHeight));
	 	color = lerp(color, fogColor, groundColor);
		return color;
	}

	ENDCG
	}
}
FallBack Off
}
