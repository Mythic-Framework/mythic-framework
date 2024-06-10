_inInvPoly = nil

RegisterNetEvent("Inventory:Client:PolySetup", function(locs)
	for k, v in ipairs(locs) do
		local data = GlobalState[string.format("Inventory:%s", v)]
		if data ~= nil then
			if data.data ~= nil then
				data.data.isInventory = true 
			end

			if data.type == "box" then
				Polyzone.Create:Box(data.id, data.coords, data.length, data.width, data.options, data.data)
			elseif data.type == "poly" then
				Polyzone.Create:Poly(data.id, data.points, data.options, data.data)
			else
				Polyzone.Create:Circle(data.id, data.coords, data.radius, data.options, data.data)
			end
		end
	end
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if GlobalState[string.format("Inventory:%s", id)] ~= nil then
		LocalPlayer.state:set("_inInvPoly", data, true)
		_inInvPoly = data
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if LocalPlayer.state.loggedIn and GlobalState[string.format("Inventory:%s", id)] ~= nil then
		if
			SecondInventory ~= nil
			and SecondInventory.owner == data.owner
			and SecondInventory.invType == data.invType
		then
			Inventory.Close:All()
		end
		LocalPlayer.state:set("_inInvPoly", nil, true)
		_inInvPoly = nil
	end
end)
