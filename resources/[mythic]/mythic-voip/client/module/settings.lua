function GetPlayerVOIPSettings()
    local savedSettings = json.decode(GetResourceKvpString('VOIP_SETTINGS'))
    local retSettings = {}
    for setting, settingDefault in pairs(VOIP_CONFIG.DefaultSettings) do
        if savedSettings and savedSettings[setting] then
            retSettings[setting] = savedSettings[setting]
        else
            retSettings[setting] = VOIP_CONFIG.DefaultSettings[setting]
        end
    end
    return retSettings
end

function SetPlayerVOIPSetting(setting, newValue)
    if VOIP_CONFIG.DefaultSettings[setting] ~= nil then
        local currentSettings = GetPlayerVOIPSettings()
        currentSettings[setting] = newValue
        SetResourceKvp('VOIP_SETTINGS', json.encode(currentSettings))
        return currentSettings
    end
end