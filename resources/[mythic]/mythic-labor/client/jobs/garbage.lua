local _joiner = nil
local _working = false
local _blips = {}
local _blip = nil
local _state = 0
local eventHandlers = {}
local _entities = {}
local _route = nil
local location = nil


local trashBins = {
	`prop_bin_01a`,
	`zprop_bin_01a_old`,
	`prop_bin_02a`,
	`prop_bin_03a`,
	`prop_bin_04a`,
	`prop_bin_05a`,
	`prop_bin_06a`,
	`prop_bin_07a`,
	`prop_bin_08a`,
	`prop_bin_08open`,
	`prop_bin_09a`,
	`prop_bin_10a`,
	`prop_bin_11a`,
	`prop_bin_12a`,
	`prop_bin_13a`,
	`prop_bin_14a`,
	`prop_bin_07b`,
	`prop_bin_10b`,
	`prop_bin_11b`,
	`prop_bin_14b`,
	`prop_bin_07c`,
	`prop_bin_beach_01a`,
	`prop_bin_beach_01d`,
	`prop_bin_delpiero`,
	`prop_bin_delpiero_b`,
	`prop_rub_binbag_sd_01`,
	`prop_rub_binbag_sd_02`,
	`prop_rub_binbag_01`,
	`prop_rub_binbag_01b`,
	`prop_rub_binbag_03`,
	`prop_rub_binbag_03b`,
	`prop_rub_binbag_04`,
	`prop_rub_binbag_05`,
	`prop_rub_binbag_06`,
	`prop_rub_binbag_08`,
	`prop_dumpster_01a`,
	`prop_dumpster_02a`,
	`prop_dumpster_02b`,
	`prop_dumpster_3a`,
	`prop_dumpster_4a`,
	`prop_dumpster_4b`,
	1143473856, -- Plebmasters doesn't have an object with this id but its very much a garbage can?
}

loadAnimDict = function(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Wait(10)
	end
end
AddEventHandler("Labor:Client:Setup", function()
	PedInteraction:Add("GarbageJob", GetHashKey("s_m_y_garbage"), vector3(-348.940, -1570.224, 24.228), 340.561, 25.0, {
		{
			icon = "trash",
			text = "Start Work",
			event = "Garbage:Client:StartJob",
			tempjob = "Garbage",
			isEnabled = function()
				return not _working
			end,
		},
		{
			icon = "handshake-angle",
			text = "Borrow Garbage Truck",
			event = "Garbage:Client:GarbageSpawn",
			tempjob = "Garbage",
			isEnabled = function()
				return _working and _state == 1
			end,
		},
		{
			icon = "handshake-angle",
			text = "Return Garbage Truck",
			event = "Garbage:Client:GarbageSpawnRemove",
			tempjob = "Garbage",
			isEnabled = function()
				return _working and _state == 3
			end,
		},
		{
			icon = "handshake-angle",
			text = "Complete Job",
			event = "Garbage:Client:TurnIn",
			tempjob = "Garbage",
			isEnabled = function()
				return _working and _state == 4
			end,
		},
	}, "trash")

	Callbacks:RegisterClientCallback("Garbage:DoingSomeAction", function(item, cb)
		local ped = PlayerPedId()
		if item == "grabTrash" then
			loadAnimDict("missfbi4prepp1")
			TaskPlayAnim(ped, "missfbi4prepp1", "_bag_walk_garbage_man", 6.0, -6.0, -1, 49, 0, 0, 0, 0)
			GarbageObject = CreateObject(GetHashKey("prop_cs_rub_binbag_01"), 0, 0, 0, true, true, true)
			AttachEntityToEntity(
				GarbageObject,
				ped,
				GetPedBoneIndex(ped, 57005),
				0.12,
				0.0,
				-0.05,
				220.0,
				120.0,
				0.0,
				true,
				true,
				false,
				true,
				1,
				true
			)
		else
			if item == "trashPutIn" then
				loadAnimDict("missfbi4prepp1")
				TaskPlayAnim(ped, "missfbi4prepp1", "_bag_throw_garbage_man", 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
				SetEntityHeading(ped, GetEntityHeading(GarbageVehicle))

				SetTimeout(1250, function()
					DetachEntity(GarbageObject, 1, false)
					DeleteObject(GarbageObject)
					TaskPlayAnim(ped, "missfbi4prepp1", "exit", 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
					GarbageObject = nil
				end)
			end
		end
	end)
end)

RegisterNetEvent("Garbage:Client:OnDuty", function(joiner, time)
	_joiner = joiner
	DeleteWaypoint()
	SetNewWaypoint(-348.940, -1570.224)

	_blip = Blips:Add("GarbageStart", "Sanitation Foreman", { x = -348.940, y = -1570.224, z = 0 }, 480, 2, 1.4)

	eventHandlers["startup"] = RegisterNetEvent(string.format("Garbage:Client:%s:Startup", joiner), function()
		_working = true
		_state = 1
		for k, v in ipairs(trashBins) do
			Targeting:AddObject(v, "trash", {
				{
					icon = "trash",
					text = "Grab Trash",
					event = "Garbage:Client:TrashGrab",
					data = "Garbage",
					isEnabled = function(data, entity)
						return not _entities[ObjToNet(entity.entity)] and LocalPlayer.state.inGarbagbeZone and GarbageObject == nil
					end,
				},
			}, 3.0)
		end

		CreateThread(function()
			while _working do
				if _route ~= nil then
					local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(_route.coords.x, _route.coords.y, _route.coords.z))
					if dist <= (_route.radius / 2) then
						LocalPlayer.state.inGarbagbeZone = true
					else
						LocalPlayer.state.inGarbagbeZone = false
					end
				end
				Wait(1000)
			end
		end)
	end)

	eventHandlers["new-route"] = RegisterNetEvent(string.format("Garbage:Client:%s:NewRoute", joiner), function(r)
		_state = 2
		_route = r
		DeleteWaypoint()
		SetNewWaypoint(_route.coords)

		if _blip ~= nil then
			Blips:Remove("GarbageStart")
			RemoveBlip(_blip)
			_blip = nil
		end
		_blip = AddBlipForRadius(_route.coords.x, _route.coords.y, _route.coords.maxZ, (_route.radius / 2) + 0.0)
		SetBlipColour(_blip, 3)
		SetBlipAlpha(_blip, 90)
	end)

	eventHandlers["actions"] = RegisterNetEvent(string.format("Garbage:Client:%s:Action", joiner), function(netId)
		_entities[netId] = true
	end)

	eventHandlers["end-pickup"] = RegisterNetEvent(string.format("Garbage:Client:%s:EndRoutes", joiner), function()
		DeleteWaypoint()
		SetNewWaypoint(-334.989, -1562.966)
		if _blip ~= nil then
			Blips:Remove("GarbageStart")
			RemoveBlip(_blip)
			_blip = nil
		end
		_blip = Blips:Add("GarbageStart", "Sanitation Foreman", { x = -348.940, y = -1570.224, z = 0 }, 480, 2, 1.4)
		_state = 3
	end)

	eventHandlers["gabrage-grab"] = AddEventHandler("Garbage:Client:TrashGrab", function(entity, data)
		if GarbageObject ~= nil then
			DetachEntity(GarbageObject, 1, false)
			DeleteObject(GarbageObject)
			GarbageObject = nil
		end
		
		Callbacks:ServerCallback("Garbage:TrashGrab", ObjToNet(entity.entity), function(s)
			if s then
				LocalPlayer.state.carryingGarbabge = true
			end
		end)
	end)

	eventHandlers["toss-gabrage"] = AddEventHandler("Garbage:Client:TossBag", function()
		Callbacks:ServerCallback("Garbage:TrashPutIn", {}, function(s)
			if s then
				LocalPlayer.state.carryingGarbabge = false
			end
		end)
	end)

	eventHandlers["spawn-truck"] = AddEventHandler("Garbage:Client:GarbageSpawn", function()
		Callbacks:ServerCallback("Garbage:GarbageSpawn", {}, function(netId)
			SetEntityAsMissionEntity(NetToVeh(netId))
		end)
	end)

	eventHandlers["despawn-truck"] = AddEventHandler("Garbage:Client:GarbageSpawnRemove", function()
		Callbacks:ServerCallback("Garbage:GarbageSpawnRemove", {})
	end)

	eventHandlers["return-truck"] = RegisterNetEvent(string.format("Garbage:Client:%s:ReturnTruck", joiner), function()
		_state = 4
	end)

	eventHandlers["turn-in"] = AddEventHandler("Garbage:Client:TurnIn", function()
		Callbacks:ServerCallback("Garbage:TurnIn", _joiner)
	end)
end)

AddEventHandler("Garbage:Client:StartJob", function()
	Callbacks:ServerCallback("Garbage:StartJob", _joiner, function(state)
		if not state then
			Notification:Error("Unable To Start Job")
		end
	end)
end)

AddEventHandler("Garbage:Client:Buy", function()
	Callbacks:ServerCallback("Gabage:Pawn:Buy", {}, function(items)
		local itemList = {}

		for k, v in ipairs(items) do
			local itemData = Inventory.Items:GetData(v.item)
			if v.qty > 0 then
				table.insert(itemList, {
					label = itemData.label,
					description = string.format("%s $%s", v.price, v.coin),
					event = "Garbage:Client:Pawn:BuyLimited",
					data = {
						index = k,
						item = v.item,
					}
				})
			else
				table.insert(itemList, {
					label = itemData.label,
					description = "Sold Out",
				})
			end
		end

		ListMenu:Show({
			main = {
				label = "Pawn Shop",
				items = itemList,
			},
		})
	end)
end)

AddEventHandler("Garbage:Client:Pawn:BuyLimited", function(data)
	Callbacks:ServerCallback("Garbage:Pawn:BuyLimited", data)
end)

RegisterNetEvent("Garbage:Client:OffDuty", function(time)
	for k, v in pairs(eventHandlers) do
		RemoveEventHandler(v)
	end

	for k, v in ipairs(trashBins) do
		Targeting:RemoveObject(v)
	end

	if _blip ~= nil then
		Blips:Remove("GarbageStart")
		RemoveBlip(_blip)
		_blip = nil
	end

	if LocalPlayer.state.carryingGarbabge or GarbageObject ~= nil then
		DetachEntity(GarbageObject, 1, false)
		DeleteObject(GarbageObject)
		LocalPlayer.state.carryingGarbabge = false
	end

	eventHandlers = {}
	_joiner = nil
	_working = false
	_route = nil
	GarbageObject = nil
	_state = 0
	LocalPlayer.state.inGarbagbeZone = false
end)
