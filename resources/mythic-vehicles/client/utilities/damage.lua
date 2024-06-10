function GetDefaultDamagedParts()
    return {
        Axle = 100.0,
        Radiator = 100.0,
        Transmission = 100.0,
        Brakes = 100.0,
        FuelInjectors = 100.0,
        Clutch = 100.0,
        Electronics = 100.0,
    }
end

function SetVehicleDamageData(vehicle, damageData)
    if damageData and damageData.Engine and damageData.Body then
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
        SetVehicleFixed(vehicle)

        SetVehicleEngineHealth(vehicle, damageData.Engine + 0.0)

        if damageData.Body < 200.0 then
            damageData.Body = 200.0
        end

        SetVehicleBodyHealth(vehicle, damageData.Body + 0.0)
    
        if damageData.Body <= 750.0 then
            for i = 0, 6 do
                SmashVehicleWindow(vehicle, i)
            end
        end

        if damageData.Body <= 600.0 then
            for i = 0, 6 do
                SetVehicleDoorBroken(vehicle, i, true)
            end
        end
    end
end