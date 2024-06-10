_mbDoors = {
	{
		coords = vector3(-1307.724, -817.6955, 16.80672),
		heading = 305.704,
		door = "mazebank_tills",
		requiredDoors = {},
	},
	{
		coords = vector3(-1301.999, -819.1389, 16.88831),
		heading = 306.572,
		door = "mazebank_gate",
		requiredDoors = {
			"mazebank_tills",
		},
	},
	{
		coords = vector3(-1295.787, -816.8411, 17.15724),
		heading = 217.537,
		door = "mazebank_vault_gate",
		requiredDoors = {
			"mazebank_tills",
			"mazebank_gate",
		},
	},
}

_mbHacks = {
	{
		coords = vector3(-1299.680, -816.679, 16.779),
		heading = 308.857,
		requiredDoors = {
			"mazebank_tills",
			"mazebank_gate",
		},
		doorId = 1,
		doorConfig = {
			object = `v_ilev_cbankvauldoor01`,
			step = 0.8,
			originalHeading = 306.902,
		},
		config = {
			countdown = 3,
			timer = { 1700, 2400 },
			limit = 20000,
			difficulty = 4,
			chances = 6,
			isShuffled = false,
			anim = false,
		},
	},
}

_mbDrillPoints = {
	{
		coords = vector3(-1293.04, -816.81, 16.78),
		length = 0.6,
		width = 2.0,
		options = {
			heading = 308,
			--debugPoly = true,
			minZ = 16.58,
			maxZ = 18.18,
		},
		data = {
			wallId = 1,
		},
	},
	{
		coords = vector3(-1291.2, -818.81, 16.78),
		length = 0.8,
		width = 1.8,
		options = {
			heading = 305,
			--debugPoly = true,
			minZ = 16.38,
			maxZ = 18.18,
		},
		data = {
			wallId = 2,
		},
	},
	{
		coords = vector3(-1291.28, -820.56, 16.78),
		length = 2.0,
		width = 0.6,
		options = {
			heading = 306,
			--debugPoly = true,
			minZ = 16.18,
			maxZ = 18.18,
		},
		data = {
			wallId = 3,
		},
	},
	{
		coords = vector3(-1293.2, -821.57, 16.78),
		length = 1.8,
		width = 0.8,
		options = {
			heading = 307,
			--debugPoly = true,
			minZ = 16.58,
			maxZ = 17.78,
		},
		data = {
			wallId = 4,
		},
	},
	{
		coords = vector3(-1294.69, -821.32, 16.78),
		length = 0.2,
		width = 1.6,
		options = {
			heading = 308,
			--debugPoly = true,
			minZ = 16.58,
			maxZ = 17.98,
		},
		data = {
			wallId = 5,
		},
	},
	{
		coords = vector3(-1296.16, -819.15, 16.78),
		length = 0.4,
		width = 1.8,
		options = {
			heading = 308,
			--debugPoly = true,
			minZ = 16.58,
			maxZ = 17.98,
		},
		data = {
			wallId = 6,
		},
	},
}

_mbOfficeDoors = {
	{
		coords = vector3(-1300.430, -831.591, 17.075),
		door = "mazebank_office_1",
		requiredDoors = {
			"mazebank_offices",
		},
	},
	{
		coords = vector3(-1297.972, -834.860, 17.075),
		door = "mazebank_office_2",
		requiredDoors = {
			"mazebank_offices",
		},
	},
	{
		coords = vector3(-1292.914, -841.591, 17.075),
		door = "mazebank_office_3",
		requiredDoors = {
			"mazebank_offices",
		},
	},
}

_mbDesks = {
	{
		coords = vector3(-1296.43, -827.92, 17.07),
		length = 1.2,
		width = 3.0,
		options = {
			heading = 306,
			--debugPoly = true,
			minZ = 16.07,
			maxZ = 17.87,
		},
		requiredDoors = {
			"mazebank_offices",
			"mazebank_office_1",
		},
		data = {
			deskId = 1,
		},
	},
	{
		coords = vector3(-1293.37, -832.03, 17.07),
		length = 1.2,
		width = 3.0,
		options = {
			heading = 307,
			--debugPoly = true,
			minZ = 16.07,
			maxZ = 17.87,
		},
		requiredDoors = {
			"mazebank_offices",
			"mazebank_office_2",
		},
		data = {
			deskId = 2,
		},
	},
	{
		coords = vector3(-1287.19, -837.78, 17.07),
		length = 1.2,
		width = 3.0,
		options = {
			heading = 307,
			--debugPoly = true,
			minZ = 16.07,
			maxZ = 17.87,
		},
		requiredDoors = {
			"mazebank_offices",
			"mazebank_office_3",
		},
		data = {
			deskId = 3,
		},
	},
}

_mbElectric = {
	{
		isThermite = false,
		coords = vector3(-1304.94, -803.99, 17.58),
		length = 0.8,
		width = 1.2,
		options = {
			heading = 303,
			--debugPoly = true,
			minZ = 16.58,
			maxZ = 18.98,
		},
		data = {
			boxId = 1,
			ptFxPoint = vector3(-1304.799, -803.7391, 17.62313),
		},
	},
	{
		isThermite = false,
		coords = vector3(-1286.22, -834.59, 17.1),
		length = 0.6,
		width = 1.0,
		options = {
			heading = 308,
			--debugPoly = true,
			minZ = 16.5,
			maxZ = 18.7,
		},
		data = {
			boxId = 2,
			ptFxPoint = vector3(-1286.22, -834.5959, 17.58015),
		},
	},
	{
		isThermite = true,
		coords = vector3(-1381.05, -830.55, 19.08),
		length = 0.6,
		width = 0.8,
		options = {
			heading = 14,
			--debugPoly = true,
			minZ = 17.08,
			maxZ = 20.08,
		},
		data = {
			boxId = 3,
			thermitePoint = {
				coords = vector3(-1381.041, -830.7778, 19.095),
				heading = 18.270,
			},
			ptFxPoint = vector3(-1381.041, -830.7778, 19.095),
		},
	},
}
