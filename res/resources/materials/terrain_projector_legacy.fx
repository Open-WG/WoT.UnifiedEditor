#include "stdinclude.fxh"

// variables
texture diffuse;
selection bool alphaTestEnable = false : [true, false];
int alphaReference = 0;
float4x4 world;
float4x4 view;
float4x4 viewProj;
float4x4 proj;
float4x4 projtextransform;
float4x4 fftextransform;

struct VS_INPUT
{
    float4 pos		: POSITION;
    float3 normal		: NORMAL;
    float4 blend		: COLOR0;
    float4 shadow		: COLOR1;
};

struct VS_OUTPUT
{
    float4 pos			: POSITION;
    float2 t0			: TEXCOORD0;
    float2 t1			: TEXCOORD1;
    float2 t2			: TEXCOORD2;
    float2 t3			: TEXCOORD3;
    float4 diffuse		: COLOR0;
    float4 blend		: COLOR1;
    float3 view     	: TEXCOORD5;
    float fog			: FOG;
};

struct VS_OUTPUT11
{
    float4 pos			: POSITION;
    float3 view     	: TEXCOORD1;    
};


//----------------------------------------------------------------------------
// Shader body 
//----------------------------------------------------------------------------

//This shader sets up the standard diffuse pixel shader
VS_OUTPUT vs_main(const VS_INPUT v)
{
	VS_OUTPUT o = (VS_OUTPUT) 0;

	float4 worldPos = mul( v.pos, world );
	o.pos = mul( worldPos, viewProj );
	float2 tc;
	tc.x = dot( v.pos, projtextransform[0] );
	tc.y = dot( v.pos, projtextransform[2] );
	o.t0.xy=tc.xy;
	o.diffuse = float4(1, 1, 1, 1);
	return o;
};

sampler diffuseSampler = sampler_state
{
	Texture = diffuse;
	SamplerState = SamplerState : SS_FILTER_ANISOTROPIC, SS_ADDRESS_WRAP
	{
		MaxAnisotropy = 16;
	};
};

float4 ps_main( const VS_OUTPUT input, uniform bool alphaTest ) : COLOR0
{	
	float4 diffuse = tex2D( diffuseSampler, input.t0 );
	if (alphaTest)
	{
		clip(diffuse.a - alphaReference / 255.h);
	}
	return diffuse;
};

technique shader_version
{
	pass Pass_0
	{
		RenderState  = RenderState {
			BlendEnable    = true;
			SrcBlend       = SRC_ALPHA;
			SrcBlendAlpha  = SRC_ALPHA;
			DestBlend      = ONE;
			DestBlendAlpha = ONE;
			DepthAccess    = READ;
		};
		VertexShader = compile vs_3 vs_main();
		PixelShader  = compile ps_3 ps_main(alphaTestEnable);
	}
}
