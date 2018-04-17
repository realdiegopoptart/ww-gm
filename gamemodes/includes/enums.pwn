//enums

enum ENUM_PLAYER_DATA
{
	ID,
	Name[25],
	Password[129],
	PasswordFails,
	IP[16],
	Kills,
	Deaths,
	Score,
	Cash,
	Admin,
	Banned,
	rMuted,
	rAccepted,
	Cache: Player_Cache,
	bool:LoggedIn
}

new pInfo[MAX_PLAYERS][ENUM_PLAYER_DATA];

enum weapons
{
	Melee,
	Thrown,
	Pistols,
	Shotguns,
	Submachine,
	Assault,
	Rifles,
	Heavy,
	Handheld
}

new Weapons[MAX_PLAYERS][weapons];

