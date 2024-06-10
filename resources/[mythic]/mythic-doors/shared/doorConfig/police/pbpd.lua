addDoorsListToConfig({
    -- Paleto Bay PD

    {
        id = "pbpd_front_1",
        model = 733214349,
        double = "pbpd_front_2",
        coords = vector3(-437.17, 6012.95, 32.29),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_front_2",
        model = 965382714,
        double = "pbpd_front_1",
        coords = vector3(-438.59, 6014.36, 32.29),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "pbpd_lobby_1",
        model = 1857649811,
        double = "pbpd_lobby_2",
        coords = vector3(-448.07, 6004.87, 32.29),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_lobby_2",
        model = 1362051455,
        double = "pbpd_lobby_1",
        coords = vector3(-446.66, 6003.45, 32.29),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "pbpd_rear_1",
        model = 965382714,
        double = "pbpd_rear_2",
        coords = vector3(-453.49, 5996.64, 32.29),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_rear_2",
        model = 733214349,
        double = "pbpd_rear_1",
        coords = vector3(-454.9, 5998.05, 32.29),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "pbpd_reception",
        model = 1362051455,
        coords = vector3(-443.96, 6017.16, 32.29),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    {
        id = "pbpd_observation_1",
        model = 1362051455,
        coords = vector3(-443.06, 5999.87, 27.58),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_interrogation_1",
        model = 1362051455,
        coords = vector3(-441.94, 5998.75, 27.58),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "pbpd_observation_2",
        model = 1362051455,
        coords = vector3(-445.35, 5995.34, 27.58),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_interrogation_2",
        model = 1362051455,
        coords = vector3(-446.48, 5996.47, 27.58),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "pbpd_observation_c_1",
        model = 1857649811,
        double = "pbpd_observation_c_2",
        coords = vector3(-448.0, 5999.98, 27.58),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_observation_c_2",
        model = 1362051455,
        double = "pbpd_observation_c_1",
        coords = vector3(-446.58, 6001.4, 27.58),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "pbpd_mugshot",
        model = 1362051455,
        coords = vector3(-449.51, 5999.47, 27.58),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "pbpd_lockers",
        model = 1362051455,
        coords = vector3(-441.67, 6009.14, 37.0),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
        },
    },

    {
        id = "pbpd_office_command",
        model = 1362051455,
        coords = vector3(-437.13, 6004.66, 37.0),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 60, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_armoury",
        model = 1362051455,
        coords = vector3(-447.44, 6011.51, 37.0),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_evidence",
        model = 1362051455,
        coords = vector3(-449.68, 5999.34, 37.0),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_cells_outer",
        model = -594854737,
        coords = vector3(-442.24, 6012.62, 27.73),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_cell_1",
        model = -594854737,
        coords = vector3(-443.39, 6015.44, 27.73),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_cell_2",
        model = -594854737,
        coords = vector3(-446.36, 6018.41, 27.73),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_cell_3",
        model = -594854737,
        coords = vector3(-448.92, 6015.85, 27.73),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "pbpd_cell_4",
        model = -594854737,
        coords = vector3(-445.95, 6012.88, 27.73),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "pbpd_gate",
        model = -470936668,
        coords = vector3(-456.48, 6031.13, 31.14),
        locked = true,
        special = true,
        autoRate = 1.0,
        autoDist = 7.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
})