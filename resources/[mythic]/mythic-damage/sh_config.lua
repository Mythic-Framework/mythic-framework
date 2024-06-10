Config = Config or {}
Config.Debug = false

Config.NotifStyle = {
	alert = {
		background = "#760036",
	},
	progress = {
		background = "#ffffff",
	},
}

Config.BedModels = {
	`v_med_bed1`,
	`v_med_bed2`,
	`v_med_emptybed`,
}

Config.Beds = {
	{ x = -448.375, y = -283.771, z = 33.94, h = 203.0 },
	{ x = -451.535, y = -285.083, z = 33.94, h = 203.0 },
	{ x = -455.114, y = -278.044, z = 33.94, h = 23.0 },
	{ x = -454.916, y = -286.475, z = 33.94, h = 203.0 },
	{ x = -459.004, y = -279.650, z = 33.94, h = 23.0 },
	{ x = -460.287, y = -288.666, z = 33.94, h = 203.0 },
	{ x = -462.747, y = -281.232, z = 33.94, h = 23.0 },
	{ x = -463.686, y = -290.074, z = 33.94, h = 203.0 },
	{ x = -466.501, y = -282.755, z = 33.94, h = 23.0 },
	{ x = -466.987, y = -291.403, z = 33.94, h = 203.0 },
	{ x = -469.906, y = -284.189, z = 33.94, h = 23.0 },
	{ x = -448.980, y = -303.591, z = 33.94, h = 205.0},
	-- Pillbox beds, JUST IN FUCKING CASE
	-- { x = 309.35, y = -577.38, z = 42.84, h = 340.00 },
	-- { x = 307.72, y = -581.75, z = 42.84, h = 160.00 },
	-- { x = 313.93, y = -579.04, z = 42.84, h = 340.00 },
	-- { x = 311.06, y = -582.96, z = 42.84, h = 160.00 },
	-- { x = 314.47, y = -584.20, z = 42.84, h = 160.00 },
	-- { x = 319.41, y = -581.04, z = 42.84, h = 340.00 },
	-- { x = 317.67, y = -585.37, z = 42.84, h = 160.00 },
	-- { x = 324.26, y = -582.80, z = 42.84, h = 340.00 },
	-- { x = 322.62, y = -587.17, z = 42.84, h = 160.00 },
	-- { x = 359.54, y = -586.23, z = 42.84, h = 250.00 },
	-- { x = 361.36, y = -581.30, z = 42.83, h = 250.00 },
	-- { x = 354.44, y = -600.19, z = 42.85, h = 250.00 },
	-- { x = 363.80, y = -589.12, z = 42.85, h = 250.00 },
	-- { x = 364.96, y = -585.94, z = 42.85, h = 250.00 },
	-- { x = 366.52, y = -581.66, z = 42.85, h = 250.00 },
	-- { x = 357.55, y = -598.16, z = 42.84, h = 160.00 },
	-- { x = 354.18, y = -593.00, z = 42.84, h = 250.00 },
	-- { x = 346.48, y = -590.33, z = 42.84, h = 70.00 },

	-- { x = 321.9, y = -585.86, z = 43.29, h = 193.55 },
	-- { x = 318.56, y = -580.69, z = 43.29, h = 245.66 },
	-- { x = 316.87, y = -584.93, z = 43.29, h = 247.1 },
	-- { x = 313.56, y = -583.83, z = 43.29, h = 250.0 },
	-- { x = 314.91, y = -579.39, z = 43.29, h = 68.7 },
	-- { x = 312.01, y = -583.34, z = 43.29, h = 66.16 },
}

--[[
    GENERAL SETTINGS | THESE WILL AFFECT YOUR ENTIRE SERVER SO BE SURE TO SET THESE CORRECTLY
    MaxHp : Maximum HP Allowed, set to -1 if you want to disable mythic_hospital from setting this
        NOTE: Anything under 100 and you are dead
    RegenRate : 
]]
Config.MaxHp = 200
Config.RegenRate = 0.0
Config.HealTimer = 60
Config.KnockoutTimer = 60
Config.RespawnTimer = 300

--[[
    AlertShowInfo : 
]]
Config.AlertShowInfo = 2
