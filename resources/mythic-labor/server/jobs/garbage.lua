local _JOB = "Garbage"

local _joiners = {}
local _Garbage = {}

local _highClassLoot = {
	"ironbar",
	"heavy_glue",
}

local _lootTable = {
	"scrapmetal",
	"rubber",
	"plastic",
	"copperwire",
	"glue",
	"electronic_parts",
}

local _GarbageRoutes = {
	{
		id = 1,
		coords = vector3(274.442, -84.17, 70.120),
		location = "Vinewood",
		radius = 550,
		count = 0,
		truckRental = false,
		garEntity = nil,
	},
	{
		id = 2,
		coords = vector3(-626.002, -935.058, 22.284),
		location = "Little Seoul",
		radius = 550,
		count = 0,
		truckRental = false,
		garEntity = nil,
	},
	{
		id = 3,
		coords = vector3(97.330, -844.267, 30.948),
		location = "Downtown",
		radius = 550,
		count = 0,
		truckRental = false,
		garEntity = nil,
	},
	{
		id = 4,
		coords = vector3(-1099.901, -1328.459, 5.238),
		location = "Vespucci",
		radius = 550,
		count = 0,
		truckRental = false,
		garEntity = nil,
	},
	{
		id = 5,
		coords = vector3(146.379, -1619.73, 29.33),
		location = "South Los Santos",
		radius = 550,
		count = 0,
		truckRental = false,
		garEntity = nil,
	},
	{
		id = 6,
		coords = vector3(-766.331, -281.512, 53.999),
		location = "RockFord Hills",
		radius = 550,
		count = 0,
		truckRental = false,
		garEntity = nil,
	},
	{
		id = 7,
		coords = vector3(1815.581, 3697.691, 33.997),
		location = "SandyShores",
		radius = 1050,
		count = 0,
		truckRental = false,
		garEntity = nil,
	},
}

local _jewelryPrices = {
	[1] = 20,
	[2] = 30,
	[3] = 50,
	[4] = 60,
	[5] = 80,
	[6] = 100,
}

local _jewelryItems = {
	{ item = 'rolex', ratio = 0.5 },
	{ item = 'watch', ratio = 0.5 },
	{ item = 'chain', ratio = 0.5 },
	{ item = 'earrings', ratio = 0.5 },
	{ item = 'ring', ratio = 0.5 },
	{ item = 'goldcoins', ratio = 0.5 },
}

local _pawnItems = {
	{ item = "sequencer", coin = "PLEB", price = 20, qty = 1 },
}

AddEventHandler("Labor:Server:Startup", function()
	Callbacks:RegisterServerCallback("Garbage:StartJob", function(source, data, cb)
		if _Garbage[data] ~= nil and _Garbage[data].state == 0 then
			_Garbage[data].state = 1
			Labor.Offers:Task(_joiners[source], _JOB, "Grab a garbage truck")
			TriggerClientEvent(string.format("Garbage:Client:%s:Startup", data), -1)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Garbage:GarbageSpawn", function(source, data, cb)
		if _joiners[source] ~= nil and _Garbage[_joiners[source]].truck == nil and _Garbage[_joiners[source]].state == 1 then
			Vehicles:SpawnTemp(source, `trash2`, vector3(-334.989, -1562.966, 25.230), 57.510, function(veh, VIN)
				Vehicles.Keys:Add(source, VIN)
				_Garbage[_joiners[source]].truck = veh
				local availRoutes = {}
				for k, v in ipairs(_GarbageRoutes) do
					table.insert(availRoutes, k)
				end
				local randRoute = math.random(#availRoutes)
				_Garbage[_joiners[source]].route = deepcopy(_GarbageRoutes[availRoutes[randRoute]])
				table.remove(availRoutes, randRoute)
				_Garbage[_joiners[source]].routes = availRoutes
				_Garbage[_joiners[source]].state = 2
				TriggerClientEvent(string.format("Garbage:Client:%s:NewRoute", _joiners[source]), -1, _Garbage[_joiners[source]].route)
				Labor.Offers:Start(
					_joiners[source],
					_JOB,
					string.format("Collect Garbage In %s", _Garbage[_joiners[source]].route["location"]),
					15
				)

				cb(veh)
			end)
		end
	end)

	Callbacks:RegisterServerCallback("Garbage:GarbageSpawnRemove", function(source, data, cb)
		if _joiners[source] ~= nil and _Garbage[_joiners[source]].truck ~= nil then
			if _Garbage[_joiners[source]].state == 3 then
				local garCoords = GetEntityCoords(_Garbage[_joiners[source]].truck)
				local pedCoords = GetEntityCoords(GetPlayerPed(source))
				local distance = #(pedCoords - garCoords)
				if distance <= 25 then
					Vehicles:Delete(_Garbage[_joiners[source]].truck, function()
						_Garbage[_joiners[source]].truck = nil
						_Garbage[_joiners[source]].state = 4
						TriggerClientEvent(string.format("Garbage:Client:%s:ReturnTruck", _joiners[source]), -1)
						Labor.Offers:Task(_joiners[source], _JOB, "Speak with the Sanitation Foreman")
					end)
				else
					Execute:Client(source, "Notification", "Error", "Truck Needs To Be With You")
				end
			end
		end
	end)

	Callbacks:RegisterServerCallback("Garbage:TrashGrab", function(source, data, cb)
		if _joiners[source] ~= nil then
			Callbacks:ClientCallback(source, "Garbage:DoingSomeAction", "grabTrash")
			TriggerClientEvent(string.format("Garbage:Client:%s:Action", _joiners[source]), -1, data)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Garbage:TrashPutIn", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _Garbage[_joiners[source]] ~= nil then
			local luck = math.random(100)
			if luck >= 80 then
				Loot:CustomSet(_highClassLoot, char:GetData("SID"), 1, math.random(60, 150))
			elseif luck >= 50 then
				Loot:CustomSet(_lootTable, char:GetData("SID"), 1, math.random(60, 150))
			end
			Inventory:AddItem(char:GetData("SID"), "recycledgoods", math.random(10), {}, 1)

			Callbacks:ClientCallback(source, "Garbage:DoingSomeAction", "trashPutIn")
			if Labor.Offers:Update(_joiners[source], _JOB, 1, true) then
				if _Garbage[_joiners[source]].tasks < 3 then
					_Garbage[_joiners[source]].tasks = _Garbage[_joiners[source]].tasks + 1
					local randRoute = math.random(#_Garbage[_joiners[source]].routes)
					_Garbage[_joiners[source]].route = deepcopy(_GarbageRoutes[_Garbage[_joiners[source]].routes[randRoute]])
					table.remove(_Garbage[_joiners[source]].routes, randRoute)
					Labor.Offers:Start(
						_joiners[source],
						_JOB,
						string.format("Collect Garbage In %s", _Garbage[_joiners[source]].route.location),
						15
					)
					TriggerClientEvent(string.format("Garbage:Client:%s:NewRoute", _joiners[source]), -1, _Garbage[_joiners[source]].route)
				else
					_Garbage[_joiners[source]].state = 3
					TriggerClientEvent(string.format("Garbage:Client:%s:EndRoutes", _joiners[source]), -1)
					Labor.Offers:Task(_joiners[source], _JOB, "Return your truck")
				end
			end
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Garbage:TurnIn", function(source, data, cb)
		if _joiners[source] ~= nil and _Garbage[_joiners[source]].tasks >= 3 then
			local char = Fetch:Source(source):GetData("Character")
			if char:GetData("TempJob") == _JOB then
				Labor.Offers:ManualFinish(_joiners[source], _JOB)
				cb(true)
			else
				Execute:Client(source, "Notification", "Error", "Unable To Finish Job")
				cb(false)
			end
		else
			Execute:Client(source, "Notification", "Error", "You've Not Completed All Routes")
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Garbage:Pawn:Sell", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local repLvl = Reputation:GetLevel(source, _JOB)

		if repLvl > 0 then
			local money = 0
			for k, v in ipairs(_jewelryItems) do
				local count = Inventory.Items:GetCount(char:GetData("SID"), 1, v.item) or 0
				if (count) > 0 then
					if Inventory.Items:Remove(char:GetData("SID"), 1, v.item, count) then
						money = money + math.floor(_jewelryPrices[repLvl] * v.ratio) * count
					end
				end
			end
	
			if money > 0 then
				Wallet:Modify(source, money)
			else
				Execute:Client(source, "Notification", "Error", "You Have Nothing To Sell")
			end
		else
			Execute:Client(source, "Notification", "Error", "You're Not Trusted Enough To Do This Yet")
		end
	end)

	-- Callbacks:RegisterServerCallback("Gabage:Pawn:Buy", function(source, data, cb)
	-- 	local char = Fetch:Source(source):GetData("Character")
	-- 	local repLvl = Reputation:GetLevel(source, _JOB)

	-- 	if repLvl >= 3 then
	-- 		cb(_pawnItems)
	-- 	else
	-- 		Execute:Client(source, "Notification", "Error", "You're Not Trusted Enough To Do This Yet")
	-- 	end
	-- end)

	-- Callbacks:RegisterServerCallback("Garbage:Pawn:BuyLimited", function(source, data, cb)
	-- 	local char = Fetch:Source(source):GetData("Character")
	-- 	local repLvl = Reputation:GetLevel(source, _JOB)

	-- 	if repLvl >= 3 then
	-- 		if _pawnItems[data.index] and _pawnItems[data.index].qty > 0 then
	-- 			if Crypto.Exchange:Remove(_pawnItems[data.index].coin, char:GetData("SID"), _pawnItems[data.index].price) then
	-- 				_pawnItems[data.index].qty = _pawnItems[data.index].qty - 1
					
	-- 				Phone.Notification:Add(
	-- 					source,
	-- 					"Crypto Purchase",
	-- 					string.format("You Paid %s $%s", _pawnItems[data.index].price, _pawnItems[data.index].coin),
	-- 					os.time() * 1000,
	-- 					6000,
	-- 					"crypto",
	-- 					{}
	-- 				)

	-- 				cb(Inventory:AddItem(char:GetData("SID"), _pawnItems[data.index].item, 1, {}, 1))
	-- 			else
	-- 				Execute:Client(source, "Notification", "Error", "Not Enough Crypto")
	-- 			end
	-- 		else
	-- 			Execute:Client(source, "Notification", "Error", "Item Not In Stock")
	-- 		end
	-- 	else
	-- 		Execute:Client(source, "Notification", "Error", "You're Not Trusted Enough To Do This Yet")
	-- 	end
	-- end)
end)

AddEventHandler("Garbage:Server:OnDuty", function(joiner, members, isWorkgroup)
	_joiners[joiner] = joiner
	_Garbage[joiner] = {
		joiner = joiner,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		state = 0,
		tasks = 0,
	}

	local char = Fetch:Source(joiner):GetData("Character")
	char:SetData("TempJob", _JOB)
	Phone.Notification:Add(joiner, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
	TriggerClientEvent("Garbage:Client:OnDuty", joiner, joiner, os.time())

	Labor.Offers:Task(joiner, _JOB, "Speak with the Sanitation Foreman")
	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:Source(v.ID):GetData("Character")
			member:SetData("TempJob", _JOB)
			Phone.Notification:Add(v.ID, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
			TriggerClientEvent("Garbage:Client:OnDuty", v.ID, joiner, os.time())
		end
	end
end)

AddEventHandler("Garbage:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Garbage:Client:OffDuty", source)
end)

AddEventHandler("Garbage:Server:FinishJob", function(joiner)
	_Garbage[joiner] = nil
end)
