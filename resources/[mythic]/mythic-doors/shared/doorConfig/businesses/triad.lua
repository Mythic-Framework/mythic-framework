addDoorsListToConfig({
    -- Entry Left
    {
        id = 'traid_entry_left_1',
        double = 'traid_entry_left_2',
        model = 2001816392,
        coords = vector3(-826.4025, -700.9301, 28.49083),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'traid_entry_left_2',
        double = 'traid_entry_left_1',
        model = 2001816392,
        coords = vector3(-826.4025, -698.7478, 28.49083),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Entry Right
    {
        id = 'traid_entry_right_1',
        double = 'traid_entry_right_2',
        model = 2001816392,
        coords = vector3(-826.4025, -697.9944, 28.49083),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'traid_entry_right_2',
        double = 'traid_entry_right_1',
        model = 2001816392,
        coords = vector3(-826.4025, -695.8148, 28.49083),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Hallway
    {
        id = 'traid_hallway_entry_1',
        double = 'traid_hallway_entry_2',
        model = 75593271,
        coords = vector3(-822.3143, -703.1263, 28.2056),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'traid_hallway_entry_2',
        double = 'traid_hallway_entry_1',
        model = 1403720845,
        coords = vector3(-820.3126, -703.1263, 28.2056),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Reception Staff Right
    {
        id = 'traid_reception_staff_right',
        model = 693644064,
        coords = vector3(-816.6038, -702.3438, 28.2056),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Reception Staff Left
    {
        id = 'traid_reception_staff_left',
        model = 693644064,
        coords = vector3(-816.6038, -694.3998, 28.2056),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Hallway 2
    {
        id = 'traid_hallway_bar_1',
        double = 'traid_hallway_bar_2',
        model = 75593271,
        coords = vector3(-822.3143, -715.694, 28.2056),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'traid_hallway_bar_2',
        double = 'traid_hallway_bar_1',
        model = 1403720845,
        coords = vector3(-820.3126, -715.694, 28.2056),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Staircase Recep
    {
        id = 'traid_stairs_1',
        model = 693644064,
        coords = vector3(-819.4991, -711.9124, 28.2056),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Staircase Upstairs
    {
        id = 'traid_stairs_2',
        model = 693644064,
        coords = vector3(-819.4991, -711.9124, 32.48665),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Staircase Downstairs
    {
        id = 'traid_stairs_3',
        model = 693644064,
        coords = vector3(-819.4991, -711.9124, 23.92465),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- CEO Office
    {
        id = 'traid_ceo',
        model = 693644064,
        coords = vector3(-822.0345, -703.1276, 32.48665),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 99, reqDuty = false },
        },
    },
    -- Meeting
    {
        id = 'traid_meeting_1',
        double = 'traid_meeting_2',
        model = 1403720845,
        coords = vector3(-823.145, -708.4457, 32.4866),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'traid_meeting_2',
        double = 'traid_meeting_1',
        model = 75593271,
        coords = vector3(-823.145, -710.4473, 32.4866),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Studio
    {
        id = 'traid_studio',
        model = 693644064,
        coords = vector3(-822.0345, -715.6934, 32.48665),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },

    -- Downstairs Storage
    {
        id = 'traid_studio',
        model = -2023754432,
        coords = vector3(-823.1431, -711.9124, 23.92465),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Downstairs Storage
    {
        id = 'traid_downstairs_storage',
        model = -2023754432,
        coords = vector3(-823.1431, -711.9124, 23.92465),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    -- Downstairs Garage access
    {
        id = 'traid_downstairs_garage',
        model = -2023754432,
        coords = vector3(-820.6585, -715.6949, 23.93994),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
    {
        id = 'traid_garage',
        model = -700626879,
        coords = vector3(-816.2236, -740.1627, 24.16524),
        locked = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'triad', gradeLevel = 0, reqDuty = false },
        },
    },
})