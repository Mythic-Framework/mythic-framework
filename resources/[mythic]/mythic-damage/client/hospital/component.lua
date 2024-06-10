_curBed = nil
_done = false

AddEventHandler("Hospital:Shared:DependencyUpdate", HospitalComponents)
function HospitalComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Damage = exports["mythic-base"]:FetchComponent("Damage")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Hospital = exports["mythic-base"]:FetchComponent("Hospital")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
	PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
	Escort = exports["mythic-base"]:FetchComponent("Escort")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Hospital", {
		"Callbacks",
		"Notification",
		"Damage",
		"Targeting",
		"Hospital",
		"Progress",
		"PedInteraction",
		"Escort",
		"Polyzone",
		"Action",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		HospitalComponents()
		Init()

		while GlobalState["HiddenHospital"] == nil do
			Citizen.Wait(5)
		end

		PedInteraction:Add("HiddenHospital", `s_m_m_doctor_01`, GlobalState["HiddenHospital"].coords, GlobalState["HiddenHospital"].heading, 25.0, {
			{
				icon = "heart-pulse",
				text = "Revive Escort (20 $PLEB)",
				event = "Hospital:Client:HiddenRevive",
				data = LocalPlayer.state.isEscorting or {},
				isEnabled = function()
					if LocalPlayer.state.isEscorting ~= nil and not LocalPlayer.state.isDead then
						local ps = Player(LocalPlayer.state.isEscorting).state
						return ps.isDead and not ps.deadData?.isMinor
					else
						return false
					end
				end,
			},
		}, 'suitcase-medical', 'CODE_HUMAN_MEDIC_KNEEL')

		Polyzone.Create:Box('hospital-check-in-zone', vector3(-436.09, -326.23, 34.91), 2.0, 3.0, {
			heading = 338,
			--debugPoly=true,
			minZ = 33.91,
			maxZ = 36.31
		}, {})

		Targeting.Zones:AddBox("icu-checkout", "bell-concierge", vector3(-492.49, -336.15, 69.52), 0.8, 7.2, {
			name = "hospital",
			heading = 353,
			--debugPoly=true,
			minZ = 68.52,
			maxZ = 70.52
		}, {
			{
				icon = "bell-concierge",
				text = "Request Personnel",
				event = "Hospital:Client:RequestEMS",
				isEnabled = function()
					return (LocalPlayer.state.Character:GetData("ICU") ~= nil and not LocalPlayer.state.Character:GetData("ICU").Released) and (not _done or _done < GetCloudTimeAsInt())
				end,
			}
		})
	end)
end)

AddEventHandler("Hospital:Client:RequestEMS", function()
	if not _done or _done < GetCloudTimeAsInt() then
		TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", "icurequest")
		_done = GetCloudTimeAsInt() + (60 * 10)
	end
end)

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Hospital', HOSPITAL)
end)

local _bedId = nil
HOSPITAL = {
	CheckIn = function(self)
		Callbacks:ServerCallback('Hospital:Treat', {}, function(bed)
			if bed ~= nil then
				_countdown = Config.HealTimer
				LocalPlayer.state:set("isHospitalized", true, true)
				Hospital:SendToBed(Config.Beds[bed], false, bed)
			else
				Notification:Error('No Beds Available')
			end
		end)
	end,
	SendToBed = function(self, bed, isRp, bedId)
		local fuck = false

		if bedId then
			local p = promise.new()
			Callbacks:ServerCallback('Hospital:OccupyBed', bedId, function(s)
				p:resolve(s)
			end)

			fuck = Citizen.Await(p)
		else
			fuck = true
		end

		_bedId = bedId

		if bed ~= nil and fuck then
			SetBedCam(bed)
			if isRp then
				StartRPThread()
			else
				_countdown = Config.HealTimer
				StartHealThread()
			end
		else
			Notification:Error('Invalid Bed or Bed Occupied')
		end
	end,
	FindBed = function(self, object)
		local coords = GetEntityCoords(object)
		Callbacks:ServerCallback('Hospital:FindBed', coords, function(bed)
			if bed ~= nil then
				Hospital:SendToBed(Config.Beds[bed], true, bed)
			else
				Hospital:SendToBed({
					x = coords.x,
					y = coords.y,
					z = coords.z,
					h = GetEntityHeading(object),
					freeBed = true,
				}, true)
			end
		end)
	end,
	LeaveBed = function(self)
		Callbacks:ServerCallback('Hospital:LeaveBed', _bedId, function()
			_bedId = nil
		end)
	end,
}

local _inCheckInZone = false

AddEventHandler('Polyzone:Enter', function(id, point, insideZone, data)
    if id == 'hospital-check-in-zone' then
        _inCheckInZone = true

		if not LocalPlayer.state.isEscorted and (GlobalState["ems:pmc:doctor"] == nil or GlobalState["ems:pmc:doctor"] == 0) then
			if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
				Action:Show('{keybind}primary_action{/keybind} Check In {key}$150{/key}')
			else
				Action:Show('{keybind}primary_action{/keybind} Check In {key}$5000{/key}')
			end
		end
    end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZone, data)
    if id == 'hospital-check-in-zone' then
        _inCheckInZone = false
		Action:Hide()
    end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
    if _inCheckInZone then
		if not LocalPlayer.state.doingAction and not LocalPlayer.state.isEscorted and (GlobalState["ems:pmc:doctor"] == nil or GlobalState["ems:pmc:doctor"] == 0) then
			TriggerEvent('Hospital:Client:CheckIn')
		end
	end
end)