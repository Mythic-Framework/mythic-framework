COMPONENTS.Execute = {
	_name = "base",
	Client = function(self, source, component, method, ...)
		TriggerClientEvent("Execute:Client:Component", source, component, method, ...)
	end,
}

RegisterNetEvent("Execute:Server:Log", function(component, method, ...)
	local src = source
end)