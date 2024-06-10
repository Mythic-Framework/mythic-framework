Config = Config or {}

--[[
    HealthDamage : How Much Damage To Direct HP Must Be Applied Before Checks For Damage Happens
    ArmorDamage : How Much Damage To Armor Must Be Applied Before Checks For Damage Happens | NOTE: This will in turn make stagger effect with armor happen only after that damage occurs
]]
Config.HealthDamage = 10
Config.ArmorDamage = 18

--[[
    MaxInjuryChanceMulti : How many times the HealthDamage value above can divide into damage taken before damage is forced to be applied
    ForceInjury : Maximum amount of damage a player can take before limb damage & effects are forced to occur
]]
Config.MaxInjuryChanceMulti = 3
Config.ForceInjury = 19
Config.AlwaysBleedChance = 45

--[[ 
    BleedTickRate : How much time, in seconds, between bleed ticks
]]
Config.BleedTickRate = 30

--[[ 
    BleedEvidenceRate : How much time, in seconds, between blood falling to the floor as evidence (it is divided by bleed level 1-4)
]]

Config.BleedEvidenceRate = 4

--[[
    BleedMovementTick : How many seconds is taken away from the bleed tick rate if the player is walking, jogging, or sprinting
    BleedMovementAdvance : How Much Time Moving While Bleeding Adds (This Adds This Value To The Tick Count, Meaing The Above BleedTickRate Will Be Reached Faster)
]]
Config.BleedMovementTick = 10
Config.BleedMovementAdvance = 3

--[[
    The Base Damage That Is Multiplied By Bleed Level Every Time A Bleed Tick Occurs
]]
Config.BleedTickDamage = 2

--[[
    AdvanceBleedTimer : How many bleed ticks occur before bleed level increases
]]
Config.AdvanceBleedTimer = 10

--[[
    HeadInjuryTimer : How much time, in seconds, do head injury effects chance occur
    ArmInjuryTimer : How much time, in seconds, do arm injury effects chance occur
    LegInjuryTimer : How much time, in seconds, do leg injury effects chance occur
]]
Config.HeadInjuryTimer = 30
Config.ArmInjuryTimer = 30
Config.LegInjuryTimer = 15

--[[
    The Chance, In Percent, That Certain Injury Side-Effects Get Applied
]]
Config.HeadInjuryChance = 25
Config.ArmInjuryChance = 25
Config.LegInjuryChance = {
	Running = 50,
	Walking = 15,
}

--[[
    MajorArmoredBleedChance : The % Chance Someone Gets A Bleed Effect Applied When Taking Major Damage With Armor
    MajorDoubleBleed : % Chance You Have To Receive Double Bleed Effect From Major Damage, This % is halved if the player has armor
]]
Config.MajorArmoredBleedChance = 30

--[[
    DamgeMinorToMajor : How much damage would have to be applied for a minor weapon to be considered a major damage event. Put this at 100 if you want to disable it
]]
Config.DamageMinorToMajor = 25

--[[
    These following lists uses tables defined in definitions.lua, you can technically use the hardcoded values but for sake
    of ensuring future updates doesn't break it I'd highly suggest you check that file for the index you're wanting to use.

    MinorInjurWeapons : Damage From These Weapons Will Apply Only Minor Injuries
    MajorInjurWeapons : Damage From These Weapons Will Apply Only Major Injuries
    AlwaysBleedChanceWeapons : Weapons that're in the included weapon classes will roll for a chance to apply a bleed effect if the damage wasn't enough to trigger an injury chance
    CriticalAreas : 
    StaggerAreas : These are the body areas that would cause a stagger is hit by firearms,
        Table Values: Armored = Can This Cause Stagger If Wearing Armor, Major = % Chance You Get Staggered By Major Damage, Minor = % Chance You Get Staggered By Minor Damage
]]

Config.MinorInjurWeapons = {
	[Config.WeaponClasses["SMALL_CALIBER"]] = true,
	[Config.WeaponClasses["MEDIUM_CALIBER"]] = true,
	[Config.WeaponClasses["CUTTING"]] = true,
	[Config.WeaponClasses["WILDLIFE"]] = true,
	[Config.WeaponClasses["OTHER"]] = true,
	[Config.WeaponClasses["LIGHT_IMPACT"]] = true,
}

Config.MajorInjurWeapons = {
	[Config.WeaponClasses["HIGH_CALIBER"]] = true,
	[Config.WeaponClasses["HEAVY_IMPACT"]] = true,
	[Config.WeaponClasses["SHOTGUN"]] = true,
	[Config.WeaponClasses["EXPLOSIVE"]] = true,
}

Config.AlwaysBleedChanceWeapons = {
	[Config.WeaponClasses["SMALL_CALIBER"]] = true,
	[Config.WeaponClasses["MEDIUM_CALIBER"]] = true,
	[Config.WeaponClasses["CUTTING"]] = true,
	[Config.WeaponClasses["WILDLIFE"]] = true,
}

Config.ForceInjuryWeapons = {
	[Config.WeaponClasses["HIGH_CALIBER"]] = true,
	[Config.WeaponClasses["HEAVY_IMPACT"]] = true,
	[Config.WeaponClasses["EXPLOSIVE"]] = true,
}

Config.CriticalAreas = {
	["UPPER_BODY"] = { armored = false },
	["LOWER_BODY"] = { armored = true },
	["SPINE"] = { armored = true },
	["HEAD"] = { armored = false },
}

Config.StaggerAreas = {
	-- ["SPINE"] = { armored = false, major = 0, minor = 0 },
	-- ["UPPER_BODY"] = { armored = false, major = 0, minor = 0 },
	-- ["LLEG"] = { armored = false, major = 0, minor = 0 },
	-- ["RLEG"] = { armored = false, major = 0, minor = 0 },
	-- ["LFOOT"] = { armored = false, major = 0, minor = 0 },
	-- ["RFOOT"] = { armored = false, major = 0, minor = 0 },
}

Config.ICUBeds = {
	vector4(-484.631, -329.334, 69.523, 352.380),
	vector4(-483.648, -341.486, 69.523, 178.489),
	vector4(-477.289, -330.050, 69.523, 1.676),
	vector4(-476.180, -342.179, 69.523, 179.781),
	vector4(-469.840, -331.163, 69.523, 1.152),
	vector4(-468.668, -343.538, 69.523, 181.606),
	vector4(-462.200, -332.150, 69.521, 4.846),
	vector4(-461.303, -344.223, 69.523, 174.951),
	vector4(-445.279, -346.800, 69.523, 176.390),
	vector4(-435.775, -336.701, 69.523, 274.043),
}

Config.BedPolys = {
	{
		center = vector3(-441.25, -303.29, 34.91),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 25,
			--debugPoly=true,
			minZ = 33.91,
			maxZ = 34.91,
		},
		laydown = vector4(-441.079, -303.129, 35.780, 113.386),
	},
	{
		center = vector3(-447.17, -291.22, 35.81),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 25,
			--debugPoly=true,
			minZ = 33.96,
			maxZ = 34.96,
		},
		laydown = vector4(-446.780, -291.055, 35.812, 110.598),
	},
	{
		center = vector3(-464.63, -295.38, 35.68),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 20,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 34.83,
		},
		laydown = vector4(-464.627, -295.382, 35.676, 108.281),
	},
	{
		center = vector3(-462.23, -301.42, 35.68),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 20,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 34.83,
		},
		laydown = vector4(-462.232, -301.422, 35.683, 105.833),
	},
	{
		center = vector3(-459.83, -306.67, 35.57),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 20,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 34.83,
		},
		laydown = vector4(-459.833, -306.669, 35.567, 110.890),
	},
	{
		center = vector3(-456.0, -315.63, 35.68),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 20,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 34.83,
		},
		laydown = vector4(-455.772, -315.531, 35.684, 111.440),
	},
	{
		center = vector3(-450.43, -323.06, 35.69),
		length = 1.0,
		width = 2.8,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 33.84,
			maxZ = 34.84,
		},
		laydown = vector4(-450.418, -322.993, 35.688, 90.981),
	},
}

Config.DeathTypes = {
	[`WEAPON_FALLING`] = { minor = true },
	[`WEAPON_UNARMED`] = { minor = true },
	[`WEAPON_ANIMAL`] = { minor = true },
	[`WEAPON_COUGAR`] = { minor = false },
	[`WEAPON_KNIFE`] = { minor = false, violent = true },
	[`WEAPON_SWITCHBLADE`] = { minor = false, violent = true },
	[`WEAPON_SHIV`] = { minor = false, violent = true },
	[`WEAPON_KATANA`] = { minor = false, violent = true },
	[`WEAPON_NIGHTSTICK`] = { minor = true, violent = true },
	[`WEAPON_HAMMER`] = { minor = true, violent = true },
	[`WEAPON_BAT`] = { minor = true },
	[`WEAPON_GOLFCLUB`] = { minor = true, violent = true },
	[`WEAPON_CROWBAR`] = { minor = true, violent = true },
	[`WEAPON_SLEDGEHAMMER`] = { minor = true },
	[`WEAPON_PONY`] = { minor = true },
	[`WEAPON_CRUTCH`] = { minor = true },
	[`WEAPON_SHOVEL`] = { minor = true },
	[`WEAPON_PISTOL`] = { minor = false, violent = true },
	[`WEAPON_COMBATPISTOL`] = { minor = false, violent = true },
	[`WEAPON_APPISTOL`] = { minor = false, violent = true },
	[`WEAPON_PISTOL50`] = { minor = false, violent = true },
	[`WEAPON_MICROSMG`] = { minor = false, violent = true },
	[`WEAPON_SMG`] = { minor = false, violent = true },
	[`WEAPON_ASSAULTSMG`] = { minor = false, violent = true },
	[`WEAPON_ASSAULTRIFLE`] = { minor = false, violent = true },
	[`WEAPON_CARBINERIFLE`] = { minor = false, violent = true },
	[`WEAPON_ADVANCEDRIFLE`] = { minor = false, violent = true },
	[`WEAPON_MG`] = { minor = false, violent = true },
	[`WEAPON_COMBATMG`] = { minor = false, violent = true },
	[`WEAPON_PUMPSHOTGUN`] = { minor = false, violent = true },
	[`WEAPON_SAWNOFFSHOTGUN`] = { minor = false, violent = true },
	[`WEAPON_ASSAULTSHOTGUN`] = { minor = false, violent = true },
	[`WEAPON_BULLPUPSHOTGUN`] = { minor = false, violent = true },
	[`WEAPON_STUNGUN`] = { minor = true, violent = true },
	[`WEAPON_SNIPERRIFLE`] = { minor = false, violent = true },
	[`WEAPON_HEAVYSNIPER`] = { minor = false, violent = true },
	[`WEAPON_REMOTESNIPER`] = { minor = false, violent = true },
	[`WEAPON_GRENADELAUNCHER`] = { minor = false, violent = true },
	[`WEAPON_GRENADELAUNCHER_SMOKE`] = { minor = true, violent = true },
	[`WEAPON_RPG`] = { minor = false, violent = true },
	[`WEAPON_STINGER`] = { minor = false, violent = true },
	[`WEAPON_MINIGUN`] = { minor = false, violent = true },
	[`WEAPON_GRENADE`] = { minor = false, violent = true },
	[`WEAPON_STICKYBOMB`] = { minor = false, violent = true },
	[`WEAPON_SMOKEGRENADE`] = { minor = false, violent = true },
	[`WEAPON_BZGAS`] = { minor = false, violent = true },
	[`WEAPON_MOLOTOV`] = { minor = false, violent = true },
	[`WEAPON_FIREEXTINGUISHER`] = { minor = true },
	[`WEAPON_PETROLCAN`] = { minor = false },
	[`WEAPON_FLARE`] = { minor = false },
	[`WEAPON_BARBED_WIRE`] = { minor = false },
	[`WEAPON_DROWNING`] = { minor = false },
	[`WEAPON_DROWNING_IN_VEHICLE`] = { minor = false },
	[`WEAPON_BLEEDING`] = { minor = false },
	[`WEAPON_ELECTRIC_FENCE`] = { minor = true },
	[`WEAPON_EXPLOSION`] = { minor = false },
	[`WEAPON_FALL`] = { minor = true },
	[`WEAPON_EXHAUSTION`] = { minor = true },
	[`WEAPON_HIT_BY_WATER_CANNON`] = { minor = false, violent = true },
	[`WEAPON_RAMMED_BY_CAR`] = { minor = true },
	[`WEAPON_RUN_OVER_BY_CAR`] = { minor = false },
	[`WEAPON_HELI_CRASH`] = { minor = false },
	[`WEAPON_FIRE`] = { minor = false },
	[`WEAPON_ASSAULTSMG`] = { minor = false, violent = true },
	[`WEAPON_GUSENBERG`] = { minor = false, violent = true },
	[`WEAPON_COMBATPDW`] = { minor = false, violent = true },
	[`WEAPON_HEAVYSHOTGUN`] = { minor = false, violent = true },
	[`WEAPON_AUTOSHOTGUN`] = { minor = false, violent = true },
	[`WEAPON_BULLPUPSHOTGUN`] = { minor = false, violent = true },
	[`WEAPON_ASSAULTSHOTGUN`] = { minor = false, violent = true },
	[`WEAPON_BULLPUPRIFLE`] = { minor = false, violent = true },
	[`WEAPON_ASSAULTRIFLE`] = { minor = false, violent = true },
	[`WEAPON_PISTOL_MK2`] = { minor = false, violent = true },
	[`WEAPON_BEANBAG`] = { minor = true },
	[`WEAPON_AR15`] = { minor = false, violent = true },
	[`WEAPON_50BEOWULF`] = { minor = false, violent = true },
	[`WEAPON_P90FM`] = { minor = false, violent = true },
	[`WEAPON_GLOCK19X2`] = { minor = false, violent = true },
	[`WEAPON_G17`] = { minor = false, violent = true },
	[`WEAPON_FNX`] = { minor = false, violent = true },
	[-1553120962] = { minor = true },
}
