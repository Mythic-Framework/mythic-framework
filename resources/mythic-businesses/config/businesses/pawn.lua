table.insert(Config.Businesses, {
    Job = "ferrari_pawn",
    Name = "Ferrari Pawn",
    Benches = {
        -- regular = {
        --     label = "Make Electronics",
        --     targeting = {
        --         actionString = "Making",
        --         icon = "microchip",
        --         poly = {
        --             coords = vector3(377.86, -820.56, 29.3),
        --             w = 2.8,
        --             l = 1.4,
        --             options = {
        --                 heading = 0,
        --                 --debugPoly=true,
        --                 minZ = 28.3,
        --                 maxZ = 29.5
        --             },
        --         },
        --     },
        --     recipes = {
        --         {
        --             result = { name = "radio_shitty", count = 1 },
        --             items = {
        --                 { name = "electronic_parts", count = 2 },
        --                 { name = "plastic", count = 5 },
        --                 { name = "copperwire", count = 1 },
        --                 { name = "glue", count = 2 },
        --             },
        --             time = 6500,
        --         },
        --         {
        --             result = { name = "phone", count = 1 },
        --             items = {
        --                 { name = "electronic_parts", count = 1 },
        --                 { name = "plastic", count = 2 },
        --                 { name = "glue", count = 1 },
        --             },
        --             time = 2000,
        --         },
        --     },
        -- },
    },
    Storage = {
        {
            id = "pawn-storage",
            type = "box",
            coords = vector3(158.2, -1314.69, 29.36),
            length = 3.6,
            width = 5.0,
            options = {
                heading = 334,
                --debugPoly=true,
                minZ = 28.36,
                maxZ = 31.36
            },
            data = {
                business = "ferrari_pawn",
                inventory = {
                    invType = 117,
                    owner = "ferrari_pawn-storage",
                },
            },
        },
    },
    Pickups = {
        {
            id = "pawn-pickup-1",
            coords = vector3(174.04, -1322.51, 29.36),
            width = 1.0,
            length = 1.0,
            options = {
                heading = 332,
                --debugPoly=true,
                minZ = 28.76,
                maxZ = 30.16
            },
            data = {
                business = "ferrari_pawn",
                inventory = {
                    invType = 136,
                    owner = "ferrari_pawn-pickup-1",
                },
            },
        },
    },
})