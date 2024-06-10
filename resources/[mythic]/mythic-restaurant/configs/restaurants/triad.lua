table.insert(Config.Restaurants, {
    Name = "Triad Records Bar",
    Job = "triad",
    Benches = {
    	bar = {
            label = "Bar",
            targeting = {
                actionString = "Making",
                icon = "martini-glass-citrus",
    			poly = {
    				coords = vector3(-828.54, -730.53, 28.06),
    				w = 1.2,
    				l = 2.6,
    				options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 27.06,
                        maxZ = 29.06
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
    		},
    	},
    },
    Storage = {
        {
            id = "triad-storage",
            type = "box",
            coords = vector3(-810.51, -733.09, 23.78),
            width = 5,
            length = 5,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 22.78,
                maxZ = 25.98
            },
			data = {
                business = "triad",
                inventory = {
                    invType = 98,
                    owner = "triad-storage",
                },
			},
        },
    },
    Pickups = {
        {
            id = "triad-pickup-1",
            coords = vector3(-828.37, -727.79, 28.06),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 27.66,
                maxZ = 29.06
            },
			data = {
                business = "triad",
                inventory = {
                    invType = 25,
                    owner = "triad-pickup-1",
                },
			},
        },
    },
    Warmers = {
        {
            fridge = true,
            id = "triad-1",
            coords = vector3(-826.09, -729.23, 28.06),
            width = 1.6,
            length = 1.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 27.06,
                maxZ = 28.46
            },
            restrict = {
                jobs = { "triad" },
            },
			data = {
                business = "triad",
                inventory = {
                    invType = 96,
                    owner = "triad-1",
                },
			},
        },
        {
            fridge = true,
            id = "triad-2",
            coords = vector3(-831.43, -730.5, 28.06),
            width = 0.8,
            length = 1.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 26.86,
                maxZ = 29.06
            },
            restrict = {
                jobs = { "triad" },
            },
			data = {
                business = "triad",
                inventory = {
                    invType = 96,
                    owner = "triad-2",
                },
			},
        },
    },
})