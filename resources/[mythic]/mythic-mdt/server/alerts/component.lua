_alertsPermMap = {
	[1] = "police_alerts",
	[2] = "ems_alerts",
	[3] = "tow_alerts",
}

_alertValidTypes = {
	police = {
		"car",
		"motorcycle",
		"air1",
	},
	ems = {
		"bus",
		"car",
		"lifeflight",
	},
	tow = {
		"truck-tow",
	},
}

_alertsDefaultType = {
	police = _alertValidTypes.police[1],
	ems = _alertValidTypes.ems[1],
	tow = _alertValidTypes.tow[1],
}

AddEventHandler("EmergencyAlerts:Shared:DependencyUpdate", RetrieveEAComponents)
function RetrieveEAComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Database = exports["mythic-base"]:FetchComponent("Database")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("MDT", {
		"Fetch",
		"Database",
		"Callbacks",
		"Logger",
		"Utils",
		"Chat",
		"Middleware",
		"EmergencyAlerts",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveEAComponents()
		RegisterEACallbacks()
		StartAETrackingThreads()
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("EmergencyAlerts", _pdAlerts)
end)

emergencyAlertsData = {}
emergencyAlertsUnits = {}

_pdAlerts = {
	Create = function(self, code, title, type, location, description, isPanic, blip, styleOverride, isArea, camera)
		for k, v in pairs(emergencyAlertsData) do
			if v.AlertPermissions[_alertsPermMap[type]] then
				TriggerClientEvent(
					"EmergencyAlerts:Client:Add",
					v.Source,
					code,
					title,
					type,
					location,
					description,
					isPanic,
					blip,
					styleOverride,
					isArea or false,
					camera or false
				)
			end
		end
	end,
	Units = {
		ChangeType = function(self, primary, newType)
			for k, v in ipairs(emergencyAlertsUnits) do
				if v.primary == primary then
					if _alertValidTypes[v.job] and Utils:DoesTableHaveValue(_alertValidTypes[v.job], newType) then
						emergencyAlertsUnits[k].type = newType
						EmergencyAlerts:SendUnitUpdates()
						return true
					else
						return false
					end
				end
			end
			return false
		end,
		BreakOff = function(self, primary, unit, skipAddingBack) -- Removes the Unit from the Primary
			for k, v in ipairs(emergencyAlertsUnits) do
				if v.primary == primary or not primary then
					for uKey, u in ipairs(v.units) do
						if u == unit then
							table.remove(v.units, uKey)
							if not skipAddingBack then
								local char = Fetch:CharacterData("Callsign", unit):GetData("Character")
								table.insert(emergencyAlertsUnits, {
									job = v.job,
									type = _alertsDefaultType[v.job],
									character = {
										SID = char:GetData("SID"),
										First = char:GetData("First"),
										Last = char:GetData("Last"),
										Phone = char:GetData("Phone"),
									},
									primary = unit,
									units = {},
								})

								EmergencyAlerts:SendUnitUpdates()
							end
							return true
						end
					end
					break
				end
			end
			return false
		end,
		OperateUnder = function(self, primary, unit)
			for k, v in ipairs(emergencyAlertsUnits) do
				if v.primary == unit then
					-- The unit that is moving has to not be a unit with people in
					if #v.units <= 0 then
						for k2, v2 in ipairs(emergencyAlertsUnits) do
							if v2.primary == primary and v.job == v2.job then
								table.insert(v2.units, unit)
								table.remove(emergencyAlertsUnits, k)
								EmergencyAlerts:SendUnitUpdates()
								return true
							end
						end
					end
					break
				end
			end
			return false
		end,
	},
	OnDuty = function(self, dutyData, source, stateId, callsign)
		if dutyData and (dutyData.Id == "police" or dutyData.Id == "ems" or dutyData.Id == "tow") then
			local alertPermissions = {}
			local allJobPermissions = Jobs.Permissions:GetPermissionsFromJob(source, dutyData.Id)
			for k, v in pairs(_alertsPermMap) do
				if allJobPermissions[v] then
					alertPermissions[v] = true
				end
			end

			local char = Fetch:Source(source):GetData("Character")
			emergencyAlertsData[source] = {
				SID = stateId,
				Source = source,
				Job = dutyData.Id,
				Workplace = dutyData.WorkplaceId,
				Callsign = callsign,
				Phone = char:GetData("Phone"),
				AlertPermissions = alertPermissions,
				First = dutyData.First,
				Last = dutyData.Last,
				Coords = GetEntityCoords(GetPlayerPed(source)),
			}

			EmergencyAlerts:SendMemberUpdates()

			if callsign or dutyData.Id == "tow" then
				table.insert(emergencyAlertsUnits, {
					job = dutyData.Id,
					type = _alertsDefaultType[dutyData.Id],
					character = {
						SID = char:GetData("SID"),
						First = char:GetData("First"),
						Last = char:GetData("Last"),
						Phone = char:GetData("Phone"),
					},
					primary = callsign or "NA",
					units = {},
				})

				EmergencyAlerts:SendUnitUpdates()
			end
		end
	end,
	OffDuty = function(self, dutyData, source, stateId)
		local emergencyMember = emergencyAlertsData[source]
		if emergencyMember then
			EmergencyAlerts.Units:BreakOff(false, emergencyMember.Callsign, true)
			for i = #emergencyAlertsUnits, 1, -1 do
				if emergencyAlertsUnits[i].character.SID == emergencyMember.SID then
					for uKey, u in ipairs(emergencyAlertsUnits[i].units) do
						if u ~= nil and u ~= "NA" then
							local plyr = Fetch:CharacterData("Callsign", u)

							if plyr ~= nil then
								local char = plyr:GetData("Character")
								table.insert(emergencyAlertsUnits, {
									job = emergencyAlertsUnits[i].job,
									type = _alertsDefaultType[emergencyAlertsUnits[i].job],
									character = {
										SID = char:GetData("SID"),
										First = char:GetData("First"),
										Last = char:GetData("Last"),
										Phone = char:GetData("Phone"),
									},
									primary = u,
									units = {},
								})
							end
						end
					end

					table.remove(emergencyAlertsUnits, i)
				end
			end

			emergencyAlertsData[source] = nil

			EmergencyAlerts:SendUnitUpdates()
			EmergencyAlerts:SendMemberUpdates()
		end
	end,
	RefreshCallsign = function(self, stateId, newCallsign)
		for k, v in pairs(emergencyAlertsData) do
			if v.SID == stateId then
				if v.Callsign then -- Updating an already existing callsign
					for unitKey, unit in ipairs(emergencyAlertsUnits) do
						if unit.primary == v.Callsign then
							unit.primary = newCallsign
							break
						else
							for subUnitKey, subUnit in ipairs(unit.units) do
								if subUnit == v.Callsign then
									unit.units[subUnitKey] = newCallsign
								end
								break
							end
						end
					end
					emergencyAlertsData[k].Callsign = newCallsign
				else -- Just got assigned a callsign
					emergencyAlertsData[k].Callsign = newCallsign
					local char = Fetch:CharacterData("Callsign", newCallsign):GetData("Character")
					table.insert(emergencyAlertsUnits, {
						job = v.Job,
						type = _alertsDefaultType[v.Job],
						character = {
							SID = char:GetData("SID"),
							First = char:GetData("First"),
							Last = char:GetData("Last"),
							Phone = char:GetData("Phone"),
						},
						primary = newCallsign,
						units = {},
					})
				end
			end
		end
	end,
	SendUnitUpdates = function(self)
		EmergencyAlerts:SendOnDutyEvent("EmergencyAlerts:Client:UpdateUnits", emergencyAlertsUnits)
	end,
	SendMemberUpdates = function(self)
		EmergencyAlerts:SendOnDutyEvent("EmergencyAlerts:Client:UpdateMembers", emergencyAlertsData)
	end,
	SendOnDutyEvent = function(self, event, data)
		for k, v in pairs(emergencyAlertsData) do
			TriggerClientEvent(event, k, data)
		end
	end,
}
