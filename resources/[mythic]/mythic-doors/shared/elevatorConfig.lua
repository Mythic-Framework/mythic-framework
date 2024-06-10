local hospitalRoofRestriction = {
    { type = 'job', job = 'police', workplace = false, level = 0, jobPermission = false, reqDuty = true },
    { type = 'job', job = 'ems', workplace = false, level = 0, jobPermission = false, reqDuty = true },
}

local hospitalLocking = {
    { type = 'job', job = 'ems', workplace = false, level = 0, jobPermission = false, reqDuty = true },
}

_elevatorConfig = {
    { -- Single Elevator
        name = 'Mt Zonah - Elevator',
        canLock = hospitalLocking,
        floors = {
            [-5] = {
                defaultLocked = true,
                name = 'Basement - Operations & Laboratory',
                coords = vector4(-452.626, -288.444, -130.841, 117.326),
                zone = {
                    center = vector3(-453.9, -289.04, -130.88),
                    length = 2.4,
                    width = 0.8,
                    heading = 22,
                    minZ = -131.88,
                    maxZ = -129.48
                }
            },
            [-1] = {
                name = 'Underground Parking',
                coords = vector4(-495.383, -372.737, 24.231, 288.445),
                zone = {
                    center = vector3(-494.06, -372.31, 24.23),
                    length = 0.8,
                    width = 2.4,
                    heading = 290,
                    minZ = 23.23,
                    maxZ = 25.63
                }
            },
            [1] = {
                name = 'Ground Floor - Emergency Department',
                coords = vector4(-452.381, -288.393, 34.950, 117.890),
                zone = {
                    center = vector3(-453.9, -289.05, 34.91),
                    length = 2.4,
                    width = 0.8,
                    heading = 22,
                    minZ = 33.91,
                    maxZ = 36.31
                },
            },
            [11] = {
                name = 'Intensive Care Unit',
                coords = vector4(-452.779, -288.538, 69.539, 115.790),
                zone = {
                    center = vector3(-453.97, -289.07, 69.54),
                    length = 2.4,
                    width = 0.8,
                    heading = 22,
                    minZ = 68.54,
                    maxZ = 70.94
                }
            },
            [13] = {
                defaultLocked = true,
                name = 'Roof - Helipad',
                coords = vector4(-439.719, -335.733, 78.301, 87.790),
                bypassLock = hospitalRoofRestriction,
                zone = {
                    center = vector3(-441.42, -337.66, 78.32),
                    length = 6.6,
                    width = 0.8,
                    heading = 352,
                    minZ = 77.32,
                    maxZ = 79.72
                },
            }
        }
    },

    {
        name = 'Mt Zonah - Elevator',
        canLock = hospitalLocking,
        floors = {
            [-1] = {
                name = 'Underground Parking',
                coords = vector4(-419.076, -344.817, 24.231, 110.590),
                zone = {
                    center = vector3(-420.32, -345.16, 24.23),
                    length = 0.8,
                    width = 2.4,
                    heading = 290,
                    minZ = 23.23,
                    maxZ = 25.63
                }
            },
            [1] = {
                name = 'Ground Floor - Emergency Department',
                coords = vector4(-436.105, -359.731, 34.950, 352.303),
                zone = {
                    center = vector3(-435.89, -358.23, 34.91),
                    length = 0.8,
                    width = 2.4,
                    heading = 352,
                    minZ = 33.91,
                    maxZ = 36.31
                },
            },
            [13] = {
                defaultLocked = true,
                name = 'Roof - Helipad',
                coords = vector4(-449.041, -334.642, 78.301, 264.699),
                bypassLock = hospitalRoofRestriction,
                zone = {
                    center = vector3(-447.73, -336.86, 78.32),
                    length = 6.6,
                    width = 0.8,
                    heading = 352,
                    minZ = 77.32,
                    maxZ = 79.72
                },
            }
        }
    },



    {
        name = 'Mt Zonah - Elevator',
        canLock = hospitalLocking,
        floors = {
            [2] = {
                name = '2nd Floor - Pharmacy',
                coords = vector4(-487.534, -327.838, 42.308, 167.233),
                zone = {
                    center = vector3(-487.75, -329.51, 42.32),
                    length = 0.8,
                    width = 2.4,
                    heading = 350,
                    minZ = 41.32,
                    maxZ = 43.72
                },
            },
            [11] = {
                name = 'Intensive Care Unit',
                coords = vector4(-487.595, -328.015, 69.505, 174.213),
                zone = {
                    center = vector3(-487.7, -329.48, 69.5),
                    length = 0.8,
                    width = 2.4,
                    heading = 351,
                    minZ = 68.5,
                    maxZ = 70.9
                },
            }
        }
    },
    {
        name = 'Mt Zonah - Elevator',
        canLock = hospitalLocking,
        floors = {
            [2] = {
                name = '2nd Floor - Pharmacy',
                coords = vector4(-487.534, -327.838, 42.308, 167.233),
                zone = {
                    center = vector3(-490.8, -329.18, 69.52),
                    length = 0.8,
                    width = 2.4,
                    heading = 351,
                    minZ = 41.32,
                    maxZ = 43.72
                },
            },
            [11] = {
                name = 'Intensive Care Unit',
                coords = vector4(-487.595, -328.015, 69.505, 174.213),
                zone = {
                    center = vector3(-490.71, -329.08, 69.52),
                    length = 2.4,
                    width = 0.8,
                    heading = 260,
                    minZ = 68.52,
                    maxZ = 70.72
                },
            }
        }
    },
    {
        name = 'Mt Zonah - Elevator',
        canLock = hospitalLocking,
        floors = {
            [2] = {
                name = '2nd Floor - Pharmacy',
                coords = vector4(-493.556, -327.225, 42.307, 168.865),
                zone = {
                    center = vector3(-493.57, -328.62, 42.32),
                    length = 0.8,
                    width = 2.4,
                    heading = 351,
                    minZ = 41.32,
                    maxZ = 43.72
                },
            },
            [11] = {
                name = 'Intensive Care Unit',
                coords = vector4(-493.476, -327.028, 69.505, 177.761),
                zone = {
                    center = vector3(-493.64, -328.65, 69.52),
                    length = 2.4,
                    width = 0.8,
                    heading = 261,
                    minZ = 68.52,
                    maxZ = 70.72
                },
            }
        }
    },

    { -- Triad Right
        name = 'Triad Records - Elevator 1',
        canLock = {
            { type = 'job', job = 'triad', workplace = false, level = 0, jobPermission = false, reqDuty = false },
        },
        floors = {
            [-1] = {
                defaultLocked = true,
                name = 'Basement',
                coords = vector4(-817.305, -709.485, 23.781, 90.442),
                zone = {
                    center = vector3(-817.85, -709.53, 23.78),
                    length = 3.0,
                    width = 3.8,
                    heading = 0,
                    --debugPoly=true,
                    minZ = 22.78,
                    maxZ = 25.58
                }
            },
            [1] = {
                name = 'Ground Floor',
                coords = vector4(-817.609, -709.467, 28.062, 90.153),
                zone = {
                    center = vector3(-817.84, -709.51, 28.06),
                    length = 3.0,
                    width = 3.8,
                    heading = 0,
                    --debugPoly=true,
                    minZ = 27.06,
                    maxZ = 29.86
                }
            },
            [2] = {
                name = 'Floor 2',
                coords = vector4(-817.434, -709.519, 32.343, 85.856),
                zone = {
                    center = vector3(-817.84, -709.5, 32.34),
                    length = 3.0,
                    width = 3.8,
                    heading = 0,
                    --debugPoly=true,
                    minZ = 31.34,
                    maxZ = 34.14
                },
            },
        }
    },
    { -- Triad Left
        name = 'Triad Records - Elevator 2',
        canLock = {
            { type = 'job', job = 'triad', workplace = false, level = 0, jobPermission = false, reqDuty = false },
        },
        floors = {
            [-1] = {
                defaultLocked = true,
                name = 'Basement',
                coords = vector4(-818.091, -705.504, 23.777, 89.689),
                zone = {
                    center = vector3(-817.77, -705.47, 23.78),
                    length = 3.0,
                    width = 3.8,
                    heading = 0,
                    --debugPoly=true,
                    minZ = 22.78,
                    maxZ = 25.58
                }
            },
            [1] = {
                name = 'Ground Floor',
                coords = vector4(-817.671, -705.504, 28.062, 91.055),
                restricted = false,
                zone = {
                    center = vector3(-817.86, -705.5, 28.06),
                    length = 3.0,
                    width = 3.8,
                    heading = 0,
                    --debugPoly=true,
                    minZ = 27.06,
                    maxZ = 29.86
                }
            },
            [2] = {
                name = 'Floor 2',
                coords = vector4(-817.668, -705.485, 32.343, 93.975),
                restricted = false,
                zone = {
                    center = vector3(-817.81, -705.51, 32.34),
                    length = 3.0,
                    width = 3.8,
                    heading = 0,
                    --debugPoly=true,
                    minZ = 31.34,
                    maxZ = 34.14
                },
            },
        }
    },

    {
        name = 'Diamond Casino Main Elevator',
        canLock = {
            { type = 'job', job = 'casino', workplace = false, level = 0, jobPermission = "CASINO_LOCK_ELEVATOR", reqDuty = false },
        },
        floors = {
            [-5] = {
                defaultLocked = true,
                name = 'Nightclub Staff Only',
                coords = vector4(958.203, 49.725, -75.205, 243.310),
                zone = {
                    center = vector3(957.76, 50.05, -75.21),
                    length = 2.8,
                    width = 1.0,
                    heading = 144,
                    --debugPoly=true,
                    minZ = -76.21,
                    maxZ = -73.61
                },
            },
            [0] = {
                defaultLocked = true,
                name = 'Rear Entrance',
                coords = vector4(976.777, 16.366, 80.990, 238.062),
                zone = {
                    center = vector3(976.19, 17.3, 80.99),
                    length = 2.4,
                    width = 2.0,
                    heading = 328,
                    --debugPoly=true,
                    minZ = 79.99,
                    maxZ = 82.39
                },
            },
            [1] = {
                name = 'Main Floor',
                coords = vector4(960.210, 43.188, 71.701, 278.518),
                zone = {
                    center = vector3(959.87, 43.14, 71.7),
                    length = 2.4,
                    width = 0.4,
                    heading = 12,
                    --debugPoly=true,
                    minZ = 70.7,
                    maxZ = 73.1
                },
            },
            [8] = {
                defaultLocked = true,
                name = 'Roof - Rear',
                coords = vector4(953.516, 4.249, 111.259, 240.528),
                zone = {
                    center = vector3(953.06, 4.53, 111.26),
                    length = 2.8,
                    width = 1.0,
                    heading = 145,
                    --debugPoly=true,
                    minZ = 110.26,
                    maxZ = 112.86
                },
            },
            [9] = {
                defaultLocked = true,
                name = 'Roof - Main Terrace',
                coords = vector4(964.800, 58.576, 112.553, 60.625),
                zone = {
                    center = vector3(965.14, 58.39, 112.55),
                    length = 2.4,
                    width = 0.6,
                    heading = 328,
                    --debugPoly=true,
                    minZ = 111.55,
                    maxZ = 113.95
                },
            },
            [10] = {
                defaultLocked = true,
                name = 'Penthouse Suite',
                coords = vector4(980.747, 56.650, 116.164, 61.786),
                zone = {
                    center = vector3(980.99, 56.39, 116.16),
                    length = 2.4,
                    width = 0.6,
                    heading = 328,
                    --debugPoly=true,
                    minZ = 115.16,
                    maxZ = 117.56
                },
            },
        }
    },

    {
        name = 'Diamond Casino Side Elevator',
        canLock = {
            { type = 'job', job = 'casino', workplace = false, level = 0, jobPermission = "CASINO_LOCK_ELEVATOR", reqDuty = false },
        },
        floors = {
            [-5] = {
                defaultLocked = true,
                name = 'Nightclub Entrance',
                coords = vector4(994.411, 84.381, -74.406, 54.885),
                zone = {
                    center = vector3(994.78, 84.08, -74.41),
                    length = 2.2,
                    width = 1.0,
                    heading = 324,
                    --debugPoly=true,
                    minZ = -75.41,
                    maxZ = -72.81
                },
            },
            [0] = {
                name = 'Side Door',
                coords = vector4(987.570, 79.664, 80.991, 327.664),
                zone = {
                    center = vector3(987.24, 79.25, 80.99),
                    length = 2.8,
                    width = 1,
                    heading = 239,
                    --debugPoly=true,
                    minZ = 79.99,
                    maxZ = 82.59
                },
            },
            [2] = {
                defaultLocked = true,
                name = 'Management Office',
                coords = vector4(994.114, 56.084, 75.060, 235.408),
                zone = {
                    center = vector3(993.75, 56.22, 75.06),
                    length = 2.4,
                    width = 0.6,
                    heading = 148,
                    --debugPoly=true,
                    minZ = 74.06,
                    maxZ = 76.46
                },
            },
            [9] = {
                defaultLocked = true,
                name = 'Roof - Main Terrace',
                coords = vector4(936.930, 14.168, 112.554, 64.480),
                zone = {
                    center = vector3(937.21, 13.81, 112.55),
                    length = 2.4,
                    width = 0.6,
                    heading = 328,
                    --debugPoly=true,
                    minZ = 111.55,
                    maxZ = 113.95
                },
            },
            [11] = {
                defaultLocked = true,
                name = 'Roof - Helipad',
                coords = vector4(959.669, 32.471, 120.226, 142.133),
                zone = {
                    center = vector3(959.82, 32.67, 120.23),
                    length = 2.4,
                    width = 0.6,
                    heading = 238,
                    --debugPoly=true,
                    minZ = 119.23,
                    maxZ = 121.63
                },
            },
        }
    },
}
