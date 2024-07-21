table.insert(Config.Restaurants, {
    Name = "Bobs Balls",
    Job = "bowling",
    -- Benches = {
    -- 	drinks = {
    -- 		label = "Drinks",
    -- 		targeting = {
    -- 			actionString = "Preparing",
    -- 			icon = "kitchen-set",
    -- 			poly = {
    -- 				coords = vector3(-1199.32, -896.87, 14.0),
    -- 				w = 5.4,
    -- 				l = 2.2,
    -- 				options = {
    -- 					heading = 33,
    -- 					--debugPoly = true,
    -- 					minZ = 11.6,
    -- 					maxZ = 15.6,
    -- 				},
    -- 			},
    -- 		},
    -- 		recipes = {
    -- 			{
    -- 				result = { name = "burgershot_drink", count = 1 },
    -- 				items = {
    -- 					{ name = "burgershot_cup", count = 1 },
    -- 				},
    -- 				time = 2000,
    -- 			},
    -- 		},
    -- 	},
    -- 	food = {
    -- 		label = "Food",
    -- 		targeting = {
    -- 			actionString = "Cooking",
    -- 			icon = "fire-burner",
    -- 			poly = {
    -- 				coords = vector3(-1201.41, -899.46, 14.0),
    -- 				w = 1.2,
    -- 				l = 10.35,
    -- 				options = {
    -- 					heading = 304,
    -- 					--debugPoly = true,
    -- 					minZ = 13.0,
    -- 					maxZ = 15.6,
    -- 				},
    -- 			},
    -- 		},
    -- 		recipes = {
    -- 			{
    -- 				result = { name = "burger", count = 1 },
    -- 				items = {
    -- 					{ name = "bun", count = 1 },
    -- 					{ name = "patty", count = 1 },
    -- 					{ name = "lettuce", count = 1 },
    -- 					{ name = "pickle", count = 1 },
    -- 					{ name = "tomato", count = 1 },
    -- 				},
    -- 				time = 3000,
    -- 			},
    -- 			{
    -- 				result = { name = "burgershot_fries", count = 1 },
    -- 				items = {
    -- 					{ name = "potato", count = 1 },
    -- 				},
    -- 				time = 3000,
    -- 			},
    -- 		},
    -- 	},
    -- },
    Storage = {
        {
            id = "bobs_balls_fridge",
            type = "box",
            coords = vector3(757.43, -766.4, 26.34),
            width = 1.0,
            length = 0.8,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.34,
                maxZ = 27.54
            },
			data = {
                business = "bowling",
                inventory = {
                    invType = 68,
                    owner = "bobs_balls_fridge",
                },
			},
        },
    },
    Pickups = {
        {
            id = "bobs_balls-pickup-1",
            coords = vector3(755.73, -768.12, 26.34),
            width = 0.8,
            length = 0.6,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 26.14,
                maxZ = 26.94
            },
			data = {
                business = "bowling",
                inventory = {
                    invType = 25,
                    owner = "bobs_balls-pickup-1",
                },
			},
        },
    },
    -- Warmers = {
    -- 	{
    -- 		id = "pizza_this-warmer-1",
    -- 		coords = vector3(811.69, -755.44, 26.78),
    -- 		width = 0.8,
    -- 		length = 2.0,
    -- 		options = {
    -- 			heading = 0,
    -- 			--debugPoly=true,
    -- 			minZ = 26.58,
    -- 			maxZ = 27.38
    -- 		},
    -- 		restrict = {
    -- 			jobs = { "pizza_this" },
    -- 		},
    -- 		inventory = {
    -- 			invType = 60,
    -- 			owner = "pizza_this-warmer-1",
    -- 		},
    -- 	},
    -- },
})