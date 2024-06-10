PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_mansion1"] = {
    type = "house",
    price = 700000,
    info = {
        name = "Mediterranean",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(-815.756, 178.461, -77.174),
            heading = 292.717,
            polyzone = {
                center = vector3(-816.3, 178.34, -77.17),
                length = 2.8,
                width = 1.0,
                options = {
                    heading = 21,
                    --debugPoly=true,
                    minZ = -78.17,
                    maxZ = -74.77
                }
            }
        },
        back = {
            coords = vector3(-795.733, 178.285, -76.492),
            heading = 23.503,
            polyzone = {
                center = vector3(-795.46, 177.6, -76.49),
                length = 2.8,
                width = 1.0,
                options = {
                    heading = 291,
                    --debugPoly=true,
                    minZ = -77.49,
                    maxZ = -74.09
                }
            }
        },
    },
    zone = {
        center = vector3(-804.58, 179.52, -77.18),
        length = 26.8,
        width = 24.6,
        options = {
            heading = 30,
            --debugPoly=true,
            minZ = -79.78,
            maxZ = -65.78
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {x=-813.9766235351563,y=182.0312042236328,z=-78.17357635498047},
            heading = 20.907302856445312,
            data = {},
        },
    },
    cameras = {
        {
            name = "Entry Hallway",
            coords = vec3(-806.284363, 179.748825, -73.768875),
            rotation = vec3(-23.244629, 0.000000, 89.965324),
        },
        {
            name = "Living Area",
            coords = vec3(-800.769165, 179.808823, -74.647903),
            rotation = vec3(-9.622579, 0.000000, 148.390488),
        },
        {
            name = "Kitchen",
            coords = vec3(-804.634521, 181.068573, -75.539825),
            rotation = vec3(-7.181628, 0.000000, 309.650238),
        },
        {
            name = "Dining Area",
            coords = vec3(-793.459412, 179.141464, -74.812798),
            rotation = vec3(-20.291866, 0.000000, 71.421936),
        },
        {
            name = "Garage",
            coords = vec3(-815.930908, 188.919937, -74.859055),
            rotation = vec3(-13.205255, 0.000000, 253.390427),
        },
        {
            name = "Upper Hallway",
            coords = vec3(-809.189697, 174.509476, -70.566101),
            rotation = vec3(-16.197380, 0.000000, 310.438110),
        },
        {
            name = "Bedroom #1",
            coords = vec3(-803.668274, 175.168457, -70.840630),
            rotation = vec3(-19.780046, 0.000000, 223.902481),
        },
        {
            name = "Bedroom #2",
            coords = vec3(-808.474915, 178.631744, -70.247162),
            rotation = vec3(-23.087114, 0.000000, 79.650650),
        },
        {
            name = "Bedroom #3",
            coords = vec3(-808.656860, 166.480453, -70.595741),
            rotation = vec3(-16.984762, 0.000000, 348.469513),
        },
        {
            name = "Bathroom",
            coords = vec3(-802.283325, 168.561005, -72.059593),
            rotation = vec3(-6.417331, 0.000000, 47.209633),
        },
    },
}