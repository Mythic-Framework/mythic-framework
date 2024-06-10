RegisterNUICallback("Dyn8:SearchProperty", function(data, cb)
	Callbacks:ServerCallback("Phone:Dyn8:Search", data, cb)
end)

RegisterNUICallback("Dyn8:MarkProperty", function(data, cb)
	local prop = GlobalState[string.format("Property:%s", data)]
	if prop ~= nil then
		ClearGpsPlayerWaypoint()
		SetNewWaypoint(prop.location.front.x, prop.location.front.y)
	else
		cb(false)
	end
	Callbacks:ServerCallback("Phone:Dyn8:Search", data, cb)
end)

RegisterNUICallback("Dyn8:SellProperty", function(data, cb)
	cb('OK')
	--Callbacks:ServerCallback("Phone:Dyn8:Sell", data, cb)
end)

RegisterNUICallback("Dyn8:CheckCredit", function(data, cb)
	cb('OK')
	--Callbacks:ServerCallback("Phone:Dyn8:CheckCredit", data, cb)
end)