AddEventHandler("Businesses:Server:Startup", function()
	Inventory.Poly:Create({
		id = "avast_arcade_safe",
		type = "box",
		coords = vector3(-1648.3, -1072.7, 13.76),
		width = 1.0,
		length = 0.6,
		options = {
			heading = 320,
			--debugPoly=true,
			minZ = 11.96,
			maxZ = 14.56,
		},
		data = {
			business = "avast_arcade",
            inventory = {
                invType = 54,
                owner = "avast-arcade-safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "pizza_this_safe",
		type = "box",
		coords = vector3(796.54, -749.24, 31.27),
		width = 1.0,
		length = 0.6,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 29.47,
			maxZ = 32.07,
		},
		data = {
			business = "pizza_this",
			inventory = {
				invType = 53,
				owner = "pizza-this-safe",
			},
		},
	})

	Inventory.Poly:Create({
		id = "sterling_construction_safe",
		type = "box",
		coords = vector3(2474.25, 4111.19, 41.24),
		width = 1.0,
		length = 0.6,
		options = {
			heading = 355,
			--debugPoly=true,
			minZ = 39.44,
			maxZ = 42.04,
		},
		data = {
			business = "sterling_construction",
            inventory = {
                invType = 52,
                owner = "sterling-construction-safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "sterling_construction_storage",
		type = "box",
		coords = vector3(2467.2, 4090.4, 34.83),
		width = 2.0,
		length = 2.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 33.83,
			maxZ = 36.83,
		},
		data = {
			business = "sterling_construction",
            inventory = {
                invType = 63,
                owner = "sterling-construction-storage",
            },
		},
	})

	Inventory.Poly:Create({
		id = "redline_safe",
		type = "box",
		coords = vector3(-595.65, -914.12, 28.14),
		width = 1.0,
		length = 0.6,
		options = {
			heading = 1,
			--debugPoly=true,
			minZ = 26.34,
			maxZ = 28.94,
		},
		data = {
			business = "redline",
            inventory = {
                invType = 51,
                owner = "redline-safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "redline_safe2",
		type = "box",
		coords = vector3(-580.84, -928.21, 23.89),
		width = 2.2,
		length = 2.2,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 22.89,
			maxZ = 25.09,
		},
		data = {
			business = "redline",
            inventory = {
                invType = 51,
                owner = "redline-safe2",
            },
		},
	})

	Inventory.Poly:Create({
		id = "blackline_storage",
		type = "box",
		coords = vector3(994.78, -1489.84, 31.5),
		width = 3.2,
		length = 3.2,
		options = {
			heading = 270,
			--debugPoly=true,
			minZ = 30.5,
			maxZ = 33.1,
		},
		data = {
			business = "blackline",
            inventory = {
                invType = 64,
                owner = "blackline-storage",
            },
		},
	})

	Inventory.Poly:Create({
		id = "uwu_safe",
		type = "box",
		coords = vector3(-597.39, -1049.57, 22.34),
		width = 1.0,
		length = 1.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 21.34,
			maxZ = 23.94
		},
		data = {
			business = "uwu",
            inventory = {
                invType = 55,
                owner = "uwu-safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "uwu_warehouse_storage",
		type = "box",
		coords = vector3(-598.09, -1065.24, 22.34),
		width = 7.6,
		length = 5.2,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 21.34,
			maxZ = 24.74,
		},
		data = {
			business = "uwu",
            inventory = {
                invType = 69,
                owner = "uwu_warehouse_storage",
            },
		},
	})

	Inventory.Poly:Create({
		id = "pdm_safe",
		type = "box",
		coords = vector3(-23.87, -1102.85, 27.27),
		width = 2.2,
		length = 1.0,
		options = {
			heading = 340,
			--debugPoly=true,
			minZ = 26.27,
			maxZ = 28.27,
		},
		data = {
			business = "pdm",
            inventory = {
                invType = 56,
                owner = "pdm-safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "tuna_safe",
		type = "box",
		coords = vector3(146.27, -3007.82, 7.04),
		length = 2.0,
		width = 2.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 6.04,
			maxZ = 8.04,
		},
		data = {
			business = "tuna",
            inventory = {
                invType = 65,
                owner = "tuna-safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "tuna_safe_2",
		type = "box",
		coords = vector3(145.68, -3011.15, 7.04),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 6.04,
			maxZ = 8.24
		},
		data = {
			business = "tuna",
            inventory = {
                invType = 65,
                owner = "tuna-safe_2",
            },
		},
	})

	Inventory.Poly:Create({
		id = "triad_safe",
		type = "box",
		coords = vector3(-816.53, -696.26, 32.14),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 30.94,
			maxZ = 33.34,
		},
		data = {
			business = "triad",
            inventory = {
                invType = 66,
                owner = "triad-safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "bobs_safe",
		type = "box",
		coords = vector3(757.46, -775.95, 26.34),
		length = 0.8,
		width = 0.8,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 25.34,
			maxZ = 27.14,
		},
		data = {
			business = "bobs",
            inventory = {
                invType = 67,
                owner = "bobs-safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dmansion_safe_1",
		type = "box",
		coords = vector3(-2579.55, 1884.19, 163.79),
		length = 1.4,
		width = 3.6,
		options = {
			heading = 310,
			--debugPoly=true,
			minZ = 162.79,
			maxZ = 165.39,
		},
		data = {
			business = "dgang",
            inventory = {
                invType = 70,
                owner = "dmansion_safe_1",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dmansion_safe_2",
		type = "box",
		coords = vector3(-2598.18, 1888.33, 163.75),
		length = 1.6,
		width = 2.4,
		options = {
			heading = 220,
			--debugPoly=true,
			minZ = 162.75,
			maxZ = 165.35,
		},
		data = {
			business = "dgang",
            inventory = {
                invType = 70,
                owner = "dmansion_safe_2",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dmansion_safe_3",
		type = "box",
		coords = vector3(-2604.13, 1923.33, 167.3),
		length = 1.6,
		width = 2.4,
		options = {
			heading = 95,
			--debugPoly=true,
			minZ = 166.3,
			maxZ = 168.9,
		},
		data = {
			business = "dgang",
            inventory = {
                invType = 70,
                owner = "dmansion_safe_3",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dmansion_safe_4",
		type = "box",
		coords = vector3(-2601.2, 1875.18, 163.79),
		length = 5.0,
		width = 1.2,
		options = {
			heading = 40,
			--debugPoly=true,
			minZ = 162.79,
			maxZ = 165.19,
		},
		data = {
			business = "dgang",
            inventory = {
                invType = 70,
                owner = "dmansion_safe_4",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dmansion_safe_5",
		type = "box",
		coords = vector3(-2588.94, 1893.82, 163.72),
		length = 3.0,
		width = 2.0,
		options = {
			heading = 310,
			--debugPoly=true,
			minZ = 162.72,
			maxZ = 165.32,
		},
		data = {
			business = "dgang",
            inventory = {
                invType = 70,
                owner = "dmansion_safe_5",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dmansion_safe_6",
		type = "box",
		coords = vector3(-2590.74, 1911.72, 167.3),
		length = 2.0,
		width = 1.8,
		options = {
			heading = 7,
			--debugPoly=true,
			minZ = 166.3,
			maxZ = 168.9,
		},
		data = {
			business = "dgang",
            inventory = {
                invType = 70,
                owner = "dmansion_safe_6",
            },
		},
	})

	Inventory.Poly:Create({
		id = "hayes_safe",
		type = "box",
		coords = vector3(-1428.22, -459.8, 35.91),
		length = 1.2,
		width = 1.6,
		options = {
			heading = 300,
			--debugPoly=true,
			minZ = 34.91,
			maxZ = 37.11,
		},
		data = {
			business = "hayes",
            inventory = {
                invType = 75,
                owner = "hayes_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "unicorn_safe",
		type = "box",
		coords = vector3(93.78, -1290.6, 29.26),
		length = 1.4,
		width = 1.0,
		options = {
			heading = 30,
			--debugPoly=true,
			minZ = 28.26,
			maxZ = 29.86,
		},
		data = {
			business = "unicorn",
            inventory = {
                invType = 85,
                owner = "unicorn_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dynasty8_safe",
		type = "box",
		coords = vector3(-717.92, 259.94, 84.14),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 25,
			--debugPoly=true,
			minZ = 83.14,
			maxZ = 85.54,
		},
		data = {
			business = "dynasty8",
            inventory = {
                invType = 86,
                owner = "dynasty8_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "nutz_safe",
		type = "box",
		coords = vector3(-69.95, -1327.76, 29.27),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 28.27,
			maxZ = 30.27,
		},
		data = {
			business = "tirenutz",
            inventory = {
                invType = 93,
                owner = "nutz_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "weed_storage",
		type = "box",
		coords = vector3(-1162.64, -1572.16, 4.66),
		length = 3.2,
		width = 3.2,
		options = {
			heading = 305,
			--debugPoly=true,
			minZ = 3.66,
			maxZ = 6.06,
		},
		data = {
			business = "weed",
            inventory = {
                invType = 94,
                owner = "weed_storage",
            },
		},
	})

	Inventory.Poly:Create({
		id = "weed_safe",
		type = "box",
		coords = vector3(-1166.66, -1567.7, 4.66),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 310,
			--debugPoly=true,
			minZ = 3.66,
			maxZ = 5.86,
		},
		data = {
			business = "weed",
            inventory = {
                invType = 95,
                owner = "weed_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "tequila_safe",
		type = "box",
		coords = vector3(-571.53, 289.01, 79.18),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 355,
			--debugPoly=true,
			minZ = 78.18,
			maxZ = 80.38,
		},
		data = {
			business = "tequila",
            inventory = {
                invType = 97,
                owner = "tequila_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "digitalden_safe",
		type = "box",
		coords = vector3(380.74, -824.81, 29.3),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 28.3,
			maxZ = 30.9,
		},
		data = {
			business = "digitalden",
            inventory = {
                invType = 102,
                owner = "digitalden_safe",
            },
		},
	})

    Inventory.Poly:Create({
		id = "superperformance_safe",
		type = "box",
		coords = vector3(268.22, -1786.8, 31.27),
		length = 1.0,
		width = 1.0,
		options = {
            heading = 50,
            --debugPoly=true,
            minZ = 30.27,
            maxZ = 33.07
		},
		data = {
			business = "superperformance",
            inventory = {
                invType = 104,
                owner = "superperformance_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "noodle_safe",
		type = "box",
		coords = vector3(-1184.16, -1149.45, 7.67),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 15,
			--debugPoly=true,
			minZ = 6.67,
			maxZ = 9.07
		},
		data = {
			business = "noodle",
            inventory = {
                invType = 105,
                owner = "noodle_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "autoexotics_safe",
		type = "box",
		coords = vector3(542.49, -199.13, 54.49),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 53.49,
			maxZ = 55.89
		},
		data = {
			business = "autoexotics",
            inventory = {
                invType = 108,
                owner = "autoexotics_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "rockford_records_safe",
		type = "box",
		coords = vector3(-1007.72, -262.54, 44.8),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 325,
			--debugPoly=true,
			minZ = 43.8,
			maxZ = 47.8
		},
		data = {
			business = "rockford_records",
            inventory = {
                invType = 111,
                owner = "rockford_records_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "securoserv_safe",
		type = "box",
		coords = vector3(31.14, -119.98, 56.22),
		length = 0.8,
		width = 1.0,
		options = {
			heading = 340,
			--debugPoly=true,
			minZ = 55.22,
			maxZ = 57.22
		},
		data = {
			business = "securoserv",
            inventory = {
                invType = 114,
                owner = "securoserv_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "ferrari_pawn_safe",
		type = "box",
		coords = vector3(167.15, -1313.47, 29.36),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 333,
			--debugPoly=true,
			minZ = 28.36,
			maxZ = 30.36
		},
		data = {
			business = "ferrari_pawn",
            inventory = {
                invType = 118,
                owner = "ferrari_pawn_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "ottos_autos_safe",
		type = "box",
		coords = vector3(836.23, -829.15, 26.33),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 25.33,
			maxZ = 27.73
		},
		data = {
			business = "ottos",
            inventory = {
                invType = 121,
                owner = "ottos_autos_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "ottos_autos_safe2",
		type = "box",
		coords = vector3(830.94, -823.65, 26.33),
		length = 1.0,
		width = 1.0,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 25.33,
			maxZ = 27.53
		},
		data = {
			business = "ottos",
            inventory = {
                invType = 121,
                owner = "ottos_autos_safe2",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dreamworks_safe",
		type = "box",
		coords = vector3(-700.44, -1399.22, 8.55),
		length = 1.4,
		width = 1.0,
		options = {
			heading = 50,
			--debugPoly=true,
			minZ = 7.55,
			maxZ = 9.95
		},
		data = {
			business = "dreamworks",
            inventory = {
                invType = 124,
                owner = "dreamworks_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "dreamworks_safe2",
		type = "box",
		coords = vector3(-742.05, -1526.34, 5.06),
		length = 1.5,
		width = 1.5,
		options = {
			heading = 24,
			--debugPoly=true,
			minZ = 4.06,
			maxZ = 6.06
		},
		data = {
			business = "dreamworks",
            inventory = {
                invType = 124,
                owner = "dreamworks_safe2",
			}
		}
	})

	Inventory.Poly:Create({
		id = "casino_safe",
		type = "box",
		coords = vector3(978.63, 50.69, 116.17),
		length = 1.0,
		width = 2.6,
		options = {
			heading = 328,
			--debugPoly=true,
			minZ = 115.17,
			maxZ = 118.17
		},
		data = {
			business = "casino",
            inventory = {
                invType = 127,
                owner = "casino_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "casino_safe2",
		type = "box",
		coords = vector3(1000.85, 52.78, 75.06),
		length = 2.0,
		width = 2.0,
		options = {
			heading = 330,
			--debugPoly=true,
			minZ = 74.06,
			maxZ = 76.46
		},
		data = {
			business = "casino",
            inventory = {
                invType = 127,
                owner = "casino_safe2",
            },
		},
	})

	Inventory.Poly:Create({
		id = "prego_safe",
		type = "box",
		coords = vector3(-1123.2, -1460.47, 5.11),
		length = 2.2,
		width = 2.0,
		options = {
			heading = 35,
			--debugPoly=true,
			minZ = 4.11,
			maxZ = 5.91
		},
		data = {
			business = "prego",
            inventory = {
                invType = 131,
                owner = "prego_safe",
            },
		},
	})

	Inventory.Poly:Create({
		id = "triad_boxing_storage",
		type = "box",
		coords = vector3(1073.0, -2399.06, 25.9),
		length = 1.4,
		width = 1.2,
		options = {
			heading = 0,
			--debugPoly=true,
			minZ = 24.9,
			maxZ = 26.9
		},
		data = {
			business = "triad_boxing",
            inventory = {
                invType = 137,
                owner = "triad_boxing_storage",
            },
		},
	})
end)
