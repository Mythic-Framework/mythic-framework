local _predefined = {
	injuredPerson = {
		code = "10-47",
		title = "Injured Person",
		type = 2,
		isPanic = false,
		blip = {
			icon = 280,
			size = 1.2,
			color = 8,
			duration = (60 * 5),
		},
	},
	illegalHunting = {
		code = "10-35",
		title = "Illegal Hunting",
		type = 1,
		isPanic = false,
		blip = {
			icon = 141,
			size = 0.9,
			color = 30,
			duration = (60 * 5),
		},
	},
	bane = {
		code = "10-31",
		title = "Breaking & Entering",
		type = 1,
		isPanic = false,
		blip = {
			icon = 311,
			size = 0.9,
			color = 30,
			duration = (60 * 5),
		},
	},
	shotsfired = {
		code = "10-99",
		title = "Shots Fired",
		type = 1,
		isPanic = false,
		blip = {
			icon = 110,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
	},
	shotsfiredvehicle = {
		code = "10-99",
		title = "Shots Fired From A Vehicle",
		type = 1,
		isPanic = false,
		blip = {
			icon = 229,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
	},
	oxysale = {
		code = "10-31",
		title = "Suspicious Activity",
		type = 1,
		isPanic = false,
		blip = {
			icon = 66,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
		isArea = true,
	},
	lockpickext = {
		code = "10-31",
		title = "Suspicious Activity",
		type = 1,
		isPanic = false,
		blip = {
			icon = 66,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
	},
	lockpickint = {
		code = "10-60",
		title = "Stolen Vehicle",
		type = 1,
		isPanic = false,
		blip = {
			icon = 326,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
	},
	caraccident = {
		code = "10-50",
		title = "Vehicle Accident",
		type = 2,
		isPanic = false,
		blip = {
			icon = 620,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
	},
	planeaccident = {
		code = "10-50",
		title = "Plane Crash",
		type = 2,
		isPanic = false,
		blip = {
			icon = 307,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
	},
	heliaccident = {
		code = "10-50",
		title = "Helicopter Accident",
		type = 2,
		isPanic = false,
		blip = {
			icon = 64,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
	},
	boataccident = {
		code = "10-50",
		title = "Boating Accident",
		type = 2,
		isPanic = false,
		blip = {
			icon = 427,
			size = 0.9,
			color = 30,
			duration = (60 * 3),
		},
	},
	call911 = {
		code = "911",
		title = "911 Call",
		type = 2,
		isPanic = false,
		blip = {
			icon = 280,
			size = 0.9,
			color = 1,
			duration = (60 * 5),
		},
		styleOverride = 1,
	},
	call311 = {
		code = "311",
		title = "311 Call",
		type = 2,
		isPanic = false,
		blip = {
			icon = 280,
			size = 0.9,
			color = 5,
			duration = (60 * 5),
		},
		styleOverride = 1,
	},
	call911anon = {
		code = "911",
		title = "911 Call",
		type = 2,
		isPanic = false,
		isAnon = true,
		blip = {
			icon = 280,
			size = 0.9,
			color = 1,
			duration = (60 * 5),
		},
		styleOverride = 1,
	},
	call311anon = {
		code = "311",
		title = "311 Call",
		type = 2,
		isPanic = false,
		isAnon = true,
		blip = {
			icon = 280,
			size = 0.9,
			color = 5,
			duration = (60 * 5),
		},
		styleOverride = 1,
	},
	bankjob = {
		code = "10-90",
		title = "Bank Robbery",
		type = 1,
		isPanic = false,
		blip = {
			icon = 311,
			size = 0.9,
			color = 30,
			duration = (60 * 5),
		},
	},
	bobcat = {
		code = "10-90",
		title = "Armed Robbery",
		type = 1,
		isPanic = false,
		blip = {
			icon = 311,
			size = 0.9,
			color = 30,
			duration = (60 * 5),
		},
	},
	icurequest = {
		code = "NA",
		title = "ICU Patient Assistance",
		type = 2,
		isPanic = false,
	},
	illegalStreetRacing = {
		code = "10-35",
		title = "Illegal Street Racing",
		type = 1,
		isPanic = false,
		blip = {
			icon = 227,
			size = 0.9,
			color = 30,
			duration = (60 * 5),
		},
	},
	towRequest = {
		code = "TOW",
		title = "PD Tow Request",
		type = 3,
		isPanic = false,
		blip = {
			icon = 68,
			size = 0.9,
			color = 1,
			duration = (60 * 5),
			flashing = true,
		},
	}
}

AddEventHandler("Job:Server:DutyAdd", function(dutyData, source, stateId, callsign)
	EmergencyAlerts:OnDuty(dutyData, source, stateId, callsign)
end)

AddEventHandler("Job:Server:DutyRemove", function(dutyData, source, stateId)
	EmergencyAlerts:OffDuty(dutyData, source, stateId)
end)

AddEventHandler("EmergencyAlerts:Server:ServerDoPredefined", function(src, type, description)
	local data = _predefined[type]
	if data == nil then
		return
	end

	local coords = GetEntityCoords(GetPlayerPed(src))

	local tpCoords = Player(src)?.state?.tpLocation
	if tpCoords ~= nil then
		coords = vector3(tpCoords.x, tpCoords.y, tpCoords.z)
	end

	Callbacks:ClientCallback(src, "EmergencyAlerts:GetStreetName", coords, function(location)
		if location ~= nil then
			EmergencyAlerts:Create(
				data.code,
				data.title,
				data.type,
				location,
				description or data.description or "",
				data.isPanic or false,
				data.blip or false,
				data.styleOverride,
				description and description.metadata or false
			)
		end
	end)
end)

local _cds = {}
RegisterNetEvent("EmergencyAlerts:Server:DoPredefined", function(type, description)
	local src = source	
	local data = _predefined[type]
	if data == nil then
		return
	end

	if type == "injuredPerson" then
		if _cds[source] ~= nil and _cds[source] > os.time() then
			return
		else
			_cds[source] = os.time() + (60 * 2)
		end
	end

	if data.isAnon then
		EmergencyAlerts:Create(
			data.code,
			data.title,
			data.type,
			false,
			description or data.description or "",
			data.isPanic or false,
			data.blip or false,
			data.styleOverride,
			false,
			false,
			description and description.metadata or false
		)
	else
		local coords = GetEntityCoords(GetPlayerPed(src))

		local tpCoords = Player(src)?.state?.tpLocation
		if tpCoords then
			coords = vector3(tpCoords.x, tpCoords.y, tpCoords.z)
		elseif data.isArea then
			coords = vector3(coords.x + math.random(-50, 50), coords.y + math.random(-50, 50), coords.z)
		end

		Callbacks:ClientCallback(src, "EmergencyAlerts:GetStreetName", coords, function(location)
			EmergencyAlerts:Create(
				data.code,
				data.title,
				data.type,
				location,
				description or data.description or "",
				data.isPanic or false,
				data.blip or false,
				data.styleOverride,
				data.isArea or false,
				false,
				description and description.metadata or false
			)
		end)
	end

end)

RegisterNetEvent("EmergencyAlerts:Server:ChangeUnit", function(data)
	if data.primary and data.type then
		EmergencyAlerts.Units:ChangeType(data.primary, data.type)
	end
end)

RegisterNetEvent("EmergencyAlerts:Server:OperateUnder", function(data)
	if data.primary and data.unit then
		EmergencyAlerts.Units:OperateUnder(data.primary, data.unit)
	end
end)

RegisterNetEvent("EmergencyAlerts:Server:BreakOff", function(data)
	if data.primary and data.unit then
		EmergencyAlerts.Units:BreakOff(data.primary, data.unit)
	end
end)
