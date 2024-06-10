-- Emergency Lights Stuff

function SetVehicleEmergencySirens(veh, lights, sirens)
    if lights then
        SetVehicleHasMutedSirens(veh, true)
        SetVehicleSiren(veh, true)

        SetVehicleSirenSounds(veh, sirens)
    else
        SetVehicleSiren(veh, false)
        RemoveVehicleSirenSounds(veh)
    end
end

function DoVehicleEmergencyUpdate(veh, newLightState, newSirenState)
    local vehEnt = Entity(veh)
    if vehEnt then
        vehEnt.state:set('emLights', newLightState, true)
        vehEnt.state:set('emSirens', newSirenState, true)
        TriggerServerEvent('VehicleSync:Server:Emergency', VehToNet(veh), newLightState, newSirenState)
    end
end

-- AddStateBagChangeHandler('emLights', nil, function(bagName, key, value, _unused, replicated)
--     local vNet, count = bagName:gsub('entity:', '')
--     if count > 0 then
--         local veh = NetToVeh(tonumber(vNet))

--         if DoesEntityExist(veh) and SYNCED_EMERGENCY_VEHICLES[veh] then
--             SYNCED_EMERGENCY_VEHICLES[veh].lights = value
--             SetVehicleEmergencySirens(veh, value, SYNCED_EMERGENCY_VEHICLES[veh].siren)
--         end
--     end
-- end)

-- AddStateBagChangeHandler('emSirens', nil, function(bagName, key, value, _unused, replicated)
--     local vNet, count = bagName:gsub('entity:', '')
--     if count > 0 then
--         local veh = NetToVeh(tonumber(vNet))

--         if DoesEntityExist(veh) and SYNCED_EMERGENCY_VEHICLES[veh] then
--             SYNCED_EMERGENCY_VEHICLES[veh].siren = value
--             SetVehicleEmergencySirens(veh, SYNCED_EMERGENCY_VEHICLES[veh].lights, value)
--         end
--     end
-- end)

RegisterNetEvent('VehicleSync:Client:Emergency', function(veh, lights, siren)
    if NetworkDoesEntityExistWithNetworkId(veh) then
        local veh = NetToVeh(veh)
        if DoesEntityExist(veh) and SYNCED_EMERGENCY_VEHICLES[veh] then
            SYNCED_EMERGENCY_VEHICLES[veh].lights = lights
            SYNCED_EMERGENCY_VEHICLES[veh].siren = siren
            SetVehicleEmergencySirens(veh, lights, siren)
        end
    end
end)

function DoVehicleEmergencyAirhorn(veh, state)
    TriggerServerEvent('VehicleSync:Server:EmergencyAirhorn', VehToNet(veh), state)
end

RegisterNetEvent('VehicleSync:Client:EmergencyAirhorn', function(veh, state)
    if NetworkDoesEntityExistWithNetworkId(veh) then
        local veh = NetToVeh(veh)
        if DoesEntityExist(veh) and SYNCED_EMERGENCY_VEHICLES[veh] then
            SYNCED_EMERGENCY_VEHICLES[veh].airhorn = state
            SetVehicleAirhornSounds(veh, state)
        end
    end
end)


-- Emergency Siren Sound Stuff

VEHICLE_SIREN_SOUNDS = {}
VEHICLE_HORN_SOUNDS = {}

function RemoveVehicleSirenSounds(veh)
    if VEHICLE_SIREN_SOUNDS[veh] then
        StopSound(VEHICLE_SIREN_SOUNDS[veh].soundId)
        ReleaseSoundId(VEHICLE_SIREN_SOUNDS[veh].soundId)
        VEHICLE_SIREN_SOUNDS[veh] = nil
    end
end

function SetVehicleSirenSounds(veh, state)
    RemoveVehicleSirenSounds(veh)
    if state and state > 0 then
        local soundToPlay = GetModelSirenTone(GetEntityModel(veh), state)
        if not soundToPlay then return end
        local newSoundId = GetSoundId()
        VEHICLE_SIREN_SOUNDS[veh] = { soundId = newSoundId, siren = state, sirenName = soundToPlay.name }
        PlaySoundFromEntity(newSoundId, soundToPlay.siren, veh, 0, 0, 0)
    end
end

function RemoveVehicleAirhornSounds(veh)
    if VEHICLE_HORN_SOUNDS[veh] then
        StopSound(VEHICLE_HORN_SOUNDS[veh])
        ReleaseSoundId(VEHICLE_HORN_SOUNDS[veh])
        VEHICLE_HORN_SOUNDS[veh] = nil
    end
end

function SetVehicleAirhornSounds(veh, state)
    RemoveVehicleAirhornSounds(veh)
    if state then
        local soundToPlay = GetModelAirhornSound(GetEntityModel(veh))
        if not soundToPlay then return end
        local newSoundId = GetSoundId()
        VEHICLE_HORN_SOUNDS[veh] = newSoundId
        PlaySoundFromEntity(newSoundId, soundToPlay.siren, veh, 0, 0, 0)
    end
end