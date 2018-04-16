//functions

public OnPlayerRequestSpawn(playerid)
{
	if(pInfo[playerid][LoggedIn] == false) return 0;
	return 1;
}

SetupPlayerForClassSelection(playerid)
{
 	SetPlayerInterior(playerid,0);
	SetPlayerPos(playerid,258.4893,-41.4008,1002.0234);
	SetPlayerFacingAngle(playerid, 270.0);
}

public OnPlayerUpdate(playerid)
{
	CheckWeapons(playerid);
	return 1;
}

public DCC_OnChannelMessage(DCC_Channel:channel, DCC_User:author, const message[])
{
	new ip[] = ".ip";
	new nig[] = "nig";
	new devin[] = "devin";
	new yesman[] = "yes-man";
	new cotton[] = "cotton";
	new players[] = "players";
	if(strcmp(ip, message, true, 4) == 0)
 	{
 	   	g_InfoChannelId = channel;
		new str[128];
		format(str, sizeof str, "``Server IP: ``");
		DCC_SendChannelMessage(g_InfoChannelId, str);
	    return 1;
	}
	
	if(strcmp(nig, message, true, 4) == 0)
 	{
 	   	g_InfoChannelId = channel;
		new str[128];
		format(str, sizeof str, "nog");
		DCC_SendChannelMessage(g_InfoChannelId, str);
	 	return 1;
	}

	if(strcmp(devin, message, true, 6) == 0)
 	{
 	   	g_InfoChannelId = channel;
		new str[128];
		format(str, sizeof str, "https://media.discordapp.net/attachments/342633126239010817/419937193549627402/image.gif");
		DCC_SendChannelMessage(g_InfoChannelId, str);
	    return 1;
	}
	
	if(strcmp(yesman, message, true, 5) == 0)
 	{
 	   	g_InfoChannelId = channel;
		new str[128];
		format(str, sizeof str, "Allow me to introduce myself! I'm a PDQ-88b Securitron, but you can call me Yes Man!");
		DCC_SendChannelMessage(g_InfoChannelId, str);
	    return 1;
	}

    if(strcmp(cotton, message, true, 7) == 0)
 	{
 	   	g_InfoChannelId = channel;
		new str[128];
		format(str, sizeof str, "picker");
		DCC_SendChannelMessage(g_InfoChannelId, str);
	    return 1;
	}

	if(strcmp(players, message, true, 8) == 0)
	{
	    g_InfoChannelId = channel;
	    new str[128];
   		format(str, sizeof str, "Players online: %d", playercount);
		DCC_SendChannelMessage(g_InfoChannelId, str);
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if((GetVehicleModel(vehicleid) == 425))
	{
 		SetVehicleHealth(vehicleid, 7500);
	}
	else if((GetVehicleModel(vehicleid) == 520))
	{
 		SetVehicleHealth(vehicleid, 2500);
	}
	else if((GetVehicleModel(vehicleid) == 432))
	{
		SetVehicleHealth(vehicleid, 10000);
	}
	else if((GetVehicleModel(vehicleid) == 447))
	{
	    SetVehicleHealth(vehicleid, 4000);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetupPlayerForClassSelection(playerid);
	return 1;
}

forward PingTimer();
public PingTimer()
{
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	  	if(IsPlayerConnected(i))
 		{
		  	if(pInfo[i][Admin] < 1)
		   	{
	    		new ping = GetPlayerPing(i);
	    		if(ping > MaxPing)
		 		{
	    			new name[MAX_PLAYER_NAME];
					GetPlayerName(i, name, sizeof(name));
					new string[128];
				    new pIP[16];
	    			GetPlayerIp(i, pIP, sizeof(pIP));
		      		format(string, sizeof(string), "%s has been kicked for exceeding the ping limit (%d).", name, ping);
				    SendClientMessageToAll(COLOR_RED, string);
				    SetTimerEx("KickDelay", 1000, false, "i", i);
				}
			}
		}
	}
	return 1;
}

forward AnnouncementTimer();
public AnnouncementTimer()
{
	new string[128];

	if(stringrandom == 0)
	{
	    format(string, sizeof(string), "Info: You can customize your skin if you obtain more than 100 points (/skin).");
	    SendClientMessageToAll(COLOR_LIGHTBLUE, string);
	    stringrandom = random(3);
	    SetTimer("AnnouncementTimer", 120000, false);
	    return 1;
	}
	else if(stringrandom == 1)
	{
	    format(string, sizeof(string), "Info: If you have any suggestions don't hesitate to tell an administrator.");
     	SendClientMessageToAll(COLOR_LIGHTBLUE, string);
	    stringrandom = random(3);
     	SetTimer("AnnouncementTimer", 120000, false);
     	return 1;
	}
	else if(stringrandom == 2)
	{
	    format(string, sizeof(string), "Info: Feel free to join our discord @ discordlink (case sensitive!).");
      	SendClientMessageToAll(COLOR_LIGHTBLUE, string);
	    stringrandom = random(3);
     	SetTimer("AnnouncementTimer", 120000, false);
     	return 1;
	}
	else {
 		stringrandom = random(3);
	    SetTimer("AnnouncementTimer", 120000, false);
	}
	return 1;
}


stock AdminChat(colour, message[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(pInfo[i][Admin] > 1)
 		{
	        SendClientMessage(i, colour, message);
	    }
	}
}

MakeBan(iPlayerID)
{
	new DB_Query[256];
	pInfo[iPlayerID][Banned] = 1;
	mysql_format(MainPipeline, DB_Query, sizeof(DB_Query), "UPDATE `PLAYERS` SET `BANNED` = %d WHERE `ID` = %d",
	pInfo[iPlayerID][Banned], pInfo[iPlayerID][ID]);
	mysql_tquery(MainPipeline, DB_Query);
	SetTimerEx("KickDelay", 1000, 0, "i", iPlayerID);
	return 1;
}

veh_init()
{
		//hydras
 	CreateVehicle (520, 276.4778, 2024.1133, 17.6406,268.1895, -1, -1, 15);
 	CreateVehicle (520, 275.1508, 1988.5354, 17.6406, 268.4150, -1, -1, 15);
 	CreateVehicle (520, 275.5229, 1954.9385, 17.6406, 268.8740, -1, -1, 15);
 	CreateVehicle (520, 324.5745, 2542.9839, 16.8081, 176.8318, -1, -1, 15);
 	CreateVehicle (520, 291.7529, 2542.4646, 16.8207, 175.7226, -1, -1, 15);
 	CreateVehicle (520, -553.1320,2632.6125,53.5156,264.0197, -1, -1, 15);

	 	//hunters
	CreateVehicle (425, 282.6066, 1925.5651, 17.6406, 296.0167, -1, -1, 15);
   	CreateVehicle (425, 335.6370, 1897.3173, 17.6406, 86.9273, -1, -1, 15);
  	CreateVehicle (425, 336.4571, 1918.8156, 17.6406, 81.5755, -1, -1, 15);
  	CreateVehicle (425, 335.5110, 1943.4585, 17.6406, 86.0013, -1, -1, 15);
   	CreateVehicle (425, 336.2878, 1971.5244, 17.6406, 88.7743, -1, -1, 15);
   	CreateVehicle (425, -151.5630,2102.0107,15.2330,181.0695, -1, -1, 15);
   	CreateVehicle (425, -125.2058,2102.1431,15.2188,179.5419, -1, -1, 15);
   	CreateVehicle (425, 365.3611,2536.9067,16.6648,181.4755, -1, -1, 15);
   	CreateVehicle (425, -524.7087,2556.3718,53.5703,358.3381, -1, -1, 15);
  	CreateVehicle (425, -523.3063,2629.7021,53.5703,175.2915, -1, -1, 15);
  	CreateVehicle (425, 268.7458, 2539.8657, 16.8125, 183.6981, -1, -1, 15);
	   	//patriots
   	CreateVehicle (470, -520.8674,2617.5898,53.4154,264.9012, -1, -1, 15);
	CreateVehicle (470, -520.5955,2615.0339,53.4154,265.7111, -1, -1, 15);
   	CreateVehicle (470, -520.9384,2612.5320,53.4154,266.0682, -1, -1, 15);
   	CreateVehicle (470, 378.4300,2542.8215,16.5391,179.6246, -1, -1, 15);
  	CreateVehicle (470, 385.5543,2542.1904,16.5391,178.6453, -1, -1, 15);
  	CreateVehicle (470, 338.2266,1984.1589,17.6406,87.7114, -1, -1, 15);
  	CreateVehicle (470, 337.8092,1990.2411,17.6406,87.4137, -1, -1, 15);
  	
	   //rhinos
   	CreateVehicle (432, -184.1888,2091.5708,15.2224,235.5813, -1, -1, 15);
   	CreateVehicle (432, 288.0757,2042.5315,17.6406,271.8958, -1, -1, 15);
   	CreateVehicle (432, 288.0757,2054.3718,17.6406,269.7244, -1, -1, 15);
   	CreateVehicle (432, 352.6200,2542.0544,16.7270,182.4587, -1, -1, 15);
   	CreateVehicle (432, 342.6925,2542.0896,16.7755,177.1491, -1, -1, 15);
   	
   	    //seasparrows
   	CreateVehicle (447, -495.2135, 2610.7898, 53.8006, 87.5988, -1, -1, 15);
   	CreateVehicle (447, -497.1111, 2576.2966, 53.5456, 84.3636, -1, -1, 15);
   	CreateVehicle (447, 309.3323, 2462.7502, 16.4766, 358.9065, -1, -1, 15);
   	CreateVehicle (447, 361.3125, 2468.0576, 16.4844, 358.1231, -1, -1, 15);
   	CreateVehicle (447, 331.5235, 2066.4866, 17.6406, 132.5427, -1, -1, 15);
	return 1;
}

veh_respawn()
{
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
		SetVehicleToRespawn(i);
	}
}

forward KickDelay(playerid);
public KickDelay(playerid)
{
	Kick(playerid);
}
