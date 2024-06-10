local _nonLog = {
	["Logger"] = true,
	["Notification"] = true,
	["Animations"] = true,
	["Phone"] = true,
}

RegisterNetEvent("Execute:Client:Component", function(component, method, ...)
	if not _nonLog[component] then
		TriggerServerEvent("Execute:Server:Log", component, method, ...)
	end

	if COMPONENTS[component] ~= nil then
		if COMPONENTS[component][method] ~= nil then
			COMPONENTS[component][method](COMPONENTS[component][method], ...)
		else
			COMPONENTS.Logger:Warn("Execute", "Attempted To Execute Non-Method Attribute", { console = true })
		end
	else
		COMPONENTS.Logger:Warn(
			"Execute",
			"Attempted To Execute Method Attribute In Non-Existing Component",
			{ console = true }
		)
	end
end)
