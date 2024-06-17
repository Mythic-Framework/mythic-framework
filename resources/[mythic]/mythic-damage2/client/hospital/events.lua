local hospitalCheckin = {
	{
		icon = "clipboard-check",
		text = "Go On Duty",
		event = "EMS:Client:OnDuty",
		jobPerms = {
			{
				job = 'ems',
				reqOffDuty = true,
			}
		},
	},
	{ 
		icon = "clipboard", 
		text = "Go Off Duty", 
		event = "EMS:Client:OffDuty", 
		jobPerms = {
			{
				job = 'ems',
				reqDuty = true,
			}
		},
	},
	{ 
		icon = "clipboard", 
		text = "Check ICU Patients", 
		event = "EMS:Client:CheckICUPatients", 
		jobPerms = {
			{
				job = 'ems',
			}
		},
	},
	{
		icon = "clipboard-list",
		text = "Check In - $150",
		event = "Hospital:Client:CheckIn",
		isEnabled = function()
			if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
				return not LocalPlayer.state.isEscorted and (GlobalState["ems:pmc:doctor"] == nil or GlobalState["ems:pmc:doctor"] == 0)
			end
			return false
		end,
	},
	{
		icon = "clipboard-list",
		text = "Check In - $5000",
		event = "Hospital:Client:CheckIn",
		isEnabled = function()
			if GlobalState["Duty:ems"] and GlobalState["Duty:ems"] > 0 then
				return not LocalPlayer.state.isEscorted and (GlobalState["ems:pmc:doctor"] == nil or GlobalState["ems:pmc:doctor"] == 0)
			end
			return false
		end,
	},
	{
		icon = "hands-holding",
		text = "Retreive Items",
		event = "Hospital:Client:RetreiveItems",
		isEnabled = function()
			return LocalPlayer.state.Character:GetData("ICU") == nil or not LocalPlayer.state.Character:GetData("ICU").Items
		end,
	},
}

function Init()
	PedInteraction:Add("hospital-check-in", `u_f_m_miranda_02`, vector3(-437.484, -323.269, 33.911), 162.630, 25.0, hospitalCheckin, "notes-medical", "WORLD_HUMAN_CLIPBOARD")

	for k, v in ipairs(Config.BedModels) do
		Targeting:AddObject(v, "bed-pulse", {
			{
				icon = "bed-pulse",
				text = "Lay in Bed",
				event = "Hospital:Client:FindBed",
				minDist = 2.0,
				isEnabled = function()
					return LocalPlayer.state.isEscorting == nil and LocalPlayer.state.myEscorter == nil and not LocalPlayer.state.isHospitalized
				end,
			},
		}, 3.0)
	end

	for k, v in ipairs(Config.BedPolys) do
		Targeting.Zones:AddBox(string.format("hospitalbed-%s", k),
			"bed-pulse",
			v.center,
			v.length,
			v.width,
			v.options,
			{
				{
					icon = "bed-pulse",
					text = "Lay Down",
					event = "Hospital:Client:LaydownAnimation",
					data = v.laydown,
				},
			},
			3.0,
			true
		)
	end
end

AddEventHandler("Hospital:Client:LaydownAnimation", function(hitting, coords)
	SetEntityCoords(LocalPlayer.state.ped, coords.x, coords.y, coords.z)
	SetEntityHeading(LocalPlayer.state.ped, coords.w)
	Animations.Emotes:Play("passout3", true)
	LocalPlayer.state:set("isHospitalized", true, true)

	while Animations.Emotes:Get() == "passout3" do
		Wait(250)
	end

	print("Out of Bed")
	LocalPlayer.state:set("isHospitalized", false, true)
end)

AddEventHandler("Hospital:Client:RetreiveItems", function()
	Callbacks:ServerCallback("Hospital:RetreiveItems")
end)

AddEventHandler("Hospital:Client:HiddenRevive", function(entity, data)
	Progress:Progress({
		name = "ammo_action",
		duration = (math.random(5) + 15) * 1000,
		label = "Reviving",
		useWhileDead = false,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			task = "CODE_HUMAN_MEDIC_KNEEL",
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Hospital:HiddenRevive", {}, function(s)
				if s then
					Escort:StopEscort()
				end
			end)
		end
	end)
end)

AddEventHandler("Characters:Client:Spawn", function()
	LocalPlayer.state:set("isHospitalized", false, true)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	LocalPlayer.state:set("isHospitalized", false, true)
end)

AddEventHandler("Hospital:Client:CheckIn", function()
	Progress:ProgressWithStartEvent({
		name = "hospital_action",
		duration = 2500,
		label = "Checking In",
		useWhileDead = true,
		canCancel = true,
		ignoreModifier = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "clipboard_still",
		},
		disarm = true,
	}, function()
		LocalPlayer.state:set("isHospitalized", true, true)
	end, function(status)
		if not status then
			Hospital:CheckIn()
		else
			LocalPlayer.state:set("isHospitalized", false, true)
		end
	end)
end)

RegisterNetEvent("Hospital:Client:GetOut", function()
	Callbacks:ServerCallback('Hospital:LeaveBed', {}, function()
		_doing = false
		LeaveBed()
	end)
end)

AddEventHandler("Hospital:Client:FindBed", function(event, data)
	if not event then
		return
	end
	Hospital:FindBed(event.entity)
end)

RegisterNetEvent("Hospital:Client:ICU:Enter", function()
	if not IsScreenFadedOut() then
		DoScreenFadeOut(1000)
		while not IsScreenFadedOut() do
			Wait(10)
		end
	end

	local room = Config.ICUBeds[math.random(#Config.ICUBeds)]

	SetEntityCoords(LocalPlayer.state.ped, room[1], room[2], room[3], 0, 0, 0, false)
	Wait(100)
	SetEntityHeading(LocalPlayer.state.ped, room[4])
	_disabled = false

	Wait(1000)

	DoScreenFadeIn(1000)
	while not IsScreenFadedIn() do
		Wait(10)
	end
end)