AddEventHandler("Characters:Client:Spawn", function()
	CreateThread(function()
		while _loggedIn do
			Callbacks:ServerCallback("Phone:Email:DeleteExpired", {}, function(ids)
				for k, v in ipairs(ids) do
					print(("^2Removing %s From NUI"):format(v))
					Phone.Data:Remove("emails", v)
				end
			end)
			Wait(1e4)
		end
	end)
end)

RegisterNetEvent("Phone:Client:Email:Receive")
AddEventHandler("Phone:Client:Email:Receive", function(email)
	SendNUIMessage({
		type = "ADD_DATA",
		data = {
			type = "emails",
			data = email,
		},
	})
	Wait(1e3)
	Phone.Notification:Add(email.sender, email.subject, email.time, 6000, "email", {
		view = "view/" .. email._id,
	}, nil)
end)

RegisterNetEvent("Phone:Client:Email:Delete")
AddEventHandler("Phone:Client:Email:Delete", function(email)
	SendNUIMessage({
		type = "REMOVE_DATA",
		data = {
			type = "emails",
			id = email,
		},
	})
end)

RegisterNUICallback("ReadEmail", function(data, cb)
	cb("OK")
	Callbacks:ServerCallback("Phone:Email:Read", data)
end)

RegisterNUICallback("DeleteEmail", function(data, cb)
	cb("OK")
	Callbacks:ServerCallback("Phone:Email:Delete", data, function(res)
		cb(res)
	end)
end)

RegisterNUICallback("GPSRoute", function(data, cb)
	cb("OK")
	SetNewWaypoint(data.location.x, data.location.y)
end)

RegisterNUICallback("Hyperlink", function(data, cb)
	cb("OK")
	TriggerServerEvent(data.hyperlink.event, data.hyperlink.data, data.id)
end)

