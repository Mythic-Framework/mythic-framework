RegisterServerEvent("Error:Server:Report", function(resource, ...)
	COMPONENTS.Logger:Error("Client Error", string.format("Script Error In %s", resource), {
		console = true,
		file = true,
		database = true,
		discord = {
			type = "error",
			webhook = GetConvar("discord_error_webhook", ''),
			content = string.format("```%s```", ...)
		},
	})
end)
