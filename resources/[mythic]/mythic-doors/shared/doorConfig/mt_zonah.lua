local publicDoorPermissions = { -- Public Doors, Police can lock when on duty, Medical Staff Whenever
    { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
    { type = 'job', job = 'ems', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
}

local staffOnlyDoorPermissions = { -- Medical Staff Only (Allows Offduty)
    { type = 'job', job = 'ems', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
}

local staffOnlyStrictDoorPermissions = { -- On Duty Medical Staff Only
    { type = 'job', job = 'ems', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
}

addDoorsListToConfig({
    -- Emergency Lobby Doors
    {
        id = 'mtz_emergency_lobby_door1_1',
        model = `gus_zonah_door`,
        coords = vector3(-442.8783, -357.9211, 33.49734),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_lobby_door1_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_emergency_lobby_door1_2',
        model = `gus_zonah_door`,
        coords = vector3(-445.3691, -357.5913, 33.49734),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_lobby_door1_1',
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_emergency_lobby_door2_1',
        model = `gus_zonah_door`,
        coords = vector3(-448.1449, -349.3434, 33.49734),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_lobby_door2_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_emergency_lobby_door2_2',
        model = `gus_zonah_door`,
        coords = vector3(-447.8171, -346.8542, 33.49734),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_lobby_door2_1',
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_emergency_lobby_door3_1',
        model = `gus_zonah_door`,
        coords = vector3(-447.2123, -342.2507, 33.49734),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_lobby_door3_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_emergency_lobby_door3_2',
        model = `gus_zonah_door`,
        coords = vector3(-446.8802, -339.762, 33.49734),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_lobby_door3_1',
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_emergency_lobby_door4_1',
        model = `gus_zonah_door`,
        coords = vector3(-446.2654, -335.1541, 33.49734),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_lobby_door4_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_emergency_lobby_door4_2',
        model = `gus_zonah_door`,
        coords = vector3(-445.9332, -332.6644, 33.49734),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_lobby_door4_1',
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_emergency_lobby_reception',
        model = `gus_hos_door`,
        coords = vector3(-440.6439, -321.7954, 35.06683),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyDoorPermissions,
    },

    -- Emergency Corridor
    {
        id = 'mtz_emergency_corridor1',
        model = `gus_hos_doubledoor`,
        coords = vector3(-445.4264, -320.6447, 35.06686),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_corridor2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_emergency_corridor2',
        model = `gus_hos_doubledoor`,
        coords = vector3(-443.0124, -319.6694, 35.06686),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_corridor1',
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_emergency_cloakroom',
        model = `gus_hos_door`,
        coords = vector3(-442.589, -317.0564, 35.06619),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_emergency_xray',
        model = `gus_hos_door`,
        coords = vector3(-447.3418, -305.4991, 35.07071),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_emergency_diag',
        model = `gus_hos_door`,
        coords = vector3(-449.6572, -299.8383, 35.07071),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_emergency_mri',
        model = `gus_hos_door`,
        coords = vector3(-453.0472, -291.5856, 35.06544),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },

    {
        id = 'mtz_emergency_room1',
        model = `gus_hos_door`,
        coords = vector3(-448.6458, -316.0326, 35.06632),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_emergency_room2',
        model = `gus_hos_door`,
        coords = vector3(-449.2249, -314.634, 35.06632),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_emergency_closet',
        model = `gus_hos_door`,
        coords = vector3(-451.4746, -309.0658, 35.06632),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_emergency_room3',
        model = `gus_hos_door`,
        coords = vector3(-452.7051, -306.0629, 35.06632),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_emergency_room4',
        model = `gus_hos_door`,
        coords = vector3(-454.9653, -300.5515, 35.06632),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_emergency_room5',
        model = `gus_hos_door`,
        coords = vector3(-457.122, -295.3082, 35.06632),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },

    {
        id = 'mtz_emergency_rest1',
        model = `gus_hos_doubledoor`,
        coords = vector3(-458.2174, -289.2669, 35.06949),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_emergency_rest2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_emergency_rest2',
        model = `gus_hos_doubledoor`,
        coords = vector3(-455.8128, -288.2954, 35.06949),
        locked = false,
        double = 'mtz_emergency_rest1',
        autoRate = 6.0,
        restricted = staffOnlyDoorPermissions,
    },

    -- Level 1 Enter

    {
        id = 'mtz_level1_lobby_door1_1',
        model = `gus_zonah_door`,
        coords = vector3(-437.9523, -340.1761, 41.32681),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_door1_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_level1_lobby_door1_2',
        model = `gus_zonah_door`,
        coords = vector3(-438.285, -342.6693, 41.32681),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_door1_1',
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_level1_lobby_door2_1',
        model = `gus_zonah_door`,
        coords = vector3(-472.1934, -341.2045, 41.32181),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_door2_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_level1_lobby_door2_2',
        model = `gus_zonah_door`,
        coords = vector3(-474.6872, -340.8755, 41.32181),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_door2_1',
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_level1_lobby_door3_1',
        model = `gus_zonah_door`,
        coords = vector3(-473.5818, -332.4851, 41.32181),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_door3_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_level1_lobby_door3_2',
        model = `gus_zonah_door`,
        coords = vector3(-471.089, -332.8133, 41.32181),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_door3_1',
        restricted = staffOnlyDoorPermissions,
    },

    {
        id = 'mtz_level1_lobby_door4_1',
        model = `gus_zonah_door`,
        coords = vector3(-507.8236, -333.5138, 41.32181),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_door4_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_level1_lobby_door4_2',
        model = `gus_zonah_door`,
        coords = vector3(-507.4955, -331.0215, 41.32181),
        locked = false,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_door4_1',
        restricted = staffOnlyDoorPermissions,
    },

    -- Office Corridor

    {
        id = 'mtz_level1_lobby_office_1',
        model = `xm_prop_x17_l_door_frame_01`,
        coords = vector3(-501.8895, -325.3537, 42.46983),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_office_2',
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_level1_lobby_office_2',
        model = `xm_prop_x17_l_door_frame_01`,
        coords = vector3(-499.2977, -325.1406, 42.46983),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_office_1',
        restricted = staffOnlyStrictDoorPermissions,
    },

    {
        id = 'mtz_level1_lobby_officeexit_1',
        model = `gn_hos_doorglass`,
        coords = vector3(-511.2768, -299.2697, 42.63515),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_officeexit_2',
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_level1_lobby_officeexit_2',
        model = `gn_hos_doorglass`,
        coords = vector3(-508.87, -298.2558, 42.63515),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_level1_lobby_officeexit_1',
        restricted = staffOnlyStrictDoorPermissions,
    },

    -- ICU Floor (Upper)

    -- Office Corridor
    {
        id = 'mtz_icu_office_1',
        model = `gus_hos_doubledoor`,
        coords = vector3(-496.0181, -334.7783, 69.67925),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_icu_office_2',
        restricted = staffOnlyDoorPermissions,
    },
    {
        id = 'mtz_icu_office_2',
        model = `gus_hos_doubledoor`,
        coords = vector3(-495.6571, -332.2099, 69.67925),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_icu_office_1',
        restricted = staffOnlyDoorPermissions,
    },


    -- ICU Rooms
    { -- 1
        model = `gus_hos_door`,
        coords = vector3(-482.7205, -333.846, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 2
        model = `gus_hos_door`,
        coords = vector3(-482.1169, -341.48, 68.52184),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 3
        model = `gus_hos_door`,
        coords = vector3(-475.2886, -334.8333, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 4
        model = `gus_hos_door`,
        coords = vector3(-478.0122, -337.83, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 5
        model = `gus_hos_door`,
        coords = vector3(-467.8647, -335.8116, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 6
        model = `gus_hos_door`,
        coords = vector3(-470.5856, -338.8056, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 7
        model = `gus_hos_door`,
        coords = vector3(-460.4161, -336.7872, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 8
        model = `gus_hos_door`,
        coords = vector3(-463.152, -339.7936, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 9 (Double)
        model = `gus_hos_door`,
        coords = vector3(-445.9842, -342.1603, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    { -- 9 (VIP)
        model = `gus_hos_door`,
        coords = vector3(-440.2983, -338.7459, 69.67925),
        locked = false,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },


    -- Helipad
    {
        id = 'mtz_helipad_1',
        model = `gus_zonah_door`,
        coords = vector3(-445.2872, -332.981, 77.3009),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_helipad_2',
        restricted = publicDoorPermissions,
    },
    {
        id = 'mtz_helipad_2',
        model = `gus_zonah_door`,
        coords = vector3(-442.7953, -333.3066, 77.3009),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_helipad_1',
        restricted = publicDoorPermissions,
    },

    -- Operation Floor

    {
        id = 'mtz_op_lab_1',
        model = `gus_hos_doubledoor`,
        coords = vector3(-458.2203, -289.2584, -130.7138),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_op_lab_2',
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_op_lab_2',
        model = `gus_hos_doubledoor`,
        coords = vector3(-455.8113, -288.2991, -130.7138),
        locked = true,
        autoRate = 6.0,
        double = 'mtz_op_lab_1',
        restricted = staffOnlyStrictDoorPermissions,
    },

    -- Surgery 1

    {
        id = 'mtz_op_surgery_1',
        model = `gus_hos_door`,
        coords = vector3(-447.3456, -305.5006, -130.7193),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_op_surgery_2',
        model = `gus_hos_door`,
        coords = vector3(-451.4877, -309.0756, -130.7237),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
    {
        id = 'mtz_op_surgery_3',
        model = `gus_hos_door`,
        coords = vector3(-453.052, -291.5876, -130.7246),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },

    {
        id = 'mtz_op_diag',
        model = `gus_hos_door`,
        coords = vector3(-449.1745, -301.0362, -130.7193),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },

    {
        id = 'mtz_op_closet',
        model = `gus_hos_door`,
        coords = vector3(-454.9724, -300.5544, -130.7237),
        locked = true,
        autoRate = 6.0,
        restricted = staffOnlyStrictDoorPermissions,
    },
})