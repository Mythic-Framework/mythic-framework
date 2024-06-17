DAMAGE_VEHICLE = false

SENT_FUCKED_DAMAGE = {}

LAST_DAMAGE_ENGINE = 1000.0
LAST_DAMAGE_BODY = 1000.0

INSIDE_DAMAGE_MODIFIER = 1.8
INSIDE_HAS_DEGEN = false

AddEventHandler('Vehicles:Client:ForceUpdateVehicleDamageState', function(vehicle, newDamage)
    if vehicle == DAMAGE_VEHICLE and newDamage then
        LAST_DAMAGE_ENGINE = newDamage.Engine
        LAST_DAMAGE_BODY = newDamage.Body

        SENT_FUCKED_DAMAGE[vehicle] = false
    end
end)

AddEventHandler('gameEventTriggered', function(event, args)
    if event == 'CEventNetworkEntityDamage' then
        local entity, attacker, _, _, _, isFatal, weaponHash, _, _, _, _, isMelee, hitType = table.unpack(args)
        if DAMAGE_VEHICLE and entity == DAMAGE_VEHICLE and (NetworkHasControlOfEntity(DAMAGE_VEHICLE) or (DAMAGE_VEHICLE == VEHICLE_INSIDE and VEHICLE_SEAT == -1)) then
            if isMelee == 1 then -- Put health back to how it was, you shouldn't be able to set a vehicle on fire by kicking it
                SetVehicleEngineHealth(DAMAGE_VEHICLE, LAST_DAMAGE_ENGINE + 0.0)
            else
                local engineRunning = GetIsVehicleEngineRunning(DAMAGE_VEHICLE)
                local engineHealth = math.floor(GetVehicleEngineHealth(DAMAGE_VEHICLE))
                local bodyHealth = math.floor(GetVehicleBodyHealth(DAMAGE_VEHICLE))

                if (engineHealth < LAST_DAMAGE_ENGINE) or (bodyHealth < LAST_DAMAGE_BODY) then
                    local engineHealthDiff = math.floor(LAST_DAMAGE_ENGINE - engineHealth)
                    local bodyHealthDiff = math.floor(LAST_DAMAGE_BODY - bodyHealth)

                    if engineHealthDiff > 0.0 then
                        Logger:Trace('Vehicles', 'Engine Damaged - New Health: '.. engineHealth)
                    end
    
                    if bodyHealthDiff > 0.0 then
                        Logger:Trace('Vehicles', 'Body Damage Taken: '.. bodyHealthDiff .. ' - New Health: '.. bodyHealth)
    
                        if engineRunning and VEHICLE_INSIDE == DAMAGE_VEHICLE and bodyHealthDiff >= 50.0 and math.random(55) >= 35 then
                            local stalling = true
                            Notification:Error('Engine Stalled')
                            CreateThread(function()
                                while stalling do
                                    Vehicles.Engine:Force(DAMAGE_VEHICLE, false)
                                    Wait(500)
                                end
                            end)
                            SetTimeout(math.random(1, 5) * 1000, function()
                                stalling = false
                            end)
                        end
                    end

                    if bodyHealthDiff >= 120.0 then
                        local tire = math.random(0, GetVehicleNumberOfWheels(DAMAGE_VEHICLE))
                        SetVehicleTyreBurst(DAMAGE_VEHICLE, tire, true, 0.0)
                    end

                    if INSIDE_HAS_DEGEN and (engineHealthDiff >= 20.0 and engineHealth <= 700.0) or (bodyHealthDiff >= 15.0 and bodyHealth <= 850.0) then
                        RunVehiclePartsDamage(DAMAGE_VEHICLE, false, math.max(bodyHealthDiff, engineHealthDiff))
                    end

                    if bodyHealthDiff >= 10.0 and bodyHealth <= 900.0 and engineHealth >= 200.0 then
                        local newEngineDamage = engineHealth - bodyHealthDiff
                        if bodyHealth <= 550.0 then
                            newEngineDamage *= 2.5
                        elseif bodyHealth <= 750.0 then
                            newEngineDamage *= 2
                        end

                        if newEngineDamage < engineHealth and newEngineDamage > 0 then
                            SetVehicleEngineHealth(DAMAGE_VEHICLE, newEngineDamage + 0.0)
                        end
                    end

                    if bodyHealth <= 100.0 then
                        bodyHealth = 100.0
                        SetVehicleBodyHealth(DAMAGE_VEHICLE, 100.0)
                    end
    
                    if bodyHealth <= 100.0 and engineHealth > 300.0 then
                        SetVehicleEngineHealth(DAMAGE_VEHICLE, 300.0)
                    end
    
                    LAST_DAMAGE_ENGINE = engineHealth
                    LAST_DAMAGE_BODY = bodyHealth

                    local vehEnt = Entity(DAMAGE_VEHICLE)
                    if vehEnt and vehEnt.state then
                        vehEnt.state:set('Damage', {
                            Engine = LAST_DAMAGE_ENGINE,
                            Body = LAST_DAMAGE_BODY,
                        }, true)
                        vehEnt.state:set('NeedSave', true, true)
                    end
                end
            end
        end
    end
end)

AddEventHandler('Vehicles:Client:StartUp', function()
    AddTaskBeforeVehicleThread('regular_damage', function(veh, class)
        DAMAGE_VEHICLE = veh

        fuckingExplode = false

        INSIDE_DAMAGE_MODIFIER = 2.0
        if _damageMultiplierOverrides[class] then
            INSIDE_DAMAGE_MODIFIER = _damageMultiplierOverrides[class]
        end

        if _damageMultiplierOverridesModel[GetEntityModel(veh)] then
            INSIDE_DAMAGE_MODIFIER = _damageMultiplierOverridesModel[GetEntityModel(veh)]
        end

        INSIDE_HAS_DEGEN = not _noDegenDamageVehicleClasses[class]

        SetVehicleControlsInverted(veh, false)
        SetVehicleDamageModifier(veh, INSIDE_DAMAGE_MODIFIER + 0.0)

        LAST_DAMAGE_ENGINE = math.ceil(GetVehicleEngineHealth(veh))
        LAST_DAMAGE_BODY = math.ceil(GetVehicleEngineHealth(veh))
        
        local vehEnt = Entity(veh)
        if vehEnt and vehEnt.state then
            if vehEnt.state.Damage and vehEnt.state.Damage.Engine and vehEnt.state.Damage.Body then
                SetVehicleEngineHealth(veh, vehEnt.state.Damage.Engine + 0.0)
                SetVehicleBodyHealth(veh, vehEnt.state.Damage.Body + 0.0)

                LAST_DAMAGE_ENGINE = vehEnt.state.Damage.Engine
                LAST_DAMAGE_BODY = vehEnt.state.Damage.Body
            end
        end
    end)

    AddTaskToVehicleThread('regular_damage', 8, false, function(veh, class)
        if NetworkHasControlOfEntity(veh) then
            SetVehicleDamageModifier(veh, INSIDE_DAMAGE_MODIFIER + 0.0)
            local engineRunning = GetIsVehicleEngineRunning(veh)
            local engineHealth = math.floor(GetVehicleEngineHealth(veh))

            if engineRunning and engineHealth <= 200.0 then
                local newEngineHealth = engineHealth - 2.0
                if newEngineHealth < -100.0 then
                    newEngineHealth = -100.0
                end

                if newEngineHealth < engineHealth then
                    SetVehicleEngineHealth(veh, newEngineHealth + 0.0)
                end
            end

            if engineHealth <= -100.0 then
                if INSIDE_HAS_DEGEN and not SENT_FUCKED_DAMAGE[veh] then
                    SENT_FUCKED_DAMAGE[veh] = true
                    RunVehiclePartsDamage(veh, false, false, true)
                end

                local allowExplode = math.random(5, engineRunning and 40 or 60)
                if fuckingExplode or (allowExplode <= 7) then
                    fuckingExplode = true
                    SetDisableVehiclePetrolTankDamage(veh, false)
                    SetDisableVehiclePetrolTankFires(veh, false)
                    SetVehiclePetrolTankHealth(veh, 200.0)
                else
                    fuckingExplode = false
                    SetDisableVehiclePetrolTankDamage(veh, true)
                    SetDisableVehiclePetrolTankFires(veh, true)
                    SetVehiclePetrolTankHealth(veh, 1000.0)
                end
            else
                if fuckingExplode then
                    fuckingExplode = false
                end

                if SENT_FUCKED_DAMAGE[veh] then
                    SENT_FUCKED_DAMAGE[veh] = false
                end
            end
        end
    end)

    AddTaskToVehicleThread('damage_degen', 200, false, function(veh, class, engineRunning)
        if engineRunning and INSIDE_HAS_DEGEN and RunVehiclePartsDamage then
            RunVehiclePartsDamage(veh, true)
        end
    end)

    AddTaskToVehicleThread('damage_effects', 40, true, function(veh, class, engineRunning)
        if engineRunning and INSIDE_HAS_DEGEN and RunVehiclePartsDamageEffects then
            RunVehiclePartsDamageEffects(veh)
        end
    end)
end)