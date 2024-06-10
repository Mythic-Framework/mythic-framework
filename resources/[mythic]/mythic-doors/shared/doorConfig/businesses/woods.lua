addDoorsListToConfig({
    {
        id = 'woods_front_1',
        model = 1504256620,
        coords = vector3(-301.87, 6256.16, 31.68),
        locked = true,
        double = 'woods_front_2',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'woods_saloon', jobPermission = false, reqDuty = false },
        },
    },
    {
        id = 'woods_front_2',
        model = 262671971,
        coords = vector3(-300.27, 6257.67, 31.68),
        locked = true,
        double = 'woods_front_1',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'woods_saloon', jobPermission = false, reqDuty = false },
        },
    },

    { -- To Back Area
        model = -2023754432,
        coords = vector3(-310.38, 6267.34, 31.68),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'woods_saloon', jobPermission = false, reqDuty = false },
        },
    },

    { -- Rear Exit
        model = -1627599682,
        coords = vector3(-309.88, 6271.33, 31.68),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'woods_saloon', jobPermission = false, reqDuty = false },
        },
    },
    { -- Side Exit
        model = 1099436502,
        coords = vector3(-298.29, 6272.89, 31.68),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'woods_saloon', jobPermission = false, reqDuty = false },
        },
    },

    { -- Office
        model = -2023754432,
        coords = vector3(-298.58, 6272.24, 31.68),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'woods_saloon', grade = 'owner', jobPermission = false, reqDuty = false },
        },
    },
})