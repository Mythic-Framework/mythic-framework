FUEL = {
    Fuel = {
        CanBeFueled = function(self, vehicle)
            if DoesEntityExist(vehicle) and GetVehicleClass(vehicle) ~= 13 then
                local vehState = Entity(vehicle).state
                if vehState.VIN and vehState.Fuel ~= nil then
                    local vehicleInZone = IsVehicleInFuelZone(vehicle)
                    if vehicleInZone then
                        local requiredFuel = 100 - vehState.Fuel
                        if requiredFuel > 1 then
                            return {
                                zone = vehicleInZone,
                                needsFuel = true,
                                requiredFuel = requiredFuel,
                                cost = CalculateFuelCost(GetVehicleClass(vehicle), requiredFuel),
                            }
                        else
                            return {
                                zone = vehicleInZone,
                                needsFuel = false,
                            }
                        end
                    end
                end
            end
            return false
        end,
    }
}

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'Vehicles' then
        exports['mythic-base']:ExtendComponent(component, FUEL)
    end
end)