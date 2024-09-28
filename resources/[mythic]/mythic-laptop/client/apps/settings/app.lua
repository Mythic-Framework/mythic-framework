RegisterNUICallback("UpdateSetting", function(data, cb)
	cb("OK")
	_settings[data.type] = data.val
	Callbacks:ServerCallback("Laptop:Settings:Update", data)
end)