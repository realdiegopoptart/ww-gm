//variables

new MySQL: MainPipeline;

new Float:RandomSpawns[][] =
{
	{323.3734, 1992.7439, 17.6406, 91.1339},
	{284.1721,1925.2954,17.6406,322.7444},
	{-143.2678,2069.0623,17.6098,192.4161},
	{-505.9730,2601.5525,53.5156,179.8481},
	{-548.9627,2592.0679,53.9348,271.8123},
	{426.1712,2527.5037,16.6012,178.8247},
	{351.3763,2529.1736,16.7331,179.1381}
};

new MaxPing = 600;

//my shit way of doing global announcements (AnnouncementTimer)
new StringRandom = 1;

//used to get current time for discord logs
new Hour, Minute, Second;

//for discord player count
new playercount = 0;

//for anticheat, can be used for other shit
new GunName[47][20] =
{
	"Fist","Brass Knuckles","Golf Club","Nightstick","Knife","Basebal Bat","Shovel","Pool Cue","Katana","Chainsaw","Double-ended Dildo","Dildo","Vibrator",
	"Silver Vibrator","Flowers","Cane","Grenade","Tear Gas","Molotv Cocktail","?","?","?","9mm","Silenced 9mm","Desert Eagle","Shotgun","Sawnoff-Shotgun",
	"Combat Shotgun","Micro-SMG","MP5","Ak-47","M4","Tec9","Country Rifle","Sniper Rifle","RPG","HS-RPG","Flame-Thrower","Minigun","Satchel Charge","Detonator",
	"Spray Can","Fire Extinguisher","Camera","Night Goggles","Thermal Goggles","Parachute"
};

//discord related
new DCC_Channel:g_AdminChannelId;
new DCC_Channel:g_AdminLogChannelId;
new DCC_Channel:g_AnticheatChannelId;
new DCC_Channel:g_InfoChannelId;
new DCC_Channel:g_GamemodeChannelId;
new DCC_Channel:g_PlayerChannelId;
new DCC_Channel:g_ReportChannelId;
new DCC_Channel:g_AdminChatId;

