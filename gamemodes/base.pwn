//weaponized warfare gamemode
//scripted by ryan (chyakka)
//credits
//y_less for foreach and sscanf
//emmet_ for easydialog
//ZCMD for zcmd
//maddinat0r for discord-connector
//SecretBoss for UCP base (modernized to work with new php version)

#include <a_samp>

#define SERVER_GM_TEXT "WW:DM"

#undef MAX_PLAYERS
#define MAX_PLAYERS (50)
#include <a_mysql>
#include <core>
#include <float>
#include <discord-connector>
#include <streamer>
#include <zcmd>
#include <YSI\y_timers>
#include <YSI\y_utils>
#include <easyDialog>
#include <foreach>
#include <sscanf2>
#include <colors>

native WP_Hash(buffer[], len, const str[]);

#include "./includes/defines.pwn"
#include "./includes/enums.pwn"
#include "./includes/variables.pwn"
#include "./includes/functions.pwn"
#include "./includes/commands.pwn"
#include "./includes/anticheat.pwn"


main()
{
	print("\n----------------------------------");
	print("  Weaponized Warfare \n");
	print("----------------------------------\n");
}

new Corrupt_Check[MAX_PLAYERS];

mysql_init()
{
	new MySQLOpt: option_id = mysql_init_options();
	
 	mysql_set_option(option_id, AUTO_RECONNECT, true);

	MainPipeline = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATABASE, option_id);
	
	mysql_log(DEBUG);

	if(MainPipeline == MYSQL_INVALID_HANDLE || mysql_errno(MainPipeline) != 0)
	{
		if (_:g_GamemodeChannelId == 0)
		g_GamemodeChannelId = DCC_FindChannelById("");
		new str[128];
		format(str, sizeof str, "``GAMEMODE: Failed to connect to the MYSQL server, shutting down...``");
		DCC_SendChannelMessage(g_GamemodeChannelId, str);
		SendRconCommand("exit");
		return 1;
	}

   	if (_:g_GamemodeChannelId == 0)
	g_GamemodeChannelId = DCC_FindChannelById("");
	new str2[128];
	format(str2, sizeof str2, "``GAMEMODE: Successfully connected to the MYSQL server.``");
	DCC_SendChannelMessage(g_GamemodeChannelId, str2);
	return 1;
}
    
public OnGameModeInit()
{
	SetGameModeText("WW:DM WAR 1.0b");
	UsePlayerPedAnims();
	ShowPlayerMarkers(1);
	EnableStuntBonusForAll(0);
 	LimitPlayerMarkerRadius(3000.0);
  	DisableInteriorEnterExits();
 	
 	mysql_init();
 	veh_init();
 	veh_respawn();
 	AnnouncementTimer();
 	
	if (_:g_GamemodeChannelId == 0)
		g_GamemodeChannelId = DCC_FindChannelById("");

	new str[128];
 	gettime(Hour, Minute, Second);
	format(str, sizeof str, "``%02d:%02d:%02d - GAMEMODE: Gamemode Initiated. (version: 1.0b) (GM Text: WW:DM 1.0b) (IP: 213.32.15.137)``", Hour, Minute, Second);
	DCC_SendChannelMessage(g_GamemodeChannelId, str);

	AddPlayerClass(285,1958.3783,1343.1572,15.3746,270.1425,0,0,0,0,-1,-1);
	return 1;
}

public OnGameModeExit()
{
	foreach(new i: Player)
    {
		if(IsPlayerConnected(i))
		{
			OnPlayerDisconnect(i, 1);
		}
	}
	mysql_close(MainPipeline);
	new string[128];

	if (_:g_GamemodeChannelId == 0)
		g_GamemodeChannelId = DCC_FindChannelById("");
 	gettime(Hour, Minute, Second);
	format(string, sizeof string, "``%02d:%02d:%02d - GAMEMODE: Server shutting down...``", Hour, Minute, Second);
	DCC_SendChannelMessage(g_GamemodeChannelId, string);
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(!ispassenger)
	{
	    SetPlayerArmedWeapon(playerid, 0);
	}
}

public OnPlayerSpawn(playerid)
{
	new Random = random(sizeof(RandomSpawns)), playervw;
	playervw = GetPlayerVirtualWorld(playerid);
	SetPlayerPos(playerid, RandomSpawns[Random][0], RandomSpawns[Random][1], RandomSpawns[Random][2]);
    SetPlayerFacingAngle(playerid, RandomSpawns[Random][3]);
    GiveServerWeapon(playerid, 27, 10000);
    GiveServerWeapon(playerid, 31, 10000);
	GiveServerWeapon(playerid, 24, 10000);
	GiveServerWeapon(playerid, 34, 10000);
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);
	if(playervw != 0) {
	SetPlayerVirtualWorld(playerid, 0);
	}
	TogglePlayerClock(playerid, 0);
	SetTimerEx("PingTimer", 10000, true, "i", playerid);
	return 1;
}

forward public OnPlayerDataCheck(playerid, corrupt_check);
public OnPlayerDataCheck(playerid, corrupt_check)
{
	if (corrupt_check != Corrupt_Check[playerid]) return Kick(playerid);

	new String[150];

	if(cache_num_rows() > 0)
	{
		cache_get_value(0, "PASSWORD", pInfo[playerid][Password], 129);

		pInfo[playerid][Player_Cache] = cache_save();

		format(String, sizeof(String), "{FFFFFF}Welcome back, %s.\n\n{FFFFFF}This account is already registered.\n\
		{FFFFFF}Please, input your password below to login.\n", pInfo[playerid][Name]);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login System", String, "Login", "Leave");
	}
	else
	{
		format(String, sizeof(String), "{FFFFFF}Welcome %s.\n\n{FFFFFF}This account is not registered.\n\
		{FFFFFF}Please input your desired password below to register.\n\n", pInfo[playerid][Name]);
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration System", String, "Register", "Leave");
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	new DB_Query[115], name[MAX_PLAYER_NAME + 1], ip[16];
	GetPlayerName(playerid, name, sizeof name);
	pInfo[playerid][PasswordFails] = 0;
	
	playercount++;
	
	GetPlayerName(playerid, pInfo[playerid][Name], MAX_PLAYER_NAME);
	Corrupt_Check[playerid]++;

	mysql_format(MainPipeline, DB_Query, sizeof(DB_Query), "SELECT * FROM `players` WHERE `USERNAME` = '%e'", pInfo[playerid][Name]);
	mysql_tquery(MainPipeline, DB_Query, "OnPlayerDataCheck", "ii", playerid, Corrupt_Check[playerid]);

	if (_:g_PlayerChannelId == 0)
		g_PlayerChannelId = DCC_FindChannelById("");

	new str[128];
 	GetPlayerIp(playerid, ip, sizeof(ip));
 	gettime(Hour, Minute, Second);
	format(str, sizeof str, "``%02d:%02d:%02d - PLAYER: %s has connected to the server. (IP: %s)``", Hour, Minute, Second, name, ip);
	DCC_SendChannelMessage(g_PlayerChannelId, str);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    Corrupt_Check[playerid]++;

	new DB_Query[256];
	
	playercount--;
	
	mysql_format(MainPipeline, DB_Query, sizeof(DB_Query), "UPDATE `players` SET `SCORE` = %d, `CASH` = %d, `ADMIN` = %d, `BANNED` = %d, `KILLS` = %d, `DEATHS` = %d, `IP` = '%s', `REPORTMUTED` = %d WHERE `ID` = %d",
	pInfo[playerid][Score], pInfo[playerid][Cash], pInfo[playerid][Admin], pInfo[playerid][Banned], pInfo[playerid][Kills], pInfo[playerid][Deaths], pInfo[playerid][IP], pInfo[playerid][rMuted], pInfo[playerid][ID]);
	mysql_tquery(MainPipeline, DB_Query);

	if(cache_is_valid(pInfo[playerid][Player_Cache]))
	{
		cache_delete(pInfo[playerid][Player_Cache]);
		pInfo[playerid][Player_Cache] = MYSQL_INVALID_CACHE;
	}

	pInfo[playerid][LoggedIn] = false;
	
 	new szString[64], playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, MAX_PLAYER_NAME);

    new szDisconnectReason[3][] =
    {
        "Timed Out",
        "Quit",
        "Kick/Ban"
    };
    
	if (_:g_PlayerChannelId == 0)
	g_PlayerChannelId = DCC_FindChannelById("");
 	gettime(Hour, Minute, Second);
    format(szString, sizeof szString, "``%02d:%02d:%02d - PLAYER: %s has left the server (%s).``", Hour, Minute, Second, playerName, szDisconnectReason[reason]);
   	DCC_SendChannelMessage(g_PlayerChannelId, szString);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DIALOG_LOGIN:
		{
			if(!response) return Kick(playerid);

			new key[129];
			WP_Hash(key, sizeof (key), inputtext);

			if(strcmp(key, pInfo[playerid][Password]) == 0)
			{
				cache_set_active(pInfo[playerid][Player_Cache]);
            	cache_get_value_int(0, "ID", pInfo[playerid][ID]);
        		cache_get_value_int(0, "KILLS", pInfo[playerid][Kills]);
        		cache_get_value_int(0, "DEATHS", pInfo[playerid][Deaths]);
        		cache_get_value_int(0, "SCORE", pInfo[playerid][Score]);
        		cache_get_value_int(0, "ADMIN", pInfo[playerid][Admin]);
        		cache_get_value_int(0, "BANNED", pInfo[playerid][Banned]);
        		cache_get_value_int(0, "CASH", pInfo[playerid][Cash]);
        		cache_get_value_int(0, "REPORTMUTED", pInfo[playerid][rMuted]);
        		cache_get_value_name(0, "IP", pInfo[playerid][IP]);

        		SetPlayerScore(playerid, pInfo[playerid][Score]);
        		ResetPlayerMoney(playerid);
        		GivePlayerMoney(playerid, pInfo[playerid][Cash]);
				cache_delete(pInfo[playerid][Player_Cache]);
				pInfo[playerid][Player_Cache] = MYSQL_INVALID_CACHE;
				GetPlayerIp(playerid, pInfo[playerid][IP], 16);

				if(pInfo[playerid][Banned] > 0) {
					new szString[128];
					if (_:g_PlayerChannelId == 0)
					g_PlayerChannelId = DCC_FindChannelById("");
					gettime(Hour, Minute, Second);
				   	format(szString, sizeof szString, "``%02d:%02d:%02d - PLAYER: %s has attempted to login while being banned (IP: %s).``", Hour, Minute, Second, pInfo[playerid][Name], pInfo[playerid][IP]);
				   	DCC_SendChannelMessage(g_PlayerChannelId, szString);
	    			SendClientMessage(playerid, 0xFF0000FF, "You are currently banned, contact an administrator.");
    				SetTimerEx("KickDelay", 1000, false, "i", playerid);
	    			return 1;
				}
                for(new i = 0; i < 32; i++) SendClientMessage(playerid, COLOR_WHITE, " ");
				pInfo[playerid][LoggedIn] = true;
				SendClientMessage(playerid, 0x00FF00FF, "You have successfully logged in.");
			}
			else
			{
			new String[150], szString[128];

			pInfo[playerid][PasswordFails] += 1;

			if (_:g_PlayerChannelId == 0)
				g_PlayerChannelId = DCC_FindChannelById(""); 

		   	format(szString, sizeof szString, "``%02d:%02d:%02d - PLAYER: %s has failed to login due to incorrect password. (%d attempts).``", Hour, Minute, Second, pInfo[playerid][Name], pInfo[playerid][PasswordFails]);
		   	DCC_SendChannelMessage(g_PlayerChannelId, szString);

			if (pInfo[playerid][PasswordFails] >= 2)
			{
				SetTimerEx("KickDelay", 1000, false, "i", playerid);
			}
			else
			{
				format(String, sizeof(String), "Incorrect password, you have %d out of 2 tries.", pInfo[playerid][PasswordFails]);
				SendClientMessage(playerid, 0xFF0000FF, String);

           		format(String, sizeof(String), "{FFFFFF}Welcome back, %s.\n\n{FFFFFF}This account is already registered.\n\
           		{FFFFFF}Please, input your password below to proceed to the game.\n\n", pInfo[playerid][Name]);
           		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login System", String, "Login", "Leave");
				}
			}
		}
		case DIALOG_REGISTER:
		{
			if(!response) return Kick(playerid);

			if(strlen(inputtext) < 6 || strlen(inputtext) > 60)
			{
		    	SendClientMessage(playerid, 0x969696FF, "Invalid password length, should be 6 - 60.");

				new String[150];

    	    	format(String, sizeof(String), "{FFFFFF}Welcome %s.\n\n{FFFFFF}This account is not registered.\n\
    	     	{FFFFFF}Please, input your password below to proceed.\n\n", pInfo[playerid][Name]);
	        	ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration System", String, "Register", "Leave");
			}
			else
			{
		    	new key[129];
		    	WP_Hash(key, sizeof(key), inputtext);

		    	new DB_Query[384];

		    	mysql_format(MainPipeline, DB_Query, sizeof(DB_Query), "INSERT INTO `players` (`USERNAME`, `PASSWORD`, `SCORE`, `IP`, `KILLS`, `CASH`, `DEATHS`)\
		    	VALUES ('%e', '%s', '1', '%s', '0', '0', '0')", pInfo[playerid][Name], key, pInfo[playerid][IP]);
		     	mysql_tquery(MainPipeline, DB_Query, "OnPlayerRegister", "d", playerid);
		     }
		}
	}
	return 1;
}

forward public OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
	SendClientMessage(playerid, 0x00FF00FF, "You are now registered and have been logged in, welcome!");
    pInfo[playerid][LoggedIn] = true;
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	new name[MAX_PLAYER_NAME + 1], killername[MAX_PLAYER_NAME + 1], str[128], ip[16], killerip[16], acstring[128];
	GetPlayerName(playerid, name, sizeof name);
	GetPlayerName(killerid, killername, sizeof killername);

	if(killerid != INVALID_PLAYER_ID)
	{
	    if(pInfo[playerid][Admin] < 1)
		{
 			if(GetPlayerWeapon(killerid) == 38)
	 		{
 			    MakeBan(killerid);
 			  	if (_:g_AnticheatChannelId == 0)
				g_AnticheatChannelId = DCC_FindChannelById("");
				gettime(Hour, Minute, Second);
  				format(acstring,sizeof (acstring),"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (minigun)``", Hour, Minute, Second, killername);
				DCC_SendChannelMessage(g_AnticheatChannelId, acstring);
 			}
 			return 1;
		}
		return 0;
	}

 	SendDeathMessage(killerid, playerid, reason);

	if (_:g_PlayerChannelId == 0)
		g_PlayerChannelId = DCC_FindChannelById("");
		
 	if(killerid != INVALID_PLAYER_ID)
	{
	    pInfo[killerid][Kills]++;
	    pInfo[killerid][Score]++;
	    pInfo[playerid][Deaths]++;
	    SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
   		GetPlayerIp(playerid, ip, sizeof(ip));
		GetPlayerIp(killerid, killerip, sizeof(killerip));
 		gettime(Hour, Minute, Second);
		format(str, sizeof str, "``%02d:%02d:%02d - PLAYER: %s (%s) has been killed by %s with a %s (%s).``", Hour, Minute, Second, name, ip, killername, GunName[GetPlayerWeapon(killerid)], killerip);
		DCC_SendChannelMessage(g_PlayerChannelId, str);
	} else {
 		GetPlayerIp(playerid, ip, sizeof(ip));
	 	gettime(Hour, Minute, Second);
		format(str, sizeof str, "``%02d:%02d:%02d - PLAYER: %s has killed themselves. (IP: %s)``", Hour, Minute, Second, name, ip);
		DCC_SendChannelMessage(g_PlayerChannelId, str);
	}
   	return 1;
}
