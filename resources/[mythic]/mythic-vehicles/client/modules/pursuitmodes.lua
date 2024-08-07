_inPursuitVehicle = false
_inPursuitVehicleSettings = nil
_inPursuitVehicleMode = 1

AddEventHandler("Characters:Client:Spawn", function()
    Wait(500)
    Hud:RegisterStatus("pursuit-modes", 0, 100, "gauge", "#892020", true, false, {
        hideZero = true,
    })
end)

local _timeout = false

AddEventHandler('Vehicles:Client:StartUp', function()
    Keybinds:Add('vehicle_pursuit_modes', '', 'keyboard', 'Vehicle - Pursuit Modes', function()
        if _inPursuitVehicle and not _timeout then
            if (_inPursuitVehicleMode + 1) <= #_inPursuitVehicleSettings then
                _inPursuitVehicleMode += 1
            else
                _inPursuitVehicleMode = 1
            end

            UISounds.Play:FrontEnd(-1, "Business_Restart", "DLC_Biker_Computer_Sounds")
            Notification:Standard("Switched to Pursuit Mode " .. _inPursuitVehicleSettings[_inPursuitVehicleMode].name or _inPursuitVehicleMode)

            ApplyPursuitStuffToVehicle(_inPursuitVehicleMode)

            Entity(_inPursuitVehicle).state:set('PursuitMode', _inPursuitVehicleMode, true)

            _timeout = true
            SetTimeout(1000, function()
                _timeout = false
            end)
        end
    end)

    AddTaskBeforeVehicleThread('pursuit-modes', function(veh, class)
        local pVeh = _pursuitModeConfig[GetEntityModel(veh)]
        if pVeh then
            _inPursuitVehicle = veh
            _inPursuitVehicleMode = 1
            _inPursuitVehicleSettings = pVeh

            local lastPursuitMode = Entity(veh)?.state?.PursuitMode
            if lastPursuitMode ~= nil and lastPursuitMode <= #_inPursuitVehicleSettings then
                _inPursuitVehicleMode = lastPursuitMode

                UISounds.Play:FrontEnd(-1, "Business_Restart", "DLC_Biker_Computer_Sounds")
                Notification:Standard("Switched to Pursuit Mode " .. _inPursuitVehicleSettings[_inPursuitVehicleMode].name or _inPursuitVehicleMode)

                ApplyPursuitStuffToVehicle(lastPursuitMode)
            end
        end
    end)

    AddTaskToVehicleThread('pursuit-modes', 100, true, function(veh, class, running, inside, onExit)
        if _inPursuitVehicle then
            if onExit then
                _inPursuitVehicle = false
                _inPursuitVehicleMode = 1
                _inPursuitVehicleSettings = nil

                RemovePursuitStuffFromVehicle(veh)
                SetVehicleLights(veh, 0)
            else

            end
        end
    end, true)
end)

function ApplyPursuitStuffToVehicle(mode)
    if mode <= #_inPursuitVehicleSettings then

        local modeSettings = _inPursuitVehicleSettings[mode]

        ResetVehicleHandlingOverrides(_inPursuitVehicle)

        if modeSettings?.handling then
            for k, v in ipairs(modeSettings.handling) do
                if v.multiplier then
                    SetVehicleHandlingOverrideMultiplier(_inPursuitVehicle, v.field, v.fieldType, v.value)
                else
                    SetVehicleHandlingOverride(_inPursuitVehicle, v.field, v.fieldType, v.value)
                end
            end
        end

        SetVehicleModKit(_inPursuitVehicle, 0)
        for k, v in pairs(_performanceUpgrades) do
            if k == "turbo" then
                ToggleVehicleMod(_inPursuitVehicle, v, modeSettings?.performance?.turbo or false)
            else
                SetVehicleMod(_inPursuitVehicle, v, modeSettings?.performance?[k] or -1, false)
            end
        end

        if mode > 1 then
            SetVehicleLights(_inPursuitVehicle, 2)
            ToggleVehicleMod(_inPursuitVehicle, 22, true)

            if mode >= 4 then
                SetVehicleXenonLightsColor(_inPursuitVehicle, 0)
            else
                SetVehicleXenonLightsColor(_inPursuitVehicle, -1)
            end
        else
            SetVehicleLights(_inPursuitVehicle, 0)
            ToggleVehicleMod(_inPursuitVehicle, 22, false)
        end

        if mode > 1 then
            local percentage = (100 / (#_inPursuitVehicleSettings - 1)) * (mode - 1)

            TriggerEvent("Status:Client:Update", "pursuit-modes", percentage)
        else
            TriggerEvent("Status:Client:Update", "pursuit-modes", 0)
        end
    end
end

function RemovePursuitStuffFromVehicle(veh)
    SetVehicleModKit(veh, 0)
    for k, v in pairs(_performanceUpgrades) do
        if k == "turbo" then
            ToggleVehicleMod(veh, v, false)
        else
            SetVehicleMod(veh, v, -1, false)
        end
    end

    SetVehicleLights(veh, 0)
    ToggleVehicleMod(veh, 22, false)

    TriggerEvent("Status:Client:Update", "pursuit-modes", 0)
end