RegisterNetEvent("Phone:Client:IRC:Notify")
AddEventHandler("Phone:Client:IRC:Notify", function(message)
	SendNUIMessage({
		type = "ADD_DATA",
		data = {
			type = "irc-" .. message.channel,
			data = message,
		},
	})
	Wait(1e3)
	Phone.Notification:Add("New Message", "You received a message in #" .. message.channel, message.time, 6000, "irc", {
		view = "view/" .. message.channel,
	}, nil)
end)
RegisterNUICallback("GetIRCMessages", function(data, cb)
	Callbacks:ServerCallback("Phone:IRC:GetMessages", data, cb)
end)
RegisterNUICallback("SendIRCMessage", function(data, cb)
	cb("OK")
	Callbacks:ServerCallback("Phone:IRC:SendMessage", data)
end)
RegisterNUICallback("JoinIRCChannel", function(data, cb)
	Callbacks:ServerCallback("Phone:IRC:JoinChannel", data, cb)
end)
RegisterNUICallback("LeaveIRCChannel", function(data, cb)
	cb("OK")
	Callbacks:ServerCallback("Phone:IRC:LeaveChannel", data)
end)
