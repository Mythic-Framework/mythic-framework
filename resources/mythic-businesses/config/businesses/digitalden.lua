table.insert(Config.Businesses, {
    Job = "digitalden",
    Name = "Digital Den",
    Benches = {
        regular = {
            label = "Make Electronics",
            targeting = {
                actionString = "Making",
                icon = "microchip",
                poly = {
                    coords = vector3(377.86, -820.56, 29.3),
                    w = 2.8,
                    l = 1.4,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 28.3,
                        maxZ = 29.5
                    },
                },
            },
            recipes = {
                {
                    result = { name = "radio_shitty", count = 1 },
                    items = {
                        { name = "electronic_parts", count = 2 },
                        { name = "plastic", count = 5 },
                        { name = "copperwire", count = 1 },
                        { name = "glue", count = 2 },
                    },
                    time = 6500,
                },
                {
                    result = { name = "phone", count = 1 },
                    items = {
                        { name = "electronic_parts", count = 1 },
                        { name = "plastic", count = 2 },
                        { name = "glue", count = 1 },
                    },
                    time = 2000,
                },
            },
        },
    },
    Storage = {
        {
            id = "digitalden-storage",
            type = "box",
            coords = vector3(382.66, -830.16, 29.3),
            width = 1.4,
            length = 1.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 28.3,
                maxZ = 30.9
            },
            data = {
                business = "digitalden",
                inventory = {
                    invType = 100,
                    owner = "digitalden-storage",
                },
            },
        },
        {
            id = "digitalden-storage-2",
            type = "box",
            coords = vector3(382.15, -818.72, 29.3),
            width = 3.6,
            length = 3.6,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 28.3,
                maxZ = 30.7
            },
            data = {
                business = "digitalden",
                inventory = {
                    invType = 101,
                    owner = "digitalden-storage-2",
                },
            },
        },
        {
            id = "digitalden-storage-3",
            type = "box",
            coords = vector3(374.35, -818.37, 29.3),
            width = 2.0,
            length = 2.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 28.3,
                maxZ = 30.7
            },
            data = {
                business = "digitalden",
                inventory = {
                    invType = 101,
                    owner = "digitalden-storage-3",
                },
            },
        },
    },
    Pickups = {
        {
            id = "digitalden-pickup-1",
            coords = vector3(384.19, -828.63, 29.3),
            width = 1.8,
            length = 0.8,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 28.5,
                maxZ = 30.3
            },
            data = {
                business = "digitalden",
                inventory = {
                    invType = 25,
                    owner = "digitalden-pickup-1",
                },
            },
        },
    },
})