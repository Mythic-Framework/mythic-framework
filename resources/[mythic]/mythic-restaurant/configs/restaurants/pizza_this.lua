table.insert(Config.Restaurants, {
    Name = "Pizza This",
    Job = "pizza_this",
    Benches = {
        drinks = {
            label = "Drinks",
            targeting = {
                actionString = "Preparing",
                icon = "kitchen-set",
                poly = {
                    coords = vector3(810.74, -764.46, 26.78),
                    w = 1.0,
                    l = 2.0,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 25.78,
                        maxZ = 28.18
                    },
                },
            },
            recipes = {
                _genericRecipies.glass_cock,
                _genericRecipies.lemonade,
            },
        },
        drinksbar = {
            label = "Drinks",
            targeting = {
                actionString = "Preparing",
                icon = "kitchen-set",
                poly = {
                    coords = vector3(814.05, -749.35, 26.78),
                    w = 1.0,
                    l = 2.2,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 25.98,
                        maxZ = 28.78
                    },
                },
            },
            recipes = {
                _genericRecipies.glass_cock,
                _genericRecipies.lemonade,
                _cocktailRecipies.vodka_shot,
                _cocktailRecipies.whiskey_glass,
            },
        },
        pizza = {
            label = "Pizza Oven",
            targeting = {
                actionString = "Cooking",
                icon = "pizza-slice",
                poly = {
                    coords = vector3(813.97, -752.85, 26.78),
                    w = 2.0,
                    l = 2.0,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 25.78,
                        maxZ = 27.98
                    },
                },
            },
            recipes = {
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
                    result = { name = "san_manzano_pizza", count = 1 },
                    items = {
                        { name = "dough", count = 1 },
                        { name = "tomato", count = 5 },
                        { name = "lettuce", count = 4 },
                        { name = "cheese", count = 2 },
                    },
                    time = 3000,
                },
            },
        },
        food = {
            label = "Food",
            targeting = {
                actionString = "Cooking",
                icon = "pizza-slice",
                poly = {
                    coords = vector3(808.69, -761.17, 26.78),
                    w = 3.0,
                    l = 2.2,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 25.78,
                        maxZ = 28.38
                    },
                },
            },
            recipes = {
                {
                    result = { name = "pasta_fresca", count = 4 },
                    items = {
                        { name = "dough", count = 2 },
                        { name = "tomato", count = 6 },
                        { name = "lettuce", count = 4 },
                        { name = "cheese", count = 4 },
                    },
                    time = 4000,
                },
                {
                    result = { name = "pesto_cavatappi", count = 4 },
                    items = {
                        { name = "dough", count = 2 },
                        { name = "cheese", count = 4 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 4000,
                },
                {
                    result = { name = "spag_bowl", count = 4 },
                    items = {
                        { name = "dough", count = 1 },
                        { name = "cheese", count = 4 },
                        { name = "tomato", count = 6 },
                        { name = "beef", count = 3 },
                    },
                    time = 4000,
                },
                {
                    result = { name = "chips", count = 5 },
                    items = {
                        { name = "potato", count = 6 },
                    },
                    time = 3000,
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
            id = "pizza_this-freezer",
            type = "box",
            coords = vector3(802.49, -758.53, 26.78),
            width = 3.0,
            length = 3.6,
            options = {
                heading = 1,
                --debugPoly=true,
                minZ = 25.78,
                maxZ = 29.58
            },
			data = {
                business = "pizza_this",
                inventory = {
                    invType = 59,
                    owner = "pizza_this-freezer",
                },
			},
        },
        {
            id = "pizza_this-fridge",
            type = "box",
            coords = vector3(813.35, -749.39, 26.78),
            width = 1.0,
            length = 2.4,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.78,
                maxZ = 27.38
            },
			data = {
                business = "pizza_this",
                inventory = {
                    invType = 60,
                    owner = "pizza_this-fridge-1",
                },
			},
        },
        {
            id = "pizza_this-wine",
            type = "box",
            coords = vector3(809.33, -761.47, 22.3),
            width = 1.2,
            length = 2.2,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 21.3,
                maxZ = 23.3
            },
			data = {
                business = "pizza_this",
                inventory = {
                    invType = 77,
                    owner = "pizza_this-wine",
                },
			},
        },
    },
    Pickups = {
        {
            id = "pizza_this-pickup-1",
            coords = vector3(811.17, -750.84, 26.78),
            width = 1.0,
            length = 1.2,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 26.58,
                maxZ = 27.38
            },
			data = {
                business = "pizza_this",
                inventory = {
                    invType = 25,
                    owner = "pizza_this-pickup-1",
                },
			},
        },
        {
            id = "pizza_this-pickup-2",
            coords = vector3(811.17, -752.62, 26.78),
            width = 1.0,
            length = 1.2,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 26.58,
                maxZ = 27.38
            },
			data = {
                business = "pizza_this",
                inventory = {
                    invType = 25,
                    owner = "pizza_this-pickup-2",
                },
			},
        },
    },
    Warmers = {
        {
            id = "pizza_this-warmer-1",
            coords = vector3(811.69, -755.44, 26.78),
            width = 0.8,
            length = 2.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 26.58,
                maxZ = 27.38
            },
            restrict = {
                jobs = { "pizza_this" },
            },
			data = {
                business = "pizza_this",
                inventory = {
                    invType = 60,
                    owner = "pizza_this-warmer-1",
                },
			},
        },
        {
            id = "pizza_this-warmer-2",
            coords = vector3(806.0, -763.82, 26.78),
            width = 2.6,
            length = 1.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.78,
                maxZ = 28.18
            },
            restrict = {
                jobs = { "pizza_this" },
            },
			data = {
                business = "pizza_this",
                inventory = {
                    invType = 60,
                    owner = "pizza_this-warmer-2",
                },
			},
        },
    },
})
