table.insert(Config.Restaurants, {
    Name = "Bakery",
    Job = "bakery",
    Benches = {
        food = {
            label = "Food",
            targeting = {
                actionString = "Preparing",
                icon = "bread-slice",
                poly = {
                    coords = vector3(-1263.97, -282.88, 37.39),
                    l = 5.2,
                    w = 2.0,
                    options = {
                        heading = 20,
                        --debugPoly=true,
                        minZ = 36.39,
                        maxZ = 37.59
                    },
                },
            },
            recipes = {
                _genericRecipies.glass_cock,
                _genericRecipies.lemonade,
                {
                    result = { name = "smoothie_orange", count = 3 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "orange", count = 3 },
                        { name = "sugar", count = 1 },
                    },
                    time = 5000,
                },
                _genericRecipies.sandwich,
                _genericRecipies.sandwich_turkey,
                _genericRecipies.sandwich_beef,
                _genericRecipies.sandwich_blt,
                _genericRecipies.salad,
                {
                    result = { name = "baguette", count = 4 },
                    items = {
                        { name = "dough", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "bavarois", count = 6 },
                    items = {
                        { name = "sugar", count = 1 },
                        { name = "raspberry", count = 1 },
                        { name = "milk_can", count = 1 },
                        { name = "icing", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "choux", count = 6 },
                    items = {
                        { name = "sugar", count = 1 },
                        { name = "dough", count = 1 },
                        { name = "milk_can", count = 1 },
                        { name = "icing", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "choclat_eclair", count = 3 },
                    items = {
                        { name = "sugar", count = 2 },
                        { name = "dough", count = 1 },
                        { name = "milk_can", count = 1 },
                        { name = "icing", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "charlotte", count = 6 },
                    items = {
                        { name = "sugar", count = 2 },
                        { name = "dough", count = 1 },
                        { name = "milk_can", count = 1 },
                        { name = "raspberry", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "latte", count = 4 },
                    items = {
                        { name = "coffee_beans", count = 5 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "donut_stack", count = 5 },
                    items = {
                        { name = "sugar", count = 2 },
                        { name = "dough", count = 1 },
                        { name = "milk_can", count = 1 },
                        { name = "raspberry", count = 1 },
                        { name = "chocolate_bar", count = 1 },
                    },
                    time = 5000,
                },
            },
        },
    },
    Storage = {
        {
            id = "bakery-storage",
            type = "box",
            coords = vector3(-1259.49, -281.17, 37.38),
            width = 2.0,
            length = 3.4,
            options = {
                heading = 21,
                --debugPoly=true,
                minZ = 36.38,
                maxZ = 38.58
            },
			data = {
                business = "bakery",
                inventory = {
                    invType = 87,
                    owner = "bakery-storage",
                },
			},
        },
    },
    Pickups = {
        {
            id = "bakery-pickup-1",
            coords = vector3(-1262.53, -290.64, 37.39),
            width = 1.0,
            length = 0.8,
            options = {
                heading = 21,
                --debugPoly=true,
                minZ = 36.59,
                maxZ = 37.99
            },
			data = {
                business = "bakery",
                inventory = {
                    invType = 25,
                    owner = "bakery-pickup-1",
                },
			},
        },
    },
    Warmers = {
    	{
    		id = "bakery-warmer-1",
    		coords = vector3(-1265.04, -279.81, 37.39),
    		length = 5.8,
    		width = 1.2,
    		options = {
                heading = 21,
                --debugPoly=true,
                minZ = 36.39,
                maxZ = 38.79
    		},
    		restrict = {
    			jobs = { "bakery" },
    		},
			data = {
                business = "bakery",
                inventory = {
                    invType = 88,
                    owner = "bakery-warmer-1",
                },
			},
    	},
        {
    		id = "bakery-warmer-2",
    		coords = vector3(-1259.47, -286.53, 37.38),
    		length = 5.0,
    		width = 1.0,
    		options = {
                heading = 21,
                --debugPoly=true,
                minZ = 36.38,
                maxZ = 38.78
    		},
    		restrict = {
    			jobs = { "bakery" },
    		},
			data = {
                business = "bakery",
                inventory = {
                    invType = 88,
                    owner = "bakery-warmer-2",
                },
			},
    	},
    },
})
