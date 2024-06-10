PropertyInteriors = PropertyInteriors or {}

-- 100

PropertyInteriors["warehouse_low"] = {
    type = "warehouse",
    price = 250000,
    info = {
        name = "Warehouse Low",
        description = "It's a Warehouse",
    },
    inventoryOverride = 1010,
    locations = {
        front = {
            coords = vector3(1087.496, -3099.390, -39.000),
            heading = 268.047,
            polyzone = {
                center = vector3(1087.24, -3099.4, -39.0),
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
            coords = vector3(1087.496, -3099.390, -39.000),
            heading = 0.0,
            polyzone = {
                center = vector3(1087.66, -3101.33, -39.0),
                length = 1.0,
                width = 1.0,
                options = {
                    heading = 270,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -37.0
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