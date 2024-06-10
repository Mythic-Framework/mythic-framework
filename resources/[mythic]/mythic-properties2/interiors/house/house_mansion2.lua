PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_mansion2"] = {
    type = "house",
    price = 800000,
    info = {
        name = "Luxury Modern #1",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(-1290.959, 449.157, 39.240),
            heading = 175.114,
            polyzone = {
                center = vector3(-1291.01, 449.48, 39.24),
                length = 0.4,
                width = 1.8,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 38.24,
                    maxZ = 40.84
                }
            }
        },
        back = {
            coords = vector3(-1288.338, 428.935, 38.831),
            heading = 1.584,
            polyzone = {
                center = vector3(-1288.25, 428.66, 38.83),
                length = 0.6,
                width = 3.0,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 37.83,
                    maxZ = 40.43
                }
            }
        },
    },
    zone = {
        center = vector3(-1290.55, 440.46, 39.25),
        length = 26.8,
        width =  24.6,
        options = {
            heading = 0,
            --debugPoly=true,
            minZ = 27.65,
            maxZ = 47.45
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {x=-1289.34619140625,y=448.0220947265625,z=38.24016571044922},
            heading = 289.0,
            data = {},
        },
    },
    cameras = {
        {
            name = "Living Area",
            coords = vec3(-1282.746582, 428.638977, 40.321411),
            rotation = vec3(-12.374144, 0.000000, 33.575008),
        },
        {
            name = "Kitchen",
            coords = vec3(-1288.340088, 439.414185, 40.488602),
            rotation = vec3(-10.563111, 0.000000, 331.409668),
        },
        {
            name = "Bedroom #1",
            coords = vec3(-1289.018555, 428.907990, 36.512718),
            rotation = vec3(-7.216651, 0.000000, 336.291473),
        },
        {
            name = "Office",
            coords = vec3(-1287.096191, 440.584442, 33.403786),
            rotation = vec3(-17.059185, 0.000000, 38.889839),
        },
        {
            name = "Hallway",
            coords = vec3(-1286.072510, 452.126740, 33.628071),
            rotation = vec3(-15.799335, 0.000000, 119.992294),
        },
    },
}