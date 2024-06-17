_trackerBlips = {}

_trackedJobs = {
    police = true,
    ems = true,
}

RegisterNetEvent('Job:Client:DutyChanged', function(state)
    if state and _trackedJobs[state] then
        CreateThread(function()
            local mySID = LocalPlayer.state.Character:GetData('SID')
            Logger:Trace('Tracking', 'Start Emergency Tracking')
            while LocalPlayer.state.loggedIn and LocalPlayer.state.onDuty and _trackedJobs[LocalPlayer.state.onDuty] do
                Wait(1000)
                local trackingData = GlobalState.GovernmentTrackers
                for k, v in pairs(trackingData) do
                    if v.SID ~= mySID and v.Job and _trackedJobs[v.Job] then
                        local canTrackAsEntity = IsPlayerCloseEnoughToTrack(k)
                        local currentData = _trackerBlips[k]

                        if not currentData then
                            local newBlipId
                            if canTrackAsEntity then
                                newBlipId = AddBlipForEntity(canTrackAsEntity)
                                ShowHeadingIndicatorOnBlip(newBlipId, true)
                            else
                                newBlipId = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
                            end
                            ApplyStylingToBlip(newBlipId, v)

                            _trackerBlips[k] = {
                                blipId = newBlipId,
                                entityTracking = canTrackAsEntity,
                            }
                        elseif currentData and (currentData.entityTracking ~= canTrackAsEntity) then
                            RemoveBlip(currentData.blipId)

                            local newBlipId
                            if canTrackAsEntity then
                                newBlipId = AddBlipForEntity(canTrackAsEntity)
                                ShowHeadingIndicatorOnBlip(newBlipId, true)
                            else
                                newBlipId = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
                            end

                            ApplyStylingToBlip(newBlipId, v)
                            _trackerBlips[k] = {
                                blipId = newBlipId,
                                entityTracking = canTrackAsEntity,
                            }
                        elseif currentData then
                            if not currentData.entityTracking then 
                                SetBlipCoords(currentData.blipId, v.Coords.x, v.Coords.y, v.Coords.z)
                            end
                            --ApplyStylingToBlip(currentData.blipId, v)
                        end
                    end
                end
            end

            Logger:Trace('Tracking', 'Clear Emergency Tracking')

            for k, v in pairs(_trackerBlips) do 
                RemoveBlip(v.blipId)
                _trackerBlips[k] = nil
            end
        end)
    end
end)

RegisterNetEvent('EmergencyAlerts:Client:UpdateMembers', function()
    local trackingData = GlobalState.GovernmentTrackers

    for k, v in pairs(_trackerBlips) do 
        if not trackingData[k] then 
            RemoveBlip(v.blipId)
            _trackerBlips[k] = nil
        end
    end
end)

function ApplyStylingToBlip(blip, data)
    SetBlipCategory(blip, 7)
    -- if data.disabledTracker then
    --     SetBlipColour(blip, 47)
    --     SetBlipFlashes(blip, true)
    -- elseif data.dead then 
    --     SetBlipColour(blip, 1)
    --     SetBlipFlashes(blip, true)
    -- else

    if data.Job == 'police' then
        if data.Workplace == 'sasp' then
            SetBlipColour(blip, 55)
        elseif data.Workplace == 'lscso' then
            SetBlipColour(blip, 31)
        else
            SetBlipColour(blip, 3)
        end
    elseif data.Job == 'ems' then
        if data.Workplace == 'doctors' then
            SetBlipColour(blip, 62)
        else
            SetBlipColour(blip, 8)
        end
    end

    SetBlipScale(blip, 0.7)
    SetBlipFlashes(blip, false)
    BeginTextCommandSetBlipName("STRING")

    local nameString = string.format('%s. %s', data.First:sub(1, 1), data.Last)
    if data.Callsign then 
        nameString = string.format('(%s) %s', data.Callsign, nameString)
    end

    -- if data.dead then
    --     nameString = '[Down] '.. nameString
    -- elseif data.disabledTracker then 
    --     nameString = '[Disconnected] '.. nameString
    -- end

    AddTextComponentString(nameString)
    EndTextCommandSetBlipName(blip)
end

function IsPlayerCloseEnoughToTrack(src)
    local player = GetPlayerFromServerId(src)
    if player and player ~= -1 then 
        local playerPed = GetPlayerPed(player)
        if DoesEntityExist(playerPed) then 
            return playerPed
        end
    end
    return false 
end