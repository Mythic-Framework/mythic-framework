local STORE_SERVER_START_WAIT = 1000 * 60 * math.random(30, 60)
local STORE_REQUIRED_POLICE = 2

local _storeLocs = {
	store1 = {
		id = "store1",
		coords = vector3(-48.59, -1751.52, 29.42),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 50,
			--debugPoly = true,
			minZ = 28.42,
			maxZ = 31.82,
		},
	},
	store2 = {
		id = "store2",
		coords = vector3(-1826.95, 792.96, 138.22),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 43,
			--debugPoly = true,
			minZ = 137.22,
			maxZ = 140.22,
		},
	},
	store3 = {
		id = "store3",
		coords = vector3(-711.93, -909.84, 19.22),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 0,
			--debugPoly = true,
			minZ = 18.22,
			maxZ = 21.22,
		},
	},
	store4 = {
		id = "store4",
		coords = vector3(1704.21, 4925.27, 42.06),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 324,
			--debugPoly = true,
			minZ = 41.06,
			maxZ = 43.06,
		},
	},
	store5 = {
		id = "store5",
		coords = vector3(2676.53, 3286.28, 55.24),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 330,
			--debugPoly = true,
			minZ = 54.24,
			maxZ = 57.24,
		},
	},
	store6 = {
		id = "store6",
		coords = vector3(1734.64, 6417.04, 35.04),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 333,
			--debugPoly = true,
			minZ = 34.04,
			maxZ = 37.04,
		},
	},
	store7 = {
		id = "store7",
		coords = vector3(544.53, 2666.06, 42.16),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 6,
			--debugPoly = true,
			minZ = 41.16,
			maxZ = 44.16,
		},
	},
	store8 = {
		id = "store8",
		coords = vector3(1962.25, 3746.62, 32.34),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 28,
			--debugPoly = true,
			minZ = 31.34,
			maxZ = 34.34,
		},
	},
	store9 = {
		id = "store9",
		coords = vector3(29.65, -1342.67, 29.5),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 0,
			--debugPoly = true,
			minZ = 28.5,
			maxZ = 31.5,
		},
	},
	store10 = {
		id = "store10",
		coords = vector3(378.72, 329.66, 103.57),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 346,
			--debugPoly = true,
			minZ = 102.57,
			maxZ = 105.57,
		},
	},
	store11 = {
		id = "store11",
		coords = vector3(-3044.97, 588.05, 7.91),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 19,
			--debugPoly = true,
			minZ = 6.91,
			maxZ = 9.91,
		},
	},
	store12 = {
		id = "store12",
		coords = vector3(-3246.45, 1005.58, 12.83),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 357,
			--debugPoly = true,
			minZ = 11.83,
			maxZ = 14.83,
		},
	},
	store13 = {
		id = "store13",
		coords = vector3(2552.78, 386.17, 108.62),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 359,
			--debugPoly = true,
			minZ = 107.62,
			maxZ = 110.62,
		},
	},
	store14 = {
		id = "store14",
		coords = vector3(1159.1, -319.31, 69.21),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 280,
			--debugPoly = true,
			minZ = 68.21,
			maxZ = 71.21,
		},
	},
	store15 = {
		id = "store15",
		coords = vector3(297.268, -1266.357, 28.518),
		width = 14.6,
		length = 13.4,
		options = {
			heading = 181,
			--debugPoly = true,
			minZ = 28.518,
			maxZ = 31.518,
		},
	},
	store16 = {
		id = "store16",
		coords = vector3(165.77, 6641.32, 31.7),
		width = 13.4,
		length = 11.6,
		options = {
			heading = 315,
			--debugPoly=true,
			minZ = 30.5,
			maxZ = 34.1,
		},
	},
}

local _safes = {
	{
		id = "safe1",
		coords = vector3(1962.1, 3750.45, 32.34),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 30,
			--debugPoly=true,
			minZ = 31.94,
			maxZ = 33.74,
		},
		data = {
			id = 1,
			coords = vector3(1962.1, 3750.45, 32.34),
		},
	},
	{
		id = "safe2",
		coords = vector3(2674.39, 3289.41, 55.24),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 60,
			--debugPoly=true,
			minZ = 54.84,
			maxZ = 56.64,
		},
		data = {
			id = 2,
			coords = vector3(2674.39, 3289.41, 55.24),
		},
	},
	{
		id = "safe3",
		coords = vector3(1708.08, 4920.66, 42.06),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 325,
			--debugPoly = true,
			minZ = 40.86,
			maxZ = 42.06,
		},
		data = {
			id = 3,
			coords = vector3(1708.08, 4920.66, 42.06),
		},
	},
	{
		id = "safe4",
		coords = vector3(1737.72, 6419.32, 35.04),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 334,
			--debugPoly=true,
			minZ = 34.64,
			maxZ = 36.44,
		},
		data = {
			id = 4,
			coords = vector3(1737.72, 6419.32, 35.04),
		},
	},
	{
		id = "safe5",
		coords = vector3(171.18, 6642.34, 31.7),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 314,
			--debugPoly=true,
			minZ = 31.3,
			maxZ = 33.1,
		},
		data = {
			id = 5,
			coords = vector3(171.18, 6642.34, 31.7),
		},
	},
	{
		id = "safe6",
		coords = vector3(-168.74, 6319.02, 30.59),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 225,
			--debugPoly = true,
			minZ = 29.39,
			maxZ = 31.59,
		},
		data = {
			id = 6,
			coords = vector3(-168.74, 6319.02, 30.59),
		},
	},
	{
		id = "safe7",
		coords = vector3(-3249.66, 1007.7, 12.83),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 264,
			--debugPoly=true,
			minZ = 12.43,
			maxZ = 14.23,
		},
		data = {
			id = 7,
			coords = vector3(-3249.66, 1007.7, 12.83),
		},
	},
	{
		id = "safe8",
		coords = vector3(-3048.8, 588.78, 7.91),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 289,
			--debugPoly=true,
			minZ = 7.51,
			maxZ = 9.31,
		},
		data = {
			id = 8,
			coords = vector3(-3048.8, 588.78, 7.91),
		},
	},
	{
		id = "safe9",
		coords = vector3(-2959.62, 386.74, 14.04),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 355,
			--debugPoly = true,
			minZ = 12.84,
			maxZ = 15.04,
		},
		data = {
			id = 9,
			coords = vector3(-2959.62, 386.74, 14.04),
		},
	},
	{
		id = "safe10",
		coords = vector3(-1829.38, 798.6, 138.18),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 313,
			--debugPoly = true,
			minZ = 136.98,
			maxZ = 138.18,
		},
		data = {
			id = 10,
			coords = vector3(-1829.38, 798.6, 138.18),
		},
	},
	{
		id = "safe11",
		coords = vector3(543.07, 2662.48, 42.16),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 6,
			--debugPoly=true,
			minZ = 41.76,
			maxZ = 43.36,
		},
		data = {
			id = 11,
			coords = vector3(543.07, 2662.48, 42.16),
		},
	},
	{
		id = "safe12",
		coords = vector3(1169.57, 2717.84, 37.16),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 88,
			--debugPoly = true,
			minZ = 35.96,
			maxZ = 38.16,
		},
		data = {
			id = 12,
			coords = vector3(1169.57, 2717.84, 37.16),
		},
	},
	{
		id = "safe13",
		coords = vector3(2549.45, 388.22, 108.62),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 86,
			--debugPoly=true,
			minZ = 108.22,
			maxZ = 109.82,
		},
		data = {
			id = 13,
			coords = vector3(2549.45, 388.22, 108.62),
		},
	},
	{
		id = "safe14",
		coords = vector3(1159.2, -314.07, 69.21),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 100,
			--debugPoly = true,
			minZ = 68.01,
			maxZ = 69.21,
		},
		data = {
			id = 14,
			coords = vector3(1159.2, -314.07, 69.21),
		},
	},
	{
		id = "safe15",
		coords = vector3(381.37, 332.47, 103.57),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 346,
			--debugPoly=true,
			minZ = 103.17,
			maxZ = 104.77,
		},
		data = {
			id = 15,
			coords = vector3(381.37, 332.47, 103.57),
		},
	},
	{
		id = "safe16",
		coords = vector3(-1478.67, -375.68, 39.16),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 223,
			--debugPoly = true,
			minZ = 37.96,
			maxZ = 40.16,
		},
		data = {
			id = 16,
			coords = vector3(-1478.67, -375.68, 39.16),
		},
	},
	{
		id = "safe17",
		coords = vector3(-1221.13, -916.19, 11.33),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 123,
			--debugPoly = true,
			minZ = 10.13,
			maxZ = 12.33,
		},
		data = {
			id = 17,
			coords = vector3(-1478.67, -375.68, 39.16),
		},
	},
	{
		id = "safe18",
		coords = vector3(1126.75, -979.81, 45.42),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 188,
			--debugPoly = true,
			minZ = 44.22,
			maxZ = 46.42,
		},
		data = {
			id = 18,
			coords = vector3(1126.75, -979.81, 45.42),
		},
	},
	{
		id = "safe19",
		coords = vector3(-709.99, -904.16, 19.22),
		width = 0.6,
		length = 0.4,
		options = {
			heading = 268,
			--debugPoly = true,
			minZ = 18.02,
			maxZ = 19.22,
		},
		data = {
			id = 19,
			coords = vector3(-709.99, -904.16, 19.22),
		},
	},
	{
		id = "safe20",
		coords = vector3(31.48, -1339.27, 29.5),
		width = 0.4,
		length = 1.2,
		options = {
			heading = 1,
			--debugPoly=true,
			minZ = 29.1,
			maxZ = 30.7,
		},
		data = {
			id = 20,
			coords = vector3(31.48, -1339.27, 29.5),
		},
	},
	{
		id = "safe21",
		coords = vector3(-43.62, -1748.17, 29.42),
		width = 0.6,
		length = 0.6,
		options = {
			heading = 51,
			--debugPoly = true,
			minZ = 28.22,
			maxZ = 29.42,
		},
		data = {
			id = 21,
			coords = vector3(-43.62, -1748.17, 29.42),
		},
	},
	{
		id = "safe22",
		coords = vector3(302.29, -1268.55, 29.52),
		width = 0.4,
		length = 0.6,
		options = {
			heading = 269,
			--debugPoly = true,
			minZ = 26.52,
			maxZ = 29.72,
		},
		data = {
			id = 22,
			coords = vector3(302.29, -1268.55, 29.52),
		},
	},
}

local _registerLoot = {
	{ 99, { name = "moneyroll", min = 2, max = 4 } },
	{ 1, { name = "moneyband", max = 1 } },
}

local _safeLoot = {
	{ 85, { name = "moneyroll", min = 20, max = 40 } },
	{ 13, { name = "moneyband", min = 2, max = 4 } },
	{ 2, { name = "valuegoods", min = 1, max = 3 } },
}

_storeAlerts = {}
_registers = {}
_robbedSafes = {}

local _storeInUse = {}

local _run = false
function Threads()
	if _run then
		return
	end
	_run = true

	CreateThread(function()
		while true do
			Logger:Trace("Robbery", "Resetting Store Alert States With Expired Emergency Alerts")
			for k, v in pairs(_storeAlerts) do
				if v < os.time() then
					_storeAlerts[k] = nil
				end
			end
			Wait((1000 * 60) * 2)
		end
	end)
end

local _cRegisterCooldowns = {}

AddEventHandler("Robbery:Server:Setup", function()
	GlobalState["StoreRobberies"] = _storeLocs
	GlobalState["StoreSafes"] = _safes

	Callbacks:RegisterServerCallback("Robbery:Store:Register", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")

		local d = GlobalState[string.format("Register:%s:%s", data.coords[1], data.coords[2])]
		if
			char
			and d ~= nil
			and d.source == source
			and (not _cRegisterCooldowns[source] or os.time() > _cRegisterCooldowns[source])
		then
			_cRegisterCooldowns[source] = os.time() + 5
			if data.results then
				Loot:CustomWeightedSetWithCount(_registerLoot, char:GetData("SID"), 1)
				Wallet:Modify(source, (math.random(150) + 100))
				cb(true)
			else
				Inventory.Items:Remove(char:GetData("SID"), 1, "lockpick", 1)

				local slot = Inventory.Items:GetFirst(char:GetData("SID"), "lockpick", 1)
				if slot ~= nil then
					local itemData = Inventory.Items:GetData("lockpick")
					local newValue = slot.CreateDate - math.ceil(itemData.durability / 2)
					if success then
						newValue = slot.CreateDate - math.ceil(itemData.durability / 8)
					end
					if (os.time() - itemData.durability >= newValue) then
						Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
					else
						Inventory:SetItemCreateDate(slot.id, newValue)
					end
				end
				
				if _storeAlerts[data.store] == nil or _storeAlerts[data.store] < os.time() then
					_storeAlerts[data.store] = (os.time() + (60 * 5))
					Robbery:TriggerPDAlert(
						source,
						_storeLocs[data.store].coords,
						"10-90",
						"Store Robbery",
						{
							icon = 628,
							size = 0.9,
							color = 31,
							duration = (60 * 5),
						},
						{
							icon = "shop",
							details = '24/7',
						},
						data.store
					)
				end
				cb(true)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Store:StartSafeCrack", function(source, data, cb)
		local pState = Player(source).state
		local plyr = Fetch:Source(source)

		if pState.storePoly ~= nil then
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if
						GlobalState[string.format("Safe:%s", data.id)] == nil
						or os.time() > GlobalState[string.format("Safe:%s", data.id)].expires
					then
						if GetGameTimer() < STORE_SERVER_START_WAIT then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"You Notice The Register Has An Extra Lock On It Securing It For A Storm, Maybe Check Back Later",
								6000
							)
							return cb(false)
						elseif (GlobalState["Duty:police"] or 0) < STORE_REQUIRED_POLICE then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
								6000
							)
							return cb(false)
						elseif GlobalState["RobberiesDisabled"] then
							Execute:Client(
								source,
								"Notification",
								"Error",
								"Temporarily Disabled, Please See City Announcements",
								6000
							)
							return cb(false)
						end

						if not _storeInUse[pState.storePoly] then
							_storeInUse[pState.storePoly] = source
							local slot = Inventory.Items:GetFirst(char:GetData("SID"), "safecrack_kit", 1)

							if slot ~= nil then
								local itemData = Inventory.Items:GetData(slot.Name)

								Logger:Info("Robbery", string.format("%s %s (%s) Started Store Robbery (Safe) At Store %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), pState.storePoly))

								Callbacks:ClientCallback(source, "Robbery:Store:DoSafeCrack", {
									passes = 1,
									config = {
										countdown = 3,
										preview = 2500,
										timer = 10000,
										passReduce = 300,
										base = 8,
										cols = 5,
										rows = 5,
										anim = false,
									},
									data = {},
								}, function(isSuccess, extra)
									local itemData = Inventory.Items:GetData("safecrack_kit")
						
									local newValue = slot.CreateDate - math.ceil(itemData.durability / 2)
									if (os.time() - itemData.durability >= newValue) then
										Inventory.Items:RemoveId(char:GetData("SID"), 1, slot)
									else
										Inventory:SetItemCreateDate(
											slot.id,
											newValue
										)
									end

									if isSuccess then
										if
											_storeAlerts[pState.storePoly] == nil
											or _storeAlerts[pState.storePoly] < os.time()
										then
											_storeAlerts[pState.storePoly] = (os.time() + (60 * 5))
											Robbery:TriggerPDAlert(
												source,
												_storeLocs[pState.storePoly].coords,
												"10-90",
												"Store Robbery",
												{
													icon = 628,
													size = 0.9,
													color = 31,
													duration = (60 * 5),
												},
												{
													icon = "shop",
													details = '24/7',
												},
												pState.storePoly
											)
										end
										local obj = {
											expires = os.time() + (60 * math.random(3, 5)),
											id = data.id,
											poly = pState.storePoly,
											coords = data.coords,
											source = source,
											state = 1,
										}
										Logger:Trace(
											"Robbery",
											string.format("Safe %s Will Unlock At %s", data.id, obj.expires)
										)
										_robbedSafes[data.id] = obj
										GlobalState[string.format("Safe:%s", data.id)] = obj
										GlobalState["StoreAntiShitlord"] = os.time() + (60 * math.random(5, 10))

										Status.Modify:Add(source, "PLAYER_STRESS", 3)
										Execute:Client(
											source,
											"Notification",
											"Success",
											"Lock Disengage Initiated, Please Stand By",
											6000
										)
									else
										Status.Modify:Add(source, "PLAYER_STRESS", 6)
									end

									_storeInUse[data.id] = nil
								end)
							end
						end
					else
						Execute:Client(source, "Notification", "Error", "Unable To Crack Safe", 6000)
					end
				end
			end
		end

		cb(false)
	end)

	Callbacks:RegisterServerCallback("Robbery:Store:StartSafeSequence", function(source, data, cb)
		if GetGameTimer() < STORE_SERVER_START_WAIT then
			Execute:Client(
				source,
				"Notification",
				"Error",
				"You Notice The Register Has An Extra Lock On It Securing It For A Storm, Maybe Check Back Later",
				6000
			)
			return cb(false)
		elseif (GlobalState["Duty:police"] or 0) < STORE_REQUIRED_POLICE then
			Execute:Client(
				source,
				"Notification",
				"Error",
				"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
				6000
			)
			return cb(false)
		elseif GlobalState["RobberiesDisabled"] then
			Execute:Client(source, "Notification", "Error", "Temporarily Disabled, Please See City Announcements", 6000)
			return cb(false)
		end

		cb(true)
	end)

	Callbacks:RegisterServerCallback("Robbery:Store:StartLockpick", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if
					GlobalState[string.format("Register:%s:%s", data.x, data.y)] == nil and not GlobalState["RestartLockdown"]
				then
					if GetGameTimer() < STORE_SERVER_START_WAIT then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"You Notice The Register Has An Extra Lock On It Securing It For A Storm, Maybe Check Back Later",
							6000
						)
						return
					elseif (GlobalState["Duty:police"] or 0) < STORE_REQUIRED_POLICE then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
							6000
						)
						return
					elseif GlobalState["RobberiesDisabled"] then
						Execute:Client(
							source,
							"Notification",
							"Error",
							"Temporarily Disabled, Please See City Announcements",
							6000
						)
						return
					end
		
					local obj = {
						expires = (os.time() + 60 * math.random(20, 40)),
						coords = data,
						source = source,
					}
					Logger:Info("Robbery", string.format("%s %s (%s) Started Store Robbery (Register) At Store %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), Player(source).state.storePoly))
					table.insert(_registers, obj)
					GlobalState[string.format("Register:%s:%s", data.x, data.y)] = obj
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Store:Safe", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if GlobalState[string.format("Safe:%s", data.id)] == nil and not GlobalState["RestartLockdown"] then
			if GetGameTimer() < STORE_SERVER_START_WAIT then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"You Notice The Register Has An Extra Lock On It Securing It For A Storm, Maybe Check Back Later",
					6000
				)
				return
			elseif (GlobalState["Duty:police"] or 0) < STORE_REQUIRED_POLICE then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Enhanced Security Measures Enabled, Maybe Check Back Later When Things Feel Safer",
					6000
				)
				return
			elseif GlobalState["RobberiesDisabled"] then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Temporarily Disabled, Please See City Announcements",
					6000
				)
				return
			elseif GlobalState["StoreAntiShitlord"] ~= nil and GlobalState["StoreAntiShitlord"] > os.time() then
				Execute:Client(
					source,
					"Notification",
					"Error",
					"Temporary Security Measures Engaged, Come Back Later",
					6000
				)
				return
			end

			local state = -1
			if data.results then
				state = 1
				cb(true)
				Execute:Client(source, "Notification", "Success", "Lock Disengage Initiated, Please Stand By", 6000)
			else
				-- Do something?
				cb(true)
				Execute:Client(source, "Notification", "Error", "You've Damaged The Electronics On The Lock", 6000)
			end
			if _storeAlerts[data.store] == nil or _storeAlerts[data.store] < os.time() then
				Logger:Info("Robbery", string.format("%s %s (%s) Started Store Robbery (Safe) At Store %s", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), data.store))
				_storeAlerts[data.store] = (os.time() + (60 * 5))
				Robbery:TriggerPDAlert(source, _storeLocs[data.store].coords, "10-90", "Store Robbery", {
					icon = 628,
					size = 0.9,
					color = 31,
					duration = (60 * 5),
				},
				{
					icon = "shop",
					details = '24/7',
				},
				data.store)
			end
			local obj = {
				expires = (os.time() + 60 * 5),
				id = data.id,
				poly = string.format("store%s", data.id),
				coords = data.coords,
				source = source,
				state = state,
			}
			Logger:Trace("Robbery", string.format("Safe %s Will Unlock At %s", data.id, obj.expires))
			_robbedSafes[data.id] = obj
			GlobalState[string.format("Safe:%s", data.id)] = obj
			GlobalState["StoreAntiShitlord"] = os.time() + (60 * math.random(5, 10))
		else
			Logger:Error("Robbery", string.format("Safe %s Was Already Cracked", data.id))
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Store:LootSafe", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")

		if _robbedSafes[data.id] ~= nil and _robbedSafes[data.id].state == 2 then
			_robbedSafes[data.id].state = 3
			_robbedSafes[data.id].expires = (os.time() + 60 * math.random(30, 60))
			GlobalState[string.format("Safe:%s", data.id)] = _robbedSafes[data.id]

			Loot:CustomWeightedSetWithCount(_safeLoot, char:GetData("SID"), 1)

			if math.random(100) <= 5 then
				Inventory:AddItem(char:GetData("SID"), "green_dongle", 1, {}, 1)
				Inventory:AddItem(char:GetData("SID"), "crypto_voucher", 1, {
					CryptoCoin = "HEIST",
					Quantity = 2,
				}, 1)
			elseif math.random(100) <= 15 then
				Inventory:AddItem(char:GetData("SID"), "gps_tracker", 1, {}, 1)
			end

			Logger:Info("Robbery", string.format("%s %s (%s) Looted %s Safe", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), data.id))
			Wallet:Modify(source, (math.random(3000) + 2000))
			Sounds.Stop:Location(_robbedSafes[data.id].source, _robbedSafes[data.id].coords, "alarm")
		end
	end)

	Callbacks:RegisterServerCallback("Robbery:Store:SecureSafe", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local myDuty = Player(source).state.onDuty

		if myDuty and myDuty == "police" then
			if _robbedSafes[data.id] ~= nil and _robbedSafes[data.id].state ~= 4 then
				if _robbedSafes[data.id].state == 1 then
					Chat.Send.Server:Single(source, "Safe Was Cracked, But Timelock Was Still Engaged")
				elseif _robbedSafes[data.id].state == 2 then
					Chat.Send.Server:Single(source, "Safe Was Cracked, And Timelock Disengaged")
				elseif _robbedSafes[data.id].state == 3 then
					Chat.Send.Server:Single(source, "Safe Was Cracked and looted")
				end

				_robbedSafes[data.id].state = 4
				_robbedSafes[data.id].expires = (os.time() + 60 * math.random(30, 60))
				Logger:Info("Robbery", string.format("%s %s (%s) Secured %s Safe", char:GetData("First"), char:GetData("Last"), char:GetData("SID"), data.id))
				GlobalState[string.format("Safe:%s", data.id)] = _robbedSafes[data.id]
				Sounds.Stop:Location(_robbedSafes[data.id].source, _robbedSafes[data.id].coords, "alarm")
			end
		end
	end)
end)

CreateThread(function()
	while true do
		for k, v in pairs(_robbedSafes) do
			if v.expires < os.time() then
				if v.state == 1 then
					Logger:Trace("Robbery", string.format("Safe %s Expired While State 1, Updating To State 2", k))
					_robbedSafes[k].expires = (os.time() + 60 * math.random(30, 60))
					_robbedSafes[k].state = 2
					GlobalState[string.format("Safe:%s", k)] = _robbedSafes[k]
					Sounds.Play:Location(v.source, v.coords, 10, "alarm.ogg", 0.15)
					-- Do something to alert
				else
					Logger:Trace("Robbery", string.format("Safe %s Expired While State 2, Resetting", k))
					_robbedSafes[k] = nil
					GlobalState[string.format("Safe:%s", k)] = nil
				end
			end
		end
		Wait(30000)
	end
end)
