/*  
*    LMC_L4D2_Menu_Choosing - Allows humans to choose LMC model with cookiesaving
*    Copyright (C) 2019  LuxLuma		acceliacat@gmail.com
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*
*Awoo v2
*/


#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

#define REQUIRE_EXTENSIONS
#include <clientprefs>
#undef REQUIRE_EXTENSIONS

#define REQUIRE_PLUGIN
#include <LMCCore>
#include <LMCL4D2CDeathHandler>
#include <LMCL4D2SetTransmit>
#undef REQUIRE_PLUGIN

#pragma newdecls required


#define PLUGIN_NAME "LMC_L4D2_Menu_Choosing"
#define PLUGIN_VERSION "1.1 Awoo Server"

//change me to whatever flag you want
#define COMMAND_ACCESS ADMFLAG_CHAT

#define HUMAN_MODEL_PATH_SIZE 11
#define SPECIAL_MODEL_PATH_SIZE 8
#define UNCOMMON_MODEL_PATH_SIZE 6
#define COMMON_MODEL_PATH_SIZE 34

enum ZOMBIECLASS
{
	ZOMBIECLASS_SMOKER = 1,
	ZOMBIECLASS_BOOMER,
	ZOMBIECLASS_HUNTER,
	ZOMBIECLASS_SPITTER,
	ZOMBIECLASS_JOCKEY,
	ZOMBIECLASS_CHARGER,
	ZOMBIECLASS_UNKNOWN,
	ZOMBIECLASS_TANK,
}

enum LMCModelSectionType
{
	LMCModelSectionType_Human = 0,
	LMCModelSectionType_Special,
	LMCModelSectionType_UnCommon,
	LMCModelSectionType_Common,
	LMCModelSectionType_Custom
};

//Z:***INCREASE NUMBER FOR EACH MODEL!!!***
#define CUSTOM_MODEL_PATH_SIZE 29	

//Z:***ADD NEW MODEL PATHS HERE!!!***
static const char sCustomPaths[CUSTOM_MODEL_PATH_SIZE][] =
{
	"models/survivors/gene6.mdl",
	"models/survivors/raisin.mdl",
	"models/survivors/emilia.mdl",
	"models/survivors/m119howitzer_static_01.mdl",
	"models/survivors/ran.mdl",
	"models/survivors/nyn.mdl",
	"models/survivors/hsi.mdl",
	"models/survivors/icg.mdl",
	"models/survivors/hk416_2.mdl",
	"models/survivors/g11.mdl",
	"models/survivors/ump9_2.mdl",
	"models/survivors/ump45_2.mdl",
	"models/survivors/g41.mdl",
	"models/survivors/wa2000.mdl",
	"models/survivors/m4sopmod2.mdl",
	"models/survivors/m1903_2.mdl",
	"models/survivors/ump40.mdl",
	"models/survivors/tdasweetmiguloli.mdl",
	"models/survivors/akai_haato4.mdl",
	"models/survivors/inubashiri_momiji.mdl",
	"models/survivors/murasaki_shion3.mdl",
	"models/survivors/ar15.mdl",
	"models/survivors/m4a1.mdl",
	"models/survivors/minato_aqua2.mdl",
	"models/survivors/test.mdl",
	"models/survivors/shirakami_fubuki.mdl",
	"models/survivors/natsuiro_matsuri.mdl",
	"models/survivors/kurokami_fubuki.mdl",
	"models/survivors/yuzuki_choco.mdl"
};
//Z:***ADD NEW ENUM HERE!!!***
enum LMCCustomModelType
{
	MODEL_GENE = 0,
	MODEL_RAISIN,
	MODEL_EMILIA,
	MODEL_M119HOWITZER,
	MODEL_RAN,
	MODEL_NYN,
	MODEL_HSI,
	MODEL_ICG,
	MODEL_HK416,
	MODEL_G11,
	MODEL_UMP9,
	MODEL_UMP45,
	MODEL_G41,
	MODEL_WA2000,
	MODEL_M4SOPMOD2,
	MODEL_M1903,
	MODEL_UMP40,
	MODEL_TDASWEETMIGULOLI,
	MODEL_AKAIHAATO,
	MODEL_INUBASHIRIMOMIJI,
	MODEL_MURASAKISHION,
	MODEL_AR15,
	MODEL_M4A1,
	MODEL_MINATOAQUA,
	MODEL_TEST,
	MODEL_SHIRAKAMIFUBUKI,
	MODEL_NATSUIROMATSURI,
	MODEL_KUROKAMIFUBUKI,
	MODEL_YUZUKICHOCO
};

static const char sHumanPaths[HUMAN_MODEL_PATH_SIZE][] =
{
	"models/survivors/survivor_gambler.mdl",
	"models/survivors/survivor_producer.mdl",
	"models/survivors/survivor_coach.mdl",
	"models/survivors/survivor_mechanic.mdl",
	"models/survivors/survivor_namvet.mdl",
	"models/survivors/survivor_teenangst.mdl",
	"models/survivors/survivor_teenangst_light.mdl",
	"models/survivors/survivor_biker.mdl",
	"models/survivors/survivor_biker_light.mdl",
	"models/survivors/survivor_manager.mdl",
	"models/npcs/rescue_pilot_01.mdl"
};

enum LMCHumanModelType
{
	LMCHumanModelType_Nick = 0,
	LMCHumanModelType_Rochelle,
	LMCHumanModelType_Coach,
	LMCHumanModelType_Ellis,
	LMCHumanModelType_Bill,
	LMCHumanModelType_Zoey,
	LMCHumanModelType_ZoeyLight,
	LMCHumanModelType_Francis,
	LMCHumanModelType_FrancisLight,
	LMCHumanModelType_Louis,
	LMCHumanModelType_Pilot
};

static const char sSpecialPaths[SPECIAL_MODEL_PATH_SIZE][] =
{
	"models/infected/witch.mdl",
	"models/infected/witch_bride.mdl",
	"models/infected/boomer.mdl",
	"models/infected/boomette.mdl",
	"models/infected/hunter.mdl",
	"models/infected/smoker.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk_dlc3.mdl"
};

enum LMCSpecialModelType
{
	LMCSpecialModelType_Witch = 0,
	LMCSpecialModelType_WitchBride,
	LMCSpecialModelType_Boomer,
	LMCSpecialModelType_Boomette,
	LMCSpecialModelType_Hunter,
	LMCSpecialModelType_Smoker,
	LMCSpecialModelType_Tank,
	LMCSpecialModelType_TankDLC3
};

static const char sUnCommonPaths[UNCOMMON_MODEL_PATH_SIZE][] =
{
	"models/infected/common_male_riot.mdl",
	"models/infected/common_male_mud.mdl",
	"models/infected/common_male_ceda.mdl",
	"models/infected/common_male_clown.mdl",
	"models/infected/common_male_jimmy.mdl",
	"models/infected/common_male_fallen_survivor.mdl"
};

enum LMCUnCommonModelType
{
	LMCUnCommonModelType_RiotCop = 0,
	LMCUnCommonModelType_MudMan,
	LMCUnCommonModelType_Ceda,
	LMCUnCommonModelType_Clown,
	LMCUnCommonModelType_Jimmy,
	LMCUnCommonModelType_Fallen
};

static const char sCommonPaths[COMMON_MODEL_PATH_SIZE][] =
{
	"models/infected/common_male_tshirt_cargos.mdl",
	"models/infected/common_male_tankTop_jeans.mdl",
	"models/infected/common_male_dressShirt_jeans.mdl",
	"models/infected/common_female_tankTop_jeans.mdl",
	"models/infected/common_female_tshirt_skirt.mdl",
	"models/infected/common_male_roadcrew.mdl",
	"models/infected/common_male_tankTop_overalls.mdl",
	"models/infected/common_male_tankTop_jeans_rain.mdl",
	"models/infected/common_female_tankTop_jeans_rain.mdl",
	"models/infected/common_male_roadcrew_rain.mdl",
	"models/infected/common_male_tshirt_cargos_swamp.mdl",
	"models/infected/common_male_tankTop_overalls_swamp.mdl",
	"models/infected/common_female_tshirt_skirt_swamp.mdl",
	"models/infected/common_male_formal.mdl",
	"models/infected/common_female_formal.mdl",
	"models/infected/common_military_male01.mdl",
	"models/infected/common_police_male01.mdl",
	"models/infected/common_male_baggagehandler_01.mdl",
	"models/infected/common_tsaagent_male01.mdl",
	"models/infected/common_shadertest.mdl",
	"models/infected/common_female_nurse01.mdl",
	"models/infected/common_surgeon_male01.mdl",
	"models/infected/common_worker_male01.mdl",
	"models/infected/common_morph_test.mdl",
	"models/infected/common_male_biker.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male_suit.mdl",
	"models/infected/common_patient_male01_l4d2.mdl",
	"models/infected/common_male_polo_jeans.mdl",
	"models/infected/common_female_rural01.mdl",
	"models/infected/common_male_rural01.mdl",
	"models/infected/common_male_pilot.mdl",
	"models/infected/common_test.mdl"
};

#define CvarIndexes 7
static const char sSharedCvarNames[CvarIndexes][] =
{
	"lmc_allowtank",
	"lmc_allowhunter",
	"lmc_allowsmoker",
	"lmc_allowboomer",
	"lmc_allowSurvivors",
	"lmc_allow_tank_model_use",
	"lmc_precache_prevent"
};

static const char sJoinSound[] = {"ui/menu_countdown.wav"};

static Handle hCvar_ArrayIndex[CvarIndexes] = {INVALID_HANDLE, ...};

static bool g_bAllowTank = true;
static bool g_bAllowHunter = true;
static bool g_bAllowSmoker = true;
static bool g_bAllowBoomer = true;
static bool g_bAllowSurvivors = true;
static bool g_bTankModel = true;

static Handle hCookie_LmcCookie = INVALID_HANDLE;

static Handle hCvar_AdminOnlyModel = INVALID_HANDLE;
static Handle hCvar_AnnounceDelay = INVALID_HANDLE;
static Handle hCvar_AnnounceMode = INVALID_HANDLE;
static Handle hCvar_ThirdPersonTime = INVALID_HANDLE;

static float g_fAnnounceDelay = 15.0;
static int g_iAnnounceMode = 1;
static bool g_bAdminOnly = false;
static float g_fThirdPersonTime = 2.0;

static int iSavedModel[MAXPLAYERS+1] = {0, ...};
static bool bAutoApplyMsg[MAXPLAYERS+1];
static bool bAutoBlockedMsg[MAXPLAYERS+1][9];

static int iCurrentPage[MAXPLAYERS+1];

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	if(GetEngineVersion() != Engine_Left4Dead2 )
	{
		strcopy(error, err_max, "Plugin only supports Left 4 Dead 2");
		return APLRes_SilentFailure;
	}
	return APLRes_Success;
}

public Plugin myinfo =
{
	name = PLUGIN_NAME,
	author = "Lux",
	description = "Allows humans to choose LMC model with cookiesaving",
	version = PLUGIN_VERSION,
	url = "https://forums.alliedmods.net/showthread.php?p=2607394"
};

public void OnPluginStart()
{
	LoadTranslations("lmc.phrases");

	CreateConVar("lmc_l4d2_menu_choosing", PLUGIN_VERSION, "LMC_L4D2_Menu_Choosing_Version", FCVAR_DONTRECORD|FCVAR_NOTIFY);

	hCvar_AdminOnlyModel = CreateConVar("lmc_adminonly", "0", "Allow admins to only change models? (1 = true) NOTE: this will disable announcement to player who join. ((#define COMMAND_ACCESS ADMFLAG_CHAT) change to w/o flag you want or (Use override file))", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	hCvar_AnnounceDelay = CreateConVar("lmc_announcedelay", "15.0", "Delay On which a message is displayed for !lmc command", FCVAR_NOTIFY, true, 1.0, true, 360.0);
	hCvar_AnnounceMode = CreateConVar("lmc_announcemode", "1", "Display Mode for !lmc command (0 = off, 1 = Print to chat, 2 = Center text, 3 = Director Hint)", FCVAR_NOTIFY, true, 0.0, true, 3.0);
	hCvar_ThirdPersonTime = CreateConVar("lmc_thirdpersontime", "0.0", "How long (in seconds) the client will be in thirdperson view after selecting a model from !lmc command. (0.5 < = off)", FCVAR_NOTIFY, true, 0.0, true, 360.0);
	HookConVarChange(hCvar_AdminOnlyModel, eConvarChanged);
	HookConVarChange(hCvar_AnnounceDelay, eConvarChanged);
	HookConVarChange(hCvar_AnnounceMode, eConvarChanged);
	HookConVarChange(hCvar_ThirdPersonTime, eConvarChanged);
	AutoExecConfig(true, "LMC_L4D2_Menu_Choosing");
	CvarsChanged();

	hCookie_LmcCookie = RegClientCookie("lmc_cookie", "", CookieAccess_Protected);
	RegConsoleCmd("sm_lmc", ShowMenuCmd, "Brings up a menu to select a client's model");

	HookEvent("player_spawn", ePlayerSpawn);
}

public void eConvarChanged(Handle hCvar, const char[] sOldVal, const char[] sNewVal)
{
	CvarsChanged();
}

void CvarsChanged()
{
	if(hCvar_ArrayIndex[0] != INVALID_HANDLE)
		g_bAllowTank = GetConVarInt(hCvar_ArrayIndex[0]) > 0;
	if(hCvar_ArrayIndex[1] != INVALID_HANDLE)
		g_bAllowHunter = GetConVarInt(hCvar_ArrayIndex[1]) > 0;
	if(hCvar_ArrayIndex[2] != INVALID_HANDLE)
		g_bAllowSmoker = GetConVarInt(hCvar_ArrayIndex[2]) > 0;
	if(hCvar_ArrayIndex[3] != INVALID_HANDLE)
		g_bAllowBoomer = GetConVarInt(hCvar_ArrayIndex[3]) > 0;
	if(hCvar_ArrayIndex[4] != INVALID_HANDLE)
		g_bAllowSurvivors = GetConVarInt(hCvar_ArrayIndex[4]) > 0;
	if(hCvar_ArrayIndex[5] != INVALID_HANDLE)
		g_bTankModel = GetConVarInt(hCvar_ArrayIndex[5]) > 0;

	g_bAdminOnly = GetConVarInt(hCvar_AdminOnlyModel) > 0;
	g_fAnnounceDelay = GetConVarFloat(hCvar_AnnounceDelay);
	g_iAnnounceMode = GetConVarInt(hCvar_AnnounceMode);
	g_fThirdPersonTime = GetConVarFloat(hCvar_ThirdPersonTime);
}

void HookCvars()
{
	for(int i = 0; i < CvarIndexes; i++)
	{
		if(hCvar_ArrayIndex[i] != INVALID_HANDLE)
			continue;

		if((hCvar_ArrayIndex[i] = FindConVar(sSharedCvarNames[i])) == INVALID_HANDLE)
		{
			PrintToServer("[LMC]Unable to find shared cvar \"%s\" using fallback value plugin:(%s)", sSharedCvarNames[i], PLUGIN_NAME);
			continue;
		}
		HookConVarChange(hCvar_ArrayIndex[i], eConvarChanged);
	}
}


public void OnMapStart()
{
	bool bPrecacheModels = true;
	if(FindConVar(sSharedCvarNames[6]) != INVALID_HANDLE)
	{
		char sCvarString[4096];
		char sMap[67];
		GetConVarString(FindConVar(sSharedCvarNames[6]), sCvarString, sizeof(sCvarString));
		GetCurrentMap(sMap, sizeof(sMap));

		Format(sMap, sizeof(sMap), ",%s,", sMap);
		Format(sCvarString, sizeof(sCvarString), ",%s,", sCvarString);

		if(StrContains(sCvarString, sMap, false) != -1)
			bPrecacheModels = false;

		if(!bPrecacheModels)
		{
			ReplaceString(sMap, sizeof(sMap), ",", "", false);
			PrintToServer("[%s] \"%s\" Model Precaching Disabled.", PLUGIN_NAME, sMap);
		}
	}

	if(bPrecacheModels)
	{
		int i;
		for(i = 0; i < HUMAN_MODEL_PATH_SIZE; i++)
			PrecacheModel(sHumanPaths[i], true);

		for(i = 0; i < SPECIAL_MODEL_PATH_SIZE; i++)
			PrecacheModel(sSpecialPaths[i], true);

		for(i = 0; i < UNCOMMON_MODEL_PATH_SIZE; i++)
			PrecacheModel(sUnCommonPaths[i], true);

		for(i = 0; i < COMMON_MODEL_PATH_SIZE; i++)
			PrecacheModel(sCommonPaths[i], true);
	}

	PrecacheSound(sJoinSound, true);

	HookCvars();
	CvarsChanged();
}


public void ePlayerSpawn(Handle hEvent, const char[] sEventName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
	if(iClient < 1 || iClient > MaxClients)
		return;

	if(!IsClientInGame(iClient) || IsFakeClient(iClient) || !IsPlayerAlive(iClient))
		return;

	LMC_ResetRenderMode(iClient);

	if(g_bAdminOnly && !CheckCommandAccess(iClient, "sm_lmc", COMMAND_ACCESS))
			return;

	switch(GetClientTeam(iClient))
	{
		case 3:
		{
			switch(GetEntProp(iClient, Prop_Send, "m_zombieClass"))//1.4
			{
				case ZOMBIECLASS_SMOKER:
				{
					if(!g_bAllowSmoker)
						return;
				}
				case ZOMBIECLASS_BOOMER:
				{
					if(!g_bAllowBoomer)
						return;
				}
				case ZOMBIECLASS_HUNTER:
				{
					if(!g_bAllowHunter)
						return;
				}
				case ZOMBIECLASS_CHARGER, ZOMBIECLASS_JOCKEY, ZOMBIECLASS_SPITTER, ZOMBIECLASS_UNKNOWN:
				{
					return;
				}
				case ZOMBIECLASS_TANK:
				{
					if(!g_bAllowTank)
						return;
				}
				default:
				{
					return;
				}
			}
		}
		case 2:
		{
			if(!g_bAllowSurvivors)
				return;
		}
		default:
		{
			return;
		}
	}


	if(iSavedModel[iClient] < 2)
		return;

	RequestFrame(NextFrame, GetClientUserId(iClient));
}

public void NextFrame(int iUserID)
{
	int iClient = GetClientOfUserId(iUserID);
	if(iClient < 1 || !IsClientInGame(iClient))
		return;

	ModelIndex(iClient, iSavedModel[iClient], false);
}

public Action ShowMenuCmd(int iClient, int iArgs)
{
	iCurrentPage[iClient] = 0;
	ShowMenu(iClient, iArgs);
}

/*borrowed some code from csm*/
public Action ShowMenu(int iClient, int iArgs)
{
	if(iClient == 0)
	{
		ReplyToCommand(iClient, Translate(iClient, "%t", "In-game only")); // "[LMC] Menu is in-game only.");
		return Plugin_Continue;
	}
	if(g_bAdminOnly && !CheckCommandAccess(iClient, "sm_lmc", COMMAND_ACCESS))
	{
		ReplyToCommand(iClient, Translate(iClient, "%t", "Admin only")); // "\x04[LMC] \x03Model Changer is only available to admins.");
		return Plugin_Continue;
	}
	if(!IsPlayerAlive(iClient) && bAutoBlockedMsg[iClient][8])
	{
		ReplyToCommand(iClient, Translate(iClient, "%t", "Alive only")); // "\x04[LMC] \x03Pick a Model to be Applied NextSpawn");
		bAutoBlockedMsg[iClient][8] = false;
	}
	Handle hMenu = CreateMenu(CharMenu);
	SetMenuTitle(hMenu, Translate(iClient, "%t", "Lux's Model Changer"));//1.4

	AddMenuItem(hMenu, "1", Translate(iClient, "%t", "Normal Models"));

	//Z:***ADD MENU OPTION HERE*** last used 54

	AddMenuItem(hMenu, "45", "Inubashiri Momiji(2hu)");
	AddMenuItem(hMenu, "26", "Gene(PSO2)");
	AddMenuItem(hMenu, "44", "Akai Haato(Hololive)");
	AddMenuItem(hMenu, "52", "Natsuiro Matsuri(Hololive)");
	AddMenuItem(hMenu, "51", "Shirakami Fubuki(Hololive)");
	AddMenuItem(hMenu, "53", "Kurokami Fubuki(Hololive)");
	AddMenuItem(hMenu, "54", "Yuzuki Choco(Hololive)");
	AddMenuItem(hMenu, "46", "Murasaki Shion(Hololive)");
	AddMenuItem(hMenu, "49", "Minato Aqua(Hololive)");
	AddMenuItem(hMenu, "48", "M4A1(GFL)");
	AddMenuItem(hMenu, "47", "AR15(GFL)");
	AddMenuItem(hMenu, "37", "G11(GFL)");
	AddMenuItem(hMenu, "36", "G41(GFL)");
	AddMenuItem(hMenu, "34", "HK416(GFL)");
	AddMenuItem(hMenu, "39", "UMP45(GFL)");
	AddMenuItem(hMenu, "35", "UMP9(GFL)");
	AddMenuItem(hMenu, "42", "UMP40(GFL)");
	AddMenuItem(hMenu, "38", "WA2000(GFL)");
	AddMenuItem(hMenu, "40", "M4 SOPMOD 2(GFL)");
	AddMenuItem(hMenu, "41", "Springfield M1903(GFL)");
	AddMenuItem(hMenu, "30", "Ran(2hu)");
	AddMenuItem(hMenu, "27", "Raisin(2hu)");
	AddMenuItem(hMenu, "33", "ICG(2hu cookie???)");
	AddMenuItem(hMenu, "32", "HSI(2hu cookie???)");
	AddMenuItem(hMenu, "31", "NYN(2hu cookie???)");
	AddMenuItem(hMenu, "28", "Emilia(ReZero)");
	AddMenuItem(hMenu, "43", "TDA Sweet Migu Loli");
	AddMenuItem(hMenu, "29", "M119 Howitzer");
	AddMenuItem(hMenu, "50", "TEST");
	

	AddMenuItem(hMenu, "2", Translate(iClient, "%t", "Random Common"));
	if(IsModelPrecached(sSpecialPaths[LMCSpecialModelType_Witch]))
		AddMenuItem(hMenu, "3", Translate(iClient, "%t", "Witch"));
	if(IsModelPrecached(sSpecialPaths[LMCSpecialModelType_WitchBride]))
		AddMenuItem(hMenu, "4", Translate(iClient, "%t", "Witch Bride"));
	if(IsModelPrecached(sSpecialPaths[LMCSpecialModelType_Boomer]))
		AddMenuItem(hMenu, "5", Translate(iClient, "%t", "Boomer"));
	if(IsModelPrecached(sSpecialPaths[LMCSpecialModelType_Boomette]))
		AddMenuItem(hMenu, "6", Translate(iClient, "%t", "Boomette"));
	if(IsModelPrecached(sSpecialPaths[LMCSpecialModelType_Hunter]))
		AddMenuItem(hMenu, "7", Translate(iClient, "%t", "Hunter"));
	if(IsModelPrecached(sSpecialPaths[LMCSpecialModelType_Smoker]))
		AddMenuItem(hMenu, "8", Translate(iClient, "%t", "Smoker"));
	if(IsModelPrecached(sUnCommonPaths[LMCUnCommonModelType_RiotCop]))
		AddMenuItem(hMenu, "9", Translate(iClient, "%t", "Riot Cop"));
	if(IsModelPrecached(sUnCommonPaths[LMCUnCommonModelType_MudMan]))
		AddMenuItem(hMenu, "10", Translate(iClient, "%t", "MudMan"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Pilot]))
		AddMenuItem(hMenu, "11", Translate(iClient, "%t", "Chopper Pilot"));
	if(IsModelPrecached(sUnCommonPaths[LMCUnCommonModelType_Ceda]))
		AddMenuItem(hMenu, "12", Translate(iClient, "%t", "CEDA"));
	if(IsModelPrecached(sUnCommonPaths[LMCUnCommonModelType_Clown]))
		AddMenuItem(hMenu, "13", Translate(iClient, "%t", "Clown"));
	if(IsModelPrecached(sUnCommonPaths[LMCUnCommonModelType_Jimmy]))
		AddMenuItem(hMenu, "14", Translate(iClient, "%t", "Jimmy Gibs"));
	if(IsModelPrecached(sUnCommonPaths[LMCUnCommonModelType_Fallen]))
		AddMenuItem(hMenu, "15", Translate(iClient, "%t", "Fallen Survivor"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Nick]))
		AddMenuItem(hMenu, "16", Translate(iClient, "%t", "Nick"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Rochelle]))
		AddMenuItem(hMenu, "17", Translate(iClient, "%t", "Rochelle"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Coach]))
		AddMenuItem(hMenu, "18", Translate(iClient, "%t", "Coach"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Ellis]))
		AddMenuItem(hMenu, "19", Translate(iClient, "%t", "Ellis"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Bill]))
		AddMenuItem(hMenu, "20", Translate(iClient, "%t", "Bill"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Zoey]))// not going to filter light model other checks will get that.
		AddMenuItem(hMenu, "21", Translate(iClient, "%t", "Zoey"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Francis]))// not going to filter light model other checks will get that.
		AddMenuItem(hMenu, "22", Translate(iClient, "%t", "Francis"));
	if(IsModelPrecached(sHumanPaths[LMCHumanModelType_Louis]))
		AddMenuItem(hMenu, "23", Translate(iClient, "%t", "Louis"));

	if(g_bTankModel)
	{
		if(IsModelPrecached(sSpecialPaths[LMCSpecialModelType_Tank]))
			AddMenuItem(hMenu, "24", Translate(iClient, "%t", "Tank"));
		if(IsModelPrecached(sSpecialPaths[LMCSpecialModelType_TankDLC3]))
			AddMenuItem(hMenu, "25", Translate(iClient, "%t", "Tank DLC"));
	}
	SetMenuExitButton(hMenu, true);
	//DisplayMenu(hMenu, iClient, 15);
	DisplayMenuAtItem(hMenu, iClient, iCurrentPage[iClient], 15);
	return Plugin_Continue;
}

public int CharMenu(Handle hMenu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char sItem[4];
			GetMenuItem(hMenu, param2, sItem, sizeof(sItem));
			ModelIndex(param1, StringToInt(sItem), true);
			iCurrentPage[param1] = GetMenuSelectionPosition();
			ShowMenu(param1, 0);
		}
		case MenuAction_Cancel:
		{
			iCurrentPage[param1] = 0;
		}
		case MenuAction_End:
		{
			CloseHandle(hMenu);
		}
	}
}

void ModelIndex(int iClient, int iCaseNum, bool bUsingMenu=false)
{
	if(AreClientCookiesCached(iClient) && bUsingMenu)
	{
		char sCookie[3];
		IntToString(iCaseNum, sCookie, sizeof(sCookie));
		SetClientCookie(iClient, hCookie_LmcCookie, sCookie);
	}
	iSavedModel[iClient] = iCaseNum;

	if(!IsPlayerAlive(iClient))
		return;

	switch(GetClientTeam(iClient))
	{
		case 3:
		{
			switch(GetEntProp(iClient, Prop_Send, "m_zombieClass"))
			{
				case ZOMBIECLASS_SMOKER:
				{
					if(!g_bAllowSmoker)
					{
						if(!bUsingMenu && !bAutoBlockedMsg[iClient][0])
							return;

						CPrintToChat(iClient, "%t", "Disabled_Models_Smoker"); // "\x04[LMC] \x03Server Has Disabled Models for \x04Smoker");
						bAutoBlockedMsg[iClient][0] = false;
						return;
					}
				}
				case ZOMBIECLASS_BOOMER:
				{
					if(!g_bAllowBoomer)
					{
						if(!bUsingMenu && !bAutoBlockedMsg[iClient][1])
							return;

						CPrintToChat(iClient, "%t", "Disabled_Models_Boomer"); // "\x04[LMC] \x03Server Has Disabled Models for \x04Boomer");
						bAutoBlockedMsg[iClient][1] = false;
						return;
					}
				}
				case ZOMBIECLASS_HUNTER:
				{
					if(!g_bAllowHunter)
					{
						if(!bUsingMenu && !bAutoBlockedMsg[iClient][2])
							return;

						CPrintToChat(iClient, "%t", "Disabled_Models_Hunter"); // "\x04[LMC] \x03Server Has Disabled Models for \x04Hunter");
						bAutoBlockedMsg[iClient][2] = false;
						return;
					}
				}
				case ZOMBIECLASS_SPITTER:
				{
					if(!bUsingMenu && !bAutoBlockedMsg[iClient][3])
						return;

					CPrintToChat(iClient, "%t", "Unsupported_Spitter"); // "\x04[LMC] \x03Models Don't Work for \x04Spitter");
					bAutoBlockedMsg[iClient][3] = false;
					return;
				}
				case ZOMBIECLASS_JOCKEY:
				{
					if(!bUsingMenu && !bAutoBlockedMsg[iClient][4])
						return;

					CPrintToChat(iClient, "%t", "Unsupported_Jockey"); // "\x04[LMC] \x03Models Don't Work for \x04Jockey");
					bAutoBlockedMsg[iClient][4] = false;
					return;
				}
				case ZOMBIECLASS_CHARGER:
				{
					if(IsFakeClient(iClient))
						return;

					if(!bUsingMenu && !bAutoBlockedMsg[iClient][5])
						return;

					CPrintToChat(iClient, "%t", "Unsupported_Charger"); // "\x04[LMC] \x03Models Don't Work for \x04Charger");
					bAutoBlockedMsg[iClient][5] = false;
					return;
				}
				case ZOMBIECLASS_TANK:
				{
					if(!g_bAllowTank)
					{
						if(!bUsingMenu && !bAutoBlockedMsg[iClient][6])
							return;

						CPrintToChat(iClient, "%t", "Disabled_Models_Tank"); // "\x04[LMC] \x03Server Has Disabled Models for \x04Tank");
						bAutoBlockedMsg[iClient][6] = false;
						return;
					}
				}
			}
		}
		case 2:
		{
			if(!g_bAllowSurvivors)
			{
				if(!bUsingMenu && !bAutoBlockedMsg[iClient][7])
					return;

				CPrintToChat(iClient, "%t", "Disabled_Models_Survivors"); // "\x04[LMC] \x03Server Has Disabled Models for \x04Survivors");
				bAutoBlockedMsg[iClient][7] = false;
				return;
			}
		}
		default:
			return;
	}

	//model selection
	switch(iCaseNum)
	{
		case 1:
		{
			ResetDefaultModel(iClient);
			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Default_Models"); // "\x04[LMC] \x03Models will be default");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
			return;
		}
		case 2:
		{
			static int iChoice = 0;//+1 each time any player picks a common infected
			static int iLastValidModel = 0;// just try until we have a valid model to give people.
			if(!IsModelValid(iClient, LMCModelSectionType_Common, iChoice))
			{
				if(IsModelValid(iClient, LMCModelSectionType_Common, iLastValidModel))
					LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCommonPaths[iLastValidModel]));
			}
			else
			{
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCommonPaths[iChoice]));
				iLastValidModel = iChoice;
			}

			if(++iChoice >= COMMON_MODEL_PATH_SIZE)
				iChoice = 0;

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Common"); // "\x04[LMC] \x03Model is \x04Common Infected");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 3:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Special, view_as<int>(LMCSpecialModelType_Witch)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sSpecialPaths[LMCSpecialModelType_Witch]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Witch"); // "\x04[LMC] \x03Model is \x04Witch");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 4:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Special, view_as<int>(LMCSpecialModelType_WitchBride)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sSpecialPaths[LMCSpecialModelType_WitchBride]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Witch_Bride"); // "\x04[LMC] \x03Model is \x04Witch Bride");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 5:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Special, view_as<int>(LMCSpecialModelType_Boomer)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sSpecialPaths[LMCSpecialModelType_Boomer]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Boomer"); // "\x04[LMC] \x03Model is \x04Boomer");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 6:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Special, view_as<int>(LMCSpecialModelType_Boomette)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sSpecialPaths[LMCSpecialModelType_Boomette]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Boomette"); // "\x04[LMC] \x03Model is \x04Boomette");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 7:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Special, view_as<int>(LMCSpecialModelType_Hunter)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sSpecialPaths[LMCSpecialModelType_Hunter]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;
			CPrintToChat(iClient, "%t", "Model_Hunter"); // "\x04[LMC] \x03Model is \x04Hunter");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 8:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Special, view_as<int>(LMCSpecialModelType_Smoker)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sSpecialPaths[LMCSpecialModelType_Smoker]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Smoker"); // "\x04[LMC] \x03Model is \x04Smoker");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 9:
		{
			if(IsModelValid(iClient, LMCModelSectionType_UnCommon, view_as<int>(LMCUnCommonModelType_RiotCop)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sUnCommonPaths[LMCUnCommonModelType_RiotCop]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_RiotCop"); // "\x04[LMC] \x03Model is \x04RiotCop");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 10:
		{
			if(IsModelValid(iClient, LMCModelSectionType_UnCommon, view_as<int>(LMCUnCommonModelType_MudMan)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sUnCommonPaths[LMCUnCommonModelType_MudMan]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_MudMen"); // "\x04[LMC] \x03Model is \x04MudMen");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 11:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Pilot)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Pilot]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Chopper_Pilot"); // "\x04[LMC] \x03Model is \x04Chopper Pilot");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 12:
		{
			if(IsModelValid(iClient, LMCModelSectionType_UnCommon, view_as<int>(LMCUnCommonModelType_Ceda)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sUnCommonPaths[LMCUnCommonModelType_Ceda]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_CEDA"); // "\x04[LMC] \x03Model is \x04CEDA Suit");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 13:
		{
			if(IsModelValid(iClient, LMCModelSectionType_UnCommon, view_as<int>(LMCUnCommonModelType_Clown)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sUnCommonPaths[LMCUnCommonModelType_Clown]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Clown"); // "\x04[LMC] \x03Model is \x04Clown");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 14:
		{
			if(IsModelValid(iClient, LMCModelSectionType_UnCommon, view_as<int>(LMCUnCommonModelType_Jimmy)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sUnCommonPaths[LMCUnCommonModelType_Jimmy]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Jimmy_Gibs"); // "\x04[LMC] \x03Model is \x04Jimmy Gibs");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 15:
		{
			if(IsModelValid(iClient, LMCModelSectionType_UnCommon, view_as<int>(LMCUnCommonModelType_Fallen)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sUnCommonPaths[LMCUnCommonModelType_Fallen]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Fallen_Survivor"); // "\x04[LMC] \x03Model is \x04Fallen Survivor");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		case 16:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Nick)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Nick]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Nick"); // "\x04[LMC] \x03Model is \x04Nick");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 17:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Rochelle)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Rochelle]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Rochelle"); // "\x04[LMC] \x03Model is \x04Rochelle");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 18:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Coach)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Coach]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Coach"); // "\x04[LMC] \x03Model is \x04Coach");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 19:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Ellis)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Ellis]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Ellis"); // "\x04[LMC] \x03Model is \x04Ellis");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 20:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Bill)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Bill]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Bill"); // "\x04[LMC] \x03Model is \x04Bill");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 21:
		{
			if(GetRandomInt(1, 100) >= 50)
			{
				if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Zoey)))
					LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Zoey]));
			}
			else
			{
				if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_ZoeyLight)))
					LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_ZoeyLight]));
				else if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Zoey)))
					LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Zoey]));
			}

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Zoey"); // "\x04[LMC] \x03Model is \x04Zoey");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 22:
		{
			if(GetRandomInt(1, 100) >= 50)
			{
				if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Francis)))
					LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Francis]));
			}
			else
			{
				if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_FrancisLight)))
					LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_FrancisLight]));
				else if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Francis)))
					LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Francis]));
			}

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Francis"); // "\x04[LMC] \x03Model is \x04Francis");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 23:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Human, view_as<int>(LMCHumanModelType_Louis)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sHumanPaths[LMCHumanModelType_Louis]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Louis"); // "\x04[LMC] \x03Model is \x04Louis");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 24:
		{
			if(!g_bTankModel)
				return;

			if(IsModelValid(iClient, LMCModelSectionType_Special, view_as<int>(LMCSpecialModelType_Tank)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sSpecialPaths[LMCSpecialModelType_Tank]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Tank"); // "\x04[LMC] \x03Model is \x04Tank");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 25:
		{
			if(!g_bTankModel)
				return;

			if(IsModelValid(iClient, LMCModelSectionType_Special, view_as<int>(LMCSpecialModelType_TankDLC3)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sSpecialPaths[LMCSpecialModelType_TankDLC3]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			CPrintToChat(iClient, "%t", "Model_Tank_DLC"); // "\x04[LMC] \x03Model is \x04Tank DLC");
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 26:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_GENE)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_GENE]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Gene(PSO2)");

			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 27:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_RAISIN)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_RAISIN]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Raisin(2hu)");

			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 28:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_EMILIA)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_EMILIA]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Emilia(ReZero)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 29:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_M119HOWITZER)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_M119HOWITZER]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04M119 Howitzer");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 30:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_RAN)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_RAN]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Ran(2hu)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 31:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_NYN)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_NYN]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04NYN(2hu cookie???)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 32:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_HSI)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_HSI]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04HSI(2hu cookie???)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 33:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_ICG)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_ICG]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04ICG(2hu cookie???)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 34:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_HK416)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_HK416]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04HK416(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 35:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_UMP9)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_UMP9]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04UMP9(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 36:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_G41)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_G41]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04G41(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 37:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_G11)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_G11]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04G11(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 38:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_WA2000)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_WA2000]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04WA2000(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 39:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_UMP45)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_UMP45]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04UMP45(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 40:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_M4SOPMOD2)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_M4SOPMOD2]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04M4 SOPMOD 2(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 41:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_M1903)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_M1903]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Springfield M1903(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 42:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_UMP40)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_UMP40]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04UMP40(Girls Frontline)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 43:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_TDASWEETMIGULOLI)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_TDASWEETMIGULOLI]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04TDA Sweet Migu Loli(Brokaloid)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 44:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_AKAIHAATO)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_AKAIHAATO]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Akai Haato(Hololive)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 45:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_INUBASHIRIMOMIJI)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_INUBASHIRIMOMIJI]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Inubashiri Momiji(2hu)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 46:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_MURASAKISHION)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_MURASAKISHION]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Murasaki Shion(Hololive)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}
		case 47:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_AR15)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_AR15]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04AR15(GFL)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		case 48:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_M4A1)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_M4A1]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04M4A1(GFL)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		case 49:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_MINATOAQUA)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_MINATOAQUA]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Minato Aqua(Hololive)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		case 50:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_TEST)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_TEST]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04TEST");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		case 51:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_SHIRAKAMIFUBUKI)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_SHIRAKAMIFUBUKI]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Shirakami Fubuki(Hololive)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		case 52:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_NATSUIROMATSURI)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_NATSUIROMATSURI]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Natsuiro Matsuri(Hololive)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		case 53:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_KUROKAMIFUBUKI)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_KUROKAMIFUBUKI]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Kurokami Fubuki(Hololive)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		case 54:
		{
			if(IsModelValid(iClient, LMCModelSectionType_Custom, view_as<int>(MODEL_YUZUKICHOCO)))
				LMC_L4D2_SetTransmit(iClient, LMC_SetClientOverlayModel(iClient, sCustomPaths[MODEL_YUZUKICHOCO]));

			if(!bUsingMenu && !bAutoApplyMsg[iClient])
				return;

			PrintToChat(iClient, "\x04[LMC] \x03Model is \x04Yuzuki Choco(Hololive)");
			
			SetExternalView(iClient);
			bAutoApplyMsg[iClient] = false;
		}

		//Z:***ADD NEW CASE HERE. SAVE AND COMPILE
		
	}
	bAutoApplyMsg[iClient] = false;
}

public void OnClientPostAdminCheck(int iClient)
{
	if(IsFakeClient(iClient))
		return;

	if(g_iAnnounceMode != 0 && !g_bAdminOnly)
		CreateTimer(g_fAnnounceDelay, iClientInfo, GetClientUserId(iClient), TIMER_FLAG_NO_MAPCHANGE);
}

public Action iClientInfo(Handle hTimer, any iUserID)
{
	int iClient = GetClientOfUserId(iUserID);
	if(iClient < 1 || iClient > MaxClients || !IsClientInGame(iClient))
		return Plugin_Stop;

	switch(g_iAnnounceMode)
	{
		case 1:
		{
			CPrintToChat(iClient, "%t", "Change_Model_Help_Chat"); // "\x04[LMC] \x03To Change Model use chat Command \x04!lmc\x03");
			EmitSoundToClient(iClient, sJoinSound, SOUND_FROM_PLAYER, SNDCHAN_STATIC);
		}
		case 2: PrintHintText(iClient, "%t", "Change_Model_Help_Hint"); // "[LMC] To Change Model use chat Command !lmc");
		case 3:
		{
			int iEntity = CreateEntityByName("env_instructor_hint");
			if(iEntity < 1)
				return Plugin_Stop;
				
			char sValues[64];
			
			FormatEx(sValues, sizeof(sValues), "hint%d", iClient);
			DispatchKeyValue(iClient, "targetname", sValues);
			DispatchKeyValue(iEntity, "hint_target", sValues);
			
			Format(sValues, sizeof(sValues), "10");
			DispatchKeyValue(iEntity, "hint_timeout", sValues);
			DispatchKeyValue(iEntity, "hint_range", "100");
			DispatchKeyValue(iEntity, "hint_icon_onscreen", "icon_tip");
			DispatchKeyValue(iEntity, "hint_caption", Translate(iClient, "%t", "Change_Model_Help_Hint")); // "[LMC] To Change Model use chat Command !lmc");
			Format(sValues, sizeof(sValues), "%i %i %i", GetRandomInt(1, 255), GetRandomInt(100, 255), GetRandomInt(1, 255));
			DispatchKeyValue(iEntity, "hint_color", sValues);
			DispatchSpawn(iEntity);
			AcceptEntityInput(iEntity, "ShowHint", iClient);
			
			SetVariantString("OnUser1 !self:Kill::6:1");
			AcceptEntityInput(iEntity, "AddOutput");
			AcceptEntityInput(iEntity, "FireUser1");
		}
	}
	return Plugin_Stop;
}

bool IsModelValid(int iClient, LMCModelSectionType iModelSectionType, int iModelIndex)
{
	char sCurrentModel[PLATFORM_MAX_PATH];
	GetClientModel(iClient, sCurrentModel, sizeof(sCurrentModel));

	switch(iModelSectionType)
	{
		case LMCModelSectionType_Human:
		{
			bool bSameModel = false;
			bSameModel = StrEqual(sCurrentModel, sHumanPaths[iModelIndex], false);
			if(!bSameModel && IsModelPrecached(sHumanPaths[iModelIndex]))
				return true;

			if(bSameModel)
				ResetDefaultModel(iClient);

			return false;
		}
		case LMCModelSectionType_Special:
		{
			bool bSameModel = false;
			bSameModel = StrEqual(sCurrentModel, sSpecialPaths[iModelIndex], false);
			if(!bSameModel && IsModelPrecached(sSpecialPaths[iModelIndex]))
				return true;

			if(bSameModel)
				ResetDefaultModel(iClient);

			return false;
		}
		case LMCModelSectionType_UnCommon:
		{
			bool bSameModel = false;
			bSameModel = StrEqual(sCurrentModel, sUnCommonPaths[iModelIndex], false);
			if(!bSameModel && IsModelPrecached(sUnCommonPaths[iModelIndex]))
				return true;

			if(bSameModel)
				ResetDefaultModel(iClient);

			return false;
		}
		case LMCModelSectionType_Common:
		{
			bool bSameModel = false;
			bSameModel = StrEqual(sCurrentModel, sCommonPaths[iModelIndex], false);
			if(!bSameModel && IsModelPrecached(sCommonPaths[iModelIndex]))
				return true;

			if(bSameModel)
				ResetDefaultModel(iClient);

			return false;
		}
		case LMCModelSectionType_Custom:
		{
			bool bSameModel = false;
			bSameModel = StrEqual(sCurrentModel, sCustomPaths[iModelIndex], false);
			if(!bSameModel && IsModelPrecached(sCustomPaths[iModelIndex]))
				return true;

			if(bSameModel)
				ResetDefaultModel(iClient);

			return false;
		}
	}
	ResetDefaultModel(iClient);
	return false;

}

void ResetDefaultModel(int iClient)
{
	int iOverlayModel = LMC_GetClientOverlayModel(iClient);
	if(iOverlayModel > -1)
		AcceptEntityInput(iOverlayModel, "kill");

	LMC_ResetRenderMode(iClient);
}

public void OnClientDisconnect(int iClient)
{
	//1.3
	if(AreClientCookiesCached(iClient))
	{
		char sCookie[3];
		IntToString(iSavedModel[iClient], sCookie, sizeof(sCookie));
		SetClientCookie(iClient, hCookie_LmcCookie, sCookie);
	}
	iCurrentPage[iClient] = 0;
	bAutoApplyMsg[iClient] = true;//1.4
	for(int i = 0; i < sizeof(bAutoBlockedMsg[]); i++)//1.4
		bAutoBlockedMsg[iClient][i] = true;

	iSavedModel[iClient] = 0;
}

public void OnClientCookiesCached(int iClient)
{
	char sCookie[3];
	GetClientCookie(iClient, hCookie_LmcCookie, sCookie, sizeof(sCookie));
	if(StrEqual(sCookie, "\0", false))
		return;

	iSavedModel[iClient] = StringToInt(sCookie);

	if(!IsClientInGame(iClient) || !IsPlayerAlive(iClient))
		return;

	if(g_bAdminOnly && !CheckCommandAccess(iClient, "sm_lmc", COMMAND_ACCESS, true))
			return;

	ModelIndex(iClient, iSavedModel[iClient], false);
}

public void LMC_OnClientModelApplied(int iClient, int iEntity, const char sModel[PLATFORM_MAX_PATH], bool bBaseReattach)
{
	if(bBaseReattach)//if true because orignal overlay model has been killed
		LMC_L4D2_SetTransmit(iClient, iEntity);
}


void SetExternalView(int iClient)
{
	if(g_fThirdPersonTime < 0.5)// best time any lower is kinda pointless
		return;
	
	float fCurrentTPtime = GetForcedThirdPerson(iClient);
	float fTime = GetGameTime();
	if(fCurrentTPtime > (fTime + g_fThirdPersonTime))
		return;
	
	if(fCurrentTPtime < fTime + 0.5)
		if(fCurrentTPtime > fTime - 1.0)//helps to prevent a strange rare bug with models that include particles(e.g. witch) model spamming just about to go back to firstperson, causing stuff to not render correctly (Could be only me) this seems to be client bug, this only seems to happen on maps with modded func_precipitation.
			return;
	
	SetEntPropFloat(iClient, Prop_Send, "m_TimeForceExternalView", fTime + g_fThirdPersonTime);
}


float GetForcedThirdPerson(int iClient)
{
	return GetEntPropFloat(iClient, Prop_Send, "m_TimeForceExternalView");
}
