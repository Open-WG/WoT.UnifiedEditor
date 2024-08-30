#include "stdinclude.fxh"
#include "unskinned_transform.fxh"
#include "pbs_helpers.fxh"

BW_ARTIST_EDITABLE_DIFFUSE_MAP

sampler diffuseSampler = sampler_state
{
	Texture = diffuseMap;
	SamplerState = SamplerState : SS_FILTER_AUTO, SS_ADDRESS_CLAMP {};
};

float4 reducedArmorWidthRange
<
	bool   exposed = true;
	string name    = "Reduced Armor Width Range";
> = float4(100, 200, 0, 0);

float materialArmorWidth
<
	bool   exposed = true;
	string name    = "Material Armor Width";
> = 100;

#undef WG_DEFERRED_SHADING

//--------------------------------------------------------------------------------------------------
VS2PS_LightOnlyForward vs_main_2_0(IA2VS_GenericLightOnly i)
{
	GenericLightOnlyData data = genericTransform(i);
	return initVS2PS_LightOnlyForward(data);
}

//--------------------------------------------------------------------------------------------------
float4 ps_2_0(VS2PS_LightOnlyForward i) : COLOR0
{
	float armorAngleCos = dot(-g_cameraDir, normalize(i.normal));
	
	float reducedArmorWidth = materialArmorWidth / clamp(armorAngleCos, 0.001, 1);
	reducedArmorWidth = clamp(reducedArmorWidth, reducedArmorWidthRange.x, reducedArmorWidthRange.y);

	float u = (reducedArmorWidth - reducedArmorWidthRange.x) / (reducedArmorWidthRange.y - reducedArmorWidthRange.x);

	float4 color	= tex2D(diffuseSampler, float2(u, 0.5f));	
	return color;
}

//--------------------------------------------------------------------------------------------------
TECHNIQUE_COLOR_TRANSPARENT
{
	pass P0
	{
		RenderState  = RS_ARTIST_EDITABLE_DOUBLE_SIDED;
		VertexShader = compile vs_3 vs_main_2_0();
		PixelShader  = compile ps_3 ps_2_0();
	}
}

