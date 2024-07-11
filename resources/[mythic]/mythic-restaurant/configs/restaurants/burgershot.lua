table.insert(Config.Restaurants, {
    Name = "Burger Shot",
    Job = "burgershot",
    Benches = {
        drinks = {
            label = "Drinks & Ice Cream",
            targeting = {
                actionString = "Preparing",
                icon = "kitchen-set",
                poly = {
                    coords = vector3(-1196.81, -894.8, 13.97),
                    w = 1.2,
                    l = 3.0,
                    options = {
                        heading = 35,
                        --debugPoly=true,
                        minZ = 12.97,
                        maxZ = 15.17
                    },
                },
            },
            recipes = {
                {
                    result = { name = "burgershot_drink", count = 1 },
                    items = {
                        { name = "burgershot_cup", count = 1 },
                    },
                    time = 0,
                },
                {
                    result = { name = "orangotang_icecream", count = 10 },
                    items = {
                        { name = "milk_can", count = 3 },
                        { name = "sugar", count = 1 },
                        { name = "orange", count = 10 },
                    },
                    time = 2500,
                },
                {
                    result = { name = "meteorite_icecream", count = 10 },
                    items = {
                        { name = "milk_can", count = 3 },
                        { name = "sugar", count = 1 },
                        { name = "chocolate_bar", count = 3 },
                    },
                    time = 2500,
                },
                {
                    result = { name = "mocha_shake", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "milk_can", count = 3 },
                        { name = "chocolate_bar", count = 1 },
                        { name = "coffee_beans", count = 3 },
                    },
                    time = 2500,
                },
            },
        },
        food = {
            label = "Food",
            targeting = {
                actionString = "Cooking",
                icon = "fire-burner",
                poly = {
                    coords = vector3(-1197.16, -898.86, 13.97),
                    w = 3.0,
                    l = 3.0,
                    options = {
                        heading = 35,
                        --debugPoly=true,
                        minZ = 12.97,
                        maxZ = 16.17
                    },
                },
            },
            recipes = {
                {
                    result = { name = "patty", count = 5 },
                    items = {
                        { name = "unk_meat", count = 10 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "pickle", count = 10 },
                    items = {
                        { name = "cucumber", count = 15 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "burger", count = 5 },
                    items = {
                        { name = "bun", count = 4 },
                        { name = "patty", count = 4 },
                        { name = "lettuce", count = 3 },
                        { name = "pickle", count = 6 },
                        { name = "tomato", count = 10 },
                        { name = "cheese", count = 5 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "double_shot_burger", count = 5 },
                    items = {
                        { name = "bun", count = 6 },
                        { name = "patty", count = 6 },
                        { name = "lettuce", count = 6 },
                        { name = "pickle", count = 6 },
                        { name = "tomato", count = 10 },
                        { name = "cheese", count = 5 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "tacos", count = 3 },
                    items = {
                        { name = "dough", count = 1 },
                        { name = "lettuce", count = 2 },
                        { name = "tomato", count = 4 },
                        { name = "beef", count = 2 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "heartstopper", count = 1 },
                    items = {
                        { name = "bun", count = 2 },
                        { name = "patty", count = 3 },
                        { name = "lettuce", count = 2 },
                        { name = "pickle", count = 3 },
                        { name = "tomato", count = 4 },
                        { name = "cheese", count = 5 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "the_simply_burger", count = 5 },
                    items = {
                        { name = "bun", count = 5 },
                        { name = "patty", count = 5 },
                        { name = "lettuce", count = 12 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "prickly_burger", count = 5 },
                    items = {
                        { name = "bun", count = 3 },
                        { name = "patty", count = 3 },
                        { name = "lettuce", count = 9 },
                        { name = "chicken", count = 9 },
                        { name = "cheese", count = 3 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "chicken_wrap", count = 3 },
                    items = {
                        { name = "dough", count = 1 },
                        { name = "lettuce", count = 1 },
                        { name = "cucumber", count = 3 },
                        { name = "tomato", count = 5 },
                        { name = "cheese", count = 1 },
                        { name = "chicken", count = 1 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "goat_cheese_wrap", count = 3 },
                    items = {
                        { name = "dough", count = 1 },
                        { name = "lettuce", count = 1 },
                        { name = "cucumber", count = 2 },
                        { name = "tomato", count = 3 },
                        { name = "cheese", count = 5 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "burgershot_fries", count = 5 },
                    items = {
                        { name = "potato", count = 10 },
                    },
                    time = 2000,
                },
            },
        },
    },
    Storage = {
        {
            id = "burgershot-freezer",
            type = "box",
            coords = vector3(-1200.18, -902.32, 13.97),
            width = 2.0,
            length = 4.6,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 12.97,
                maxZ = 15.97
            },
			data = {
                business = "burgershot",
                inventory = {
                    invType = 23,
                    owner = "burgershot-freezer",
                },
			},
        },
    },
    Pickups = {
        { -- Burger Shot
            id = "burgershot-pickup-1",
            coords = vector3(-1192.52, -896.71, 13.97),
            width = 1.2,
            length = 2.0,
            options = {
                heading = 304,
                --debugPoly=true,
                minZ = 13.57,
                maxZ = 15.17
            },
            data = {
                business = "burgershot",
                inventory = {
                    invType = 25,
                    owner = "burgershot-pickup-2",
                },
            },
        },
        { -- Burger Shot
            id = "burgershot-pickup-2",
            coords = vector3(-1193.63, -895.16, 13.97),
            width = 1.2,
            length = 1.6,
            options = {
                heading = 304,
                --debugPoly=true,
                minZ = 13.57,
                maxZ = 15.17
            },
			data = {
                business = "burgershot",
                inventory = {
                    invType = 25,
                    owner = "burgershot-pickup-2",
                },
			},
        },
        { -- Burger Shot
            id = "burgershot-pickup-3",
            coords = vector3(-1194.85, -893.42, 13.97),
            width = 1.2,
            length = 1.6,
            options = {
                heading = 304,
                --debugPoly=true,
                minZ = 13.57,
                maxZ = 15.17
            },
			data = {
                business = "burgershot",
                inventory = {
                    invType = 25,
                    owner = "burgershot-pickup-3",
                },
			},
        },
    },
    Warmers = {
        { -- Burger Shot
            id = "burgershot-warmer-1",
            coords = vector3(-1195.33, -897.62, 13.97),
            length = 1.6,
            width = 3.2,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 12.97,
                maxZ = 14.97
            },
            restrict = {
                jobs = { "burgershot" },
            },
			data = {
                business = "burgershot",
                inventory = {
                    invType = 24,
                    owner = "burgershot-warmer-1",
                },
			},
        },
    },
})