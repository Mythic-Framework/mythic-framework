_trackingEmployees = {}

function StartAETrackingThreads()
    GlobalState.GovernmentTrackers = {}

    CreateThread(function()
        while true do
            Wait(2500)
            for k, v in pairs(emergencyAlertsData) do
                if v ~= nil and v.Source then
                    local tpCoords = Player(v.Source)?.state?.tpLocation
                    if tpCoords then
                        emergencyAlertsData[k].Coords = vector3(tpCoords.x, tpCoords.y, tpCoords.z)
                    else
                        emergencyAlertsData[k].Coords = GetEntityCoords(GetPlayerPed(k))
                    end
                end
            end

            GlobalState.GovernmentTrackers = emergencyAlertsData
        end
    end)
end