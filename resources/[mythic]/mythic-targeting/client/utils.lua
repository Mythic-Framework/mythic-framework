-- See https://forum.cfx.re/t/get-camera-coordinates/183555/14 because I was not about to deal with the maths myself

local getGameplayCamCoord = GetGameplayCamCoord
local getGameplayCamRot = GetGameplayCamRot
local getShapeTestResultIncludingMaterial = GetShapeTestResultIncludingMaterial
local startExpensiveSynchronousShapeTestLosProbe = StartExpensiveSynchronousShapeTestLosProbe

---@param rotation vector3|vector4|table
---@return table
local function rotationToDirection(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}

	local direction = {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function GetEntityPlayerIsLookingAt(distance, ignored, flagOverride)
	local cameraRotation = getGameplayCamRot(0)
	local cameraCoord = getGameplayCamCoord()
	local direction = rotationToDirection(cameraRotation)
	local destination = {
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}

	local _, hit, hitcoords, _, _, entity = getShapeTestResultIncludingMaterial(startExpensiveSynchronousShapeTestLosProbe(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, flagOverride or 27, ignored or LocalPlayer.state.ped, 0.2))
	return hit == 1, hitcoords, entity
end

---@param t table
---@return table
function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

---@param ent number
---@return vector3
local function trunkOffset(ent)
	local entityModel = GetEntityModel(ent)
	local min, _ = GetModelDimensions(entityModel)
	return GetOffsetFromEntityInWorldCoords(ent, 0.0, min.y - 0.5, 0.0)
end

---@param ent number
---@param dist number
---@param open boolean
---@return boolean
function IsNearTrunk(ent, dist, open)
	return #(trunkOffset(ent) - GetEntityCoords(LocalPlayer.state.ped)) <= (dist or 1.0)
		and GetVehicleDoorLockStatus(ent) == 1
		and (not open or GetVehicleDoorAngleRatio(ent, 5) >= 0.1)
end
