local cruiseControl = false
local noCruise = {
    [13] = true,
    [14] = true,
    [15] = true,
    [16] = true,
}

AddEventHandler('Vehicles:Client:StartUp', function()
    Keybinds:Add('vehicle_cruise', '', 'keyboard', 'Vehicle - Toggle Cruise', function()
        if VEHICLE_INSIDE and not noCruise[VEHICLE_CLASS] then
            if cruiseControl then
                cruiseControl = false
                SetEntityMaxSpeed(VEHICLE_INSIDE, 1000.0)
            else
                local speed = GetEntitySpeed(VEHICLE_INSIDE)
                if speed >= 6.7 then
                    cruiseControl = true
                    SetEntityMaxSpeed(VEHICLE_INSIDE, speed)
                else
                    Notification:Info('Cruise Can Only Be Enabled Above 25MPH')
                end
            end

            TriggerEvent('Vehicles:Client:Cruise', cruiseControl)
        end
    end)
end)

AddEventHandler('Vehicles:Client:EnterVehicle', function(v, seat)
    cruiseControl = false
    SetEntityMaxSpeed(VEHICLE_INSIDE, 1000.0)
    TriggerEvent('Vehicles:Client:Cruise', false)
end)

AddEventHandler('Vehicles:Client:ExitVehicle', function()
    cruiseControl = false
    SetEntityMaxSpeed(VEHICLE_INSIDE, 1000.0)
    TriggerEvent('Vehicles:Client:Cruise', false)
end)