function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t={} ; i=1

	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end

local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function setVisualSettings(file)
	CreateThread(function()
		local settingsFile = LoadResourceFile(GetCurrentResourceName(), file)
		local lines = stringsplit(settingsFile, "\n")
		for k,v in ipairs(lines) do
			if not starts_with(v, '#') and not starts_with(v, '//') and (v ~= "" or v ~= " ") and #v > 1 then
				v = v:gsub("%s+", " ")
	
				local setting = stringsplit(v, " ")
	
				if setting[1] ~= nil and setting[2] ~= nil and tonumber(setting[2]) ~= nil then
					if setting[1] ~= 'weather.CycleDuration' then	
						Citizen.InvokeNative(GetHashKey('SET_VISUAL_SETTING_FLOAT') & 0xFFFFFFFF, setting[1], tonumber(setting[2])+.0)
					end
				end
			end
		end
	end)
end

CreateThread(function()
	local state = GetResourceKvpInt("VISUALS_TOGGLE") or 0
	if state == 1 then
		setVisualSettings("visualsettings.dat")
	end
end)

RegisterNetEvent("Visuals:Client:Toggle", function()
	local state = GetResourceKvpInt("VISUALS_TOGGLE") or 0

	local file = "defaultsettings.dat"
	if state == 0 then
		file = "visualsettings.dat"
	end

	setVisualSettings(file)

	if state == 0 then
		SetResourceKvpInt("VISUALS_TOGGLE", 1)
	else
		SetResourceKvpInt("VISUALS_TOGGLE", 0)
	end
end)