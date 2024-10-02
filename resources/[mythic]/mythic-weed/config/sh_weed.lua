Materials = {
	[581794674] = { groundType = "normal" },
	[-2041329971] = { groundType = "normal" },
	[-309121453] = { groundType = "normal" },
	[-913351839] = { groundType = "normal" },
	[-1885547121] = { groundType = "normal" },
	[-1915425863] = { groundType = "normal" },
	[-1833527165] = { groundType = "normal" },
	[2128369009] = { groundType = "normal" },
	[-124769592] = { groundType = "normal" },
	[-840216541] = { groundType = "normal" },
	[-461750719] = { groundType = "grass" },
	[930824497] = { groundType = "grass" },
	[1333033863] = { groundType = "grocks" },
	[223086562] = { groundType = "wet" },
	[1109728704] = { groundType = "wet" },
	[-1286696947] = { groundType = "mgrass" },
	[-1942898710] = { groundType = "grocks" },
	[509508168] = { groundType = "sand" },
	[-2073312001] = { groundType = "unk1" },
	[627123000] = { groundType = "unk1" },
	[-1595148316] = { groundType = "unk2" },
	[435688960] = { groundType = "unk3" },
}

Plants = {
	{
		model = GetHashKey("bkr_prop_weed_01_small_01c"),
		offset = -0.4,
		harvestable = false,
		targeting = {
			{
				icon = "magnifying-glass",
				text = "Check",
				event = "Weed:Client:Check",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "hand-scissors",
				text = "Destroy Plant",
				event = "Weed:Client:PDDestroy",
				jobPerms = {
					{
						job = "police",
						reqDuty = true,
					}
				},
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
		},
	},
	{
		model = GetHashKey("bkr_prop_weed_01_small_01b"),
		offset = -0.4,
		harvestable = false,
		targeting = {
			{
				icon = "magnifying-glass",
				text = "Check",
				event = "Weed:Client:Check",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "hand-scissors",
				text = "Destroy Plant",
				event = "Weed:Client:PDDestroy",
				jobPerms = {
					{
						job = "police",
						reqDuty = true,
					}
				},
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
		},
	},
	{
		model = GetHashKey("bkr_prop_weed_01_small_01a"),
		offset = -0.4,
		harvestable = false,
		targeting = {
			{
				icon = "magnifying-glass",
				text = "Check",
				event = "Weed:Client:Check",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "hand-scissors",
				text = "Destroy Plant",
				event = "Weed:Client:PDDestroy",
				jobPerms = {
					{
						job = "police",
						reqDuty = true,
					}
				},
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
		},
	},
	{
		model = GetHashKey("bkr_prop_weed_med_01a"),
		offset = -0.4,
		harvestable = false,
		targeting = {
			{
				icon = "magnifying-glass",
				text = "Check",
				event = "Weed:Client:Check",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "hand-scissors",
				text = "Destroy Plant",
				event = "Weed:Client:PDDestroy",
				jobPerms = {
					{
						job = "police",
						reqDuty = true,
					}
				},
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
		},
	},
	{
		model = GetHashKey("bkr_prop_weed_med_01b"),
		offset = -0.4,
		harvestable = true,
		targeting = {
			{
				icon = "magnifying-glass",
				text = "Check",
				event = "Weed:Client:Check",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "money-bill",
				text = "Harvest",
				event = "Weed:Client:Harvest",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "hand-scissors",
				text = "Destroy Plant",
				event = "Weed:Client:PDDestroy",
				jobs = { "police" },
				jobPerms = {
					{
						job = "police",
						reqDuty = true,
					}
				},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
		},
	},
	{
		model = GetHashKey("bkr_prop_weed_lrg_01a"),
		offset = -0.4,
		harvestable = true,
		targeting = {
			{
				icon = "magnifying-glass",
				text = "Check",
				event = "Weed:Client:Check",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "money-bill",
				text = "Harvest",
				event = "Weed:Client:Harvest",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "hand-scissors",
				text = "Destroy Plant",
				event = "Weed:Client:PDDestroy",
				jobPerms = {
					{
						job = "police",
						reqDuty = true,
					}
				},
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
		},
	},
	{
		model = GetHashKey("bkr_prop_weed_lrg_01b"),
		offset = -0.4,
		harvestable = true,
		targeting = {
			{
				icon = "magnifying-glass",
				text = "Check",
				event = "Weed:Client:Check",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "money-bill",
				text = "Harvest",
				event = "Weed:Client:Harvest",
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
			{
				icon = "hand-scissors",
				text = "Destroy Plant",
				event = "Weed:Client:PDDestroy",
				jobPerms = {
					{
						job = "police",
						reqDuty = true,
					}
				},
				data = {},
				isEnabled = function(data, entity)
					return GetWeedPlant(entity.entity)
				end,
			},
		},
	},
	-- {
	-- 	model = GetHashKey("prop_weed_02"),
	-- 	offset = -0.4,
	-- 	targeting = {
	-- 		{
	-- 			icon = "magnifying-glass",
	-- 			text = "Check",
	-- 			event = "Weed:Client:Check",
	-- 			data = {},
	-- 			isEnabled = function(data, entity)
	-- 				return GetWeedPlant(entity.entity)
	-- 			end,
	-- 		},
	-- 		{
	-- 			icon = "hand-scissors",
	-- 			text = "Confiscate",
	-- 			event = "Weed:Client:Confiscate",
	-- 			jobs = { "police" },
	-- 			jobDuty = true,
	-- 			data = {},
	-- 			isEnabled = function(data, entity)
	-- 				return GetWeedPlant(entity.entity)
	-- 			end,
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	model = GetHashKey("prop_weed_01"),
	-- 	offset = -0.4,
	-- 	targeting = {
	-- 		{
	-- 			icon = "magnifying-glass",
	-- 			text = "Check",
	-- 			event = "Weed:Client:Check",
	-- 			data = {},
	-- 			isEnabled = function(data, entity)
	-- 				return GetWeedPlant(entity.entity)
	-- 			end,
	-- 		},
	-- 		{
	-- 			icon = "hand-scissors",
	-- 			text = "Confiscate",
	-- 			event = "Weed:Client:Confiscate",
	-- 			jobs = { "police" },
	-- 			jobDuty = true,
	-- 			data = {},
	-- 			isEnabled = function(data, entity)
	-- 				return GetWeedPlant(entity.entity)
	-- 			end,
	-- 		},
	-- 	},
	-- },
}
