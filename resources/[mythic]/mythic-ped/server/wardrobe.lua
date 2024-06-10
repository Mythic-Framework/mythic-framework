AddEventHandler("Wardrobe:Shared:DependencyUpdate", RetrieveWardrobeComponents)
function RetrieveWardrobeComponents()
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Database = exports["mythic-base"]:FetchComponent("Database")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Ped = exports["mythic-base"]:FetchComponent("Ped")
	Wardrobe = exports["mythic-base"]:FetchComponent("Wardrobe")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Wardrobe", {
		"Chat",
		"Fetch",
		"Callbacks",
		"Middleware",
		"Database",
		"Locations",
		"Logger",
		"Ped",
		"Wardrobe",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveWardrobeComponents()
		RegisterWardrobeCallbacks()
		RegisterWardrobeMiddleware()
		RegisterChatCommands()
	end)
end)

WARDROBE = {}
AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Wardrobe", WARDROBE)
end)

function RegisterChatCommands()
	Chat:RegisterAdminCommand("wardrobe", function(source, args, rawCommand)
		TriggerClientEvent("Wardrobe:Client:ShowBitch", source)
	end, {
		help = "Test Notification",
	})
end

function RegisterWardrobeMiddleware()
	Middleware:Add("Characters:Creating", function(source, cData)
		return { {
			Wardrobe = {},
		} }
	end)
end

function RegisterWardrobeCallbacks()
	Callbacks:RegisterServerCallback("Wardrobe:GetAll", function(source, data, cb)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local char = player:GetData("Character")
		local wardrobe = char:GetData("Wardrobe") or {}

		local wr = {}

		for k, v in ipairs(wardrobe) do
			table.insert(wr, {
				label = v.label,
			})
		end

		cb(wr)
	end)

	Callbacks:RegisterServerCallback("Wardrobe:Save", function(source, data, cb)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local char = player:GetData("Character")

		if char ~= nil then
			local ped = char:GetData("Ped")
			local wardrobe = char:GetData("Wardrobe") or {}

			local outfit = {
				label = data.name,
				data = ped.customization,
			}
			table.insert(wardrobe, outfit)
			char:SetData("Wardrobe", wardrobe)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Wardrobe:SaveExisting", function(source, data, cb)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local char = player:GetData("Character")

		if char ~= nil then
			local ped = char:GetData("Ped")
			local wardrobe = char:GetData("Wardrobe") or {}

			if wardrobe[data] ~= nil then
				wardrobe[data].data = ped.customization
				char:SetData("Wardrobe", wardrobe)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Wardrobe:Equip", function(source, data, cb)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local char = player:GetData("Character")
		if char ~= nil then
			local outfit = char:GetData("Wardrobe")[tonumber(data)]
			if outfit ~= nil then
				Ped:ApplyOutfit(source, outfit)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Wardrobe:Delete", function(source, data, cb)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local char = player:GetData("Character")
		if char ~= nil then
			local wardrobe = char:GetData("Wardrobe") or {}
			table.remove(wardrobe, data)
			char:SetData("Wardrobe", wardrobe)
			cb(true)
		else
			cb(false)
		end
	end)
end
