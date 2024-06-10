RegisterNUICallback("UpdateSetting", function(data, cb)
	cb("OK")
	_settings[data.type] = data.val
	Callbacks:ServerCallback("Phone:Settings:Update", data)
end)
RegisterNUICallback("TestSound", function(data, cb)
	cb("OK")
	Sounds.Play:Distance(10, data.val, 0.1 * (_settings.volume / 100))
end)
