RADAR_FORCE_DISABLED = false
RADAR_SETTINGS = nil

function GetDefaultSettings()
    return {
        scale = 100,
        location = 1,
        fastSpeed = 75,
        frontRadar = {
            lane = true,
            transmit = true,
        },
        rearRadar = {
            lane = true,
            transmit = true,
        }
    }
end

function GetSavedSettings()
    local settingData = json.decode(GetResourceKvpString('RADAR_SETTINGS'))
    local radarDisabled = (GetResourceKvpInt('RADAR_FORCE_DISABLED') == 1)

    RADAR_FORCE_DISABLED = radarDisabled

    if type(settingData) == "table" then
        RADAR_SETTINGS = settingData
    else
        RADAR_SETTINGS = GetDefaultSettings()
    end

    SendSettingsUpdate()
end

function SaveSettings(settings)
    RADAR_SETTINGS = settings
    SetResourceKvp('RADAR_SETTINGS', json.encode(settings))
    SendSettingsUpdate()
end

function SendSettingsUpdate()
    SendNUIMessage({
        type = 'UPDATE_SETTINGS',
        data = RADAR_SETTINGS
    })
end

RegisterNUICallback('UpdateSettings', function(data, cb)
    SaveSettings(data)
    cb('OK')
end)

function ToggleRadarIsDisabled()
    if RADAR_ENABLED_VEHICLE then
        RADAR_FORCE_DISABLED = not RADAR_FORCE_DISABLED
        SetResourceKvpInt('RADAR_FORCE_DISABLED', RADAR_FORCE_DISABLED and 1 or 0)
    
        if RADAR_ENABLED and RADAR_FORCE_DISABLED then
            DisableRadar()
        elseif not RADAR_FORCE_DISABLED then
            EnableRadar()
        end
    end
end