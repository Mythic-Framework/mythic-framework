local _ran = false

function Startup()
	if _ran then
		return
	end
	_ran = true
	PHONE_APPS = {}
	for k, v in ipairs(_appData) do
		PHONE_APPS[v.name] = v
	end
end
