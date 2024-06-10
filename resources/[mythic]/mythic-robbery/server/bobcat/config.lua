BC_SERVER_START_WAIT = 1000 * 60 * math.random(120, 240)
BC_REQUIRED_POLICE = 4

BC_RESET_TIME = 60 * 60 * 8

_bobcatLootTable = {
	["guns"] = {
		{
			29,
			{
				name = "BOBCAT_57",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			28,
			{
				name = "BOBCAT_SNSPISTOL",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			28,
			{
				name = "BOBCAT_COMBATPISTOL",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			5,
			{
				name = "BOBCAT_DOUBLEACTION",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			5,
			{
				name = "BOBCAT_PISTOL50",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			5,
			{
				name = "BOBCAT_REVOLVER",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
	},
	["guns-c2"] = {
		{
			20,
			{
				name = "BOBCAT_PISTOL50",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			20,
			{
				name = "BOBCAT_COMBATPISTOL",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			20,
			{
				name = "BOBCAT_DOUBLEACTION",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
		{
			20,
			{
				name = "BOBCAT_REVOLVER",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
        {
			10,
			{
				name = "BOBCAT_SMG_MK2",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
        {
			5,
			{
				name = "BOBCAT_SAWNOFFSHOTGUN",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
        {
			5,
			{
				name = "BOBCAT_DBSHOTGUN",
				min = 1,
				max = 1,
				metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
			},
		},
        -- {
		-- 	10,
		-- 	{
		-- 		name = "BOBCAT_PUMPSHOTGUN",
		-- 		min = 1,
		-- 		max = 1,
		-- 		metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
		-- 	},
		-- },
		-- {
		-- 	4,
		-- 	{
		-- 		name = "BOBCAT_SMG",
		-- 		min = 1,
		-- 		max = 1,
		-- 		metadata = { ammo = 100, clip = 0, Company = { name = "Bobcat Security", stolen = true } },
		-- 	},
		-- },
	},
	["components"] = {
		{
			22,
			{
				name = "ATTCH_WEAPON_FLASHLIGHT",
				min = 1,
				max = 1,
			},
		},
		{
			20,
			{
				name = "scuba_gear",
				min = 1,
				max = 1,
			},
		},
		{
			19,
			{
				name = "AMMO_SMG",
				min = 3,
				max = 10,
			},
		},
		{
			19,
			{
				name = "AMMO_SHOTGUN",
				min = 3,
				max = 10,
			},
		},
		{
			10,
			{
				name = "ATTCH_PISTOL_EXT_MAG",
				min = 1,
				max = 1,
			},
		},
		{
			10,
			{
				name = "ATTCH_PISTOL_SILENCER",
				min = 1,
				max = 1,
			},
		},
	},
}


_bobcatLocations = {
    extrDoor = {
        coords =  vector3(882.174, -2258.287, 30.541),
        heading = 178.102,
    },
	startDoor = {
		coords = vector3(880.3293, -2264.466, 30.59444),
        heading = 178.102,
	},
    securedDoor = {
        coords = vector3(882.976, -2268.013, 30.468),
    },
    vaultDoor = {
        coords = vector3(890.41, -2285.601, 30.467),
        heading = 93.374,
    }
}

_bobcatPedLocs = {
    vector4(886.807, -2276.838, 29.468, 51.147),
    vector4(893.393, -2276.251, 29.468, 78.949),
    vector4(891.600, -2274.399, 29.468, 108.464),
    vector4(892.425, -2284.977, 29.468, 358.630),
    vector4(896.191, -2281.820, 29.468, 39.449),
    vector4(892.821, -2292.995, 29.468, 355.386),
    vector4(886.287, -2294.577, 29.468, 294.028),
    vector4(882.191, -2291.016, 29.468, 262.662),
    vector4(872.283, -2295.646, 29.468, 286.915),
    vector4(869.142, -2289.833, 29.468, 258.194),
    vector4(879.335, -2296.077, 29.468, 357.248),
    vector4(889.901, -2278.239, 29.468, 51.623),
    vector4(894.838, -2293.385, 29.468, 5.322),
    vector4(880.594, -2290.424, 29.468, 256.154),
    vector4(894.204, -2278.500, 29.468, 64.731),
    vector4(894.143, -2282.527, 29.468, 19.232),
    vector4(883.731, -2274.178, 29.468, 76.075),
    vector4(890.418, -2292.704, 29.468, 326.799),
    vector4(894.257, -2289.460, 29.468, 4.785),
    vector4(879.189, -2291.258, 29.468, 264.933),
    vector4(869.398, -2297.251, 29.468, 302.063),
    vector4(868.223, -2288.710, 29.468, 248.462),
}

_bobcatLootLocs = {
    {
        coords = vector3(881.8, -2282.79, 30.47),
        width = 2.0,
        length = 1.4,
        options = {
            heading = 333,
            -- debugPoly = true,
            minZ = 29.47,
            maxZ = 31.67
        },
        data = {
            id = 1,
            type = "guns-c2",
            amount = 2,
            bonus = 8,
        }
    },
    {
        coords = vector3(882.55, -2285.82, 30.47),
        width = 1.15,
        length = 1.8,
        options = {
            heading = 341,
            -- debugPoly = true,
            minZ = 29.47,
            maxZ = 31.27
        },
        data = {
            id = 2,
            type = "guns-c2",
            amount = 2,
            bonus = 8,
        }
    },
    {
        coords = vector3(886.63, -2286.84, 30.59),
        width = 1.4,
        length = 2.0,
        options = {
            heading = 0,
            -- debugPoly = true,
            minZ = 29.59,
            maxZ = 30.99
        },
        data = {
            id = 3,
            type = "guns",
            amount = 3,
            bonus = 15,
        }
    },
    {
        coords = vector3(887.01, -2282.06, 30.47),
        width = 1.2,
        length = 2.2,
        options = {
            heading = 354,
            -- debugPoly = true,
            minZ = 29.47,
            maxZ = 31.27
        },
        data = {
            id = 4,
            type = "components",
            amount = 4,
            bonus = 10,
        }
    },
}