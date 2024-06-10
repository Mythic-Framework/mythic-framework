local vanillaUnicornDoorPerms = {
    {
        type = 'job',
        job = 'unicorn',
        gradeLevel = 0,
        jobPermission = 'JOB_DOORS',
        reqDuty = false
    }
}

addDoorsListToConfig({
    {
        model = -1116041313,
        coords = vector3(127.95, -1298.51, 29.42),
        locked = true,
        autoRate = 6.0,
        restricted = vanillaUnicornDoorPerms,
    },
    {
        model = 1695461688,
        coords = vector3(128.07, -1279.35, 29.44),
        locked = true,
        autoRate = 6.0,
        restricted = vanillaUnicornDoorPerms,
    },
    {
        model = 390840000,
        coords = vector3(116.23, -1294.59, 29.44),
        locked = true,
        autoRate = 6.0,
        restricted = vanillaUnicornDoorPerms,
    },
    {
        model = 390840000,
        coords = vector3(113.41, -1296.26, 29.44),
        locked = true,
        autoRate = 6.0,
        restricted = vanillaUnicornDoorPerms,
    },
    {
        model = 390840000,
        coords = vector3(99.08, -1293.69, 29.44),
        locked = true,
        autoRate = 6.0,
        restricted =  {
            {
                type = 'job',
                job = 'unicorn',
                gradeLevel = 99,
                jobPermission = 'JOB_DOORS',
                reqDuty = false
            }
        },
    },
    {
        model = 1695461688,
        coords = vector3(96.09, -1284.85, 29.44),
        locked = true,
        autoRate = 6.0,
        restricted = {
            {
                type = 'job',
                job = 'unicorn',
                gradeLevel = 99,
                jobPermission = 'JOB_DOORS',
                reqDuty = false
            }
        },
    },
})