function UpdateVehicleIndicatorState(veh, state)
    if not state then
        SetVehicleIndicatorLights(veh, 0, false)
        SetVehicleIndicatorLights(veh, 1, false)
    end

    if state == 0 then -- Hazards
        SetVehicleIndicatorLights(veh, 0, true)
        SetVehicleIndicatorLights(veh, 1, true)
    elseif state == 1 then -- Right
        SetVehicleIndicatorLights(veh, 0, true)
        SetVehicleIndicatorLights(veh, 1, false)
    elseif state == 2 then -- Left
        SetVehicleIndicatorLights(veh, 0, false)
        SetVehicleIndicatorLights(veh, 1, true)
    end
end

function DoVehicleIndicatorUpdate(veh, newState)
    local vehEnt = Entity(veh)
    if vehEnt then
        vehEnt.state:set('indicators', newState, true)
        TriggerServerEvent('VehicleSync:Server:SyncIndicators', VehToNet(veh), newState)
    end
end

-- AddStateBagChangeHandler('indicators', nil, function(bagName, key, value, _unused, replicated)
--     local vNet, count = bagName:gsub('entity:', '')
--     if count > 0 then
--         local veh = NetToVeh(tonumber(vNet))

--         if DoesEntityExist(veh) and SYNCED_VEHICLES[veh] then
--             SYNCED_VEHICLES[veh].indicators = value
--             UpdateVehicleIndicatorState(veh, value)
--         end
--     end
-- end)

RegisterNetEvent('VehicleSync:Client:SyncIndicators', function(veh, state)
    if NetworkDoesEntityExistWithNetworkId(veh) then
        local veh = NetToVeh(veh)
        if DoesEntityExist(veh) and SYNCED_VEHICLES[veh] then
            SYNCED_VEHICLES[veh].indicators = state
            UpdateVehicleIndicatorState(veh, state)
        end
    end
end)