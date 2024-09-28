function RegisterChatCommands()
	Chat:RegisterAdminCommand("setcallsign", function(source, args, rawCommand)
		local newCallsign = args[2]
		local tPly = Fetch:SID(tonumber(args[1]))
		if tPly ~= nil then
			local target = tPly:GetData("Character")
			if
				Jobs.Permissions:HasJob(tPly:GetData("Source"), "police")
				or Jobs.Permissions:HasJob(tPly:GetData("Source"), "ems")
			then
				if MDT.People:Update(-1, target:GetData("SID"), "Callsign", newCallsign) then
					Chat.Send.System:Single(source, "Updated Callsign")
				else
					Chat.Send.System:Single(source, "Error Updating Callsign")
				end
			else
				Chat.Send.System:Single(source, "Target is not Emergency Personnel")
			end
		else
			Chat.Send.System:Single(source, "Invalid State ID")
		end
	end, {
		help = "Assign a callsign to an emergency worker",
		params = {
			{
				name = "Target",
				help = "State ID",
			},
			{
				name = "Callsign",
				help = "The callsign you want to assign to the player. This must be unique",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("reclaimcallsign", function(source, args, rawCommand)
		Database.Game:findOneAndUpdate({
			collection = "characters",
			query = {
				Callsign = args[1],
			},
			update = {
				['$set'] = {
					Callsign = false,
				},
			},
			options = {
				projection = {
					SID = 1,
					User = 1,
					First = 1,
					Last = 1,
				},
			},
		}, function(success, results)
			if success and results then
				local plyr = Fetch:SID(results.SID)
				if plyr then
					local char = plyr:GetData("Character")
					if char then
						char:SetData("Callsign", false)
					end
				end

				Chat.Send.System:Single(source, string.format("Callsign Reclaimed From %s %s (%s)", results.First, results.Last, results.SID))
			else
				Chat.Send.System:Single(source, "Nobody With That Callsign")
			end
		end)
	end, {
		help = "Force Reclaim a Callsign",
		params = {
			{
				name = "Callsign",
				help = "The callsign you want to reclaim.",
			},
		},
	}, 1)

	Chat:RegisterCommand(
		"mdt",
		function(source, args, rawCommand)
			TriggerClientEvent("MDT:Client:Toggle", source)
		end,
		{
			help = "Open MDT",
		},
		0,
		{
			{
				Id = "police",
			},
			{
				Id = "government",
			},
			{
				Id = "ems",
			},
		}
	)

	Chat:RegisterAdminCommand("addmdtsysadmin", function(source, args, rawCommand)
		local targetStateId = math.tointeger(args[1])
		local success = MDT.People:Update(-1, targetStateId, "MDTSystemAdmin", true)
		if success then
			Chat.Send.System:Single(source, "Granted System Admin to State ID: " .. targetStateId)
		else
			Chat.Send.System:Single(source, "Error Granting System Admin")
		end
	end, {
		help = "Grant MDT System Admin [Danger!]",
		params = {
			{
				name = "Target State ID",
				help = "State ID of Character",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("removemdtsysadmin", function(source, args, rawCommand)
		local targetStateId = math.tointeger(args[1])
		local success = MDT.People:Update(-1, targetStateId, "MDTSystemAdmin", false)
		if success then
			Chat.Send.System:Single(source, "Revoked System Admin from State ID: " .. targetStateId)
		else
			Chat.Send.System:Single(source, "Error Revoking System Admin")
		end
	end, {
		help = "Revoke MDT System Admin",
		params = {
			{
				name = "Target State ID",
				help = "State ID of Character",
			},
		},
	}, 1)

	Chat:RegisterCommand(
		"clearblips",
		function(source, args, rawCommand)
			TriggerClientEvent("EmergencyAlerts:Client:Clear", source)
		end,
		{
			help = "Clear Emergency Alert Blips",
		},
		0,
		{
			{
				Id = "police",
			},
			{
				Id = "ems",
			},
			{
				Id = "tow",
			}
		}
	)
end
