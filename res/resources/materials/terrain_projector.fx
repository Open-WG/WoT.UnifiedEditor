#include "stdinclude.fxh"
#include "terrain_common.fxh"

//--------------------------------------------------------------------------------------------------
texture diffuse;
selection bool alphaTestEnable = false : [true, false];
int alphaReference = 0;
selection bool zEnable = true : [true, false];
selection int  wrap    = 1    : [1, 2, 3, 4];
float zShift; // world space bias in meters

float4x4 projtextransform;

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
    float  fog			: FOG;
};

//--------------------------------------------------------------------------------------------------
const TexAddressMode G_TEX_ADDRESS_MODE[] = { WRAP, WRAP, MIRROR, CLAMP, BORDER };

sampler diffuseSampler = sampler_state
{
	Texture = diffuse;
	SamplerState = SamplerState : SS_FILTER_ANISOTROPIC
	{
		AddressU      = G_TEX_ADDRESS_MODE[wrap];
		AddressV      = G_TEX_ADDRESS_MODE[wrap];
		AddressW      = G_TEX_ADDRESS_MODE[wrap];
		MaxAnisotropy = 16;
		BorderColor   = float4(0, 0, 0, 0);
	};
};

//--------------------------------------------------------------------------------------------------
VS_OUTPUT vsMainCommon( const TerrainVertex vIn, const bool useVertexHeight )
{
	VS_OUTPUT o = (VS_OUTPUT) 0;
	float dist = 0;

	TerrainVertex v = vIn;

	// get transformed terrain vertex
	float4 worldPos = terrainVertexPosition( v, useVertexHeight );

	// Add vertical bias as cheap compensation for terrain tessellation
	worldPos.y += zShift;

	// had to hard-code the planar terrain vertex without world xform here
	float4 texPos = float4( v.grid.x * terrainScale, 0, v.grid.y * terrainScale, 1 );

	// calc tex coords
	float2 tc;
	tc.x = dot( texPos, projtextransform[0] );
	tc.y = dot( texPos, projtextransform[2] );

	// output
	o.pos = mul( worldPos, g_viewProjMat );
	o.t0.xy = tc.xy;
	o.diffuse = float4(1, 1, 1, 1);
	return o;
};

//--------------------------------------------------------------------------------------------------
VS_OUTPUT vs_main(TerrainVertex i)
{
	const bool useVertexHeight = true;
	return vsMainCommon(i, useVertexHeight);
}

//--------------------------------------------------------------------------------------------------
VS_OUTPUT vs_mainGridOnly(TerrainVertexGridOnly i)
{
	TerrainVertex ig = (TerrainVertex)0;
	ig.grid = i.grid;

	const bool useVertexHeight = false;
	return vsMainCommon(ig, useVertexHeight);
}

//--------------------------------------------------------------------------------------------------
float4 ps_main( const VS_OUTPUT input, uniform bool alphaTest ) : COLOR0
{
	float4 diffuse = tex2D( diffuseSampler, input.t0 );
	if (alphaTest)
	{
		clip(diffuse.a - alphaReference / 255.h);
	}
	return diffuse;
};


//--------------------------------------------------------------------------------------------------
RenderState RS_MAIN = 
{
	BlendEnable    = true;
	SrcBlend       = SRC_ALPHA;
	SrcBlendAlpha  = SRC_ALPHA;
	DestBlend      = ONE;
	DestBlendAlpha = ONE;
	StencilFunc    = NOTEQUAL;
	StencilRef     = 0;
	StencilMask    = G_STENCIL_USAGE_TERRAIN;
	DepthAccess    = (zEnable) ? READ : NONE;
	DepthBias	   = NONE;
};


//--------------------------------------------------------------------------------------------------
technique Main
{
	pass Main
	{
		RenderState  = RS_MAIN;
		VertexShader = compile vs_3 vs_main();
		PixelShader  = compile ps_3 ps_main(alphaTestEnable);
	}
}

//--------------------------------------------------------------------------------------------------
technique MainGridOnly
{
	pass Main
	{
		RenderState  = RS_MAIN;
		VertexShader = compile vs_3 vs_mainGridOnly();
		PixelShader  = compile ps_3 ps_main(alphaTestEnable);
	}
}
