addDoorsListToConfig({
    -- Main Front Doors
    {
        id = "courthouse_front_1",
        double = "courthouse_front_2",
        locked = false,
        model = 660342567,
        coords = vector3(-544.56, -202.78, 38.42),
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },
    {
        id = "courthouse_front_2",
        double = "courthouse_front_1",
        locked = false,
        model = -1094765077,
        coords = vector3(-546.52, -203.91, 38.42),
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },
    -- Court Side Main
    {
        id = "courthouse_courtside_1",
        double = "courthouse_courtside_2",
        locked = true,
        model = -1940023190,
        coords = vector3(-562.78, -201.44, 38.44),
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },
    {
        id = "courthouse_courtside_2",
        double = "courthouse_courtside_1",
        locked = true,
        model = -1940023190,
        coords = vector3(-562.13, -202.57, 38.44),
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },

    {
        id = "courthouse_rearcourt_1",
        double = "courthouse_rearcourt_2",
        locked = true,
        model = -1940023190,
        coords = vector3(-562.78, -201.44, 43.58),
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },
    {
        id = "courthouse_rearcourt_2",
        double = "courthouse_rearcourt_1",
        locked = true,
        model = -1940023190,
        coords = vector3(-562.13, -202.56, 43.58),
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },

    -- Voting

    {
        model = 1762042010,
        coords = vector3(-532.42, -182.13, 38.33),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },
    {
        model = 1762042010,
        coords = vector3(-538.41, -185.59, 38.33),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },

    -- Offices

    {
        model = 1762042010,
        coords = vector3(-531.34, -186.61, 38.33),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', workplace = 'commissioner' },
        },
    },
    {
        model = 1762042010,
        coords = vector3(-536.2, -189.42, 38.33),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },
    {
        model = 1762042010,
        coords = vector3(-541.02, -192.2, 38.33),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },
    {
        model = 1762042010,
        coords = vector3(-541.01, -192.2, 43.47),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },
    {
        model = 1762042010,
        coords = vector3(-536.19, -189.41, 43.47),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },
    {
        model = 1762042010,
        coords = vector3(-538.4, -185.58, 43.47),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', workplace = 'commissioner' },
        },
    },

    -- Judge Chambers

    {
        model = 1762042010,
        coords = vector3(-582.5, -207.5, 38.32),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },

    {
        model = 1762042010,
        coords = vector3(-577.25, -216.61, 38.32),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
        },
    },

    {
        model = 1762042010,
        coords = vector3(-574.59, -216.93, 38.32),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },

    {
        model = 1762042010,
        coords = vector3(-574.59, -216.93, 38.32),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },


    {
        id = 'courthouse_rear_1',
        double = 'courthouse_rear_2',
        model = 297112647,
        coords = vector3(-567.49, -236.27, 34.36),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },
    {
        id = 'courthouse_rear_2',
        double = 'courthouse_rear_1',
        model = 830788581,
        coords = vector3(-568.55, -234.42, 34.36),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },

    {
        model = 1762042010,
        coords = vector3(-562.69, -231.69, 34.37),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },

    {
        model = 918828907,
        coords = vector3(-557.94, -233.11, 34.48),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },
    {
        model = 918828907,
        coords = vector3(-560.54, -234.61, 34.48),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'government' },
            { type = 'job', job = 'police', reqDuty = true },
        },
    },
})