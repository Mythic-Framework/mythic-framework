RegisterNetEvent("Phone:Client:Messages:Notify")
AddEventHandler("Phone:Client:Messages:Notify", function(message)
	SendNUIMessage({
		type = "ADD_DATA",
		data = {
			type = "messages",
			data = message,
		},
	})
	if message.contact ~= nil then
		Phone.Notification:Add(message.contact.name, message.message, message.time, 6000, "messages", {
			view = "convo/" .. message.number,
		}, nil)
	else
		Phone.Notification:Add(message.number, message.message, message.time, 6000, "messages", {
			view = "convo/" .. message.number,
		}, nil)
	end
end)
RegisterNUICallback("SendMessage", function(data, cb)
	cb("OK")
	Callbacks:ServerCallback("Phone:Messages:SendMessage", data)
end)
RegisterNUICallback("ReadConvo", function(data, cb)
	cb("OK")
	Callbacks:ServerCallback("Phone:Messages:ReadConvo", data)
end)
RegisterNUICallback("DeleteConvo", function(data, cb)
	cb("OK")
	Callbacks:ServerCallback("Phone:Messages:DeleteConvo", data)
end)
