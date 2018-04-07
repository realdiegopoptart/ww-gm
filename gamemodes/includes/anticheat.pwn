//anticheat
//#include <BustAim>
//#define BUSTAIM_MAX_PING 600

GiveServerWeapon(playerid, weaponid, ammo)
{
	if(weaponid >= 1 && weaponid <= 15)
 	{
		Weapons[playerid][Melee] = weaponid;
		GivePlayerWeapon(playerid, weaponid, ammo);
		return 1;
	}

	if( weaponid >= 16 && weaponid <= 18 || weaponid == 39 ) // Checking Thrown
 	{
		Weapons[playerid][Thrown] = weaponid;
		GivePlayerWeapon(playerid, weaponid, ammo);
		return 1;
	}
	if( weaponid >= 22 && weaponid <= 24 ) // Checking Pistols
 	{
		Weapons[playerid][Pistols] = weaponid;
		GivePlayerWeapon(playerid, weaponid, ammo);
		return 1;
	}

	if( weaponid >= 25 && weaponid <= 27 ) // Checking Shotguns
 	{
		Weapons[playerid][Shotguns] = weaponid;
		GivePlayerWeapon(playerid, weaponid, ammo);
		return 1;
	}
	if( weaponid == 28 || weaponid == 29 || weaponid == 32 ) // Checking Sub Machine Guns
 	{
		Weapons[playerid][Submachine] = weaponid;
		GivePlayerWeapon(playerid, weaponid, ammo);
		return 1;
	}

	if( weaponid == 30 || weaponid == 31 ) // Checking Assault
 	{
		Weapons[playerid][Assault] = weaponid;
		GivePlayerWeapon(playerid, weaponid, ammo);
		return 1;
	}

	if( weaponid == 33 || weaponid == 34 ) // Checking Rifles
 	{
		Weapons[playerid][Rifles] = weaponid;
		GivePlayerWeapon(playerid, weaponid, ammo);
		return 1;
	}
	if( weaponid >= 35 && weaponid <= 38 ) // Checking Heavy
 	{
		Weapons[playerid][Heavy] = weaponid;
		GivePlayerWeapon(playerid, weaponid, ammo);
		return 1;
	}
	return 1;
}

CheckWeapons(playerid)
{
	new weaponid = GetPlayerWeapon(playerid), string[128], hackername[MAX_PLAYER_NAME];
	gettime(Hour, Minute, Second);
	GetPlayerName(playerid, hackername, sizeof(hackername));

	if(weaponid >= 1 && weaponid <= 15)
	{
	    if(weaponid == Weapons[playerid][Melee])
	    {
	        return 1;
	    }
	    else
	    {
   			if (_:g_AnticheatChannelId == 0)
			g_AnticheatChannelId = DCC_FindChannelById("");
	  		format(string,256,"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (%s)``", Hour, Minute, Second, hackername, GunName[GetPlayerWeapon(playerid)]);
			DCC_SendChannelMessage(g_AnticheatChannelId, string);
			MakeBan(playerid);
			SetTimerEx("KickDelay", 500, false, "i", playerid);
			return 1;
	    }
	}
	if(weaponid >= 16 && weaponid <= 18 || weaponid == 39)
	{
	    if(weaponid == Weapons[playerid][Thrown])
	    {
	    return 1;
	    }
	    else
	    {
  			if (_:g_AnticheatChannelId == 0)
			g_AnticheatChannelId = DCC_FindChannelById("");
	  		format(string,256,"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (%s)``", Hour, Minute, Second, hackername, GunName[GetPlayerWeapon(playerid)]);
			DCC_SendChannelMessage(g_AnticheatChannelId, string);
			MakeBan(playerid);
			SetTimerEx("KickDelay", 1000, false, "i", playerid);
			return 1;
	    }
	}
	if(weaponid >= 22 && weaponid <= 24)
	{
	    if(weaponid == Weapons[playerid][Pistols])
	    {
	    return 1;
	    }
	    else
	    {
  			if (_:g_AnticheatChannelId == 0)
			g_AnticheatChannelId = DCC_FindChannelById("");
	  		format(string,256,"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (%s)``", Hour, Minute, Second, hackername, GunName[GetPlayerWeapon(playerid)]);
			DCC_SendChannelMessage(g_AnticheatChannelId, string);
			MakeBan(playerid);
			SetTimerEx("KickDelay", 1000, false, "i", playerid);
			return 1;
	    }
	}
	if(weaponid >= 25 && weaponid <= 27)
	{
	    if(weaponid == Weapons[playerid][Shotguns])
	    {
	        return 1;
	    }
	    else
	    {
  			if (_:g_AnticheatChannelId == 0)
			g_AnticheatChannelId = DCC_FindChannelById("");
	  		format(string,256,"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (%s)``", Hour, Minute, Second, hackername, GunName[GetPlayerWeapon(playerid)]);
			DCC_SendChannelMessage(g_AnticheatChannelId, string);
			MakeBan(playerid);
			SetTimerEx("KickDelay", 1000, false, "i", playerid);
			return 1;
	    }
	}
	if(weaponid == 28 || weaponid == 29 || weaponid == 32)
	{
	    if(weaponid == Weapons[playerid][Submachine])
	    {
	        return 1;
	    }
	    else
	    {
  			if (_:g_AnticheatChannelId == 0)
			g_AnticheatChannelId = DCC_FindChannelById("");
	  		format(string,256,"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (%s)``", Hour, Minute, Second, hackername, GunName[GetPlayerWeapon(playerid)]);
			DCC_SendChannelMessage(g_AnticheatChannelId, string);
			MakeBan(playerid);
			SetTimerEx("KickDelay", 1000, false, "i", playerid);
			return 1;
	    }
	}
	if(weaponid == 30 || weaponid == 31)
	{
	    if(weaponid == Weapons[playerid][Assault])
	    {
	    return 1;
	    }
	    else
	    {
  			if (_:g_AnticheatChannelId == 0)
			g_AnticheatChannelId = DCC_FindChannelById("");
	  		format(string,256,"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (%s)``", Hour, Minute, Second, hackername, GunName[GetPlayerWeapon(playerid)]);
			DCC_SendChannelMessage(g_AnticheatChannelId, string);
			MakeBan(playerid);
			SetTimerEx("KickDelay", 1000, false, "i", playerid);
			return 1;
	    }
	}
	if(weaponid == 33 || weaponid == 34)
	{
	    if(weaponid == Weapons[playerid][Rifles])
	    {
	        return 1;
	    }
	    else
	    {
  		 	if (_:g_AnticheatChannelId == 0)
			g_AnticheatChannelId = DCC_FindChannelById("");
	  		format(string,256,"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (%s)``", Hour, Minute, Second, hackername, GunName[GetPlayerWeapon(playerid)]);
			DCC_SendChannelMessage(g_AnticheatChannelId, string);
			MakeBan(playerid);
			SetTimerEx("KickDelay", 1000, false, "i", playerid);
			return 1;
	    }
	}
	if(weaponid >= 35 && weaponid <= 38)
	{
	    if(weaponid == Weapons[playerid][Heavy])
	    {
	        return 1;
	    }
	    else
	    {
   	 		if (_:g_AnticheatChannelId == 0)
			g_AnticheatChannelId = DCC_FindChannelById("");
	  		format(string,256,"``%02d:%02d:%02d - ANTICHEAT: %s has been banned for Weapon Hacking (%s)``", Hour, Minute, Second, hackername, GunName[GetPlayerWeapon(playerid)]);
			DCC_SendChannelMessage(g_AnticheatChannelId, string);
			MakeBan(playerid);
			SetTimerEx("KickDelay", 1000, false, "i", playerid);
			return 1;
	    }
	}
	else
	{
	return 1;
	}
}
