Convar = {}

local queueEnabled, queueActive, queueClosed = true, false, false
local resourceName = GetCurrentResourceName()
local MAX_PLAYERS = tonumber(GetConvar("sv_maxclients", "32"))

_tempWhitelist = {}
_tempWhitelistGroup = {}

GlobalState["MaxPlayers"] = MAX_PLAYERS

local playerJoining = false
local privPlayerJoining = false

local _dbReadyTime = 0
local _dbReady = false

local Data = {
	Total = 0,
	Session = {
		Count = 0,
		Players = {},
	},
	Dropped = {},
	Queue = {},
}

QUEUE = {}

QUEUE.Queue = {
	Get = function(self, identifier)
		for k, v in ipairs(Data.Queue) do
			if v.Identifier == identifier then
				return k, v
			end
		end

		return nil
	end,
	Add = function(self, player)
		for k, v in ipairs(Data.Queue) do
			if player.Identifier == v.Identifier then
				if v:IsInGracePeriod() then
					v.Deferrals = player.Deferrals
					v.State = States.QUEUED
					v.Source = player.Source
					v.Groups = player.Groups
					v.Name = player.Name
					v.ID = player.ID
					v.AccountID = player.AccountID
					v.Tokens = player.Tokens
					v.Avatar = player.Avatar
					v.Priority = player.Priority
					v.TimeBoost = player.TimeBoost
					v.Message = player.Message
				else
					QUEUE.Queue:Remove(k)
				end
				return
			end
		end

		if player.Priority > 0 then
			for k, v in ipairs(Data.Queue) do
				if player.Priority > v.Priority then
					table.insert(Data.Queue, k, player)
					Log(
						string.format(
							Config.Strings.PrioAdd,
							player.Name,
							player.Identifier,
							k,
							#Data.Queue,
							player.Priority
						)
					)
					return
				end
			end
		end

		table.insert(Data.Queue, player)
		Log(
			string.format(
				Config.Strings.Add,
				player.Name,
				player.AccountID,
				player.Identifier,
				#Data.Queue,
				#Data.Queue,
				GetNumPlayerIndices()
			)
		)
	end,
	Remove = function(self, position)
		table.remove(Data.Queue, position)
	end,
	Join = function(self, count)
		local joined = 0
		for i = 1, #Data.Queue, 1 do
			if joined == count then
				break
			end
			if Data.Queue[i] ~= nil and Data.Queue[i].State == States.QUEUED then
				if GetPlayerEndpoint(Data.Queue[i].Source) then
					Data.Total = Data.Total + 1
					Data.Queue[i].Deferrals.update(Config.Strings.Joining)
					Data.Queue[i].State = States.JOINING
					Data.Queue[i].Deferrals.handover({
						name = Data.Queue[i].Name,
						priority = Data.Queue[i].Priority,
						priorityMessage = Data.Queue[i].Message,
					})
					Data.Queue[i].Deferrals.done()
					Log(
						string.format(
							Config.Strings.Joined,
							Data.Queue[i].Name,
							Data.Queue[i].AccountID,
							Data.Queue[i].Identifier
						)
					)
					joined = joined + 1
				else
					Data.Queue[i].State = States.DISCONNECTED
					Data.Queue[i].Grace = os.time()
					Log(
						string.format(
							Config.Strings.Disconnected,
							Data.Queue[i].Name,
							Data.Queue[i].AccountID,
							Data.Queue[i].Identifier
						)
					)
				end
			end
		end
		playerJoining = false
	end,
	Drop = function(self, priv)
		local dropping = nil
		for k, v in pairs(Data.Session.Players) do
			if v ~= nil and (dropping == nil or v.Priority < dropping.Priority) then
				dropping = v
			end
		end

		DropPlayer(dropping.Source, Config.Strings.Dropped)
		priv.Deferrals.done()
	end,
}

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

QUEUE.Dropped = {
	Get = function(self, identifier)
		for k, v in ipairs(Data.Dropped) do
			if v.Identifier == identifier and os.time() < v.Grace then
				return k
			end
		end

		return nil
	end,
	Add = function(self, source, message)
		Data.Total = Data.Total - 1
		for _, v in ipairs(Config.ExcludeDrop) do
			if string.find(message, v) then
				return
			end
		end
		Log("Player Dropped: " .. tostring(message))

		if Data.Session.Players[source] == nil then
			return
		end

		table.insert(Data.Dropped, {
			Identifier = Data.Session.Players[source].Identifier,
			Grace = os.time() + (60 * 5),
		})
		QUEUE.Session:Remove(source)
	end,
	Remove = function(self, position)
		table.remove(Data.Dropped, position)
	end,
}

QUEUE.Session = {
	Add = function(self, player)
		Data.Session.Count = Data.Session.Count + 1
		Data.Session.Players[player.Source] = player
	end,
	Remove = function(self, source)
		Data.Session.Count = Data.Session.Count - 1
		Data.Session.Players[source] = nil
	end,
}

function GetPlayerSteam(source)
	for _, id in ipairs(GetPlayerIdentifiers(source)) do
		if string.sub(id, 1, string.len("steam:")) == "steam:" then
			local steamHex = string.sub(id, string.len("steam:") + 1)
			return steamHex
		end
	end
	return false
end

function GetPlayerSteamDecimal(source)
	local steamHex = GetPlayerSteam(source)
	if not steamHex then
		return false
	end
	local steam64 = tonumber(steamHex, 16)
	return tostring(steam64)
end

QUEUE.Connect = function(self, source, playerName, setKickReason, deferrals)
	local identifier = nil

	deferrals.defer()
	Citizen.Wait(1)

	Citizen.CreateThread(function()
		if not _dbReady or GlobalState.IsProduction == nil then
			deferrals.done(Config.Strings.NotReady)
			return CancelEvent()
		end

		if queueClosed then
			deferrals.done(Config.Strings.PendingRestart)
			return CancelEvent()
		end

		if GlobalState.IsProduction then
			while GetGameTimer() < (_dbReadyTime + (Config.Settings.QueueDelay * (1000 * 60))) do
				local min = math.floor(((math.floor(_dbReadyTime / 1000) + (Config.Settings.QueueDelay * 60)) - math.floor(GetGameTimer() / 1000)) / 60)
				local secs = math.floor(((math.floor(_dbReadyTime / 1000) + (Config.Settings.QueueDelay * 60)) - math.floor(GetGameTimer() / 1000)) - (min * 60))

				if min <= 0 then
					deferrals.update(string.format(Config.Strings.WaitingSeconds, secs, secs > 1 and "Seconds" or "Second"))
				else
					deferrals.update(string.format(Config.Strings.Waiting, min, min > 1 and "Minutes" or "Minute", secs, secs > 1 and "Seconds" or "Second"))
				end

				Citizen.Wait(100)
			end
		end

		while not queueActive do
			Citizen.Wait(100)
		end

		local identifier = GetPlayerSteamDecimal(source)

		if not identifier then
			deferrals.done(Config.Strings.NoIdentifier)
			CancelEvent()
			return
		end

		local ply = PlayerClass(identifier, source, deferrals)

		if not ply or not ply:IsWhitelisted() then
			if not ply and not Config.Server.Access then
				deferrals.done(Config.Strings.PublicWhitelist)
			else
				deferrals.done(Config.Strings.NotWhitelisted)
			end
			CancelEvent()
			return
		end

		if not ply:IsVerified() then
			deferrals.done(Config.Strings.NotVerified)
			CancelEvent()
			return
		end

		-- if not ply:IsValid() then
		-- 	deferrals.done(Config.Strings.NotValid)
		-- 	CancelEvent()
		-- 	return
		-- end

		-- local siteBanned = ply:IsSiteBanned()
		-- if siteBanned then
		-- 	deferrals.done(Config.Strings.SiteBanned)
		-- 	CancelEvent()
		-- 	return
		-- end

		local banned = ply:IsBanned()
		print(banned)
		print(json.encode(banned))
		if banned ~= nil then
			if banned.issuer == "Pwnzor" then
				banned.reason = "💙 From Pwnzor 🙂"
			end
			if banned.expires == -1 then
				deferrals.done(string.format(Config.Strings.PermaBanned, banned.reason, banned._id or "N/A"))
			else
				deferrals.done(
					string.format(
						Config.Strings.Banned,
						banned.reason,
						os.date("%Y-%m-%d at %I:%M:%S %p", tostring(banned.expires)),
						banned._id or "N/A"
					)
				)
			end
			CancelEvent()
			return
		end

		local tknBan = ply:IsTokenBanned()
		if tknBan ~= nil then
			if tknBan.expires == -1 then
				deferrals.done(string.format(Config.Strings.PermaBanned, tknBan.reason, tknBan._id or "N/A"))
			else
				deferrals.done(
					string.format(
						Config.Strings.Banned,
						tknBan.reason,
						os.date("%Y-%m-%d at %I:%M:%S %p", tostring(tknBan.expires)),
						tknBan._id or "N/A"
					)
				)
			end
			CancelEvent()
			return
		end

		-- if Data.Session.Count < MAX_PLAYERS then
		--     self.Session:Add(ply)
		--     deferrals.update(Config.Strings.Joining)
		--     deferrals.done()
		--     return
		-- end

		QUEUE.Queue:Add(ply)

		local pos, plyr = QUEUE.Queue:Get(identifier)

		while plyr == nil do
			QUEUE.Queue:Add(ply)
			pos, plyr = QUEUE.Queue:Get(identifier)
			Citizen.Wait(100)
		end

		while plyr.State == States.QUEUED and GetPlayerEndpoint(source) do
			pos, plyr = QUEUE.Queue:Get(identifier)

			local msg = ""
			if plyr.Priority > 0 then
				if plyr.TimeBoost > 0 then
					msg = "\n\nTotal Priority of "
						.. plyr.Priority
						.. ": \n⏳ Time In Queue +"
						.. plyr.TimeBoost
						.. " ⏳"
						.. plyr.Message
				else
					msg = "\n\nTotal Priority of " .. plyr.Priority .. ": " .. plyr.Message
				end
			end
			plyr.Deferrals.update(string.format(Config.Strings.Queued, pos, #Data.Queue, plyr.Timer:Output(), msg))
			plyr.Timer:Tick(plyr)
			Citizen.Wait(1000)
		end

		pos, plyr = QUEUE.Queue:Get(identifier)
		if plyr.State == States.QUEUED then
			plyr.State = States.DISCONNECTED
			plyr.Grace = (os.time() + (60 * 5))
			Log(string.format(Config.Strings.Grace, plyr.Name, os.date("%I:%M:%S %p", plyr.Grace)))
			Data.Queue[pos] = plyr
			--self.Queue:Remove(pos)
		end
	end)
end

QUEUE.Utils = {
	CloseAndDrop = function(self)
		queueClosed = true
		for k, v in ipairs(Data.Queue) do
			v.Deferrals.done(Config.Strings.PendingRestart)
		end
	end,
}

QUEUE.GetTotal = function(self)
	return #Data.Queue or 0
end

Citizen.CreateThread(function()
	while true do
		GlobalState["QueueCount"] = #Data.Queue
		Citizen.Wait(30000)
	end
end)

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
	if queueClosed then
		deferrals.done(Config.Strings.PendingRestart)
	elseif queueEnabled then
		QUEUE:Connect(source, playerName, setKickReason, deferrals)
	else
		deferrals.done("Queue Closed, Try Again Later")
	end
end)

AddEventHandler("playerDropped", function(message)
	if queueEnabled then
		Queue.Dropped:Add(source, message)
	end
end)

AddEventHandler("onResourceStart", function(resource)
	if resource == "mythic-base" then
		while GetResourceState(resource) ~= "started" do
			Citizen.Wait(0)
		end
		for k, v in pairs(Data.Session.Players) do
			TriggerClientEvent("Queue:Client:SessionActive", k)
			TriggerEvent("Queue:Server:SessionActive", k, {
				Groups = ply.Groups,
				Name = ply.Name,
				ID = ply.ID,
				AccountID = ply.AccountID,
				Avatar = ply.Avatar,
				Identifier = ply.Identifier,
				Tokens = ply.Tokens,
			})
		end
	end
end)

AddEventHandler("Core:Shared:Ready", function()
	_dbReadyTime = GetGameTimer()
	_dbReady = true
end)

RegisterServerEvent("Core:Server:SessionStarted")
AddEventHandler("Core:Server:SessionStarted", function()
	local src = source
	local identifier = GetPlayerSteamDecimal(src)
	if identifier then
		local pos, ply = Queue.Queue:Get(identifier)

		if ply ~= nil then
			ply.Source = src
			ply.State = States.JOINED
			QUEUE.Session:Add(ply)
			QUEUE.Queue:Remove(pos)
			TriggerClientEvent("Queue:Client:SessionActive", src)
			TriggerEvent("Queue:Server:SessionActive", src, {
				Groups = ply.Groups,
				Name = ply.Name,
				ID = ply.ID,
				AccountID = ply.AccountID,
				Avatar = ply.Avatar,
				Identifier = ply.Identifier,
				Tokens = ply.Tokens,
			})
		end

		return
	end

	DropPlayer(src, Config.Strings.NoIdentifier)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Queue", QUEUE)
end)

AddEventHandler("Queue:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	c = exports["mythic-base"]:FetchComponent("Config")
	Database = exports["mythic-base"]:FetchComponent("Database")
	WebAPI = exports["mythic-base"]:FetchComponent("WebAPI")
	Punishment = exports["mythic-base"]:FetchComponent("Punishment")
	Queue = exports["mythic-base"]:FetchComponent("Queue")
	Convar = exports["mythic-base"]:FetchComponent("Convar")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	Sequence = exports["mythic-base"]:FetchComponent("Sequence")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Queue", {
		"Config",
		"Database",
		"WebAPI",
		"Punishment",
		"Queue",
		"Convar",
		"Chat",
		"Execute",
		"Sequence",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		Config.Server = c.Server
		Config.Groups = c.Groups
		Config.GroupIDs = c.GroupIDs
		queueActive = true

		Chat:RegisterAdminCommand("clearjoining", function(source, args, rawCommand)
			playerJoining = false
			privPlayerJoining = false
		end, {
			help = "Clear Queue Joining State",
		}, 0)

		Chat:RegisterAdminCommand("tempwl", function(source, args, rawCommand)
			local accountID = args[1]
			if accountID then
				if not _tempWhitelist[accountID] then
					_tempWhitelist[accountID] = true
					Execute:Client(source, "Notification", "Success", "Temp Whitelist Added For ID: " .. accountID)
				else
					_tempWhitelist[accountID] = false
					Execute:Client(source, "Notification", "Error", "Temp Whitelist Revoked For ID: " .. accountID)
				end
			end
		end, {
			help = "Temp Whitelist Someone",
			params = {
				{
					name = "Account DB ID",
					help = "Account DB Number - Look at URL",
				},
			},
		}, 1)

		Chat:RegisterAdminCommand("tempwlgroup", function(source, args, rawCommand)
			local group = args[1]
			if group then
				if not _tempWhitelistGroup[group] then
					_tempWhitelistGroup[group] = true
					Execute:Client(source, "Notification", "Success", "Temp Whitelist Added For Group: " .. group)
				else
					_tempWhitelistGroup[group] = false
					Execute:Client(source, "Notification", "Error", "Temp Whitelist Revoked For Group: " .. group)
				end
			end
		end, {
			help = "Temp Whitelist a Group",
			params = {
				{
					name = "Group Abbreviation",
					help = "Group Abbreviation",
				},
			},
		}, 1)
	end)
end)

function Log(log, flagsOverride)
	local flags = { console = true }
	if flagsOverride ~= nil then
		flags = flagsOverride
	end
	TriggerEvent("Logger:Info", "Queue", log, flags)
end

Citizen.CreateThread(function()
	while not queueActive do
		Citizen.Wait(1000)
	end

	if not exports["mythic-base"]:FetchComponent("WebAPI").Enabled then
		Log("^8Queue Disabled^7", { console = true })
		queueEnabled = false
		return
	end

	while GetResourceState("hardcap") ~= "stopped" do
		local state = GetResourceState("hardcap")
		if state == "missing" then
			break
		end

		if state == "started" then
			StopResource("hardcap")
			break
		end

		Citizen.Wait(5000)
	end

	Citizen.Wait(10000)

	while queueEnabled do
		if GetNumPlayerIndices() < MAX_PLAYERS and #Data.Queue > 0 and not (playerJoining or privPlayerJoining) then
			playerJoining = true
			QUEUE.Queue:Join(MAX_PLAYERS - GetNumPlayerIndices())
		end

		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while queueEnabled do
		for k, v in ipairs(Data.Queue) do
			if v.State == States.DISCONNECTED and not v:IsInGracePeriod() then
				QUEUE.Queue:Remove(k)
			end
		end
		Citizen.Wait(10000)
	end
end)
