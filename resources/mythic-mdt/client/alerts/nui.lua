RegisterNUICallback("CloseAlerts", function(data, cb)
	cb("OK")
	EmergencyAlerts:Close()
end)

RegisterNUICallback("RouteAlert", function(data, cb)
	cb("OK")
	if data.location then
		UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
		EmergencyAlerts:Close()

		if data.blip then
			local f = false
			for k, v in ipairs(_alertBlips) do
				if v.id == data.blip.id then
					v.time = GlobalState["OS:Time"] + data.blip.duration
					f = true
					break
				end
			end

			if not f then
				local eB = Blips:Add(
					data.blip.id,
					data.title,
					data.location,
					data.blip.icon,
					data.blip.color,
					data.blip.size,
					2
				)
				table.insert(_alertBlips, {
					id = data.blip.id,
					time = GlobalState["OS:Time"] + data.blip.duration,
					blip = eB,
				})
				SetBlipFlashes(eB, data.isPanic)
			end
		end

		ClearGpsPlayerWaypoint()
		SetNewWaypoint(data.location.x, data.location.y)
		Notification:Info("Alert Location Marked")
	end
end)

RegisterNUICallback("ViewCamera", function(data, cb)
	cb('OK')
	if data.camera then
		UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
		EmergencyAlerts:Close()
		Callbacks:ServerCallback("CCTV:ViewGroup", data.camera)
	end
end)

RegisterNUICallback("ChangeUnit", function(data, cb)
	cb("OK")
	UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	TriggerServerEvent("EmergencyAlerts:Server:ChangeUnit", data)
end)

RegisterNUICallback("OperateUnder", function(data, cb)
	cb("OK")
	UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	TriggerServerEvent("EmergencyAlerts:Server:OperateUnder", data)
end)

RegisterNUICallback("BreakOff", function(data, cb)
	cb("OK")
	UISounds.Play:FrontEnd(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
	TriggerServerEvent("EmergencyAlerts:Server:BreakOff", data)
end)
