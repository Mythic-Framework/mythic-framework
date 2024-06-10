function rotationToDirection(rotation)
	local adjustedRotation = (math.pi / 180) * rotation

	local direction = vector3(
		-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		math.sin(adjustedRotation.x)
	)

	return direction
end

function draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.25, 0.25)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)
    SetTextOutline(true)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

function IsCoordsInWater(coords)
    local inWater, waterHeight = TestVerticalProbeAgainstAllWater(coords.x, coords.y, coords.z, 0, 1.0)
    return inWater
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