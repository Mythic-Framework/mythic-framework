PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_apartment1"] = {
    type = "house",
    price = 120000,
    info = {
        name = "Style #1",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(294.561, 126.442, 129.064),
            heading = 163.768,
            polyzone = {
                center = vector3(294.74, 126.74, 129.06),
                length = 0.6,
                width = 2.0,
                options = {
                    heading = 160,
                    --debugPoly=true,
                    minZ = 128.06,
                    maxZ = 130.66
                }
            }
        },
    },
    zone = {
        center = vector3(290.6, 127.44, 129.06),
        length = 13.4,
        width = 15.6,
        options = {
            heading = 340,
            --debugPoly=true,
            minZ = 127.46,
            maxZ = 131.86
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = { x = 294.145, y = 129.605, z = 128.06 },
            heading = 249.68,
            data = {},
        },
        {
            id = 2,
            name = "Default Bed",
            model = "v_res_tre_bed1",
            coords = { x = 284.256, y = 127.823, z = 128.06 },
            heading = 69.750,
            data = {},
        },
    },
    cameras = {
        {
            name = "Living Area",
            coords = vec3(296.005615, 120.115623, 130.096527),
            rotation = vec3(-3.976376, 0.000000, 40.064541),
        },
        {
            name = "Bathroom",
            coords = vec3(285.885162, 135.477417, 131.145325),
            rotation = vec3(-22.519688, 0.000000, 221.166840),
        },
        {
            name = "Bedroom",
            coords = vec3(287.084808, 124.077499, 131.320709),
            rotation = vec3(-19.645638, 0.000000, 14.631672),
        },
        {
            name = "Closet",
            rotation = vec3(-35.614529, 0.000000, 280.642914),
            coords = vec3(284.025024, 130.911972, 131.039352),
        }
    }
}