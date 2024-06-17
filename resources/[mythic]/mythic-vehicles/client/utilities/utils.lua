function GetPedSeatInVehicle(veh, ped)
    local totalSeats = GetVehicleMaxNumberOfPassengers(veh)
    for i = -1, totalSeats do
        if GetPedInVehicleSeat(veh, i) == ped then 
            return i
        end
    end
    return false
end

-- Yes this is aids

function DoVehicleUnlockShit(veh)
    StartVehicleHorn(veh, 80, "HELDDOWN", false)
    SetVehicleLights(veh, 2)
    Wait(200)
    SetVehicleLights(veh, 0)
    Wait(200)
    SetVehicleLights(veh, 2)
    Wait(200)
    SetVehicleLights(veh, 0)
end

function DoVehicleLockShit(veh)
    StartVehicleHorn(veh, 80, "HELDDOWN", false)
    Wait(160)
    StartVehicleHorn(veh, 350, "HELDDOWN", false)
    SetVehicleLights(veh, 2)
    Wait(200)
    SetVehicleLights(veh, 0)
    Wait(200)
    SetVehicleLights(veh, 2)
    Wait(200)
    SetVehicleLights(veh, 0)
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

function GetFrontOfVehicleCoords(vehicle)
    local min, max = GetModelDimensions(GetEntityModel(vehicle))
    return GetOffsetFromEntityInWorldCoords(vehicle, 0.0, min.y, 0.0)
end

function GetRearOfVehicleCoords(vehicle)
    local min, max = GetModelDimensions(GetEntityModel(vehicle))
    return GetOffsetFromEntityInWorldCoords(vehicle, 0.0, max.y, 0.0)
end

function IsCloseToFrontOfVehicle(vehicle, pedCoords)
    local vehFrontCoords = GetFrontOfVehicleCoords(vehicle)

    if #(vehFrontCoords - pedCoords) <= 1.5 then
        return true
    end
    return false
end

function IsCloseToRearOfVehicle(vehicle, pedCoords)
    local vehRearCoords = GetRearOfVehicleCoords(vehicle)

    if #(vehRearCoords - pedCoords) <= 1.5 then
        return true
    end
    return false
end

function IsCloseToVehicle(vehicle, pedCoords)
    local vehCoords = GetEntityCoords(vehicle)

    if #(vehCoords - pedCoords) <= 5.0 then
        return true
    end
    return false
end

function CanModelHaveFakePlate(model)
    if IsThisModelACar(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
        return true
    end
    return false
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

function UnlockAnim()
	CreateThread(function()
		while not HasAnimDictLoaded('anim@heists@keycard@') do
			RequestAnimDict('anim@heists@keycard@')
			Wait(10)
		end

		TaskPlayAnim(LocalPlayer.state.ped, 'anim@heists@keycard@', 'exit', 8.0, 1.0, -1, 48, 0, 0, 0, 0)
		Wait(750)
        StopAnimTask(LocalPlayer.state.ped, 'anim@heists@keycard@', 'exit', 1.0)
	end)
end

function GetVehicleMPH(veh)
    return GetEntitySpeed(veh) * 2.237
end