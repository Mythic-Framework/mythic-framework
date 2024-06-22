local randomPartDamageMults = {
    Axle = 0.1,
    Radiator = 0.15,
    Transmission = 0.1,
    FuelInjectors = 0.08,
    Brakes = 0.15,
    Clutch = 0.1,
    Electronics = 0.1,
}

local damagePartDamageMults = {
    Axle = 1.5,
    Radiator = 1.3,
    Transmission = 2.0,
    FuelInjectors = 0.8,
    Brakes = 2.0,
    Clutch = 1.25,
    Electronics = 1.1,
}

local onDestroyPartDamage = {
    Axle = 15.5,
    Radiator = 20.0,
    Transmission = 14.0,
    FuelInjectors = 18.0,
    Brakes = 16.0,
    Clutch = 18.0,
    Electronics = 16.5,
}

local partDamageRequiredSpeed = {
    Axle = 5.0,
    Transmission = 5.0,
    Radiator = 15.0,
    Brakes = 2.0,
}

local WEAK_BRAKES = false

function RunVehiclePartsDamage(veh, isRandom, damageAmount, destroyed)
    if DoesEntityExist(veh) then
        local vehEnt = Entity(veh)
        local currentDamage = vehEnt.state.DamagedParts
        local vehSpeed = math.floor(GetEntitySpeed(veh) * 3.6)
        if type(currentDamage) ~= 'table' then
            currentDamage = GetDefaultDamagedParts()
        end

        if isRandom then
            local speedMult = ((vehSpeed > 100.0) and vehSpeed or 100.0) / 100
            for k, v in pairs(randomPartDamageMults) do
                local requiredSpeed = partDamageRequiredSpeed[k] or 0.0
                if vehSpeed >= requiredSpeed then
                    local newDamage = Utils:Round((currentDamage[k] - (v * speedMult)), 3)
                    if newDamage <= 0.0 then
                        newDamage = 0.0
                    end
                    currentDamage[k] = newDamage
                end
            end

            Logger:Trace('Vehicles', 'Running Regular Damage Degen - Data: ' .. json.encode(currentDamage, { indent = true }))
        else
            if damageAmount then
                local damageMult = (100 + damageAmount) / 100
                for k, v in pairs(damagePartDamageMults) do
                    local newDamage = Utils:Round((currentDamage[k] - (v * damageMult)), 3)
                    if newDamage <= 0.0 then
                        newDamage = 0.0
                    end
                    currentDamage[k] = newDamage
                end
                Logger:Trace('Vehicles', 'Running Collision Damage Degen - Data: ' .. json.encode(currentDamage))
            elseif destroyed then
                for k, v in pairs(onDestroyPartDamage) do
                    local newDamage = Utils:Round((currentDamage[k] - v), 3)
                    if newDamage <= 0.0 then
                        newDamage = 0.0
                    end
                    currentDamage[k] = newDamage

                    vehEnt.state:set('Damage', {
                        Engine = -1000.0,
                        Body = 0.0,
                    }, true)
                end
                Logger:Trace('Vehicles', 'Running Destroyed Damage Degen - Data: ' .. json.encode(currentDamage))
            end
        end

        vehEnt.state:set('DamagedParts', currentDamage, true)
        vehEnt.state:set('NeedSave', true, true)
        return currentDamage
    end
end

function RunVehiclePartsDamageEffects(veh)
    if DoesEntityExist(veh) and INSIDE_HAS_DEGEN then
        local vehEnt = Entity(veh)
        local currentDamage = vehEnt.state.DamagedParts
        local vehSpeed = GetEntitySpeed(veh) * 3.6
        local funChance = math.random(1, 100)
        if type(currentDamage) == 'table' then
            -- Axle Effects
            if currentDamage.Axle and currentDamage.Axle <= 30.0 then
                local amount = false
                if (currentDamage.Axle >= 20.0 and funChance >= 90) then
                    amount = 3
                elseif (currentDamage.Axle < 20.0 and currentDamage.Axle >= 10.0 and funChance >= 80) then
                    amount = 15
                elseif (currentDamage.Axle < 10.0 and funChance >= 45) then
                    amount = 25
                end

                if amount then
                    Logger:Trace('Vehicles', 'Running Damage Effects - Axle')
                    CreateThread(function()
                        for i = 0, amount do
                            SetVehicleSteerBias(veh, -1.0)
                            Wait(1)
                        end
                        for i = 0, amount do
                            SetVehicleSteerBias(veh, 1.0)
                            Wait(1)
                        end
                    end)
                end
            end
            funChance = math.random(1, 100)
            -- Electronics
            if currentDamage.Electronics and currentDamage.Electronics <= 22.5 then
                if (currentDamage.Electronics >= 15.0 and funChance >= 80) or (currentDamage.Electronics < 15.0 and currentDamage.Electronics >= 5.0 and funChance >= 65) or (currentDamage.Electronics < 5.0 and funChance >= 50) then
                    Logger:Trace('Vehicles', 'Running Damage Effects - Electronics')
                    if currentDamage.Electronics <= 10 and funChance >= 90 then
                        CreateThread(function()
                            SetVehicleControlsInverted(veh, true)
                            Wait(12000)
                            SetVehicleControlsInverted(veh, false)
                        end)
                    end

                    CreateThread(function()
                        for i = 1, 10 do
                            SetVehicleLights(veh, 2)
                            Wait(400)
                            SetVehicleLights(veh, 0)
                            Wait(math.random(5, 50))
                        end
                    end)
                end
            end

            funChance = math.random(1, 100)
            -- Brakes
            if (currentDamage.Brakes and currentDamage.Brakes <= 25.0) and funChance >= 50 then
                Logger:Trace('Vehicles', 'Running Damage Effects - Brakes')
                CreateThread(function()
                    WEAK_BRAKES = true
                    SetVehicleWeakBrakesState(veh, true)
                    Wait(currentDamage.Brakes <= 5.0 and 60000 or 15000)
                    if WEAK_BRAKES then
                        SetVehicleWeakBrakesState(veh, false)
                        WEAK_BRAKES = false
                    end
                end)
            end

            funChance = math.random(1, 100)
            -- Fuel Injectors
            if (currentDamage.FuelInjectors and currentDamage.FuelInjectors <= 30.0) then
                local amount = false
                local wait = math.random(50, 500)
                if (currentDamage.FuelInjectors >= 20.0 and funChance <= 10) then
                    amount = 2
                elseif (currentDamage.FuelInjectors < 20.0 and currentDamage.FuelInjectors >= 10.0 and funChance <= 25) then
                    amount = 4
                elseif (currentDamage.FuelInjectors < 10.0 and currentDamage.FuelInjectors >= 5.0 and funChance <= 40) then
                    amount = 6
                elseif (currentDamage.FuelInjectors < 5.0 and funChance <= 60) then
                    amount = 8
                end

                if amount then
                    Logger:Trace('Vehicles', 'Running Damage Effects - Fuel Injectors')

                    CreateThread(function()
                        for i = 1, amount do
                            Vehicles.Engine:Force(veh, false)
                            Wait(wait)
                            Vehicles.Engine:Force(veh, true)
                            Wait(wait + 100)
                        end
                    end)
                end
            end

            funChance = math.random(1, 100)
            -- Radiator
            if (currentDamage.Radiator and currentDamage.Radiator <= 30.0) then
                local engineHealth = GetVehicleEngineHealth(veh)
                local damageHit = false
                if (currentDamage.Radiator >= 20.0 and funChance <= 15) then
                    if engineHealth <= 1000 and engineHealth >= 700 then
                        damageHit = 5.0
                    end
                elseif (currentDamage.Radiator < 20.0 and currentDamage.Radiator >= 10.0 and funChance <= 28) then
                    if engineHealth <= 1000 and engineHealth >= 600 then
                        damageHit = 7.5
                    end
                elseif (currentDamage.Radiator < 10.0 and currentDamage.Radiator >= 5.0 and funChance <= 40) then
                    if engineHealth <= 1000 and engineHealth >= 400 then
                        damageHit = 12.5
                    end
                elseif (currentDamage.Radiator < 5.0 and funChance <= 65) then
                    if engineHealth <= 1000 and engineHealth >= 300 then
                        damageHit = 15.0
                    end
                end

                if damageHit then
                    local newHealth = engineHealth - damageHit
                    if newHealth <= -2000 then
                        Logger:Trace('Vehicles', 'Running Damage Effects - Radiator')
                        SetVehicleEngineHealth(veh, newHealth)
                    end
                end
            end

            funChance = math.random(1, 100)
            -- Transmission
            if (currentDamage.Transmission and currentDamage.Transmission <= 30.0) then
                local amount = false
                if (currentDamage.Transmission >= 20.0 and funChance <= 10) then
                    amount = 4
                elseif (currentDamage.Transmission < 20.0 and currentDamage.Transmission >= 10.0 and funChance <= 20) then
                    amount = 6
                elseif (currentDamage.Transmission < 10.0 and currentDamage.Transmission >= 5.0 and funChance <= 35) then
                    amount = 8
                elseif (currentDamage.Transmission < 5.0 and funChance <= 50) then
                    amount = 10
                end

                if amount then
                    Logger:Trace('Vehicles', 'Running Damage Effects - Transmission')
                    CreateThread(function()
                        for i = 1, amount do
                            SetVehicleHandbrake(veh, true)
                            Wait(200)
                            SetVehicleHandbrake(veh, false)
                            Wait(math.random(350, 1200))
                        end
                    end)
                end
            end

            funChance = math.random(1, 100)
            -- Transmission
            if (currentDamage.Clutch and currentDamage.Clutch <= 30.0) then
                local wait = false
                if (currentDamage.Clutch >= 20.0 and funChance <= 10) then
                    wait = 2500
                elseif (currentDamage.Clutch < 20.0 and currentDamage.Clutch >= 10.0 and funChance <= 20) then
                    wait = 3500
                elseif (currentDamage.Clutch < 10.0 and currentDamage.Clutch >= 5.0 and funChance <= 35) then
                    wait = 5000
                elseif (currentDamage.Clutch < 5.0 and funChance <= 50) then
                    wait = 7000
                end

                if wait then
                    Logger:Trace('Vehicles', 'Running Damage Effects - Clutch')
                    local lolGetFucked = true
                    SetTimeout(wait, function()
                        lolGetFucked = false
                    end)
                    CreateThread(function()
                        while lolGetFucked do
                            Wait(5)
                            SetVehicleCurrentRpm(veh, 0.2)
                        end
                    end)
                end
            end
        end
    end
end

function SetVehicleWeakBrakesState(veh, state)
    if state then
        Logger:Trace('Vehicles', 'Weak Brakes: On')
        SetVehicleHandlingOverrideMultiplier(veh, 'fBrakeForce', 'Float', 0.5)
    else
        Logger:Trace('Vehicles', 'Weak Brakes: Off')
        ResetVehicleHandlingOverride(veh, 'fBrakeForce')
    end
end

AddEventHandler('Vehicles:Client:ForceUpdateVehicleDegenState', function(veh)
    SetVehicleWeakBrakesState(veh, false)
end)

AddEventHandler('Vehicles:Client:ExitVehicle', function(veh)
    SetVehicleWeakBrakesState(veh, false)
end)