AddEventHandler('Vehicles:Client:StartUp', function()
    Interaction:RegisterMenu("pd_ems_boats", "Access Boat", "ship", function()
        StartRequestEmergencyBoat()
        Interaction:Hide()
    end, function()
        if LocalPlayer.state.onDuty == "police" or LocalPlayer.state.onDuty == "ems" then
            local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
            local inVehicleStorageZone, vehicleStorageZoneId = GetVehicleStorageAtCoords(pedCoords)

            if inVehicleStorageZone and vehicleStorageZoneId then
                local vehStorageData = _vehicleStorage[vehicleStorageZoneId]

                if vehStorageData and vehStorageData.spaces and vehStorageData.vehType == 1 then
                    return true
                end
            end
        end
    end)
end)

function StartRequestEmergencyBoat()
    local pedCoords = GetEntityCoords(LocalPlayer.state.ped)
    local inVehicleStorageZone, vehicleStorageZoneId = GetVehicleStorageAtCoords(pedCoords)
    if inVehicleStorageZone and vehicleStorageZoneId then
        local vehStorageData = _vehicleStorage[vehicleStorageZoneId]

        if vehStorageData and vehStorageData.spaces and vehStorageData.vehType == 1 then
            local parkingSpace = GetClosestAvailableParkingSpace(pedCoords, vehStorageData.spaces)

            if parkingSpace then
                TriggerServerEvent("Vehicles:Server:RequestEmergencyBoat", parkingSpace)
                return
            end
        end
    end

    Notification:Error("Not at Boat Storage or Spaces Full")
end