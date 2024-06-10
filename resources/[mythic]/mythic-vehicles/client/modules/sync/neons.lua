function UpdateVehicleNeonsState(veh, state)
    DisableVehicleNeonLights(veh, state)
end

function DoVehicleNeonUpdate(veh, newState)
    local vehEnt = Entity(veh)
    if vehEnt then
        vehEnt.state:set('neonsDisabled', newState, true)
        TriggerServerEvent('VehicleSync:Server:SyncNeons', VehToNet(veh), newState)
    end
end

-- AddStateBagChangeHandler('neonsDisabled', nil, function(bagName, key, value, _unused, replicated)
--     local vNet, count = bagName:gsub('entity:', '')
--     if count > 0 then
--         local veh = NetToVeh(tonumber(vNet))

--         if DoesEntityExist(veh) and SYNCED_VEHICLES[veh] then
--             SYNCED_VEHICLES[veh].neonsDisabled = value
--             UpdateVehicleNeonsState(veh, value)
--         end
--     end
-- end)

RegisterNetEvent('VehicleSync:Client:SyncNeons', function(veh, state)
    if NetworkDoesEntityExistWithNetworkId(veh) then
        local veh = NetToVeh(veh)
        if DoesEntityExist(veh) and SYNCED_VEHICLES[veh] then
            SYNCED_VEHICLES[veh].neonsDisabled = state
            UpdateVehicleNeonsState(veh, state)
        end
    end
end)