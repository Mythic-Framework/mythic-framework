function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function PlaceCast()
    local distance = 100.0
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}

	local a, hit, hitcoords, _, material, entity = GetShapeTestResultIncludingMaterial(StartExpensiveSynchronousShapeTestLosProbe(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, LocalPlayer.state.ped, 0))
	return hit , hitcoords, material, entity
end

function InstructionButton(ControlButton)
	N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

function InstructionScaleform(scaleform, showFurnitureButtons, offsetMode)
	if createdCamera ~= 0 then
		local scaleform = RequestScaleformMovie(scaleform)
		while not HasScaleformMovieLoaded(scaleform) do
			Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
		PopScaleformMovieFunctionVoid()

        if offsetMode then
            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(9)
            InstructionButton(GetControlInstructionalButton(0, 45, 1))
            InstructionButtonMessage("Up")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(8)
            InstructionButton(GetControlInstructionalButton(0, 23, 1))
            InstructionButtonMessage("Down")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(7)
            InstructionButton(GetControlInstructionalButton(0, 32, 1))
            InstructionButtonMessage("Forward")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(6)
            InstructionButton(GetControlInstructionalButton(0, 33, 1))
            InstructionButtonMessage("Back")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(5)
            InstructionButton(GetControlInstructionalButton(0, 34, 1))
            InstructionButtonMessage("Left")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(4)
            InstructionButton(GetControlInstructionalButton(0, 35, 1))
            InstructionButtonMessage("Right")
            PopScaleformMovieFunctionVoid()
        elseif showFurnitureButtons then
            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(6)
            InstructionButton(GetControlInstructionalButton(0, 36, 1))
            InstructionButtonMessage("Toggle Offset Mode")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(5)
            InstructionButton(GetControlInstructionalButton(0, GetHashKey('+furniture_prev') | 0x80000000, 1))
            InstructionButtonMessage("Prev. Item")
            PopScaleformMovieFunctionVoid()

            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(4)
            InstructionButton(GetControlInstructionalButton(0, GetHashKey('+furniture_next') | 0x80000000, 1))
            InstructionButtonMessage("Next Item")
            PopScaleformMovieFunctionVoid()
        end

        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(3)
        InstructionButton(GetControlInstructionalButton(0, 21, 1))
        InstructionButtonMessage(showFurnitureButtons and "Slower" or "Slower Rotation")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(2)
        InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cancel_action') | 0x80000000, 1))
        InstructionButtonMessage(showFurnitureButtons and "Cancel" or "Cancel Placement")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(1)
        InstructionButton(GetControlInstructionalButton(0, GetHashKey('+primary_action') | 0x80000000, 1))
        InstructionButtonMessage(showFurnitureButtons and "Place" or "Place Object")
        PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(80)
		PopScaleformMovieFunctionVoid()

		return scaleform
	else
		return false
	end
end

function RunPlacementThread(model, canPlaceInside, showFurnitureButtons, stupidFlag)
    loadModel(model)

    local myPed = PlayerPedId()
    local myPos = GetOffsetFromEntityInWorldCoords(myPed, 0.0, 2.5, 0.0)

    local obj = CreateObject(model, myPos.x, myPos.y, myPos.z, false, true, false)
    DisableCamCollisionForEntity(obj)
    SetEntityCompletelyDisableCollision(obj, false, true)

    FreezeEntityPosition(obj, true)
    SetEntityAlpha(obj, 155, true)
    SetEntityDrawOutlineColor(255, 255, 255, 175)
    SetEntityDrawOutline(obj, true)

    local rotate = GetEntityHeading(myPed)

    local offset = {
        x = 0.0,
        y = 0.0,
        z = 0.0,
    }
    local offsetMode = false

    CreateThread(function()
        while _placeData ~= nil and _placing do
            if IsPedInAnyVehicle(myPed) then
                ObjectPlacer:Cancel()
            end

            local instructions = InstructionScaleform("instructional_buttons", showFurnitureButtons, offsetMode)
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)

            if IsControlPressed(1, 181) then
                local amount = IsControlPressed(1, 21) and 1.0 or 5.0
                if rotate >= 360.0 then
                    rotate = 0.0
                else
                    rotate += amount
                end
            elseif IsControlPressed(1, 180) then
                local amount = IsControlPressed(1, 21) and 1.0 or 5.0
                if rotate <= 0.0 then
                    rotate = 360.0
                else
                    rotate -= amount
                end
            elseif showFurnitureButtons and IsDisabledControlJustReleased(1, 36) then
                offsetMode = not offsetMode
                offset = {
                    x = 0.0,
                    y = 0.0,
                    z = 0.0,
                }
            end

            if offsetMode and showFurnitureButtons then
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true)
                DisableControlAction(0, 32, true)
                DisableControlAction(0, 33, true)
                DisableControlAction(0, 34, true)
                DisableControlAction(0, 35, true)
                DisableControlAction(0, 23, true)
                DisableControlAction(0, 44, true)
                DisableControlAction(0, 45, true)
                DisableControlAction(0, 140, true)

                if IsDisabledControlPressed(1, 45) then
                    offset.z += IsControlPressed(1, 21) and 0.005 or 0.025
                    if offset.z > 2.5 then
                        offset.z = 2.5
                    end
                elseif IsDisabledControlPressed(1, 23) then
                    offset.z -= IsControlPressed(1, 21) and 0.005 or 0.025
                    if offset.z < -2.5 then
                        offset.z = -2.5
                    end
                elseif IsDisabledControlPressed(1, 32) then
                    offset.y += IsControlPressed(1, 21) and 0.005 or 0.025
                    if offset.y > 2.5 then
                        offset.y = 2.5
                    end
                elseif IsDisabledControlPressed(1, 33) then
                    offset.y -= IsControlPressed(1, 21) and 0.005 or 0.025
                    if offset.y < -2.5 then
                        offset.y = -2.5
                    end
                elseif IsDisabledControlPressed(1, 35) then
                    offset.x += IsControlPressed(1, 21) and 0.005 or 0.025
                    if offset.x > 2.5 then
                        offset.x = 2.5
                    end
                elseif IsDisabledControlPressed(1, 34) then
                    offset.x -= IsControlPressed(1, 21) and 0.005 or 0.025
                    if offset.x < -2.5 then
                        offset.x = -2.5
                    end
                end
            end

            myPos = GetEntityCoords(myPed)
            local hit, coords, material, entity = PlaceCast()

            if hit then
                SetEntityCoords(obj, coords.x, coords.y, coords.z, 0, 0, 0, false)

                if stupidFlag then
                    PlaceObjectOnGroundProperly(obj)
                end

                if showFurnitureButtons then
                    coords = GetOffsetFromEntityInWorldCoords(obj, offset.x, offset.y, offset.z)
                    SetEntityCoords(obj, coords.x, coords.y, coords.z, 0, 0, 0, false)
                end

                SetEntityHeading(obj, rotate)
            end
            StopEntityFire(obj)
            isValid = hit and (not IsEntityAVehicle(entity) and not IsEntityAPed(entity)) and #(coords - myPos) <= 5.0 and (canPlaceInside or (GetInteriorFromEntity(myPed) == 0 and GetInteriorFromEntity(obj) == 0))

            if isValid then
                SetEntityDrawOutlineColor(0, 255, 0, 175)
                placementCoords = {
                    coords = coords,
                    rotation = rotate
                }
            else
                SetEntityDrawOutlineColor(255, 0, 0, 175)
                placementCoords = nil
            end

            Wait(1)
        end

        DeleteObject(obj)
    end)
end