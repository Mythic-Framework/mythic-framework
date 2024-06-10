PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_mansion3"] = {
    type = "house",
    price = 1000000,
    info = {
        name = "Luxury Modern #2",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(327.809, 101.351, -98.970),
            heading = 66.740,
            polyzone = {
                center = vector3(328.27, 101.29, -98.97),
                length = 2.0,
                width = 1.0,
                options = {
                    heading = 340,
                    --debugPoly=true,
                    minZ = -99.97,
                    maxZ = -96.97
                }
            }
        },
        back = {
            coords = vector3(330.551, 116.984, -94.700),
            heading = 159.563,
            polyzone = {
                center = vector3(330.84, 117.27, -94.7),
                length = 3.8,
                width = 1.0,
                options = {
                    heading = 250,
                    --debugPoly=true,
                    minZ = -95.7,
                    maxZ = -92.9
                }
            }
        },
    },
    zone = {
        center = vector3(326.18, 108.58, -94.7),
        length = 21.2,
        width =  21.2,
        options = {
            heading = 340,
            --debugPoly=true,
            minZ = -103.1,
            maxZ = -83.7
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {x=325.8331298828125,y=101.01309967041016,z=-99.96990966796875},
            heading = 159.0,
            data = {},
        },
    },
    cameras = {
        {
            name = "Entry",
            coords = vec3(325.798828, 108.776215, -96.733299),
            rotation = vec3(-17.756340, 0.000000, 189.397659),
        },
        {
            name = "Living Area",
            coords = vec3(327.921143, 100.713356, -93.122360),
            rotation = vec3(-10.866556, 0.000000, 39.476467),
        },
        {
            name = "Kitchen",
            coords = vec3(333.202148, 116.069862, -92.745979),
            rotation = vec3(-18.622469, 0.000000, 117.390022),
        },
        {
            name = "Bedroom #1",
            coords = vec3(325.259094, 118.686295, -88.173027),
            rotation = vec3(-17.559475, 0.000000, 209.004211),
        },
        {
            name = "Bathroom #1",
            coords = vec3(322.011230, 109.686340, -88.143845),
            rotation = vec3(-31.496479, 0.000000, 297.665741),
        },
        {
            name = "Living Area #1",
            coords = vec3(327.477173, 100.221672, -88.135620),
            rotation = vec3(-16.378380, 0.000000, 28.453171),
        },
        {
            name = "Garage",
            coords = vec3(321.583069, 110.158150, -97.257088),
            rotation = vec3(-17.362589, 0.000000, 295.854858),
        },
        {
            name = "Bathroom #2",
            coords = vec3(322.418091, 104.842155, -97.872063),
            rotation = vec3(-27.087002, 0.000000, 115.421738),
        },
    },
}