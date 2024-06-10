-- Mission Row PD Doors

addDoorsListToConfig({
    -- Main Floor
    { -- Reception Double Doors
        id = 'mrpd_reception_1',
        model = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(434.7444, -980.7556, 30.8153),
        locked = false,
        double = 'mrpd_reception_2',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Reception Double Doors
        id = 'mrpd_reception_2',
        model = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(434.7444, -983.0781, 30.8153),
        locked = false,
        double = 'mrpd_reception_1',
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Reception Inner Side Doors
        id = 'mrpd_reception_3',
        model = `gabz_mrpd_door_04`,
        coords = vector3(440.5201, -977.6011, 30.82319),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Reception Inner Side Doors 2
        id = 'mrpd_reception_4',
        model = `gabz_mrpd_door_05`,
        coords = vector3(440.5201, -986.2335, 30.82319),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- MRPD Locker
        model = `gabz_mrpd_door_02`,
        coords = vector3(458.0894, -995.5247, 30.82319),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    { -- Side Double Doors
        id = 'mrpd_side_1',
        model = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(455.8862, -972.2543, 30.81531),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_side_2',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Side Double Doors
        id = 'mrpd_side_2',
        model = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(458.2087, -972.2543, 30.81531),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_side_1',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Carpark Side Double Doors
        id = 'mrpd_cside_1',
        model = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(440.7392, -998.7462, 30.8153),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_cside_2',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Carpark Side Double Doors
        id = 'mrpd_cside_2',
        model = `gabz_mrpd_reception_entrancedoor`,
        coords = vector3(443.0618, -998.7462, 30.8153),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_cside_1',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Archive Room
        model = `gabz_mrpd_door_05`,
        coords = vector3(452.2663, -995.5254, 30.82319),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Command Office
        model = `gabz_mrpd_door_05`,
        coords = vector3(458.6543, -990.6498, 30.82319),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 60, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Break Room
        model = `gabz_mrpd_door_05`,
        coords = vector3(458.65, -976.89, 30.82),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Armoury Front
        model = `gabz_mrpd_door_03`,
        coords = vector3(479.7507, -999.629, 30.78917),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Armoury Side
        model = `gabz_mrpd_door_03`,
        coords = vector3(487.4378, -1000.189, 30.78697),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    -- Tactical Room
    {
        id = 'mrpd_tac_1',
        model = `gabz_mrpd_door_04`,
        coords = vector3(475.3837, -989.8247, 30.82319),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_tac_2',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_tac_2',
        model = `gabz_mrpd_door_05`,
        coords = vector3(472.9777, -989.8247, 30.82319),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_tac_1',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Tactical Other Door
        model = `gabz_mrpd_door_04`,
        coords = vector3(476.75, -999.63, 30.82),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Shooting Range 1
        id = 'mrpd_range_1',
        model = `gabz_mrpd_door_03`,
        coords = vector3(488.0184, -1002.902, 30.78697),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_range_2',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Shooting Range 2
        id = 'mrpd_range_2',
        model = `gabz_mrpd_door_03`,
        coords = vector3(485.6133, -1002.902, 30.78697),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_range_1',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Lab 1
        id = 'mrpd_lab_1',
        model = `gabz_mrpd_door_04`,
        coords = vector3(479.7534, -986.2151, 30.82319),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_lab_2',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Lab 2
        id = 'mrpd_lab_2',
        model = `gabz_mrpd_door_05`,
        coords = vector3(479.7534, -988.6204, 30.82319),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_lab_1',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Training Room 1
        model = `gabz_mrpd_door_05`,
        coords = vector3(449.676, -981.529, 34.972),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Training Room 2
        model = `gabz_mrpd_door_04`,
        coords = vector3(449.639, -989.854, 35.069),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Meeting 1
        model = `gabz_mrpd_door_04`,
        coords = vector3(459.160, -981.019, 35.071),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    
    { -- Meeting 2
        model = `gabz_mrpd_door_05`,
        coords = vector3(459.206, -991.229, 34.972),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Dispatch Room
        model = `gabz_mrpd_door_05`,
        coords = vector3(449.572, -996.148, 35.071),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- The Roof
        model = `gabz_mrpd_door_03`,
        coords = vector3(464.896, -983.833, 43.673),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Parking
        model = `gabz_mrpd_room13_parkingdoor`,
        coords = vector3(464.1566, -997.5093, 26.3707),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Parking
        model = `gabz_mrpd_room13_parkingdoor`,
        coords = vector3(464.1591, -974.6656, 26.3707),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'mrpd_down_double_1',
        model = `gabz_mrpd_door_04`,
        coords = vector3(471.3753, -985.0319, 26.40548),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_down_double_2',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_down_double_2',
        model = `gabz_mrpd_door_05`,
        coords = vector3(471.3753, -987.4374, 26.40548),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_down_double_1',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'mrpd_down_double_3',
        model = `gabz_mrpd_door_01`,
        coords = vector3(469.9274, -1000.544, 26.40548),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_down_double_4',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_down_double_4',
        model = `gabz_mrpd_door_01`,
        coords = vector3(467.5222, -1000.544, 26.40548),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_down_double_3',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Evidence Outer
        model = `gabz_mrpd_door_03`,
        coords = vector3(475.673, -989.664, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Evidence Inner
        model = `gabz_mrpd_fencedoor`,
        coords = vector3(475.6114, -992.0482, 26.51181),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'mrpd_rear_exit_1',
        model = `gabz_mrpd_door_03`,
        coords = vector3(469.7743, -1014.406, 26.48382),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_rear_exit_2',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_rear_exit_2',
        model = `gabz_mrpd_door_03`,
        coords = vector3(467.3686, -1014.406, 26.48382),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_rear_exit_1',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'mrpd_down_double_5',
        model = `gabz_mrpd_door_02`,
        coords = vector3(479.576, -985.582, 26.273),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_down_double_6',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_down_double_6',
        model = `gabz_mrpd_door_02`,
        coords = vector3(479.568, -986.695, 26.273),
        locked = true,
        autoRate = 6.0,
        double = 'mrpd_down_double_5',
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    { -- Interrogation 1
        model = `gabz_mrpd_door_04`,
        coords = vector3(482.160, -988.307, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Interrogation 1 Observation
        model = `gabz_mrpd_door_04`,
        coords = vector3(482.721, -984.614, 26.374),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Interrogation 1
        model = `gabz_mrpd_door_04`,
        coords = vector3(482.325, -992.952, 26.275),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Interrogation 1 Observation
        model = `gabz_mrpd_door_04`,
        coords = vector3(482.140, -995.966, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Processing
        model = `gabz_mrpd_door_01`,
        coords = vector3(475.294, -1007.433, 26.274),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'mrpd_cell_mugshot',
        model = `gabz_mrpd_door_04`,
        coords = vector3(475.007, -1010.819, 26.313),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    -- Cells

    {
        id = 'mrpd_cell_1',
        model = `gabz_mrpd_cells_door`,
        coords = vector3(477.143, -1011.909, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_cell_2',
        model = `gabz_mrpd_cells_door`,
        coords = vector3(480.051, -1011.995, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_cell_3',
        model = `gabz_mrpd_cells_door`,
        coords = vector3(483.566, -1011.750, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_cell_4',
        model = `gabz_mrpd_cells_door`,
        coords = vector3(486.581, -1011.763, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_cell_5',
        model = `gabz_mrpd_cells_door`,
        coords = vector3(484.931, -1007.864, 26.322),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    {
        id = 'mrpd_cell_outer_1',
        model = `gabz_mrpd_cells_door`,
        coords = vector3(477.302, -1008.257, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_cell_outer_2',
        model = `gabz_mrpd_cells_door`,
        coords = vector3(481.697, -1003.518, 26.274),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },

    { -- Lineup Room
        model = `gabz_mrpd_door_01`,
        coords = vector3(479.571, -1002.396, 26.273),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    -- MRPD Vehicle Related Doors

    { -- Garage Door Enter
        id = 'mrpd_garage_enter',
        model = `gabz_mrpd_garage_door`,
        coords = vector3(452.3, -1000.78, 26.74),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    { -- Garage Door Exit
        id = 'mrpd_garage_exit',
        model = `gabz_mrpd_garage_door`,
        coords = vector3(431.41, -1000.77, 26.7),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },


    {
        id = 'mrpd_bollards_exit',
        model = `gabz_mrpd_bollards1`,
        coords = vector3(410.0258, -1024.226, 29.22022),
        autoRate = 1.0,
        autoDist = 7.0,
        locked = true,
        special = true,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_bollards_enter',
        model = `gabz_mrpd_bollards2`,
        coords = vector3(410.0258, -1024.226, 29.22022),
        autoRate = 1.0,
        autoDist = 7.0,
        locked = true,
        special = true,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = false },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
    {
        id = 'mrpd_reargate',
        model = -1603817716,
        coords = vector3(488.8948, -1017.21, 27.14584),
        locked = true,
        special = true,
        restricted = {
            { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
            { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
        },
    },
})