local boatModels = {
    police = `predator`,
    ems = `dinghy3`
}

local boatCooldowns = {}

RegisterNetEvent("Vehicles:Server:RequestEmergencyBoat", function(parkingSpace)
    local src = source
    local char = Fetch:Source(src):GetData("Character")
    local onDuty = Player(src).state.onDuty
    if char and (onDuty == "police" or onDuty == "ems") and (not boatCooldowns[onDuty] or boatCooldowns[onDuty] <= os.time()) then
        Vehicles:SpawnTemp(source, boatModels[onDuty] or `predator`, parkingSpace.xyz, parkingSpace.w, function(veh, VIN)
            Vehicles.Keys:Add(src, VIN)

            Entity(veh).state.GroupKeys = onDuty
            Entity(veh).state.EmergencyBoat = true

            boatCooldowns[onDuty] = os.time() + (60 * 2) -- Will do for now
        end)
    else
        Execute:Client(source, "Notification", "Error", "On Cooldown")
    end
end)

RegisterNetEvent("Vehicles:Server:DeleteEmergencyBoat", function(vNet)
    local src = source
    local char = Fetch:Source(src):GetData("Character")
    local onDuty = Player(src).state.onDuty
    if char and (onDuty == "police" or onDuty == "ems") then
        local veh = NetworkGetEntityFromNetworkId(vNet)
        if veh and DoesEntityExist(veh) and Entity(veh).state.EmergencyBoat then
            Vehicles:Delete(veh, function() end)

            boatCooldowns[onDuty] = false
        end
    end
end)