local fov_max = 80.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 3.0 -- camera zoom speed
local speed_lr = 4.0 -- speed by which the camera pans left-right 
local speed_ud = 4.0 -- speed by which the camera pans up-down

local fov = (fov_max + fov_min) * 0.5

local heliCamera = false
local cam = false
local inHeli = false
local vehicle_detected = false
local locked_on_vehicle = nil

local camHelis = {
	[`polmav`] = true,
	[`as350`] = true,
	[`emsheli`] = true,
}

function StartHeliCamera()
    if heliCamera then
        heliCamera = false
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        return
    end

    inHeli = GetVehiclePedIsIn(LocalPlayer.state.ped, false)

	if inHeli and camHelis[GetEntityModel(inHeli)] and IsHeliHighEnough(inHeli) and GetPedInVehicleSeat(inHeli, 0) == LocalPlayer.state.ped and not LocalPlayer.state.isDead then
		heliCamera = true

		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)

		SetTimecycleModifier("heliGunCam")
		SetTimecycleModifierStrength(0.3)
		local scaleform = RequestScaleformMovie("HELI_CAM")
		while not HasScaleformMovieLoaded(scaleform) do
			Wait(0)
		end

		cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
		AttachCamToEntity(cam, inHeli, 0.0, 0.0, -1.5, true)
		SetCamRot(cam, 0.0, 0.0, GetEntityHeading(inHeli))
		SetCamFov(cam, fov)
		RenderScriptCams(true, false, 0, 1, 0)
		PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
		PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
		PopScaleformMovieFunctionVoid()

		CreateThread(function()
			while heliCamera do
				Wait(2000)

				if locked_on_vehicle then
					if not DoesEntityExist(locked_on_vehicle) or not HasEntityClearLosToEntity(inHeli, locked_on_vehicle, 4294967295) or #(GetEntityCoords(LocalPlayer.state.ped) - GetEntityCoords(locked_on_vehicle)) > 300.0 then
						LockOnHeliCamera(true)
					end
				end

				if GetVehiclePedIsIn(LocalPlayer.state.ped) ~= inHeli or not IsHeliHighEnough(inHeli) or LocalPlayer.state.isDead or GetPedInVehicleSeat(inHeli, 0) ~= LocalPlayer.state.ped then
					heliCamera = false
				end
			end
		end)
	
		CreateThread(function()
			while heliCamera and LocalPlayer.state.loggedIn do
				Wait(5)

				if locked_on_vehicle then
					if DoesEntityExist(locked_on_vehicle) then
						PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
						RenderVehicleInfo(locked_on_vehicle)
					end
				else
					local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov-fov_min)
					CheckInputRotation(cam, zoomvalue)
					vehicle_detected = GetVehicleInView(cam)
					if DoesEntityExist(vehicle_detected) then
						RenderVehicleInfo(vehicle_detected)
					end
				end

				HandleZoom(cam)
				PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
				PushScaleformMovieFunctionParameterFloat(GetEntityCoords(inHeli).z)
				PushScaleformMovieFunctionParameterFloat(zoomvalue)
				PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
				PopScaleformMovieFunctionVoid()
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				--Wait(0)
			end

			heliCamera = false
			locked_on_vehicle = false

			ClearTimecycleModifier()
			fov = (fov_max + fov_min) * 0.5 -- reset to starting zoom level
			RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
			SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
			DestroyCam(cam, false)
			SetNightvision(false)
		end)
	end
end

function LockOnHeliCamera(forceOff)
	if locked_on_vehicle or forceOff then 
		locked_on_vehicle = nil
		target_vehicle = nil

		local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
		local fov = GetCamFov(cam)
		local old_cam = cam
		DestroyCam(old_cam, false)
		cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
		AttachCamToEntity(cam, inHeli, 0.0, 0.0, -1.5, true)
		SetCamRot(cam, rot, 2)
		SetCamFov(cam, fov)
		RenderScriptCams(true, false, 0, 1, 0)

		return
	end

	if heliCamera and vehicle_detected then
		locked_on_vehicle = vehicle_detected
	end
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end

function ChangeVision()
	if heliCamera then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
		if GetUsingnightvision() then
			SetNightvision(false)
		else
			SetNightvision(true)
		end
	end
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomvalue + 0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0, 241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0, 242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov - current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov) * 0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle = CastRayPointToPoint(coords, coords + (forward_vector * 200.0), 10, GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit > 0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	if DoesEntityExist(vehicle) then
		local vehSpeed = GetEntitySpeed(vehicle) * 2.236936

		SetTextFont(0)
		SetTextProportional(1)
		SetTextScale(0.0, 0.55)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(string.format("Target Speed: %s MPH", math.ceil(vehSpeed)))
		DrawText(0.65, 0.92)
	end
end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end