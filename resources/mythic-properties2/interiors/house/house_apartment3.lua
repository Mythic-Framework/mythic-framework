PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_apartment3"] = {
    type = "house",
    price = 250000,
    info = {
        name = "Style #3",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(294.839, 118.298, 134.356),
            heading = 71.096,
            polyzone = {
                center = vector3(295.07, 118.21, 134.36),
                length = 0.6,
                width = 2.0,
                options = {
                    heading = 250,
                    --debugPoly=true,
                    minZ = 133.36,
                    maxZ = 135.96
                }
            }
        },
    },
    zone = {
        center = vector3(291.36, 123.85, 134.36),
        length = 19.8,
        width = 19.0,
        options = {
            heading = 340,
            --debugPoly=true,
            minZ = 132.76,
            maxZ = 137.16
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {x=293.9130554199219,y=116.01509094238281,z=133.35614013671876},
            heading = 248.9642333984375,
            data = {},
        },
        {
            id = 2,
            name = "Default Bed",
            model = "v_res_tre_bed1",
            coords = {x=297.0943298339844,y=130.65420532226563,z=133.35614013671876},
            heading = 340.1803283691406,
            data = {},
        },
    },
    cameras = {
        {
            name = "Large Living Area",
            coords = vec3(284.827118, 117.781090, 136.532471),
            rotation = vec3(-15.476163, 0.000000, 299.298218),
        },
        {
            name = "Bedroom #1",
            coords = vec3(299.495209, 131.015564, 136.598816),
            rotation = vec3(-21.184845, 0.000000, 127.408470),
        },
        {
            name = "Bedroom #2",
            coords = vec3(290.562561, 134.270721, 136.571487),
            rotation = vec3(-24.846264, 0.000000, 198.550140),
        },
        {
            name = "Bathroom",
            coords = vec3(295.731384, 120.351524, 136.592728),
            rotation = vec3(-27.720263, 0.000000, 24.495312),
        },
    },
}