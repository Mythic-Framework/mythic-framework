_vehicleRepair = {
    Repair = {
        NeedsKit = function(self, veh, type)
            if DoesEntityExist(veh) and not IsEntityDead(veh) then
                local driverPed = GetPedInVehicleSeat(veh, -1)
                if driverPed == 0 or driverPed == GLOBAL_PED then
                    local vehEnt = Entity(veh)

                    local isHelicopter = GetVehicleClass(veh) == 15
                    local bodyHealth = GetVehicleBodyHealth(veh)
                    local engineHealth = GetVehicleEngineHealth(veh)

                    if vehEnt and vehEnt.state then
                        local currentRepairUses = vehEnt.state.RepairKits
                        local canChangeHealth = (not currentRepairUses or currentRepairUses < 5)
                        local hasBurstTire = false

                        if type then
                            for i = 0, 12 do
                                if IsVehicleTyreBurst(veh, i, false) then
                                    hasBurstTire = true
                                end
                            end
                        end

                        if bodyHealth < 500.0 or (engineHealth < 500.0) or (isHelicopter and engineHealth < 900.0) or hasBurstTire then
                            return true
                        end
                    end
                end
            end
            return false
        end,
        -- For Repair Kits to Call - There are two types - true repairs tires and false doesn't
        Kit = function(self, veh, type)
            if DoesEntityExist(veh) and not IsEntityDead(veh) then
                local driverPed = GetPedInVehicleSeat(veh, -1)
                if driverPed == 0 or driverPed == GLOBAL_PED then
                    local timeout = false
                    Citizen.SetTimeout(2000, function() 
                        timeout = true
                    end)

                    while not NetworkHasControlOfEntity(veh) and not timeout do
                        NetworkRequestControlOfEntity(veh)
                        Citizen.Wait(100)
                    end

                    local isHelicopter = GetVehicleClass(veh) == 15

                    if NetworkHasControlOfEntity(veh) then
                        local vehEnt = Entity(veh)
                        local bodyHealth = GetVehicleBodyHealth(veh)
                        local engineHealth = GetVehicleEngineHealth(veh)

                        if vehEnt and vehEnt.state then
                            local currentRepairUses = vehEnt.state.RepairKits
                            local canChangeHealth = (not currentRepairUses or currentRepairUses < 4)
                            local hasBurstTire = false

                            if type then
                                for i = 0, 12 do
                                    if IsVehicleTyreBurst(veh, i, false) then
                                        hasBurstTire = true
                                    end
                                end
                            end

                            local success = false
                            local errorMessage = 'Nothing to Repair'

                            if bodyHealth < 500.0 or (engineHealth < 500.0) or (isHelicopter and engineHealth < 900.0) or hasBurstTire then
                                local changedHealth = false
                                if canChangeHealth then
                                    if bodyHealth < 500.0 then
                                        changedHealth = true
                                        SetVehicleBodyHealth(veh, 500.0)
                                    end

                                    if engineHealth < 500.0 or (isHelicopter and engineHealth < 900.0) then
                                        changedHealth = true
                                        SetVehicleEngineHealth(veh, isHelicopter and 950.0 or 500.0)
                                        SetVehicleUndriveable(veh, false)
                                    end

                                    SetVehiclePetrolTankHealth(veh, 1000.0)
                                else
                                    errorMessage = 'This Vehicle Has Been Repaired Too Many Times'
                                end

                                if type and hasBurstTire then
                                    for i = 0, 12 do
                                        SetVehicleTyreFixed(veh, i)
                                    end

                                    success = true
                                end

                                if changedHealth then
                                    local newDamage = {
                                        Body = GetVehicleBodyHealth(veh),
                                        Engine = GetVehicleEngineHealth(veh)
                                    }
                                    vehEnt.state:set('Damage', newDamage, true)
                                    TriggerEvent('Vehicles:Client:ForceUpdateVehicleDamageState', veh, newDamage)

                                    if not currentRepairUses then
                                        currentRepairUses = 0
                                    end
                                    currentRepairUses = currentRepairUses + 1
                                    vehEnt.state:set('RepairKits', currentRepairUses, true)
                                    success = true
                                end
                            end
                            return success, errorMessage
                        end
                    end
                end
            end
            return false
        end,
        -- For Just Repairing Body & Engine
        Normal = function(self, veh, alreadyDone)
            if DoesEntityExist(veh) then
                local driverPed = GetPedInVehicleSeat(veh, -1)
                if driverPed == 0 or driverPed == GLOBAL_PED then
                    if not alreadyDone then
                        TriggerServerEvent('VehicleSync:Server:BodyRepair', VehToNet(veh))
                    end

                    SetVehicleEngineHealth(veh, 1000.0)
                    SetVehicleBodyHealth(veh, 1000.0)
                    SetVehiclePetrolTankHealth(veh, 1000.0)
                    SetVehicleUndriveable(veh, false)
                    SetVehicleFixed(veh)
                    return true
                end
            end
            return false
        end,
        -- For Just Repairing Engine
        Engine = function(self, veh)
            if DoesEntityExist(veh) then
                local driverPed = GetPedInVehicleSeat(veh, -1)
                if driverPed == 0 or driverPed == GLOBAL_PED then
                    TriggerServerEvent('VehicleSync:Server:EngineRepair', VehToNet(veh))

                    SetVehicleEngineHealth(veh, 1000.0)
                    SetVehiclePetrolTankHealth(veh, 1000.0)
                    SetVehicleUndriveable(veh, false)
                    return true
                end
            end
            return false
        end,
        -- Repair a Specific Part (or all if none specified)
        Part = function(self, veh, part, repairAmount)
            if DoesEntityExist(veh) then
                local driverPed = GetPedInVehicleSeat(veh, -1)
                if driverPed == 0 or driverPed == GLOBAL_PED then
                    local timeout = false
                    Citizen.SetTimeout(2000, function() 
                        timeout = true
                    end)

                    while not NetworkHasControlOfEntity(veh) and not timeout do
                        NetworkRequestControlOfEntity(veh)
                        Citizen.Wait(100)
                    end

                    if NetworkHasControlOfEntity(veh) then
                        if _noDegenDamageVehicleClasses[GetVehicleClass(veh)] then
                            return true
                        end

                        local vehEnt = Entity(veh)
                        if vehEnt and vehEnt.state then
                            local currentPartDamage = vehEnt.state.DamagedParts
                            if type(currentPartDamage) == 'table' then
                                if part then
                                    if currentPartDamage[part] then
                                        if type(repairAmount) == 'number' and repairAmount > 0 then
                                            currentPartDamage[part] = math.min(100, (currentPartDamage[part] + tonumber(repairAmount)))
                                        else
                                            currentPartDamage[part] = 100.0
                                            TriggerEvent('Vehicles:Client:ForceUpdateVehicleDegenState', veh)
                                        end
                                    end
                                else
                                    currentPartDamage = GetDefaultDamagedParts()
                                end
                            else
                                currentPartDamage = GetDefaultDamagedParts()
                            end
                            vehEnt.state:set('DamagedParts', currentPartDamage, true)
                            return true
                        end
                    end
                end
            end
            return false
        end,
        -- Full Repairs of everything including parts
        Full = function(self, veh)
            local nSuccess = Vehicles.Repair:Normal(veh)
            local pSuccess = Vehicles.Repair:Part(veh, false)
            if nSuccess and pSuccess then
                return true
            end
            return false
        end,
    }
}

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'Vehicles' then
        exports['mythic-base']:ExtendComponent(component, _vehicleRepair)
    end
end)

function CanRepairVehicle(vehicle)
    local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
    if vehicle and DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) and (IsCloseToFrontOfVehicle(vehicle, pedCoords) or IsCloseToRearOfVehicle(vehicle, pedCoords)) and (not GetPedInVehicleSeat(vehicle, -1) or GetPedInVehicleSeat(vehicle, -1) == 0) then
        return true
    end
    return false
end

AddEventHandler('Vehicles:Client:StartUp', function()
    Callbacks:RegisterClientCallback('Vehicles:RepairKit', function(type, cb)
        if LocalPlayer.state.loggedIn then
            local entity = Targeting:GetEntityPlayerIsLookingAt()

            if entity and entity.entity and CanRepairVehicle(entity.entity) then
                local vehicle = entity.entity
                if Vehicles.Repair:NeedsKit(vehicle, type) then
                    TaskTurnPedToFaceEntity(GLOBAL_PED, vehicle, 1)
                    Citizen.Wait(500)
                    Vehicles.Sync.Doors:Open(vehicle, 4, false, false)
                    Progress:Progress({
                        name = "vehicle_repair_kit",
                        duration = 7500,
                        label = "Repairing Engine",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "mini@repair",
                            anim = "fixing_a_player",
                            flags = 16,
                        },
                        disarm = true,
                    }, function(cancelled)
                        if not cancelled and CanRepairVehicle(vehicle) then
                            local success, errorMessage = Vehicles.Repair:Kit(vehicle, type)
                            cb(success)

                            Vehicles.Sync.Doors:Shut(vehicle, 4, false)

                            if not success then
                                if errorMessage then
                                    Notification:Error(errorMessage)
                                else
                                    Notification:Error('Repair Failed')
                                end
                            else
                                Notification:Success('Repaired Successfully')
                            end
                        else
                            cb(false)
                        end
                    end)
                else
                    Notification:Error('Vehicle Doesn\'t Need Repair')
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent('VehicleSync:Client:BodyRepair', function(vNet)
    if NetworkDoesEntityExistWithNetworkId(vNet) then
        local vehicle = NetToVeh(vNet)

        if DoesEntityExist(vehicle) then
            Vehicles.Repair:Normal(vehicle, true)
        end
    end
end)