_vehicleRentals = {
    {
        name = 'Cheap-O Rent-a-Car',
        coords = vector3(34.726, -883.911, 29.239),
        blip = {
            sprite = 545,
            color = 52,
            scale = 0.5,
        },
        interactionPed = {
            model = `cs_andreas`,
            heading = 59.994,
            scenario = 'WORLD_HUMAN_SMOKING',
            range = 45.0,
        },
        zone = {
            type = 'box',
            center = vector3(36.28, -883.65, 30.0),
            length = 37.2,
            width = 40.2,
            options = {
                heading = 340,
                --debugPoly=true,
                minZ = 29.0,
                maxZ = 34.4
            }
        },
        spaces = {
            vector4(19.269, -880.771, 29.932, 160.314),
            vector4(22.540, -882.039, 29.925, 160.147),
            vector4(25.687, -883.276, 29.918, 159.130),
            vector4(37.845, -887.921, 29.895, 161.070),
            vector4(41.205, -889.100, 29.887, 160.784),
            vector4(44.383, -890.423, 29.875, 160.546),
            vector4(47.775, -891.521, 29.869, 160.408),
            vector4(50.878, -892.764, 29.863, 160.667),
            vector4(21.025, -875.657, 30.017, 340.408),
            vector4(24.360, -876.939, 30.009, 339.909),
            vector4(27.370, -878.422, 29.997, 338.650),
            vector4(39.728, -882.426, 29.982, 341.148),
            vector4(43.113, -883.563, 29.975, 338.832),
            vector4(46.590, -884.665, 29.965, 338.481),
            vector4(49.577, -886.483, 29.947, 341.453),
            vector4(52.625, -887.737, 29.938, 338.446),
            vector4(50.580, -873.756, 30.135, 156.466),
            vector4(47.353, -872.341, 30.148, 160.120),
            vector4(44.114, -871.067, 30.161, 162.846),
            vector4(31.479, -866.925, 30.183, 160.451),
            vector4(25.033, -864.335, 30.203, 158.437),
        },
        vehicleList = {
            {
                make = 'Pegassi',
                model = 'Faggio',
                description = 'Small Scooter',
                vehicle = `faggio`,
                cost = {
                    deposit = 500,
                    payment = 650,
                }
            },
            {
                make = 'Weeny',
                model = 'Issi',
                description = 'Small Hatchback',
                vehicle = `issi2`,
                cost = {
                    deposit = 850,
                    payment = 800,
                }
            },
            {
                make = 'Maxwell',
                model = 'Asbo',
                description = 'Small Hatchback',
                vehicle = `asbo`,
                cost = {
                    deposit = 850,
                    payment = 1000,
                }
            },
            {
                make = 'Karin',
                model = 'Dilettante',
                description = 'Hybrid Hatchback',
                vehicle = `dilettante`,
                cost = {
                    deposit = 1200,
                    payment = 1000,
                }
            },
            {
                make = 'Karin',
                model = 'Asterope',
                description = 'Medium Sedan',
                vehicle = `asterope`,
                cost = {
                    deposit = 1000,
                    payment = 1500,
                }
            },
            {
                make = 'Cheval',
                model = 'Surge',
                description = 'Medium Electric Sedan',
                vehicle = `surge`,
                cost = {
                    deposit = 1500,
                    payment = 1500,
                }
            },
            {
                make = 'Dinka Sugoi',
                model = 'Sugoi',
                description = 'Medium Sporty Sedan',
                vehicle = `sugoi`,
                cost = {
                    deposit = 1800,
                    payment = 3000,
                }
            },
            {
                make = 'Ubermacht',
                model = 'Oracle',
                description = 'Larger Sedan',
                vehicle = `oracle2`,
                cost = {
                    deposit = 1500,
                    payment = 3500,
                }
            },
            {
                make = 'Cheval',
                model = 'Fugitive',
                description = 'Larger Sedan',
                vehicle = `fugitive`,
                cost = {
                    deposit = 2750,
                    payment = 5000,
                }
            },
            {
                make = 'Ubermacht',
                model = 'Sentinel',
                description = 'Coupe',
                vehicle = `sentinel2`,
                cost = {
                    deposit = 2150,
                    payment = 7000,
                }
            },
            {
                make = 'Karin',
                model = 'BeeJay XL',
                description = 'SUV',
                vehicle = `bjxl`,
                cost = {
                    deposit = 1000,
                    payment = 2500,
                }
            },
            {
                make = 'Bravado',
                model = 'Gresley',
                description = 'SUV',
                vehicle = `gresley`,
                cost = {
                    deposit = 1500,
                    payment = 3500,
                }
            },
            {
                make = 'Fathom',
                model = 'FQ 2',
                description = 'SUV',
                vehicle = `fq2`,
                cost = {
                    deposit = 1500,
                    payment = 4500,
                }
            },
            {
                make = 'Bravado',
                model = 'Buffalo',
                description = 'Speedy Machine',
                vehicle = `buffalo`,
                cost = {
                    deposit = 2000,
                    payment = 5000,
                }
            },
            {
                make = 'Karin',
                model = 'Sultan',
                description = 'Speedy Machine',
                vehicle = `sultan`,
                cost = {
                    deposit = 2000,
                    payment = 9500,
                }
            },
            {
                make = 'Bravado',
                model = 'Bison',
                description = 'Pickup Truck',
                vehicle = `bison`,
                cost = {
                    deposit = 1500,
                    payment = 3000,
                }
            },
            {
                make = 'Vapid',
                model = 'Speedo',
                description = 'Cargo Van',
                vehicle = `speedo4`,
                cost = {
                    deposit = 2000,
                    payment = 7000,
                }
            },
        }
    },
    {
        name = 'Dave\'s Boat Rental\'s',
        coords = vector3(-906.603, -1464.646, 0.6),
        blip = {
            sprite = 410,
            color = 18,
            scale = 0.6,
        },
        interactionPed = {
            model = `ig_money`,
            heading = 200.0,
            scenario = 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT',
            range = 45.0,
        },
        zone = {
            type = 'box',
            center = vector3(-908.1, -1464.83, 1.63),
            length = 32.4,
            width = 56.2,
            options = {
                heading = 20,
                minZ = -2.37,
                maxZ = 3.63
            }
        },
        spaces = {
            vector4(-928.031, -1475.646, 0.363, 20.066),
            vector4(-919.512, -1472.215, 0.422, 20.783),
            vector4(-910.828, -1469.398, 0.404, 21.109),
            vector4(-900.550, -1466.493, 0.468, 20.181),
            vector4(-892.752, -1461.480, 0.383, 20.101),
            vector4(-884.057, -1458.434, 0.338, 20.844)
        },
        vehicleList = {
            {
                make = 'Speedophile',
                model = 'Seashark',
                description = 'Dual Seat Jetski',
                noPlate = true,
                vehicle = `seashark`,
                cost = {
                    deposit = 750,
                    payment = 500,
                }
            },
            {
                make = 'Shitzu',
                model = 'Suntrap',
                description = 'Small Motorboat',
                noPlate = true,
                vehicle = `suntrap`,
                cost = {
                    deposit = 1000,
                    payment = 1000,
                }
            },
            {
                make = 'Nagasaki',
                model = 'Dinghy',
                description = 'Dinghy',
                noPlate = true,
                vehicle = `dinghy`,
                cost = {
                    deposit = 2000,
                    payment = 6000,
                }
            },
            {
                make = 'Shitzu',
                model = 'Tropic',
                description = 'Motor Yacht',
                noPlate = true,
                vehicle = `tropic`,
                cost = {
                    deposit = 2000,
                    payment = 6500,
                }
            },
        }
    },
    {
        name = 'Luxury Vehicle Rentals',
        coords = vector3(-1118.855, -322.916, 36.9),
        blip = {
            sprite = 545,
            color = 66,
            scale = 0.5,
        },
        interactionPed = {
            model = `s_m_m_highsec_02`,
            heading = 0.5,
            scenario = 'CODE_HUMAN_MEDIC_TIME_OF_DEATH',
            range = 35.0,
        },
        spaces = {
            vector4(-1108.954, -319.521, 37.367, 85.380),
            vector4(-1125.263, -318.430, 37.365, 85.093),
            vector4(-1115.250, -309.455, 37.353, 85.023),
            vector4(-1140.634, -329.315, 37.362, 175.014),
            vector4(-1142.099, -346.149, 37.371, 175.051),
            vector4(-1135.691, -328.681, 37.362, 175.239),
            vector4(-1137.021, -342.300, 37.365, 175.047)
        },
        zone = {
            type = 'box',
            center = vector3(-1123.6, -324.48, 37.82),
            length = 39.0,
            width = 35.2,
            options = {
                heading = 355,
                minZ = 36.62,
                maxZ = 40.82
            }
        },
        vehicleList = {
            {
                make = 'Gallivanter',
                model = 'Baller LWB',
                description = 'Luxury SUV',
                vehicle = `baller4`,
                cost = {
                    deposit = 6000,
                    payment = 7500,
                }
            },
            {
                make = 'Albany',
                model = 'V-STR',
                description = 'High End Sports Sedan',
                vehicle = `vstr`,
                cost = {
                    deposit = 6000,
                    payment = 7500,
                }
            },
            {
                make = 'Albany',
                model = 'Stretch',
                description = 'Executive Limousine',
                vehicle = `stretch`,
                cost = {
                    deposit = 10000,
                    payment = 7000,
                }
            },
            {
                make = 'Mammoth',
                model = 'Patriot Stretch',
                description = 'Executive Limousine SUV',
                vehicle = `patriot2`,
                cost = {
                    deposit = 12500,
                    payment = 7000,
                }
            },
            {
                make = 'Enus',
                model = 'Super Diamond',
                description = 'Luxury 4 Door Sedan',
                vehicle = `superd`,
                cost = {
                    deposit = 12500,
                    payment = 14000,
                }
            },
            {
                make = 'Enus',
                model = 'Windsor Drop',
                description = '4 Door Luxury Convertible',
                vehicle = `windsor2`,
                cost = {
                    deposit = 15000,
                    payment = 10000,
                }
            },
            {
                make = 'Enus',
                model = 'Stafford',
                description = 'Vintage Luxury Sedan',
                vehicle = `stafford`,
                cost = {
                    deposit = 12000,
                    payment = 6500,
                }
            },
        }
    },
}