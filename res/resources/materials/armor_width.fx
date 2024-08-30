#include "stdinclude.fxh"
#include "unskinned_transform.fxh"
#include "pbs_helpers.fxh"

BW_ARTIST_EDITABLE_DIFFUSE_MAP

sampler diffuseSampler = sampler_state
{
	Texture = diffuseMap;
	SamplerState = SamplerState : SS_FILTER_AUTO, SS_ADDRESS_CLAMP {};
};

float4 g_armorRange
<
	bool   exposed = true;
	string name    = "Reduced Armor Width Range";
> = float4(100, 200, 0, 0);

float4 g_angleMax
<
	bool   exposed = true;
	string name    = "Max angle";
	string desc    = "Maximum angle between camera direction and triangle";
> = float4(0, 1.5707f, 0, 0);//default in deg 0-90

float g_armorWidth
<
	bool   exposed = true;
	string name    = "Material Armor Width";
> = 100;

float4 g_calibreRule
<
	bool   exposed = true;
	string name    = "Calibre rule";
	string desc    = "Change armor calculation for armor range";
> = float4(100, 200, 0, 0);

float g_normalizeAngle
<
	bool   exposed = true;
	string name    = "Normalization angle";
	string desc    = "Angle that will be added to normal of triangle";
> = 0;//5 degrees in radian

float g_modelId
<
	bool   exposed = true;
	string name    = "Model Id";
	string desc    = "Determinate to witch model belong pixel";
> = -1.0f;

float g_pixelType
<
	bool   exposed = true;
	string name    = "Pixel type";
	string desc    = "0 - fake,  >= 1 - real";
> = 0;

bool g_ignoreAngle
<
	bool   exposed = true;
	string name    = "Ignore angle";
	string desc    = "In calculation angle will be skiped";
> = false;

selection bool g_useBlend
<
	bool   exposed = true;
	string name    = "Use Blend";
	string desc    = "Render with blend technique";
> = true : [true, false];

selection bool g_useCull
<
	bool   exposed = true;
	string name    = "Use Cull";
> = true : [true, false];


#undef WG_DEFERRED_SHADING

//--------------------------------------------------------------------------------------------------
VS2PS_LightOnlyForward vs_main_2_0(IA2VS_GenericLightOnly i)
{
	GenericLightOnlyData data = genericTransform(i);
	return initVS2PS_LightOnlyForward(data);
}

//--------------------------------------------------------------------------------------------------
float4 ps_2_0(VS2PS_LightOnlyForward i, bool vFace : SV_IsFrontFace, uniform bool blend) : COLOR0
{
	float3 normal = i.normal.xyz * (vFace ? 1.0f : -1.0f);
	float armorAngleCos = dot(-g_cameraDir, normalize(normal));
	float armorAngle = acos(armorAngleCos);
	
	float reducedArmorWidth = 0;
	float pixelType = g_pixelType;
	float modelId = g_modelId;
	
	//flag blend is true only for fake armor
	
	//if value less them MAX and more then MIN - skip this value
	//because cos(90) -  0, amd cos(0) - 1
	if( (armorAngleCos > g_angleMax.x || armorAngleCos < g_angleMax.y) && blend == false)
	{
		reducedArmorWidth = 0;//ignore armor with small angle
		pixelType = 0;//ingnore this pixel 
		armorAngleCos = -999.0f;
	}
	else
	{
		//NORMALIZATION RULE
		if(armorAngle > g_normalizeAngle)
		{
			armorAngleCos = cos(armorAngle - g_normalizeAngle);
		}
		else
		{
			armorAngleCos = 1.0f;
		}
	
		if(g_ignoreAngle == true)
		{
			armorAngleCos = 1.0f;
		}
	
		reducedArmorWidth = g_armorWidth / clamp(armorAngleCos, 0.001, 1);
		reducedArmorWidth = clamp(reducedArmorWidth, g_armorRange.x, g_armorRange.y);
	
		//CALIBRE RULE
		if(g_calibreRule.y > 0)
		{
			if(g_armorWidth >= g_calibreRule.x && g_armorWidth <= g_calibreRule.y)
			{
				float coefficient = (g_armorWidth - g_calibreRule.x) / (g_calibreRule.y - g_calibreRule.x);
			
				reducedArmorWidth = reducedArmorWidth * coefficient;

				if(reducedArmorWidth < g_armorWidth)
				{
					reducedArmorWidth = g_armorWidth;
				}
			}
		}	
	}
	
	//render with blend just add width to previous rendered image for real armor
	if(blend == true)
	{
		modelId = 0;
		pixelType = 0;
	}

	//float armorAngleCosDeg = acos(armorAngleCos) * 180.0f / 3.141592f;
	//return float4(g_angleMax.x, g_angleMax.y, armorAngleCos, armorAngleCosDeg);
	return float4(reducedArmorWidth, modelId, pixelType, armorAngleCos);
}

//--------------------------------------------------------------------------------------------------
TECHNIQUE_COLOR_TRANSPARENT
{
	pass P0
	{
		// RenderState  = RS_PBS_COLOR; // RS_ARTIST_EDITABLE_DOUBLE_SIDED;

		RenderState = RenderState
		{
			StencilFunc      = ALWAYS;
			StencilMask      = 0xF0;
			StencilWriteMask = 0xF0;
			StencilRef       = 128;
			StencilPass      = REPLACE;
			StencilFail      = KEEP;
			StencilDepthFail = KEEP;
			
			DepthAccess		 = (g_useBlend) ? READ : READ_WRITE;
			BlendEnable		 = g_useBlend;
			SrcBlend		 = ONE;
			DestBlend		 = ONE;
			
			CullMode		 = (g_useBlend && !g_useCull)  ? NONE : CCW;
		};

		VertexShader = compile vs_3 vs_main_2_0();
		PixelShader  = compile ps_3 ps_2_0(g_useBlend);
	}
}
 