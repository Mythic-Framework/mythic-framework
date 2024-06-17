function GetVehicleBehindTowTruck(towTruck, distance)
    local fwdVector = GetEntityForwardVector(towTruck)
    local truckCoords = GetEntityCoords(towTruck)
    local targetCoords = truckCoords + (fwdVector * -distance)

    local ray = StartShapeTestSweptSphere(truckCoords, targetCoords, 0.75, 286, towTruck, 0)
    local _, hit, _, _, targetEntity = GetShapeTestResult(ray)
    if hit and targetEntity and DoesEntityExist(targetEntity) then
        return targetEntity
    end
    return false
end

function GetVehicleAttachOffset(towModel, targetVeh)
    local towPositioning = _towTrucks[towModel]
    if towPositioning then
        local model = GetEntityModel(targetVeh)
        local minDim, maxDim = GetModelDimensions(model)
        local vehSize = maxDim - minDim

        if towPositioning.classOverrides and towPositioning.classOverrides[GetVehicleClass(targetVeh)] then
            towPositioning = towPositioning.classOverrides[GetVehicleClass(targetVeh)]
        end

        return vector3(0.0, -(vehSize.y / towPositioning.position), towPositioning.height - minDim.z)
    end
end

function CanFuckingTowVehicle(truck, vehicle)
    if vehicle and IsEntityAVehicle(vehicle) and #(GetEntityCoords(truck) - GetEntityCoords(vehicle)) <= 20.0 and not _bannedClasses[GetVehicleClass(vehicle)] and not _bannedModels[GetEntityModel(vehicle)] and not Entity(vehicle).state.towingVehicle then
        if IsVehicleEmpty(vehicle) then
            if GetEntitySpeed(vehicle) <= 1.0 then
                return true
            else
                return false, 'The Vehicle Is Still Moving'
            end
        else
            return false, 'The Vehicle Needs to Be Empty'
        end
    else
        return false, 'No Towable Vehicle Found Behind Truck'
    end
end

function RequestControlWithTimeout(veh, timeout)
    local requestTimeout = false
    if not NetworkHasControlOfEntity(veh) then
		NetworkRequestControlOfEntity(veh)

		SetTimeout(timeout, function()
            requestTimeout = true
        end)

		while not NetworkHasControlOfEntity(veh) and not requestTimeout do
			NetworkRequestControlOfEntity(veh)
			Wait(200)
		end
	end

	return NetworkHasControlOfEntity(veh)
end

function IsVehicleEmpty(veh)
    for i = -1, GetVehicleMaxNumberOfPassengers(veh) do
        local pedInSeat = GetPedInVehicleSeat(veh, i)
        if pedInSeat > 0 then
            return false
        end
    end
    return true
end


function GetClosestAvailableParkingSpace(pedCoords, parkingSpaces)
    table.sort(parkingSpaces, function(a, b) 
        local distA = #(a.xyz - pedCoords)
        local distB = #(b.xyz - pedCoords)
        return distA > distB
    end)

    local nearestCoords = false

    for k, v in ipairs(parkingSpaces) do
        if IsParkingSpaceFree(v) then
            nearestCoords = v
        end
    end

    return nearestCoords
end

function IsParkingSpaceFree(spaceCoords)
    return GetClosestVehicleWithinRadius(spaceCoords.xyz, 2.0) == false
end

-- Because the normal one doesn't fucking work
function GetClosestVehicleWithinRadius(coords, radius)
    if not radius then
        radius = 5.0
    end

    local poolVehicles = GetGamePool('CVehicle')
    local lastDist = radius
    local lastVeh = false
    
    for k, v in ipairs(poolVehicles) do
        if DoesEntityExist(v) then
            local dist = #(coords - GetEntityCoords(v))
            if dist <= lastDist then
                lastDist = dist
                lastVeh = v
            end
        end
    end

    return lastVeh
end