CraftingTables = {
	{
		label = "Salvage Exchange",
		targetConfig = {
			actionString = "Trading",
			icon = "business-time",
			ped = {
				model = "s_m_m_gardener_01",
				task = "WORLD_HUMAN_LEANING",
			},
		},
		location = {
			x = 2350.925,
			y = 3145.093,
			z = 47.209,
			h = 169.500,
		},
		restriction = {
			shared = true,
		},
		recipes = {
			{
				result = { name = "ironbar", count = 10 },
				items = {
					{ name = "salvagedparts", count = 25 },
				},
				time = 0,
			},
			{
				result = { name = "scrapmetal", count = 20 },
				items = {
					{ name = "salvagedparts", count = 10 },
				},
				time = 0,
			},
			{
				result = { name = "heavy_glue", count = 20 },
				items = {
					{ name = "salvagedparts", count = 10 },
				},
				time = 0,
			},
			{
				result = { name = "rubber", count = 16 },
				items = {
					{ name = "salvagedparts", count = 8 },
				},
				time = 0,
			},
			{
				result = { name = "plastic", count = 6 },
				items = {
					{ name = "salvagedparts", count = 3 },
				},
				time = 0,
			},
			{
				result = { name = "copperwire", count = 4 },
				items = {
					{ name = "salvagedparts", count = 2 },
				},
				time = 0,
			},
			{
				result = { name = "glue", count = 4 },
				items = {
					{ name = "salvagedparts", count = 2 },
				},
				time = 0,
			},
			{
				result = { name = "electronic_parts", count = 32 },
				items = {
					{ name = "salvagedparts", count = 8 },
				},
				time = 0,
			},
		},
	},
	{
		label = "Recycle Exchange",
		targetConfig = {
			actionString = "Trading",
			icon = "business-time",
			ped = {
				model = "s_m_m_dockwork_01",
				task = "WORLD_HUMAN_JANITOR",
			},
		},
		location = {
			x = -334.833,
			y = -1577.247,
			z = 24.222,
			h = 20.715,
		},
		restriction = {
			shared = true,
		},
		recipes = {
			{
				result = { name = "ironbar", count = 10 },
				items = {
					{ name = "recycledgoods", count = 25 },
				},
				time = 0,
			},
			{
				result = { name = "scrapmetal", count = 20 },
				items = {
					{ name = "recycledgoods", count = 10 },
				},
				time = 0,
			},
			{
				result = { name = "heavy_glue", count = 20 },
				items = {
					{ name = "recycledgoods", count = 10 },
				},
				time = 0,
			},
			{
				result = { name = "rubber", count = 16 },
				items = {
					{ name = "recycledgoods", count = 8 },
				},
				time = 0,
			},
			{
				result = { name = "plastic", count = 6 },
				items = {
					{ name = "recycledgoods", count = 3 },
				},
				time = 0,
			},
			{
				result = { name = "copperwire", count = 4 },
				items = {
					{ name = "recycledgoods", count = 2 },
				},
				time = 0,
			},
			{
				result = { name = "glue", count = 4 },
				items = {
					{ name = "recycledgoods", count = 2 },
				},
				time = 0,
			},
		},
	},
	{
		label = "Smelter",
		targetConfig = {
			actionString = "Smelting",
			icon = "fire-burner",
			model = "gr_prop_gr_bench_02b",
		},
		location = {
			x = 1112.165,
			y = -2030.834,
			z = 29.914,
			h = 235.553,
		},
		restriction = {
			shared = true,
		},
		recipes = {
			{
				result = { name = "goldbar", count = 1 },
				items = {
					{ name = "goldore", count = 1 },
				},
				time = 5000,
				animation = "mechanic",
			},
			{
				result = { name = "silverbar", count = 1 },
				items = {
					{ name = "silverore", count = 1 },
				},
				time = 5000,
				animation = "mechanic",
			},
			{
				result = { name = "ironbar", count = 3 },
				items = {
					{ name = "ironore", count = 1 },
				},
				time = 5000,
				animation = "mechanic",
			},
		},
	},
}
