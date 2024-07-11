table.insert(Config.Restaurants, {
    Name = "Cafe Prego",
    Job = "prego",
    Benches = {
        drinks = {
            label = "Drinks",
            targeting = {
                actionString = "Preparing",
                icon = "kitchen-set",
                poly = {
                    coords = vector3(-1117.32, -1455.51, 5.11),
                    w = 0.8,
                    l = 2.8,
                    options = {
                        heading = 35,
                        --debugPoly=true,
                        minZ = 4.71,
                        maxZ = 6.71
                    },
                },
            },
            recipes = {
                _genericRecipies.glass_cock,
                _genericRecipies.lemonade,
                _genericRecipies.glass_cock,
                _genericRecipies.lemonade,
                _cocktailRecipies.vodka_shot,
                _cocktailRecipies.whiskey_glass,
                {
                    result = { name = "expresso", count = 3 },
                    items = {
                        { name = "coffee_beans", count = 5 },
                    },
                    time = 5000,
                },
            },
        },
        food = {
            label = "Make Food",
            targeting = {
                actionString = "Cooking",
                icon = "pizza",
                poly = {
                    coords = vector3(-1117.4, -1452.97, 5.11),
                    l = 1.0,
                    w = 3.2,
                    options = {
                        heading = 35,
                        --debugPoly=true,
                        minZ = 4.51,
                        maxZ = 6.31
                    },
                },
            },
            recipes = {
                {
                    result = { name = "fettuccini_alfredo", count = 4 },
                    items = {
                        { name = "dough", count = 2 },
                        { name = "flour", count = 6 },
                        { name = "lettuce", count = 4 },
                        { name = "cheese", count = 4 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "ravioli", count = 4 },
                    items = {
                        { name = "dough", count = 2 },
                        { name = "cheese", count = 4 },
                        { name = "flour", count = 3 },
                        { name = "milk_can", count = 1 },
                        { name = "tomato", count = 2 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "pepperoni_pizza", count = 1 },
                    items = {
                        { name = "dough", count = 1 },
                        { name = "tomato", count = 5 },
                        { name = "unk_meat", count = 5 },
                        { name = "cheese", count = 1 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "margherita_pizza", count = 1 },
                    items = {
                        { name = "dough", count = 1 },
                        { name = "tomato", count = 5 },
                        { name = "cheese", count = 2 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "chips", count = 5 },
                    items = {
                        { name = "potato", count = 6 },
                    },
                    time = 3000,
                },
                {
                    result = { name = "tiramisu", count = 8 },
                    items = {
                        { name = "milk_can", count = 3 },
                        { name = "sugar", count = 1 },
                        { name = "chocolate_bar", count = 3 },
                    },
                    time = 1500,
                },
                _genericRecipies.sandwich,
                _genericRecipies.sandwich_turkey,
                _genericRecipies.sandwich_beef,
                _genericRecipies.sandwich_blt,
            },
        },
    },
    Storage = {
        {
            id = "prego-freezer",
            type = "box",
            coords = vector3(-1124.56, -1458.42, 5.11),
            length = 1.4,
            width = 2.4,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 4.11,
                maxZ = 6.51
            },
			data = {
                business = "prego",
                inventory = {
                    invType = 128,
                    owner = "prego-freezer",
                },
			},
        },
        {
            id = "prego-fridge",
            type = "box",
            coords = vector3(-1119.02, -1452.57, 5.11),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 30,
                --debugPoly=true,
                minZ = 4.11,
                maxZ = 6.31
            },
			data = {
                business = "prego",
                inventory = {
                    invType = 129,
                    owner = "prego-fridge-1",
                },
			},
        },
        {
            id = "prego-wine",
            type = "box",
            coords = vector3(-1120.07, -1456.97, 2.03),
            width = 1.2,
            length = 1.2,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 1.03,
                maxZ = 3.43
            },
			data = {
                business = "prego",
                inventory = {
                    invType = 130,
                    owner = "prego-wine",
                },
			},
        },
    },
    Pickups = {
        {
            id = "prego-pickup-1",
            coords = vector3(-1117.37, -1457.06, 5.11),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 4.71,
                maxZ = 5.91
            },
			data = {
                business = "prego",
                inventory = {
                    invType = 25,
                    owner = "prego-pickup-1",
                },
			},
        },
        {
            id = "prego-pickup-2",
            coords = vector3(-1115.56, -1455.0, 5.11),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 4.71,
                maxZ = 5.91
            },
			data = {
                business = "prego",
                inventory = {
                    invType = 25,
                    owner = "prego-pickup-2",
                },
			},
        },
    },
    Warmers = {
        {
            id = "prego-warmer-1",
            coords = vector3(-1119.54, -1453.37, 5.11),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 4.51,
                maxZ = 5.91
            },
            restrict = {
                jobs = { "prego" },
            },
			data = {
                business = "prego",
                inventory = {
                    invType = 129,
                    owner = "prego-warmer-1",
                },
			},
        },
    },
})