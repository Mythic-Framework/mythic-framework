table.insert(Config.Restaurants, {
    Name = "Avast Arcade",
    Job = "avast_arcade",
    Storage = {
        {
            id = "avast_fridge",
            type = "box",
            coords = vector3(-1656.03, -1058.7, 12.16),
            width = 2.2,
            length = 1.0,
            options = {
                heading = 320,
                --debugPoly=true,
                minZ = 11.16,
                maxZ = 13.56
            },
			data = {
                business = "avast_arcade",
                inventory = {
                    invType = 78,
                    owner = "avast_fridge",
                },
			},
        },
    },
    Pickups = {
        {
            id = "avast-pickup-1",
            coords = vector3(-1654.13, -1062.85, 12.16),
            width = 1.0,
            length = 0.8,
            options = {
                heading = 320,
                --debugPoly=true,
                minZ = 11.56,
                maxZ = 12.96
            },
			data = {
                business = "avast_arcade",
                inventory = {
                    invType = 25,
                    owner = "avast-pickup-1",
                },
			},
        },
    },
})