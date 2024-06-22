function CameraLoop()
    local currId = LocalPlayer.state.inCCTVCam?.camKey
    local isGroup = GlobalState[currId]?.group ~= nil
    local isOnline = GlobalState[currId].isOnline
    local canRot = GlobalState[currId].canRotate

    local handler = AddStateBagChangeHandler(
		LocalPlayer.state.inCCTVCam,
        nil,
		function(bagName, key, value, _unused, replicated)
            isOnline = value.isOnline
            canRot = value.canRotate
		end
	)

    CreateThread(function()
        while createdCamera ~= 0 and currId == LocalPlayer.state.inCCTVCam?.camKey do
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
        while createdCamera ~= 0 and currId == LocalPlayer.state.inCCTVCam?.camKey do
            local instructions = InstructionScaleform("instructional_buttons", isGroup, isOnline, canRot)
            DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
            SetTimecycleModifierStrength(1.0)
    
            ---------------------------------------------------------------------------
            -- CAMERA ROTATION CONTROLS
            ---------------------------------------------------------------------------
            if canRot and isOnline then
                local getCameraRot = GetCamRot(createdCamera, 2)
    
                local rotX = getCameraRot.x or 0.0
                local rotZ = getCameraRot.z or 0.0

                local change = false
                -- ROTATE UP
                if camMoveUp then
                    if rotX <= 0.0 then
                        change = true
                        rotX += 0.7
                    end
                end
    
                -- ROTATE DOWN
                if camMoveDown then
                    if rotX >= -50.0 then
                        change = true
                        rotX -= 0.7
                    end
                end
    
                -- ROTATE LEFT
                if camMoveLeft then
                    change = true
                    rotZ += 0.7
                end
    
                -- ROTATE RIGHT
                if camMoveRight then
                    change = true
                    rotZ -= 0.7
                end

                if change then
                    SetCamRot(createdCamera, rotX, 0.0, rotZ, 2)
                end
            end
    
            Wait(1)
        end
		RemoveStateBagChangeHandler(handler)
    end)
end

function SetupGTACamera(x, y, z, r)
	if createdCamera ~= 0 then
		DestroyCam(createdCamera, 0)
		createdCamera = 0
	end
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(cam, x, y, z)
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

function EnterCam(camId)
	local camKey = string.format("CCTV:Camera:%s", camId)

	if GlobalState[camKey] ~= nil and not GlobalState['Sync:Blackout'] then
		LocalPlayer.state:set("inCCTVCam", {
            camKey = camKey,
            camId = camId,
        }, true)
		
		globalCamera = camId
		DoScreenFadeOut(250)
		while not IsScreenFadedOut() do
			Wait(0)
		end

		if GlobalState[camKey].isOnline then
			if GlobalState[camKey].quality == "brown" then
				currentTimecycle = "phone_cam6"
			elseif GlobalState[camKey].quality == "medium" then
				currentTimecycle = "CAMERA_BW"
			elseif GlobalState[camKey].quality == "low" then
				currentTimecycle = "CAMERA_secuirity"
			elseif GlobalState[camKey].quality == "blackandwhite" then
				currentTimecycle = "phone_cam2"
			elseif GlobalState[camKey].quality == "blurred" then
				currentTimecycle = "helicamfirst"
			elseif GlobalState[camKey].quality == "nightvision" then
				currentTimecycle = "MP_heli_cam"
			elseif GlobalState[camKey].quality == "offline" then
				currentTimecycle = "Broken_camera_fuzz"
			else
				currentTimecycle = "Broken_camera_fuzz"
			end

			SetTimecycleModifier(currentTimecycle)
			offline = false
			Wait(200)
		else
			currentTimecycle = "Broken_camera_fuzz"
			SetTimecycleModifier(currentTimecycle)
			offline = true
			Wait(200)
		end
		canrotate = GlobalState[camKey].canRotate
		local firstCamx = GlobalState[camKey].x
		local firstCamy = GlobalState[camKey].y
		local firstCamz = GlobalState[camKey].z
		local firstCamr = GlobalState[camKey].r
		SetFocusArea(firstCamx, firstCamy, firstCamz, firstCamx, firstCamy, firstCamz)
		SetupGTACamera(firstCamx, firstCamy, firstCamz, firstCamr)
		currentCameraIndex = a
		currentCameraIndexIndex = 1
		DoScreenFadeIn(250)
        CameraLoop()
	end
end

function ExitCam()
	globalCamera = cameraId
	DoScreenFadeOut(250)
    
    LocalPlayer.state:set("inCCTVCam", false, true)

	while not IsScreenFadedOut() do
		Wait(0)
	end
	CleanupGTACamera()

	DoScreenFadeIn(250)
	inCamera = false
end

function InstructionScaleform(scaleform, isGroup, isOnline, canRot)
	if createdCamera ~= 0 then
		local scaleform = RequestScaleformMovie(scaleform)
		while not HasScaleformMovieLoaded(scaleform) do
			Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
		PopScaleformMovieFunctionVoid()

		if isGroup then
			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            if canRot and not offline then
                PushScaleformMovieFunctionParameterInt(4)
            else
                PushScaleformMovieFunctionParameterInt(2)
            end
			InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cctv_next') | 0x80000000, 1))
			InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cctv_previous') | 0x80000000, 1))
			InstructionButtonMessage(Config.CameraSwitchText)
			PopScaleformMovieFunctionVoid()
		end

		if canRot and not offline then
			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(3)
			InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cctv_down') | 0x80000000, 1))
			InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cctv_up') | 0x80000000, 1))
			InstructionButtonMessage(Config.CameraUpDownText)
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(2)
			InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cctv_right') | 0x80000000, 1))
			InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cctv_left') | 0x80000000, 1))
			InstructionButtonMessage(Config.CameraRightLeftText)
			PopScaleformMovieFunctionVoid()
		end
        
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(1)
        InstructionButton(GetControlInstructionalButton(0, GetHashKey('+cctv_disconnect') | 0x80000000, 1))
        InstructionButtonMessage(Config.CameraDisconnectText)
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
