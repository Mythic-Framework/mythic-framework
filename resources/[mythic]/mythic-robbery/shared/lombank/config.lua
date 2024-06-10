_lbCarts = {
    `prop_large_gold`,
    `prop_large_gold_alt_a`,
    `prop_large_gold_alt_b`,
    `prop_large_gold_alt_c`,
}

lbThermPoints = {
	lobbyGate = {
		coords = vector3(17.5381, -920.9682, 30.07446),
		heading = 249.549,
		door = "lombank_front_gate",
		requiredDoors = {},
	},
	vaultGate = {
		coords = vector3(24.04349, -932.0154, 30.25345),
		heading = 166.307,
		door = "lombank_upper_gate",
		requiredDoors = {
			"lombank_front_gate",
		},
	},
	upperVaultGate = {
		coords = vector3(22.34634, -942.4745, 30.26073),
		heading = 249.518,
		door = "lombank_upper_vault_gate",
		requiredDoors = {
			"lombank_front_gate",
			"lombank_upper_gate",
			"lombank_upper_vault",
		},
	},
	lowerVaultGate = {
		coords = vector3(25.865, -929.0033, 26.09646),
		heading = 74.396,
		door = "lombank_lower_gate",
		requiredDoors = {
			"lombank_front_gate",
			"lombank_upper_gate",
		},
	},
	lowerVaultRoom1 = {
		coords = vector3(24.48319, -913.9099, 26.09066),
		heading = 76.141,
		door = "lombank_lower_room_1",
		requiredDoors = {
			"lombank_front_gate",
			"lombank_upper_gate",
			"lombank_lasers",
			"lombank_lower_vault",
		},
	},
	lowerVaultRoom2 = {
		coords = vector3(33.44628, -917.2109, 26.08794),
		heading = 250.554,
		door = "lombank_lower_room_2",
		requiredDoors = {
			"lombank_front_gate",
			"lombank_upper_gate",
			"lombank_lasers",
			"lombank_lower_vault",
		},
	},
	lowerVaultRoom3 = {
		coords = vector3(27.05835, -906.868, 26.08865),
		heading = 76.141,
		door = "lombank_lower_room_3",
		requiredDoors = {
			"lombank_front_gate",
			"lombank_upper_gate",
			"lombank_lasers",
			"lombank_lower_vault",
		},
	},
	lowerVaultRoom4 = {
		coords = vector3(36.03009, -910.1262, 26.09541),
		heading = 250.554,
		door = "lombank_lower_room_4",
		requiredDoors = {
			"lombank_front_gate",
			"lombank_upper_gate",
			"lombank_lasers",
			"lombank_lower_vault",
		},
	},
}

_lbHackPoints = {
	upperVaultDoor = {
		coords = vector3(21.330, -939.860, 29.903),
		heading = 161.625,
		config = {
			countdown = 3,
			timer = { 1500, 2200 },
			limit = 20000,
			difficulty = 4,
			chances = 6,
			isShuffled = false,
			anim = false,
		},
		door = "lombank_upper_vault",
		requiredDoors = {
			"lombank_front_gate",
			"lombank_upper_gate",
		},
	},
	lowerVaultDoor = {
		coords = vector3(28.094, -921.723, 25.738),
		heading = 250.137,
		config = {
			countdown = 3,
			timer = { 1500, 2200 },
			limit = 20000,
			difficulty = 4,
			chances = 6,
			isShuffled = false,
			anim = false,
		},
		door = "lombank_lower_vault",
		forceOpen = true,
		requiredDoors = {
			"lombank_front_gate",
			"lombank_upper_gate",
			"lombank_lasers",
		},
	},
}

_lbPowerBoxes = {
	{
		isThermite = false,
		coords = vector3(85.45, -812.77, 31.36),
		length = 1.0,
		width = 1.4,
		options = {
			heading = 343,
			--debugPoly = true,
			minZ = 31.16,
			maxZ = 32.96,
		},
		data = {
			boxId = 1,
			ptFxPoint = vector3(85.37447, -812.7527, 32.08653),
		},
	},
	{
		isThermite = false,
		coords = vector3(55.65, -832.02, 31.07),
		length = 1.0,
		width = 1.4,
		options = {
			heading = 340,
			--debugPoly = true,
			minZ = 30.47,
			maxZ = 33.27,
		},
		data = {
			boxId = 2,
			ptFxPoint = vector3(55.73209, -831.9764, 32.08678),
		},
	},
	{
		isThermite = true,
		coords = vector3(88.81, -1080.09, 29.3),
		length = 1.6,
		width = 1.4,
		options = {
			heading = 336,
			--debugPoly = true,
			minZ = 28.3,
			maxZ = 30.5,
		},
		data = {
			boxId = 3,
			thermitePoint = {
				coords = vector3(89.09108, -1080.605, 29.54803),
				heading = 71.914,
			},
			ptFxPoint = vector3(89.09108, -1080.605, 29.54803),
		},
	},
}

_lbUpperVaultPoints = {
	{
		coords = vector3(24.18, -941.61, 29.9),
		length = 0.6,
		width = 2.2,
		options = {
			heading = 340,
			--debugPoly = true,
			minZ = 29.3,
			maxZ = 31.7,
		},
		wallId = 1,
	},
	{
		coords = vector3(26.84, -942.42, 29.9),
		length = 0.6,
		width = 2.2,
		options = {
			heading = 340,
			--debugPoly = true,
			minZ = 29.3,
			maxZ = 31.7,
		},
		wallId = 2,
	},
	{
		coords = vector3(27.5, -944.83, 29.9),
		length = 0.6,
		width = 2.2,
		options = {
			heading = 251,
			--debugPoly = true,
			minZ = 29.3,
			maxZ = 31.7,
		},
		wallId = 3,
	},
}

_lombankRooms = {
	{
		coords = vector3(22.14, -913.35, 25.74),
		length = 3.8,
		width = 4.4,
		options = {
			heading = 340,
			--debugPoly = true,
			minZ = 24.74,
			maxZ = 27.54,
		},
		roomId = 1,
	},
	{
		coords = vector3(35.55, -918.27, 25.74),
		length = 3.8,
		width = 4.4,
		options = {
			heading = 340,
			--debugPoly = true,
			minZ = 24.74,
			maxZ = 27.54,
		},
		roomId = 2,
	},
	{
		coords = vector3(24.7, -906.27, 25.74),
		length = 3.8,
		width = 4.4,
		options = {
			heading = 340,
			--debugPoly = true,
			minZ = 24.74,
			maxZ = 27.54,
		},
		roomId = 3,
	},
	{
		coords = vector3(38.18, -911.16, 25.74),
		length = 3.8,
		width = 4.4,
		options = {
			heading = 340,
			--debugPoly = true,
			minZ = 24.74,
			maxZ = 27.54,
		},
		roomId = 4,
	},
}
