PropertyInteriors = PropertyInteriors or {}

-- 151

PropertyInteriors["container2"] = {
    type = "container",
    price = 100000,
    info = {
        name = "Container #2",
        description = "Tech Shipping Container",
    },
    inventoryOverride = 1020,
    locations = {
        front = {
            coords = vector3(-826.415, -399.982, 31.564),
            heading = 2.435,
            polyzone = {
                center = vector3(-826.5, -401.17, 31.56),
                length = 2.0,
                width = 2.0,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 30.56,
                    maxZ = 32.96
                }
            }
        },
        crafting = {
            coords = vector3(-825.48, -392.41, 31.56),
            heading = 0.0,
            polyzone = {
                center = vector3(-825.48, -392.41, 31.56),
                length = 2.2,
                width = 2.0,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 30.56,
                    maxZ = 32.76
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