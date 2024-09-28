local _POLYID = "salvage-yard"
local _joiner = nil
local _working = false
local _state = 0
local _inPoly = false
local _blip = nil
local _count = 0
local _nodes = nil

local eventHandlers = {}
local _models = {
	-273279397, 322493792, 1120812170, 591265130, -915224107, 10106915, -52638650, -896997473, -1748303324, 1434516869, 1069797899, 591265130, 1898296526, 2090224559, -1366478936, -273279397, 322493792
}

function SalvCleanup()

end

AddEventHandler("Labor:Client:Setup", function()
	Polyzone.Create:Poly(_POLYID, {
		vector2(2403.0769042969, 3160.6232910156),
		vector2(2435.3303222656, 3160.5451660156),
		vector2(2435.2749023438, 3026.3818359375),
		vector2(2328.7590332031, 3025.9470214844),
		vector2(2328.7644042969, 3059.189453125),
		vector2(2328.6860351562, 3068.1652832031),
		vector2(2329.3513183594, 3079.5327148438),
		vector2(2348.4104003906, 3079.7502441406),
		vector2(2364.2434082031, 3085.9904785156),
		vector2(2372.0126953125, 3093.2883300781),
		vector2(2379.1826171875, 3104.9187011719),
		vector2(2387.0463867188, 3126.4077148438)
	}, {
		name="scrap",
		--debugPoly=true,
		--minZ = 50.28173828125,
		--maxZ = 51.348690032959
	})

	PedInteraction:Add("SalvagingJob", `s_m_y_construct_02`, vector3(2369.771, 3157.132, 47.209), 10.633, 25.0, {
		{
			icon = "helmet-safety",
			text = "Start Work",
			event = "Salvaging:Client:StartJob",
			tempjob = "Salvaging",
			isEnabled = function()
				return not _working
			end,
		},
		{
			icon = "ballot-check",
			text = "I've Finished",
			event = "Salvaging:Client:TriggerDelivery",
			tempjob = "Salvaging",
			isEnabled = function()
				return _working and _state == 2
			end,
		},
		--[[{
			icon = "box-open-full",
			text = "Here For My Pickup",
			event = "Laptop:Client:LSUnderground:Chopping:Pickup",
			isEnabled = function()
				return LocalPlayer.state.Character:GetData("ChopPickups") ~= nil and #LocalPlayer.state.Character:GetData("ChopPickups") > 0
			end,
		},
		{
			icon = "list-timeline",
			text = "View Current Requests",
			event = "Laptop:Client:LSUnderground:Chopping:GetPublicList",
			rep = { id = "Salvaging", level = 3 },
		},]]
	}, 'car-crash')
end)

RegisterNetEvent("Salvaging:Client:OnDuty", function(joiner, time)
	_joiner = joiner
	DeleteWaypoint()
	SetNewWaypoint(2369.771, 3157.132)

	eventHandlers["startup"] = RegisterNetEvent(string.format("Salvaging:Client:%s:Startup", joiner), function()
		_state = 1
		_working = true
		_count = 0
		_nodes = {}

		eventHandlers["enter-poly"] = AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
			if id ~= _POLYID or _count >= 15 then return end

			for k, v in ipairs(_models) do
				Targeting:RemoveObject(v)
				Targeting:AddObject(v, "car", {
					{
						icon = "engine",
						text = "Scrap",
						event = "Salvaging:Client:ScrapCar",
						tempjob = "Salvaging",
						data = {},
						isEnabled = function(s, s2)
							return (_working and _inPoly and (_nodes ~= nil and not _nodes[NetworkGetNetworkIdFromEntity(s2.entity)]))
						end,
					}
				}, 3.0)
			end

			_inPoly = true
		end)

		eventHandlers["enter-exit"] = AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
			if id ~= _POLYID then return end
			_inPoly = false
			for k, v in ipairs(_models) do
				Targeting:RemoveObject(v)
			end
		end)

		_blip = AddBlipForArea(2385.561, 3057.702, 48.153, 140.0, 80.0)
		SetBlipColour(_blip, 79)

		if not _inPoly and Polyzone:IsCoordsInZone(GetEntityCoords(LocalPlayer.state.ped, false, _POLYID, true)) and _count < 15 then
			for k, v in ipairs(_models) do
				Targeting:RemoveObject(v)
				Targeting:AddObject(v, "car", {
					{
						icon = "engine",
						text = "Scrap",
						event = "Salvaging:Client:ScrapCar",
						tempjob = "Salvaging",
						data = {},
						isEnabled = function(s, s2)
							return (_working and _inPoly and (_nodes ~= nil and not _nodes[NetworkGetNetworkIdFromEntity(s2.entity)]))
						end,
					}
				}, 3.0)
			end

			_inPoly = true
		end
	end)

	eventHandlers["update-state"] = RegisterNetEvent(string.format("Salvaging:Client:%s:EndScrapping", joiner), function()
		_state = 2
		if _blip ~= nil then
			RemoveBlip(_blip)
		end
	
		for k, v in ipairs(_models) do
			Targeting:RemoveObject(v)
		end
	end)

	eventHandlers["delivery"] = RegisterNetEvent(string.format("Salvaging:Client:%s:StartDelivery", joiner), function(point)
		_state = 3
		DeleteWaypoint()
		SetNewWaypoint(point.coords.x, point.coords.y)

		_blip = Blips:Add("SalvDelivery", "Deliver Goods", point.coords, 478, 2, 1.4)

		PedInteraction:Add("SalvagingDelivery", `mp_m_waremech_01`, point.coords, point.heading, 25.0, {
			{
				icon = "box-circle-check",
				text = "Deliver Goods",
				event = "Salvaging:Client:EndDelivery",
				tempjob = "Salvaging",
				isEnabled = function()
					return _working and _state == 3
				end,
			},
		}, 'box-circle-check')
	end)

	eventHandlers["actions"] = RegisterNetEvent(string.format("Salvaging:Client:%s:Action", joiner), function(netid)
		if _nodes then
			_nodes[netid] = true
		end
		_count = _count + 1
		if _count >= 15 then
			for k, v in ipairs(_models) do
				Targeting:RemoveObject(v)
			end

			if _blip ~= nil then
				RemoveBlip(_blip)
				Blips:Remove("SalvDelivery")
			end
		end
	end)
end)

AddEventHandler("Salvaging:Client:ScrapCar", function(s, s2)
	Progress:Progress({
		name = 'salvaging_action',
		duration = (math.random(15) + 25) * 1000,
		label = "Scrapping Car",
		useWhileDead = false,
		canCancel = true,
		vehicle = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableCombat = true,
		},
		animation = {
			animDict = "mini@repair",
			anim = "fixing_a_ped",
			flags = 49,
		}
	}, function(cancelled)
		if not cancelled then
			Callbacks:ServerCallback('Salvaging:SalvageCar', NetworkGetNetworkIdFromEntity(s.entity))
		end
	end)
end)

AddEventHandler("Salvaging:Client:TriggerDelivery", function()
    Callbacks:ServerCallback('Salvaging:TriggerDelivery', _joiner)
end)

AddEventHandler("Salvaging:Client:EndDelivery", function()
    Callbacks:ServerCallback('Salvaging:EndDelivery', _joiner)
	PedInteraction:Remove("SalvagingDelivery")
end)

AddEventHandler("Salvaging:Client:StartJob", function()
    Callbacks:ServerCallback('Salvaging:StartJob', _joiner, function(state)
		if not state then
			Notification:Error("Unable To Start Job")
		end
    end)
end)

RegisterNetEvent("Salvaging:Client:OffDuty", function(time)
	for k, v in pairs(eventHandlers) do
		RemoveEventHandler(v)
	end

	if _blip ~= nil then
		RemoveBlip(_blip)
		Blips:Remove("SalvDelivery")
	end

	for k, v in ipairs(_models) do
		Targeting:RemoveObject(v)
	end

	PedInteraction:Remove("SalvagingDelivery")

	eventHandlers = {}
	_joiner = nil
	_working = false
	_nodes = nil
end)