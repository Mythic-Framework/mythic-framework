table.insert(Config.Restaurants, 		{
    Name = "The Last Train",
    Job = "lasttrain",
    Benches = {
        drinks = {
            label = "Drinks",
            targeting = {
                actionString = "Preparing",
                icon = "whiskey-glass",
                poly = {
                    coords = vector3(-380.78, 270.12, 86.46),
                    w = 4.8,
                    l = 4.2,
                    options = {
                        heading = 305,
                        --debugPoly = true,
                        minZ = 86.41,
                        maxZ = 87.21
                    },
                },
            },
            recipes = {
                _genericRecipies.glass_cock,
                _genericRecipies.lemonade,
                _cocktailRecipies.vodka_shot,
                _cocktailRecipies.whiskey_glass,
                {
                    result = { name = "rootbeerfloat", count = 3 },
                    items = {
                        { name = "sugar", count = 1 },
                        { name = "water", count = 3 },
                        { name = "milk_can", count = 2 },
                        { name = "icing", count = 1 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "chocolate_shake", count = 4 },
                    items = {
                        { name = "sugar", count = 2 },
                        { name = "milk_can", count = 1 },
                        { name = "icing", count = 1 },
                        { name = "chocolate_bar", count = 3 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "milkshake", count = 4 },
                    items = {
                        { name = "sugar", count = 2 },
                        { name = "milk_can", count = 1 },
                        { name = "icing", count = 1 },
                        { name = "raspberry", count = 1 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "green_tea", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "tea_leaf", count = 4 },
                    },
                    time = 6000,
                },
                {
                    result = { name = "pint_mcdougles", count = 15 },
                    items = {
                        { name = "keg", count = 1 },
                    },
                    time = 3000,
                },
            },
        },
        food = {
            label = "Food",
            targeting = {
                actionString = "Cooking",
                icon = "fire-burner",
                poly = {
                    coords = vector3(-383.88, 262.59, 86.46),
                    w = 2.6,
                    l = 3.2,
                    options = {
                        heading = 305,
                        --debugPoly = true,
                        minZ = 85.71,
                        maxZ = 87.31
                    },
                },
            },
            recipes = {
                _genericRecipies.sandwich,
                _genericRecipies.sandwich_turkey,
                _genericRecipies.sandwich_beef,
                _genericRecipies.sandwich_blt,
                _genericRecipies.sandwich_crisp,
                {
                    result = { name = "chickenpotpie", count = 5 },
                    items = {
                        { name = "chicken", count = 2 },
                        { name = "dough", count = 4 },
                        { name = "peas", count = 10 },
                        { name = "potato", count = 2 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "chickenfriedsteak", count = 5 },
                    items = {
                        { name = "chicken", count = 2 },
                        { name = "potato", count = 3 },
                        { name = "lettuce", count = 2 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "salisbury_steak", count = 5 },
                    items = {
                        { name = "beef", count = 4 },
                        { name = "chips", count = 2 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "baconeggbiscuit", count = 5 },
                    items = {
                        { name = "unk_meat", count = 4 },
                        { name = "dough", count = 2 },
                        { name = "cheese", count = 2 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "sloppyjoe", count = 5 },
                    items = {
                        { name = "unk_meat", count = 2 },
                        { name = "beef", count = 2 },
                        { name = "loaf", count = 1 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "chips", count = 5 },
                    items = {
                        { name = "potato", count = 5 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "sandwich_chips", count = 5 },
                    items = {
                        { name = "loaf", count = 1 },
                        { name = "chips", count = 1 },
                    },
                    time = 2000,
                },
            },
        },
    },
    Storage = {
        {
            id = "lasttrain-freezer",
            type = "box",
            coords = vector3(-383.95, 265.61, 86.46),
            width = 1.4,
            length = 0.8,
            options = {
                heading = 305,
                --debugPoly = true,
                minZ = 85.0,
                maxZ = 87.66
            },
			data = {
                business = "lasttrain",
                inventory = {
                    invType = 31,
                    owner = "lasttrain-freezer",
                },
			},
        },
    },
    Pickups = {
        {
            id = "lasttrain-pickup-1",
            coords = vector3(-380.74, 266.21, 86.46),
            width = 1.8,
            length = 1.4,
            options = {
                heading = 305,
                --debugPoly = true,
                minZ = 86.46,
                maxZ = 87.26
            },
			data = {
                business = "lasttrain",
                inventory = {
                    invType = 25,
                    owner = "lasttrain-pickup-1",
                },
			},
        },
    },
    Warmers = {
        {
            id = "lasttrain-warmer-1",
            coords = vector3(-379.15, 267.83, 86.46),
            width = 2.4,
            length = 0.8,
            options = {
                heading = 305,
                --debugPoly = true,
                minZ = 85.41,
                maxZ = 87.01
            },
            restrict = {
                jobs = { "lasttrain" },
            },
			data = {
                business = "lasttrain",
                inventory = {
                    invType = 30,
                    owner = "lasttrain-warmer-1",
                },
			},
        },
    },
})
