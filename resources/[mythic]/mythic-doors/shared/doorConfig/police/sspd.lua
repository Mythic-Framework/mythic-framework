local offDutyDoorPermissions = {

}

addDoorsListToConfig({
    {
        id = "sspd_front_1",
        double = "sspd_front_2",
        model = -1501157055,
        coords = vector3(1837.38, 3674.72, 34.34),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_front_2",
        double = "sspd_front_1",
        model = -1501157055,
        coords = vector3(1835.13, 3673.42, 34.34),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_stairwell",
        model = 1364638935,
        coords = vector3(1838.01, 3677.1, 34.28),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_backarea",
        model = -1264811159,
        coords = vector3(1830.65, 3676.56, 34.28),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    {
        id = "sspd_mugshot_enter",
        model = 1364638935,
        coords = vector3(1818.32, 3669.28, 34.28),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "sspd_cell_1",
        model = 2010487154,
        coords = vector3(1810.13, 3676.46, 34.4),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_cell_2",
        model = 2010487154,
        coords = vector3(1808.63, 3679.07, 34.4),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_cell_3",
        model = 2010487154,
        coords = vector3(1807.13, 3681.66, 34.4),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_cells_rear",
        model = 2010487154,
        coords = vector3(1813.55, 3675.06, 34.4),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_interrogation",
        model = -1264811159,
        coords = vector3(1814.2, 3669.45, 34.28),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_obervation",
        model = 1364638935,
        coords = vector3(1812.31, 3672.72, 34.28),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "sspd_armoury",
        model = -1264811159,
        coords = vector3(1838.97, 3682.86, 34.28),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_back",
        model = -1501157055,
        coords = vector3(1823.86, 3681.12, 34.34),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },



    -- Downstairs
    {
        id = "sspd_evidence",
        model = -1264811159,
        coords = vector3(1829.85, 3673.79, 34.28),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_lockers",
        model = -1264811159,
        coords = vector3(1827.07, 3674.5, 34.28),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    -- Upstairs

    {
        id = "sspd_sheriff",
        model = -1626613696,
        coords = vector3(1831.23, 3675.43, 38.95),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 70, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_sheriff2",
        model = -1626613696,
        coords = vector3(1828.43, 3673.81, 38.95),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 70, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_archive",
        model = -1264811159,
        coords = vector3(1828.53, 3680.23, 38.95),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = "sspd_gate",
        model = 1286535678,
        coords = vector3(1862.0, 3687.52, 33.01),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = "sspd_garage_rear",
        model = -1156020871,
        coords = vector3(1845.41, 3677.49, 34.61),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
})