_vehicleImpound = {
    name = 'Impound Yard',
    coords = vector3(-217.737, -1178.995, 23.044),
    spaces = {
        vector4(-197.824, -1174.704, 22.562, 200.803),
        vector4(-194.447, -1174.454, 22.562, 200.792),
        vector4(-190.991, -1174.274, 22.561, 200.788),
        vector4(-187.387, -1174.478, 22.562, 200.783),
        vector4(-183.857, -1174.757, 22.562, 200.786),
        vector4(-152.417, -1170.048, 23.286, 269.104),
        vector4(-152.420, -1166.538, 23.288, 270.890),
        vector4(-147.635, -1161.992, 23.288, 180.160),
        vector4(-144.135, -1161.988, 23.288, 180.161),
        vector4(-139.119, -1161.981, 23.288, 181.144),
        vector4(-133.749, -1166.455, 23.288, 89.500),
        vector4(-133.286, -1170.013, 23.287, 89.509),
        vector4(-132.368, -1175.155, 23.287, 90.843),
        vector4(-132.592, -1178.552, 23.287, 89.580),
        vector4(-132.624, -1182.113, 23.287, 89.580),
    },
    interactionBoxZone = {
        center = vector3(-192.56, -1162.3, 23.67),
        length = 3.0,
        width = 0.8,
        heading = 0,
        minZ=23.47,
        maxZ=23.87
    }
}

_impoundConfig = {
    RequiredPermission = 'impound',
    RegularFine = 750,
    Police = {
        RequiredPermission = 'impound_police',
        Levels = {
            {
                Fine = {
                    Min = 2000,
                    Percent = false,
                },
                Holding = 0,
            },
            {
                Fine = {
                    Min = 3500,
                    Percent = false,
                },
                Holding = 6,
            },
            {
                Fine = {
                    Min = 5000,
                    Percent = false,
                },
                Holding = 12,
            },
            {
                Fine = {
                    Min = 8500,
                    Percent = false,
                },
                Holding = 24,
            },
            -- {
            --     Fine = {
            --         Min = 10000,
            --         Percent = 25,
            --     },
            --     Holding = 48,
            -- },
            -- {
            --     Fine = {
            --         Min = 10000,
            --         Percent = 25,
            --     },
            --     Holding = 96,
            -- },
        }
    }
}