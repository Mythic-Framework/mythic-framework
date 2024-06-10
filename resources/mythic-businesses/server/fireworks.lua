AddEventHandler("Businesses:Server:Startup", function()
    Chat:RegisterAdminCommand("firework", function(source, args, rawCommand)
        local fw = tonumber(args[1])
        if fw >= 1 and fw <= 7 then
            Callbacks:ClientCallback(source, "Fireworks:Use", fw, function(x, y, z)
                TriggerClientEvent("Fireworks:Client:Play", -1, fw, x, y, z)
            end)
        end
	end, {
		help = "[Admin] Place Fireworks",
		params = {
			{
				name = "Id",
				help = "1-7",
			},
		},
	}, 1)
end)