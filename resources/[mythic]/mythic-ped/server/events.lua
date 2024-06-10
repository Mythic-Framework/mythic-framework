RegisterServerEvent("Ped:EnterCreator", function()
	local routeId = Routing:RequestRouteId("ped:" .. source)
	Routing:AddPlayerToRoute(source, routeId)
end)

RegisterServerEvent("Ped:LeaveCreator", function()
	Routing:RoutePlayerToGlobalRoute(source)
end)
