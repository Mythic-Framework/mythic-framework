-- 1-49 - Houses
-- 50-99 - Offices
-- 100-149 - Warehouses
-- 150-199 - Containers

PropertyTypes = {
    .house,
    .warehouse,
    .office,
    .container,
}

PropertyConfig = {
    [0] = {
        x = 265.940,
        y = -1004.289,
        z = -99.008,
        h = 3.839,
        exit = vector3(266.045, -1007.037, -100.929),
        zone = {
            center = vector3(258.42, -1000.55, -99.01),
            length = 14.8,
            width = 24.2,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = -108.41,
                maxZ = -96.21
            }
        },
        locations = {
            wakeup = {
                x = 262.713,
                y = -1003.740,
                z = -99.987,
                h = 6.295,
            },
            logout = {
                x = 262.54,
                y = -1004.2,
                z = -99.01,
                l = 1.8,
                w = 2.2,
                extras = {
                    heading = 0,
                    minZ = -99.96,
                    maxZ = -97.36,
                    --debugPoly = true,
                },
            },
            closet = {
                x = 259.74,
                y = -1004.32,
                z = -99.01,
                l = 0.5,
                w = 1.6,
                extras = {
                    heading = 0,
                    minZ = -99.96,
                    maxZ = -97.36,
                    --debugPoly = true,
                },
            },
            stash = {
                x = 263.99,
                y = -994.87,
                z = -99.01,
                l = 1.0,
                w = 1.6,
                extras = {
                    heading = 0,
                    minZ = -99.96,
                    maxZ = -97.36,
                    --debugPoly = true,
                },
            },
            exit = {
                x = 266.11,
                y = -1007.62,
                z = -99.67,
                l = 0.6,
                w = 1.6,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -102.07,
                    maxZ = -99.47
                }
            },
        },
        garage = 2,
    },
    [1] = {
        x = 942.369,
        y = -652.403,
        z = 58.437,
        h = 86.432,
        exit = vector3(942.601, -652.562, 58.439),
        backdoorExit = vector3(935.444, -651.951, 58.440),
        backdoor = {
            x = 935.372,
            y = -651.883,
            z = 58.440,
            h = 221.485
        },
        zone = {
            center = vector3(941.6, -654.78, 62.58),
            length = 15.4,
            width = 15.8,
            options = {
                heading = 40,
                --debugPoly=true,
                minZ = 55.38,
                maxZ = 60.78
            }
        },
        locations = {
            wakeup = {
                x = 934.138,
                y = -654.312,
                z = 57.5,
                h = 311.571,
            },
            logout = {
                x = 933.56,
                y = -654.65,
                z = 58.44,
                l = 2.8,
                w = 2.0,
                extras = {
                    heading = 40,
                    --debugPoly=true,
                    minZ = 57.64,
                    maxZ = 58.64
                    --debugPoly = true,
                },
            },
            closet = {
                x = 934.77,
                y = -656.97,
                z = 58.44,
                l = 0.8,
                w = 1.6,
                extras = {
                    heading = 310,
                    --debugPoly=true,
                    minZ = 57.44,
                    maxZ = 59.84
                },
            },
            stash = {
                x = 941.94,
                y = -650.37,
                z = 58.44,
                l = 0.6,
                w = 1.4,
                extras = {
                    heading = 40,
                    --debugPoly=true,
                    minZ = 57.44,
                    maxZ = 59.84
                },
            },
            exit = {
                x = 942.97,
                y = -652.88,
                z = 58.56,
                l = 1.4,
                w = 0.4,
                extras = {
                    heading = 310,
                    --debugPoly=true,
                    minZ = 57.41,
                    maxZ = 59.81
                }
            },
            backdoor = {
                x = 935.09,
                y = -651.69,
                z = 58.44,
                l = 1.4,
                w = 0.4,
                extras = {
                    heading = 310,
                    --debugPoly=true,
                    minZ = 57.29,
                    maxZ = 59.69
                }
            },
        },
        robberies = {
            effects = {
                alarm = 0,
                owner = 90,
            },
            pois = {
                alarm = {
                    coords = vector3(942.285645, -653.414734, 58.722286),
                    heading = 219.0,
                    object = `v_res_tre_alarmbox`,
                },
                owner = {
                    coords = vector3(938.000, -651.495, 58.437),
                    heading = 135.621,
                }
            },
            locations = {
                { -- Front Door Table
                    type = "standard",
                    coords = vector3(941.72, -653.52, 58.44),
                    length = 1.4,
                    width = 0.6,
                    options = {
                        heading = 310,
                        --debugPoly=true,
                        minZ = 57.64,
                        maxZ = 58.64
                    }
                },
                {
                    type = "microwave",
                    coords = vector3(943.16, -649.76, 58.46),
                    length = 1.0,
                    width = 0.4,
                    options = {
                        heading = 310,
                        --debugPoly=true,
                        minZ = 58.06,
                        maxZ = 58.86
                    }
                },
                { -- Next to TV
                    type = "standard",
                    coords = vector3(941.95, -650.41, 58.44),
                    length = 1.0,
                    width = 1.4,
                    options = {
                        heading = 40,
                        --debugPoly=true,
                        minZ = 57.44,
                        maxZ = 59.84
                    }
                },
                {
                    type = "tv",
                    coords = vector3(940.62, -651.81, 58.44),
                    length = 0.8,
                    width = 2.0,
                    options = {
                        heading = 40,
                        --debugPoly=true,
                        minZ = 57.64,
                        maxZ = 58.84
                    }
                },
                {
                    type = "pc",
                    coords = vector3(939.35, -658.07, 58.44),
                    length = 2.6,
                    width = 2.0,
                    options = {
                        heading = 310,
                        --debugPoly=true,
                        minZ = 57.64,
                        maxZ = 59.24
                    }
                },
                { -- Bedroom
                    type = "standard",
                    coords = vector3(934.63, -656.81, 58.44),
                    length = 0.6,
                    width = 1.2,
                    options = {
                        heading = 310,
                        --debugPoly=true,
                        minZ = 57.64,
                        maxZ = 59.84
                    }
                },
                {
                    type = "medicine",
                    coords = vector3(942.58, -654.73, 58.44),
                    length = 0.8,
                    width = 1.0,
                    options = {
                        heading = 310,
                        --debugPoly=true,
                        minZ = 57.44,
                        maxZ = 58.44
                    }
                },
            }
        },
        garage = 2,
    },
    [2] = {
        invType = 1001,
        x = 978.247,
        y = -717.089,
        z = 58.221,
        h = 134.118,
        exit = vector3(978.418, -716.940, 58.221),
        backdoorExit = vector3(981.474, -726.265, 58.020),
        backdoor = {
            x = 981.312, 
            y = -726.186, 
            z = 58.020, 
            h = 47.063
        },
        zone = {
            center = vector3(979.89, -721.81, 66.92),
            length = 15.0,
            width = 20.8,
            options = {
                heading = 42,
                --debugPoly=true,
                minZ = 55.32,
                maxZ = 62.52
            }
        },
        locations = {
            wakeup = {
                x = 975.349,
                y = -729.564,
                z = 56.806,
                h = 313.260,
            },
            logout = {
                x = 987.81,
                y = -718.05,
                z = 58.04,
                l = 2.4,
                w = 3.0,
                extras = {
                    heading = 313,
                    minZ = 57.04,
                    maxZ = 58.24
                    --debugPoly = true,
                },
            },
            closet = {
                x = 986.52,
                y = -721.4,
                z = 58.02,
                l = 0.8,
                w = 1.4,
                extras = {
                    heading = 311,
                    --debugPoly=true,
                    minZ = 57.02,
                    maxZ = 59.42
                },
            },
            stash = {
                x = 971.81,
                y = -722.27,
                z = 58.02,
                l = 2.0,
                w = 2.4,
                extras = {
                    heading = 42,
                    --debugPoly=true,
                    minZ = 57.02,
                    maxZ = 59.82
                },
            },
            exit = {
                x = 978.8,
                y = -716.6,
                z = 58.22,
                l = 1.2,
                w = 0.4,
                extras = {
                    heading = 221,
                    --debugPoly=true,
                    minZ = 57.07,
                    maxZ = 59.67
                }
            },
            backdoor = {
                x = 981.48,
                y = -726.59,
                z = 58.02,
                l = 2.0,
                w = 0.4,
                extras = {
                    heading = 311,
                    --debugPoly=true,
                    minZ = 56.87,
                    maxZ = 59.47
                }
            },
        },
        robberies = {
            effects = {
                alarm = 40,
                owner = 80,
            },
            pois = {
                alarm = {
                    coords = vector3(978.857, -718.4066, 58.5406),
                    heading = 221.0,
                    object = `v_res_tre_alarmbox`,
                },
                owner = {
                    coords = vector3(974.070, -727.563, 58.021),
                    heading = 335.774,
                }
            },
            locations = {
                { -- Living Room Drawers
                    type = "standard",
                    coords = vector3(974.02, -722.49, 58.02),
                    length = 1.0,
                    width = 0.6,
                    options = {
                        heading = 310,
                        --debugPoly=true,
                        minZ = 57.02,
                        maxZ = 59.82
                    }
                },
                { -- Bedroom 2
                    type = "standard",
                    coords = vector3(985.49, -720.25, 58.04),
                    length = 1.8,
                    width = 0.8,
                    options = {
                        heading = 222,
                        --debugPoly=true,
                        minZ = 57.04,
                        maxZ = 58.44
                    }
                },
                { -- Hallway Shit
                    type = "standard",
                    coords = vector3(980.03, -718.84, 58.02),
                    length = 2.8,
                    width = 0.8,
                    options = {
                        heading = 132,
                        --debugPoly=true,
                        minZ = 57.02,
                        maxZ = 59.62
                    }
                },
                {
                    type = "microwave",
                    coords = vector3(979.7, -723.03, 58.03),
                    length = 1.0,
                    width = 1.0,
                    options = {
                        heading = 310,
                        --debugPoly=true,
                        minZ = 57.83,
                        maxZ = 58.63
                    }
                },
                {
                    type = "pc",
                    coords = vector3(983.92, -720.2, 58.02),
                    length = 1.6,
                    width = 1.0,
                    options = {
                        heading = 42,
                        --debugPoly=true,
                        minZ = 57.02,
                        maxZ = 58.62
                    }
                },
                {
                    type = "tv",
                    coords = vector3(981.95, -723.75, 58.02),
                    length = 0.8,
                    width = 1.2,
                    options = {
                        heading = 312,
                        --debugPoly=true,
                        minZ = 57.02,
                        maxZ = 58.42
                    }
                },
                {
                    type = "tv",
                    coords = vector3(976.65, -725.01, 58.02),
                    length = 0.8,
                    width = 1.2,
                    options = {
                        heading = 312,
                        --debugPoly=true,
                        minZ = 57.02,
                        maxZ = 58.62
                    }
                },
                {
                    type = "golfclubs",
                    coords = vector3(975.38, -717.9, 58.02),
                    length = 0.6,
                    width = 1.0,
                    options = {
                        heading = 312,
                        --debugPoly=true,
                        minZ = 57.02,
                        maxZ = 58.62
                    }
                },
                {
                    type = "medicine",
                    coords = vector3(986.02, -715.64, 58.06),
                    length = 1.0,
                    width = 1.0,
                    options = {
                        heading = 312,
                        --debugPoly=true,
                        minZ = 57.06,
                        maxZ = 58.46
                    }
                },
            }
        },
        garage = 4,
    },
    [3] = {
        invType = 1002,
        x = -815.740, 
        y = 178.535, 
        z = 72.153, 
        h = 289.890,
        exit = vector3(-815.740, 178.535, 72.153),
        backdoorExit = vector3(-794.495, 181.268, 72.835),
        backdoor = {
            x = -794.522,
            y = 181.251,
            z = 72.835,
            h = 293.258
        },
        zone = {
            center = vector3(-806.3, 179.62, 72.36),
            length = 25.2,
            width = 25.4,
            options = {
                heading = 22,
                --debugPoly=true,
                minZ = 69.76,
                maxZ = 83.56
            }
        },
        locations = {
            wakeup = {
                x = -813.398,
                y = 180.978,
                z = 75.813,
                h = 302.186,
            },
            logout = {
                x = -814.34,
                y = 180.98,
                z = 76.75,
                l = 2.6,
                w = 2.4,
                extras = {
                    heading = 21,
                    --debugPoly=true,
                    minZ = 75.75,
                    maxZ = 77.75
                },
            },
            closet = {
                x = -811.32,
                y = 175.15,
                z = 76.74,
                l = 2.4,
                w = 2.0,
                extras = {
                    heading = 10,
                    --debugPoly=true,
                    minZ = 75.54,
                    maxZ = 78.54
                },
            },
            stash = {
                x = -808.97,
                y = 189.87,
                z = 72.48,
                l = 4.0,
                w = 4.4,
                extras = {
                    heading = 110,
                    --debugPoly=true,
                    minZ = 71.48,
                    maxZ = 74.48
                },
            },
            exit = {
                x = -816.22,
                y = 178.34,
                z = 72.15,
                l = 0.4,
                w = 2.4,
                extras = {
                    heading = 291,
                    --debugPoly=true,
                    minZ = 71.15,
                    maxZ = 74.15
                }
            },
            backdoor = {
                x = -793.87,
                y = 181.5,
                z = 72.83,
                l = 0.4,
                w = 2.4,
                extras = {
                    heading = 295,
                    --debugPoly=true,
                    minZ = 71.83,
                    maxZ = 74.83
                }
            },
        },
        robberies = {
            effects = {
                alarm = 55,
                owner = 65,
            },
            pois = {
                alarm = {
                    coords = vector3(-816.832, 179.9514, 72.437),
                    heading = 100.0,
                    object = `v_res_tre_alarmbox`,
                },
                owner = {
                    coords = vector3(-801.584, 180.266, 72.835),
                    heading = 10.167,
                }
            },
            locations = {
                {
                    type = "microwave",
                    coords = vector3(-804.3, 184.28, 72.61),
                    length = 0.8,
                    width = 2.6,
                    options = {
                        heading = 291,
                        --debugPoly=true,
                        minZ = 71.61,
                        maxZ = 73.81
                    }
                },
                {
                    type = "standard",
                    coords = vector3(-808.22, 181.77, 72.15),
                    length = 0.8,
                    width = 2.6,
                    options = {
                        heading = 201,
                        --debugPoly=true,
                        minZ = 71.15,
                        maxZ = 73.35
                    }
                },
                {
                    type = "boombox",
                    coords = vector3(-807.1, 170.94, 72.84),
                    length = 0.8,
                    width = 5.6,
                    options = {
                        heading = 111,
                        --debugPoly=true,
                        minZ = 71.84,
                        maxZ = 74.84
                    }
                },
                {
                    type = "tv",
                    coords = vector3(-799.13, 172.26, 76.75),
                    length = 0.6,
                    width = 2.4,
                    options = {
                        heading = 111,
                        --debugPoly=true,
                        minZ = 75.75,
                        maxZ = 76.95
                    }
                },
                {
                    type = "standard",
                    coords = vector3(-811.07, 182.04, 76.74),
                    length = 0.6,
                    width = 2.4,
                    options = {
                        heading = 111,
                        --debugPoly=true,
                        minZ = 75.74,
                        maxZ = 76.94
                    }
                },
                {
                    type = "standard",
                    coords = vector3(-811.6, 175.18, 76.75),
                    length = 1.8,
                    width = 2.4,
                    options = {
                        heading = 111,
                        --debugPoly=true,
                        minZ = 75.75,
                        maxZ = 78.15
                    }
                },
                {
                    type = "medicine",
                    coords = vector3(-804.61, 169.32, 76.74),
                    length = 0.8,
                    width = 2.4,
                    options = {
                        heading = 111,
                        --debugPoly=true,
                        minZ = 75.74,
                        maxZ = 78.14
                    }
                },
                {
                    type = "golfclubs",
                    coords = vector3(-809.8, 191.29, 72.48),
                    length = 0.8,
                    width = 1.4,
                    options = {
                        heading = 20,
                        --debugPoly=true,
                        minZ = 71.48,
                        maxZ = 73.28
                    }
                },
                {
                    type = "big_tv",
                    coords = vector3(-812.14, 177.47, 76.74),
                    length = 1.0,
                    width = 2.0,
                    options = {
                        heading = 21,
                        --debugPoly=true,
                        minZ = 75.74,
                        maxZ = 78.54
                    }
                },
                {
                    type = "house_art",
                    coords = vector3(-810.95, 178.09, 72.15),
                    length = 0.8,
                    width = 2.0,
                    options = {
                        heading = 20,
                        --debugPoly=true,
                        minZ = 71.15,
                        maxZ = 75.15
                    }
                },
            }
        },
        garage = 6,
    },
    [4] = {
        invType = 1003,
        x = 373.546,
        y = 423.625,
        z = 145.908,
        h = 168.381,
        exit = vector3(373.546, 423.625, 145.908),
        backdoorExit = vector3(370.081, 403.448, 145.501),
        backdoor = {
            x = 370.081,
            y = 403.447,
            z = 145.501,
            h = 347.579
        },
        zone = {
            center = vector3(374.92, 414.87, 151.87),
            length = 28.6,
            width = 47.2,
            options = {
                heading = 90,
                --debugPoly=true,
                minZ = 135.121,
                maxZ = 155.82
            }
        },
        locations = {
            wakeup = {
                x = 375.389,
                y = 405.353,
                z = 141.228,
                h = 162.001,
            },
            logout = {
                x = 375.94,
                y = 406.15,
                z = 142.1,
                l = 3.6,
                w = 3.6,
                extras = {
                    heading = 346,
                    --debugPoly=true,
                    minZ = 141.1,
                    maxZ = 145.1
                },
            },
            closet = {
                x = 374.43,
                y = 411.94,
                z = 142.1,
                l = 2.4,
                w = 3.2,
                extras = {
                    heading = 347,
                    --debugPoly=true,
                    minZ = 141.1,
                    maxZ = 143.9
                },
            },
            stash = {
                x = 378.13,
                y = 429.82,
                z = 138.3,
                l = 4.0,
                w = 4.0,
                extras = {
                    heading = 345,
                    --debugPoly=true,
                    minZ = 137.3,
                    maxZ = 140.3
                },
            },
            exit = {
                x = 373.71,
                y = 424.1,
                z = 145.91,
                l = 0.4,
                w = 1.6,
                extras = {
                    heading = 346,
                    --debugPoly=true,
                    minZ = 144.91,
                    maxZ = 147.51
                },
            },
            backdoor = {
                x = 371.37,
                y = 402.33,
                z = 145.53,
                l = 1.0,
                w = 6.0,
                extras = {
                    heading = 346,
                    --debugPoly=true,
                    minZ = 144.53,
                    maxZ = 147.33
                }
            },
        },
        robberies = {
            effects = {
                alarm = 70,
                owner = 60,
            },
            pois = {
                alarm = {
                    coords = vector3(372.377, 424.152, 146.113),
                    heading = 75.5,
                    object = `v_res_tre_alarmbox`,
                },
                owner = {
                    coords = vector3(375.414, 419.189, 145.900),
                    heading = 76.807,
                }
            },
            locations = {
                {
                    type = "microwave",
                    coords = vector3(379.73, 416.53, 145.9),
                    length = 1.2,
                    width = 1.2,
                    options = {
                        heading = 355,
                        --debugPoly=true,
                        minZ = 145.5,
                        maxZ = 146.7
                    }
                },
                {
                    type = "big_tv",
                    coords = vector3(376.93, 404.85, 145.5),
                    length = 2.4,
                    width = 1.0,
                    options = {
                        heading = 345,
                        --debugPoly=true,
                        minZ = 144.5,
                        maxZ = 146.9
                    }
                },
                {
                    type = "medicine",
                    coords = vector3(379.36, 418.56, 142.11),
                    length = 2.8,
                    width = 1.0,
                    options = {
                        heading = 75,
                        --debugPoly=true,
                        minZ = 140.91,
                        maxZ = 143.51
                    }
                },
                {
                    type = "pc",
                    coords = vector3(372.71, 432.9, 138.3),
                    length = 3.8,
                    width = 2.0,
                    options = {
                        heading = 345,
                        --debugPoly=true,
                        minZ = 137.3,
                        maxZ = 139.9
                    }
                },
                {
                    type = "boombox",
                    coords = vector3(372.02, 429.92, 138.3),
                    length = 1.0,
                    width = 1.0,
                    options = {
                        heading = 345,
                        --debugPoly=true,
                        minZ = 137.3,
                        maxZ = 138.7
                    }
                },
                {
                    type = "standard",
                    coords = vector3(368.66, 407.9, 142.1),
                    length = 3.2,
                    width = 1.0,
                    options = {
                        heading = 345,
                        --debugPoly=true,
                        minZ = 141.1,
                        maxZ = 142.7
                    }
                },
                {
                    type = "house_art",
                    coords = vector3(374.17, 419.24, 142.1),
                    length = 2.4,
                    width = 1.0,
                    options = {
                        heading = 345,
                        --debugPoly=true,
                        minZ = 141.1,
                        maxZ = 144.1
                    }
                },
                {
                    type = "house_art",
                    coords = vector3(380.28, 422.85, 140.3),
                    length = 2.4,
                    width = 1.0,
                    options = {
                        heading = 345,
                        --debugPoly=true,
                        minZ = 139.3,
                        maxZ = 142.3
                    }
                },
                {
                    type = "standard",
                    coords = vector3(369.74, 412.79, 145.7),
                    length = 4.0,
                    width = 1.0,
                    options = {
                        heading = 345,
                        --debugPoly=true,
                        minZ = 144.7,
                        maxZ = 147.1
                    }
                },
                {
                    type = "standard",
                    coords = vector3(370.7, 426.28, 138.3),
                    length = 2.6,
                    width = 1.0,
                    options = {
                        heading = 345,
                        --debugPoly=true,
                        minZ = 137.3,
                        maxZ = 140.1
                    }
                },
            }
        },
        garage = 8,
    },
    [5] = {
        invType = 1004,
        x = 7.738, 
        y = 538.287, 
        z = 176.028, 
        h = 151.198,
        exit = vector3(7.738, 538.287, 176.028),
        backdoorExit = vector3(-4.003, 518.315, 174.642),
        backdoor = {
            x = -4.003,
            y = 518.315,
            z = 174.642,
            h = 54.494
        },
        zone = {
            center = vector3(-2.7, 525.76, 183.62),
            length = 28.0,
            width = 47.2,
            options = {
                heading = 25,
                --debugPoly=true,
                minZ = 162.22,
                maxZ = 180.82
            }
        },
        locations = {
            wakeup = {
                x = -0.911,
                y = 525.111,
                z = 169.819,
                h = 22.828,
            },
            logout = {
                x = -1.11,
                y = 524.04,
                z = 170.63,
                l = 3.0,
                w = 3.0,
                extras = {
                    heading = 25,
                    --debugPoly=true,
                    minZ = 169.63,
                    maxZ = 172.63
                },
            },
            closet = {
                x = 9.73,
                y = 529.16,
                z = 170.64,
                l = 5.2,
                w = 2.0,
                extras = {
                    heading = 25,
                    --debugPoly=true,
                    minZ = 169.64,
                    maxZ = 173.04
                },
            },
            stash = {
                x = -9.74,
                y = 531.26,
                z = 170.62,
                l = 3.2,
                w = 2.0,
                extras = {
                    heading = 25,
                    --debugPoly=true,
                    minZ = 169.62,
                    maxZ = 172.42
                },
            },
            exit = {
                x = 8.23,
                y = 538.92,
                z = 176.03,
                l = 0.4,
                w = 2.0,
                extras = {
                    heading = 330,
                    --debugPoly=true,
                    minZ = 175.03,
                    maxZ = 178.03
                },
            },
            backdoor = {
                x = -4.02,
                y = 516.85,
                z = 174.63,
                l = 0.4,
                w = 6.4,
                extras = {
                    heading = 60,
                    --debugPoly=true,
                    minZ = 173.63,
                    maxZ = 176.83
                }
            },
        },
        garage = 10,
    },
    [6] = false,
    [40] = { -- Trevor Trailer
        x = 1973.103,
        y = 3816.142,
        z = 33.429,
        h = 29.059,
        exit = vector3(1973.103, 3816.142, 33.429),
        zone = {
            center = vector3(1974.19, 3819.21, 33.44),
            length = 9.2,
            width = 16.6,
            options = {
                heading = 30,
                --debugPoly=true,
                minZ = 30.84,
                maxZ = 36.44
            }
        },
        locations = {
            wakeup = {
                x = 1969.152,
                y = 3816.672,
                z = 32.206,
                h = 300.609,
            },
            logout = {
                x = 1968.11,
                y = 3816.85,
                z = 34.01,
                l = 2.6,
                w = 2.0,
                extras = {
                    heading = 30,
                    --debugPoly=true,
                    minZ = 32.61,
                    maxZ = 34.01
                },
            },
            closet = {
                x = 1968.92, 
                y = 3814.19, 
                z = 33.43,
                l = 2.6,
                w = 1.0,
                extras = {
                    heading = 30,
                    --debugPoly=true,
                    minZ = 32.43,
                    maxZ = 35.03
                },
            },
            stash = {
                x = 1977.61, 
                y = 3819.28, 
                z = 33.45,
                l = 1.8,
                w = 4.0,
                extras = {
                    heading = 30,
                    --debugPoly=true,
                    minZ = 32.45,
                    maxZ = 34.85
                },
            },
            exit = {
                x = 1973.39,
                y = 3815.6,
                z = 33.43,
                l = 1.0,
                w = 2.0,
                extras = {
                    heading = 30,
                    --debugPoly=true,
                    minZ = 32.43,
                    maxZ = 35.03
                }
            },
        },
        garage = 2,
    },
    [69] = {
        invType = 1000,
        x = -1578.138,
        y = -563.817,
        z = 108.523,
        h = 126.474,
        exit = vector3(-1578.138, -563.817, 108.523),
        backdoorExit = vector3(-1584.088, -559.739, 108.523),
        backdoor = {
            x = -1583.887,
            y = -559.613,
            z = 108.523,
            h = 304.464,
        },
        locations = {
            logout = {
                x = -1560.03,
                y = -567.72,
                z = 108.52,
                l = 3.6,
                w = 1.4,
                extras = {
                    heading = 36,
                    --debugPoly=true,
                    minZ = 107.52,
                    maxZ = 108.52
                },
            },
            closet = {
                x = -1561.97,
                y = -569.11,
                z = 108.52,
                l = 2.6,
                w = 1.0,
                extras = {
                    heading = 36,
                    --debugPoly=true,
                    minZ = 107.52,
                    maxZ = 110.12
                },
            },
            stash = {
                x = -1576.49,
                y = -582.93,
                z = 108.52,
                l = 1.8,
                w = 1.0,
                extras = {
                    heading = 36,
                    --debugPoly=true,
                    minZ = 107.52,
                    maxZ = 110.12
                },
            },
            exit = {
                x = -1579.69,
                y = -562.97,
                z = 108.52,
                l = 3.4,
                w = 5.0,
                extras = {
                    heading = 305,
                    --debugPoly=true,
                    minZ = 107.52,
                    maxZ = 110.12
                },
            },
            backdoor = {
                x = -1584.28,
                y = -559.79,
                z = 108.52,
                l = 1.8,
                w = 1.0,
                extras = {
                    heading = 36,
                    --debugPoly=true,
                    minZ = 107.52,
                    maxZ = 109.92
                }
            },
            office = {
                x = -1570.94,
                y = -573.87,
                z = 108.52,
                l = 2.0,
                w = 1.2,
                extras = {
                    heading = 306,
                    --debugPoly=true,
                    minZ = 108.12,
                    maxZ = 109.32
                },
            },
        },
        garage = 4,
    },
    [100] = {
        invType = 1010,
        x = 1087.496,
        y = -3099.390,
        z = -39.000,
        h = 268.047,
        exit = vector3(1087.496, -3099.390, -39.000),
        backdoorExit = vector3(1105.109, -3099.760, -39.000),
        backdoor = {
            x = 1105.109,
            y = -3099.760,
            z = -39.000,
            h = 92.823,
        },
        locations = {
            warehouse = {
                x = 1087.66,
                y = -3101.33,
                z = -39.0,
                l = 1.0,
                w = 1.0,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -39.6,
                    maxZ = -38.4
                },
            },
            stash = {
                x = 1096.19,
                y = -3096.54,
                z = -39.0,
                l = 18.0,
                w = 2.8,
                extras = {
                    heading = 270,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -37.0
                },
            },
            exit = {
                x = 1087.24,
                y = -3099.4,
                z = -39.0,
                l = 1.4,
                w = 0.4,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -37.6
                }
            },
            backdoor = {
                x = 1105.3,
                y = -3099.4,
                z = -39.0,
                l = 3.6,
                w = 0.4,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -36.8
                }
            },
        },
        garage = 2,
    },
    [101] = {
        invType = 1011,
        x = 1048.231,
        y = -3097.037,
        z = -39.000,
        h = 267.443,
        exit = vector3(1048.231, -3097.037, -39.000),
        backdoorExit = vector3(1072.785, -3102.192, -39.000),
        backdoor = {
            x = 1072.785,
            y = -3102.192,
            z = -39.000,
            h = 87.643,
        },
        locations = {
            warehouse = {
                x = 1048.26,
                y = -3100.67,
                z = -39.0,
                l = 1.2,
                w = 1.0,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -39.6,
                    maxZ = -38.6
                },
            },
            stash = {
                x = 1060.44,
                y = -3102.76,
                z = -39.0,
                l = 17.6,
                w = 18.2,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -36.0
                },
            },
            exit = {
                x = 1047.84,
                y = -3097.13,
                z = -39.0,
                l = 1.5,
                w = 0.3,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -37.6
                }
            },
            backdoor = {
                x = 1073.26,
                y = -3102.61,
                z = -39.0,
                l = 5.0,
                w = 0.5,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -35.4
                }
            },
        },
        garage = 4,
    },
    [102] = {
        invType = 1012,
        x = 992.502,
        y = -3097.861,
        z = -38.996,
        h = 267.804,
        exit = vector3(992.502, -3097.861, -38.996),
        backdoorExit = vector3(1027.284, -3101.488, -39.000),
        backdoor = {
            x = 1027.284,
            y = -3101.488,
            z = -39.000,
            h = 86.237,
        },
        locations = {
            warehouse = {
                x = 995.37,
                y = -3099.86,
                z = -39.0,
                l = 2.4,
                w = 1.0,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -38.2
                },
            },
            stash = {
                x = 1011.09,
                y = -3100.87,
                z = -39.0,
                l = 20.6,
                w = 18.4,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -33.8
                },
            },
            exit = {
                x = 992.17,
                y = -3097.82,
                z = -39.0,
                l = 1.4,
                w = 0.4,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -37.8
                }
            },
            backdoor = {
                x = 1027.98,
                y = -3101.47,
                z = -39.0,
                l = 5.0,
                w = 0.5,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = -40.0,
                    maxZ = -35.4
                }
            },
        },
        garage = 6,
    },
    [150] = {
        invType = 1020,
        x = -836.086,
        y = -401.542,
        z = 31.564,
        h = 357.346,
        exit = vector3(-836.086, -401.542, 31.564),
        locations = {
            stash = {
                x = -836.53,
                y = -393.18,
                z = 31.56,
                l = 2.8,
                w = 1.0,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 30.56,
                    maxZ = 32.96
                },
            },
            exit = {
                x = -836.22,
                y = -402.27,
                z = 31.56,
                l = 0.4,
                w = 1.4,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 30.56,
                    maxZ = 33.16
                }
            },
            crafting = {
                x = -835.62,
                y = -396.14,
                z = 31.56,
                l = 3.6,
                w = 2.6,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 30.56,
                    maxZ = 32.76
                }
            },
        },
        garage = 0,
    },
    [151] = {
        invType = 1020,
        x = -826.415,
        y = -399.982,
        z = 31.564,
        h = 2.435,
        exit = vector3(-826.415, -399.982, 31.564),
        locations = {
            stash = {
                x = -827.56,
                y = -390.12,
                z = 31.56,
                l = 0.6,
                w = 1.2,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 30.56,
                    maxZ = 33.96
                },
            },
            exit = {
                x = -826.5,
                y = -401.17,
                z = 31.56,
                l = 2.0,
                w = 2.0,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 30.56,
                    maxZ = 32.96
                }
            },
            crafting = {
                x = -825.48,
                y = -392.41,
                z = 31.56,
                l = 2.2,
                w = 2.0,
                extras = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 30.56,
                    maxZ = 32.76
                }
            },
        },
        garage = 0,
    },
}