_vehicleSyncStuff = {
    Sync = {
        Indicators = {
            Get = function(self)
                if SYNC_DRIVING_VEHICLE then
                    local currentState = SYNCED_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState then
                        return currentState.indicators
                    end
                end
                return false
            end,
            Set = function(self, type)
                if SYNC_DRIVING_VEHICLE and CheckActionRateLimit('indicators', 30) then
                    local currentState = SYNCED_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState then
                        if not currentState.indicators or currentState.indicators ~= type then
                            currentState.indicators = type
                            DoVehicleIndicatorUpdate(SYNC_DRIVING_VEHICLE, currentState.indicators)
                        elseif currentState.indicators == type then
                            currentState.indicators = false
                            DoVehicleIndicatorUpdate(SYNC_DRIVING_VEHICLE, currentState.indicators)
                        end
                        return currentState.indicators
                    end
                end
                return false
            end
        },
        Neons = {
            Has = function(self)
                if SYNC_DRIVING_VEHICLE then
                    for i = 0, 3 do
                        if IsVehicleNeonLightEnabled(SYNC_DRIVING_VEHICLE, i) then
                            return true
                        end
                    end
                end
                return false
            end,
            IsDisabled = function(self)
                if SYNC_DRIVING_VEHICLE and Vehicles.Sync.Neons:Has() then
                    local currentState = SYNCED_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState then
                        return currentState.neonsDisabled
                    end
                end
                return false
            end,
            Toggle = function(self, toggle)
                if SYNC_DRIVING_VEHICLE and Vehicles.Sync.Neons:Has() and CheckActionRateLimit('neons', 20) then
                    local currentState = SYNCED_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState then
                        if not toggle then
                            toggle = not currentState.neonsDisabled
                        end

                        if toggle ~= currentState.neonsDisabled then
                            DoVehicleNeonUpdate(SYNC_DRIVING_VEHICLE, toggle)
                            return true
                        end
                    end
                end
                return false
            end,
        },
        EmergencyLights = {
            Toggle = function(self)
                if SYNC_DRIVING_VEHICLE and SYNC_DRIVING_EMERGENCY_VEHICLE and SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE] and CheckActionRateLimit('emLights', 60) then
                    local currentState = SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState then
                        currentState.lights = not currentState.lights
                        currentState.siren = false
                        DoVehicleEmergencyUpdate(SYNC_DRIVING_VEHICLE, currentState.lights, currentState.siren)
                        return currentState.lights
                    end
                end
                return false
            end,
            Get = function(self)
                if SYNC_DRIVING_VEHICLE and SYNC_DRIVING_EMERGENCY_VEHICLE and SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE] then
                    local currentState = SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState then
                        return currentState.lights
                    end
                end
                return false
            end,
        },
        EmergencySiren = {
            Cycle = function(self)
                if SYNC_DRIVING_VEHICLE and SYNC_DRIVING_EMERGENCY_VEHICLE and SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE] and CheckActionRateLimit('emSirenCycle', 60) then
                    local currentState = SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState and currentState.siren then
                        currentState.siren = currentState.siren + 1
                        if currentState.siren > 3 then
                            currentState.siren = 1
                        end
                        LAST_SIREN_TYPE = currentState.siren
                        DoVehicleEmergencyUpdate(SYNC_DRIVING_VEHICLE, currentState.lights, currentState.siren)
                        return currentState.siren
                    end
                end
                return false
            end,
            Toggle = function(self)
                if SYNC_DRIVING_VEHICLE and SYNC_DRIVING_EMERGENCY_VEHICLE and SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE] and CheckActionRateLimit('emSirenToggle', 60) then
                    local currentState = SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState and currentState.lights then
                        if currentState.siren then
                            currentState.siren = false
                        else
                            currentState.siren = LAST_SIREN_TYPE
                        end
                        DoVehicleEmergencyUpdate(SYNC_DRIVING_VEHICLE, currentState.lights, currentState.siren)
                        return currentState.siren
                    end
                end
                return false
            end,
            Get = function(self)
                if SYNC_DRIVING_VEHICLE and SYNC_DRIVING_EMERGENCY_VEHICLE and SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE] then
                    local currentState = SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState and currentState.lights then
                        return currentState.siren
                    end
                end
                return false
            end,
        },
        EmergencyAirhorn = {
            Set = function(self, state)
                if SYNC_DRIVING_VEHICLE and SYNC_DRIVING_EMERGENCY_VEHICLE and SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE] then
                    local passRLimit = CheckActionRateLimit('emAirhorn', 50)
                    local currentState = SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState then
                        if not passRLimit then
                            if currentState.airhorn then
                                currentState.airhorn = false
                                DoVehicleEmergencyAirhorn(SYNC_DRIVING_VEHICLE, currentState.airhorn)
                            end
                        else
                            currentState.airhorn = state
                            DoVehicleEmergencyAirhorn(SYNC_DRIVING_VEHICLE, currentState.airhorn)
                        end
                        return currentState.airhorn
                    end
                end
                return false
            end,
            Get = function(self)
                if SYNC_DRIVING_VEHICLE and SYNC_DRIVING_EMERGENCY_VEHICLE and SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE] then
                    local currentState = SYNCED_EMERGENCY_VEHICLES[SYNC_DRIVING_VEHICLE]
                    if currentState then
                        return currentState.airhorn
                    end
                end
                return false
            end,
        },
        Doors = {
            Open = function(self, vehicle, doorNum, loose, instant)
                if DoesEntityExist(vehicle) then
                    if NetworkGetEntityIsNetworked(vehicle) and not NetworkHasControlOfEntity(vehicle) then
                        TriggerServerEvent('VehicleSync:Server:OpenDoor', VehToNet(vehicle), doorNum, loose, instant)
                    end
                    HandleDoorOpenSync(vehicle, doorNum, loose, instant)
                end
            end,
            Shut = function(self, vehicle, doorNum, instant)
                if DoesEntityExist(vehicle) then
                    if NetworkGetEntityIsNetworked(vehicle) and not NetworkHasControlOfEntity(vehicle) then
                        TriggerServerEvent('VehicleSync:Server:ShutDoor', VehToNet(vehicle), doorNum, instant)
                    end
                    HandleDoorShutSync(vehicle, doorNum, instant)
                end
            end,
        }
    }
}

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'Vehicles' then
        exports['mythic-base']:ExtendComponent(component, _vehicleSyncStuff)
    end
end)