function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.25, 0.25)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)
    SetTextOutline(true)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

function PedFaceCoord(pPed, pCoords)
    TaskTurnPedToFaceCoord(pPed, pCoords.x, pCoords.y, pCoords.z)

    Wait(100)

    while GetScriptTaskStatus(pPed, 0x574bb8f5) == 1 do
        Wait(0)
    end
end

function CheckPDInZone(zone, radius)
    for k, v in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(v)
        local src = GetPlayerServerId(v)
        if #(GetEntityCoords(ped) - zone) <= radius and Player(src).state.onDuty == "police" then
            return true
        end
    end
    return false
end