local _JOB = "Mining"

local _joiners = {}
local _mining = {}

local _lootTable = {
	"crushedrock",
}

local _miningNodes = {
	{
		{ id = 1, coords = vector3(2938.144, 2772.396, 39.252), attempts = 0 },
		{ id = 2, coords = vector3(2952.930, 2769.443, 39.096), attempts = 0 },
		{ id = 3, coords = vector3(2928.800, 2789.580, 40.154), attempts = 0 },
		{ id = 4, coords = vector3(2922.429, 2798.988, 41.225), attempts = 0 },
		{ id = 5, coords = vector3(2977.805, 2790.959, 40.593), attempts = 0 },
		{ id = 6, coords = vector3(2987.681, 2813.613, 45.148), attempts = 0 },
		{ id = 7, coords = vector3(2978.518, 2828.737, 46.135), attempts = 0 },
		{ id = 8, coords = vector3(2970.544, 2845.862, 46.590), attempts = 0 },
		{ id = 9, coords = vector3(2998.696, 2758.649, 42.981), attempts = 0 },
		{ id = 10, coords = vector3(2991.046, 2750.637, 43.686), attempts = 0 },
		{ id = 11, coords = vector3(2977.352, 2741.483, 44.631), attempts = 0 },
		{ id = 12, coords = vector3(2941.840, 2741.984, 43.521), attempts = 0 },
		{ id = 13, coords = vector3(2929.043, 2759.290, 45.067), attempts = 0 },
		{ id = 14, coords = vector3(2911.868, 2778.041, 45.255), attempts = 0 },
		{ id = 15, coords = vector3(2907.100, 2788.490, 46.406), attempts = 0 },
	},
	{
		{ id = 1, coords = vector3(2659.231, 2905.037, 36.431), attempts = 0 },
		{ id = 2, coords = vector3(2648.106, 2906.361, 37.245), attempts = 0 },
		{ id = 3, coords = vector3(2643.043, 2911.251, 37.175), attempts = 0 },
		{ id = 4, coords = vector3(2645.326, 2916.472, 36.794), attempts = 0 },
		{ id = 5, coords = vector3(2668.878, 2936.764, 37.274), attempts = 0 },
		{ id = 6, coords = vector3(2675.047, 2935.462, 37.336), attempts = 0 },
		{ id = 7, coords = vector3(2718.989, 2939.137, 36.692), attempts = 0 },
		{ id = 8, coords = vector3(2725.688, 2937.714, 36.223), attempts = 0 },
		{ id = 9, coords = vector3(2731.663, 2933.119, 36.108), attempts = 0 },
		{ id = 10, coords = vector3(2740.036, 2928.666, 36.783), attempts = 0 },
		{ id = 11, coords = vector3(2746.769, 2944.376, 35.814), attempts = 0 },
		{ id = 12, coords = vector3(2757.438, 2939.536, 36.703), attempts = 0 },
		{ id = 13, coords = vector3(2761.567, 2937.006, 36.737), attempts = 0 },
		{ id = 14, coords = vector3(2784.216, 2919.008, 38.248), attempts = 0 },
		{ id = 15, coords = vector3(2795.665, 2900.989, 39.290), attempts = 0 },
	},
	{
		{ id = 1, coords = vector3(2926.581, 2922.312, 90.317), attempts = 0 },
		{ id = 2, coords = vector3(2934.832, 2930.792, 91.181), attempts = 0 },
		{ id = 3, coords = vector3(2945.168, 2944.622, 92.029), attempts = 0 },
		{ id = 4, coords = vector3(2947.963, 2951.895, 92.094), attempts = 0 },
		{ id = 5, coords = vector3(2960.703, 2967.157, 91.192), attempts = 0 },
		{ id = 6, coords = vector3(2969.028, 2977.197, 89.481), attempts = 0 },
		{ id = 7, coords = vector3(2972.374, 2983.273, 88.794), attempts = 0 },
		{ id = 8, coords = vector3(2978.499, 2992.683, 87.506), attempts = 0 },
		{ id = 9, coords = vector3(2983.067, 3006.238, 89.416), attempts = 0 },
		{ id = 10, coords = vector3(2989.504, 3018.260, 89.303), attempts = 0 },
		{ id = 11, coords = vector3(3000.554, 3031.342, 90.469), attempts = 0 },
		{ id = 12, coords = vector3(3013.113, 3038.370, 92.252), attempts = 0 },
		{ id = 13, coords = vector3(3045.072, 3034.309, 91.494), attempts = 0 },
		{ id = 14, coords = vector3(3059.861, 3018.096, 91.376), attempts = 0 },
		{ id = 15, coords = vector3(3073.169, 3008.398, 95.435), attempts = 0 },
	},
	{
		{ id = 1, coords = vector3(2983.771, 2959.722, 79.222), attempts = 0 },
		{ id = 2, coords = vector3(3000.422, 2970.566, 75.890), attempts = 0 },
		{ id = 3, coords = vector3(3008.430, 2982.145, 74.070), attempts = 0 },
		{ id = 4, coords = vector3(3018.553, 2994.703, 72.448), attempts = 0 },
		{ id = 5, coords = vector3(3027.995, 2996.917, 72.641), attempts = 0 },
		{ id = 6, coords = vector3(3041.438, 2979.969, 74.375), attempts = 0 },
		{ id = 7, coords = vector3(3048.038, 2960.285, 71.745), attempts = 0 },
		{ id = 8, coords = vector3(3048.168, 2937.676, 69.885), attempts = 0 },
		{ id = 9, coords = vector3(3046.663, 2928.586, 70.100), attempts = 0 },
		{ id = 10, coords = vector3(3044.607, 2912.102, 70.978), attempts = 0 },
		{ id = 11, coords = vector3(3027.494, 2887.198, 74.306), attempts = 0 },
		{ id = 12, coords = vector3(3022.946, 2869.014, 75.569), attempts = 0 },
		{ id = 13, coords = vector3(3009.044, 2869.983, 73.367), attempts = 0 },
		{ id = 14, coords = vector3(3026.088, 2850.535, 72.727), attempts = 0 },
		{ id = 15, coords = vector3(3041.110, 2822.618, 71.250), attempts = 0 },
	},
	{
		{ id = 1, coords = vector3(2985.130, 2707.875, 54.994), attempts = 0 },
		{ id = 2, coords = vector3(2982.273, 2699.220, 55.827), attempts = 0 },
		{ id = 3, coords = vector3(2968.980, 2693.589, 54.772), attempts = 0 },
		{ id = 4, coords = vector3(2957.219, 2692.233, 55.364), attempts = 0 },
		{ id = 5, coords = vector3(2935.035, 2711.480, 54.301), attempts = 0 },
		{ id = 6, coords = vector3(2916.866, 2741.743, 54.344), attempts = 0 },
		{ id = 7, coords = vector3(2905.849, 2757.351, 53.693), attempts = 0 },
		{ id = 8, coords = vector3(2899.150, 2764.472, 53.772), attempts = 0 },
		{ id = 9, coords = vector3(2884.477, 2796.901, 56.040), attempts = 0 },
		{ id = 10, coords = vector3(2874.509, 2772.755, 59.852), attempts = 0 },
		{ id = 11, coords = vector3(2889.584, 2750.469, 64.111), attempts = 0 },
		{ id = 12, coords = vector3(2895.904, 2743.068, 63.588), attempts = 0 },
		{ id = 13, coords = vector3(2908.053, 2730.871, 63.626), attempts = 0 },
		{ id = 14, coords = vector3(2917.821, 2710.271, 63.943), attempts = 0 },
		{ id = 15, coords = vector3(2924.810, 2703.965, 64.443), attempts = 0 },
	},
}

local _payoutCuts = {
	[1] = 0.5,
	[2] = 0.45,
	[3] = 0.4,
	[4] = 0.35,
	[5] = 0.3,
}

local _gems = {
	diamond = { level = 4 },
	emerald = { level = 5 },
	sapphire = { level = 3 },
	ruby = { level = 3 },
	amethyst = { level = 2 },
	citrine = { level = 2 },
	opal = { level = 1 },
}

AddEventHandler("Labor:Server:Startup", function()
	Middleware:Add("Characters:Logout", function(source)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				Inventory.Items:RemoveAll(char:GetData("SID"), 1, "unknown_ore")
			end
		end
	end)

	Middleware:Add("playerDropped", function(source)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				Inventory.Items:RemoveAll(char:GetData("SID"), 1, "unknown_ore")
			end
		end
	end)

	Inventory.Items:RegisterUse("pickaxe", "Mining", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _mining[_joiners[source]] ~= nil then
			local mypos = GetEntityCoords(GetPlayerPed(source))
			local lastId = nil
			local lastDist = nil
			if (_mining[_joiners[source]].nodes) then
				for k, v in pairs(_mining[_joiners[source]].nodes) do
					local dist = #(vector3(mypos.x, mypos.y, mypos.z) - v.coords)
					if (lastDist == nil) or (lastDist and dist < lastDist) then
						lastDist = dist
						lastId = k
					end
				end
			end

			if lastId and lastDist <= 1.0 then
				local node = _mining[_joiners[source]].nodes[lastId]

				if not node.inUse then
					node.inUse = true
					Callbacks:ClientCallback(source, "Mining:DoTheThingBrother", {}, function(successful)
						if successful and _mining[_joiners[source]].nodes[lastId] ~= nil then
							node.attempts = node.attempts + 1
							local luck = math.random(100)
							if luck >= 95 or node.attempts >= 3 then
								Inventory:AddItem(char:GetData("SID"), "unknown_ore", 1, {}, 1)
								TriggerClientEvent(
									string.format("Mining:Client:%s:Action", _joiners[source]),
									-1,
									node.id
								)
								--table.remove(_mining[_joiners[source]].nodes, lastId)
								_mining[_joiners[source]].nodes[lastId] = nil
								if luck >= 75 then
									Loot.Sets:Gem(char:GetData("SID"), 1)
								end
								Loot.Sets:Ore(char:GetData("SID"), 1, math.random(2, 6))
							else
								node.inUse = false
								Inventory:AddItem(char:GetData("SID"), "crushedrock", math.random(10), {}, 1)
							end
						elseif not successful then
							node.inUse = false
						end
					end)
				else
					Execute:Client(source, "Notification", "Error", "Node Already Being Mined")
				end
			else
				Execute:Client(source, "Notification", "Error", "Not Near Mining Node")
			end
		end
	end)

	Callbacks:RegisterServerCallback("Mining:PurchasePickaxe", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if Wallet:Modify(source, -250) then
			Inventory:AddItem(char:GetData("SID"), "pickaxe", 1, {}, 1)
		else
			Execute:Client(source, "Notification", "Error", "Not Enough Cash")
		end
	end)

	Callbacks:RegisterServerCallback("Mining:StartJob", function(source, data, cb)
		if _mining[data] ~= nil and _mining[data].state == 0 then
			_mining[data].nodes = deepcopy(_miningNodes[math.random(#_miningNodes)])
			Labor.Offers:Start(data, _JOB, "Collect & Hand In Unknown Ore", 15)
			TriggerClientEvent(string.format("Mining:Client:%s:Startup", data), -1, _mining[data].nodes)
			_mining[data].state = 1
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Mining:TurnIn", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char:GetData("TempJob") == _JOB and _joiners[source] ~= nil and _mining[_joiners[source]] ~= nil then
			local count = Inventory.Items:GetCount(char:GetData("SID"), 1, "unknown_ore")
			if (count or 0) > 0 then
				if Inventory.Items:RemoveAll(char:GetData("SID"), 1, "unknown_ore") then
					Labor.Offers:Update(_joiners[source], _JOB, count)
					cb(true)
				else
					Execute:Client(source, "Notification", "Error", "Unable To Remove Ore")
					cb(false)
				end
			else
				Execute:Client(source, "Notification", "Error", "You Have No Ore")
				cb(false)
			end
		else
			Execute:Client(source, "Notification", "Error", "Unable To Turn In Ore")
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Mining:SellStone", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local count = Inventory.Items:GetCount(char:GetData("SID"), 1, "crushedrock")
		if (count or 0) > 0 then
			if Inventory.Items:Remove(char:GetData("SID"), 1, "crushedrock", count) then
				Wallet:Modify(source, (3 * count))
				cb(true)
			else
				Execute:Client(source, "Notification", "Error", "Unable To Remove Crushed Rock")
				cb(false)
			end
		else
			Execute:Client(source, "Notification", "Error", "You Have No Crushed Rock")
			cb(false)
		end
	end)

	-- Callbacks:RegisterServerCallback("Mining:SellGem", function(source, data, cb)
	-- 	local char = Fetch:Source(source):GetData("Character")
	-- 	local repLvl = Reputation:GetLevel(source, _JOB)

	-- 	if _gems[data] ~= nil and _gems[data].level <= repLvl then
	-- 		local itemData = Inventory.Items:GetData(data)
	-- 		if itemData ~= nil then
	-- 			local count = Inventory.Items:GetCount(char:GetData("SID"), 1, data)

	-- 			if count > 0 then
	-- 				local totalPayout = 0
	-- 				for i = 1, count do
	-- 					local item = Inventory.Items:GetFirst(char:GetData("SID"), data, 1)
	-- 					local payout = itemData.price * ((item.MetaData.Quality / 100) - _payoutCuts[repLvl])
	-- 					if payout <= 0 then
	-- 						payout = 100
	-- 					end

	-- 					if Inventory.Items:Remove(char:GetData("SID"), 1, data, 1) then
	-- 						totalPayout = math.ceil(totalPayout + payout)
	-- 					end
	-- 				end

	-- 				Banking.Balance:Deposit(Banking.Accounts:GetPersonal(char:GetData("SID")).Account, totalPayout, {
	-- 					type = "deposit",
	-- 					title = "Gems Sale",
	-- 					description = string.format("Sold %s x%s", itemData.label, count),
	-- 					data = {
	-- 						gem = data,
	-- 						repLvl = repLvl,
	-- 					},
	-- 				})
	-- 				Execute:Client(
	-- 					source,
	-- 					"Notification",
	-- 					"Info",
	-- 					string.format("$%s Has Been Deposited Into Your Account", totalPayout)
	-- 				)
	-- 			else
	-- 				Execute:Client(
	-- 					source,
	-- 					"Notification",
	-- 					"Error",
	-- 					string.format("You Don't Have Any %s's", itemData.label)
	-- 				)
	-- 			end
	-- 		end
	-- 	end
	-- end)
end)

AddEventHandler("Mining:Server:OnDuty", function(joiner, members, isWorkgroup)
	_joiners[joiner] = joiner
	_mining[joiner] = {
		joiner = joiner,
		isWorkgroup = isWorkgroup,
		started = os.time(),
		state = 0,
	}

	local char = Fetch:Source(joiner):GetData("Character")
	char:SetData("TempJob", _JOB)
	Phone.Notification:Add(joiner, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
	TriggerClientEvent("Mining:Client:OnDuty", joiner, joiner, os.time())

	Labor.Offers:Task(joiner, _JOB, "Talk To The Foreman")
	if #members > 0 then
		for k, v in ipairs(members) do
			_joiners[v.ID] = joiner
			local member = Fetch:Source(v.ID):GetData("Character")
			member:SetData("TempJob", _JOB)
			Phone.Notification:Add(v.ID, "Labor Activity", "You started a job", os.time() * 1000, 6000, "labor", {})
			TriggerClientEvent("Mining:Client:OnDuty", v.ID, joiner, os.time())
		end
	end
end)

AddEventHandler("Mining:Server:OffDuty", function(source, joiner)
	_joiners[source] = nil
	TriggerClientEvent("Mining:Client:OffDuty", source)
	local plyr = Fetch:Source(source)
	if plyr ~= nil then
		local char = plyr:GetData("Character")
		if char ~= nil then
			Inventory.Items:RemoveAll(char:GetData("SID"), 1, "unknown_ore")
		end
	end
end)

AddEventHandler("Mining:Server:FinishJob", function(joiner)
	_mining[joiner] = nil
end)
