local _policeCustomSettings = {
    GOVERNMENT_PAINT = true,
    BLOCK_LIGHTING = true,
    BLOCK_TIRESMOKE = true,
}

_customsLocations = {
    {
        type = 0,
        name = 'Benny\'s Motorworks',
        restrictClass = false,
        restrictJobs = {
            police = false, -- Don't allow Police
        },
        blip = vector3(-31.88, -1052.1, 28.39),
        zone = {
            type = 'box',
            center = vector3(-31.88, -1052.1, 28.39),
            length = 27.4,
            width = 19.0,
            heading = 340,
            minZ = 27.2,
            maxZ = 32.0
        }
    },
    {
        type = 0,
        name = 'Beekers Garage',
        restrictClass = false,
        restrictJobs = {
            police = false,
        },
        blip = vector3(107.45, 6624.39, 31.79),
        zone = {
            type = 'box',
            center = vector3(107.45, 6624.39, 31.79),
            length = 6.6,
            width = 10.0,
            heading = 45,
            minZ = 30.79,
            maxZ = 34.79
        }
    },
    {
        type = 1, -- Repairs Only
        name = 'Garage',
        restrictClass = false,
        restrictJobs = {
            police = false, -- Don't allow Police
        },
        blip = false,
        zone = {
            type = 'box',
            center = vector3(732.48, -1077.76, 22.17),
            length = 13.8,
            width = 6.6,
            heading = 0,
            minZ = 21.17,
            maxZ = 25.17
        }
    },
    {
        type = 1, -- Repairs Only
        name = 'Garage',
        restrictClass = false,
        restrictJobs = {
            police = false, -- Don't allow Police
        },
        blip = false,
        zone = {
            type = 'box',
            center = vector3(-1358.27, -755.96, 22.3),
            length = 5.0,
            width = 5.0,
            heading = 35,
            minZ = 21.3,
            maxZ = 25.3
        }
    },
    {
        type = 1, -- Repairs Only
        name = 'Garage',
        restrictClass = false,
        restrictJobs = false,
        blip = false,
        zone = {
            type = 'box',
            center = vector3(-442.3, -2179.46, 9.73),
            length = 8.0,
            width = 9.0,
            heading = 0,
            minZ = 8.73,
            maxZ = 12.73
        }
    },
    { -- Pegasus Hangar
        type = 0,
        name = 'Aircraft Customs',
        restrictClass = { 15, 16 },
        restrictJobs = false,
        aircraft = true,
        blip = vector3(-1649.99, -3139.01, 13.99),
        zone = {
            type = 'box',
            center = vector3(-1649.99, -3139.01, 13.99),
            length = 50.0,
            width = 50.0,
            heading = 330,
            minZ = 12.39,
            maxZ = 22.99
        }
    },
    { -- Sandy Hangar
        type = 1, -- Repairs Only
        name = 'Aircraft Garage',
        restrictClass = { 15, 16 },
        restrictJobs = false,
        blip = false,
        zone = {
            type = 'box',
            center = vector3(1698.29, 3277.78, 40.92),
            length = 18.6,
            width = 13.8,
            heading = 35,
            minZ = 39.92,
            maxZ = 43.92
        }
    },
    -- MISSION ROW PD
    {
        type = 0,
        name = 'MRPD Garage',
        restrictClass = { 18 },
        restrictJobs = {
            police = true, -- Only allow Police
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(451.35, -975.69, 25.7),
            length = 16.0,
            width = 5.0,
            heading = 270,
            minZ = 24.7,
            maxZ = 28.7
        },
        settings = _policeCustomSettings,
    },
    {
        type = 0,
        name = 'Sandy Sheriff Garage',
        restrictClass = { 18 },
        restrictJobs = {
            police = true, -- Only allow Police
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(1813.6, 3688.3, 33.97),
            length = 5.2,
            width = 10.4,
            heading = 30,
            --debugPoly=true,
            minZ = 32.77,
            maxZ = 36.57
        },
        settings = _policeCustomSettings,
    },
    {
        type = 1,
        name = 'PBPD Garage',
        restrictClass = { 18 },
        restrictJobs = {
            police = true, -- Only allow Police
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(-444.93, 5983.55, 31.34),
            length = 3.6,
            width = 9.4,
            heading = 315,
            minZ = 30.34,
            maxZ = 34.34
        },
        settings = _policeCustomSettings,
    },
    {
        type = 0,
        name = 'Davis PD Garage',
        restrictClass = { 18 },
        restrictJobs = {
            police = true, -- Only allow Police
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(377.25, -1626.96, 29.29),
            length = 6.4,
            width = 11.4,
            heading = 320,
            minZ = 28.29,
            maxZ = 32.29
        },
        settings = _policeCustomSettings,
    },
    {
        type = 0,
        name = 'La Mesa PD Garage',
        restrictClass = { 18 },
        restrictJobs = {
            police = true, -- Only allow Police
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(866.43, -1350.23, 26.06),
            length = 12.0,
            width = 19.6,
            heading = 0,
            --debugPoly=true,
            minZ = 25.06,
            maxZ = 29.06
        },
        settings = _policeCustomSettings,
    },
    -- MT ZONAH MED
    {
        type = 0,
        name = 'Mt Zonah Medical Garage',
        restrictClass = { 18 },
        restrictJobs = {
            ems = true, -- Only allow EMS
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(-478.32, -393.19, 24.23),
            length = 11.6,
            width = 11.6,
            heading = 20,
            minZ = 23.03,
            maxZ = 27.03
        }
    },
    -- Redline
    {
        type = 0,
        name = 'Redline Garage',
        restrictClass = false,
        restrictJobs = {
            redline = true,
        },
        canInstallPerformance = false,
        costMultiplier = 0.75,
        blip = false,
        zone = {
            type = 'box',
            center = vector3(-560.65, -914.52, 23.89),
            length = 5.4,
            width = 9.4,
            heading = 0,
            minZ = 22.89,
            maxZ = 26.89
        },
        --fitment = 'redline',
    },
    {
        type = 0,
        name = 'Tuna Garage',
        restrictClass = false,
        restrictJobs = {
            tuna = true,
        },
        canInstallPerformance = false,
        costMultiplier = 0.5,
        blip = false,
        zone = {
            type = 'box',
            center = vector3(124.7, -3047.2, 7.04),
            length = 5.4,
            width = 8.4,
            heading = 0,
            --debugPoly=true,
            minZ = 5.64,
            maxZ = 9.44
        },
        fitment = 'tuna',
    },
    {
        type = 0,
        name = 'Mt Zonah Helipad',
        restrictClass = { 15, 16 },
        restrictJobs = {
            ems = true,
            police = true,
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(-456.25, -291.28, 78.17),
            length = 10.0,
            width = 10.0,
            heading = 25,
            --debugPoly=true,
            minZ = 77.17,
            maxZ = 81.17
        }
    },
    {
        type = 0,
        name = 'MRPD Helipad',
        restrictClass = { 15, 16 },
        restrictJobs = {
            ems = true,
            police = true,
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(449.15, -981.34, 43.69),
            length = 10.0,
            width = 10.0,
            heading = 0,
            --debugPoly=true,
            minZ = 42.69,
            maxZ = 46.69
        }
    },
    {
        type = 0,
        name = 'SSPD Helipad',
        restrictClass = { 15, 16 },
        restrictJobs = {
            ems = true,
            police = true,
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(1853.39, 3706.35, 33.97),
            length = 10.8,
            width = 12.0,
            heading = 30,
            --debugPoly=true,
            minZ = 32.97,
            maxZ = 36.97
        }
    },
    {
        type = 0,
        name = 'Paleto PD Helipad',
        restrictClass = { 15, 16 },
        restrictJobs = {
            ems = true,
            police = true,
        },
        blip = false,
        costMultiplier = 0.5,
        zone = {
            type = 'box',
            center = vector3(-475.1, 5988.99, 31.34),
            length = 20.8,
            width = 24.6,
			heading = 315,
			minZ = 30.34,
			maxZ = 34.34,
        }
    },
    -- Super Performance
    {
        type = 0,
        name = 'Auto Exotics Garage',
        restrictClass = false,
        restrictJobs = {
            autoexotics = true,
        },
        canInstallPerformance = false,
        costMultiplier = 0.75,
        blip = false,
        zone = {
            type = 'box',
            center = vector3(548.48, -198.62, 54.49),
            length = 6.4,
            width = 4.4,
            heading = 0,
            --debugPoly=true,
            minZ = 53.49,
            maxZ = 56.89
        },
        --fitment = 'autoexotics',
    },
    {
        type = 0,
        name = 'Otto\'s Autos Garage',
        restrictClass = false,
        restrictJobs = {
            ottos = true,
        },
        canInstallPerformance = false,
        costMultiplier = 0.75,
        blip = false,
        zone = {
            type = 'box',
            center = vector3(841.27, -814.03, 26.33),
            length = 8.8,
            width = 6.2,
            heading = 0,
            --debugPoly=true,
            minZ = 25.33,
            maxZ = 29.33
        },
        --fitment = 'ottos',
    },
    {
        type = 0,
        name = 'Dreamworks Garage',
        restrictClass = false,
        restrictJobs = {
            dreamworks = true,
        },
        canInstallPerformance = false,
        costMultiplier = 0.75,
        blip = false,
        zone = {
            type = 'box',
            center = vector3(-757.92, -1530.8, 5.06),
            length = 5.8,
            width = 4.8,
            heading = 23,
            --debugPoly=true,
            minZ = 4.06,
            maxZ = 7.06
        }
    },
}