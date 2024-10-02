local changeHandler = nil
RegisterNetEvent("Characters:Client:Spawn", function()
	changeHandler = AddStateBagChangeHandler(
		"isBlindfolded",
		string.format("player:%s", LocalPlayer.state.serverID),
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
    if type(entity) == "table" and entity.serverId then
        Callbacks:ServerCallback("HUD:RemoveBlindfold", entity.serverId, function(s)
        end)
	end
end)

local blindfoldObject = nil
function SetupBlindfold()
	local ped = PlayerPedId()
	local model = GetHashKey("prop_money_bag_01")

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
		Wait(0)
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
		0.2,
		0.04,
		0.0,
		0.0,
		270.0,
		60.0,
		1,
		1,
		0,
		1,
		1,
		1
	)
	SetFollowPedCamViewMode(4)

	CreateThread(function()
		while blindfoldObject ~= nil do
			SetEntityLocallyInvisible(blindfoldObject)
			DisableControlAction(0, 0, true)
			Wait(1)
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
