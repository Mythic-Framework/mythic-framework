_schematics = {
	-- AMMO
	smg_ammo = {
		result = { name = "AMMO_SMG", count = 2 },
		items = {
			{ name = "copperwire", count = 6 },
			{ name = "scrapmetal", count = 12 },
		},
		time = 1000,
	},
	shotgun_ammo = {
		result = { name = "AMMO_SHOTGUN", count = 2 },
		items = {
			{ name = "copperwire", count = 6 },
			{ name = "scrapmetal", count = 12 },
		},
		time = 1000,
	},
	ar_ammo = {
		result = { name = "AMMO_AR", count = 2 },
		items = {
			{ name = "copperwire", count = 12 },
			{ name = "scrapmetal", count = 24 },
		},
		time = 1000,
	},

	-- TOOLS
	thermite = {
		result = { name = "thermite", count = 1 },
		items = {
			{ name = "ironbar", count = 100 },
			{ name = "electronic_parts", count = 200 },
			{ name = "copperwire", count = 200 },
		},
		time = 1000,
	},
	blindfold = {
		result = { name = "blindfold", count = 1 },
		items = {
			{ name = "cloth", count = 100 },
		},
		time = 1000,
	},
	green_laptop = {
		result = { name = "green_laptop", count = 1 },
		items = {
			{ name = "ironbar", count = 25 },
			{ name = "electronic_parts", count = 500 },
			{ name = "scrapmetal", count = 500 },
			{ name = "copperwire", count = 500 },
			{ name = "heavy_glue", count = 500 },
			{ name = "plastic", count = 500 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 12,
	},
	blue_laptop = {
		result = { name = "blue_laptop", count = 1 },
		items = {
			{ name = "ironbar", count = 50 },
			{ name = "electronic_parts", count = 750 },
			{ name = "scrapmetal", count = 750 },
			{ name = "copperwire", count = 750 },
			{ name = "heavy_glue", count = 750 },
			{ name = "plastic", count = 750 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 12,
	},
	red_laptop = {
		result = { name = "red_laptop", count = 1 },
		items = {
			{ name = "ironbar", count = 75 },
			{ name = "electronic_parts", count = 1000 },
			{ name = "scrapmetal", count = 1000 },
			{ name = "copperwire", count = 1000 },
			{ name = "heavy_glue", count = 1000 },
			{ name = "plastic", count = 1000 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 12,
	},
	purple_laptop = {
		result = { name = "purple_laptop", count = 1 },
		items = {
			{ name = "ironbar", count = 100 },
			{ name = "electronic_parts", count = 1250 },
			{ name = "scrapmetal", count = 1250 },
			{ name = "copperwire", count = 1250 },
			{ name = "heavy_glue", count = 1250 },
			{ name = "plastic", count = 1250 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 12,
	},
	yellow_laptop = {
		result = { name = "yellow_laptop", count = 1 },
		items = {
			{ name = "ironbar", count = 125 },
			{ name = "electronic_parts", count = 1500 },
			{ name = "scrapmetal", count = 1500 },
			{ name = "copperwire", count = 1500 },
			{ name = "heavy_glue", count = 1500 },
			{ name = "plastic", count = 1500 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 12,
	},
	handcuffs = {
		result = { name = "handcuffs", count = 1 },
		items = {
			{ name = "ironbar", count = 20 },
		},
		time = 5000,
	},
	adv_electronics_kit = {
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

	-- ATTACHMENTS
	weapon_flashlight = {
		result = { name = "ATTCH_WEAPON_FLASHLIGHT", count = 1 },
		items = {
			{ name = "goldbar", count = 1 },
			{ name = "electronic_parts", count = 25 },
			{ name = "heavy_glue", count = 5 },
			{ name = "plastic", count = 30 },
			{ name = "copperwire", count = 20 },
		},
		time = 5000,
	},
	pistol_ext_mag = {
		result = { name = "ATTCH_PISTOL_EXT_MAG", count = 1 },
		items = {
			{ name = "ironbar", count = 1 },
			{ name = "heavy_glue", count = 5 },
			{ name = "plastic", count = 15 },
		},
		time = 5000,
	},
	smg_ext_mag = {
		result = { name = "ATTCH_SMG_EXT_MAG", count = 1 },
		items = {
			{ name = "ironbar", count = 10 },
			{ name = "heavy_glue", count = 25 },
			{ name = "plastic", count = 100 },
		},
		time = 5000,
	},
	rifle_ext_mag = {
		result = { name = "ATTCH_AR_EXT_MAG", count = 1 },
		items = {
			{ name = "ironbar", count = 25 },
			{ name = "heavy_glue", count = 75 },
			{ name = "plastic", count = 250 },
		},
		time = 5000,
	},
	drum_mag = {
		result = { name = "ATTCH_DRUM_MAG", count = 1 },
		items = {
			{ name = "ironbar", count = 100 },
			{ name = "heavy_glue", count = 250 },
			{ name = "plastic", count = 500 },
		},
		time = 5000,
	},
	box_mag = {
		result = { name = "ATTCH_BOX_MAG", count = 1 },
		items = {
			{ name = "ironbar", count = 100 },
			{ name = "heavy_glue", count = 250 },
			{ name = "plastic", count = 500 },
		},
		time = 5000,
	},

	pistol_suppressor = {
		result = { name = "ATTCH_PISTOL_SILENCER", count = 1 },
		items = {
			{ name = "ironbar", count = 100 },
		},
		time = 5000,
	},
	adv_pistol_suppressor = {
		result = { name = "ATTCH_ADV_PISTOL_SILENCER", count = 1 },
		items = {
			{ name = "ironbar", count = 200 },
		},
		time = 5000,
	},
	smg_suppressor = {
		result = { name = "ATTCH_SMG_SILENCER", count = 1 },
		items = {
			{ name = "ironbar", count = 100 },
		},
		time = 5000,
	},
	adv_smg_suppressor = {
		result = { name = "ATTCH_ADV_SMG_SILENCER", count = 1 },
		items = {
			{ name = "ironbar", count = 200 },
		},
		time = 5000,
	},
	ar_suppressor = {
		result = { name = "ATTCH_AR_SILENCER", count = 1 },
		items = {
			{ name = "ironbar", count = 100 },
		},
		time = 5000,
	},
	adv_ar_suppressor = {
		result = { name = "ATTCH_ADV_AR_SILENCER", count = 1 },
		items = {
			{ name = "ironbar", count = 200 },
		},
		time = 5000,
	},

	scope_holo = {
		result = { name = "ATTCH_HOLO", count = 1 },
		items = {
			{ name = "ironbar", count = 25 },
			{ name = "goldbar", count = 1 },
			{ name = "electronic_parts", count = 30 },
			{ name = "glue", count = 5 },
			{ name = "copperwire", count = 45 },
		},
		time = 5000,
	},
	scope_reddot = {
		result = { name = "ATTCH_REDDOT", count = 1 },
		items = {
			{ name = "ironbar", count = 25 },
			{ name = "goldbar", count = 1 },
			{ name = "electronic_parts", count = 30 },
			{ name = "glue", count = 5 },
			{ name = "copperwire", count = 45 },
		},
		time = 5000,
	},
	scope_small = {
		result = { name = "ATTCH_SMALL_SCOPE", count = 1 },
		items = {
			{ name = "ironbar", count = 35 },
			{ name = "goldbar", count = 1 },
			{ name = "electronic_parts", count = 40 },
			{ name = "glue", count = 10 },
			{ name = "copperwire", count = 60 },
		},
		time = 5000,
	},
	scope_med = {
		result = { name = "ATTCH_MED_SCOPE", count = 1 },
		items = {
			{ name = "ironbar", count = 45 },
			{ name = "goldbar", count = 2 },
			{ name = "electronic_parts", count = 50 },
			{ name = "glue", count = 15 },
			{ name = "copperwire", count = 75 },
		},
		time = 5000,
	},
	scope_lrg = {
		result = { name = "ATTCH_LRG_SCOPE", count = 1 },
		items = {
			{ name = "ironbar", count = 55 },
			{ name = "goldbar", count = 3 },
			{ name = "electronic_parts", count = 60 },
			{ name = "glue", count = 20 },
			{ name = "copperwire", count = 90 },
		},
		time = 5000,
	},

	-- GUNS
	mp5 = {
		result = { name = "WEAPON_MP5", count = 1 },
		items = {
			{ name = "ironbar", count = 75 },
			{ name = "rubber", count = 300 },
			{ name = "heavy_glue", count = 125 },
			{ name = "plastic", count = 500 },
			{ name = "copperwire", count = 85 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 2,
	},
	miniuzi = {
		result = { name = "WEAPON_MINIUZI", count = 1 },
		items = {
			{ name = "ironbar", count = 125 },
			{ name = "rubber", count = 400 },
			{ name = "heavy_glue", count = 175 },
			{ name = "plastic", count = 500 },
			{ name = "copperwire", count = 170 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 3,
	},
	mp9 = {
		result = { name = "WEAPON_MP9A", count = 1 },
		items = {
			{ name = "ironbar", count = 125 },
			{ name = "rubber", count = 400 },
			{ name = "heavy_glue", count = 175 },
			{ name = "plastic", count = 500 },
			{ name = "copperwire", count = 170 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 3,
	},
	mpx = {
		result = { name = "WEAPON_MPX", count = 1 },
		items = {
			{ name = "ironbar", count = 175 },
			{ name = "rubber", count = 500 },
			{ name = "heavy_glue", count = 225 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 250 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 4,
	},
	pp19 = {
		result = { name = "WEAPON_PP19", count = 1 },
		items = {
			{ name = "ironbar", count = 175 },
			{ name = "rubber", count = 500 },
			{ name = "heavy_glue", count = 225 },
			{ name = "plastic", count = 600 },
			{ name = "copperwire", count = 250 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 4,
	},
	appistol = {
		result = { name = "WEAPON_APPISTOL", count = 1 },
		items = {
			{ name = "ironbar", count = 300 },
			{ name = "rubber", count = 1000 },
			{ name = "heavy_glue", count = 500 },
			{ name = "plastic", count = 1100 },
			{ name = "copperwire", count = 500 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 12,
	},
	tec9 = {
		result = { name = "WEAPON_MACHINEPISTOL", count = 1 },
		items = {
			{ name = "ironbar", count = 300 },
			{ name = "rubber", count = 1000 },
			{ name = "heavy_glue", count = 500 },
			{ name = "plastic", count = 1100 },
			{ name = "copperwire", count = 500 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 12,
	},
	ak74 = {
		result = { name = "WEAPON_AK74", count = 1 },
		items = {
			{ name = "ironbar", count = 300 },
			{ name = "rubber", count = 1000 },
			{ name = "heavy_glue", count = 500 },
			{ name = "plastic", count = 1100 },
			{ name = "copperwire", count = 500 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 4,
	},
	ak47 = {
		result = { name = "WEAPON_ASSAULTRIFLE", count = 1 },
		items = {
			{ name = "ironbar", count = 300 },
			{ name = "rubber", count = 1000 },
			{ name = "heavy_glue", count = 500 },
			{ name = "plastic", count = 1100 },
			{ name = "copperwire", count = 500 },
		},
		time = 5000,
		cooldown = 1000 * 60 * 60 * 4,
	},
	sns = {
		result = { name = "WEAPON_SNSPISTOL", count = 1 },
		items = {
			{ name = "scrapmetal", count = 5 },
			{ name = "ironbar", count = 3 },
			{ name = "rubber", count = 8 },
			{ name = "heavy_glue", count = 4 },
			{ name = "plastic", count = 6 },
			{ name = "copperwire", count = 8 },
		},
		time = 5000,
	},
	g45 = {
		result = { name = "WEAPON_G45", count = 1 },
		items = {
			{ name = "scrapmetal", count = 25 },
			{ name = "ironbar", count = 10 },
			{ name = "rubber", count = 100 },
			{ name = "heavy_glue", count = 45 },
			{ name = "plastic", count = 100 },
			{ name = "copperwire", count = 30 },
		},
		time = 5000,
	},
	l5 = {
		result = { name = "WEAPON_L5", count = 1 },
		items = {
			{ name = "scrapmetal", count = 25 },
			{ name = "ironbar", count = 10 },
			{ name = "rubber", count = 100 },
			{ name = "heavy_glue", count = 45 },
			{ name = "plastic", count = 100 },
			{ name = "copperwire", count = 30 },
		},
		time = 5000,
	},
}
