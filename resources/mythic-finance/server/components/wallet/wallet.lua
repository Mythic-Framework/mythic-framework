AddEventHandler("Finance:Server:Startup", function()
	Callbacks:RegisterServerCallback("Wallet:GetCash", function(source, data, cb)
		cb(Wallet:Get(source))
	end)

	Chat:RegisterCommand("cash", function(source, args, rawCommand)
		ShowCash(source)
	end, {
		help = "Show Current Cash",
	})

	Chat:RegisterAdminCommand("addcash", function(source, args, rawCommand)
		local addingAmount = tonumber(args[1])
		if addingAmount and addingAmount > 0 then
			Wallet:Modify(source, addingAmount)
		end
	end, {
		help = "Give Cash To Yourself",
		params = {
			{
				name = "Amount",
				help = "Amount of cash to give",
			},
		},
	}, 1)

	Chat:RegisterCommand("givecash", function(source, args, rawCommand)
		local target = tonumber(args[1])
		if target and target > 0 then
			local player = Fetch:Source(source)
			local targetPlayer = Fetch:SID(target)
			if player and targetPlayer and targetPlayer:GetData("Source") ~= player:GetData("Source") then
				local targetCharacter = targetPlayer:GetData("Character")
				if targetCharacter then
					local playerCoords = GetEntityCoords(GetPlayerPed(source))
					local targetCoords = GetEntityCoords(GetPlayerPed(targetPlayer:GetData("Source")))
					if #(playerCoords - targetCoords) <= 5.0 then
						local amount = math.tointeger(args[2])
						if amount and amount > 0 then
							if Wallet:Modify(source, -amount, true) then
								if Wallet:Modify(targetPlayer:GetData("Source"), amount, true) then
									TriggerClientEvent('Finance:Client:HandOffCash', source)
									Execute:Client(
										source,
										"Notification",
										"Success",
										"You Gave $" .. formatNumberToCurrency(amount) .. " in Cash"
									)
									Execute:Client(
										targetPlayer:GetData("Source"),
										"Notification",
										"Success",
										"You Just Received $" .. formatNumberToCurrency(amount) .. " in Cash"
									)
									return
								else
									return Chat.Send.System:Single(source, "Error")
								end
							else
								return Chat.Send.System:Single(source, "Not Enough Cash")
							end
						else
							return Chat.Send.System:Single(source, "Invalid Amount")
						end
					else
						return Chat.Send.System:Single(source, "Target Not Nearby")
					end
				end
			end
		end
		Chat.Send.System:Single(source, "Invalid State ID")
	end, {
		help = "Give Your Cash to a Person",
		params = {
			{
				name = "State ID",
				help = "The person you want to give the cash to has to be nearby",
			},
			{
				name = "Amount",
				help = "The amount of money to give",
			},
		},
	}, 2)
end)

function ShowCash(source)
	Execute:Client(
		source,
		"Notification",
		"Success",
		"You have $" .. formatNumberToCurrency(Wallet:Get(source)),
		2500,
		"money-bill-wave"
	)
end

RegisterServerEvent("Wallet:ShowCash", function()
	local source = source
	ShowCash(source)
end)
