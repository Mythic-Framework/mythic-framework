function RegisterCommands()
	Chat:RegisterStaffCommand("logout", function(source, args, rawCommand)
		exports["mythic-base"]:FetchComponent("Execute"):Client(source, "Characters", "Logout")
	end, {
		help = "Logout",
	}, 0)

	Chat:RegisterAdminCommand("addrep", function(source, args, rawCommand)
		local player = Fetch:SID(tonumber(args[1]))
		if player ~= nil then
			Reputation.Modify:Add(player:GetData("Source"), args[2], tonumber(args[3]))
			Chat.Send.System:Single(source, string.format("%s Rep Added For %s To State ID %s", args[3], args[2], args[1]))
		else
			Chat.Send.System:Single(source, "Invalid Target")
		end
	end, {
		help = "Add Specified Reputation To Specified Player",
		params = {
			{
				name = "Target",
				help = "State ID of who you want to give the reputation to",
			},
			{
				name = "ID",
				help = "ID of the reputation you want to give",
			},
			{
				name = "Amount",
				help = "Amount of reputation to give",
			},
		},
	}, 3)

	Chat:RegisterAdminCommand("remrep", function(source, args, rawCommand)
		local player = Fetch:SID(tonumber(args[1]))
		if player ~= nil then
			Reputation.Modify:Remove(player:GetData("Source"), args[2], tonumber(args[3]))
			Chat.Send.System:Single(source, string.format("%s Rep Removed For %s From State ID %s", args[3], args[2], args[1]))
		else
			Chat.Send.System:Single(source, "Invalid Target")
		end
	end, {
		help = "Remove Specified Reputation To Specified Player",
		params = {
			{
				name = "Target",
				help = "State ID of who you want to remove the reputation from",
			},
			{
				name = "ID",
				help = "ID of the reputation you want to take",
			},
			{
				name = "Amount",
				help = "Amount of reputation to take",
			},
		},
	}, 3)

	Chat:RegisterAdminCommand("phoneperm", function(source, args, rawCommand)
		local player = Fetch:SID(tonumber(args[1]))
		local app, perm = args[2], args[3]

		if player ~= nil then
			local char = player:GetData("Character")
			if char ~= nil then
				local phonePermissions = char:GetData("PhonePermissions")
				if phonePermissions[app] then
					if phonePermissions[app][perm] ~= nil then
						if phonePermissions[app][perm] then
							phonePermissions[app][perm] = false
							Chat.Send.System:Single(source, "Disabled Permission")
						else
							phonePermissions[app][perm] = true
							Chat.Send.System:Single(source, "Enabled Permission")
						end

						char:SetData("PhonePermissions", phonePermissions)
					else
						Chat.Send.System:Single(source, "Permission Doesn't Exist")
					end
				else
					Chat.Send.System:Single(source, "App Doesn't Exist")
				end
			end
		else
			Chat.Send.System:Single(source, "Invalid Target")
		end
	end, {
		help = "Add Specified App Permission",
		params = {
			{
				name = "Target",
				help = "State ID",
			},
			{
				name = "App ID",
				help = "ID of the app",
			},
			{
				name = "Perm ID",
				help = "Permission",
			},
		},
	}, 3)
end
