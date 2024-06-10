addDoorsListToConfig({
    -- Paleto Bay PD

    {
        id = "dpd_front_1",
        double = "dpd_front_2",
        model = 1670919150,
        coords = vector3(379.78, -1592.61, 30.2),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_front_2",
        double = "dpd_front_1",
        model = 618295057,
        coords = vector3(381.78, -1594.28, 30.2),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "dpd_rear_1",
        double = "dpd_rear_2",
        model = 618295057,
        coords = vector3(369.52, -1614.2, 30.2),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_rear_2",
        double = "dpd_rear_1",
        model = 1670919150,
        coords = vector3(371.51, -1615.87, 30.2),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "dpd_command_1",
        double = "dpd_command_2",
        model = -425870000,
        coords = vector3(361.61, -1594.33, 31.14),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 60, jobPermission = false, reqDuty = false },
        },
    },
    {
        id = "dpd_command_2",
        double = "dpd_command_1",
        model = -425870000,
        coords = vector3(363.15, -1592.5, 31.14),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 60, jobPermission = false, reqDuty = false },
        },
    },

    {
        id = "dpd_office_2",
        model = -425870000,
        coords = vector3(363.24, -1589.21, 31.14),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },
    {
        id = "dpd_office_1",
        model = -425870000,
        coords = vector3(358.38, -1595.0, 31.14),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    {
        id = "dpd_reception",
        model = -425870000,
        coords = vector3(382.82, -1599.03, 30.14),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    {
        id = "dpd_stairs_1",
        model = -1335406364,
        coords = vector3(384.43, -1601.96, 30.14),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },
    {
        id = "dpd_stairs_2",
        model = -1335406364,
        coords = vector3(374.64, -1613.63, 30.14),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    {
        id = "dpd_observation",
        model = -1335406364,
        coords = vector3(375.54, -1608.15, 25.54),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_interrogation",
        model = -728950481,
        coords = vector3(371.96, -1605.14, 25.55),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "dpd_mugshot",
        model = -1335406364,
        coords = vector3(379.17, -1603.83, 25.54),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "dpd_lockers",
        model = -1335406364,
        coords = vector3(363.89, -1595.47, 25.55),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },
    {
        id = "pbpd_armoury",
        model = -1335406364,
        coords = vector3(367.12, -1601.08, 25.54),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "dpd_cdouble_1",
        double = "dpd_cdouble_2",
        model = -1335406364,
        coords = vector3(370.41, -1598.59, 25.55),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_cdouble_2",
        double = "dpd_cdouble_1",
        model = -1335406364,
        coords = vector3(368.86, -1600.43, 25.55),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "dpd_cell_1",
        model = -674638964,
        coords = vector3(369.07, -1605.69, 29.94),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_cell_2",
        model = -674638964,
        coords = vector3(368.27, -1605.02, 29.94),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_cell_3",
        model = -674638964,
        coords = vector3(375.88, -1599.11, 25.34),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_cell_4",
        model = -674638964,
        coords = vector3(375.08, -1598.43, 25.34),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "dpd_gate",
        model = 1286535678,
        coords = vector3(397.88, -1607.38, 28.34),
        locked = true,
        --autoRate = 6.0,
        special = true,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "dpd_gate2",
        model = -1483471451,
        coords = vector3(413.36, -1620.04, 28.34),
        locked = true,
        --autoRate = 6.0,
        special = true,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },
    {
        id = "dpd_gate3",
        model = -1483471451,
        coords = vector3(418.29, -1651.39, 28.29),
        locked = true,
        --autoRate = 6.0,
        special = true,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },
})

