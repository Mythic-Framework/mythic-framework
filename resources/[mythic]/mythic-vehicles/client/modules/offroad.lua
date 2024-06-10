OFFROAD_VEHICLE = false

AddEventHandler('Vehicles:Client:StartUp', function()
    -- AddTaskToVehicleThread('offroad_handling', 1, true, function(veh, class, running, inside, onExit)
    --     if onExit then
    --         OFFROAD_VEHICLE = false
    --     else
    --         local surface = GetVehicleWheelSurfaceMaterial(veh, 0)
    --         local surface2 = GetVehicleWheelSurfaceMaterial(veh, 1)
    --         if _loseTractionMaterials[surface] and _loseTractionMaterials[surface2] then
    --             if not OFFROAD_VEHICLE then
    --                 OFFROAD_VEHICLE = true
    --                 SetVehicleOffroadState(veh, true)
    --             end
    --         elseif OFFROAD_VEHICLE then
    --             OFFROAD_VEHICLE = false
    --             SetVehicleOffroadState(veh, false)
    --         end
    --     end
    -- end, true)
end)

function SetVehicleOffroadState(veh, state)
    if state then
        local class = GetVehicleClass(veh)
        local fTractionLossMultMult = _loseTractionBadlyClasses[class] and 1.3 or 1.1
        local fTractionCurveMinMult = _loseTractionBadlyClasses[class] and 0.8 or 0.9
        local fLowSpeedTractionLossMultMult = _loseTractionBadlyClasses[class] and 1.2 or 1.1
        
        SetVehicleHandlingOverrideMultiplier(veh, 'fTractionLossMult', 'Float', fTractionLossMultMult)
        SetVehicleHandlingOverrideMultiplier(veh, 'fTractionCurveMin', 'Float', fTractionCurveMinMult)
        SetVehicleHandlingOverrideMultiplier(veh, 'fLowSpeedTractionLossMult', 'Float', fLowSpeedTractionLossMultMult)

        Logger:Trace('Vehicles', 'Offroad Handling: On')
    else
        ResetVehicleHandlingOverride(veh, 'fTractionLossMult')
        ResetVehicleHandlingOverride(veh, 'fTractionCurveMin')
        ResetVehicleHandlingOverride(veh, 'fLowSpeedTractionLossMult')
        Logger:Trace('Vehicles', 'Offroad Handling: Off')
    end
end