local _jobs = {
	police = true,
	ems = true,
	tow = true,
}

AddEventHandler("EmergencyAlerts:Shared:DependencyUpdate", RetrievePDAComponents)
function RetrievePDAComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	UISounds = exports["mythic-base"]:FetchComponent("UISounds")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	CCTV = exports["mythic-base"]:FetchComponent("CCTV")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("MDT", {
		"Callbacks",
		"Logger",
		"Sounds",
		"UISounds",
		"EmergencyAlerts",
		"Notification",
		"Keybinds",
		"Blips",
		"CCTV",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrievePDAComponents()
		RegisterCallbacks()
		Keybinds:Add("emergency_alerts_toggle", "GRAVE", "keyboard", "Police - Toggle Alerts Panel", function()
			local duty = LocalPlayer.state.onDuty
			if _jobs[duty] then
				EmergencyAlerts:Open()
			end
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("EmergencyAlerts", _pdAlerts)
end)

local _pTs = {
	[6] = true,
	[27] = true,
	[29] = true,
	[28] = true,
}

function isEligiblePed(p, gs, spd)
	if math.random(100) > 15 then
		return false
	end

	if LocalPlayer.state.inCayo then
		return false
	end

	if p == nil or not DoesEntityExist(p) then
		return false
	end

	if IsPedAPlayer(p) then
		return false
	end

	if spd == nil then
		spd = false
	elseif not IsPedInAnyVehicle(p, false) then
		return false
	end

	if p == LocalPlayer.state.ped then
		return false
	end

	if LocalPlayer.state.oxyBuyer ~= nil and LocalPlayer.state.oxyBuyer.ped == p then
		return false
	end

	if GetEntityHealth(p) < GetEntityMaxHealth(p) then
		return false
	end

	local startcoords = GetEntityCoords(p)

	if #(LocalPlayer.state.myPos - startcoords) < 10.0 then
		return false
	end

	if not HasEntityClearLosToEntity(LocalPlayer.state.ped, p, 17) and not gs then
		return false
	end

	if IsPedFatallyInjured(p) then
		return false
	end

	if IsPedArmed(p, 7) then
		return false
	end

	if IsPedInMeleeCombat(p) then
		return false
	end

	if IsPedShooting(p) then
		return false
	end

	if IsPedDucking(p) then
		return false
	end

	if IsPedBeingJacked(p) then
		return false
	end

	if IsPedSwimming(p) then
		return false
	end

	if IsPedJumpingOutOfVehicle(p) or IsPedBeingJacked(p) then
		return false
	end

	local entState = Entity(p).state
	if entState.boughtDrugs then
		return false
	end

	if entState.isDrugBuyer then
		return false
	end

	if entState.crimePed then
		return false
	end

	if _pTs[GetPedType(p)] then
		return false
	end
	return true
end

function nearNpc(dist, isGunshot)
	local handle, ped = FindFirstPed()
	local success
	local retval = nil
	repeat
		local loc = GetEntityCoords(ped)
		local d1 = #(vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z) - loc)
		if isEligiblePed(ped, isGunshot) and d1 <= dist and (retval == nil or d1 < retval.dist) then
			retval = {
				ped = ped,
				dist = d1,
			}
		end
		success, ped = FindNextPed(handle)
	until not success
	EndFindPed(handle)

	return retval
end

function RegisterCallbacks()
	Callbacks:RegisterClientCallback("EmergencyAlerts:GetStreetName", function(data, cb)
		local x, y, z = table.unpack(data)
		local main, cross = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

		main = GetStreetNameFromHashKey(main)
		cross = GetStreetNameFromHashKey(cross)
		cb({
			street1 = main,
			street2 = intersect,
			area = GetLabelText(GetNameOfZone(x, y, z)),
			x = x,
			y = y,
			z = z,
		})
	end)
end

local ids = 0
_pdAlerts = {
	Open = function(self)
		SendNUIMessage({
			type = "SET_SHOWING",
			data = {
				state = true,
			},
		})
		SetNuiFocus(true, true)
	end,
	Close = function(self)
		SendNUIMessage({
			type = "SET_SHOWING",
			data = {
				state = false,
			},
		})
		SetNuiFocus(false, false)
	end,
	CreateIfReported = function(self, distance, type, isNpcTriggered, description)
		if isNpcTriggered then
			local ped = nearNpc(distance, type == "shotsfired" or type == "shotsfiredvehicle")
			if ped ~= nil then
				TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", type, description)
				return true
			end
			return false
		else
			TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", type, description)
		end
	end,
	Create = function(self, code, title, type, location, description, isPanic, blip, styleOverride, isArea, camera)
		ids = ids + 1

		local areaBlip = {}
		if blip then
			blip.id = string.format("emrg-%s", _blipCount)

			local pref = "[Police]"
			if type == 2 then
				pref = "[EMS]"
			elseif type == 3 then
				pref = "[Tow]"
			end

			blip.title = string.format("%s: %s", pref, title)

			_blipCount = _blipCount + 1

			if isArea then
				areaBlip.id = string.format("emrg-%s", _blipCount)
				_blipCount = _blipCount + 1
			end
		end

		local alert = {
			id = ids,
			code = code,
			title = title,
			type = type,
			location = location,
			description = description,
			panic = isPanic,
			blip = blip,
			style = styleOverride or type,
			camera = camera or false,
		}

		local duty = LocalPlayer.state.onDuty
		if _jobs[duty] then
			if isPanic then
				Sounds.Play:Distance(15, "panic.ogg", 1.0)
			else
				Sounds.Play:Distance(15, "alert_normal.ogg", 0.5)
			end

			if blip ~= nil and location ~= nil then
				local eB = Blips:Add(
					blip.id,
					blip.title,
					location,
					blip.icon,
					blip.color,
					blip.size,
					2,
					false,
					blip.flashing
				)
				SetBlipFlashes(eB, isPanic)
				table.insert(_alertBlips, {
					id = blip.id,
					time = GlobalState["OS:Time"] + blip.duration,
					blip = eB,
				})

				if isArea then
					local eAB = AddBlipForRadius(location.x, location.y, location.z, 100.0)
					SetBlipColour(eAB, blip.color)
					SetBlipAlpha(eAB, 90)
					table.insert(_alertBlips, {
						id = areaBlip.id,
						time = GlobalState["OS:Time"] + blip.duration,
						blip = eAB,
					})
				end
			end

			SendNUIMessage({
				type = "ADD_ALERT",
				data = {
					alert = alert,
				},
			})
		end
		TriggerEvent("Phone:Client:AddData", "leoAlerts", alert)
	end,
}

RegisterNetEvent("EmergencyAlerts:Client:Open", function()
	EmergencyAlerts:Open()
end)

RegisterNetEvent("EmergencyAlerts:Client:Close", function()
	EmergencyAlerts:Close()
end)

RegisterNetEvent(
	"EmergencyAlerts:Client:Add",
	function(code, title, type, location, extra, isPanic, blip, styleOverride, isArea, camera)
		EmergencyAlerts:Create(code, title, type, location, extra, isPanic, blip, styleOverride, isArea, camera)
	end
)
