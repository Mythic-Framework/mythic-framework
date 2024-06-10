table.insert(Config.Businesses, {
    Job = "securoserv",
    Name = "SecuroServ",
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
            id = "securoserv-storage",
            type = "box",
            coords = vector3(20.04, -100.54, 56.18),
            length = 1.0,
            width = 3.2,
            options = {
                heading = 70,
                --debugPoly=true,
                minZ = 55.18,
                maxZ = 57.98
            },
            data = {
                business = "securoserv",
                inventory = {
                    invType = 113,
                    owner = "securoserv-storage",
                },
            },
        },
    },
    Pickups = {
        -- {
        --     id = "digitalden-pickup-1",
        --     coords = vector3(384.19, -828.63, 29.3),
        --     width = 1.8,
        --     length = 0.8,
        --     options = {
        --         heading = 0,
        --         --debugPoly=true,
        --         minZ = 28.5,
        --         maxZ = 30.3
        --     },
        --     data = {
        --         business = "digitalden",
        --         inventory = {
        --             invType = 25,
        --             owner = "digitalden-pickup-1",
        --         },
        --     },
        -- },
    },
})