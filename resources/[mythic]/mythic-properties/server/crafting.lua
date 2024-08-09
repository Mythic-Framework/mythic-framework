-- Properties With Crafting

_propertyCraftingRecipies = {
	["WEAPON_PISTOL"] = {
		result = { name = "WEAPON_PISTOL", count = 1 },
		items = {
			{ name = "scrapmetal", count = 4 },
			{ name = "rubber", count = 5 },
			{ name = "heavy_glue", count = 2 },
			{ name = "plastic", count = 4 },
		},
		time = 10 * 1000,
	},
	["WEAPON_FNX"] = {
		result = { name = "WEAPON_FNX", count = 1 },
		items = {
			{ name = "scrapmetal", count = 4 },
			{ name = "rubber", count = 5 },
			{ name = "heavy_glue", count = 2 },
			{ name = "plastic", count = 4 },
			{ name = "copperwire", count = 3 },
		},
		time = 10 * 1000,
	},
	["WEAPON_HEAVYPISTOL"] = {
		result = { name = "WEAPON_HEAVYPISTOL", count = 1 },
		items = {
			{ name = "scrapmetal", count = 5 },
			{ name = "ironbar", count = 3 },
			{ name = "rubber", count = 8 },
			{ name = "heavy_glue", count = 4 },
			{ name = "plastic", count = 6 },
			{ name = "copperwire", count = 8 },
		},
		time = 10 * 1000,
	},
	["WEAPON_APPISTOL"] = {
		result = { name = "WEAPON_APPISTOL", count = 1 },
		items = {
			{ name = "scrapmetal", count = 5 },
			{ name = "ironbar", count = 3 },
			{ name = "rubber", count = 8 },
			{ name = "heavy_glue", count = 4 },
			{ name = "plastic", count = 6 },
			{ name = "copperwire", count = 8 },
		},
		time = 20 * 1000,
	},
	["lockpick"] = {
		result = { name = "lockpick", count = 15 },
		items = {
			{ name = "ironbar", count = 2 },
		},
		time = 1000,
	},
	["adv_lockpick"] = {
		result = { name = "adv_lockpick", count = 10 },
		items = {
			{ name = "ironbar", count = 50 },
		},
		time = 1000,
	},
	["AMMO_PISTOL"] = {
		result = { name = "AMMO_PISTOL", count = 2 },
		items = {
			{ name = "copperwire", count = 2 },
			{ name = "scrapmetal", count = 4 },
		},
		time = 1000,
	},
	["WEAPON_MOLOTOV"] = {
		result = { name = "WEAPON_MOLOTOV", count = 1 },
		items = {
			{ name = "whiskey", count = 1 },
			{ name = "cloth", count = 1 },
		},
		time = 2000,
	},
	["thermite"] = {
		result = { name = "thermite", count = 1 },
		items = {
			{ name = "scrapmetal", count = 250 },
			{ name = "ironbar", count = 50 },
			{ name = "electronic_parts", count = 75 },
		},
		time = 1000,
	},
	["ATTCH_PISTOL_EXT_MAG"] = {
		result = { name = "ATTCH_PISTOL_EXT_MAG", count = 1 },
		items = {
			{ name = "ironbar", count = 1 },
			{ name = "heavy_glue", count = 5 },
			{ name = "plastic", count = 15 },
		},
		time = 5000,
	},
	["safecrack_kit"] = {
		result = { name = "safecrack_kit", count = 1 },
		items = {
			{ name = "ironbar", count = 5 },
			{ name = "heavy_glue", count = 1 },
			{ name = "plastic", count = 4 },
		},
		time = 5000,
	},
	["electronics_kit"] = {
		result = { name = "electronics_kit", count = 1 },
		items = {
			{ name = "goldbar", count = 2 },
			{ name = "electronic_parts", count = 5 },
			{ name = "heavy_glue", count = 1 },
			{ name = "plastic", count = 4 },
			{ name = "copperwire", count = 3 },
		},
		time = 5000,
	},
	["adv_electronics_kit"] = {
		result = { name = "adv_electronics_kit", count = 1 },
		items = {
			{ name = "goldbar", count = 1 },
			{ name = "silverbar", count = 2 },
			{ name = "electronic_parts", count = 30 },
			{ name = "heavy_glue", count = 5 },
			{ name = "plastic", count = 30 },
			{ name = "copperwire", count = 20 },
		},
		time = 5000,
	},
	["vpn"] = {
		result = { name = "vpn", count = 1 },
		items = {
			{ name = "silverbar", count = 2 },
			{ name = "electronic_parts", count = 3 },
			{ name = "glue", count = 1 },
			{ name = "plastic", count = 4 },
			{ name = "copperwire", count = 3 },
		},
		time = 5000,
	}
}

-- Really Shitty Way of doing this but oh well

_propertyCrafting = {
	{ -- King Abuse's Bench
		id = "6254a3649e4b901cdce6376d",
		recipies = {
			_propertyCraftingRecipies.lockpick,
			_propertyCraftingRecipies.adv_lockpick,
			_propertyCraftingRecipies.WEAPON_PISTOL,
			_propertyCraftingRecipies.WEAPON_FNX,
			_propertyCraftingRecipies.WEAPON_HEAVYPISTOL,
			_propertyCraftingRecipies.AMMO_PISTOL,
			{
				result = { name = "fakeplates", count = 2 },
				items = {
					{ name = "plastic", count = 1 },
					{ name = "scrapmetal", count = 1 },
				},
				time = 10000,
			},
			_propertyCraftingRecipies.vpn,
			_propertyCraftingRecipies.safecrack_kit,
			_propertyCraftingRecipies.electronics_kit,
			_propertyCraftingRecipies.adv_electronics_kit,
			_propertyCraftingRecipies.WEAPON_MOLOTOV,
			_propertyCraftingRecipies.ATTCH_PISTOL_EXT_MAG,
			-- {
			-- 	result = { name = "WEAPON_PIPEBOMB", count = 1 },
			-- 	items = {
			-- 		{ name = "pipe", count = 1 },
			-- 		{ name = "gunpowder", count = 1 },
			-- 		{ name = "nails", count = 2 },
			-- 	},
			-- 	time = 2000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_PISTOL_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 6 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_ADV_PISTOL_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_SMG_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 6 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_ADV_SMG_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 16 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_AR_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 6 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_ADV_AR_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_WEAPON_FLASHLIGHT", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "electronic_parts", count = 10 },
			-- 		{ name = "plastic", count = 2 },
			-- 		{ name = "copperwire", count = 2 },
			-- 		{ name = "glue", count = 1 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_SMG_EXT_MAG", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "heavy_glue", count = 5 },
			-- 		{ name = "plastic", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_AR_EXT_MAG", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "heavy_glue", count = 5 },
			-- 		{ name = "plastic", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_DRUM_MAG", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "heavy_glue", count = 5 },
			-- 		{ name = "plastic", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_BOX_MAG", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "heavy_glue", count = 5 },
			-- 		{ name = "plastic", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_HOLO", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "electronic_parts", count = 35 },
			-- 		{ name = "plastic", count = 5 },
			-- 		{ name = "heavy_glue", count = 2 },
			-- 	},
			-- 	time = 5000,
			-- },
		},
		restrictions = {
			job = {
				id = "dgang",
				onDuty = false,
			},
		},
		canUseSchematics = true,
	},
	{ -- Alzars Bench
		id = "62e9a59083fb7e252cb98e77",
		recipies = {
			_propertyCraftingRecipies.lockpick,
			_propertyCraftingRecipies.adv_lockpick,
			_propertyCraftingRecipies.WEAPON_PISTOL,
			_propertyCraftingRecipies.WEAPON_FNX,
			_propertyCraftingRecipies.WEAPON_HEAVYPISTOL,
			_propertyCraftingRecipies.AMMO_PISTOL,
			{
				result = { name = "fakeplates", count = 2 },
				items = {
					{ name = "plastic", count = 1 },
					{ name = "scrapmetal", count = 1 },
				},
				time = 10000,
			},
			_propertyCraftingRecipies.vpn,
			_propertyCraftingRecipies.safecrack_kit,
			_propertyCraftingRecipies.electronics_kit,
			_propertyCraftingRecipies.adv_electronics_kit,
			_propertyCraftingRecipies.WEAPON_MOLOTOV,
			_propertyCraftingRecipies.ATTCH_PISTOL_EXT_MAG,
			-- {
			-- 	result = { name = "WEAPON_PIPEBOMB", count = 1 },
			-- 	items = {
			-- 		{ name = "pipe", count = 1 },
			-- 		{ name = "gunpowder", count = 1 },
			-- 		{ name = "nails", count = 2 },
			-- 	},
			-- 	time = 2000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_PISTOL_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 6 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_ADV_PISTOL_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_SMG_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 6 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_ADV_SMG_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 16 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_AR_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 6 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_ADV_AR_SILENCER", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_WEAPON_FLASHLIGHT", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "electronic_parts", count = 10 },
			-- 		{ name = "plastic", count = 2 },
			-- 		{ name = "copperwire", count = 2 },
			-- 		{ name = "glue", count = 1 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_SMG_EXT_MAG", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "heavy_glue", count = 5 },
			-- 		{ name = "plastic", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_AR_EXT_MAG", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "heavy_glue", count = 5 },
			-- 		{ name = "plastic", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_DRUM_MAG", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "heavy_glue", count = 5 },
			-- 		{ name = "plastic", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_BOX_MAG", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "heavy_glue", count = 5 },
			-- 		{ name = "plastic", count = 15 },
			-- 	},
			-- 	time = 5000,
			-- },
			-- {
			-- 	result = { name = "ATTCH_HOLO", count = 1 },
			-- 	items = {
			-- 		{ name = "ironbar", count = 1 },
			-- 		{ name = "electronic_parts", count = 35 },
			-- 		{ name = "plastic", count = 5 },
			-- 		{ name = "heavy_glue", count = 2 },
			-- 	},
			-- 	time = 5000,
			-- },
		},
		restrictions = {
			job = {
				id = "dgang",
				onDuty = false,
			},
		},
		canUseSchematics = true,
	},
	{ -- Robbies Bench
		id = "6266c8875a39301c44cc748c",
		recipies = {
			_propertyCraftingRecipies.WEAPON_PISTOL,
			_propertyCraftingRecipies.WEAPON_FNX,
			_propertyCraftingRecipies.WEAPON_HEAVYPISTOL,
			_propertyCraftingRecipies.AMMO_PISTOL,
			_propertyCraftingRecipies.WEAPON_MOLOTOV,
			_propertyCraftingRecipies.ATTCH_PISTOL_EXT_MAG,
			_propertyCraftingRecipies.vpn,
		},
		canUseSchematics = true,
	},
	{ -- Zeke's Bench
		id = "627bcd0416fc911180e25c98",
		recipies = {
			_propertyCraftingRecipies.vpn,
			_propertyCraftingRecipies.safecrack_kit,
			_propertyCraftingRecipies.electronics_kit,
			_propertyCraftingRecipies.adv_electronics_kit,
		},
		canUseSchematics = true,
	},
	{ -- Jakes Bench
		id = "627ec8b655399e5fe01a185b",
		recipies = {
			_propertyCraftingRecipies.WEAPON_PISTOL,
			_propertyCraftingRecipies.WEAPON_FNX,
			_propertyCraftingRecipies.WEAPON_HEAVYPISTOL,
			_propertyCraftingRecipies.AMMO_PISTOL,
			_propertyCraftingRecipies.WEAPON_MOLOTOV,
			_propertyCraftingRecipies.ATTCH_PISTOL_EXT_MAG,
		},
		canUseSchematics = true,
	},
	{ -- Jakes Bench
		id = "62ec823174ffdb7079d6885b",
		recipies = {
			_propertyCraftingRecipies.WEAPON_PISTOL,
			_propertyCraftingRecipies.WEAPON_FNX,
			_propertyCraftingRecipies.WEAPON_HEAVYPISTOL,
			_propertyCraftingRecipies.AMMO_PISTOL,
			_propertyCraftingRecipies.WEAPON_MOLOTOV,
			_propertyCraftingRecipies.ATTCH_PISTOL_EXT_MAG,
		},
		canUseSchematics = true,
	},
}

function SetupPropertyCrafting()
	for k, v in ipairs(_propertyCrafting) do
		Crafting:RegisterBench("property-" .. v.id, false, false, false, v.restrictions, v.recipies, v.canUseSchematics)
		GlobalState[string.format("Property:Crafting:%s", v.id)] = {
			crafting = true,
			schematics = v.canUseSchematics,
		}
	end
end
