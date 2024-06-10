_dealerships = {
    ['pdm'] = {
        id = 'pdm',
        abbreviation = 'PDM',
        name = 'Premium Deluxe Motorsport',
        profitPercents = {
            default = 15,
            min = 10,
            max = 25,
        },
        commission = 25,
        emails = {
            sales = 'sales@premiumdeluxe.com',
            loans = 'loans@premiumdeluxe.com',
        },
        blip = {
            coords = vector3(-38.0, -1099.0, 26.0),
            sprite = 523,
            colour = 57,
            scale = 0.6,
        },
        zones = {
            -- Polyzone surrounding the entire dealership, showroom cars only spawn within this zone
            dealership = {
                type = 'poly',
                points = {
                    vector2(-1.282169342041, -1081.4558105469),
                    vector2(-19.788076400757, -1074.6860351562),
                    vector2(-22.219783782959, -1081.3433837891),
                    vector2(-63.157688140869, -1066.3566894531),
                    vector2(-80.589126586914, -1116.6845703125),
                    vector2(-64.742156982422, -1122.2971191406),
                    vector2(-15.041819572449, -1120.1148681641)
                },
                options = {
                    minZ = 21.0,
                    maxZ = 45.0,
                }
            },
            catalog = {
                {
                    type = 'box',
                    center = vector3(-51.73, -1095.03, 27.27),
                    length = 1,
                    width = 1,
                    options = {
                        heading = 28,
                        minZ = 26.27,
                        maxZ = 28.27
                    },
                },
                {
                    type = 'box',
                    center = vector3(-51.13, -1086.99, 27.27),
                    length = 1,
                    width = 1,
                    options = {
                        heading = 338,
                        minZ = 26.27,
                        maxZ = 28.27
                    },
                },
                {
                    type = 'box',
                    center = vector3(-40.27, -1094.44, 27.27),
                    length = 1,
                    width = 1,
                    options = {
                        heading = 295,
                        minZ = 26.27,
                        maxZ = 28.27
                    },
                },
                {
                    type = 'box',
                    center = vector3(-39.02, -1100.29, 27.27),
                    length = 1,
                    width = 1,
                    options = {
                        heading = 295,
                        minZ = 26.27,
                        maxZ = 28.27
                    },
                },
                {
                    type = 'box',
                    center = vector3(-46.887, -1095.525, 27.274),
                    length = 1,
                    width = 1,
                    options = {
                        heading = 291,
                        minZ = 26.27,
                        maxZ = 28.27
                    },
                },
            },
            -- Array of different BOX zones for targeting interaction
            employeeInteracts = {
                { -- PDM
                    center = vector3(-40.82, -1085.29, 27.27),
                    length = 1.0,
                    width = 5.0,
                    options = {
                        heading = 340,
                        minZ = 26.27,
                        maxZ = 27.87
                    }
                },
                { -- PDM
                    center = vector3(-32.19, -1088.49, 27.27),
                    length = 1.0,
                    width = 5.0,
                    options = {
                        heading = 340,
                        minZ = 26.27,
                        maxZ = 27.87
                    }
                },
                { -- PDM
                    center = vector3(-26.4, -1104.46, 27.27),
                    length = 0.8,
                    width = 2.6,
                    options = {
                        heading = 250,
                        minZ = 26.27,
                        maxZ = 27.87
                    }
                },
                { -- PDM
                    center = vector3(-27.36, -1107.16, 27.27),
                    length = 0.8,
                    width = 2.6,
                    options = {
                        heading = 250,
                        minZ = 26.27,
                        maxZ = 27.87
                    }
                },
                { -- PDM
                    center = vector3(-31.8, -1097.31, 27.27),
                    length = 0.8,
                    width = 5.0,
                    options = {
                        heading = 250,
                        minZ = 26.27,
                        maxZ = 27.87
                    }
                },
            },
            buyback = {
                type = 'box',
                center = vector3(-23.6, -1094.49, 27.31),
                length = 10.4,
                width = 6.6,
                options = {
                    heading = 340,
                    --debugPoly=true,
                    minZ = 26.31,
                    maxZ = 29.91
                }
            }
        },
        showroom = {
            vector4(-42.260, -1101.108, 26.817, 200.276),
            vector4(-47.382, -1092.079, 26.818, 251.945),
            vector4(-54.637, -1096.546, 26.819, 181.830),
            vector4(-49.802, -1083.960, 26.818, 204.186),
            vector4(-36.615, -1093.333, 26.819, 165.214),
        },
        storage = {
            Type = 1,
            Id = 'pdm_delivery',
        }
    },
    ['tuna'] = {
        id = 'tuna',
        abbreviation = '6STR',
        name = '6STR Motors',
        profitPercents = {
            default = 15,
            min = 10,
            max = 25,
        },
        commission = 25,
        emails = {
            sales = 'sales@6str.net',
            loans = 'loans@6str.net',
        },
        zones = {
            -- Polyzone surrounding the entire dealership, showroom cars only spawn within this zone
            dealership = {
                type = 'box',
                center = vector3(154.67, -3028.78, 7.04),
                length = 63.6,
                width = 69.0,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 3.64,
                    maxZ = 14.64
                }
            },
            catalog = {
                -- {
                --     type = 'box',
                --     center = vector3(-51.73, -1095.03, 27.27),
                --     length = 1,
                --     width = 1,
                --     options = {
                --         heading = 28,
                --         minZ = 26.27,
                --         maxZ = 28.27
                --     },
                -- },
            },
            -- Array of different BOX zones for targeting interaction
            employeeInteracts = {
                {
                    center = vector3(123.69, -3028.24, 7.04),
                    length = 1.0,
                    width = 0.6,
                    options = {
                        heading = 270,
                        minZ = 6.64,
                        maxZ = 7.44
                    }
                },
                {
                    center = vector3(125.48, -3007.18, 7.04),
                    length = 0.8,
                    width = 2.0,
                    options = {
                        heading = 0,
                        --debugPoly=true,
                        minZ = 6.64,
                        maxZ = 7.64
                    }
                },
                {
                    center = vector3(134.02, -3013.64, 10.7),
                    length = 0.8,
                    width = 1.2,
                    options = {
                        heading = 270,
                        --debugPoly=true,
                        minZ = 9.9,
                        maxZ = 10.9
                    }
                },
            },
            buyback = {
                type = 'box',
                center = vector3(129.93, -3000.37, 7.03),
                length = 10.0,
                width = 6.2,
                options = {
                    heading = 0,
                    --debugPoly=true,
                    minZ = 6.03,
                    maxZ = 10.43
                }
            }
        },
        showroom = {
            vector4(146.46, -3046.66, 6.36, 330.08),
            vector4(142.18, -3045.47, 6.36, 330.08),
            vector4(137.59, -3044.49, 6.37, 330.08),
            vector4(147.54, -3017.87, 6.36, 216.45),
            vector4(140.02, -3017.71, 6.36, 216.45),
        },
        storage = {
            Type = 1,
            Id = 'tuna_delivery',
        },
    },
}