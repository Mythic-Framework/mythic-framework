SERVER_START_WAIT = 1000 * 60 * math.random(30, 60)
REQUIRED_POLICE = 4

RESET_TIME = 60 * 60 * 6

MAX_GATEPC_SEQ_ATTEMPTS = 100

FLEECA_LOCATIONS = {
	fleeca_hawick_east = {
		id = "fleeca_hawick_east",
		label = "East Hawick Ave",
		coords = vector3(311.5, -282.35, 54.16),
		width = 13.2,
		length = 11.6,
		options = {
			name = "fleeca_hawick_east",
			heading = 340,
			minZ = 53.16,
			maxZ = 58.16,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(309.15, -281.37, 54.16),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 53.56,
				maxZ = 55.76
			}
		},
		points = {
			vaultPC = {
				coords = vector3(311.202, -284.257, 54.165),
				heading = 161.541
			},
			vaultGate = {
				coords = vector3(313.2626, -285.3768, 54.50795),
				heading = 166.280
			},
		},
		carts = {
			{
				coords = vector3(315.351, -284.929, 53.145),
				rotate = vector3(0, 0, 69.728),
			},
			{
				coords = vector3(310.935, -287.820, 53.145),
				rotate = vector3(0, 0, -110.439),
			},
			{
				coords = vector3(314.096, -289.318, 53.145),
				rotate = vector3(0, 0, 17.739),
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 249.866,
			},
		},
	},
	fleeca_hawick_west = {
		id = "fleeca_hawick_west",
		label = "West Hawick Ave",
		coords = vector3(-353.26, -53.09, 49.04),
		width = 12.4,
		length = 14.0,
		options = {
			name = "fleeca_hawick_west",
			heading = 340,
			minZ = 48.04,
			maxZ = 52.04,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(-356.0, -52.24, 49.04),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 48.64,
				maxZ = 50.24
			}
		},
		points = {
			vaultPC = {
				coords = vector3(-353.713, -54.698, 49.037),
				heading = 160.637
			},
			vaultGate = {
				coords = vector3(-351.7869, -56.2472, 49.36483),
				heading = 163.485
			},
		},
		carts = {
			{
				coords = vector3(-349.6076354980469, -55.69731903076172, 48.48738861083984),
				rotate = vector3(0, 0, 70.9395523071289),
			},
			{
				coords = vector3(-349.9295654296875, -58.20112609863281, 48.48744964599609),
				rotate = vector3(0, 0, 69.94938659667969),
			},
			{
				coords = vector3(-353.7457275390625, -59.30472564697265, 48.48740768432617),
				rotate = vector3(0, 0, -20.67239189147949),
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 250.860,
			},
		},
	},
	fleeca_delperro = {
		id = "fleeca_delperro",
		label = "Boulevard Del Perro",
		coords = vector3(-1212.59, -335.36, 37.78),
		width = 12.4,
		length = 14.0,
		options = {
			name = "fleeca_delperro",
			heading = 207,
			minZ = 36.78,
			maxZ = 40.78,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(-1214.56, -336.0, 37.78),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 25,
				--debugPoly=true,
				minZ = 37.38,
				maxZ = 39.18
			}
		},
		points = {
			vaultPC = {
				coords = vector3(-1210.908, -336.374, 37.781),
				heading = 207.123
			},
			vaultGate = {
				coords = vector3(-1208.644, -335.7033, 38.10191),
				heading = 209.101
			},
		},
		carts = {
			{
				coords = vector3(-1208.801513671875, -333.35888671875, 37.23183059692383),
				rotate = vector3(0, 0, -153.7089385986328),
			},
			{
				coords = vector3(-1209.4437255859375, -337.4613037109375, 37.2318000793457),
				rotate = vector3(0, 0, -63.64436340332031),
			},
			{
				coords = vector3(-1206.38330078125, -338.7407531738281, 37.23189544677734),
				rotate = vector3(0, 0, 28.85287857055664),
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 296.864,
			},
		},
	},
	fleeca_great_ocean = {
		id = "fleeca_great_ocean",
		label = "Great Ocean Highway",
		coords = vector3(-2959.0, 479.93, 15.7),
		width = 13.2,
		length = 14.0,
		options = {
			name = "fleeca_great_ocean",
			heading = 177,
			minZ = 14.7,
			maxZ = 18.7,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(-2958.92, 478.64, 15.7),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 0,
				--debugPoly=true,
				minZ = 15.1,
				maxZ = 16.9
			}
		},
		points = {
			vaultPC = {
				coords = vector3(-2956.775, 481.664, 15.697),
				heading = 270.583
			},
			vaultGate = {
				coords = vector3(-2956.255, 483.9868, 16.0309),
				heading = 269.528
			},
		},
		carts = {
			{
				coords = vector3(-2957.746337890625, 485.85125732421875, 15.14789676666259),
				rotate = vector3(0, 0, -170.60107421875),
			},
			{
				coords = vector3(-2952.4482421875, 485.7495422363281, 15.1479787826538),
				rotate = vector3(0, 0, 87.94722747802734),
			},
			{
				coords = vector3(-2954.23583984375, 482.419921875, 15.14787006378173),
				rotate = vector3(0, 0, -2.4940390586853),
			},
		},
		doors = {
			vaultDoor = {
				object = -63539571,
				step = -0.60,
				originalHeading = 357.542,
			},
		},
	},
	fleeca_route68 = {
		id = "fleeca_route68",
		label = "Route 68",
		coords = vector3(1177.01, 2710.92, 38.09),
		width = 12.4,
		length = 14.0,
		options = {
			name = "fleeca_route68",
			heading = 359,
			minZ = 37.09,
			maxZ = 41.09,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(1179.12, 2710.69, 38.09),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 0,
				--debugPoly=true,
				minZ = 37.49,
				maxZ = 39.29
			}
		},
		points = {
			vaultPC = {
				coords = vector3(1176.091, 2712.595, 38.088),
				heading = 4.828
			},
			vaultGate = {
				coords = vector3(1173.74, 2713.073, 38.41225),
				heading = 3.455
			},
		},
		carts = {
			{
				coords = vector3(1171.85009765625, 2711.930908203125, 37.53884506225586),
				rotate = vector3(0, 0, -90.10700988769531),
			},
			{
				coords = vector3(1171.2725830078125, 2715.08935546875, 37.53892135620117),
				rotate = vector3(0, 0, -89.14143371582031),
			},
			{
				coords = vector3(1174.9361572265625, 2713.9052734375, 37.53881454467773),
				rotate = vector3(0, 0, 50.88222122192383),
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 90.0,
			},
		},
	},
	fleeca_vespucci = {
		id = "fleeca_vespucci",
		label = "Vespucci Blvd",
		coords = vector3(145.95, -1043.69, 29.37),
		width = 12.4,
		length = 14.0,
		options = {
			name = "fleeca_vespucci",
			heading = 70,
			minZ = 28.37,
			maxZ = 32.37,
			--debugPoly = true,
		},
		reset = {
			coords = vector3(144.66, -1042.92, 29.37),
			length = 0.4,
			width = 0.4,
			options = {
				heading = 340,
				--debugPoly=true,
				minZ = 28.57,
				maxZ = 30.77
			}
		},
		points = {
			vaultPC = {
				coords = vector3(147.043, -1045.367, 29.368),
				heading = 165.714
			},
			vaultGate = {
				coords = vector3(148.9605, -1047.058, 29.70366),
				heading = 165.708
			},
		},
		carts = {
			{
				coords = vector3(150.89013671875, -1046.42236328125, 28.81888580322265),
				rotate = vector3(0, 0, 70.36432647705078),
			},
			{
				coords = vector3(149.44985961914062, -1051.1807861328125, 28.8189640045166),
				rotate = vector3(0, 0, -20.00465965270996),
			},
			{
				coords = vector3(146.57156372070312, -1049.4759521484375, 28.81887817382812),
				rotate = vector3(0, 0, -111.52824401855469),
			},
		},
		doors = {
			vaultDoor = {
				object = 2121050683,
				step = -0.60,
				originalHeading = 249.846,
			},
		},
	},
}
