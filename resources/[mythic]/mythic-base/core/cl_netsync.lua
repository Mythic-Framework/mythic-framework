function RequestNetSync(method, entity, ...)
	TriggerServerEvent(
		"NetSync:Server:Request",
		GetInvokingResource(),
		GetPlayerServerId(NetworkGetEntityOwner(entity)),
		method,
		NetworkGetNetworkIdFromEntity(entity),
		...
	)
end

RegisterNetEvent("NetSync:Client:Execute", function(method, netId, ...)
	local entity = NetworkGetEntityFromNetworkId(netId)

	if DoesEntityExist(entity) then
		COMPONENTS.NetSync[method](COMPONENTS.NetSync, entity, ...)
	end
end)

COMPONENTS.NetSync = {
	_protected = true,
	_name = "base",
	DeleteVehicle = function(self, vehicle)
		if NetworkHasControlOfEntity(vehicle) then
			DeleteVehicle(vehicle)
		else
			RequestNetSync("DeleteVehicle", vehicle)
		end
	end,
	DeletePed = function(self, ped)
		if NetworkHasControlOfEntity(ped) then
			DeletePed(ped)
		else
			RequestNetSync("DeletePed", ped)
		end
	end,
	DeleteObject = function(self, object)
		if NetworkHasControlOfEntity(object) then
			DeleteObject(object)
		else
			RequestNetSync("DeleteObject", object)
		end
	end,
	DeleteEntity = function(self, entity)
		if NetworkHasControlOfEntity(entity) then
			DeleteEntity(entity)
		else
			RequestNetSync("DeleteEntity", entity)
		end
	end,
	SetVehicleTyreBurst = function(self, vehicle, index, onRim, dmg)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleTyreBurst(vehicle, index, onRim, dmg)
		else
			RequestNetSync("SetVehicleTyreBurst", vehicle, index, onRim, dmg)
		end
	end,
	SetVehicleDoorShut = function(self, vehicle, doorIndex, closeInstantly)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleDoorShut(vehicle, doorIndex, closeInstantly)
		else
			RequestNetSync("SetVehicleDoorShut", vehicle, doorIndex, closeInstantly)
		end
	end,
	SetVehicleDoorOpen = function(self, vehicle, doorIndex, loose, openInstantly)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleDoorOpen(vehicle, doorIndex, loose, openInstantly)
		else
			RequestNetSync("SetVehicleDoorOpen", vehicle, doorIndex, loose, openInstantly)
		end
	end,
	SetVehicleDoorBroken = function(self, vehicle, doorIndex, deleteDoor)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleDoorBroken(vehicle, doorIndex, deleteDoor)
		else
			RequestNetSync("SetVehicleDoorBroken", vehicle, doorIndex, deleteDoor)
		end
	end,
	SetVehicleTyreFixed = function(self, vehicle, wheelIndex)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleTyreFixed(vehicle, wheelIndex)
		else
			RequestNetSync("SetVehicleTyreFixed", vehicle, wheelIndex)
		end
	end,
	SetVehicleEngineHealth = function(self, vehicle, health)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleEngineHealth(vehicle, health * 1.0)
		else
			RequestNetSync("SetVehicleEngineHealth", vehicle, health * 1.0)
		end
	end,
	SetVehicleBodyHealth = function(self, vehicle, health)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleBodyHealth(vehicle, health * 1.0)
		else
			RequestNetSync("SetVehicleBodyHealth", vehicle, health * 1.0)
		end
	end,
	SetVehicleDeformationFixed = function(self, vehicle)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleDeformationFixed(vehicle)
		else
			RequestNetSync("SetVehicleDeformationFixed", vehicle)
		end
	end,
	SetVehicleFixed = function(self, vehicle)
		if NetworkHasControlOfEntity(vehicle) then
			SetVehicleFixed(vehicle)
		else
			RequestNetSync("SetVehicleFixed", vehicle)
		end
	end,
	NetworkExplodeVehicle = function(self, vehicle, isAudible, isInvisible)
		if NetworkHasControlOfEntity(vehicle) then
			NetworkExplodeVehicle(vehicle, isAudible, isInvisible, 0)
		else
			RequestNetSync("NetworkExplodeVehicle", vehicle, isAudible, isInvisible, 0)
		end
	end,
	BreakOffVehicleWheel = function(self, vehicle, wheelIndex, leaveDebrisTrail, deleteWheel, unknownFlag, putOnFire)
		if NetworkHasControlOfEntity(vehicle) then
			BreakOffVehicleWheel(vehicle, wheelIndex, leaveDebrisTrail, deleteWheel, unknownFlag, putOnFire)
		else
			RequestNetSync("BreakOffVehicleWheel", vehicle, wheelIndex, leaveDebrisTrail, deleteWheel, unknownFlag, putOnFire)
		end
	end,
	TaskWanderInArea = function(self, ped, x, y, z, radius, minimalLength, timeBetweenWalks)
		if NetworkHasControlOfEntity(ped) then
			ClearPedTasksImmediately(ped)
			TaskWanderInArea(ped, x, y, z, radius, minimalLength, timeBetweenWalks)
		else
			RequestNetSync("TaskWanderInArea", ped, x, y, z, radius, minimalLength, timeBetweenWalks)
		end
	end,
	TaskFollowNavMeshToCoord = function(self, ped, x, y, z, speed, timeout, stoppingRange, persistFollowing, unk)
		if NetworkHasControlOfEntity(ped) then
			ClearPedTasksImmediately(ped)
			TaskFollowNavMeshToCoord(ped, x, y, z, speed, timeout, stoppingRange, persistFollowing, unk)
		else
			RequestNetSync("TaskFollowNavMeshToCoord", ped, x, y, z, speed, timeout, stoppingRange, persistFollowing, unk)
		end
	end,
	TaskGoToCoordAnyMeans = function(self, ped, x, y, z, speed, p5, p6, walkingStyle, p8)
		if NetworkHasControlOfEntity(ped) then
			ClearPedTasksImmediately(ped)
			TaskGoToCoordAnyMeans(ped, x, y, z, speed, p5, p6, walkingStyle, p8)
		else
			RequestNetSync("TaskGoToCoordAnyMeans", ped, x, y, z, speed, p5, p6, walkingStyle, p8)
		end
	end,
	SetEntityAsNoLongerNeeded = function(self, ped)
		if NetworkHasControlOfEntity(ped) then
			SetEntityAsNoLongerNeeded(ped)
		else
			RequestNetSync("SetEntityAsNoLongerNeeded", ped)
		end
	end,
	SetPedKeepTask = function(self, ped, state)
		if NetworkHasControlOfEntity(ped) then
			SetPedKeepTask(ped, state)
		else
			RequestNetSync("SetPedKeepTask", ped, state)
		end
	end,
}
