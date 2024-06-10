function CheckStationRestriction(restrictedState, vehicleClass)
    if not restrictedState then
        return true
    end

    if restrictedState == 'aircraft' and (vehicleClass == 15 or vehicleClass == 16) then
        return true
    elseif restrictedState == 'boat' and vehicleClass == 14 then
        return true
    end

    return false
end

function IsVehicleInFuelZone(vehicle)
    local vehicleCoords = GetEntityCoords(vehicle)
    local vehicleZone = Polyzone:IsCoordsInZone(vehicleCoords, false, 'fuel')
    if vehicleZone and vehicleZone.fuel and CheckStationRestriction(vehicleZone.restricted, GetVehicleClass(vehicle)) then
        return vehicleZone.id
    end
    return false
end