function RegisterMiddleware()
    Middleware:Add("Characters:Creating", function(source, cData)
		return {{
			Apartment = 1
		}}
	end)

    Middleware:Add('Characters:Spawning', function(source)
        local player = exports['mythic-base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
		GlobalState[string.format("Apartment:Interior:%s", char:GetData("SID"))] = char:GetData("Apartment") or 1
    end, 2)

	Middleware:Add("Characters:Logout", function(source)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			TriggerClientEvent("Apartment:Client:Cleanup", source, GlobalState[string.format("%s:Property", source)])
			GlobalState[string.format("%s:Apartment", source)] = nil
			GlobalState[string.format("Apartment:Interior:%s", char:GetData("SID"))] = char:GetData("Apartment")
		end
	end)

	Middleware:Add("Characters:GetSpawnPoints", function(source, charId, cData)
		local spawns = {}

		local apt = _aptData[cData.Apartment or 1]
		table.insert(spawns, {
			id = string.format("APT:%s:%s", apt, cData.SID),
			label = apt.name,
			location = apt.interior.wakeup,
			icon = "building",
			event = "Apartment:SpawnInside",
		})

		return spawns
	end, 2)
end
