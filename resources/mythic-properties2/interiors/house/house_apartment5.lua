PropertyInteriors = PropertyInteriors or {}

PropertyInteriors["house_apartment5"] = {
    type = "house",
    price = 280000,
    info = {
        name = "Small Luxury",
        description = "Description",
    },
    locations = {
        front = {
            coords = vector3(301.247, 114.769, 102.630),
            heading = 341.878,
            polyzone = {
                center = vector3(301.17, 114.43, 102.63),
                length = 0.6,
                width = 2.0,
                options = {
                    heading = 340,
                    --debugPoly=true,
                    minZ = 101.63,
                    maxZ = 104.23
                }
            }
        },
    },
    zone = {
        center = vector3(305.76, 122.12, 102.63),
        length = 20.0,
        width = 20.0,
        options = {
            heading = 340,
            --debugPoly=true,
            minZ = 100.63,
            maxZ = 106.83
        }
    },
    defaultFurniture = {
        {
            id = 1,
            name = "Default Storage",
            model = "v_res_tre_storagebox",
            coords = {x=299.5560607910156,y=115.46487426757813,z=101.62986755371094},
            heading = 158.5992889404297,
            data = {},
        },
    },
    cameras = {
        {
            name = "Large Living Area",
            coords = vec3(300.226532, 131.324936, 104.805153),
            rotation = vec3(-11.738203, 0.000000, 192.104416),
        },
        {
            name = "Bedroom #1",
            coords = vec3(317.211914, 127.259048, 104.788139),
            rotation = vec3(-12.643709, 0.000000, 105.372139),
        },
        {
            name = "Closet",
            coords = vec3(314.713348, 119.565208, 104.776566),
            rotation = vec3(-19.612209, 0.000000, 111.317047),
        },
        {
            name = "Bathroom",
            coords = vec3(311.537811, 110.834038, 104.754784),
            rotation = vec3(-20.005913, 0.000000, 35.765873),
        },
    },
}