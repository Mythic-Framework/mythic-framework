local _joiner = nil
local _working = false
local _blips = {}
local eventHandlers = {}

local _nodes = nil

local _sellers = {
	{
		coords = vector3(-619.496, -225.697, 37.057),
		heading = 130.523,
		model = `a_f_y_clubcust_02`,
	},
	{
		coords = vector3(232.280, 373.679, 105.142),
		heading = 162.529,
		model = `csb_popov`,
	},
}

AddEventHandler("Labor:Client:Setup", function()
	-- for k, v in ipairs(_sellers) do
	-- 	PedInteraction:Add(string.format("GemSeller%s", k), v.model, v.coords, v.heading, 25.0, {
	-- 		{
	-- 			icon = "sack-dollar",
	-- 			text = "Sell Diamonds",
	-- 			event = "Mining:Client:SellGem",
	-- 			data = "diamond",
	-- 			item = "diamond",
	-- 			rep = { id = "Mining", level = 5 },
	-- 		},
	-- 		{
	-- 			icon = "sack-dollar",
	-- 			text = "Sell Emeralds",
	-- 			event = "Mining:Client:SellGem",
	-- 			data = "emerald",
	-- 			item = "emerald",
	-- 			rep = { id = "Mining", level = 5 },
	-- 		},
	-- 		{
	-- 			icon = "sack-dollar",
	-- 			text = "Sell Sapphire",
	-- 			event = "Mining:Client:SellGem",
	-- 			data = "sapphire",
	-- 			item = "sapphire",
	-- 			rep = { id = "Mining", level = 4 },
	-- 		},
	-- 		{
	-- 			icon = "sack-dollar",
	-- 			text = "Sell Ruby",
	-- 			event = "Mining:Client:SellGem",
	-- 			data = "ruby",
	-- 			item = "ruby",
	-- 			rep = { id = "Mining", level = 3 },
	-- 		},
	-- 		{
	-- 			icon = "sack-dollar",
	-- 			text = "Sell Amethyst",
	-- 			event = "Mining:Client:SellGem",
	-- 			data = "amethyst",
	-- 			item = "amethyst",
	-- 			rep = { id = "Mining", level = 2 },
	-- 		},
	-- 		{
	-- 			icon = "sack-dollar",
	-- 			text = "Sell Citrine",
	-- 			event = "Mining:Client:SellGem",
	-- 			data = "citrine",
	-- 			item = "citrine",
	-- 			rep = { id = "Mining", level = 1 },
	-- 		},
	-- 		{
	-- 			icon = "sack-dollar",
	-- 			text = "Sell Opal",
	-- 			event = "Mining:Client:SellGem",
	-- 			data = "opal",
	-- 			item = "opal",
	-- 			rep = { id = "Mining", level = 1 },
	-- 		},
	-- 	}, 'gem')
	-- end

	PedInteraction:Add("MiningJob", `s_m_y_construct_02`, vector3(2741.874, 2791.691, 34.214), 155.045, 25.0, {
		{
			icon = "face-surprise",
			text = "Sell Crushed Stone ($3/per)",
			event = "Mining:Client:SellStone",
		},
		{
			icon = "helmet-safety",
			text = "Start Work",
			event = "Mining:Client:StartJob",
			tempjob = "Mining",
			isEnabled = function()
				return not _working
			end,
		},
		{
			icon = "dollar-sign",
			text = "Buy Pickaxe ($250)",
			event = "Mining:Client:PuchaseAxe",
			tempjob = "Mining",
		},
		{
			icon = "handshake-angle",
			text = "Turn In Ore",
			event = "Mining:Client:TurnIn",
			tempjob = "Mining",
			isEnabled = function()
				return _working
			end,
		},
	}, 'helmet-safety')

	Callbacks:RegisterClientCallback("Mining:DoTheThingBrother", function(item, cb)
		Progress:Progress({
			name = 'mining_action',
			duration = math.random(13, 35) * 1000,
			label = "Mining",
			useWhileDead = false,
			canCancel = true,
			vehicle = false,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			},
			animation = {
				animDict = "melee@large_wpn@streamed_core",
				anim = "ground_attack_on_spot",
				flags = 49,
			},
			prop = {
				model = "prop_tool_pickaxe",
				bone = 57005,
				coords = { x = 0.08, y = -0.18, z = -0.02 },
				rotation = { x = 80.0, y = 0.00, z = 180.0 },
			},
		}, function(cancelled)
			cb(not cancelled)
		end)
	end)
end)

RegisterNetEvent("Mining:Client:OnDuty", function(joiner, time)
	_joiner = joiner
	DeleteWaypoint()
	SetNewWaypoint(2741.874, 2791.691)

	eventHandlers["startup"] = RegisterNetEvent(string.format("Mining:Client:%s:Startup", joiner), function(nodes)
		if _nodes ~= nil then return end
		_working = true
		_nodes = nodes

		for k, v in pairs(_nodes) do
            Blips:Add(string.format("MiningNode-%s", v.id), "Mining Node", v.coords, 594, 0, 0.8)
		end

		CreateThread(function()
			while _working do
				local closest = nil
				for k, v in pairs(_nodes) do
					local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - v.coords)
					if closest == nil or dist < closest.dist then
						closest = {
							dist = dist,
							point = v,
						}
					end
				end

				if closest ~= nil then
					if closest.dist <= 20 then
						DrawMarker(1, closest.point.coords.x, closest.point.coords.y, closest.point.coords.z - 0.98, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 1.0, 112, 209, 244, 250, false, false, 2, false, false, false, false)
						Wait(5)
					else
						Wait(closest.dist * 100)
					end
				else
					Wait(1000)
				end
			end
		end)
	end)

	eventHandlers["actions"] = RegisterNetEvent(string.format("Mining:Client:%s:Action", joiner), function(data)
		for k, v in pairs(_nodes) do
			if v.id == data then
				Blips:Remove(string.format("MiningNode-%s", v.id))
				_nodes[k] = nil
				break
			end
		end
	end)
end)

AddEventHandler("Mining:Client:SellStone", function()
    Callbacks:ServerCallback('Mining:SellStone', {})
end)

AddEventHandler("Mining:Client:PuchaseAxe", function()
    Callbacks:ServerCallback('Mining:PurchasePickaxe', {})
end)

AddEventHandler("Mining:Client:TurnIn", function()
    Callbacks:ServerCallback('Mining:TurnIn', _joiner)
end)

-- AddEventHandler("Mining:Client:SellGem", function(entity, data)
-- 	Callbacks:ServerCallback("Mining:SellGem", data)
-- end)

AddEventHandler("Mining:Client:StartJob", function()
    Callbacks:ServerCallback('Mining:StartJob', _joiner, function(state)
		if not state then
			Notification:Error("Unable To Start Job")
		end
    end)
end)

RegisterNetEvent("Mining:Client:OffDuty", function(time)
	for k, v in pairs(eventHandlers) do
		RemoveEventHandler(v)
	end

	if _nodes ~= nil then
		for k, v in pairs(_nodes) do
			Blips:Remove(string.format("MiningNode-%s", v.id))
		end
	end

	eventHandlers = {}
	_joiner = nil
	_working = false
	_nodes = nil
end)