_dropping = {}
COMPONENTS.Players = COMPONENTS.Players or {}
COMPONENTS.RecentDisconnects = COMPONENTS.RecentDisconnects or {}

CreateThread(function()
	while true do
		for k, v in pairs(COMPONENTS.Players) do
			if not GetPlayerEndpoint(k) and not _dropping[k] then
				COMPONENTS.Middleware:TriggerEvent("playerDropped", k, "Time Out")
				COMPONENTS.Players[k] = nil
			end
		end
		Wait(10000)
	end
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	COMPONENTS.Middleware:Add("playerDropped", function(source, message)
		local player = COMPONENTS.Players[source]
		if player ~= nil then
			COMPONENTS.Logger:Info(
				"Base",
				string.format(
					"%s (%s) With Source %s Disconnected, Reason: %s",
					player:GetData("Name"),
					player:GetData("AccountID"),
					source,
					message
				),
				{
					console = true,
					discord = {
						embed = true,
						type = "info",
						webhook = GetConvar("discord_connection_webhook", ""),
					},
				}
			)
		end
	end, 1)
	COMPONENTS.Middleware:Add("playerDropped", function(source, message)
		local player = COMPONENTS.Players[source]
		if player ~= nil then
			local char = player:GetData("Character")

			local pData = {
				Source = source,
				AccountID = player:GetData("AccountID"),
				Name = player:GetData("Name"),
				Identifier = player:GetData("Identifier"),
				Level = player.Permissions:GetLevel(),
				Groups = player:GetData("Groups"),
				IsStaff = player.Permissions:IsStaff(),
				IsAdmin = player.Permissions:IsAdmin(),
				Character = (char ~= nil and {
					First = char:GetData("First"),
					Last = char:GetData("Last"),
					SID = char:GetData("SID"),
					DOB = char:GetData("DOB"),
					Phone = char:GetData("Phone"),
				} or false),
				Reason = message,
				DisconnectedTime = os.time(),
			}

			if #COMPONENTS.RecentDisconnects >= 60 then
				table.remove(COMPONENTS.RecentDisconnects, 1)
			end

			table.insert(COMPONENTS.RecentDisconnects, pData)
		end
	end, 2)
end)

AddEventHandler("playerDropped", function(message)
	local src = source
	_dropping[src] = true
	COMPONENTS.Middleware:TriggerEvent("playerDropped", src, message)
	COMPONENTS.Players[src] = nil
	_dropping[src] = nil
	collectgarbage()
end)

AddEventHandler("Core:Server:ForceUnload", function(source)
	DropPlayer(source, "You were force unloaded but were still on the server, this was probably mistake.")
	COMPONENTS.Players[source] = nil
	_dropping[source] = nil
end)

AddEventHandler("Queue:Server:SessionActive", function(source, data)
	CreateThread(function()
		Player(source).state.ID = source

		if data == nil then
			DropPlayer(source, "Unable To Get Your User Data, Please Try To Rejoin")
		else
			local pData = {
				Source = source,
				ID = data.ID,
				AccountID = data.AccountID,
				Name = data.Name,
				Identifier = data.Identifier,
				Groups = data.Groups,
				Tokens = COMPONENTS.Player:CheckTokens(source, data.ID, data.Tokens),
			}

			for k, v in pairs(COMPONENTS.Players) do
				if v:GetData("AccountID") == pData.AccountID then
					COMPONENTS.Players[k] = nil
					COMPONENTS.Logger:Error("Base", string.format("%s Connected But Was Already Registered As A Player, Clearing", pData.AccountID))
					if v:GetData("Source") ~= nil then
						DropPlayer(v:GetData("Source"), "You've Been Dropped Because Your Account Has Rejoined The Server. Using your account on multiple PCs to connect multiple times is not allowed.")
					end
				end
			end

			COMPONENTS.Players[source] = PlayerClass(source, pData)
			COMPONENTS.Routing:RoutePlayerToHiddenRoute(source)
			COMPONENTS.Logger:Info("Base", string.format("%s (%s) Connected With Source %s", COMPONENTS.Players[source]:GetData("Name"), COMPONENTS.Players[source]:GetData("AccountID"), source), {
				console = true,
				discord = {
					embed = true,
					type = 'info',
					webhook = GetConvar('discord_connection_webhook', ''),
				}
			})

			TriggerClientEvent("Player:Client:SetData", source, COMPONENTS.Players[source]:GetData())

			Player(source).state.isDev = COMPONENTS.Players[source].Permissions:GetLevel() >= 100
		end
	end)
end)

COMPONENTS.Player = {
	_required = {},
	_name = "base",
	CheckTokens = function(self, source, accountId, existing)
		local p = promise.new()

		local ctkns = {}
		for i = 0, GetNumPlayerTokens(source) - 1 do
			ctkns[GetPlayerToken(source, i)] = true
		end

		if existing ~= nil then
			for k, v in ipairs(existing) do
				if ctkns[v] then
					ctkns[v] = nil
				end
			end
			for k, v in pairs(ctkns) do
				table.insert(existing, k)
			end
			COMPONENTS.Database.Auth:updateOne({
				collection = "users",
				query = {
					_id = accountId,
				},
				update = {
					["$set"] = {
						tokens = existing,
					},
				},
			}, function()
				p:resolve(existing)
			end)
		else
			local tkns = {}
			for k, v in pairs(ctkns) do
				table.insert(tkns, k)
			end

			COMPONENTS.Database.Auth:updateOne({
				collection = "users",
				query = {
					_id = accountId,
				},
				update = {
					["$set"] = {
						tokens = tkns,
					},
				},
			}, function()
				p:resolve(tkns)
			end)
		end

		return Citizen.Await(p)
	end,
}

function PlayerClass(source, data)
	local _data = COMPONENTS.DataStore:CreateStore(source, "Player", data)

	_data.Permissions = {
		IsStaff = function(self)
			for k, v in ipairs(_data:GetData("Groups")) do
				if
					COMPONENTS.Config.Groups[v] ~= nil
					and type(COMPONENTS.Config.Groups[v].Permission) == "table"
					and (COMPONENTS.Config.Groups[v].Permission.Group == "staff" or COMPONENTS.Config.Groups[v].Permission.Group == "admin")
				then
					return true
				end
			end
			return false
		end,
		IsAdmin = function(self)
			for k, v in ipairs(_data:GetData("Groups")) do
				if
					COMPONENTS.Config.Groups[v] ~= nil
					and type(COMPONENTS.Config.Groups[v].Permission) == "table"
					and COMPONENTS.Config.Groups[v].Permission.Group == "admin"
				then
					return true
				end
			end
			return false
		end,
		GetLevel = function(self)
			local highest = 0
			for k, v in ipairs(_data:GetData("Groups")) do
				if
					COMPONENTS.Config.Groups[tostring(v)] ~= nil
					and type(COMPONENTS.Config.Groups[tostring(v)].Permission) == "table"
				then
					if COMPONENTS.Config.Groups[tostring(v)].Permission.Level > highest then
						highest = COMPONENTS.Config.Groups[tostring(v)].Permission.Level
					end
				end
			end

			return highest
		end,
	}

	local steam = GetPlayerSteam(source) -- Because the Identifier is Stored in Decimal (When you need hex)
	for k, v in ipairs(_data:GetData("Groups")) do
		if
			COMPONENTS.Config.Groups[tostring(v)] ~= nil
			and type(COMPONENTS.Config.Groups[tostring(v)].Permission) == "table"
			and COMPONENTS.Config.Groups[tostring(v)].Permission.Group
		then
			ExecuteCommand(
				("add_principal identifier.steam:%s group.%s"):format(
					steam,
					COMPONENTS.Config.Groups[tostring(v)].Permission.Group
				)
			)
		end
	end

	return _data
end

function GetPlayerSteam(source)
	for _, id in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(id, 1, string.len("steam:")) == "steam:" then
			local steamHex = string.sub(id, string.len("steam:") + 1)
			return steamHex
		end
	end
	return false
end
