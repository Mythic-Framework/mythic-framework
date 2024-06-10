addDoorsListToConfig({
    {
        id = 'redline_dealership_garage',
        model = 1827434119,
        coords = vector3(-532.64, -884.81, 28.22),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 2, reqDuty = false },
        },
    },


    {
        id = 'redline_dealership_door_1',
        double = 'redline_dealership_door_2',
        model = 4787313,
        coords = vector3(-589.78, -887.59, 16.23),
        locked = true,
        --autoRate = 6.0,
        autoDist = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 2, reqDuty = false },
        },
    },
    {
        id = 'redline_dealership_door_2',
        double = 'redline_dealership_door_1',
        model = 4787313,
        coords = vector3(-589.78, -890.75, 16.23),
        locked = true,
        --autoRate = 6.0,
        autoDist = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 2, reqDuty = false },
        },
    },

    {
        id = 'redline_dealership_door_3',
        double = 'redline_dealership_door_4',
        model = 4787313,
        coords = vector3(-594.6, -909.23, 16.24),
        locked = true,
        autoDist = 6.0,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 2, reqDuty = false },
        },
    },
    {
        id = 'redline_dealership_door_4',
        double = 'redline_dealership_door_3',
        model = 4787313,
        coords = vector3(-591.44, -909.22, 16.25),
        locked = true,
        autoDist = 6.0,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 2, reqDuty = false },
        },
    },


    {
        id = 'redline_dealership_office_1',
        model = 1282049587,
        coords = vector3(-589.77, -895.01, 17.51),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 50, reqDuty = false },
        },
    },
    {
        id = 'redline_dealership_office_2',
        model = 1282049587,
        coords = vector3(-589.78, -902.02, 17.51),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 50, reqDuty = false },
        },
    },
    {
        id = 'redline_dealership_office_3',
        model = 1282049587,
        coords = vector3(-596.19, -885.86, 17.51),
        locked = false,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 50, reqDuty = false },
        },
    },
    {
        id = 'redline_dealership_office_4',
        model = 1282049587,
        coords = vector3(-596.18, -892.86, 17.51),
        locked = false,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', gradeLevel = 50, reqDuty = false },
        },
    },

    {
        id = 'redline_front_1',
        double = 'redline_front_2',
        model = -930505499,
        coords = vector3(-598.01, -931.17, 24.03),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
    },
    {
        id = 'redline_front_2',
        double = 'redline_front_1',
        model = 733700947,
        coords = vector3(-598.01, -928.57, 24.03),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
    },

    {
        id = 'redline_office',
        model = -1687047623,
        coords = vector3(-598.1, -923.02, 24.04),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = true },
        },
    },
    {
        id = 'redline_poopoo',
        model = -1687047623,
        coords = vector3(-598.1, -917.8, 24.04),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
    },


    {
        id = 'redline_mid_1',
        double = 'redline_mid_2',
        model = 1387498002,
        coords = vector3(-588.08, -935.54, 22.89),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
    },
    {
        id = 'redline_mid_2',
        double = 'redline_mid_1',
        model = 1693396617,
        coords = vector3(-588.08, -938.57, 22.88),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
    },

    {
        id = 'redline_garage_door',
        model = -610223133,
        coords = vector3(-562.65, -930.16, 28.28),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
        holdOpen = true,
    },

    {
        id = 'redline_parts',
        model = 634417522,
        coords = vector3(-587.99, -936.84, 28.29),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
    },

    {
        id = 'redline_super_secret',
        model = -1264687887,
        coords = vector3(-590.18, -925.56, 27.14),
        locked = true,
        special = true,
        autoRate = 10.0,
        restricted = {
            { type = 'job', job = 'redline', jobPermission = 'JOB_ACCESS_SAFE', reqDuty = false },
        },
    },

    {
        id = 'redline_gate_1',
        model = 1286535678,
        coords = vector3(-538.52, -923.1, 23.04),
        double = 'redline_gate_2',
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
    },
    {
        id = 'redline_gate_2',
        model = 1286535678,
        coords = vector3(-545.85, -936.24, 22.82),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
    },

    {
        id = 'redline_paint',
        model = 623553717,
        coords = vector3(-566.06, -914.58, 22.92),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'redline', reqDuty = false },
        },
        holdOpen = true,
    },
})