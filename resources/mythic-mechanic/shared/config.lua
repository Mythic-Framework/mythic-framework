-- Vehicle Classes That Require Better Parts
_highPerformanceClasses = {
    --['A+'] = true, -- ?
    ['S'] = true,
    ['S+'] = true,
    ['X'] = true,
}

_mechanicItemsToParts = {
    ['repair_part_electronics'] = {
        part = 'Electronics',
        amount = 25.0,
        time = 5,
        regular = true,
        hperformance = true,
    },
    ['repair_part_axle'] = {
        part = 'Axle',
        amount = 50.0,
        time = 10,
        regular = true,
        hperformance = true,
    },
    ['repair_part_injectors'] = {
        part = 'FuelInjectors',
        amount = 25.0,
        time = 5,
        regular = true,
        hperformance = false,
    },
    ['repair_part_clutch'] = {
        part = 'Clutch',
        amount = 25.0,
        time = 5,
        regular = true,
        hperformance = false,
    },
    ['repair_part_brakes'] = {
        part = 'Brakes',
        amount = 25.0,
        time = 5,
        regular = true,
        hperformance = false,
    },
    ['repair_part_transmission'] = {
        part = 'Transmission',
        amount = 50.0,
        time = 10,
        regular = true,
        hperformance = false,
    },
    ['repair_part_rad'] = {
        part = 'Radiator',
        amount = 100.0,
        time = 20,
        regular = true,
        hperformance = false,
    },

    -- High Grade
    ['repair_part_injectors_hg'] = {
        part = 'FuelInjectors',
        amount = 25.0,
        time = 5,
        regular = false,
        hperformance = true,
    },
    ['repair_part_clutch_hg'] = {
        part = 'Clutch',
        amount = 25.0,
        time = 5,
        regular = false,
        hperformance = true,
    },
    ['repair_part_brakes_hg'] = {
        part = 'Brakes',
        amount = 25.0,
        time = 5,
        regular = false,
        hperformance = true,
    },
    ['repair_part_transmission_hg'] = {
        part = 'Transmission',
        amount = 50.0,
        time = 10,
        regular = false,
        hperformance = true,
    },
    ['repair_part_rad_hg'] = {
        part = 'Radiator',
        amount = 100.0,
        time = 20,
        regular = false,
        hperformance = true,
    },
}

_mechanicItemsToUpgrades = {
    ['upgrade_turbo'] = {
        part = 'Turbo',
        time = 20,
        mod = 'turbo',
        modType = 18,
        toggleMod = true,
    },
}

local partPrefixes = {
    upgrade_engine = {
        modType = 11,
        maxLevel = 4,
        mod = 'engine',
        part = 'Engine',
        installTime = 5,
        increasePerLevel = 5,
    },
    upgrade_transmission = {
        modType = 13,
        maxLevel = 4,
        mod = 'transmission',
        part = 'Transmission',
        installTime = 5,
        increasePerLevel = 5,
    },
    upgrade_brakes = {
        modType = 12,
        maxLevel = 4,
        mod = 'brakes',
        part = 'Brakes',
        installTime = 5,
        increasePerLevel = 5,
    },
    upgrade_suspension = {
        modType = 15,
        maxLevel = 4,
        mod = 'suspension',
        part = 'Suspension',
        installTime = 5,
        increasePerLevel = 5,
    },
}

for part, data in pairs(partPrefixes) do
    for i = 1, data.maxLevel, 1 do
        local item = part .. i
        _mechanicItemsToUpgrades[item] = {
            part = data.part,
            time = math.floor(data.installTime + (data.increasePerLevel * i)),
            mod = data.mod,
            modIndex = i - 1,
            modType = data.modType,
        }
    end
end