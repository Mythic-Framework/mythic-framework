PropertyInteriors = PropertyInteriors or {}

-- 101

PropertyInteriors["warehouse_med"] = {
    type = "warehouse",
    price = 500000,
    info = {
        name = "Warehouse Medium",
        description = "It's a Warehouse",
    },
    inventoryOverride = 1011,
    locations = {
        front = {
            coords = vector3(1048.231, -3097.037, -39.000),
            heading = 267.443,
            polyzone = {
                center = vector3(1047.84, -3097.13, -39.0),
                length = 1.4,
                width = 0.4,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -37.6
                }
            }
        },
        warehouse = {
            coords = vector3(1048.26, -3100.67, -39.0),
            heading = 0.0,
            polyzone = {
                center = vector3(1048.26, -3100.67, -39.0),
                length = 1.2,
                width = 1.0,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -39.6,
                    maxZ = -38.6
                }
            }
        },
    },
    -- zone = {
    --     center = vector3(326.18, 108.58, -94.7),
    --     length = 21.2,
    --     width =  21.2,
    --     options = {
    --         heading = 340,
    --         --debugPoly=true,
    --         minZ = -103.1,
    --         maxZ = -83.7
    --     }
    -- },
}