RegisterServerEvent('VehicleSync:Server:EmergencyAirhorn', function(veh, state)
    TriggerClientEvent('VehicleSync:Client:EmergencyAirhorn', -1, veh, state)
end)

RegisterServerEvent('VehicleSync:Server:SyncIndicators', function(veh, state)
    TriggerClientEvent('VehicleSync:Client:SyncIndicators', -1, veh, state)
end)

RegisterServerEvent('VehicleSync:Server:Emergency', function(veh, lights, siren)
    TriggerClientEvent('VehicleSync:Client:Emergency', -1, veh, lights, siren)
end)

RegisterNetEvent('VehicleSync:Server:SyncNeons', function(veh, state)
    TriggerClientEvent('VehicleSync:Client:SyncNeons', -1, veh, state)
end)

RegisterServerEvent('VehicleSync:Server:ShutDoor', function(vNet, door, instant)
    local veh = NetworkGetEntityFromNetworkId(vNet)

    TriggerClientEvent('VehicleSync:Client:ShutDoor', NetworkGetEntityOwner(veh), vNet, door, instant)
end)

RegisterServerEvent('VehicleSync:Server:OpenDoor', function(vNet, door, loose, instant)
    local veh = NetworkGetEntityFromNetworkId(vNet)

    TriggerClientEvent('VehicleSync:Client:OpenDoor', NetworkGetEntityOwner(veh), vNet, door, loose, instant)
end)

RegisterServerEvent('VehicleSync:Server:BodyRepair', function(vNet, door, loose, instant)
    local veh = NetworkGetEntityFromNetworkId(vNet)

    local ent = Entity(veh)
    if ent and ent.state then
        ent.state.Damage = {
            Body = 1000.0,
            Engine = 1000.0
        }
        ent.state.RepairKits = 0

        ent.state.BlownUp = false
    end

    TriggerClientEvent('VehicleSync:Client:BodyRepair', -1, vNet)
end)

RegisterServerEvent('VehicleSync:Server:EngineRepair', function(vNet, door, loose, instant)
    local veh = NetworkGetEntityFromNetworkId(vNet)

    local ent = Entity(veh)
    if ent and ent.state then
        local currentStuff = ent.state.Damage or {}

        ent.state.Damage = {
            Body = currentStuff.Body or 1000.0,
            Engine = 1000.0
        }
        ent.state.RepairKits = 0

        ent.state.BlownUp = false
    end
end)

RegisterNetEvent('Vehicles:Server:ToggleAnchor', function(vNet)
    TriggerClientEvent('Vehicles:Client:ToggleAnchor', vNet)
end)

RegisterNetEvent('Vehicles:Server:SyncNitroEffect', function(vNet, state)
    TriggerClientEvent('Vehicles:Client:SyncNitroEffect', -1, vNet, state)
end)

RegisterNetEvent('Vehicles:Server:SyncPurgeEffect', function(vNet, state)
    TriggerClientEvent('Vehicles:Client:SyncPurgeEffect', -1, vNet, state)
end)