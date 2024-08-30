#include "stdinclude.fxh"

// Auto variables
texture diffuseMap
<
	bool   exposed = true;
	string name    = "Diffuse Map";
>;

// Manual variables
float4  diffuseColour = float4(1,1,1,1);

float4x4 g_world : World;

sampler diffuseSampler = sampler_state
{
	Texture = diffuseMap;
	SamplerState = SamplerState : SS_FILTER_LINEAR, SS_ADDRESS_CLAMP {};
};

//--------------------------------------------------------------------------------------------------
struct InputVertex
{
	float4 pos		:	POSITION;
	float2 tc		:	TEXCOORD0;
	WG_VEC3 normal	:	NORMAL;
#if DUAL_UV
	float2 tc2		:	TEXCOORD1;
#endif
	float4 diffuse	:	COLOR0;
};

struct OutputDiffuseLighting
{
	float4 pos		:	POSITION;
	float2 tc		:	TEXCOORD0;
	float3 normal	:	TEXCOORD1;
#if DUAL_UV
	float2 tc2		:	TEXCOORD2;
#endif
	float4 worldPos	:	TEXCOORD3;
	float4 diffuse	:	COLOR0;
};

//--------------------------------------------------------------------------------------------------

float3 transformNormaliseVector( float4x4 world, float3 v )
{
	float3 ret;
	ret = mul( v, (float3x3)world );	
	return normalize( ret );
}

//--------------------------------------------------------------------------------------------------

//This shader sets up the standard diffuse pixel shader
OutputDiffuseLighting vs_main(const InputVertex v)
{
	OutputDiffuseLighting o = (OutputDiffuseLighting) 0;

	o.worldPos = float4( transformNormaliseVector( g_world, v.pos.xyz ), 1.0 );
	o.normal = transformNormaliseVector( g_world, WG_UNPACK_VECTOR(v.normal) );
	o.pos = mul( o.worldPos, g_viewProjMat );
	o.tc = v.tc;
#if DUAL_UV
	o.tc2 = v.tc2;
#endif
	o.diffuse = v.diffuse;

	return o;
};

OutputDiffuseLighting vs_main_2d(const InputVertex v)
{
	OutputDiffuseLighting o = (OutputDiffuseLighting) 0;

	o.worldPos = float4( ( v.pos.xy * g_screen.zw * 2.0 ) - float2( 1.0, 1.0 ), 0.0f, 1.0f );
	o.normal = v.normal;
	o.pos = o.worldPos;
	o.tc = v.tc;
#if DUAL_UV
	o.tc2 = v.tc2;
#endif
	o.diffuse = v.diffuse;

	return o;
};

struct SpaceMapInputVertex
{
	float4 pos		:	POSITION;
	float2 tc		:	TEXCOORD0;
};

struct OutputSpaceMap
{
	float4 pos		:	POSITION;
	float2 tc		:	TEXCOORD0;
	float4 worldPos	:	TEXCOORD3;
};

OutputSpaceMap vs_spaceMap(const SpaceMapInputVertex v)
{
	OutputSpaceMap o = (OutputSpaceMap) 0;

	o.worldPos = float4( ( v.pos.xy * g_screen.zw * 2.0 ) - float2( 1.0, 1.0 ), 0.0f, 1.0f );
	o.pos = o.worldPos;
	o.tc = v.tc;

	return o;
};

float4 ps_spaceMap( OutputSpaceMap input ) : COLOR0
{
	float4 colour;
	colour.xyz = tex2D( diffuseSampler, input.tc.xy ).xyz;
	colour.w = 1;
	return colour;
}

float4 ps_spaceMapDebug( OutputSpaceMap input ) : COLOR0
{
	float4 colour;
	colour = input.worldPos;
	return colour;
}

OutputDiffuseLighting vs_editorChunkPortal( IA2VS_Diffuse input )
{
	OutputDiffuseLighting o = (OutputDiffuseLighting)0;

	o.pos = mul(input.pos, g_projMat);
	o.worldPos = input.diffuse;
	
	return o;
}

float4 ps_editorChunkPortal( OutputDiffuseLighting input ) : COLOR0
{
	float4 colour;
	colour = float4(input.worldPos.xyz, 1);
	return colour;
}

float4 ps_vertexColour( OutputDiffuseLighting input ) : COLOR0
{
	return input.diffuse;
}


//--------------------------------------------------------------//
// Space Map Technique
//--------------------------------------------------------------//
RenderState RS_SPACEMAP = {
	BlendEnable       = false;
	BlendOp           = ADD;
	SrcBlend          = ONE;
	DestBlend         = ONE;
	BlendOpAlpha      = ADD;
	SrcBlendAlpha     = ONE;
	DestBlendAlpha    = ONE;

	DepthAccess = NONE;
	CullMode    = NONE;
};

technique spaceMap
{
	pass Pass_0
	{
		RenderState  = RS_SPACEMAP;
		VertexShader = compile vs_3 vs_spaceMap();
		PixelShader  = compile ps_3 ps_spaceMap();
	}
}


RenderState RS_SPACE_MAP_DEBUG = {
	BlendEnable       = true;
	BlendOp           = ADD;
	SrcBlend          = SRC_ALPHA;
	DestBlend         = INV_SRC_ALPHA;
	BlendOpAlpha      = ADD;
	SrcBlendAlpha     = SRC_ALPHA;
	DestBlendAlpha    = INV_SRC_ALPHA;

	DepthAccess = NONE;
	CullMode    = NONE;
};

technique spaceMapDebug
{
	pass Pass_0
	{
		//SRCBLEND = SRCALPHA;
		//DESTBLEND = INVSRCALPHA;
		//ZENABLE = FALSE;
		//ZWRITEENABLE = FALSE;
		//ZFUNC = LESSEQUAL;
		//ALPHABLENDENABLE = TRUE;
		//POINTSPRITEENABLE = FALSE;
		//STENCILENABLE = FALSE;
		//CULLMODE = NONE;		
		
		RenderState  = RS_SPACE_MAP_DEBUG;
		VertexShader = compile vs_3 vs_spaceMap();
		PixelShader  = compile ps_3 ps_spaceMapDebug();
	}
}

RenderState RS_EDITOR_CHUNK_PORTAL = {
	BlendEnable       = true;
	BlendOp           = ADD;
	SrcBlend          = SRC_COLOR;
	DestBlend         = ONE;
	BlendOpAlpha      = ADD;
	SrcBlendAlpha     = SRC_ALPHA;
	DestBlendAlpha    = ONE;

	DepthAccess     = NONE;
	CullMode        = NONE;
	ColorWriteMask0 = 0x7; /* RED | GREEN | BLUE */
};

technique editorChunkPortal
{
	pass Pass_0
	{
		RenderState  = RS_EDITOR_CHUNK_PORTAL;
		VertexShader = compile vs_3 vs_editorChunkPortal();
		PixelShader  = compile ps_3 ps_editorChunkPortal();
	}
}

