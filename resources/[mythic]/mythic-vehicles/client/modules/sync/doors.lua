RegisterNetEvent('VehicleSync:Client:OpenDoor', function(vNet, door, loose, instant)
    if NetworkDoesEntityExistWithNetworkId(vNet) then
        local veh = NetToVeh(vNet)
    
        HandleDoorOpenSync(veh, door, loose, instant)
    end
end)

function HandleDoorOpenSync(veh, door, loose, instant)
    if door == 'all' then
        for i = 0, 15 do
            SetVehicleDoorOpen(veh, i, loose, instant)
        end
    else
        SetVehicleDoorOpen(veh, door, loose, instant)
    end
end

RegisterNetEvent('VehicleSync:Client:ShutDoor', function(vNet, door, instant)
    if NetworkDoesEntityExistWithNetworkId(vNet) then
        local veh = NetToVeh(vNet)

        HandleDoorShutSync(veh, door, instant)
    end
end)

function HandleDoorShutSync(veh, door, instant)
    if door == 'all' then
        SetVehicleDoorsShut(veh, instant)
    else
        SetVehicleDoorShut(veh, door, instant)
    end
end