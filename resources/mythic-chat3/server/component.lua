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
				print("Invalid Command: " .. commandName)
				--Chat.Send.Server:Single(source, "Invalid Command: " .. commandName)
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
				TriggerClientEvent("chat:addMessage", -1, {
					time = os.time(),
					type = "ooc",
					message = message,
					author = {
						First = char:GetData("First"),
						Last = char:GetData("Last"),
						SID = char:GetData("SID"),
					},
				})
			end
		end
	end,
	Server = {
		All = function(self, message)
			TriggerClientEvent("chat:addMessage", -1, {
				time = os.time(),
				type = "server",
				message = message,
			})
		end,
		Single = function(self, source, message)
			TriggerClientEvent("chat:addMessage", source, {
				time = os.time(),
				type = "server",
				message = message,
			})
		end,
	},
	Broadcast = {
		All = function(self, author, message)
			TriggerClientEvent("chat:addMessage", -1, {
				time = os.time(),
				type = "broadcast",
				message = message,
			})
		end,
	},
	System = {
		All = function(self, message)
			TriggerClientEvent("chat:addMessage", -1, {
				time = os.time(),
				type = "system",
				message = message,
			})
		end,
		Single = function(self, source, message)
			TriggerClientEvent("chat:addMessage", source, {
				time = os.time(),
				type = "system",
				message = message,
			})
		end,
		Broadcast = function(self, message)
			TriggerClientEvent("chat:addMessage", -1, {
				time = os.time(),
				type = "broadcast",
				message = message,
			})
		end,
	},
	Services = {
		Emergency = function(self, source, message)
			local char = Fetch:Source(source):GetData("Character")
			TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", source, "call911", {
				details = string.format("%s | %s", char:GetData("SID"), char:GetData("Phone")),
			})

			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty

				if src == source or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						time = os.time(),
						type = "911",
						message = message,
						author = {
							First = char:GetData("First"),
							Last = char:GetData("Last"),
							Phone = char:GetData("Phone"),
							SID = char:GetData("SID"),
						},
					})
				end
			end
		end,
		EmergencyAnonymous = function(self, source, message)
			local plyr = Fetch:Source(source)
			local char = plyr:GetData("Character")

			TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", source, "call911anon")
			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty
				if src == source or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						time = os.time(),
						type = "911",
						message = message,
						author = {
							Anonymous = true,
							SID = (plyr.Permissions:IsStaff() or plyr.Permissions:IsAdmin()) and char:GetData("SID")
								or nil,
						},
					})
				end
			end
		end,
		EmergencyRespond = function(self, source, target, message)
			local char = Fetch:Source(source):GetData("Character")
			local tPlyr = Fetch:Source(target)
			if tPlyr ~= nil then
				tChar = tPlyr:GetData("Character")
				local name = string.format("%s %s", char:GetData("First"), char:GetData("Last"))
				local str = string.format("%s -> %s", name, tChar:GetData("SID"))
				for k, v in pairs(Fetch:All()) do
					local src = v:GetData("Source")
					local duty = Player(src).state.onDuty
					if src == target or (duty == "police" or duty == "ems") then
						TriggerClientEvent("chat:addMessage", src, {
							time = os.time(),
							type = "911",
							message = message,
							author = {
								First = char:GetData("First"),
								Last = char:GetData("Last"),
								Phone = char:GetData("Phone"),
								SID = char:GetData("SID"),
								Reply = tChar:GetData("SID"),
							},
						})
					end
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
						time = os.time(),
						type = "311",
						message = message,
						author = {
							First = char:GetData("First"),
							Last = char:GetData("Last"),
							Phone = char:GetData("Phone"),
							SID = char:GetData("SID"),
						},
					})
				end
			end
		end,
		NonEmergencyAnonymous = function(self, source, message)
			local plyr = Fetch:Source(source)
			local char = plyr:GetData("Character")

			TriggerEvent("EmergencyAlerts:Server:ServerDoPredefined", source, "call311anon")
			for k, v in pairs(Fetch:All()) do
				local src = v:GetData("Source")
				local duty = Player(src).state.onDuty
				if src == source or (duty == "police" or duty == "ems") then
					TriggerClientEvent("chat:addMessage", src, {
						time = os.time(),
						type = "311",
						message = message,
						author = {
							Anonymous = true,
							SID = (plyr.Permissions:IsStaff() or plyr.Permissions:IsAdmin()) and char:GetData("SID")
								or nil,
						},
					})
				end
			end
		end,
		NonEmergencyRespond = function(self, source, target, message)
			local char = Fetch:Source(source):GetData("Character")
			local tPlyr = Fetch:Source(target)
			if tPlyr ~= nil then
				tChar = tPlyr:GetData("Character")
				local name = string.format("%s %s", char:GetData("First"), char:GetData("Last"))
				local str = string.format("%s -> %s", name, tChar:GetData("SID"))
				for k, v in pairs(Fetch:All()) do
					local src = v:GetData("Source")
					local duty = Player(src).state.onDuty
					if src == target or (duty == "police" or duty == "ems") then
						TriggerClientEvent("chat:addMessage", src, {
							time = os.time(),
							type = "311",
							message = message,
							author = {
								First = char:GetData("First"),
								Last = char:GetData("Last"),
								Phone = char:GetData("Phone"),
								SID = char:GetData("SID"),
								Reply = tChar:GetData("SID"),
							},
						})
					end
				end
			end
		end,
		Dispatch = function(self, source, message)
			TriggerClientEvent("chat:addMessage", source, {
				time = os.time(),
				type = "dispatch",
				message = message,
			})
		end,
		TestResult = function(self, source, message)
			TriggerClientEvent("chat:addMessage", source, {
				time = os.time(),
				type = "tests",
				message = message,
			})
		end,
	},
}

AddEventHandler("Chat:Server:Server", function(source, message)
	TriggerClientEvent("chat:addMessage", source, {
		time = os.time(),
		type = "server",
		message = message,
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
