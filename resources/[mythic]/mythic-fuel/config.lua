Config = {
	Usage = 1.75,
	FuelUsage = {
		[1.3] = 1.3,
		[1.2] = 1.2,
		[1.1] = 1.1,
		[1.0] = 1.0,
		[0.9] = 0.8,
		[0.8] = 0.7,
		[0.7] = 0.6,
		[0.6] = 0.5,
		[0.5] = 0.4,
		[0.4] = 0.3,
		[0.3] = 0.2,
		[0.2] = 0.1,
		[0.1] = 0.1,
		[0.0] = 0.0,
	},
	Classes = {
		[0] = 0.7, -- Compacts
		[1] = 0.8, -- Sedans
		[2] = 1.0, -- SUVs
		[3] = 0.9, -- Coupes
		[4] = 1.0, -- Muscle
		[5] = 1.0, -- Sports Classics
		[6] = 1.0, -- Sports
		[7] = 1.15, -- Super
		[8] = 0.5, -- Motorcycles
		[9] = 1.0, -- Off-road
		[10] = 1.2, -- Industrial
		[11] = 1.2, -- Utility
		[12] = 1.2, -- Vans
		[13] = 0.0, -- Cycles
		[14] = 0.8, -- Boats
		[15] = 12.0, -- Helicopters
		[16] = 1.0, -- Planes
		[17] = 1.2, -- Service
		[18] = 0.8, -- Emergency
		[19] = 1.4, -- Military
		[20] = 1.2, -- Commercial
		[21] = 0.0, -- Trains
	},
	FuelCost = { -- Per % for each class
		[0] = 1.25, -- Compacts
		[1] = 1.25, -- Sedans
		[2] = 1.75, -- SUVs
		[3] = 1.5, -- Coupes
		[4] = 1.75, -- Muscle
		[5] = 2.0, -- Sports Classics
		[6] = 2.0, -- Sports
		[7] = 2.25, -- Super
		[8] = 1.4, -- Motorcycles
		[9] = 1.8, -- Off-road
		[10] = 2.2, -- Industrial
		[11] = 2.2, -- Utility
		[12] = 1.8, -- Vans
		[13] = 0.0, -- Cycles
		[14] = 3.0, -- Boats
		[15] = 4.0, -- Helicopters
		[16] = 5.0, -- Planes
		[17] = 2.0, -- Service
		[18] = 1.5, -- Emergency
		[19] = 2.0, -- Military
		[20] = 2.0, -- Commerical
		[21] = 5.0, -- Trains
	},
	FuelStations = {
		{ -- Strawberry Fuel Station
			center = vector3(265.34, -1261.21, 29.14),
			length = 19.8,
			width = 30.8,
			heading = 0,
			minZ = 27.94,
			maxZ = 37.34,
			restricted = false,
		},
		{ -- Vinewood Fuel Station
			center = vector3(621.2, 268.89, 103.09),
			length = 15.0,
			width = 28.0,
			heading = 0,
			minZ = 102.09,
			maxZ = 110.29,
			restricted = false,
		},
		{ -- Morningwood Fuel Station
			center = vector3(-1436.79, -276.91, 46.32),
			length = 22.8,
			width = 18.6,
			heading = 40,
			minZ = 45.32,
			maxZ = 54.12,
			restricted = false,
		},
		{ -- Great Ocean HWay City Fuel Station
			center = vector3(-2096.86, -318.65, 13.02),
			length = 20.2,
			width = 25.4,
			heading = 354,
			minZ = 12.02,
			maxZ = 19.42,
			restricted = false,
		},
		{ -- Heliport
			center = vector3(-732.79, -1450.31, 5.0),
			length = 55.2,
			width = 66.15,
			heading = 319,
			minZ = 4.0,
			maxZ = 9.6,
			restricted = 'aircraft',
		},
		{ -- Marina Near Airport
			center = vector3(-804.17, -1505.73, 1.6),
			length = 35.0,
			width = 22.2,
			heading = 20,
			minZ = -3.0,
			maxZ = 4.2,
			restricted = 'boat',
		},
		{ -- Marina Near Airport 2
			center = vector3(-779.92, -1425.33, 1.59),
			length = 35.0,
			width = 22.2,
			heading = 320,
			minZ = -2.21,
			maxZ = 4.0,
			restricted = 'boat',
		},
		{ -- LSIA Airport Helipad
			center = vector3(-1112.09, -2883.95, 13.95),
			length = 16.6,
			width = 19.0,
			heading = 330,
			minZ = 12.75,
			maxZ = 24.35,
			restricted = 'aircraft',
		},
		{ -- LSIA Airport Hangar
			center = vector3(-951.18, -2974.5, 13.95),
			length = 20.0,
			width = 37.2,
			heading = 330,
			minZ = 12.75,
			maxZ = 24.35,
			restricted = 'aircraft',
		},
		{ -- Grove Street Fuel Station
			center = vector3(-69.85, -1762.42, 29.43),
			length = 15.0,
			width = 30.4,
			heading = 339,
			minZ = 28.43,
			maxZ = 40.03,
			restricted = false,
		},
		{ -- South Side Fuel Station
			center = vector3(176.31, -1561.75, 29.24),
			length = 18.6,
			width = 16.8,
			heading = 43,
			minZ = 28.0,
			maxZ = 37.8,
			restricted = false,
		},
		{ -- East Side Fuel Station Near MRPD Bridge
			center = vector3(817.96, -1028.14, 26.27),
			length = 9.0,
			width = 27.2,
			heading = 0,
			minZ = 25.27,
			maxZ = 37.87,
			restricted = false,
		},
		{ -- Other East Side Fuel Station
			center = vector3(1208.44, -1401.6, 35.22),
			length = 20.8,
			width = 10.0,
			heading = 46,
			minZ = 34.22,
			maxZ = 45.02,
			restricted = false,
		},
		{ -- Mirror Park Fuel Station
			center = vector3(1181.14, -330.46, 69.18),
			length = 15.8,
			width = 28.4,
			heading = 280,
			minZ = 67.98,
			maxZ = 76.58,
			restricted = false,
		},
		{ -- Palamino Fuel Station
			center = vector3(-525.04, -1209.57, 18.2),
			length = 22.0,
			width = 17.2,
			heading = 335,
			minZ = 17.0,
			maxZ = 25.2,
			restricted = false,
		},
		{ -- Little Seoul Fuel Station
			center = vector3(-722.28, -935.68, 18.83),
			length = 13.6,
			width = 29.0,
			heading = 0,
			minZ = 18.0,
			maxZ = 26.0,
			restricted = false,
		},
		{ -- Fort Zancudo HWay Fuel Station
			center = vector3(-2555.78, 2333.35, 33.06),
			length = 15.8,
			width = 26.6,
			heading = 275,
			minZ = 32.0,
			maxZ = 40.86,
			restricted = false,
		},
		{ -- Paleto Fuel Station
			center = vector3(180.35, 6602.74, 31.85),
			length = 16.0,
			width = 30.0,
			heading = 10,
			minZ = 30.45,
			maxZ = 38.65,
			restricted = false,
		},
		{ -- Paleto Fuel Station 1.5
			center = vector3(155.37, 6629.42, 31.82),
			length = 8.0,
			width = 6.2,
			heading = 315,
			minZ = 30.82,
			maxZ = 34.82,
			restricted = false,
		},
		{ -- Paleto Fuel Station 2
			center = vector3(-94.73, 6419.57, 31.48),
			length = 12.4,
			width = 18.8,
			heading = 45,
			minZ = 30.48,
			maxZ = 34.48,
			restricted = false,
		},
		{ -- Paleto Fuel Station 3
			center = vector3(1702.13, 6416.41, 33.21),
			length = 15.0,
			width = 10.0,
			heading = 70,
			minZ = 31.41,
			maxZ = 35.61,
			restricted = false,
		},
		{ -- Grapeseed Fuel Station
			center = vector3(1686.98, 4929.65, 42.08),
			length = 7.8,
			width = 17.4,
			heading = 325,
			minZ = 40.88,
			maxZ = 47.08,
			restricted = false,
		},
		{ -- Grapeseed Hangar Fuel Station
			center = vector3(2133.2, 4784.08, 40.97),
			length = 10.0,
			width = 15.0,
			heading = 295,
			minZ = 107.06,
			maxZ = 115.86,
			restricted = 'aircraft',
		},

		{ -- Sandy Fuel Station 1
			center = vector3(2004.74, 3774.36, 32.18),
			length = 10.2,
			width = 14.0,
			heading = 30,
			minZ = 31.18,
			maxZ = 35.18,
			restricted = false,
		},
		{ -- Sandy Fuel Station 2
			center = vector3(1784.82, 3331.6, 41.34),
			length = 10.0,
			width = 9.6,
			heading = 30,
			minZ = 40.34,
			maxZ = 44.34,
			restricted = false,
		},
		{ -- Sandy Helipad Fuel Station
			center = vector3(1770.65, 3240.2, 42.19),
			length = 10.4,
			width = 110.6,
			heading = 15,
			minZ = 40.39,
			maxZ = 46.39,
			restricted = 'aircraft',
		},
		{ -- Sandy Hangar Fuel Station
			center = vector3(1731.27, 3310.06, 41.22),
			length = 10.0,
			width = 20.0,
			heading = 285,
			minZ = 40.22,
			maxZ = 44.22,
			restricted = 'aircraft',
		},
		{ -- Harmony Fuel Station 1
			center = vector3(1208.41, 2660.38, 37.9),
			length = 11.4,
			width = 12.2,
			heading = 45,
			minZ = 36.9,
			maxZ = 40.9,
			restricted = false,
		},
		{ -- Harmony Fuel Station 2
			center = vector3(1039.19, 2672.08, 39.55),
			length = 15.2,
			width = 16.4,
			heading = 0,
			minZ = 37.95,
			maxZ = 45.55,
			restricted = false,
		},
		{ -- Harmony Fuel Station 3
			center = vector3(264.29, 2607.81, 44.79),
			length = 13.8,
			width = 10.0,
			heading = 10,
			minZ = 43.79,
			maxZ = 47.79,
			restricted = false,
		},
		{ -- Harmony Fuel Station 4
			center = vector3(49.75, 2778.85, 58.04),
			length = 10.8,
			width = 12.0,
			heading = 50,
			minZ = 57.04,
			maxZ = 61.04,
			restricted = false,
		},

		{ -- Sandy Hway Fuel Station
			center = vector3(2680.72, 3264.34, 55.24),
			length = 11.2,
			width = 11.0,
			heading = 330,
			minZ = 54.24,
			maxZ = 58.24,
			restricted = false,
		},
		{ -- Barny Fuel Station
			center = vector3(2537.64, 2593.37, 37.94),
			length = 10.0,
			width = 10.0,
			heading = 15,
			minZ = 36.94,
			maxZ = 40.94,
			restricted = false,
		},
		{ -- Palomino FWay Fuel Station
			center = vector3(2580.8, 360.99, 108.46),
			length = 26.0,
			width = 16.2,
			heading = 85,
			minZ = 107.06,
			maxZ = 115.86,
			restricted = false,
		},

		{ -- Alamo Sea Pier Fuel Station
			center = vector3(1320.76, 4215.71, 31.97),
			length = 20.2,
			width = 32.2,
			heading = 350,
			minZ = 26.17,
			maxZ = 34.77,
			restricted = 'boat',
		},

		{ -- Zancudo Aircraft Fuel Station
			center = vector3(-2185.23, 3172.5, 32.81),
			length = 23.0,
			width = 25.4,
			heading = 330,
			minZ = 31.81,
			maxZ = 35.81,
			restricted = 'aircraft',
		},
		{ -- Zancudo Aircraft Fuel Station
			center = vector3(-2185.23, 3172.5, 32.81),
			length = 36.0,
			width = 24.2,
			heading = 60,
			minZ = 31.81,
			maxZ = 35.81,
			restricted = 'aircraft',
		},

		{ -- Paleto PD Helipad
			center = vector3(-475.1, 5988.99, 31.34),
			length = 20.8,
			width = 24.6,
			heading = 315,
			minZ = 30.34,
			maxZ = 34.34,
			restricted = 'aircraft',
		},
		{ -- Vinewood PD Helipad
			center = vector3(580.26, 11.59, 103.23),
			length = 15.0,
			width = 15.0,
			heading = 0,
			minZ = 102.0,
			maxZ = 108.4,
			restricted = 'aircraft',
		},
		{ -- Vespucci PD Helipad
			center = vector3(-1095.43, -835.56, 37.67),
			length = 15.0,
			width = 15.0,
			heading = 305,
			minZ = 36.67,
			maxZ = 40.67,
			restricted = 'aircraft',
		},
		{ -- Mission Row PD Helipad
			center = vector3(449.27, -981.0, 43.69),
			length = 12.4,
			width = 12.8,
			heading = 0,
			minZ = 42.69,
			maxZ = 46.69,
			restricted = 'aircraft',
		},

		{ -- Pillbox Helipad
			center = vector3(352.65, -589.56, 74.16),
			length = 20.0,
			width = 20.0,
			heading = 340,
			minZ = 73.16,
			maxZ = 77.16,
			restricted = 'aircraft',
		},
		{ -- Mt Zonah Helipad
			center = vector3(-456.3, -291.8, 78.17),
			length = 13.0,
			width = 13.8,
			heading = 23,
			minZ = 77.17,
			maxZ = 82.17,
			restricted = 'aircraft',
		},
		{
			center = vector3(-1799.75, 803.02, 138.51),
			length = 14.4,
			width = 27.0,
			heading = 40,
			minZ = 137.51,
			maxZ = 141.51,
			restricted = false,
		},
		{
			center = vector3(-319.94, -1471.15, 30.55),
			length = 20.4,
			width = 27.8,
			heading = 30,
			--debugPoly=true,
			minZ = 29.55,
			maxZ = 36.15,
			restricted = false,
		},
		{ -- Ottos Autos
			center = vector3(810.14, -790.0, 26.19),
			length = 9.6,
			width = 12.4,
			heading = 0,
			--debugPoly=true,
			minZ = 25.19,
			maxZ = 33.59,
			restricted = false,
		},
	}
}