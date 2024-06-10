-- 69

PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["office2"] = {
    type = "office",
    price = 300000,
    info = {
        name = "Luxury Office",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(-1578.138, -563.817, 108.523),
            heading = 126.474,
            polyzone = {
                center = vector3(-1579.69, -562.97, 108.52),
                length = 3.4,
                width = 5.0,
                options = {
                    heading = 305,
                    --debugPoly=true,
                    minZ = 107.52,
                    maxZ = 110.12
                }
            }
        },
        back = {
            coords = vector3(-1584.088, -559.739, 108.523),
            heading = 304.464,
            polyzone = {
                center = vector3(-1584.28, -559.79, 108.52),
                length = 1.8,
                width = 1.0,
                options = {
                    heading = 36,
                    --debugPoly=true,
                    minZ = 107.52,
                    maxZ = 109.92
                }
            }
        },
        office = {
            coords = vector3(-1570.94, -573.87, 108.52),
            heading = 0.0,
            polyzone = {
                center = vector3(-1570.94, -573.87, 108.52),
                length = 2.0,
                width = 1.2,
                options = {
                    heading = 306,
                    --debugPoly=true,
                    minZ = 108.12,
                    maxZ = 109.32
                }
            }
        }
    },
    -- zone = {
    --     center = vector3(290.6, 127.44, 129.06),
    --     length = 13.4,
    --     width = 15.6,
    --     options = {
    --         heading = 340,
    --         --debugPoly=true,
    --         minZ = 127.46,
    --         maxZ = 131.86
    --     }
    -- },
    defaultFurniture = {},
    cameras = {
        {
            name = "Hallway",
            coords = vec3(-1583.416260, -557.586060, 110.333450),
            rotation = vec3(-14.243401, 0.000000, 214.754852),
        },
        {
            name = "Reception",
            coords = vec3(-1575.217407, -569.158508, 110.375397),
            rotation = vec3(-14.243403, 0.000000, 214.557953),
        },
        {
            name = "Meeting",
            coords = vec3(-1573.338013, -591.556702, 110.570473),
            rotation = vec3(-14.637112, 0.000000, 339.479248),
        },
        {
            name = "Desk",
            coords = vec3(-1573.338013, -591.556702, 110.570473),
            rotation = vec3(-1559.515137, -580.462585, 110.800613),
        },
        {
            name = "Changing Area",
            coords = vec3(-1566.505127, -568.264954, 109.623161),
            rotation = vec3(-9.952082, 0.000000, 216.723450),
        },
    }
}