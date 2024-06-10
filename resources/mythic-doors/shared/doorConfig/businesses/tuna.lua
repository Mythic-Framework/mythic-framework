addDoorsListToConfig({
    {
        id = 'tuna_garage_1',
        model = -456733639,
        coords = vector3(154.82, -3034.05, 8.56),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'tuna', gradeLevel = 0, reqDuty = false },
        },
        holdOpen = true,
    },

    {
        id = 'tuna_garage_2',
        model = -456733639,
        coords = vector3(154.82, -3023.89, 8.56),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'tuna', gradeLevel = 0, reqDuty = false },
        },
        holdOpen = true,
    },

    {
        id = 'tuna_door',
        model = -2023754432,
        coords = vector3(154.93, -3017.32, 7.19),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'tuna', gradeLevel = 0, reqDuty = false },
        },
    },

    {
        id = 'tuna_door',
        model = -1229046235,
        coords = vector3(151.47, -3011.71, 7.26),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'tuna', gradeLevel = 0, reqDuty = false },
        },
    },
})