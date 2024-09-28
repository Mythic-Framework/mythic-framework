function defaultApps()
	local defApps = {}
	local dock = { "contacts", "phone", "messages" }
	for k, v in pairs(PHONE_APPS) do
		if not v.canUninstall then
			table.insert(defApps, v.name)
		end
	end
	return {
		installed = defApps,
		home = defApps,
		dock = dock,
	}
end

function hasValue(tbl, value)
	for k, v in ipairs(tbl) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

local defaultSettings = {
	wallpaper = "wallpaper",
	ringtone = "ringtone1.ogg",
	texttone = "text1.ogg",
	colors = {
		accent = "#1a7cc1",
	},
	zoom = 75,
	volume = 100,
	notifications = true,
	appNotifications = {},
}

local defaultPermissions = {
	redline = {
		create = false,
	},
}

AddEventHandler("onResourceStart", function(resource)
	if resource == GetCurrentResourceName() then
		TriggerClientEvent("Phone:Client:SetApps", -1, PHONE_APPS)
	end
end)

AddEventHandler("Phone:Shared:DependencyUpdate", RetrieveComponents)

function RetrieveComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Database = exports["mythic-base"]:FetchComponent("Database")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	Config = exports["mythic-base"]:FetchComponent("Config")
	MDT = exports["mythic-base"]:FetchComponent("MDT")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Labor = exports["mythic-base"]:FetchComponent("Labor")
	Crypto = exports["mythic-base"]:FetchComponent("Crypto")
	VOIP = exports["mythic-base"]:FetchComponent("VOIP")
	Generator = exports["mythic-base"]:FetchComponent("Generator")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Loot = exports["mythic-base"]:FetchComponent("Loot")
	Loans = exports["mythic-base"]:FetchComponent("Loans")
	Billing = exports["mythic-base"]:FetchComponent("Billing")
	Banking = exports["mythic-base"]:FetchComponent("Banking")
	Reputation = exports["mythic-base"]:FetchComponent("Reputation")
	Robbery = exports["mythic-base"]:FetchComponent("Robbery")
	Wallet = exports["mythic-base"]:FetchComponent("Wallet")
	Sequence = exports["mythic-base"]:FetchComponent("Sequence")
	Vendor = exports["mythic-base"]:FetchComponent("Vendor")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Phone", {
		"Fetch",
		"Database",
		"Callbacks",
		"Logger",
		"Utils",
		"Chat",
		"Phone",
		"Middleware",
		"Execute",
		"Config",
		"MDT",
		"Jobs",
		"Labor",
		"Crypto",
		"VOIP",
		"Generator",
		"Properties",
		"Vehicles",
		"Inventory",
		"Loot",
		"Loans",
		"Billing",
		"Banking",
		"Reputation",
		"Robbery",
		"Wallet",
		"Sequence",
		"Vendor",
	}, function(error)
		if #error > 0 then
			return
		end
		-- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		Startup()
		TriggerEvent("Phone:Server:RegisterMiddleware")
		TriggerEvent("Phone:Server:RegisterCallbacks")

		Reputation:Create("Racing", "LS Underground", {
			{ label = "Rank 1", value = 1000 },
			{ label = "Rank 2", value = 2500 },
			{ label = "Rank 3", value = 5000 },
			{ label = "Rank 4", value = 10000 },
			{ label = "Rank 5", value = 25000 },
			{ label = "Rank 6", value = 50000 },
			{ label = "Rank 7", value = 100000 },
			{ label = "Rank 8", value = 250000 },
			{ label = "Rank 9", value = 500000 },
			{ label = "Rank 10", value = 1000000 },
		}, true)
	end)
end)

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		Phone:UpdateJobData(source)
		TriggerClientEvent("Phone:Client:SetApps", source, PHONE_APPS)

		local char = Fetch:Source(source):GetData("Character")
		local myPerms = char:GetData("PhonePermissions")
		local modified = false
		for app, perms in pairs(defaultPermissions) do
			if myPerms[app] == nil then
				myPerms[app] = perms
				modified = true
			else
				for perm, state in pairs(perms) do
					if myPerms[app][perm] == nil then
						myPerms[app][perm] = state
						modified = true
					end
				end
			end
		end

		if modified then
			char:SetData("PhonePermissions", myPerms)
		end
	end, 1)
	Middleware:Add("Phone:UIReset", function(source)
		Phone:UpdateJobData(source)
		TriggerClientEvent("Phone:Client:SetApps", source, PHONE_APPS)
	end)
	Middleware:Add("Characters:Creating", function(source, cData)
		local t = Middleware:TriggerEventWithData("Phone:CharacterCreated", source, cData)
		local aliases = {}

		for k, v in ipairs(t) do
			aliases[v.app] = v.alias
		end

		return {
			{
				Alias = aliases,
				Apps = defaultApps(),
				PhoneSettings = defaultSettings,
				PhonePermissions = defaultPermissions,
			},
		}
	end)
end)

RegisterNetEvent("Phone:Server:UIReset", function()
	Middleware:TriggerEvent("Phone:UIReset", source)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Apps:Home", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local apps = char:GetData("Apps")
		if data.action == "add" then
			if #apps.home < 20 then
				table.insert(apps.home, data.app)
			end
		else
			local newHome = {}
			for k, v in ipairs(apps.home) do
				if v ~= data.app then
					table.insert(newHome, v)
				end
			end

			apps.home = newHome
		end
		char:SetData("Apps", apps)
	end)

	Callbacks:RegisterServerCallback("Phone:Apps:Dock", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local apps = char:GetData("Apps")
		if data.action == "add" then
			if #apps.dock < 4 then
				table.insert(apps.dock, data.app)
			end
		else
			local newDock = {}
			for k, v in ipairs(apps.dock) do
				if v ~= data.app then
					table.insert(newDock, v)
				end
			end

			apps.dock = newDock
		end
		char:SetData("Apps", apps)
	end)

	Callbacks:RegisterServerCallback("Phone:Apps:Reorder", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local apps = char:GetData("Apps")
		apps[data.type] = data.apps
		char:SetData("Apps", apps)
	end)

	Callbacks:RegisterServerCallback("Phone:UpdateAlias", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local alias = char:GetData("Alias") or {}
		if data.unique then
			local query = {
				["Alias." .. data.app] = data.alias,
				Phone = {
					["$ne"] = char:GetData("Phone"),
				},
				Deleted = {
					["$ne"] = true,
				},
			}

			if data?.alias?.name ~= nil then
				query = {
					["Alias." .. data.app .. ".name"] = data.alias.name,
					Phone = {
						["$ne"] = char:GetData("Phone"),
					},
					Deleted = {
						["$ne"] = true,
					},
				}
			end
			Database.Game:find({
				collection = "characters",
				query = query,
			}, function(success, results)
				if #results > 0 then
					cb(false)
				else
					local upd = {
						["Alias." .. data.app] = data.alias,
					}

					if data?.alias?.name ~= nil then
						upd = {
							["Alias." .. data.app .. ".name"] = data.alias.name,
						}
					end

					Database.Game:updateOne({
						collection = "characters",
						query = {
							_id = char:GetData('ID'),
						},
						update = {
							["$set"] = upd,
						},
					}, function(success, updated)
						if success then
							alias[data.app] = data.alias
							char:SetData("Alias", alias)
							cb(true)
		
							TriggerEvent("Phone:Server:AliasUpdated", src)
						else
							cb(false)
						end
					end)
				end
			end)
		else
			alias[data.app] = data.alias
			char:SetData("Alias", alias)
			cb(true)
			TriggerEvent("Phone:Server:AliasUpdated", src)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:ShareMyContact", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")
		local myPed = GetPlayerPed(src)
		local myCoords = GetEntityCoords(myPed)
		local myBucket = GetPlayerRoutingBucket(src)
		for k, v in pairs(Fetch:All()) do
			local tsrc = v:GetData("Source")
			local tped = GetPlayerPed(tsrc)
			local coords = GetEntityCoords(tped)
			if tsrc ~= src and #(myCoords - coords) <= 5.0 and GetPlayerRoutingBucket(tsrc) == myBucket then
				TriggerClientEvent("Phone:Client:ReceiveShare", tsrc, {
					type = "contacts",
					data = {
						name = char:GetData("First") .. " " .. char:GetData("Last"),
						number = char:GetData("Phone"),
					},
				}, os.time() * 1000)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Phone:Permissions", function(src, data, cb)
		local char = Fetch:Source(src):GetData("Character")

		if char ~= nil then
			local perms = char:GetData("PhonePermissions")

			for k, v in pairs(data) do
				for k2, v2 in ipairs(v) do
					if not perms[k][v2] then
						cb(false)
						return
					end
				end
			end
			cb(true)
		else
			cb(false)
		end
	end)
end)
