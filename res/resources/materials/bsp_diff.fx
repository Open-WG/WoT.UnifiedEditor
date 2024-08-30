#include "stdinclude.fxh"

float4x4 g_world;
float4 g_color;

//--------------------------------------------------------------------------------------------------
struct IA2VS_BSPDiff
{
	float4 pos		: POSITION;
	WG_VEC3 normal	: NORMAL;
};

//--------------------------------------------------------------------------------------------------
struct VS2PS_BSPDiff
{
	float4 pos		: POSITION;
	float3 normal	: NORMAL;
};

//--------------------------------------------------------------------------------------------------
VS2PS_BSPDiff vs_diff(IA2VS_BSPDiff i)
{
	VS2PS_BSPDiff o = (VS2PS_BSPDiff)0;

	float4 worldPos = mul(i.pos, g_world);
	o.pos = mul(worldPos, g_viewProjMat);
	o.normal = normalize(mul(WG_UNPACK_VECTOR(i.normal), (float3x3)g_world));

	return o;
}

//--------------------------------------------------------------------------------------------------
float4 ps_diff(VS2PS_BSPDiff i) : COLOR0
{
	const float NdotL = dot(-g_sunLight.m_dir.xyz, normalize(i.normal));
	const float lightMultiplier = 0.3f + 2.0f * abs(NdotL) / 3.0f;
	float3 o = g_color.rgb * lightMultiplier;
	return float4(o, g_color.a);
}

//--------------------------------------------------------------------------------------------------
float4 ps_diffFsQuad(VS2PS_FullScreenQuad i) : COLOR0
{
	return g_color;
}

//--------------------------------------------------------------------------------------------------
technique BspTriangles
{
	pass Main
	{
		RenderState = RenderState
		{
			StencilFunc			= ALWAYS;
			StencilWriteMask	= 0x01;
			StencilRef			= 1;

			StencilPass			= REPLACE;
			StencilDepthFail	= KEEP;

			BlendEnable			= true;
			BlendOp				= ADD;
			SrcBlend			= SRC_ALPHA;
			DestBlend			= INV_SRC_ALPHA;

			BlendOpAlpha		= ADD;
			SrcBlendAlpha		= SRC_ALPHA;
			DestBlendAlpha		= INV_SRC_ALPHA;

			DepthAccess			= READ;

			FillMode			= SOLID;
		};
		VertexShader = compile vs_3 vs_diff();
		PixelShader  = compile ps_3 ps_diff();
	}
}

//--------------------------------------------------------------------------------------------------
technique DefaultModel
{
	pass Main
	{
		RenderState = RenderState
		{
			StencilFunc			= ALWAYS;
			StencilWriteMask	= 0x02;
			StencilRef			= 2;

			StencilPass			= REPLACE;
			StencilDepthFail	= KEEP;

			BlendEnable			= true;
			BlendOp				= ADD;
			SrcBlend			= SRC_ALPHA;
			DestBlend			= INV_SRC_ALPHA;

			BlendOpAlpha		= ADD;
			SrcBlendAlpha		= SRC_ALPHA;
			DestBlendAlpha		= INV_SRC_ALPHA;

			DepthAccess			= READ_WRITE;

			FillMode			= SOLID;
		};
		VertexShader = compile vs_3 vs_diff();
		PixelShader  = compile ps_3 ps_diff();
	}
}

//--------------------------------------------------------------------------------------------------
technique Intersection
{
	pass Main
	{
		RenderState = RenderState : RS_FS_QUAD
		{
			StencilFunc			= EQUAL;
			StencilMask			= 0xFF;
			StencilRef			= 3;

			BlendEnable			= true;
			BlendOp				= ADD;
			SrcBlend			= SRC_ALPHA;
			DestBlend			= INV_SRC_ALPHA;

			BlendOpAlpha		= ADD;
			SrcBlendAlpha		= SRC_ALPHA;
			DestBlendAlpha		= INV_SRC_ALPHA;
		};
		VertexShader = compile vs_3 vs_fullScreenQuad();
		PixelShader  = compile ps_3 ps_diffFsQuad();
	}
}