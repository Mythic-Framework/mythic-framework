PALETO_SERVER_START_WAIT = 1000 * 60 * math.random(120, 360)
PALETO_REQUIRED_POLICE = 4

PALETO_RESET_TIME = 60 * 60 * 8

_pbDoorsGarbage = {
	{
		doorId = "bank_savings_paleto_corridor_1",
		label = "Tellers",
		requireCode = false,
		data = {
			id = 1,
			door = "bank_savings_paleto_corridor_1",
		},
	},
	{
		doorId = "bank_savings_paleto_corridor_2",
		label = "Security Hallway",
		requireCode = false,
		data = {
			id = 2,
			door = "bank_savings_paleto_corridor_2",
		},
	},
	{
		doorId = "bank_savings_paleto_office_1",
		label = "Office #1",
		requireCode = true,
		data = {
			id = 3,
			officeId = 1,
			door = "bank_savings_paleto_office_1",
		},
	},
	{
		doorId = "bank_savings_paleto_office_2",
		label = "Office #2",
		requireCode = true,
		data = {
			id = 4,
			officeId = 2,
			door = "bank_savings_paleto_office_2",
		},
	},
	{
		doorId = "bank_savings_paleto_office_3",
		label = "Office #3",
		requireCode = true,
		data = {
			id = 5,
			officeId = 3,
			door = "bank_savings_paleto_office_3",
		},
	},
}

_pbSubStations = {
	{
		id = 1,
		thermite = {
			coords = vector3(2586.039, 5065.303, 45.04548),
			heading = 197.966,
		},
		explosions = {
			vector3(2593.786, 5060.913, 45.546),
			vector3(2587.667, 5058.760, 45.743),
			vector3(2592.805, 5064.298, 45.285),
		},
	},
	{
		id = 2,
		thermite = {
			coords = vector3(1353.959, 6386.733, 33.19492),
			heading = 90.234,
		},
		explosions = {
			vector3(1349.453, 6380.395, 34.416),
			vector3(1349.467, 6387.196, 33.801),
			vector3(1341.865, 6386.671, 33.874),
			vector3(1341.857, 6380.379, 34.431),
		},
	},
	{
		id = 3,
		thermite = {
			coords = vector3(-288.9897, 6027.154, 31.55255),
			heading = 133.697,
		},
		explosions = {
			vector3(-293.155, 6021.172, 32.111),
			vector3(-289.357, 6017.341, 32.062),
			vector3(-287.331, 6021.060, 31.930),
			vector3(-290.942, 6024.837, 32.593),
		},
	},
	{
		id = 4,
		thermite = {
			coords = vector3(239.3452, 6405.226, 31.8286),
			heading = 111.934,
		},
		explosions = {
			vector3(235.663, 6403.994, 32.199),
			vector3(237.823, 6398.830, 32.178),
			vector3(233.731, 6396.820, 32.259),
			vector3(231.195, 6402.163, 32.031),
			vector3(228.429, 6399.177, 31.395),
			vector3(229.807, 6395.989, 31.771),
		},
	},
}

_pbLockpickPoints = {
	{
		coords = vector3(-111.549, 6468.489, 31.634),
		door = "",
	},
}

_pbHackPoints = {
	{
		coords = vector3(-102.342, 6463.234, 31.634),
		heading = 224.469,
		door = "bank_savings_paleto_vault",
		requiredDoors = {},
	},
}

_pbDoorThermite = {
	{
		coords = vector3(-97.33757, 6475.071, 31.50123),
		heading = 136.012,
		door = "bank_savings_paleto_back_1",
		requiredDoors = {},
	},
	{
		coords = vector3(-118.7633, 6477.372, 31.57678),
		heading = 221.941,
		door = "bank_savings_paleto_back_2",
		requiredDoors = {},
		requireExploit = false,
	},
}

_pbSecurityPower = {
	{
		coords = vector3(-118.4007, 6470.696, 31.65586),
		heading = 137.899,
		powerId = 1,
		requiredDoors = {
			"bank_savings_paleto_back_2",
		},
		ptfx = {
			vector3(-118.3559, 6470.742, 32.59674),
			vector3(-118.112, 6470.457, 31.36404),
		},
	},
	{
		coords = vector3(-92.64053, 6469.752, 31.7244),
		heading = 319.835,
		powerId = 2,
		requiredDoors = {
			"bank_savings_paleto_back_1",
		},
		ptfx = {
			vector3(-92.68832, 6469.708, 32.62043),
			vector3(-92.9099, 6469.972, 31.36724),
		},
	},
}
