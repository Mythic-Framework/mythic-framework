local _ran = false

function Startup()
	if _ran then
		return
	end
	_ran = true
	LAPTOP_APPS = {}
	for k, v in ipairs(_appData) do
		LAPTOP_APPS[v.name] = v
	end
end
