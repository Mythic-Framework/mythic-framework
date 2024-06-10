PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_apartment2"] = {
    type = "house",
    price = 225000,
    info = {
        name = "Style #2",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(295.287, 129.080, 141.051),
            heading = 159.194,
            polyzone = {
                center = vector3(295.45, 129.36, 141.05),
                length = 0.6,
                width = 2.0,
                options = {
                    heading = 340,
                    --debugPoly=true,
                    minZ = 140.05,
                    maxZ = 142.65
                }
            }
        },
    },
    zone = {
        center = vector3(290.58, 122.97, 141.05),
        length = 19.9,
        width = 19.0,
        options = {
            heading = 340,
            --debugPoly=true,
            minZ = 139.45,
            maxZ = 143.85
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = { x = 295.52447509765627, y =127.09036254882813, z =140.05130004882813},
            heading = 251.25814819335938,
            data = {},
        },
        {
            id = 2,
            name = "Default Bed",
            model = "v_res_tre_bed1",
            coords = {x=297.1941223144531,y=117.81202697753906,z=140.05130004882813},
            heading = 249.80099487304688,
            data = {},
        },
    },
    cameras = {
        {
            name = "Large Living Area",
            coords = vec3(281.286652, 118.272850, 143.079178),
            rotation = vec3(-13.702451, 0.000000, 305.025665),
        },
        {
            name = "Bedroom",
            coords = vec3(289.162811, 115.124031, 143.235977),
            rotation = vec3(-19.292978, 0.000000, 301.206604),
        },
        {
            name = "Bathroom",
            coords = vec3(301.055481, 125.420593, 143.104279),
            rotation = vec3(-20.119753, 0.000000, 113.647560),
        },
    },
}