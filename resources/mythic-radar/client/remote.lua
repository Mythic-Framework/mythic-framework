REMOTE_OPEN = false

function OpenRadarRemote()
    if not REMOTE_OPEN and RADAR_ENABLED then 
        SendNUIMessage({ type = 'REMOTE_SHOW' })
        SetNuiFocus(true, true)
        SetCursorLocation(0.5, 0.8)
        REMOTE_OPEN = true
    end
end

function CloseRadarRemote()
    if REMOTE_OPEN then 
        SendNUIMessage({ type = 'REMOTE_HIDE' })
        SetNuiFocus(false, false)
        REMOTE_OPEN = false
    end
end

RegisterNUICallback('CloseRemote', function(data, cb)
    CloseRadarRemote()
    cb('OK')
end)