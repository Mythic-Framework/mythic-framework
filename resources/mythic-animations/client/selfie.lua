local _selfie = false

RegisterNetEvent('Animations:Client:Selfie', function(toggle)
    if toggle ~= nil then
        if toggle then
            StartSelfieMode()
        else
            StopSelfieMode()
        end
    else
        if _selfie then
            StopSelfieMode()
        else
            StartSelfieMode()
        end
    end
end)

function StartSelfieMode()
    if not _selfie and not LocalPlayer.state.doingAction then
        _selfie = true

        DestroyMobilePhone()
        Citizen.Wait(10)
        CreateMobilePhone(0)
        CellCamActivate(true, true)
        CellCamDisableThisFrame(true)
    end
end

function StopSelfieMode()
    if _selfie then
        DestroyMobilePhone()
        Citizen.Wait(10)
        CellCamDisableThisFrame(false)
        CellCamActivate(false, false)

        _selfie = false
    end
end

AddEventHandler("Keybinds:Client:KeyUp:cancel_action", function()
	if _selfie then
        StopSelfieMode()
    end
end)