_sirenConfig = {
    sounds = {
        { name = "Airhorn", siren = "SIRENS_AIRHORN" }, -- 1
        { name = "Wail", siren = "VEHICLES_HORNS_SIREN_1" }, -- 2
        { name = "Yelp", siren = "VEHICLES_HORNS_SIREN_2" }, -- 3
        { name = "Priority", siren = "VEHICLES_HORNS_POLICE_WARNING" }, -- 4
        { name = "Futura", siren = "RESIDENT_VEHICLES_SIREN_WAIL_01" }, -- 5
        { name = "Hetro", siren = "RESIDENT_VEHICLES_SIREN_WAIL_02" }, -- 6
        { name = "Sweep-1", siren = "RESIDENT_VEHICLES_SIREN_WAIL_03" }, -- 7
        { name = "Sweep-2", siren = "RESIDENT_VEHICLES_SIREN_QUICK_01" }, -- 8
        { name = "Hi-Low", siren = "RESIDENT_VEHICLES_SIREN_QUICK_02" }, -- 9
        { name = "Whine Down", siren = "RESIDENT_VEHICLES_SIREN_QUICK_03" }, -- 10
        { name = "Powercall", siren = "VEHICLES_HORNS_AMBULANCE_WARNING" }, -- 11
        { name = "Fire Horn", siren = "VEHICLES_HORNS_FIRETRUCK_WARNING" }, -- 12
        { name = "Fire Yelp", siren = "RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01" }, -- 13
        { name = "Fire Wail", siren = "RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01" }, -- 14
    },
    dataTypes = {
        ['POLICE'] = { sirens = { 2, 3, 4 }, horn = 1 },
        ['FIRETRUCK'] = { sirens = { 13, 14, 11 }, horn = 12 },
        ['AMBULANCE'] = { sirens = { 2, 3, 4 }, horn = 1 }, -- , 11
        ['LIFEGUARD'] = { sirens = { 2, 3, 4 }, horn = 1 } -- , 11
    },
    overrides = {
        [`20ramambo`] = 'FIRETRUCK',
    }
}

function GetModelEmergencySounds(vehModel)
    if type(vehModel) == 'number' then
        local hasOverride = _sirenConfig.overrides[vehModel]
        if hasOverride ~= nil then
            return _sirenConfig.dataTypes[hasOverride]
        end
    end
    return _sirenConfig.dataTypes['POLICE']
end

function GetModelSirenTone(vehModel, tone)
    if type(tone) == 'number' and tone > 0 and tone <= 4 then 
        local sirenId = GetModelEmergencySounds(vehModel).sirens[tone]
        return _sirenConfig.sounds[sirenId]
    end
    return false
end

function GetModelAirhornSound(vehModel)
    local sirenId = GetModelEmergencySounds(vehModel).horn
    return _sirenConfig.sounds[sirenId]
end