local _911Cds = {}
local _311Cds = {}

function RegisterCommands()
	Chat:RegisterCommand("911", function(source, args, rawCommand)
		if #rawCommand:sub(4) > 0 then
			if not Player(source).state.isCuffed and not Player(source).state.isDead then
				if _911Cds[source] == nil or os.time() >= _911Cds[source] then
					Chat.Send.Services:Emergency(source, rawCommand:sub(4))
					_911Cds[source] = os.time() + (60 * 1)
					TriggerClientEvent("Animations:Client:DoPDCallEmote", source)
				else
					Chat.Send.System:Single(source, "You've Called 911 Recently")
				end
			else
				Chat.Send.System:Single(source, "You Find It Difficult To Call 911")
			end
		end
	end, {
		help = "Make 911 Call",
		params = {
			{
				name = "Message",
				help = "The Message You Want To Send To 911",
			},
		},
	}, -1)

	Chat:RegisterCommand("911a", function(source, args, rawCommand)
		if #rawCommand:sub(5) > 0 then
			if not Player(source).state.isCuffed and not Player(source).state.isDead then
				if _911Cds[source] == nil or os.time() >= _911Cds[source] then
					Chat.Send.Services:EmergencyAnonymous(source, rawCommand:sub(5))
					_911Cds[source] = os.time() + (60 * 1)
					TriggerClientEvent("Animations:Client:DoPDCallEmote", source)
				else
					Chat.Send.System:Single(source, "You've Called 911 Recently")
				end
			else
				Chat.Send.System:Single(source, "You Find It Difficult To Call 911")
			end
		end
	end, {
		help = "Make Anonymous 911 Call",
		params = {
			{
				name = "Message",
				help = "The Message You Want To Send To 911",
			},
		},
	}, -1)

	Chat:RegisterCommand(
		"911r",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local target = Fetch:SID(tonumber(args[1]))
				if target ~= nil then
					Chat.Send.Services:EmergencyRespond(source, target:GetData("Source"), args[2])
				else
					Chat.Send.System:Single(source, "Invalid Target 2")
				end
			else
				Chat.Send.System:Single(source, "Invalid Target 1")
			end
		end,
		{
			help = "Respond To 911 Caller",
			params = {
				{
					name = "Target",
					help = "State ID of the person you want to reply to",
				},
				{
					name = "Message",
					help = "[WRAP IN QUOTES] Message you want to send",
				},
			},
		},
		2,
		{
			{
				Id = "police",
			},
			{
				Id = "ems",
			},
		}
	)

	Chat:RegisterCommand("311", function(source, args, rawCommand)
		if #rawCommand:sub(4) > 0 then
			if not Player(source).state.isCuffed and not Player(source).state.isDead then
				if _311Cds[source] == nil or os.time() >= _311Cds[source] then
					Chat.Send.Services:NonEmergency(source, rawCommand:sub(4))
					_311Cds[source] = os.time() + (60 * 1)
					TriggerClientEvent("Animations:Client:DoPDCallEmote", source)
				else
					Chat.Send.System:Single(source, "You've Called 311 Recently")
				end
			else
				Chat.Send.System:Single(source, "You Find It Difficult To Call 311")
			end
		end
	end, {
		help = "Make 311 Call",
		params = {
			{
				name = "Message",
				help = "The Message You Want To Send To 311",
			},
		},
	}, -1)

	Chat:RegisterCommand("311a", function(source, args, rawCommand)
		if #rawCommand:sub(5) > 0 then
			if not Player(source).state.isCuffed and not Player(source).state.isDead then
				if _311Cds[source] == nil or os.time() >= _311Cds[source] then
					Chat.Send.Services:NonEmergencyAnonymous(source, rawCommand:sub(5))
					_311Cds[source] = os.time() + (60 * 1)
					TriggerClientEvent("Animations:Client:DoPDCallEmote", source)
				else
					Chat.Send.System:Single(source, "You've Called 311 Recently")
				end
			else
				Chat.Send.System:Single(source, "You Find It Difficult To Call 311")
			end
		end
	end, {
		help = "Make Anonymous 311 Call",
		params = {
			{
				name = "Message",
				help = "The Message You Want To Send To 311",
			},
		},
	}, -1)

	Chat:RegisterCommand("tems", function(source, args, rawCommand)
		TriggerClientEvent("EMS:Client:Test", source, source)
	end, {
		help = "Test",
	}, -1)

	Chat:RegisterCommand(
		"311r",
		function(source, args, rawCommand)
			if tonumber(args[1]) then
				local target = Fetch:SID(tonumber(args[1]))
				if target ~= nil then
					Chat.Send.Services:NonEmergencyRespond(source, target:GetData("Source"), args[2])
				else
					Chat.Send.System:Single(source, "Invalid Target 2")
				end
			else
				Chat.Send.System:Single(source, "Invalid Target 1")
			end
		end,
		{
			help = "Respond To 311 Caller",
			params = {
				{
					name = "Target",
					help = "State ID of the person you want to reply to",
				},
				{
					name = "Message",
					help = "[WRAP IN QUOTES] Message you want to send",
				},
			},
		},
		2,
		{
			{
				Id = "police",
			},
			{
				Id = "ems",
			},
		}
	)
end
