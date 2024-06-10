addDoorsListToConfig({
    { -- PDM Office 1
        model = 2089009131,
        coords = vector3(-30.43, -1102.47, 27.42),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'pdm', jobPermission = false, reqDuty = false },
        },
    },
    { -- PDM Office 2
        model = 2089009131,
        coords = vector3(-32.64, -1108.56, 27.42),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'pdm', jobPermission = false, reqDuty = false },
        },
    },
    { -- PDM Office 2
        model = 2089009131,
        coords = vector3(-27.62, -1094.76, 27.42),
        locked = true,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'pdm', jobPermission = false, reqDuty = false },
        },
    },

    { -- PDM Outer
        model = 1973010099,
        coords = vector3(-48.13, -1103.5, 27.61),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'pdm', jobPermission = false, reqDuty = false },
        },
    },
    { -- PDM Outer
        model = 1973010099,
        coords = vector3(-55.95, -1088.07, 27.61),
        locked = false,
        autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'pdm', jobPermission = false, reqDuty = false },
        },
    },

    { -- PDM Garage
        id = 'pdm_garage',
        model = 1010499530,
        coords = vector3(-21.51, -1089.39, 28.15),
        locked = true,
        special = true,
        --autoRate = 6.0,
        restricted = {
            { type = 'job', job = 'pdm', jobPermission = false, reqDuty = false },
        },
    },
})