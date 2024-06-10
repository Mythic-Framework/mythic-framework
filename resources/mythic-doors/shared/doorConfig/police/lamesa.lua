-- Mission Row PD Doors

addDoorsListToConfig({
    -- Main Floor
    { -- Reception Double Doors
        id = 'la_mesa_reception_1',
        model = 277920071,
        coords = vector3(827.9521, -1288.786, 28.37117),
        locked = false,
        double = 'la_mesa_reception_2',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Reception Double Doors
        id = 'la_mesa_reception_2',
        model = -34368499,
        coords = vector3(827.9521, -1291.387, 28.37117),
        locked = false,
        double = 'la_mesa_reception_1',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Observation
        id = 'la_mesa_observe',
        model = -1011300766,
        coords = vector3(840.0884, -1280.999, 28.37117),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Interrogation
        id = 'la_mesa_interrogation',
        model = -1189294593,
        coords = vector3(840.0861, -1281.824, 28.37117),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    -- Meeting Room
    {
        id = 'la_mesa_meeting_left_1',
        model = -1983352576,
        coords = vector3(849.9325, -1287.346, 28.37117),
        locked = true,
        double = 'la_mesa_meeting_left_2',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_meeting_left_2',
        model = 2076628221,
        coords = vector3(852.5331, -1287.346, 28.37117),
        locked = true,
        double = 'la_mesa_meeting_left_1',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_meeting_right_1',
        model = -1983352576,
        coords = vector3(856.5074, -1287.346, 28.37117),
        locked = true,
        double = 'la_mesa_meeting_right_2',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_meeting_right_2',
        model = 2076628221,
        coords = vector3(859.1082, -1287.346, 28.37117),
        locked = true,
        double = 'la_mesa_meeting_right_1',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'la_mesa_archive',
        model = 539497004,
        coords = vector3(858.865, -1291.385, 28.37111),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'la_mesa_cpt',
        model = 1861900850,
        coords = vector3(851.9497, -1298.389, 28.37117),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 60, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'la_mesa_cell',
        model = 1162089799,
        coords = vector3(834.2814, -1295.986, 28.37117),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'la_mesa_lobby',
        model = -147896569,
        coords = vector3(835.9445, -1292.193, 27.78268),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_breakroom',
        model = 1491736897,
        coords = vector3(837.2611, -1309.514, 28.37111),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_evidence',
        model = 272264766,
        coords = vector3(846.3696, -1310.04, 28.37111),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_locker1',
        model = -1213101062,
        coords = vector3(854.7811, -1310.04, 28.37111),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_locker2',
        model = -1213101062,
        coords = vector3(855.7422, -1314.608, 28.37111),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'la_mesa_hallway_1',
        model = -375301406,
        coords = vector3(856.5074, -1310.038, 28.37117),
        locked = true,
        double = 'la_mesa_hallway_2',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_hallway_2',
        model = -375301406,
        coords = vector3(859.1082, -1310.038, 28.37117),
        locked = true,
        double = 'la_mesa_hallway_1',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    {
        id = 'la_mesa_bd_1',
        model = -1339729155,
        coords = vector3(859.0076, -1320.125, 28.37111),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'la_mesa_bd_1',
        model = -1246730733,
        coords = vector3(829.6385, -1310.128, 28.37117),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    {
        id = 'la_mesa_parking_gate',
        model = -1372582968,
        coords = vector3(816.9862, -1325.258, 25.09328),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
})