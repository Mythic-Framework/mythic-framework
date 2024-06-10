table.insert(Config.Restaurants, {
    Name = "Tequi-La-La",
    Job = "tequila",
    Benches = {
        bar = {
            label = "Bar",
            targeting = {
                actionString = "Making",
                icon = "martini-glass-citrus",
                poly = {
                    coords = vector3(-562.94, 286.86, 82.18),
                    l = 3.0,
                    w = 1.0,
                    options = {
                        heading = 265,
                        --debugPoly=true,
                        minZ = 81.18,
                        maxZ = 82.98
                    },
                },
            },
            recipes = {
                _cocktailRecipies.raspberry_mimosa,
                _cocktailRecipies.pina_colada,
                _cocktailRecipies.bloody_mary,
                _cocktailRecipies.vodka_shot,
                _cocktailRecipies.whiskey_glass,
                --_cocktailRecipies.jaeger_bomb,
                _genericRecipies.glass_cock,
                _genericRecipies.lemonade,
                {
                    result = { name = "tequila_shot", count = 5 },
                    items = {
                        { name = "tequila", count = 1 },
                    },
                    time = 2000,
                },
                {
                    result = { name = "tequila_sunrise", count = 6 },
                    items = {
                        { name = "tequila", count = 1 },
                        { name = "orange", count = 5 },
                        { name = "raspberry", count = 1 },
                        { name = "raspberry_liqueur", count = 1 },
                    },
                    time = 2000,
                },
            },
        },
    },
    Storage = {
        {
            id = "tequilala-storage",
            type = "box",
            coords = vector3(-568.57, 291.2, 79.18),
            width = 1.6,
            length = 1.0,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 78.18,
                maxZ = 80.58
            },
			data = {
                business = "tequilala",
                inventory = {
                    invType = 81,
                    owner = "tequilala-storage",
                },
			},
        },
    },
    Pickups = {
        {
            id = "tequilala-pickup-1",
            coords = vector3(-560.79, 285.41, 82.18),
            width = 1.6,
            length = 1.6,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 81.78,
                maxZ = 83.18
            },
			data = {
                business = "tequilala",
                inventory = {
                    invType = 25,
                    owner = "tequilala-pickup-1",
                },
			},
        },
        {
            id = "tequilala-pickup-2",
            coords = vector3(-560.56, 288.01, 82.18),
            width = 1.6,
            length = 1.6,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 81.78,
                maxZ = 83.18
            },
			data = {
                business = "tequilala",
                inventory = {
                    invType = 25,
                    owner = "tequilala-pickup-2",
                },
			},
        },
    },
    Warmers = {
        {
            fridge = true,
            id = "tequilala-1",
            coords = vector3(-562.03, 290.0, 82.18),
            width = 2.0,
            length = 1.0,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 81.18,
                maxZ = 83.38
            },
            restrict = {
                jobs = { "tequila" },
            },
			data = {
                business = "tequilala",
                inventory = {
                    invType = 82,
                    owner = "tequilala-1",
                },
			},
        },
        {
            fridge = true,
            id = "tequilala-2",
            coords = vector3(-563.03, 284.55, 82.18),
            width = 0.8,
            length = 1.0,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 81.38,
                maxZ = 82.78
            },
            restrict = {
                jobs = { "tequila" },
            },
			data = {
                business = "tequilala",
                inventory = {
                    invType = 82,
                    owner = "tequilala-2",
                },
			},
        },
    },
})