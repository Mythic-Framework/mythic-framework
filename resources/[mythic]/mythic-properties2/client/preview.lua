local createdCamera = 0
_previewingInteriorData = {}
_previewingInterior = nil
_previewingInteriorCam = 1
_previewingInteriorSwitching = false

function StartPreview(int)
    if _previewingInterior then
        return false
    end

    if not _insideInterior then
        Notification:Error("Must be Inside Your Property to Preview Interiors", 8000)
        return false
    end

    local intData = PropertyInteriors[int]
    if intData and intData.cameras then
        _previewingInteriorData = intData
        _previewingInterior = intData.cameras
        _previewingInteriorCam = 1
        _previewingInteriorSwitching = true

        Phone:Close(true)

        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Wait(0)
        end

        Wait(200)

        SetFocusArea(intData.locations.front.coords.x, intData.locations.front.coords.y, intData.locations.front.coords.z, 0.0, 0.0, 0.0)
        SetupGTACamera(_previewingInterior[_previewingInteriorCam].coords, _previewingInterior[_previewingInteriorCam].rotation)
        DoScreenFadeIn(250)
        CameraLoop()

        InfoOverlay:Show(_previewingInteriorData?.info?.name or "Unknown", _previewingInterior[_previewingInteriorCam].name)

        _previewingInteriorSwitching = false
        return true
    else
        Notification:Error("Cannot Preview Interior")
    end
    return false
end

function EndPreview()
    DoScreenFadeOut(250)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    CleanupGTACamera()
    DoScreenFadeIn(250)

    _previewingInterior = nil
    InfoOverlay:Close()
end

function PrevPreview()
    if _previewingInteriorCam > 1 then
        _previewingInteriorSwitching = true
        _previewingInteriorCam -= 1

        InfoOverlay:Close()

        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Wait(0)
        end

        Wait(200)

        SetupGTACamera(_previewingInterior[_previewingInteriorCam].coords, _previewingInterior[_previewingInteriorCam].rotation)

        DoScreenFadeIn(250)
        CameraLoop()

        InfoOverlay:Show(_previewingInteriorData?.info?.name or "Unknown", _previewingInterior[_previewingInteriorCam].name)

        _previewingInteriorSwitching = false
    end
end

function NextPreview()
    if _previewingInteriorCam < #_previewingInterior then
        _previewingInteriorSwitching = true
        _previewingInteriorCam += 1

        InfoOverlay:Close()

        DoScreenFadeOut(250)
        while not IsScreenFadedOut() do
            Wait(0)
        end

        Wait(200)

        SetupGTACamera(_previewingInterior[_previewingInteriorCam].coords, _previewingInterior[_previewingInteriorCam].rotation)

        DoScreenFadeIn(250)
        CameraLoop()

        InfoOverlay:Show(_previewingInteriorData?.info?.name or "Unknown", _previewingInterior[_previewingInteriorCam].name)

        _previewingInteriorSwitching = false
    end
end

function SetupGTACamera(c, r)
	if createdCamera ~= 0 then
		DestroyCam(createdCamera, 0)
		createdCamera = 0
	end
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(cam, c.x, c.y, c.z)
	SetCamRot(cam, r.x, r.y, r.z, 2)
	RenderScriptCams(1, 0, 0, 1, 1)
	Wait(250)
	createdCamera = cam
end

function CleanupGTACamera()
	DestroyCam(createdCamera, 0)
	RenderScriptCams(0, 0, 1, 1, 1)
	createdCamera = 0
	ClearTimecycleModifier(currentTimecycle)
	SetFocusEntity(LocalPlayer.state.ped)
end

function InstructionScaleform(scaleform, isGroup, isOnline, canRot)
	if createdCamera ~= 0 then
		local scaleform = RequestScaleformMovie(scaleform)
		while not HasScaleformMovieLoaded(scaleform) do
			Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
		PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(3)
        InstructionButton(GetControlInstructionalButton(0, GetHashKey('+furniture_prev') | 0x80000000, 1))
        InstructionButtonMessage("Prev.")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(2)
        InstructionButton(GetControlInstructionalButton(0, GetHashKey('+furniture_next') | 0x80000000, 1))
        InstructionButtonMessage("Next")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(1)
        InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cancel_action') | 0x80000000, 1))
        InstructionButtonMessage("Leave")
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

function InstructionButton(ControlButton)
	N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

function CameraLoop()
    CreateThread(function()
        while createdCamera ~= 0 do
            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            DisableControlAction(0, 22, true) -- INPUT_JUMP
            DisableControlAction(0, 30, true) -- disable left/right
            DisableControlAction(0, 31, true) -- disable forward/back
            DisableControlAction(0, 36, true) -- INPUT_DUCK
            DisableControlAction(0, 21, true) -- disable sprint
            DisableControlAction(0, 44, true) -- disable cover
            DisableControlAction(0, 63, true) -- veh turn left
            DisableControlAction(0, 64, true) -- veh turn right
            DisableControlAction(0, 71, true) -- veh forward
            DisableControlAction(0, 72, true) -- veh backwards
            DisableControlAction(0, 75, true) -- disable exit vehicle
            DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(1, 37, true) -- disable weapon select
            DisableControlAction(0, 47, true) -- disable weapon
            DisableControlAction(0, 58, true) -- disable weapon
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            Wait(1)
        end
    end)

    CreateThread(function()
        while createdCamera ~= 0 do
            local instructions = InstructionScaleform("instructional_buttons", isGroup, isOnline, canRot)
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            Wait(1)
        end
    end)
end

AddEventHandler("Keybinds:Client:KeyDown:cancel_action", function()
	if _previewingInterior then
        EndPreview()
	end
end)

AddEventHandler("Ped:Client:Died", function()
	if _previewingInterior then
        EndPreview()
	end
end)