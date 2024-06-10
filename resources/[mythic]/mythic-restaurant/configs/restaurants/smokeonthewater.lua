table.insert(Config.Restaurants, {
    Name = "Smoke on the Water",
    Job = "weed",
    -- Benches = {

    -- },
    -- Storage = {

    -- },
    Pickups = {
        {
            id = "weed-pickup-1",
            coords = vector3(-1168.23, -1573.27, 4.66),
            width = 1.4,
            length = 0.8,
            options = {
                heading = 35,
                --debugPoly=true,
                minZ = 3.66,
                maxZ = 5.26
            },
			data = {
                business = "weed",
                inventory = {
                    invType = 25,
                    owner = "weed-pickup-1",
                },
			},
        },
    },
    -- Warmers = {

    -- },
})