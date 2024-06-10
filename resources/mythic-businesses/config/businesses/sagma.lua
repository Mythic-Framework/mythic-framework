table.insert(Config.Businesses, {
    Job = "sagma",
    Name = "San Andreas Gallery of Modern Art",
    Benches = {
        jewelry = {
            label = "",
            targeting = {
                actionString = "Making",
                manual = true
            },
            recipes = {
                {
                    result = { name = "rlg_chain", count = 1 },
                    items = {
                        { name = "goldbar", count = 10 },
                        { name = "silverbar", count = 10 },
                        { name = "diamond", count = 2 },
                        { name = "ruby", count = 2 },
                    },
                    time = 6500,
                },
                {
                    result = { name = "lss_chain", count = 1 },
                    items = {
                        { name = "goldbar", count = 10 },
                        { name = "silverbar", count = 10 },
                        { name = "diamond", count = 4 },
                    },
                    time = 6500,
                },
                {
                    result = { name = "ferrari_chain", count = 1 },
                    items = {
                        { name = "goldbar", count = 10 },
                        { name = "silverbar", count = 10 },
                        { name = "diamond", count = 4 },
                    },
                    time = 6500,
                },
                {
                    result = { name = "ssf_chain", count = 1 },
                    items = {
                        { name = "goldbar", count = 10 },
                        { name = "silverbar", count = 10 },
                        { name = "diamond", count = 2 },
                        { name = "amethyst", count = 2 },
                    },
                    time = 6500,
                },
                {
                    result = { name = "lust_chain", count = 1 },
                    items = {
                        { name = "goldbar", count = 10 },
                        { name = "silverbar", count = 10 },
                        { name = "diamond", count = 1 },
                        { name = "amethyst", count = 1 },
                        { name = "sapphire", count = 1 },
                        { name = "opal", count = 1 },
                    },
                    time = 6500,
                },
                {
                    result = { name = "mint_mate_chain", count = 1 },
                    items = {
                        { name = "goldbar", count = 10 },
                        { name = "silverbar", count = 10 },
                        { name = "diamond", count = 2 },
                        { name = "emerald", count = 2 },
                    },
                    time = 6500,
                },
                {
                    result = { name = "mint_mate_chain_2", count = 1 },
                    items = {
                        { name = "goldbar", count = 10 },
                        { name = "silverbar", count = 10 },
                        { name = "diamond", count = 2 },
                        { name = "emerald", count = 2 },
                    },
                    time = 6500,
                },
                {
                    result = { name = "snow_chain", count = 1 },
                    items = {
                        { name = "goldbar", count = 10 },
                        { name = "silverbar", count = 10 },
                        { name = "diamond", count = 2 },
                        { name = "opal", count = 2 },
                    },
                    time = 6500,
                },
            },
        },
    },
    Storage = {
        {
            id = "sagma-gem-storage-1",
            type = "box",
            coords = vector3(-469.44, 35.69, 46.23),
            length = 1.4,
            width = 1.4,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 45.23,
                maxZ = 47.63
            },
            data = {
                business = "sagma",
                inventory = {
                    invType = 134,
                    owner = "sagma-office-storage-1",
                },
            },
        },
        {
            id = "sagma-gem-storage-2",
            type = "box",
            coords = vector3(-469.33, 38.29, 46.23),
            length = 1.8,
            width = 1.2,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 45.23,
                maxZ = 47.83
            },
            data = {
                business = "sagma",
                inventory = {
                    invType = 133,
                    owner = "sagma-office-storage-2",
                },
            },
        },
        {
            id = "sagma-safe-1",
            type = "box",
            coords = vector3(-467.83, 47.58, 46.23),
            length = 1.8,
            width = 2.4,
            options = {
                heading = 354,
                --debugPoly=true,
                minZ = 45.23,
                maxZ = 48.03
            },
            data = {
                business = "sagma",
                inventory = {
                    invType = 133,
                    owner = "sagma-safe-1",
                },
            },
        },
        {
            id = "sagma-safe-2",
            type = "box",
            coords = vector3(-483.25, 63.12, 52.41),
            length = 1.6,
            width = 1.8,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 51.41,
                maxZ = 53.81
            },
            data = {
                business = "sagma",
                inventory = {
                    invType = 133,
                    owner = "sagma-safe-2",
                },
            },
        },
        {
            id = "sagma-storage-1",
            type = "box",
            coords = vector3(-467.29, 49.55, 52.41),
            length = 2.2,
            width = 1.6,
            options = {
                heading = 355,
                --debugPoly=true,
                minZ = 51.41,
                maxZ = 53.81
            },
            data = {
                business = "sagma",
                inventory = {
                    invType = 135,
                    owner = "sagma-storage-1",
                },
            },
        },
    },
    Pickups = {
        {
            id = "sagma-pickup-1",
            coords = vector3(-421.99, 30.28, 46.23),
            width = 1.0,
            length = 2.0,
            options = {
                heading = 310,
                --debugPoly=true,
                minZ = 45.23,
                maxZ = 47.83
            },
            data = {
                business = "sagma",
                inventory = {
                    invType = 25,
                    owner = "sagma-pickup-1",
                },
            },
        },
    },
})