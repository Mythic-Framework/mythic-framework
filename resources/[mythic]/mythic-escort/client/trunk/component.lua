local customOffsets = {
    [`taxi`] = { y = 0.0, z = -0.5 },
    [`buccaneer`] = { y = 0.5, z = 0.0 },
    [`peyote`] = { y = 0.35, z = -0.15 },
    [`regina`] = { y = 0.2, z = -0.35 },
    [`pigalle`] = { y = 0.2, z = -0.15 },
    [`glendale`] = { y = 0.0, z = -0.35 },
}

local _inTrunkVeh = nil

AddEventHandler("Trunk:Shared:DependencyUpdate", TrunkComponents)
function TrunkComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Escort = exports["mythic-base"]:FetchComponent("Escort")
	Trunk = exports["mythic-base"]:FetchComponent("Trunk")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Trunk", {
		"Callbacks",
		"Logger",
		"Notification",
        "Action",
        "Escort",
		"Trunk",
	}, function(error)
		if #error > 0 then
			return
		end
		TrunkComponents()

		Callbacks:RegisterClientCallback("Trunk:GetPutIn", function(data, cb)
			InTrunk(NetToVeh(data))
		end)

		Callbacks:RegisterClientCallback("Trunk:GetPulledOut", function(data, cb)
            if LocalPlayer.state.inTrunk then
				Trunk:GetOut()

                while LocalPlayer.state.inTrunk do
                    Citizen.Wait(5)
                end

                cb(true)
            else
                cb(false)
            end
		end)
	end)
end)

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
    if LocalPlayer.state.inTrunk and (not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed) then
        Trunk:GetOut()
    end
end)

AddEventHandler("Keybinds:Client:KeyUp:secondary_action", function()
    if LocalPlayer.state.inTrunk and (not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed) then
        Trunk:ToggleTrunk()
    end
end)

function loadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
end

local cam = nil
function MountTrunkCam()
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamRot(cam, 0.0, 0.0, 0.0)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 0, true, true)
		SetCamCoord(cam, LocalPlayer.state.myPos)
	end
	AttachCamToEntity(cam, LocalPlayer.state.ped, 0.0, -2.5, 1.0, true)
	SetCamRot(cam, -30.0, 0.0, GetEntityHeading(LocalPlayer.state.ped))
end

function UnmountTrunkCam()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(cam, false)
    cam = nil
end

function InTrunk(veh)
	if not DoesVehicleHaveDoor(veh, 6) and DoesVehicleHaveDoor(veh, 5) and IsThisModelACar(GetEntityModel(veh)) then
		DoScreenFadeOut(200)
        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        
		local min, max = GetModelDimensions(GetEntityModel(veh))
		local trunkZ = max.z
		if trunkZ > 1.4 then
			trunkZ = 1.4 - (max.z - 1.4)
		end

		_inTrunkVeh = veh
        --Entity(veh).state.VIN
		LocalPlayer.state:set("inTrunk", true)
        TriggerServerEvent("Trunk:Server:Enter", VehToNet(veh))

        while not LocalPlayer.state.inTrunk do
            Citizen.Wait(5)
        end

		local animDict = "mp_common_miss"
		local anim = "dead_ped_idle"

		loadAnimDict(animDict)

		DetachEntity(LocalPlayer.state.ped)
		SetPedKeepTask(LocalPlayer.state.ped, true)
		ClearPedTasks(LocalPlayer.state.ped)
		TaskPlayAnim(LocalPlayer.state.ped, animDict, anim, 8.0, 8.0, -1, 2, 999.0, 0, 0, 0)

		local vehicleName = GetEntityModel(veh)
		local trunkOffsets = customOffsets[vehicleName] or { y = 0.0, z = 0.0 }

		AttachEntityToEntity(
			LocalPlayer.state.ped,
			veh,
			0,
			-0.1,
			(min.y + 0.85) + trunkOffsets.y,
			(trunkZ - 0.87) + trunkOffsets.z,
			0,
			0,
			40.0,
			1,
			1,
			1,
			1,
			1,
			1
		)

        SetVehicleDoorsShut(veh, 5, true, false)
        MountTrunkCam()

		DoScreenFadeIn(1000)
        while not IsScreenFadedIn() do
            Citizen.Wait(10)
        end
		
        if not LocalPlayer.state.isCuffed and not LocalPlayer.state.isDead then
            Action:Show('{keybind}primary_action{/keybind} Exit Trunk | {keybind}secondary_action{/keybind} Open/Close Trunk')
        end

        while LocalPlayer.state.loggedIn and LocalPlayer.state.inTrunk and veh == _inTrunkVeh do
			MountTrunkCam()

			if not DoesEntityExist(veh) then
				Trunk:GetOut()
			end

			if not IsEntityPlayingAnim(LocalPlayer.state.ped, animDict, anim, 3) then
				TaskPlayAnim(LocalPlayer.state.ped, animDict, anim, 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end
            Citizen.Wait(1)
		end

		if veh == _inTrunkVeh then
			DoScreenFadeOut(200)
			while not IsScreenFadedOut() do
				Citizen.Wait(10)
			end

			Action:Hide()
			SetVehicleDoorOpen(_inTrunkVeh, 5, 1, 1)
			UnmountTrunkCam()
			DetachEntity(LocalPlayer.state.ped)
			if DoesEntityExist(veh) then
				local exit = GetOffsetFromEntityInWorldCoords(veh, 0.0, min.y - 0.5, 0.0)
				SetEntityCoords(LocalPlayer.state.ped, exit.x, exit.y, exit.z)
			else
				SetEntityCoords(LocalPlayer.state.ped, GetEntityCoords(LocalPlayer.state.ped))
			end
	
			_inTrunkVeh = nil
			DoScreenFadeIn(1000)
			while not IsScreenFadedIn() do
				Citizen.Wait(10)
			end
		end
	end
end

_TRUNK = {
	GetIn = function(self, veh)
		InTrunk(veh)
	end,
	GetOut = function(self)
        TriggerServerEvent("Trunk:Server:Exit", VehToNet(_inTrunkVeh))
	end,
	ToggleTrunk = function(self)
		if GetVehicleDoorAngleRatio(_inTrunkVeh, 5) > 0.0 then
            --SetVehicleDoorsShut(_inTrunkVeh, 5, true, false)
			Vehicles.Sync.Doors:Shut(_inTrunkVeh, 5, true)
		else
			--SetVehicleDoorOpen(_inTrunkVeh, 5, true, true)
			Vehicles.Sync.Doors:Open(_inTrunkVeh, 5, false, false)
		end
	end,
}

RegisterNetEvent("Trunk:Client:Exit", function()
    LocalPlayer.state:set("inTrunk", false)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Trunk", _TRUNK)
end)

AddEventHandler("Trunk:Client:GetIn", function(entity, data)
	InTrunk(entity.entity)
end)

AddEventHandler("Ped:Client:Died", function()
    if LocalPlayer.state.inTrunk then
        Trunk:GetOut()
    end
end)

AddEventHandler("Trunk:Client:PutIn", function(entity, data)
	Callbacks:ServerCallback("Trunk:PutIn", NetworkGetNetworkIdFromEntity(entity.entity), function(state) end)
end)

AddEventHandler("Trunk:Client:PullOut", function(entity, data)
	Callbacks:ServerCallback("Trunk:PullOut", NetworkGetNetworkIdFromEntity(entity.entity), function(state) end)
end)