local changeHandler = nil
RegisterNetEvent("Characters:Client:Spawn", function()
	changeHandler = AddStateBagChangeHandler(
		"isBlindfolded",
		string.format("player:%s", GetPlayerServerId(LocalPlayer.state.PlayerID)),
		function(bagName, key, value, _unused, replicated)
            if value then
                SetupBlindfold()
            else
                RemoveBlindfold()
            end
		end
	)

	if LocalPlayer.state.isBlindfolded then
		SetupBlindfold()
	end
end)

RegisterNetEvent("Characters:Client:Logout", function()
	if changeHandler ~= nil then
		RemoveStateBagChangeHandler(changeHandler)
		changeHandler = nil
	end

	RemoveBlindfold()
end)

AddEventHandler("HUD:Client:RemoveBlindfold", function(entity, data)
    Callbacks:ServerCallback("HUD:RemoveBlindfold", entity.serverId, function(s)

    end)
end)

local blindfoldObject = nil
function SetupBlindfold()
	local ped = PlayerPedId()
	local model = GetHashKey("prop_head_bag")

	if not IsModelValid(model) then
		return
	end

	RequestModel(model)

	while not HasModelLoaded(model) do
		Wait(0)
	end

	local coords = GetEntityCoords(ped)

	blindfoldObject = CreateObjectNoOffset(model, coords, true, false, false)

	while not DoesEntityExist(blindfoldObject) do
		Citizen.Wait(0)
	end

	SendNUIMessage({
		type = "SET_BLINDFOLD",
		data = {
			state = true,
		},
	})

	SetModelAsNoLongerNeeded(model)
	boneid = GetPedBoneIndex(ped, 12844)
	AttachEntityToEntity(
		blindfoldObject,
		ped,
		boneid,
		-0.01,
		0.045,
		1.9081958235745e-16,
		223.0,
		-94.0,
		-52.0,
		1,
		1,
		0,
		1,
		0,
		1
	)
	SetFollowPedCamViewMode(4)

	Citizen.CreateThread(function()
		while blindfoldObject ~= nil do
			SetEntityLocallyInvisible(blindfoldObject)
			DisableControlAction(0, 0, true)
			Citizen.Wait(1)
		end
	end)
end

function RemoveBlindfold()
	if blindfoldObject ~= nil then
		DeleteObject(blindfoldObject)
		blindfoldObject = nil
	end

	SendNUIMessage({
		type = "SET_BLINDFOLD",
		data = {
			state = false,
		},
	})
end
