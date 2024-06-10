_entityTypes = {
	{
		id = 1,
		slots = 28,
		capacity = 200,
		name = "Personal Storage",
	},
	{
		id = 2,
		slots = 500,
		capacity = 2000,
		name = "Player Holding",
	},
	{
		id = 3,
		slots = 8,
		capacity = 150,
		name = "Secured Compartment",
		restriction = {
			job = {
				id = "police",
				duty = true,
			},
		},
	},
	{
		id = 4,
		slots = 20,
		capacity = 200,
		name = "Trunk",
		isVehicle = true,
		isTrunk = true,
	},
	{
		id = 5,
		slots = 4,
		capacity = 200,
		name = "Glovebox",
		isVehicle = true,
		isGlovebox = true,
	},
	{
		id = 6,
		slots = 40,
		capacity = 200,
		shop = true,
		itemSet = 18,
		name = "Liquor Store",
	},
	{
		id = 7,
		slots = 40,
		capacity = 200,
		shop = true,
		itemSet = 2,
		name = "Hardware Store",
	},
	{
		id = 8,
		slots = 30,
		capacity = 10000,
		name = "Police Evidence",
		restriction = {
			job = {
				id = "police",
				duty = true,
			},
		},
	},
	{
		id = 9,
		slots = 500,
		capacity = 200,
		name = "Police Trash",
		restriction = {
			job = {
				id = "police",
				duty = true,
			},
		},
	},
	{
		id = 10,
		slots = 40,
		capacity = 1000,
		name = "Dropzone",
	},
	{
		id = 11,
		slots = 40,
		capacity = 200,
		shop = true,
		itemSet = 1,
		name = "Shop",
	},
	{
		id = 12,
		slots = 40,
		capacity = 200,
		shop = true,
		itemSet = 4,
		name = "Ammunation",
	},
	{
		id = 13,
		slots = 20,
		capacity = 400,
		name = "Apartment Storage Tier 1",
	},
	{
		id = 14,
		slots = 24,
		capacity = 450,
		name = "Apartment Storage Tier 2",
	},
	{
		id = 15,
		slots = 28,
		capacity = 500,
		name = "Apartment Storage Tier 3",
	},
	{
		id = 16,
		slots = 50,
		capacity = 200,
		name = "Trash Container",
	},
	{
		id = 17,
		slots = 400,
		capacity = 200,
		name = "Shipping Container",
	},
	{
		id = 18,
		slots = 800,
		capacity = 200,
		name = "Warehouse",
	},
	{
		id = 19,
		slots = 4,
		capacity = 8,
		name = "Drinks Holder",
	},
	{
		id = 20,
		slots = 8,
		capacity = 10,
		name = "Small Food Bag",
	},
	{
		id = 21,
		slots = 8,
		capacity = 15,
		name = "Food Bag",
	},
	{
		id = 22,
		slots = 16,
		capacity = 50,
		name = "Box",
	},
	{
		id = 23,
		slots = 152,
		capacity = 2000,
		name = "Burger Shot Freezer",
		restriction = {
			job = {
				id = "burgershot",
			},
		},
	},
	{
		id = 24,
		slots = 52,
		capacity = 500,
		name = "Burger Shot Food Warmer",
		restriction = {
			job = {
				id = "burgershot",
			},
		},
	},
	{
		id = 25,
		slots = 8,
		capacity = 100,
		name = "Order Pick Up",
	},
	{
		id = 26,
		slots = 32,
		capacity = 200,
		name = "Medical Supply",
		shop = true,
		free = true,
		itemSet = 7,
		restriction = {
			job = {
				id = "ems",
				duty = true,
			},
		},
	},
	{
		id = 27,
		slots = 32,
		capacity = 200,
		name = "PD Armory",
		shop = true,
		free = true,
		itemSet = 6,
		restriction = {
			job = {
				id = "police",
				duty = true,
			},
		},
	},
	{
		id = 28,
		slots = 16,
		capacity = 100,
		name = "Hunting Supplies",
		shop = true,
		itemSet = 8,
	},
	{
		id = 29,
		slots = 2,
		capacity = 10,
		name = "Hidden Compartment",
		isVehicle = true,
	},
	{
		id = 30,
		slots = 48,
		capacity = 300,
		name = "Last Train Food Warmer",
		restriction = {
			job = {
				id = "lasttrain",
			},
		},
	},
	{
		id = 31,
		slots = 160,
		capacity = 3500,
		name = "Last Train Cold Storage",
		restriction = {
			job = {
				id = "lasttrain",
			},
		},
	},

	{
		id = 32,
		slots = 120,
		capacity = 8000,
		name = "Redline Part Storage",
		restriction = {
			job = {
				id = "redline",
			},
		},
	},
	{
		id = 33,
		slots = 60,
		capacity = 600,
		name = "Mirror Autos Part Storage",
		restriction = {
			job = {
				id = "mirror_autos",
			},
		},
	},
	{
		id = 34,
		slots = 60,
		capacity = 600,
		name = "Hayes Part Storage",
		restriction = {
			job = {
				id = "hayes_autos",
			},
		},
	},
	{
		id = 35,
		slots = 60,
		capacity = 600,
		name = "Harmony Part Storage",
		restriction = {
			job = {
				id = "harmony_repairs",
			},
		},
	},
	{
		id = 36,
		slots = 60,
		capacity = 600,
		name = "Paleto Garage Part Storage",
		restriction = {
			job = {
				id = "paleto_garage",
			},
		},
	},

	{
		id = 47,
		slots = 60,
		capacity = 4000,
		name = "Redline Mini Storage",
		restriction = {
			job = {
				id = "redline",
			},
		},
	},
	{
		id = 37,
		slots = 32,
		capacity = 200,
		name = "DOC Armory",
		shop = true,
		free = true,
		itemSet = 9,
		restriction = {
			job = {
				id = "prison",
				duty = true,
				workplace = "corrections",
			},
		},
	},
	{
		id = 38,
		slots = 8,
		capacity = 200,
		name = "Vending",
		shop = true,
		itemSet = 10,
	},
	{
		id = 39,
		slots = 8,
		capacity = 200,
		name = "Vending",
		shop = true,
		itemSet = 11,
	},
	{ -- Drinks
		id = 40,
		slots = 8,
		capacity = 200,
		name = "Vending",
		shop = true,
		itemSet = 12,
	},
	{ -- Food
		id = 41,
		slots = 8,
		capacity = 200,
		name = "Vending",
		shop = true,
		itemSet = 13,
	},
	{ -- Pharmacy
		id = 42,
		slots = 32,
		capacity = 200,
		name = "Pharmacy",
		shop = true,
		itemSet = 14,
	},
	{ -- Fuel Pump
		id = 43,
		slots = 8,
		capacity = 200,
		name = "Fuel Stations",
		shop = true,
		itemSet = 15,
	},
	{
		id = 44,
		slots = 120,
		capacity = 5000,
		name = "PD Evidence Locker",
	},
	{
		id = 45,
		slots = 24,
		capacity = 200,
		name = "Personal Government Locker",
	},
	{
		id = 46,
		slots = 60,
		capacity = 400,
		name = "DOJ Safe",
		restriction = {
			job = {
				id = "government",
				workplace = "doj",
				grade = "sjudge",
			},
		},
	},

	{
		id = 49,
		slots = 60,
		capacity = 3000,
		name = "Tuner Part Storage",
		restriction = {
			job = {
				id = "tuna",
			},
		},
	},

	{
		id = 50,
		slots = 30,
		capacity = 300,
		name = "Tuner Mini Storage",
		restriction = {
			job = {
				id = "tuna",
			},
		},
	},

	{
		id = 51,
		slots = 52,
		capacity = 300,
		name = "Redline Safe",
		restriction = {
			job = {
				id = "redline",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 52,
		slots = 52,
		capacity = 300,
		name = "Sterling Construction Safe",
		restriction = {
			job = {
				id = "sterling_construction",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 53,
		slots = 52,
		capacity = 300,
		name = "Pizza This Safe",
		restriction = {
			job = {
				id = "pizza_this",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 54,
		slots = 52,
		capacity = 300,
		name = "Avast Arcade Safe",
		restriction = {
			job = {
				id = "avast_arcade",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 55,
		slots = 52,
		capacity = 300,
		name = "UwU Cafe Safe",
		restriction = {
			job = {
				id = "uwu",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 56,
		slots = 52,
		capacity = 300,
		name = "PDM Safe",
		restriction = {
			job = {
				id = "pdm",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 57,
		slots = 108,
		capacity = 2000,
		name = "UwU Cafe Freezer",
		restriction = {
			job = {
				id = "uwu",
			},
		},
	},

	{
		id = 58,
		slots = 16,
		capacity = 200,
		name = "UwU Cafe",
		restriction = {
			job = {
				id = "uwu",
			},
		},
	},

	{
		id = 59,
		slots = 96,
		capacity = 2000,
		name = "Pizza This Freezer",
		restriction = {
			job = {
				id = "pizza_this",
			},
		},
	},

	{
		id = 60,
		slots = 32,
		capacity = 600,
		name = "Pizza This",
		restriction = {
			job = {
				id = "pizza_this",
			},
		},
	},

	{
		id = 61,
		slots = 40,
		capacity = 1000,
		shop = true,
		itemSet = 16,
		name = "Food Wholesaler",
		restriction = {
			job = {
				id = false,
				permissionKey = "JOB_USE_WHOLESALER",
			},
		},
	},

	{
		id = 62,
		slots = 4,
		capacity = 1000,
		shop = true,
		itemSet = 17,
		name = "Smoke on the Water",
	},
	{
		id = 63,
		slots = 64,
		capacity = 3000,
		name = "Sterling Construction",
		restriction = {
			job = {
				id = "sterling_construction",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 64,
		slots = 64,
		capacity = 3000,
		name = "Blackline",
		restriction = {
			job = {
				id = "blackline",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 65,
		slots = 52,
		capacity = 600,
		name = "Tuna Safe",
		restriction = {
			job = {
				id = "tuna",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 66,
		slots = 52,
		capacity = 600,
		name = "Triad Safe",
		restriction = {
			job = {
				id = "triad",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 67,
		slots = 52,
		capacity = 600,
		name = "Bowling Safe",
		restriction = {
			job = {
				id = "bowling",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 68,
		slots = 60,
		capacity = 500,
		name = "Bobs Balls Fridge",
		restriction = {
			job = {
				id = "bowling",
			},
		},
	},

	{
		id = 69,
		slots = 140,
		capacity = 3000,
		name = "UwU Cafe Storage",
		restriction = {
			job = {
				id = "uwu",
			},
		},
	},

	{
		id = 70,
		slots = 80,
		capacity = 1200,
		name = "2 Buen Vino Rd Storage",
		restriction = {
			job = {
				id = "dgang",
			},
		},
	},

	{
		id = 71,
		slots = 164,
		capacity = 4000,
		name = "Tire Nutz Part Storage",
		restriction = {
			job = {
				id = "tirenutz",
			},
		},
	},
	{
		id = 72,
		slots = 164,
		capacity = 4000,
		name = "Hayes Part Storage",
		restriction = {
			job = {
				id = "hayes",
			},
		},
	},
	{
		id = 73,
		slots = 100,
		capacity = 2000,
		name = "Atomic Part Storage",
		restriction = {
			job = {
				id = "atomic",
			},
		},
	},
	{
		id = 74,
		slots = 16,
		capacity = 1000,
		shop = true,
		itemSet = 5,
		name = "Digital Den",
	},

	{
		id = 75,
		slots = 52,
		capacity = 600,
		name = "Hayes Safe",
		restriction = {
			job = {
				id = "hayes",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 76,
		slots = 4,
		capacity = 200,
		shop = true,
		itemSet = 19,
		name = "Winery",
	},

	{
		id = 77,
		slots = 40,
		capacity = 150,
		name = "Pizza This Wine Cellar",
		restriction = {
			job = {
				id = "pizza_this",
			},
		},
	},

	{
		id = 78,
		slots = 80,
		capacity = 1000,
		name = "Avast Arcade Fridge",
		restriction = {
			job = {
				id = "avast_arcade",
			},
		},
	},

	{
		id = 79,
		slots = 140,
		capacity = 2000,
		name = "Bean Machine",
		restriction = {
			job = {
				id = "beanmachine",
			},
		},
	},
	{
		id = 80,
		slots = 140,
		capacity = 2000,
		name = "Bean Machine",
		restriction = {
			job = {
				id = "beanmachine",
			},
		},
	},

	{
		id = 81,
		slots = 164,
		capacity = 1500,
		name = "Tequi-la-la Storage",
		restriction = {
			job = {
				id = "tequila",
			},
		},
	},
	{
		id = 82,
		slots = 64,
		capacity = 800,
		name = "Tequi-la-la Fridge",
		restriction = {
			job = {
				id = "tequila",
			},
		},
	},

	{
		id = 83,
		slots = 164,
		capacity = 5000,
		name = "Vanilla Unicorn Storage",
		restriction = {
			job = {
				id = "unicorn",
			},
		},
	},
	{
		id = 84,
		slots = 64,
		capacity = 800,
		name = "Vanilla Unicorn Fridge",
		restriction = {
			job = {
				id = "unicorn",
			},
		},
	},
	{
		id = 85,
		slots = 60,
		capacity = 1200,
		name = "VU Safe",
		restriction = {
			job = {
				id = "unicorn",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 86,
		slots = 52,
		capacity = 600,
		name = "Dynasty8 Safe",
		restriction = {
			job = {
				id = "realestate",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 87,
		slots = 140,
		capacity = 2000,
		name = "Bakery Storage",
		restriction = {
			job = {
				id = "bakery",
			},
		},
	},
	{
		id = 88,
		slots = 32,
		capacity = 600,
		name = "Bakery",
		restriction = {
			job = {
				id = "bakery",
			},
		},
	},

	{
		id = 89,
		slots = 140,
		capacity = 4000,
		name = "Noodle Exchange Freezer",
		restriction = {
			job = {
				id = "noodle",
			},
		},
	},

	{
		id = 90,
		slots = 32,
		capacity = 600,
		name = "Noodle Exchange",
		restriction = {
			job = {
				id = "noodle",
			},
		},
	},

	{
		id = 91,
		slots = 200,
		capacity = 2,
		name = "Card Holder",
	},

	{
		id = 92,
		slots = 164,
		capacity = 4000,
		name = "Harmony Part Storage",
		restriction = {
			job = {
				id = "harmony",
			},
		},
	},

	{
		id = 93,
		slots = 52,
		capacity = 600,
		name = "Nutz Safe",
		restriction = {
			job = {
				id = "tirenutz",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 94,
		slots = 164,
		capacity = 4000,
		name = "Smoke on the Water",
		restriction = {
			job = {
				id = "weed",
			},
		},
	},
	{
		id = 95,
		slots = 52,
		capacity = 600,
		name = "Smoke on the Water Safe",
		restriction = {
			job = {
				id = "weed",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 96,
		slots = 64,
		capacity = 800,
		name = "Triad Fridge",
		restriction = {
			job = {
				id = "triad",
			},
		},
	},
	{
		id = 97,
		slots = 52,
		capacity = 300,
		name = "Tequi-la-la Safe",
		restriction = {
			job = {
				id = "tequila",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 98,
		slots = 164,
		capacity = 4000,
		name = "Traid Records Storage",
		restriction = {
			job = {
				id = "triad",
			},
		},
	},

	{
		id = 100,
		slots = 48,
		capacity = 1500,
		name = "Digital Den Small Storage",
		restriction = {
			job = {
				id = "digitalden",
			},
		},
	},
	{
		id = 101,
		slots = 80,
		capacity = 3000,
		name = "Digital Den Storage",
		restriction = {
			job = {
				id = "digitalden",
			},
		},
	},
	{
		id = 102,
		slots = 52,
		capacity = 300,
		name = "Digital Den Safe",
		restriction = {
			job = {
				id = "digitalden",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 103,
		slots = 164,
		capacity = 4000,
		name = "Super Performance Part Storage",
		restriction = {
			job = {
				id = "superperformance",
			},
		},
	},
	{
		id = 104,
		slots = 52,
		capacity = 300,
		name = "Super Performance Safe",
		restriction = {
			job = {
				id = "superperformance",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 105,
		slots = 52,
		capacity = 300,
		name = "Noodle Exchange Safe",
		restriction = {
			job = {
				id = "noodle",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 106,
		slots = 156,
		capacity = 8000,
		name = "Auto Exotics Part Storage",
		restriction = {
			job = {
				id = "autoexotics",
			},
		},
	},
	{
		id = 107,
		slots = 100,
		capacity = 4000,
		name = "Auto Exotics Mini Storage",
		restriction = {
			job = {
				id = "autoexotics",
			},
		},
	},
	{
		id = 108,
		slots = 52,
		capacity = 600,
		name = "Auto Exotics Safe",
		restriction = {
			job = {
				id = "autoexotics",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 109,
		slots = 164,
		capacity = 4000,
		name = "Rockford Records Storage",
		restriction = {
			job = {
				id = "rockford_records",
			},
		},
	},

	{
		id = 110,
		slots = 64,
		capacity = 800,
		name = "Rockford Records Fridge",
		restriction = {
			job = {
				id = "rockford_records",
			},
		},
	},

	{
		id = 111,
		slots = 52,
		capacity = 300,
		name = "Rockford Records Safe",
		restriction = {
			job = {
				id = "rockford_records",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 99,
		slots = 16,
		capacity = 100,
		name = "Fishing Supplies",
		shop = true,
		itemSet = 20,
	},
	{ -- Advanced Fishing Supplies
		id = 112,
		slots = 16,
		capacity = 100,
		name = "Reputation Level 3+",
		shop = true,
		itemSet = 21,
		restriction = {
			rep = {
				id = "Fishing",
				level = 3,
			}
		},
	},

	{
		id = 113,
		slots = 80,
		capacity = 3000,
		name = "Gruppe 6 Storage",
		restriction = {
			job = {
				id = "securoserv",
			},
		},
	},
	{
		id = 114,
		slots = 52,
		capacity = 300,
		name = "Gruppe 6 Safe",
		restriction = {
			job = {
				id = "securoserv",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 115,
		slots = 16,
		capacity = 100,
		name = "DOJ Shop",
		shop = true,
		itemSet = 22,
		restriction = {
			job = {
				id = "government",
				workplace = "doj",
			},
		},
	},
	{
		id = 116,
		slots = 80,
		capacity = 3000,
		name = "DOJ Storage",
		restriction = {
			job = {
				id = "government",
				workplace = "doj",
			},
		},
	},

	{
		id = 117,
		slots = 100,
		capacity = 8000,
		name = "Ferrari Pawn Storage",
		restriction = {
			job = {
				id = "ferrari_pawn",
			},
		},
	},
	{
		id = 118,
		slots = 52,
		capacity = 300,
		name = "Ferrari Pawn Safe",
		restriction = {
			job = {
				id = "ferrari_pawn",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	
	{
		id = 119,
		slots = 120,
		capacity = 8000,
		name = "Otto's Part Storage",
		restriction = {
			job = {
				id = "ottos",
			},
		},
	},
	{
		id = 120,
		slots = 60,
		capacity = 4000,
		name = "Otto's Mini Storage",
		restriction = {
			job = {
				id = "ottos",
			},
		},
	},
	{
		id = 121,
		slots = 52,
		capacity = 300,
		name = "Otto's Safe",
		restriction = {
			job = {
				id = "ottos",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 122,
		slots = 120,
		capacity = 8000,
		name = "Dreamworks Part Storage",
		restriction = {
			job = {
				id = "dreamworks",
			},
		},
	},
	{
		id = 123,
		slots = 60,
		capacity = 4000,
		name = "Dreamworks Mini Storage",
		restriction = {
			job = {
				id = "dreamworks",
			},
		},
	},
	{
		id = 124,
		slots = 52,
		capacity = 300,
		name = "Dreamworks Safe",
		restriction = {
			job = {
				id = "dreamworks",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 125,
		slots = 164,
		capacity = 2500,
		name = "Casino Storage",
		restriction = {
			job = {
				id = "casino",
			},
		},
	},
	{
		id = 126,
		slots = 100,
		capacity = 1000,
		name = "Casino Fridge",
		restriction = {
			job = {
				id = "casino",
			},
		},
	},
	{
		id = 127,
		slots = 52,
		capacity = 300,
		name = "Casino Safe",
		restriction = {
			job = {
				id = "casino",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 128,
		slots = 124,
		capacity = 3000,
		name = "Cafe Prego Freezer",
		restriction = {
			job = {
				id = "prego",
			},
		},
	},

	{
		id = 129,
		slots = 64,
		capacity = 1000,
		name = "Cafe Prego",
		restriction = {
			job = {
				id = "prego",
			},
		},
	},

	{
		id = 130,
		slots = 40,
		capacity = 250,
		name = "Cafe Prego Wine Cellar",
		restriction = {
			job = {
				id = "prego",
			},
		},
	},

	{
		id = 131,
		slots = 52,
		capacity = 300,
		name = "Cafe Prego Safe",
		restriction = {
			job = {
				id = "prego",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},

	{
		id = 132,
		slots = 1,
		capacity = 25,
		name = "Gallery Gem Table",
		restriction = {
			job = {
				id = "sagma",
				permissionKey = "JOB_USE_GEM_TABLE",
			},
		},
		action = {
			icon = "gem",
			text = "Inspect",
			event = "Businesses:Server:SAGMA:ViewGem",
		}
	},

	{
		id = 133,
		slots = 116,
		capacity = 300,
		name = "SAGMA Safe",
		restriction = {
			job = {
				id = "sagma",
				permissionKey = "JOB_ACCESS_SAFE",
			},
		},
	},
	{
		id = 134,
		slots = 140,
		capacity = 4000,
		name = "Gallery Office Storage",
		restriction = {
			job = {
				id = "sagma",
			},
		},
	},
	{
		id = 135,
		slots = 1000,
		capacity = 8000,
		name = "Gallery Supplies",
		restriction = {
			job = {
				id = "sagma",
			},
		},
	},

	{
		id = 136,
		slots = 16,
		capacity = 1200,
		name = "Large Order Pick Up",
	},
	{
		id = 137,
		slots = 100,
		capacity = 1000,
		name = "Fightclub Storage",
		restriction = {
			job = {
				id = "triad_boxing",
			},
		},
	},
	{
		id = 138,
		slots = 100,
		capacity = 1000,
		name = "Placed Object",
	},

	{
		id = 1000,
		slots = 64,
		capacity = 800,
		name = "Property Storage Tier 1",
	},
	{
		id = 1001,
		slots = 96,
		capacity = 1200,
		name = "Property Storage Tier 2",
	},
	{
		id = 1002,
		slots = 128,
		capacity = 1600,
		name = "Property Storage Tier 3",
	},
	{
		id = 1003,
		slots = 160,
		capacity = 2000,
		name = "Property Storage Tier 4",
	},
	{
		id = 1004,
		slots = 192,
		capacity = 2400,
		name = "Property Storage Tier 5",
	},
	{
		id = 1005,
		slots = 224,
		capacity = 2800,
		name = "Property Storage Tier 6",
	},
	{
		id = 1010,
		slots = 128,
		capacity = 1800,
		name = "Warehouse Storage Tier 1",
	},
	{
		id = 1011,
		slots = 240,
		capacity = 3000,
		name = "Warehouse Storage Tier 2",
	},
	{
		id = 1012,
		slots = 420,
		capacity = 4000,
		name = "Warehouse Storage Tier 3",
	},
	{
		id = 1020,
		slots = 128,
		capacity = 1800,
		name = "Container Storage",
	},

	{
		id = 2000,
		slots = 600,
		capacity = 50000,
		name = "PD Trash Can",
		trash = true,
		restriction = {
			job = {
				id = "police",
				duty = true,
			},
		},
	},

	{
		id = 2001,
		slots = 600,
		capacity = 50000,
		name = "EMS Trash Can",
		trash = true,
		restriction = {
			job = {
				id = "ems",
				duty = true,
			},
		},
	},

	{
		id = 2001,
		slots = 600,
		capacity = 50000,
		name = "Otto Trash Can",
		trash = true,
		restriction = {
			job = {
				id = "ottos",
			},
		},
	},

	{
		id = 3000,
		slots = 64,
		capacity = 1000,
		name = "Storage Unit Tier 1",
	},
	{
		id = 3001,
		slots = 128,
		capacity = 2000,
		name = "Storage Unit Tier 2",
	},
	{
		id = 3002,
		slots = 192,
		capacity = 3000,
		name = "Storage Unit Tier 3",
	},
}
