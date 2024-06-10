local prisonDoors = {
    { type = 'job', job = 'police', workplace = false, gradeLevel = 0, jobPermission = false, reqDuty = true },
    { type = 'job', job = 'prison', workplace = 'corrections', gradeLevel = 0, jobPermission = false, reqDuty = true },
    { type = 'job', job = 'ems', workplace = 'prison', gradeLevel = 0, jobPermission = false, reqDuty = true },
}

addDoorsListToConfig({
    {
        id = 'prison_gate_1',
        model = 741314661,
        coords = vector3(1844.99, 2604.81, 44.64),
        special = true,
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_gate_2',
        model = 741314661,
        coords = vector3(1818.54, 2604.81, 44.61),
        special = true,
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = 'prison_gate_3',
        model = -1156020871,
        coords = vector3(1797.76, 2596.56, 46.39),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_gate_4',
        model = -1156020871,
        coords = vector3(1798.09, 2591.69, 46.42),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_gate_5',
        model = -1156020871,
        coords = vector3(1797.83, 2546.77, 46.25),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },


    {
        id = "prison_gate_ground_1",
        model = -1156020871,
        coords = vector3(1764.48, 2528.58, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_2",
        model = -1156020871,
        coords = vector3(1761.21, 2529.45, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_3",
        model = -1156020871,
        coords = vector3(1725.93, 2506.41, 46.31),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_4",
        model = -1156020871,
        coords = vector3(1726.8, 2509.69, 46.31),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_5",
        model = -1156020871,
        coords = vector3(1715.1, 2487.45, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_6",
        model = -1156020871,
        coords = vector3(1712.7, 2489.85, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_7",
        model = -1156020871,
        coords = vector3(1670.65, 2487.48, 46.31),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_8",
        model = -1156020871,
        coords = vector3(1673.05, 2489.89, 46.31),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_9",
        model = -1156020871,
        coords = vector3(1654.13, 2490.39, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_10",
        model = -1156020871,
        coords = vector3(1653.82, 2493.76, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_11",
        model = -1156020871,
        coords = vector3(1623.45, 2519.27, 46.31),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_12",
        model = -1156020871,
        coords = vector3(1620.08, 2518.96, 46.31),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_13",
        model = -1156020871,
        coords = vector3(1616.24, 2531.52, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_14",
        model = -1156020871,
        coords = vector3(1618.63, 2533.93, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_15",
        model = -1156020871,
        coords = vector3(1616.07, 2575.98, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_16",
        model = -1156020871,
        coords = vector3(1618.47, 2573.59, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_17",
        model = -1156020871,
        coords = vector3(1681.8, 2562.99, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_18",
        model = -1156020871,
        coords = vector3(1681.8, 2566.38, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_19",
        model = -1156020871,
        coords = vector3(1708.61, 2562.99, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_20",
        model = -1156020871,
        coords = vector3(1708.6, 2566.38, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_21",
        model = -1156020871,
        coords = vector3(1744.62, 2560.65, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = {}
    },
    {
        id = "prison_gate_ground_22",
        model = -1156020871,
        coords = vector3(1744.61, 2564.04, 46.28),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = "prison_gate_ground_23",
        model = -1156020871,
        coords = vector3(1697.4, 2544.24, 46.27),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_24",
        model = -1156020871,
        coords = vector3(1697.4, 2547.62, 46.27),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = "prison_gate_ground_25",
        model = -1156020871,
        coords = vector3(1744.18, 2562.53, 46.25),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_26",
        model = -1156020871,
        coords = vector3(1708.48, 2564.78, 46.25),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_gate_ground_27",
        model = -1156020871,
        coords = vector3(1681.21, 2564.78, 46.25),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },


    {
        id = 'prison_reception',
        model = 2024969025,
        coords = vector3(1844.4, 2577.0, 46.04),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = 'prison_reception_cloakroom',
        model = 2024969025,
        coords = vector3(1837.63, 2576.99, 46.04),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = 'prison_reception_visitors',
        model = -684929024,
        coords = vector3(1835.53, 2587.44, 46.04),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    
    {
        id = 'prison_reception_cage',
        model = 539686410,
        coords = vector3(1837.91, 2590.25, 46.2),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    
    {
        id = 'prison_reception_mugshot',
        model = -684929024,
        coords = vector3(1838.62, 2593.71, 46.04),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = 'prison_reception_door',
        model = -684929024,
        coords = vector3(1831.34, 2594.99, 46.04),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = 'prison_reception_exit',
        model = 1373390714,
        coords = vector3(1819.07, 2594.87, 46.09),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    -- Control Room in Cells
    {
        id = "prison_cell_control_1",
        model = 241550507,
        coords = vector3(1775.41, 2491.03, 49.84),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_control_2",
        model = 241550507,
        coords = vector3(1772.94, 2495.31, 49.84),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = "prison_cell_1",
        model = 913760512,
        coords = vector3(1768.55, 2498.41, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_2",
        model = 913760512,
        coords = vector3(1765.4, 2496.59, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_3",
        model = 913760512,
        coords = vector3(1762.25, 2494.78, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_4",
        model = 913760512,
        coords = vector3(1755.96, 2491.15, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_6",
        model = 913760512,
        coords = vector3(1752.82, 2489.33, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_6",
        model = 913760512,
        coords = vector3(1749.67, 2487.51, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_7",
        model = 913760512,
        coords = vector3(1768.55, 2498.41, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_8",
        model = 913760512,
        coords = vector3(1765.4, 2496.6, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_9",
        model = 913760512,
        coords = vector3(1762.25, 2494.78, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_10",
        model = 913760512,
        coords = vector3(1759.11, 2492.96, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_11",
        model = 913760512,
        coords = vector3(1755.96, 2491.15, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_12",
        model = 913760512,
        coords = vector3(1752.82, 2489.33, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_13",
        model = 913760512,
        coords = vector3(1749.67, 2487.51, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_14",
        model = 913760512,
        coords = vector3(1758.08, 2475.39, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_15",
        model = 913760512,
        coords = vector3(1761.22, 2477.21, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_16",
        model = 913760512,
        coords = vector3(1764.37, 2479.03, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_17",
        model = 913760512,
        coords = vector3(1767.52, 2480.84, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_18",
        model = 913760512,
        coords = vector3(1770.66, 2482.66, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_19",
        model = 913760512,
        coords = vector3(1773.81, 2484.48, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_20",
        model = 913760512,
        coords = vector3(1776.95, 2486.29, 45.89),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_21",
        model = 913760512,
        coords = vector3(1758.08, 2475.39, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_22",
        model = 913760512,
        coords = vector3(1761.22, 2477.21, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_23",
        model = 913760512,
        coords = vector3(1764.37, 2479.03, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_24",
        model = 913760512,
        coords = vector3(1767.52, 2480.84, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_25",
        model = 913760512,
        coords = vector3(1770.66, 2482.66, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_26",
        model = 913760512,
        coords = vector3(1773.81, 2484.48, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = "prison_cell_27",
        model = 913760512,
        coords = vector3(1776.95, 2486.29, 49.85),
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = 'prison_cell_gym',
        model = 241550507,
        coords = vector3(1751.15, 2481.18, 45.89),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_cell_games',
        model = 241550507,
        coords = vector3(1752.28, 2479.25, 45.89),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_cell_exit',
        model = 241550507,
        coords = vector3(1758.65, 2492.66, 45.89),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = 'prison_cell_block',
        model = 1373390714,
        coords = vector3(1754.8, 2501.57, 45.81),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },


    {
        id = 'prison_food_1',
        model = 1373390714,
        coords = vector3(1791.6, 2551.46, 45.75),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_food_2',
        model = 1373390714,
        coords = vector3(1776.2, 2552.56, 45.75),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_food_kitchen',
        model = 2024969025,
        coords = vector3(1786.83, 2560.27, 45.7),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },


    {
        id = 'prison_infirmary_block',
        model = 1373390714,
        coords = vector3(1765.12, 2566.52, 45.8),
        locked = false,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_infirmary_security',
        model = 2074175368,
        coords = vector3(1772.81, 2570.3, 45.74),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },


    {
        id = 'prison_infirmary_double_1',
        double = 'prison_infirmary_double_2',
        model = -1624297821,
        coords = vector3(1766.33, 2574.7, 45.75),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_infirmary_double_2',
        double = 'prison_infirmary_double_1',
        model = -1624297821,
        coords = vector3(1764.03, 2574.7, 45.75),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },

    {
        id = 'prison_icu_1',
        double = 'prison_icu_2',
        model = -1624297821,
        coords = vector3(1766.33, 2589.56, 45.75),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_icu_2',
        double = 'prison_icu_1',
        model = -1624297821,
        coords = vector3(1764.03, 2589.56, 45.75),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },


    {
        id = 'prison_surgery_1',
        double = 'prison_surgery_2',
        model = -1624297821,
        coords = vector3(1767.32, 2582.31, 45.75),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
    {
        id = 'prison_surgery_2',
        double = 'prison_surgery_1',
        model = -1624297821,
        coords = vector3(1767.32, 2584.61, 45.75),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },


    {
        id = 'prison_lab',
        model = -1392981450,
        coords = vector3(1767.32, 2580.83, 45.75),
        locked = true,
        autoRate = 6.0,
        restricted = prisonDoors
    },
})