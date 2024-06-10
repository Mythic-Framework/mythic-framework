function RegisterChatCommands()
	Chat:RegisterAdminCommand("acam", function(source, args, rawCommand)
		if (tonumber(args[1])) then
			CCTV:View(source, tonumber(args[1]))
		else
			CCTV:ViewGroup(source, args[1])
		end
	end, {
		help = "View CCTV Cam",
		params = {
			{
				name = "Cam ID",
				help = string.format("ID Of Camera (1 - %s)", #Config.Cameras),
			},
		},
	}, 1)
end
