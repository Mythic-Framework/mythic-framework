function RegisterChatCommands()
	Chat:RegisterStaffCommand("heal", function(source, args, rawCommand)
		local admin = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):SID(tonumber(args[1]))
		if player ~= nil then
			local char = player:GetData("Character")
			if char ~= nil and ((char:GetData("Source") ~= admin:GetData("Source")) or admin.Permissions:IsAdmin()) then
				Logger:Warn(
					"Damage",
					string.format("%s [%s] Used Admin Revive On %s [%s] - Character %s %s (%s)", admin:GetData("Name"), admin:GetData("AccountID"), player:GetData("Name"), player:GetData("AccountID"), char:GetData('First'), char:GetData('Last'), char:GetData('SID')),
					{
						console = false,
						file = false,
						database = true,
						discord = {
							embed = true,
							type = "error",
							webhook = GetConvar("discord_admin_webhook", ''),
						},
					}
				)
				Execute:Client(char:GetData("Source"), "Damage", "Heal")
				Execute:Client(source, "Notification", "Success", "Player Healed", 3000, "heart-pulse")
			else
				Chat.Send.System:Single(source, "Invalid State ID")
			end
		else
			Chat.Send.System:Single(source, "Invalid State ID")
		end
	end, {
		help = "Heals Player",
		params = {
			{
				name = "Target",
				help = "State ID of Who You Want To Heal",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("debugdamage", function(source, args, rawCommand)
		TriggerClientEvent("Damage:Client:Debug", source)
	end, {
		help = "Enable Damage Debug",
	})

	Chat:RegisterAdminCommand("die", function(source, args, rawCommand)
		TriggerClientEvent("Damage:Client:Die", source)
	end, {
		help = "Enable Damage Debug",
	})
end

RegisterServerEvent("Damage:Admin:HealSource")
AddEventHandler("Damage:Admin:HealSource", function()
	local src = source
	local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(src)
	if player ~= nil then
		local char = player:GetData("Character")
		if char ~= nil then
			return Damage:Heal(char, false)
		end
	end
end)
