_blipCount = 1
_alertBlips = {}

RegisterNetEvent("EmergencyAlerts:Client:Clear", function(eventRoutine)
    for i = 1, _blipCount do
        local id = string.format("emrg-%s", i)
        Blips:Remove(id)
    end

    for k, v in ipairs(_alertBlips) do
        RemoveBlip(v.blip)
    end

    _blipCount = 1
    _alertBlips = {}

    Notification:Success("Blips Cleared & Reset")
end)

RegisterNetEvent("Job:Client:DutyChanged", function(state)
    if state then
        CreateThread(function()
            local mySID = LocalPlayer.state.Character:GetData('SID')
            while LocalPlayer.state.loggedIn and LocalPlayer.state.onDuty and _trackedJobs[LocalPlayer.state.onDuty] do
                if #_alertBlips > 0 then
                    for k, v in ipairs(_alertBlips) do
                        if v.time <= GlobalState["OS:Time"] then
                            SetBlipFlashes(v.blip, false)
                            Blips:Remove(v.id)
                            RemoveBlip(v.blip)
                            table.remove(_alertBlips, k)
                        end
                    end
                    Wait(30000)
                else
                    Wait(1000)
                end
            end

            for k, v in ipairs(_alertBlips) do
                SetBlipFlashes(v.blip, false)
                Blips:Remove(v.id)
                RemoveBlip(v.blip)
                table.remove(_alertBlips, k)
            end
        end)
    end
end)
