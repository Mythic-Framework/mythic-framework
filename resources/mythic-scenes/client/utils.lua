function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function rotationToDirection(rotation)
	local adjustedRotation = (math.pi / 180) * rotation

	local direction = vector3(
		-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		math.sin(adjustedRotation.x)
	)

	return direction
end

function GetEntityPlayerIsLookingAt(distance, ignored, flagOverride)
	local cameraRotation = GetGameplayCamRot(2)
	local originCoords = GetGameplayCamCoord()
	local direction = rotationToDirection(cameraRotation)
	local destinationCoords = originCoords + (direction * distance)

    local castedRay = StartShapeTestSweptSphere(originCoords, destinationCoords, 0.075, flagOverride or 287, ignored, 4)
	local _, hitting, endCoords, surfaceNormal, entity = GetShapeTestResult(castedRay)
	return (hitting == 1), endCoords, entity
end

function HandleLongString(s)
    for i = 100, string.len(s), 99 do
        local part = string.sub(s, i, i + 99)
        AddTextComponentString(part)
    end
end