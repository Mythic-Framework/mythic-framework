_accessCodes = {
	paleto = {},
}

AddEventHandler("Robbery:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Loot = exports["mythic-base"]:FetchComponent("Loot")
	Wallet = exports["mythic-base"]:FetchComponent("Wallet")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Tasks = exports["mythic-base"]:FetchComponent("Tasks")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Routing = exports["mythic-base"]:FetchComponent("Routing")
	Status = exports["mythic-base"]:FetchComponent("Status")
	WaitList = exports["mythic-base"]:FetchComponent("WaitList")
	Reputation = exports["mythic-base"]:FetchComponent("Reputation")
	Robbery = exports["mythic-base"]:FetchComponent("Robbery")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Doors = exports["mythic-base"]:FetchComponent("Doors")
	Crypto = exports["mythic-base"]:FetchComponent("Crypto")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Vendor = exports["mythic-base"]:FetchComponent("Vendor")
	CCTV = exports["mythic-base"]:FetchComponent("CCTV")
end

local _sellerLocs = {
	["0"] = vector4(-603.142, 232.680, 118.175, 181.010), -- Sunday
	["1"] = vector4(151.731, 319.175, 111.333, 89.702), -- Monday
	["2"] = vector4(1280.843, 302.963, 80.991, 16.720), -- Tuesday
	["3"] = vector4(656.831, 1282.381, 359.296, 89.724), -- Wednesday
	["4"] = vector4(1233.704, 1876.189, 77.967, 51.130), -- Thursday
	["5"] = vector4(728.761, 2522.836, 77.993, 93.041), -- Friday
	["6"] = vector4(2810.369, 5985.238, 349.687, 39.693), -- Saturday
}

local _toolsForSale = {
	{ id = 1, item = "vpn", coin = "PLEB", price = 60, qty = 10, vpn = false },
	{ id = 1, item = "safecrack_kit", coin = "PLEB", price = 8, qty = 10, vpn = false },
	{ id = 2, item = "adv_electronics_kit", coin = "PLEB", price = 100, qty = 10, vpn = true },
	{ id = 2, item = "adv_electronics_kit", coin = "HEIST", price = 15, qty = 10, vpn = true, requireCurrency = true },
}

local _heistTools = {
	{ id = 2, item = "green_dongle", coin = "HEIST", price = 20, qty = 3, vpn = true, requireCurrency = true },
	{ id = 1, item = "blue_dongle", coin = "HEIST", price = 30, qty = 1, vpn = true, requireCurrency = true },
	{ id = 3, item = "red_dongle", coin = "HEIST", price = 40, qty = 1, vpn = true, requireCurrency = true },
	{ id = 4, item = "purple_dongle", coin = "HEIST", price = 50, qty = 1, vpn = true, requireCurrency = true },
	{ id = 5, item = "yellow_dongle", coin = "HEIST", price = 60, qty = 1, vpn = true, requireCurrency = true },
}

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

function hasValue(tbl, value)
	for k, v in ipairs(tbl) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

local function dumbFuckingShitCuntFucker(type, amount)
	if not amount or amount > 1 then
		return type .. "s"
	end
	return type
end

function GetFormattedTimeFromSeconds(seconds)
	local days = 0
	local hours = Utils:Round(seconds / 3600, 0)
	if hours >= 24 then
		days = math.floor(hours / 24)
		hours = math.ceil(hours - (days * 24))
	end

	local timeString
	if days > 0 or hours > 0 then
		if days > 1 then
			if hours > 0 then
				timeString = string.format(
					"%d %s and %d %s",
					days,
					dumbFuckingShitCuntFucker("day", days),
					hours,
					dumbFuckingShitCuntFucker("hour", hours)
				)
			else
				timeString = string.format("%d %s", days, dumbFuckingShitCuntFucker("day", days))
			end
		else
			timeString = string.format("%d %s", hours, dumbFuckingShitCuntFucker("hour", hours))
		end
	else
		local minutes = Utils:Round(seconds / 60, 0)
		timeString = string.format("%d %s", minutes, dumbFuckingShitCuntFucker("minute", minutes))
	end
	return timeString
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Robbery", {
		"Fetch",
		"Logger",
		"Utils",
		"Callbacks",
		"Middleware",
		"Inventory",
		"Loot",
		"Wallet",
		"Execute",
		"Chat",
		"Sounds",
		"Tasks",
		"EmergencyAlerts",
		"Properties",
		"Routing",
		"Status",
		"WaitList",
		"Reputation",
		"Robbery",
		"Jobs",
		"Doors",
		"Crypto",
		"Phone",
		"Vehicles",
		"Vendor",
		"CCTV",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		RegisterCommands()
		SetupQueues()
		TriggerEvent("Robbery:Server:Setup")

		GlobalState["RobberiesDisabled"] = false

		_accessCodes.paleto = {}
		table.insert(_accessCodes.paleto, {
			label = "Office #1",
			code = math.random(1000, 9999),
		})
		table.insert(_accessCodes.paleto, {
			label = "Office #2",
			code = math.random(1000, 9999),
		})
		table.insert(_accessCodes.paleto, {
			label = "Office #3",
			code = math.random(1000, 9999),
		})
		table.insert(_accessCodes.paleto, {
			label = "Office #3 Safe",
			code = math.random(1000, 9999),
		})

		local pos = _sellerLocs[tostring(os.date("%w"))]
		Vendor:Create("HeistBlocks", "ped", "Devices", GetHashKey("HC_Hacker"), {
			coords = vector3(1275.687, -1710.473, 53.771),
			heading = 317.712,
			anim = {
				animDict = "mp_fbi_heist",
				anim = "loop",
			},
		}, _heistTools, "badge-dollar", "View Offers", false, 1)

		Vendor:Create("HeistShit", "ped", "Rob Tools", GetHashKey("CS_NervousRon"), {
			coords = vector3(pos.x, pos.y, pos.z),
			heading = pos.w,
		}, _toolsForSale, "badge-dollar", "View Offers", 1)

		Crypto.Coin:Create("HEIST", "HEIST", 100, false, false)

		Middleware:Add("Characters:Spawning", function(source)
			TriggerClientEvent("Robbery:Client:State:Init", source, _bankStates)
		end)

		Callbacks:RegisterServerCallback("Robbery:Holdup:Do", function(source, data, cb)
			local pChar = Fetch:Source(source):GetData("Character")
			local tPlyr = Fetch:Source(data)

			if tPlyr ~= nil then
				tChar = tPlyr:GetData("Character")
				if pChar ~= nil and tChar ~= nil then
					local pPed = GetPlayerPed(source)
					local pLoc = GetEntityCoords(pPed)
					local tPed = GetPlayerPed(data)
					local tLoc = GetEntityCoords(pPed)

					if #(vector3(pLoc.x, pLoc.y, pLoc.z) - vector3(tLoc.x, tLoc.y, tLoc.z)) <= 3.0 then
						local amt = tChar:GetData("Cash")
						if amt == 0 or Wallet:Modify(data, -amt) then
							if amt == 0 or Wallet:Modify(source, amt) then
								cb({
									invType = 1,
									owner = tChar:GetData("SID"),
								})
							end
						end
					end
				else
					cb(false)
				end
			else
				cb(false)
			end
		end)

		Callbacks:RegisterServerCallback("Robbery:Pickup", function(source, data, cb)
			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if #(_pickups[char:GetData("SID")] or {}) > 0 then
						for i = #_pickups[char:GetData("SID")], 1, -1 do
							local v = _pickups[char:GetData("SID")][i]
							local givingItem = Inventory.Items:GetData(v.giving)
							local receivingItem = Inventory.Items:GetData(v.receiving)

							if Inventory.Items:Remove(char:GetData("SID"), 1, v.giving, 1) then
								if Inventory:AddItem(char:GetData("SID"), v.receiving, 1, {}, 1) then
									table.remove(_pickups[char:GetData("SID")], i)
								else
									Inventory:AddItem(char:GetData("SID"), v.giving, 1, {}, 1)
									Execute:Client(
										source,
										"Notification",
										"Error",
										string.format("Failed Adding x1 %s", receivingItem.label),
										6000
									)
								end
							else
								Execute:Client(
									source,
									"Notification",
									"Error",
									string.format("Failed Taking x1 %s", givingItem.label),
									6000
								)
							end
						end
						for k, v in pairs(_pickups[char:GetData("SID")]) do
						end

						Execute:Client(source, "Notification", "Success", "You've Picked Up All Available Items", 6000)
					else
						Execute:Client(source, "Notification", "Error", "You Have Nothing To Pickup", 6000)
					end
				end
			end
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Robbery", _ROBBERY)
end)

_ROBBERY = {
	TriggerPDAlert = function(self, source, coords, code, title, blip, description, cameraGroup, isArea)
		Callbacks:ClientCallback(source, "EmergencyAlerts:GetStreetName", coords, function(location)
			EmergencyAlerts:Create(
				code,
				title,
				1,
				location,
				description,
				false,
				blip,
				false,
				isArea or false,
				cameraGroup or false
			)
		end)
	end,
	GetAccessCodes = function(self, bankId)
		return _accessCodes[bankId]
	end,
	State = {
		Set = function(self, bank, state)
			_bankStates[bank] = state
			TriggerClientEvent("Robbery:Client:State:Set", -1, bank, state)
		end,
		Update = function(self, bank, key, value, tableId)
			if _bankStates[bank] ~= nil then
				if tableId then
					_bankStates[bank][tableId] = _bankStates[bank][tableId] or {}
					_bankStates[bank][tableId][key] = value
				else
					_bankStates[bank][key] = value
				end
				TriggerClientEvent("Robbery:Client:State:Update", -1, bank, key, value, tableId)
			end
		end,
	},
}

RegisterNetEvent("Robbery:Server:Idiot", function(id)
	local src = source
	local plyr = Fetch:Source(src)
	if plyr ~= nil then
		local char = plyr:GetData("Character")
		if char ~= nil then
			Logger:Info(
				"Exploit",
				string.format(
					"%s %s (%s) Exploited Into A Kill Zone (%s) That Was Still Active, They're Now Dead As Fuck",
					char:GetData("First"),
					char:GetData("Last"),
					char:GetData("SID"),
					id
				),
				{
					console = true,
					file = true,
					database = true,
					discord = {
						embed = true,
						type = "info",
						webhook = GetConvar("discord_kill_webhook", ""),
					},
				}
			)
		end
	end
end)
