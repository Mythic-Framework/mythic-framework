-- 69

PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["office1"] = {
    type = "office",
    price = 100000,
    info = {
        name = "Small Office",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(-310.825, -909.777, 4.602),
            heading = 51.776,
            polyzone = {
                center = vector3(-310.79, -910.73, 4.6),
                length = 1.0,
                width = 2.0,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 3.6,
                    maxZ = 6.4
                }
            }
        },
    },
    zone = {
        center = vector3(-310.67, -905.17, 4.6),
        length = 15.0,
        width = 15.0,
        options = {
            heading = 0,
            --debugPoly=true,
            minZ = 2.4,
            maxZ = 7.6
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "hei_heist_str_sideboardl_02",
            coords = { x = -311.37835693359377, y = -907.890869140625, z = 3.60231661796569 },
            heading = 179.04766845703125,
            data = {},
        },
    },
    cameras = {
        {
            name = "Hallway",
            coords = vec3(-314.851044, -909.813721, 6.252535),
            rotation = vec3(-21.369766, 0.000000, 267.407471),
        },
        {
            name = "Office",
            coords = vec3(-314.127197, -900.251953, 5.952186),
            rotation = vec3(-13.653235, 0.000000, 243.942886),
        },
    }
}