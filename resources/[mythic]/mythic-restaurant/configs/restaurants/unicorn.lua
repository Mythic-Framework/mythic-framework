table.insert(Config.Restaurants, {
    Name = "Vanilla Unicorn",
    Job = "unicorn",
    Benches = {
        bar = {
            label = "Bar",
            targeting = {
                actionString = "Making",
                icon = "martini-glass-citrus",
                poly = {
                    coords = vector3(131.03, -1282.28, 29.27),
                    w = 2.2,
                    l = 1.2,
                    options = {
                        heading = 30,
                        --debugPoly=true,
                        minZ = 28.87,
                        maxZ = 30.47
                    },
                },
            },
            recipes = {
                _cocktailRecipies.raspberry_mimosa,
                _cocktailRecipies.pina_colada,
                _cocktailRecipies.bloody_mary,
                _cocktailRecipies.vodka_shot,
                _cocktailRecipies.whiskey_glass,
                _cocktailRecipies.jaeger_bomb,
                _genericRecipies.glass_cock,
                _genericRecipies.lemonade,
            },
        },
    },
    Storage = {
        {
            id = "unicorn-storage",
            type = "box",
            coords = vector3(132.78, -1287.97, 29.27),
            width = 2.0,
            length = 1.0,
            options = {
                heading = 300,
                --debugPoly=true,
                minZ = 28.27,
                maxZ = 30.67
            },
			data = {
                business = "unicorn",
                inventory = {
                    invType = 83,
                    owner = "unicorn-storage",
                },
			},
        },
    },
    Pickups = {
        {
            id = "unicorn-pickup-1",
            coords = vector3(129.3, -1285.58, 29.27),
            width = 0.8,
            length = 1.0,
            options = {
                heading = 30,
                --debugPoly=true,
                minZ = 28.87,
                maxZ = 29.87
            },
			data = {
                business = "unicorn",
                inventory = {
                    invType = 25,
                    owner = "unicorn-pickup-1",
                },
			},
        },
        {
            id = "unicorn-pickup-2",
            coords = vector3(127.97, -1283.19, 29.27),
            width = 0.8,
            length = 1.0,
            options = {
                heading = 30,
                --debugPoly=true,
                minZ = 28.87,
                maxZ = 29.87
            },
			data = {
                business = "unicorn",
                inventory = {
                    invType = 25,
                    owner = "unicorn-pickup-2",
                },
			},
        },
        {
            id = "unicorn-pickup-3",
            coords = vector3(127.0, -1281.7, 29.27),
            width = 0.8,
            length = 1.0,
            options = {
                heading = 30,
                --debugPoly=true,
                minZ = 28.87,
                maxZ = 29.87
            },
			data = {
                business = "unicorn",
                inventory = {
                    invType = 25,
                    owner = "unicorn-pickup-3",
                },
			},
        },
    },
    Warmers = {
        {
            fridge = true,
            id = "unicorn-1",
            coords = vector3(130.02, -1280.64, 29.27),
            width = 1.2,
            length = 1.0,
            options = {
                heading = 30,
                --debugPoly=true,
                minZ = 28.27,
                maxZ = 29.47
            },
            restrict = {
                jobs = { "unicorn" },
            },
			data = {
                business = "unicorn",
                inventory = {
                    invType = 84,
                    owner = "unicorn-1",
                },
			},
        },
        {
            fridge = true,
            id = "unicorn-2",
            coords = vector3(132.77, -1285.38, 29.27),
            width = 1.2,
            length = 1.0,
            options = {
                heading = 30,
                --debugPoly=true,
                minZ = 28.27,
                maxZ = 29.47
            },
            restrict = {
                jobs = { "unicorn" },
            },
			data = {
                business = "unicorn",
                inventory = {
                    invType = 84,
                    owner = "unicorn-2",
                },
			},
        },
    },
})