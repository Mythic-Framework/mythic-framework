Config = Config or {}
_itemsSource = _itemsSource or {}

function hasValue(tbl, value)
	for k, v in ipairs(tbl or {}) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

Config.StartItems = {
	{ name = "govid", count = 1 },
	{ name = "phone", count = 1 },
	{ name = "water", count = 5 },
	{ name = "sandwich_blt", count = 5 },
	{ name = "bandage", count = 5 },
	{ name = "coffee", count = 2 },
}

Config.ShopItemSets = {
	[1] = {
		"sandwich",
		"sandwich_egg",
		"water",
		"bandage",
		"cigarette_pack",
		"coffee",
		"soda",
		"energy_pepe",
		"chocolate_bar",
		"donut",
		"crisp",
		"rolling_paper",
	}, -- General Stores like 24/7 etc..
	[2] = {
		"screwdriver",
		"WEAPON_HAMMER",
		"WEAPON_CROWBAR",
		"WEAPON_GOLFCLUB",
		"repairkit",
		"fertilizer_nitrogen",
		"fertilizer_phosphorus",
		"fertilizer_potassium",
		"camping_chair",
		"beanbag",
		"plastic_wrap",
		"baggy",
		"binoculars",
		"WEAPON_SHOVEL",
		"cloth",
		"pipe",
		"nails",
		"drill",
	}, -- Hardware
	[3] = { "cup", "bun", "patty", "pickle" }, -- Burger Shot Supplies
	[4] = { "armor", "heavyarmor", "WEAPON_PISTOL", "WEAPON_FNX", "AMMO_PISTOL", "WEAPON_BAT" }, -- Ammunation
	[5] = { -- Electronics Store
		"phone",
		"radio_shitty",
		"camera",
		"electronics_kit",
	},
	[6] = {
		"pdarmor",
		"ifak",
		"pdhandcuffs",
		"spikes",
		"WEAPON_FLASHLIGHT",
		"WEAPON_TASER",
		"WEAPON_BEANBAG",
		"WEAPON_G17",
		"WEAPON_HKUMP",
		"WEAPON_HK416B",
		"AMMO_PISTOL_PD",
		"AMMO_SHOTGUN_PD",
		"AMMO_SMG_PD",
		"AMMO_RIFLE_PD",
		"AMMO_STUNGUN",
		"radio",
		"binoculars",
		"camera",
		"phone",
		"WEAPON_FLASHBANG",
		"WEAPON_SMOKEGRENADE",
	}, -- Police Armory
	[7] = { "traumakit", "medicalkit", "firstaid", "bandage", "morphine", "radio", "phone", "scuba_gear" },
	[8] = {
		"WEAPON_SNIPERRIFLE2",
		"AMMO_SNIPER",
		"WEAPON_KNIFE",
		"hunting_bait",
		-- "deer_bait",
		-- "boar_bait",
		-- "pig_bait",
		-- "chicken_bait",
		-- "rabbit_bait",
		-- "exotic_bait",
	},
	[9] = {
		"pdarmor",
		"pdarmor",
		"traumakit",
		"ifak",
		"pdhandcuffs",
		-- "spikes",
		"WEAPON_TASER",
		"WEAPON_G17",
		--"WEAPON_HK416B",
		"AMMO_PISTOL_PD",
		"AMMO_RIFLE_PD",
		"AMMO_SHOTGUN_PD",
		"AMMO_STUNGUN",
		"radio",
		"phone",
	}, -- DOC Armory
	[10] = { "water" }, -- Water Machine
	[11] = { "coffee" }, -- Coffee Machine
	[12] = { -- Drinks Vending Machines
		"water",
		"soda",
		"energy_pepe",
	},
	[13] = { -- Food Vending Machines
		"chocolate_bar",
		"donut",
		"crisp",
	},
	[14] = {
		"firstaid",
		"bandage",
		"water",
		"sandwich_blt",
	},
	[15] = {
		"WEAPON_PETROLCAN",
	},
	[16] = {
		"dough",
		"eggs",
		"loaf",
		"sugar",
		"flour",
		"rice",
		"icing",
		"milk_can",
		"tea_leaf",
		"plastic_cup",
		"coffee_beans",
		"coffee_holder",
		"foodbag",
		"cardboard_box",
		"paper_bag",
		"burgershot_bag",
		"burgershot_cup",
		"bun",
		"water",
		"cheese",
		"jaeger",
		"raspberry_liqueur",
		"sparkling_wine",
		"rum",
		"whiskey",
		"tequila",
		"pineapple",
		"raspberry",
		"peach_juice",
		"coconut_milk",
		"bento_box",
		"keg",
	},
	[17] = {
		"weed_joint",
		"rolling_paper",
	},
	[18] = { -- Liquor Stores
		"vodka",
		"beer",
		"water",
		"bandage",
		"cigarette_pack",
		"coffee",
		"soda",
		"energy_pepe",
		"chocolate_bar",
		"donut",
		"crisp",
		"rolling_paper",
	},
	[19] = {
		"wine_bottle",
	},
	[20] = {
		"fishing_rod",
		"fishing_bait_worm",
		"fishing_bait_lugworm",
		"WEAPON_KNIFE",
	},
	[21] = {
		"fishing_rod",
		"fishing_net",
		"fishing_bait_worm",
		"fishing_bait_lugworm",
		"WEAPON_KNIFE",
	},
	[22] = {
		"personal_plates",
	},
}
