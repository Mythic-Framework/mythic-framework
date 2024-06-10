PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_apartment4"] = {
    type = "house",
    price = 250000,
    info = {
        name = "Style #4",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(294.791, 122.292, 119.214),
            heading = 342.102,
            polyzone = {
                center = vector3(294.59, 121.78, 119.21),
                length = 0.6,
                width = 2.0,
                options = {
                    heading = 160,
                    --debugPoly=true,
                    minZ = 118.21,
                    maxZ = 120.81
                }
            }
        },
    },
    zone = {
        center = vector3(296.16, 126.68, 119.21),
        length = 20.8,
        width = 20.0,
        options = {
            heading = 340,
            --debugPoly=true,
            minZ = 117.61,
            maxZ = 122.01
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {x=296.8974304199219,y=122.7481460571289,z=118.21422576904297},
            heading = 249.84390258789062,
            data = {},
        },
        {
            id = 2,
            name = "Default Bed",
            model = "v_res_tre_bed1",
            coords = {x=302.9079284667969,y=120.57762145996094,z=118.21422576904297},
            heading = 248.0587158203125,
            data = {},
        },
    },
    cameras = {
        {
            name = "Large Living Area",
            coords = vec3(289.701080, 135.324463, 121.351860),
            rotation = vec3(-13.349978, 0.000000, 213.960754),
        },
        {
            name = "Large Living Area",
            coords = vec3(307.191986, 128.890625, 121.409676),
            rotation = vec3(-18.113760, 0.000000, 106.323036),
        },
        {
            name = "Bedroom",
            coords = vec3(303.422272, 118.857925, 121.396759),
            rotation = vec3(-19.964165, 0.000000, 41.283855),
        },
        {
            name = "Bathroom",
            coords = vec3(286.076324, 125.254623, 121.272598),
            rotation = vec3(-20.712189, 0.000000, 269.591003),
        },
    },
}