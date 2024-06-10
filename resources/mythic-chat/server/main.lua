AddEventHandler("Chat:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Chat", {
		"Fetch",
		"Middleware",
		"Chat",
		"Jobs",
		"Logger",
		"EmergencyAlerts",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterMiddleware()

		Chat:RegisterCommand("me", function(source, args, rawCommand)
			if #args > 0 then
				local message = table.concat(args, " ")
				TriggerClientEvent("Chat:Client:ReceiveMe", -1, source, GetGameTimer(), message)
			else
				Chat.Send.Server:Single(source, "Invalid Number Of Arguments")
			end
		end, {
			help = "Let People Know What You are Doing",
			params = {},
		}, -1)
	end)
end)

function RegisterMiddleware()
	Middleware:Add("Characters:Spawning", function(source)
		Chat.Refresh:Commands(source)
	end, 3)
end

AddEventHandler("Job:Server:DutyRemove", function(dutyData, source)
	Chat.Refresh:Commands(source)
end)

AddEventHandler("Job:Server:DutyAdd", function(dutyData, source)
	Chat.Refresh:Commands(source)
end)

CHAT = {
	_required = { "Send" },
	Refresh = {
		Commands = function(self, source)
			local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
			if player ~= nil then
				local pData = player:GetData()
				local char = player:GetData("Character")
				if char ~= nil then
					local cData = char:GetData()
					local myDuty = Player(source).state.onDuty
					TriggerClientEvent("chat:resetSuggestions", source)
					for k, command in pairs(commandSuggestions) do
						local commandString = ("/" .. k)
						--TriggerClientEvent('chat:addSuggestion', source, commandString, '')
						if IsPlayerAceAllowed(source, ("command.%s"):format(k)) then
							if commands[k] ~= nil then
								if commands[k].admin then
									if player.Permissions:IsAdmin() then
										TriggerClientEvent(
											"chat:addSuggestion",
											source,
											commandString,
											command.help,
											command.params
										)
									else
										TriggerClientEvent("chat:removeSuggestion", source, commandString)
									end
								elseif commands[k].staff then
									if player.Permissions:IsStaff() then
										TriggerClientEvent(
											"chat:addSuggestion",
											source,
											commandString,
											command.help,
											command.params
										)
									else
										TriggerClientEvent("chat:removeSuggestion", source, commandString)
									end
								elseif commands[k].job ~= nil then
									local canUse = false
									for k2, v2 in pairs(commands[k].job) do
										if
											v2.Id == nil
											or (
												myDuty
												and myDuty == v2.Id
												and Jobs.Permissions:HasJob(
													source,
													v2.Id,
													v2.Workplace or false,
													v2.Grade or false,
													v2.Level or false
												)
											)
										then
											canUse = true
										end
									end

									if canUse then
										TriggerClientEvent(
											"chat:addSuggestion",
											source,
											commandString,
											command.help,
											command.params
										)
									else
										TriggerClientEvent("chat:removeSuggestion", source, commandString)
									end
								else
									TriggerClientEvent(
										"chat:addSuggestion",
										source,
										commandString,
										command.help,
										command.params
									)
								end
							else
								TriggerClientEvent("chat:addSuggestion", source, commandString, "")
							end
						end
					end
				end
			end
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Chat", CHAT)
end)

AddEventHandler("chatMessage", function(source, n, message)
	local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)

	if player and player:GetData("Character") then
		if starts_with(message, "/") then
			local command_args = stringsplit(message, " ")
			command_args[1] = string.gsub(command_args[1], "/", "")

			local commandName = command_args[1]
			if not commands[commandName] then
				Chat.Send.Server:Single(source, "Invalid Command")
			end
		end
	end
	CancelEvent()
end)

function CHAT.ClearAll(self)
	TriggerClientEvent("chat:clearChat", -1)
end

CHAT.Send = {
	OOC = function(self, source, message)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)

		local isStaff = player.Permissions:IsStaff()
		local special = ""
		if isStaff then
			special = " isStaff"
		end

		if player ~= nil then
			local char = player:GetData("Character")
			if char ~= nil then
				fal = char:GetData("First") .. " " .. char:GetData("Last")
				sid = char:GetData("SID")
				TriggerClientEvent("chat:addMessage", -1, {
					template = '<div class="chat-message ooc{4}"><div class="chat-message-header">[OOC] {0} (<b>{1}</b> | {2}):</div><div class="chat-message-body">{3}</div></div>',
					args = { fal, sid, source, message, special },
				})
			end
		end
	end,
	Server = {
		All = function(self, message)
			TriggerClientEvent("chat:addMessage", -1, {
				template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
				args = { message },
			})
		end,
		Single = function(self, source, message)
			TriggerClientEvent("chat:addMessage", source, {
				template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
				args = { message },
			})
		end,
	},
	Broadcast = {
		All = function(self, author, message)
			TriggerClientEvent("chat:addMessage", -1, {
				template = '<div class="chat-message"><div class="chat-message-header">[BROADCAST] {0}</div><div class="chat-message-body">{1}</div></div>',
				args = { author, message },
			})
		end,
	},
	System = {
		All = function(self, message)
			TriggerClientEvent("chat:addMessage", -1, {
				template = '<div class="chat-message system"><div class="chat-message-header">[SYSTEM]</div><div class="chat-message-body">{0}</div></div>',
				args = { message },
			})
		end,
		Single = function(self, source, message)
			TriggerClientEvent("chat:addMessage", source, {
				template = '<div class="chat-message system"><div class="chat-message-header">[SYSTEM]</div><div class="chat-message-body">{0}</div></div>',
				args = { message },
			})
		end,
		Help = function(self, source, message)
			TriggerClientEvent("chat:addMessage", source, {
				template = '<div class="chat-message help"><div class="chat-message-header">[INFO]</div><div class="chat-message-body">{0}</div></div>',
				args = { message },
			})
		end,
		Broadcast = function(self, message)
			TriggerClientEvent("chat:addMessage", -1, {
				template = '<div class="chat-message help"><div class="chat-message-header">[BROADCAST]</div><div class="chat-message-body">{0}</div></div>',
				args = { message },
			})
		end,
	},
	Services = {
		Emergency = function(self, source, message)
			local char = Fetch:Source(source):GetData("Character")
			TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", source, "call911", {
				details = string.format("%s | %s", char:GetData("SID"), char:GetData("Phone")),
			})

			local name = string.format("%s %s", char:GetData("First"), char:GetData("Last"))
			local str = string.format("(%s) %s | %s", char:GetData("SID"), name, char:GetData("Phone"))
			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty

				if src == source or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						template = '<div class="chat-message e911"><div class="chat-message-header">[911] {0}</div><div class="chat-message-body">{1}</div></div>',
						args = { str, message },
					})
				end
			end
		end,
		EmergencyAnonymous = function(self, source, message)
			TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", source, "call911anon")
			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty
				if src == source or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						template = '<div class="chat-message e911"><div class="chat-message-header">[Anonymous 911]</div><div class="chat-message-body">{0}</div></div>',
						args = { message },
					})
				end
			end
		end,
		EmergencyRespond = function(self, source, target, message)
			local char = Fetch:Source(source):GetData("Character")
			local tChar = Fetch:Source(target):GetData("Character")
			local name = string.format("%s %s", char:GetData("First"), char:GetData("Last"))
			local str = string.format("%s -> %s", name, tChar:GetData("SID"))
			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty
				if src == target or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						template = '<div class="chat-message e911 response"><div class="chat-message-header">[911r] {0}</div><div class="chat-message-body">{1}</div></div>',
						args = { str, message },
					})
				end
			end
		end,
		NonEmergency = function(self, source, message)
			local char = Fetch:Source(source):GetData("Character")
			TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", source, "call311", {
				details = string.format("%s | %s", char:GetData("SID"), char:GetData("Phone")),
			})

			local name = string.format("%s %s", char:GetData("First"), char:GetData("Last"))
			local str = string.format("(%s) %s | %s", char:GetData("SID"), name, char:GetData("Phone"))
			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty
				if src == source or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						template = '<div class="chat-message e311"><div class="chat-message-header">[311] {0}</div><div class="chat-message-body">{1}</div></div>',
						args = { str, message },
					})
				end
			end
		end,
		NonEmergencyAnonymous = function(self, source, message)
			TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", source, "call311anon")
			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty
				if src == source or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						template = '<div class="chat-message e311"><div class="chat-message-header">[Anonymous 311]</div><div class="chat-message-body">{0}</div></div>',
						args = { message },
					})
				end
			end
		end,
		NonEmergencyRespond = function(self, source, target, message)
			local char = Fetch:Source(source):GetData("Character")
			local tChar = Fetch:Source(target):GetData("Character")
			local name = string.format("%s %s", char:GetData("First"), char:GetData("Last"))
			local str = string.format("%s -> %s", name, tChar:GetData("SID"))
			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty
				if src == target or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						template = '<div class="chat-message e311 response"><div class="chat-message-header">[311r] {0}</div><div class="chat-message-body">{1}</div></div>',
						args = { str, message },
					})
				end
			end
		end,
		Dispatch = function(self, source, message)
			TriggerClientEvent("chat:addMessage", source, {
				template = '<div class="chat-message dispatch"><div class="chat-message-header">[Dispatch]</div><div class="chat-message-body">{0}</div></div>',
				args = { message },
			})
		end,
	},
}

AddEventHandler("Chat:Server:Server", function(source, message)
	TriggerClientEvent("chat:addMessage", source, {
		template = '<div class="chat-message server"><div class="chat-message-header">[SERVER]</div><div class="chat-message-body">{0}</div></div>',
		args = { message },
	})
	CancelEvent()
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end
