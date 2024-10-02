table.insert(Config.Restaurants, {
    Name = "UwU Cafe",
    Job = "uwu",
    Benches = {
        drinks = {
            label = "Hot Drinks",
            targeting = {
                actionString = "Preparing",
                icon = "mug-hot",
                poly = {
                    coords = vector3(-586.98, -1061.91, 22.34),
                    w = 0.8,
                    l = 0.8,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 22.14,
                        maxZ = 22.94
                    },
                },
            },
            recipes = {
                {
                    result = { name = "iced_coffee", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "coffee_beans", count = 1 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "matcha_latte", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "tea_leaf", count = 2 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "pumpkinspiced_latte", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "coffee_beans", count = 1 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "cat_tuccino", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "coffee_beans", count = 3 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "booba_tea", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "tea_leaf", count = 2 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "green_tea", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "tea_leaf", count = 4 },
                    },
                    time = 6000,
                },
            },
        },
        oven = {
            label = "Oven",
            targeting = {
                actionString = "Baking",
                icon = "cake-candles",
                poly = {
                    coords = vector3(-590.9, -1059.56, 22.34),
                    w = 1.6,
                    l = 1.0,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 21.34,
                        maxZ = 23.94
                    },
                },
            },
            recipes = {
                {
                    result = { name = "homemade_cookie", count = 12 },
                    items = {
                        { name = "dough", count = 1 },
                        { name = "sugar", count = 2 },
                        { name = "icing", count = 1 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "choclate_pancakes", count = 6 },
                    items = {
                        { name = "milk_can", count = 3 },
                        { name = "sugar", count = 3 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "apple_crumble", count = 3 },
                    items = {
                        { name = "dough", count = 3 },
                        { name = "sugar", count = 6 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "cat_donut", count = 6 },
                    items = {
                        { name = "dough", count = 2 },
                        { name = "sugar", count = 2 },
                        { name = "icing", count = 2 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "cat_cupcake", count = 6 },
                    items = {
                        { name = "dough", count = 2 },
                        { name = "sugar", count = 2 },
                        { name = "icing", count = 4 },
                    },
                    time = 2000,
                },
            },
        },
        food = {
            label = "Food",
            targeting = {
                actionString = "Preparing",
                icon = "bread-slice",
                poly = {
                    coords = vector3(-591.13, -1063.23, 22.36),
                    w = 2.6,
                    l = 0.8,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 21.36,
                        maxZ = 23.96
                    },
                },
            },
            recipes = {
                _genericRecipies.salad,
                {
                    result = { name = "frozen_yoghurt", count = 4 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "milk_can", count = 1 },
                        { name = "sugar", count = 1 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "fruit_explosion", count = 4 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "milk_can", count = 1 },
                        { name = "sugar", count = 8 },
                        { name = "orange", count = 10 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "fresh_lemonade", count = 5 },
                    items = {
                        { name = "plastic_cup", count = 5 },
                        { name = "orange", count = 15 },
                    },
                    time = 2000,
                },
                _genericRecipies.sandwich,
                _genericRecipies.sandwich_turkey,
                _genericRecipies.sandwich_beef,
                _genericRecipies.sandwich_blt,
                _genericRecipies.sandwich_crisp,
            },
        },
        other = {
            label = "Arts & Crafts",
            targeting = {
                actionString = "Preparing",
                icon = "paintbrush",
                poly = {
                    coords = vector3(-596.06, -1052.47, 22.34),
                    w = 1.0,
                    l = 2.0,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 21.94,
                        maxZ = 23.34
                    },
                },
            },
            recipes = {
                {
                    result = { name = "uwu_prize_box", count = 3 },
                    items = {
                        { name = "plastic", count = 15 },
                        { name = "cloth", count = 5 },
                    },
                    time = 1000,
                },
            },
        },
    },
    Storage = {
        {
            id = "uwu-freezer",
            type = "box",
            coords = vector3(-589.43, -1066.88, 22.34),
            width = 3.8,
            length = 3.8,
            options = {
                heading = 0,
                --debugPoly = true,
                minZ = 21.34,
                maxZ = 23.94
            },
			data = {
                business = "uwu",
                inventory = {
                    invType = 57,
                    owner = "uwu-freezer",
                },
			},
        },
    },
    Pickups = {
        {
            id = "uwu-pickup-1",
            coords = vector3(-584.01, -1062.1, 22.34),
            width = 0.8,
            length = 0.6,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 22.34,
                maxZ = 22.94
            },
			data = {
                business = "uwu",
                inventory = {
                    invType = 25,
                    owner = "uwu-pickup-1",
                },
			},
        },
        {
            id = "uwu-pickup-2",
            coords = vector3(-584.02, -1059.26, 22.34),
            width = 0.8,
            length = 0.6,
            options = {
                heading = 270,
                --debugPoly=true,
                minZ = 22.34,
                maxZ = 22.94
            },
			data = {
                business = "uwu",
                inventory = {
                    invType = 25,
                    owner = "uwu-pickup-2",
                },
			},
        },
        {
            id = "uwu-pickup-3",
            coords = vector3(-586.62, -1062.95, 22.34),
            width = 0.8,
            length = 0.6,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 22.34,
                maxZ = 22.94
            },
			data = {
                business = "uwu",
                inventory = {
                    invType = 25,
                    owner = "uwu-pickup-3",
                },
			},
        },
    },
    Warmers = {
        {
            id = "uwu-warmer-1",
            coords = vector3(-587.23, -1059.64, 22.36),
            width = 2.2,
            length = 0.8,
            options = {
                heading = 0,
                --debugPoly = true,
                minZ = 22.16,
                maxZ = 22.96
            },
            restrict = {
                jobs = { "uwu" },
            },
			data = {
                business = "uwu",
                inventory = {
                    invType = 58,
                    owner = "uwu-warmer-1",
                },
			},
        },
    },
})
