table.insert(Config.Restaurants, {
    Name = "Rockford Records Bar",
    Job = "rockford_records",
    Benches = {
    	bar = {
            label = "Bar",
            targeting = {
                actionString = "Making",
                icon = "martini-glass-citrus",
    			poly = {
    				coords = vector3(-995.74, -256.04, 39.04),
    				w = 1.8,
    				l = 1.0,
    				options = {
                        heading = 55,
                        --debugPoly=true,
                        minZ = 38.04,
                        maxZ = 40.64
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
            id = "rockford_records-storage",
            type = "box",
            coords = vector3(-984.61, -263.24, 38.47),
            length = 1.8,
            width = 6.0,
            options = {
                heading = 297,
                --debugPoly=true,
                minZ = 37.47,
                maxZ = 40.87
            },
			data = {
                business = "rockford_records",
                inventory = {
                    invType = 109,
                    owner = "rockford_records-storage",
                },
			},
        },
    },
    Pickups = {
        {
            id = "rockford_records-pickup-1",
            coords = vector3(-996.79, -259.17, 39.04),
            width = 1.2,
            length = 1.6,
            options = {
                heading = 325,
                --debugPoly=true,
                minZ = 38.44,
                maxZ = 40.24
            },
			data = {
                business = "rockford_records",
                inventory = {
                    invType = 25,
                    owner = "rockford_records-pickup-1",
                },
			},
        },
        {
            id = "rockford_records-pickup-2",
            coords = vector3(-998.34, -257.11, 39.04),
            width = 1.2,
            length = 1.6,
            options = {
                heading = 285,
                --debugPoly=true,
                minZ = 38.44,
                maxZ = 40.24
            },
			data = {
                business = "rockford_records",
                inventory = {
                    invType = 25,
                    owner = "rockford_records-pickup-1",
                },
			},
        },
    },
    Warmers = {
        {
            fridge = true,
            id = "rockford_records-1",
            coords = vector3(-994.04, -257.81, 39.04),
            width = 1.2,
            length = 1.2,
            options = {
                heading = 325,
                --debugPoly=true,
                minZ = 38.04,
                maxZ = 40.64
            },
            restrict = {
                jobs = { "rockford_records" },
            },
			data = {
                business = "rockford_records",
                inventory = {
                    invType = 110,
                    owner = "rockford_records-1",
                },
			},
        },
        {
            fridge = true,
            id = "rockford_records-2",
            coords = vector3(-995.04, -259.43, 39.04),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 325,
                --debugPoly=true,
                minZ = 38.04,
                maxZ = 39.44
            },
            restrict = {
                jobs = { "rockford_records" },
            },
			data = {
                business = "rockford_records",
                inventory = {
                    invType = 110,
                    owner = "rockford_records-2",
                },
			},
        },
    },
})