function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Jail:SpawnJailed", function(source, data, cb)
		Routing:RoutePlayerToGlobalRoute(source)
		local char = Fetch:Source(source):GetData("Character")
		TriggerClientEvent("Jail:Client:EnterJail", source)
		cb(true)
	end)

	Callbacks:RegisterServerCallback("Jail:Validate", function(source, data, cb)
		if not Jail:IsJailed(source) then
			cb(false)
		else
			if data.type == "logout" then
				cb(true)
			else
				cb(false)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Jail:RetreiveItems", function(source, data, cb)
		Inventory.Holding:Take(source)
	end)

	Callbacks:RegisterServerCallback("Jail:Release", function(source, data, cb)
		cb(Jail:Release(source))
	end)

	Callbacks:RegisterServerCallback("Jail:StartWork", function(source, data, cb)
		Labor.Duty:On("Prison", source, false)
	end)

	Callbacks:RegisterServerCallback("Jail:QuitWork", function(source, data, cb)
		Labor.Duty:Off("Prison", source, false, false)
	end)

	Callbacks:RegisterServerCallback("Jail:MakeItem", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if data == "food" or data == "drink" then
			Inventory:AddItem(char:GetData("SID"), string.format("prison_%s", data), 1, {}, 1)
		end
	end)
end
