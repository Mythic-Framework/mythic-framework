_bowlingZone = {
    center = vector3(743.11, -774.61, 26.45),
    length = 17.2,
    width = 30.8,
    options = {
        heading = 0,
        --debugPoly=true,
        minZ = 25.45,
        maxZ = 29.25
    }
}

_bowlingAlleys = {
    [1] = {
        pins = vector3(728.477, -781.841, 25.446),
        startZone = {
            center = vector3(747.32, -781.86, 26.45),
            length = 1.8,
            width = 1.2,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.45,
                maxZ = 28.25
            }
        },
        endZone = vector3(729.365, -781.756, 26.446),
        interactZone = {
            center = vector3(747.8, -780.81, 26.44),
            length = 0.4,
            width = 2.2,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.44,
                maxZ = 26.44
            }
        },
    },
    [2] = {
        pins = vector3(728.477, -775.565, 25.446),
        startZone = {
            center = vector3(747.24, -775.56, 26.45),
            length = 1.8,
            width = 1.2,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.45,
                maxZ = 28.25
            }
        },
        endZone = vector3(729.412, -775.555, 26.446),
        interactZone = {
            center = vector3(747.95, -776.59, 26.45),
            length = 0.6,
            width = 2.0,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.45,
                maxZ = 26.45
            }
        },
    },
    [3] = {
        pins = vector3(728.477, -771.375, 25.446),
        startZone = {
            center = vector3(747.2, -771.37, 26.45),
            length = 1.8,
            width = 1.2,
            options = {
                heading = 0,
                --debugPoly=true,
                minZ = 25.45,
                maxZ = 28.25
            }
        },
        endZone = vector3(729.464, -771.541, 26.446),
        interactZone = {
            center = vector3(747.91, -772.43, 26.48),
            length = 2.0,
            width = 0.6,
            options = {
                heading = 270,
                --debugPoly=true
                minZ = 25.45,
                maxZ = 26.45
            }
        },
    },
}