

CMD:help(playerid, params[])
{
    SendClientMessage(playerid, 0x00FF00FF, "CMDS: /pm, /kd, /rules, /kill, /skin, /report");
    return 1;
}

CMD:ahelp(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
	{
    	SendClientMessage(playerid, 0x00FF00FF, "CMDS: /ban, /kick, /viewenums (debug), /givegun, /debugkill (debug)");
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:rules(playerid, params[])
{
	SendClientMessage(playerid, COLOR_LIGHTGREY, "1. Hacking is prohibited.");
	SendClientMessage(playerid, COLOR_LIGHTGREY, "2. Exploiting is prohibited.");
	SendClientMessage(playerid, COLOR_LIGHTGREY, "3. Spawn Killing (with rockets) is prohibited.");
	SendClientMessage(playerid, COLOR_LIGHTGREY, "4. English only in global chat. (/pm is exempt)");
	SendClientMessage(playerid, COLOR_LIGHTGREY, "Failure to follow these rather basic rules will result in a kick, ban if continued.");
    return 1;
}

CMD:report(playerid, params[])
{
	new string[128], report[128], reportname[MAX_PLAYER_NAME];
	
	GetPlayerName(playerid, reportname, sizeof reportname);
	
	if(pInfo[playerid][rMuted] != 1)
	{
	    if(pInfo[playerid][rActive] != 1)
	    {
	    	if(sscanf(params, "s[128]", report)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /report (message)");
	    	format(string, sizeof(string), "REPORT: %s (ID: %d) reports - %s", reportname, playerid, report);
	    	AdminChat(COLOR_RED, string);
	    	SendClientMessage(playerid, COLOR_LIGHTGREY, "Report has been submitted.");
	    	pInfo[playerid][rActive] = 1;
 	   		if (_:g_ReportChannelId == 0)
			g_ReportChannelId = DCC_FindChannelById("");
			new str2[128];
	 		gettime(Hour, Minute, Second);
			format(str2, sizeof str2, "``%02d:%02d:%02d - REPORT: %s - %s``", Hour, Minute, Second, reportname, report);
			DCC_SendChannelMessage(g_ReportChannelId, str2);
	    	return 1;
	    }
	    else return SendClientMessage(playerid, 0xff0000ff, "You already have an active report.");
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're currently report muted, appeal to an administrator.");
}

CMD:rmute(playerid, params[])
{
	new giveplayerid, string[128], mutename[MAX_PLAYER_NAME], givename[MAX_PLAYER_NAME];
	
	GetPlayerName(giveplayerid, mutename, sizeof mutename);
	GetPlayerName(playerid, givename, sizeof givename);
	
	if(pInfo[playerid][Admin] > 1)
 	{
  		if(sscanf(params, "d", giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /rmute (id)");
		format(string, sizeof(string), "You have successfully report muted %s (ID: %d).", mutename, giveplayerid);
		SendClientMessage(playerid, COLOR_RED, string);
		format(string, sizeof(string), "You have been report muted by %s, if you feel this is unjust tell another administrator.", givename);
		SendClientMessage(giveplayerid, COLOR_RED, string);
		pInfo[giveplayerid][rMuted] = 1;
		pInfo[giveplayerid][rActive] = 0;
		if (_:g_AdminChannelId == 0)
		g_AdminChannelId = DCC_FindChannelById("");
		new strlog[128];
 		gettime(Hour, Minute, Second);
		format(strlog, sizeof strlog, "``%02d:%02d:%02d - ADMIN: %s has report muted %s.``", Hour, Minute, Second, givename, mutename);
		DCC_SendChannelMessage(g_AdminChannelId, strlog);
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:runmute(playerid, params[])
{
	new giveplayerid, string[128], adminname[MAX_PLAYER_NAME], mutename[MAX_PLAYER_NAME];
	
	GetPlayerName(giveplayerid, mutename, sizeof mutename);
	GetPlayerName(playerid, adminname, sizeof adminname);

	if(pInfo[playerid][Admin] > 1)
	{
		if(sscanf(params, "d", giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /runmute (id)");
		pInfo[giveplayerid][rMuted] = 0;
		format(string, sizeof(string), "You've successfully lifted the report mute of ID: %d", giveplayerid);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof(string), "Your report mute has been lifted.");
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
		if (_:g_AdminChannelId == 0)
		g_AdminChannelId = DCC_FindChannelById("");
		new strlog[128];
	 	gettime(Hour, Minute, Second);
		format(strlog, sizeof strlog, "``%02d:%02d:%02d - ADMIN: %s has lifted %'s report mute.``", Hour, Minute, Second, adminname, mutename);
		DCC_SendChannelMessage(g_AdminChannelId, strlog);
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:ar(playerid, params[])
{
	new giveplayerid, string[128], acceptname[MAX_PLAYER_NAME], reportname[MAX_PLAYER_NAME];
	
	GetPlayerName(playerid, acceptname, sizeof acceptname);
	GetPlayerName(giveplayerid, reportname, sizeof reportname);
	if(pInfo[playerid][Admin] > 1)
	{
		if(sscanf(params, "d", giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /ar (id)");
		
		if(pInfo[giveplayerid][rActive] == 1)
		{
		    pInfo[giveplayerid][rActive] = 0;
		    format(string, sizeof(string), "Your report has been accepted by %s (/pm any additional info if required).", acceptname);
		    SendClientMessage(giveplayerid, COLOR_LIGHTGREY, string);
		    format(string, sizeof(string), "REPORT: %s has accepted %s's report.", acceptname, reportname);
		    AdminChat(COLOR_BLUE, string);
		    pInfo[playerid][rAccepted]++;
			gettime(Hour, Minute, Second);
	   		if (_:g_ReportChannelId == 0)
			g_ReportChannelId = DCC_FindChannelById("");
			new str2[128];
	 		gettime(Hour, Minute, Second);
			format(str2, sizeof str2, "``%02d:%02d:%02d - REPORT: %s has accepted %s's report.``", Hour, Minute, Second, acceptname, reportname);
			DCC_SendChannelMessage(g_ReportChannelId, str2);
		    return 1;
		}
		else return SendClientMessage(playerid, COLOR_LIGHTGREY, "That player doesn't have an active report.");
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:skin(playerid, params[])
{
	new skin;
	if(pInfo[playerid][Admin] > 1 || pInfo[playerid][Score] >= 100)
	{
	    if(sscanf(params, "d", skin)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /skin (id)");
	    if(skin < 0 || skin > 311) return SendClientMessage(playerid, COLOR_LIGHTGREY, "Valid skin IDs go from 0 - 311!");
	    SetPlayerSkin(playerid, skin);
	    return 1;
	}
	else return SendClientMessage(playerid, COLOR_LIGHTGREY, "You require 100 or more score to change your skin.");
}

CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0.0);
	pInfo[playerid][Deaths]++;
	SendClientMessage(playerid, COLOR_LIGHTGREY, "You have killed yourself.");
	return 1;
}

CMD:debugkill(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
	{
		pInfo[playerid][Kills]++;
		return 1;
	}
	return 0;
}

CMD:viewenums(playerid, params[])
{
	new giveplayerid, givename[MAX_PLAYER_NAME], string[128], string2[128];
	GetPlayerName(giveplayerid, givename, sizeof givename);
	if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /viewenums (id)");
	if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "That player is not connected!");
	
	format(string, sizeof(string), "%s's enums: Kills: %d, Deaths: %d, Banned: %d, Admin: %d, Cash: %d, Score: %d, Logged In: %d.", givename, pInfo[giveplayerid][Kills],
	pInfo[giveplayerid][Deaths], pInfo[giveplayerid][Banned], pInfo[giveplayerid][Admin], pInfo[giveplayerid][Cash], pInfo[giveplayerid][Score], pInfo[giveplayerid][LoggedIn]);
	format(string2, sizeof(string2), "more enums: IP: %s", pInfo[giveplayerid][IP]);
	SendClientMessage(playerid, COLOR_LIGHTGREY, string);
	SendClientMessage(playerid, COLOR_LIGHTGREY, string2);
	return 1;
}

CMD:kd(playerid, params[])
{
	new Float:ratio = floatdiv(pInfo[playerid][Kills], pInfo[playerid][Deaths]);
	new string[128], name[MAX_PLAYER_NAME + 1];
 	GetPlayerName(playerid, name, sizeof name);
 	if(pInfo[playerid][Deaths] == 0)
 	{
 		format(string, sizeof(string), "Kills: %d Deaths: 0 K/D: %d.00", pInfo[playerid][Kills], pInfo[playerid][Kills]);
		SendClientMessage(playerid, COLOR_LIGHTGREY, string);
 	} 
	format(string, sizeof(string), "Kills: %d Deaths: %d K/D: %.2f", pInfo[playerid][Kills], pInfo[playerid][Deaths], ratio);
	SendClientMessage(playerid, COLOR_LIGHTGREY, string);
	return 1;
}

CMD:pm(playerid, params[])
{
    new string[128], id, name1[MAX_PLAYER_NAME], name2[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name1, sizeof(name1));
	GetPlayerName(id, name2, sizeof(name2));
    if(sscanf(params, "us[128]", id, params))
	{
	    SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /pm (id) (message)");
	    return 1;
	}
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "That player is not connected!");
	if(id == playerid) return SendClientMessage(playerid, COLOR_LIGHTGREY, "You can't pm yourself!");
	format(string, sizeof(string), "PM to %s (ID: %d): %s", name2, id, params);
	SendClientMessage(playerid, COLOR_WHITE, string);
	format(string, sizeof(string), "PM from %s (ID: %d): %s", name1, playerid, params);
	SendClientMessage(id, COLOR_WHITE, string);
	return 1;
}

CMD:givegun(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1) {
		new target, number;

		if(sscanf(params, "ud", target, number))
		{
			SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /givegun (playerid) (weapon)");
	  		return 1;
		}
		if(number < 1 || number > 46) { SendClientMessage(playerid, 0x00FF00FF, "Invalid Weapon ID."); return 1; }
		GiveServerWeapon(target, number, 50000);
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

new Vehicle[MAX_PLAYERS];
CMD:veh(playerid, params[])
{
	if(pInfo[playerid][Admin] > 0) {
	    new car, string[128], Float:X, Float:Y, Float:Z, name[MAX_PLAYER_NAME + 1];
	    GetPlayerName(playerid, name, sizeof name);
		GetPlayerPos(playerid, Float:X, Float:Y, Float:Z);
	    if(sscanf(params,"i", car)) return SendClientMessage(playerid, COLOR_LIGHTGREY , "USAGE: /veh (400-611)");
	    else if(car < 400 || car > 611) return SendClientMessage(playerid, COLOR_LIGHTGREY, "Cannot go under 400 or above 611.");
	    {
	    if(Vehicle[playerid] != 0)
	    {
	    	DestroyVehicle(Vehicle[playerid]);
	    }
	 	Vehicle[playerid] = CreateVehicle(car, X, Y, Z + 2.0, 0, -1, -1, 1);
		format(string, sizeof(string),"You have spawned vehicle ID %i", car);
		SendClientMessage(playerid, 0xffffffff, string);
		PutPlayerInVehicle(playerid, Vehicle[playerid], 0);
	 	gettime(Hour, Minute, Second);
		if (_:g_AdminChannelId == 0)
		g_AdminChannelId = DCC_FindChannelById("");
		new strlog[128];
 		gettime(Hour, Minute, Second);
		format(strlog, sizeof strlog, "``%02d:%02d:%02d - ADMIN: %s has spawned vehicle %d.``", Hour, Minute, Second, name, car);
		DCC_SendChannelMessage(g_AdminChannelId, strlog);
		return 1;
		}
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:kick(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1) {
     	new str[128], reason[64], PID;
      	new Playername[MAX_PLAYER_NAME], Adminname[MAX_PLAYER_NAME];
       	GetPlayerName(playerid, Adminname, sizeof(Adminname)); 
		GetPlayerName(PID, Playername, sizeof(Playername));
  		if(sscanf(params, "us[64]", PID, reason)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /kick (playerid) (reason)");
		if(!IsPlayerConnected(PID)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "Player is not connected!");
		if(pInfo[PID][Admin] >= pInfo[playerid][Admin]) return SendClientMessage(playerid, COLOR_LIGHTGREY, "You cannot use this command on an administrator of same/higher level.");
		format(str, sizeof(str), "%s has been kicked by administrator %s. Reason: %s", Playername, Adminname, reason);
		SendClientMessageToAll(0xff0000ff, str);
		SetTimerEx("KickDelay", 1000, false, "i", PID);
 		if (_:g_AdminLogChannelId == 0)
		g_AdminLogChannelId = DCC_FindChannelById("");
		new string[128];
		gettime(Hour, Minute, Second);
		format(string, sizeof string, "``%02d:%02d:%02d - ADMIN: %s has kicked %s. Reason: %s.``", Hour, Minute, Second, Adminname, Playername, reason);
		DCC_SendChannelMessage(g_AdminLogChannelId, string);
  		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:ban(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1) {
 		new PID, reason[64], str[128];
    	new Playername[MAX_PLAYER_NAME], Adminname[MAX_PLAYER_NAME]; 
    	GetPlayerName(playerid, Adminname, sizeof(Adminname));
  		GetPlayerName(PID, Playername, sizeof(Playername));
      	if(sscanf(params, "us[64]", PID, reason)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /ban (playerid) (reason)");
		if(!IsPlayerConnected(PID)) return SendClientMessage(playerid, 0xff0000ff, "Player is not connected!");
		if(pInfo[PID][Admin] > pInfo[playerid][Admin]) return SendClientMessage(playerid, COLOR_LIGHTGREY, "You cannot use this command on an administrator of higher level.");
		format(str, sizeof(str), "%s has been banned by administrator %s. Reason: %s", Playername, Adminname, reason);
		SendClientMessageToAll(0xff0000ff, str);
		MakeBan(PID);
		if (_:g_AdminLogChannelId == 0)
		g_AdminLogChannelId = DCC_FindChannelById("");
		new string[128];
		gettime(Hour, Minute, Second);
		format(string, sizeof string, "``%02d:%02d:%02d - ADMIN: %s has banned %s. Reason: %s.``", Hour, Minute, Second, Adminname, Playername, reason);
		DCC_SendChannelMessage(g_AdminLogChannelId, string);
        return 1;
    }
    else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:a(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
	{
	    new string[128], pName[MAX_PLAYER_NAME];
	    GetPlayerName(playerid, pName, sizeof(pName));
    	if(sscanf(params, "s[128]", params)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /a (message)");
		format(string, sizeof(string), "[ADMIN CHAT] %s: %s", pName, params);
	    AdminChat(COLOR_WHITE, string);
   		if (_:g_AdminChatId == 0)
		g_AdminChatId = DCC_FindChannelById("");
		new string2[128];
		gettime(Hour, Minute, Second);
		format(string2, sizeof string2, "``%02d:%02d:%02d - %s``", Hour, Minute, Second, string);
		DCC_SendChannelMessage(g_AdminChatId, string2);
	    return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:admin(playerid, params[])
{
	return cmd_a(playerid, "");
}

CMD:spec(playerid, params[])
{
	new giveplayerid, vehicle, specname[MAX_PLAYER_NAME], string[128];
	GetPlayerName(giveplayerid, specname, sizeof(specname));
	if(pInfo[playerid][Admin] > 1) {
  		if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /spec (id)");

		if(IsPlayerInAnyVehicle(giveplayerid)) {
		    vehicle = GetPlayerVehicleID(giveplayerid);
	       	TogglePlayerSpectating(playerid, 1);
	     	PlayerSpectateVehicle(playerid, vehicle);
			format(string, sizeof(string), "You are now spectating %s (ID: %d).", specname, giveplayerid);
	     	SendClientMessage(playerid, COLOR_LIGHTGREY, string);
	   	} else
		{
	  		TogglePlayerSpectating(playerid, 1);
	     	PlayerSpectatePlayer(playerid, giveplayerid);
			format(string, sizeof(string), "You are now spectating %s (ID: %d).", specname, giveplayerid);
	     	SendClientMessage(playerid, COLOR_LIGHTGREY, string);
	     	return 1;
   		}
   		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:specoff(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1) {
		TogglePlayerSpectating(playerid, 0);
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:savechars(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
 	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			new DB_Query[256], name[MAX_PLAYER_NAME + 1], pIP[16];
			GetPlayerIp(i, pIP, sizeof(pIP));
   			GetPlayerName(playerid, name, sizeof name);
			mysql_format(MainPipeline, DB_Query, sizeof(DB_Query), "UPDATE `PLAYERS` SET `SCORE` = %d, `CASH` = %d, `ADMIN` = %d, `BANNED` = %d`, `KILLS` = %d, `DEATHS` = %d, `REPORTMUTED` = %d WHERE `ID` = %d LIMIT 1",
			pInfo[i][Score], pInfo[i][Cash], pInfo[i][Admin], pInfo[i][Banned], pInfo[i][Kills], pInfo[i][Deaths], pInfo[i][rMuted], pInfo[i][ID]);
			mysql_tquery(MainPipeline, DB_Query);
			SendClientMessage(playerid, COLOR_AQUA, "Saved characters successfully.");
			if (_:g_AdminLogChannelId == 0)
			g_AdminLogChannelId = DCC_FindChannelById("");
			new string[128];
			gettime(Hour, Minute, Second);
			format(string, sizeof string, "``%02d:%02d:%02d - ADMIN: %s has saved all player stats.``", Hour, Minute, Second, name);
			DCC_SendChannelMessage(g_AdminLogChannelId, string);
			return 1;
		}
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:goto(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
	{
	    new giveplayerid, string[128], tpname[MAX_PLAYER_NAME + 1], Float:x, Float:y, Float:z;
		GetPlayerName(giveplayerid, tpname, sizeof tpname);
  		if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, 0xff0000ff, "USAGE: /goto (id)");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, 0xFF0000FF, "That player is not connected!");
  		GetPlayerPos(giveplayerid, x, y, z);
  		SetPlayerPos(playerid, x + 1, y + 1, z);
		format(string, sizeof(string), "You have teleported to %s (ID: %d).", tpname, giveplayerid);
		SendClientMessage(playerid, COLOR_LIGHTGREY, string);
  		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:gethere(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
	{
	    new giveplayerid, string[128], tpname[MAX_PLAYER_NAME + 1], Float:x, Float:y, Float:z;
		GetPlayerName(giveplayerid, tpname, sizeof tpname);
  		if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /gethere (id)");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "That player is not connected!");
  		GetPlayerPos(playerid, x, y, z);
  		SetPlayerPos(giveplayerid, x + 1, y + 1, z);
		format(string, sizeof(string), "You have teleported %s (ID: %d) to you.", tpname, giveplayerid);
		SendClientMessage(playerid, COLOR_LIGHTGREY, string);
  		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:ipcheck(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
	{
	 	new giveplayerid, ip[16], ipname[MAX_PLAYER_NAME + 1], string[128];
	 	GetPlayerName(giveplayerid, ipname, sizeof ipname);
	 	GetPlayerIp(giveplayerid, ip, sizeof ip);

		if(sscanf(params, "u", giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /ipcheck (id)");
		if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "That player is not connected!");
		format(string, sizeof(string), "%s's (ID: %d) IP: %s", ipname, giveplayerid, ip);
		SendClientMessage(playerid, COLOR_LIGHTGREY, string);
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:setvw(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
 	{
	    new giveplayerid, givevw, string[128], givename[MAX_PLAYER_NAME +1];
	    GetPlayerName(giveplayerid, givename, sizeof givename);
	    if(sscanf(params, "ud", giveplayerid, givevw)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /setvw (id) (vw)");
    	if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "That player is not connected!");
    	format(string, sizeof(string), "You've set %s's (ID: %d) vw to %d", givename, giveplayerid, givevw);
    	SendClientMessage(playerid, COLOR_LIGHTGREY, string);
		SetPlayerVirtualWorld(giveplayerid, givevw);
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

CMD:setint(playerid, params[])
{
	if(pInfo[playerid][Admin] > 1)
 	{
  		new giveplayerid, giveint, string[128], givename[MAX_PLAYER_NAME +1];
	    GetPlayerName(giveplayerid, givename, sizeof givename);
	    if(sscanf(params, "ud", giveplayerid, giveint)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "USAGE: /setint (id) (int)");
    	if(!IsPlayerConnected(giveplayerid)) return SendClientMessage(playerid, COLOR_LIGHTGREY, "That player is not connected!");
    	format(string, sizeof(string), "You've set %s's (ID: %d) int to %d", givename, giveplayerid, giveint);
    	SendClientMessage(playerid, COLOR_LIGHTGREY, string);
		SetPlayerInterior(giveplayerid, giveint);
		return 1;
	}
	else return SendClientMessage(playerid, 0xff0000ff, "You're not authorized to use this command.");
}

