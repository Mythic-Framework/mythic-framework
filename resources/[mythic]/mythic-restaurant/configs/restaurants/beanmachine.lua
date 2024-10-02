table.insert(Config.Restaurants, {
    Name = "Bean Machine",
    Job = "beanmachine",
    Benches = {
        food = {
            label = "Food",
            targeting = {
                actionString = "Preparing",
                icon = "bread-slice",
                poly = {
                    coords = vector3(121.6, -1038.57, 29.28),
                    w = 1.8,
                    l = 0.8,
                    options = {
                        heading = 340,
                        --debugPoly=true,
                        minZ = 28.28,
                        maxZ = 30.08
                    },
                },
            },
            recipes = {
                _genericRecipies.sandwich,
                _genericRecipies.sandwich_turkey,
                _genericRecipies.sandwich_beef,
                _genericRecipies.sandwich_blt,
                _genericRecipies.salad,
                {
                    result = { name = "carrot_cake", count = 4 },
                    items = {
                        { name = "icing", count = 1 },
                        { name = "sugar", count = 3 },
                        { name = "dough", count = 1 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "blueberry_muffin", count = 6 },
                    items = {
                        { name = "sugar", count = 3 },
                        { name = "dough", count = 1 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "chocy_muff", count = 6 },
                    items = {
                        { name = "sugar", count = 4 },
                        { name = "dough", count = 1 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "million_shrtbread", count = 10 },
                    items = {
                        { name = "sugar", count = 4 },
                        { name = "dough", count = 1 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 5000,
                },
            },
        },
        coffee = {
            label = "Coffee Machine",
            targeting = {
                actionString = "Preparing",
                icon = "mug-hot",
                poly = {
                    coords = vector3(124.04, -1039.23, 29.28),
                    w = 6.2,
                    l = 1.0,
                    options = {
                        heading = 340,
                        --debugPoly=true,
                        minZ = 28.28,
                        maxZ = 30.28
                    },
                },
            },
            recipes = {
                {
                    result = { name = "beanmachine", count = 3 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "coffee_beans", count = 3 },
                        { name = "milk_can", count = 1 },
                    },
                    time = 5000,
                },
                {
                    result = { name = "expresso", count = 3 },
                    items = {
                        { name = "coffee_beans", count = 5 },
                    },
                    time = 5000,
                },
            },
        },
        colddrinks = {
            label = "Drinks Machine",
            targeting = {
                actionString = "Preparing",
                icon = "kitchen-set",
                poly = {
                    coords = vector3(123.46, -1042.84, 29.28),
                    w = 0.8,
                    l = 1.8,
                    options = {
                        heading = 340,
                        --debugPoly=true,
                        minZ = 28.28,
                        maxZ = 31.08
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
                {
                    result = { name = "smoothie_veg", count = 3 },
                    items = {
                        { name = "plastic_cup", count = 1 },
                        { name = "lettuce", count = 4 },
                        { name = "peas", count = 10 },
                        { name = "cucumber", count = 4 },
                        { name = "sugar", count = 1 },
                    },
                    time = 5000,
                },
            },
        },
    },
    Storage = {
        {
            id = "beanmachine-fridge",
            type = "box",
            coords = vector3(123.59, -1039.2, 29.28),
            width = 2.0,
            length = 2.0,
            options = {
                heading = 340,
                --debugPoly=true,
                minZ = 28.08,
                maxZ = 30.28
            },
			data = {
                business = "beanmachine",
                inventory = {
                    invType = 79,
                    owner = "beanmachine-fridge",
                },
			},
        },
    },
    Pickups = {
        {
            id = "beanmachine-pickup-1",
            coords = vector3(121.87, -1037.29, 29.28),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 340,
                --debugPoly=true,
                minZ = 29.08,
                maxZ = 30.08
            },
			data = {
                business = "beanmachine",
                inventory = {
                    invType = 25,
                    owner = "beanmachine-pickup-1",
                },
			},
        },
        {
            id = "beanmachine-pickup-2",
            coords = vector3(120.59, -1040.88, 29.28),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 340,
                --debugPoly=true,
                minZ = 29.08,
                maxZ = 30.08
            },
			data = {
                business = "beanmachine",
                inventory = {
                    invType = 25,
                    owner = "beanmachine-pickup-2",
                },
			},
        },
    },
})
