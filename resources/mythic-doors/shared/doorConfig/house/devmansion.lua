addDoorsListToConfig({
    {
        id = 'dm_gate_1',
        double = 'dm_gate_2',
        model = 546378757,
        coords = vector3(-2559.19, 1910.86, 169.07),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'dgang', gradeLevel = 0, reqDuty = false },
        },
        holdOpen = true,
    },
    {
        id = 'dm_gate_2',
        double = 'dm_gate_1',
        model = -1249591818,
        coords = vector3(-2556.66, 1915.72, 169.07),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'dgang', gradeLevel = 0, reqDuty = false },
        },
        holdOpen = true,
    },


    {
        id = 'dm_garage',
        model = 1068002766,
        coords = vector3(-2597.04, 1925.98, 168.98),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'dgang', gradeLevel = 0, reqDuty = false },
        },
    },


    {
        id = 'dm_front',
        model = 308207762,
        coords = vector3(-2587.57, 1910.46, 167.65),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'dgang', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'dm_garage_door',
        model = -2037125726,
        coords = vector3(-2594.07, 1916.82, 167.46),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'dgang', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'dm_back_1',
        model = 813813633,
        coords = vector3(-2599.57, 1900.0, 167.74),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'dgang', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'dm_back_2',
        model = 813813633,
        coords = vector3(-2599.8, 1901.75, 164.1),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'dgang', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'dm_office',
        model = -2037125726,
        coords = vector3(-2581.08, 1877.85, 163.95),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'dgang', gradeLevel = 0, reqDuty = false },
        },
    },
})