_performanceUpgrades = {
    engine = 11,
    transmission = 13,
    brakes = 12,
    suspension = 15,
    turbo = 18,
}

--[[

Performance Parts

-1 is Stock
0 is Level 1
1 is Level 2
... You get the point

THE LOWEST LEVEL IS DEFAULT SO PUT THE STUFF BACK TO NORMAL

handling

Array of objects containing the changes
fieldType - Float, Vector, Int
multiplier - if true is a multiplier of the current value


]]

_pursuitModeConfig = {
    -- [`leo4`] = {
    --     {
    --         name = 'A',
    --         performance = {
    --             engine = -1,
    --             transmission = -1,
    --             brakes = -1,
    --             suspension = -1,
    --             turbo = false,
    --         },
    --         handling = false, -- Reset
    --     },
    --     {
    --         name = 'A+',
    --         performance = {
    --             engine = -1,
    --             transmission = -1,
    --             brakes = -1,
    --             suspension = -1,
    --             turbo = true,
    --         },
    --         handling = {
    --             {
    --                 field = 'fInitialDriveForce',
    --                 fieldType = 'Float',
    --                 multiplier = true,
    --                 value = 10.0,
    --             },
    --         }
    --     },
    --     {
    --         name = 'S',
    --     },
    --     {
    --         name = 'S+',
    --     }
    -- }
    [`em20srt`] = {
        {
            name = 'A',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = false,
            },
            handling = false, -- Reset
        },
        {
            name = 'A+',
            performance = {
                engine = 4,
                transmission = 3,
                brakes = 3,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.311000,
                },
            }
        },
        {
            name = 'S',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.281000,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 1.80000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 190.000000,
                },
            },
        },
        {
            name = 'S+',
            performance = {
                engine = 4,
                transmission = 4,
                brakes = 4,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.386000,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 2.2,
                },
                {
                    field = 'fClutchChangeRateScaleUpShift',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 2.900000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 200.000000,
                },
            },
        },
    },



    [`policebikerb`] = {
        {
            name = 'A',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = false,
            },
            handling = false, -- Reset
        },
        {
            name = 'A+',
            performance = {
                engine = 4,
                transmission = 3,
                brakes = 3,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.505069,
                },
            }
        },
        {
            name = 'S',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.505069,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 1.80000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 190.000000,
                },
            },
        },
        {
            name = 'S+',
            performance = {
                engine = 4,
                transmission = 4,
                brakes = 4,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = true,
                    value = 2.5,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 2.2,
                },
                {
                    field = 'fClutchChangeRateScaleUpShift',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 2.650000,
                },
            },
        },
    },




    [`em21ltz`] = {
        {
            name = 'A',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = false,
            },
            handling = false, -- Reset
        },
        {
            name = 'A+',
            performance = {
                engine = 4,
                transmission = 3,
                brakes = 3,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.305000,
                },
            }
        },
        {
            name = 'S',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.315000,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 1.80000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 190.000000,
                },
            },
        },
        {
            name = 'S+',
            performance = {
                engine = 4,
                transmission = 4,
                brakes = 4,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.465000,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 2.2,
                },
                {
                    field = 'fClutchChangeRateScaleUpShift',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 2.650000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 220.000000,
                },
            },
        },
    },




    [`RBDEMON`] = {
        {
            name = 'A',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = false,
            },
            handling = false, -- Reset
        },
        {
            name = 'A+',
            performance = {
                engine = 4,
                transmission = 3,
                brakes = 3,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.305000,
                },
            }
        },
        {
            name = 'S',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.315000,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 1.80000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 190.000000,
                },
            },
        },
        {
            name = 'S+',
            performance = {
                engine = 4,
                transmission = 4,
                brakes = 4,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.465000,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 2.2,
                },
                {
                    field = 'fClutchChangeRateScaleUpShift',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 3.250000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 220.000000,
                },
            },
        },
    },
    [`21c318muscle`] = {
        {
            name = 'A',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = false,
            },
            handling = false, -- Reset
        },
        {
            name = 'A+',
            performance = {
                engine = 4,
                transmission = 3,
                brakes = 3,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.345000,
                },
            }
        },
        {
            name = 'S',
            performance = {
                engine = -1,
                transmission = -1,
                brakes = -1,
                suspension = -1,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.355000,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 1.80000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 190.000000,
                },
            },
        },
        {
            name = 'S+',
            performance = {
                engine = 4,
                transmission = 4,
                brakes = 4,
                suspension = 4,
                turbo = true,
            },
            handling = {
                {
                    field = 'fInitialDriveForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 0.465000,
                },
                {
                    field = 'fBrakeForce',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 2.2,
                },
                {
                    field = 'fClutchChangeRateScaleUpShift',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 3.250000,
                },
                {
                    field = 'fInitialDriveMaxFlatVel',
                    fieldType = 'Float',
                    multiplier = false,
                    value = 220.000000,
                },
            },
        },
    },




}