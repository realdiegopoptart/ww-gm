/*
					 __________________________________________________
					|												   |
					|            Server Side Health/Armour        	   |
					|              ------------------              	   |
					|          	   	Created by: VSM         	       |
					|     		  Copyright ©2014, VSM     			   |
					| http://creativecommons.org/licenses/by-nc-nd/4.0 |
					|__________________________________________________|

--------------------------------------------------------------------------------
	MESSAGE FROM VSM
--------------------------------------------------------------------------------
Server Side Health/Armour from Imperious Roleplay (www.im-rp.net).
Please leave the rightful credits with me if you're using this include.

--------------------------------------------------------------------------------
	NOTES
--------------------------------------------------------------------------------
NOTE #1: Use szSetPlayerHealth() and szSetPlayerArmour() functions for setting Health/Armour.
NOTE #2: This include removes all Sprunks/Vending Machines.
		 Dynamic Sprunks/Vending Machines can be added if needed.
		 Or the player animation can be checked and a bypass condition can be added to szHeartBeat().
--------------------------------------------------------------------------------

*/
//------------------------------------------------------------------------------
// CONFIGURATION
//------------------------------------------------------------------------------
#if defined _ssha_included
	#endinput
#endif
#define _ssha_included

//------------------------------------------------------------------------------
// PREPROCESSOR DIRECTIVES
//------------------------------------------------------------------------------
#include <a_samp>

//------------------------------------------------------------------------------
// DEFINES AND ENUMS
//------------------------------------------------------------------------------
#define PLAYER_HEALTH_HACK (1)
#define PLAYER_ARMOUR_HACK (2)

enum ePlayerData
{
	Float:pHealth,
	Float:pArmour,
	Float:WeaponDamage
}
new PlayerVariables[MAX_PLAYERS][ePlayerData];

//------------------------------------------------------------------------------
// FUNCTIONS
//------------------------------------------------------------------------------
forward ResetWeaponDamage(playerid);
forward OnPlayerHack(playerid, hackid, newamount, oldamount);
forward szHeartBeat();

public ResetWeaponDamage(playerid) PlayerVariables[playerid][WeaponDamage] = 0.0;

public szHeartBeat()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(GetPlayerState(i) == PLAYER_STATE_WASTED) break;
		new Float:armour, Float:health; GetPlayerArmour(i, armour); GetPlayerHealth(i, health);
		if(armour > PlayerVariables[i][pArmour] + PlayerVariables[i][WeaponDamage] && armour > 0)
		{
			CallRemoteFunction("OnPlayerHack", "dddd", i, PLAYER_ARMOUR_HACK, armour, PlayerVariables[i][pArmour]);
		    SetPlayerArmour(i, PlayerVariables[i][pArmour]);
		}
		else if(health > PlayerVariables[i][pHealth] + PlayerVariables[i][WeaponDamage] && health > 0)
		{
			CallRemoteFunction("OnPlayerHack", "dddd",i, PLAYER_HEALTH_HACK, health, PlayerVariables[i][pHealth]);
		    SetPlayerHealth(i, PlayerVariables[i][pHealth]);
		}
		else
		{
			PlayerVariables[i][pHealth] = health;
			PlayerVariables[i][pArmour] = armour;
		}
	}
	return 1;
}
/* Sample code to add to the GameMode.
public OnPlayerHack(playerid, hackid, newamount, oldamount)
{
	new string[128];
	switch(hackid)
	{
		case PLAYER_HEALTH_HACK:
		{
			format(string, sizeof(string), "{FF6347}Warning:{FFFF00} (ID: %d) %s may be health hacking, %f health was found while they have %f.", playerid, szGetPlayerName(playerid), newamount, oldamount);
			SendClientMessageToAll(0, string);

		}
		case PLAYER_ARMOUR_HACK:
		{
			format(string, sizeof(string), "{FF6347}Warning:{FFFF00} (ID: %d) %s may be armour hacking, %f armour was found while they have %f.", playerid, szGetPlayerName(playerid), newamount, oldamount);
			SendClientMessageToAll(0, string);
		}
	}
	return 1;
}
*/

//------------------------------------------------------------------------------
// LOCAL CALLBACKS
//------------------------------------------------------------------------------
public OnGameModeInit()
{
	printf("This server uses VSM's Server Side Health/Armour.");
	SetTimer("szHeartBeat", 1000, true);
    return CallLocalFunction("ALS_OnGameModeInit", "");
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit ALS_OnGameModeInit
forward ALS_OnGameModeInit();

public OnPlayerConnect(playerid)
{
	// Global Removal of Sprunks/Vending Machines.
	RemoveBuildingForPlayer(playerid, 955, 0, 0, 0, 50000);
 	RemoveBuildingForPlayer(playerid, 956, 0, 0, 0, 50000);
    RemoveBuildingForPlayer(playerid, 1209, 0, 0, 0, 50000);
    RemoveBuildingForPlayer(playerid, 1302, 0, 0, 0, 50000);
    RemoveBuildingForPlayer(playerid, 1775, 0, 0, 0, 50000);
    RemoveBuildingForPlayer(playerid, 1776, 0, 0, 0, 50000);
	PlayerVariables[playerid][WeaponDamage] = 0.0;
    return CallLocalFunction("ALS_OnPlayerConnect", "d", playerid);
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect ALS_OnPlayerConnect
forward ALS_OnPlayerConnect(playerid);

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
	PlayerVariables[playerid][WeaponDamage] = amount;
	SetTimerEx("ResetWeaponDamage", GetPlayerPing(playerid)+1000, false, "i", playerid); // PlayerPing+1000 is the default timer value for proper sync.
    return CallLocalFunction("ALS_OnPlayerTakeDamage", "ddfd",playerid, issuerid, amount, weaponid);
}
#if defined _ALS_OnPlayerTakeDamage
    #undef OnPlayerTakeDamage
#else
    #define _ALS_OnPlayerTakeDamage
#endif
#define OnPlayerTakeDamage ALS_OnPlayerTakeDamage
forward ALS_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid);

//------------------------------------------------------------------------------
// STOCK FUNCTIONS
//------------------------------------------------------------------------------
stock szGetPlayerName(playerid)
{
	new pName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
	return pName;
}

stock szSetPlayerArmour(playerid, Float:amount)
{
	PlayerVariables[playerid][pArmour] = amount;
	SetPlayerArmour(playerid, PlayerVariables[playerid][pArmour]);
	return 1;
}

stock szSetPlayerHealth(playerid, Float:amount)
{
	PlayerVariables[playerid][pHealth] = amount;
    SetPlayerHealth(playerid, amount);
	return 1;
}

//------------------------------------------------------------------------------
// THE END
//------------------------------------------------------------------------------