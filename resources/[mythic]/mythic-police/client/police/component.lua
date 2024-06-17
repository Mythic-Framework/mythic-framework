local policeStationBlips = {
	vector3(-445.7, 6013.2, 100.0),
	vector3(438.7, -981.8, 100.0),
	vector3(1850.634, 3683.860, 100.0),
	vector3(372.658, -1601.816, 100.0),
	vector3(835.011, -1292.794, 100.0),
}

local _pdModels = {}

local lastTackle = 0

local _breached = {}

local policeDutyPoint = {
	{
		icon = "clipboard-check",
		text = "Go On Duty",
		event = "Police:Client:OnDuty",
		jobPerms = {
			{
				job = "police",
				reqOffDuty = true,
			},
		},
	},
	{
		icon = "clipboard",
		text = "Go Off Duty",
		event = "Police:Client:OffDuty",
		jobPerms = {
			{
				job = "police",
				reqDuty = true,
			},
		},
	},
}

local _pdStationPolys = {
	{
		points = {
			vector2(419.16091918945, -966.34405517578),
			vector2(419.2200012207, -1016.196105957),
			vector2(409.74496459961, -1016.0508422852),
			vector2(410.03247070312, -1033.0327148438),
			vector2(489.80380249023, -1026.6353759766),
			vector2(488.85284423828, -966.38427734375),
		},
		options = {
			name = "pdstation_missionrow",
			minZ = 25.36417388916,
			maxZ = 45.414678573608,
		},
		data = { pdstation = true },
	},
	{
		points = {
			vector2(411.00393676758, -1661.6872558594),
			vector2(424.06509399414, -1645.6456298828),
			vector2(424.70223999023, -1640.4389648438),
			vector2(423.83392333984, -1627.9958496094),
			vector2(360.71951293945, -1574.7712402344),
			vector2(339.02374267578, -1600.73046875),
		},
		options = {
			name = "pdstation_davis",
			minZ = 25.36417388916,
			maxZ = 45.414678573608,
		},
		data = { pdstation = true },
	},
	{
		points = {
			vector2(818.44097900391, -1249.2879638672),
			vector2(836.80029296875, -1252.8927001953),
			vector2(860.4052734375, -1278.6043701172),
			vector2(862.82849121094, -1296.5511474609),
			vector2(877.03753662109, -1297.9116210938),
			vector2(878.47839355469, -1328.7099609375),
			vector2(878.81671142578, -1361.5606689453),
			vector2(848.46789550781, -1417.4731445312),
			vector2(816.15045166016, -1417.8415527344),
		},
		options = {
			name = "pdstation_popular",
			minZ = 25.36417388916,
			maxZ = 45.414678573608,
		},
		data = { pdstation = true },
	},
	{
		points = {
			vector2(1889.2142333984, 3691.6762695312),
			vector2(1851.7814941406, 3668.3894042969),
			vector2(1830.3732910156, 3704.9562988281),
			vector2(1868.1072998047, 3727.1462402344),
		},
		options = {
			name = "pdstation_sandy",
			minZ = 29.36417388916,
			maxZ = 49.414678573608,
		},
		data = { pdstation = true },
	},
	{
		points = {
			vector2(-442.38430786133, 6062.9243164062),
			vector2(-416.13342285156, 6005.0458984375),
			vector2(-415.57186889648, 5998.3540039062),
			vector2(-439.16738891602, 5975.2041015625),
			vector2(-449.66729736328, 5985.3481445312),
			vector2(-472.04858398438, 5963.1728515625),
			vector2(-500.68542480469, 5991.81640625),
			vector2(-478.4963684082, 6014.41796875),
			vector2(-488.33645629883, 6024.4272460938),
			vector2(-460.89733886719, 6051.8681640625),
		},
		options = {
			name = "pdstation_paleto",
			minZ = 29.36417388916,
			maxZ = 49.414678573608,
		},
		data = { pdstation = true },
	},
	{
		points = {
			vector2(-127.90340423584, -1157.5145263672),
			vector2(-128.29985046387, -1186.4349365234),
			vector2(-249.06109619141, -1184.8615722656),
			vector2(-247.67953491211, -1157.8649902344),
		},
		options = {
			name = "pdstation_impound",
			heading = 0,
			--debugPoly=true,
			minZ = 22.04,
			maxZ = 34.04
		},
		data = { pdstation = true },
	},
}

function loadModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
end

AddEventHandler("Police:Shared:DependencyUpdate", PoliceComponents)
function PoliceComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Input = exports["mythic-base"]:FetchComponent("Input")
	Keybinds = exports["mythic-base"]:FetchComponent("Keybinds")
	Handcuffs = exports["mythic-base"]:FetchComponent("Handcuffs")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Apartment = exports["mythic-base"]:FetchComponent("Apartment")
	EmergencyAlerts = exports["mythic-base"]:FetchComponent("EmergencyAlerts")
	Wardrobe = exports["mythic-base"]:FetchComponent("Wardrobe")
	Status = exports["mythic-base"]:FetchComponent("Status")
	Game = exports["mythic-base"]:FetchComponent("Game")
	Sync = exports["mythic-base"]:FetchComponent("Sync")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Police", {
		"Callbacks",
		"Inventory",
		"Notification",
		"Input",
		"Keybinds",
		"Handcuffs",
		"Interaction",
		"Blips",
		"Targeting",
		"Jobs",
		"Sounds",
		"Properties",
		"Apartment",
		"EmergencyAlerts",
		"Wardrobe",
		"Status",
		"Game",
		"Sync",
		"Polyzone",
		"Vehicles",
	}, function(error)
		if #error > 0 then
			return
		end
		PoliceComponents()

		_pdModels = GlobalState["PoliceCars"]

		Interaction:RegisterMenu("police", "Panic", "land-mine-on", function(data)
			Interaction:ShowMenu({
				{
					icon = "land-mine-on",
					label = "13-A",
					action = function()
						Interaction:Hide()
						TriggerServerEvent("Police:Server:Panic", true)
					end,
					shouldShow = function()
						return LocalPlayer.state.isDead
					end,
				},
				{
					icon = "land-mine-on",
					label = "13-B",
					action = function()
						Interaction:Hide()
						TriggerServerEvent("Police:Server:Panic", false)
					end,
					shouldShow = function()
						return LocalPlayer.state.isDead
					end,
				},
			})
		end, function()
			return LocalPlayer.state.onDuty == "police" and LocalPlayer.state.isDead
		end)

		Interaction:RegisterMenu("police-raid-biz", "Search Inventory", "magnifying-glass", function(data)
			Interaction:Hide()
			Progress:ProgressWithTickEvent({
				name = 'pd_raid_biz',
				duration = 8000,
				label = "Searching",
				tickrate = 250,
				useWhileDead = false,
				canCancel = true,
				vehicle = false,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableCombat = true,
				},
				animation = {
					animDict = "anim@gangops@facility@servers@bodysearch@",
					anim = "player_search",
					flags = 49,
				},
			}, function()
				if LocalPlayer.state.onDuty == "police" and not LocalPlayer.state.isDead and LocalPlayer.state._inInvPoly ~= nil then
					return
				end
				Progress:Cancel()
			end, function(cancelled)
				_doing = false
				if not cancelled then
					Callbacks:ServerCallback("Inventory:Raid", LocalPlayer.state._inInvPoly.inventory, function(owner) end)
				end
			end)
		end, function()
			return LocalPlayer.state.onDuty == "police"
					and not LocalPlayer.state.isDead
					and LocalPlayer.state._inInvPoly ~= nil
					and LocalPlayer.state._inInvPoly?.business ~= nil
		end)

		Interaction:RegisterMenu("pd-locked-veh", "Secured Compartment", "user-lock", function(data)
			Interaction:Hide()
			Progress:Progress({
				name = "pd_rack_prog",
				duration = 5000,
				label = "Unlocking Compartment",
				useWhileDead = false,
				canCancel = true,
				animation = false,
			}, function(status)
				if not status then
					Callbacks:ServerCallback("Police:AccessRifleRack")
				end
			end)
		end, function()
			local v = GetVehiclePedIsIn(LocalPlayer.state.ped)
			return LocalPlayer.state.onDuty == "police" and not LocalPlayer.state.isDead and v ~= 0 and _pdModels[GetEntityModel(v)] and Vehicles:HasAccess(v)
		end)

		Interaction:RegisterMenu("police-utils", "Police Utilities", "tablet", function(data)
			Interaction:ShowMenu({
				{
					icon = "lock-open",
					label = "Slimjim Vehicle",
					action = function()
						Interaction:Hide()
						TriggerServerEvent("Police:Server:Slimjim")
					end,
					shoudlShow = function()
						local target = Targeting:GetEntityPlayerIsLookingAt()
						return target
							and target.entity
							and DoesEntityExist(target.entity)
							and IsEntityAVehicle(target.entity)
							and #(GetEntityCoords(target.entity) - GetEntityCoords(LocalPlayer.state.ped)) <= 2.0
					end,
				},
				{
					icon = "tablet-screen-button",
					label = "MDT",
					action = function()
						Interaction:Hide()
						TriggerEvent("MDT:Client:Toggle")
					end,
					shoudlShow = function()
						return LocalPlayer.state.onDuty == "police"
					end,
				},
				{
					icon = "video",
					label = "Toggle Body Cam",
					action = function()
						Interaction:Hide()
						TriggerEvent("MDT:Client:ToggleBodyCam")
					end,
					shoudlShow = function()
						return LocalPlayer.state.onDuty == "police"
					end,
				},
			})
		end, function()
			return LocalPlayer.state.onDuty == "police"
		end)

		Interaction:RegisterMenu("pd-breach", "Breach", "bomb", function(data)
			local prop = Properties:Get(data.propertyId)
			Interaction:ShowMenu({
				{
					icon = "house",
					label = "Breach Property",
					action = function()
						Interaction:Hide()
						Callbacks:ServerCallback("Police:Breach", {
							type = "property",
							property = data.propertyId,
						}, function(s)
							if s then

							end
						end)
					end,
					shouldShow = function()
						return prop ~= nil and prop.sold
					end,
				},
				{
					icon = "house-chimney-window",
					label = "Breach Apartment",
					action = function()
						Interaction:Hide()
						Input:Show("Breaching", "Unit Number (Owner State ID)", {
							{
								id = "unit",
								type = "number",
								options = {},
							},
						}, "Police:Client:DoApartmentBreach", data.id)
					end,
					shouldShow = function()
						return Apartment:GetNearApartment()
					end,
				},
			})
		end, function()
			if LocalPlayer.state.onDuty and LocalPlayer.state.onDuty == "police" then
				return Properties:GetNearHouse() or Apartment:GetNearApartment()
			else
				return nil
			end
		end)

		Interaction:RegisterMenu("pd-breach-robbery", "Breach House Robbery", "bomb", function(data)
			local bruh = GlobalState["Robbery:InProgress"]
			for k, v in ipairs(bruh) do
				local fuck = GlobalState[string.format("Robbery:InProgress:%s", v)]
				if fuck then
					local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(fuck.x, fuck.y, fuck.z))
					if dist <= 3.0 then
						Callbacks:ServerCallback("Police:Breach", {
							type = "robbery",
							property = v,
						})

						return
					end
				end
			end
			Interaction:Hide()
		end, function()
			if LocalPlayer.state.onDuty and LocalPlayer.state.onDuty == "police" then
				local bruh = GlobalState["Robbery:InProgress"]
				for k, v in ipairs(bruh) do
					local fuck = GlobalState[string.format("Robbery:InProgress:%s", v)]
					if fuck then
						local dist = #(vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z) - vector3(fuck.x, fuck.y, fuck.z))
						return dist <= 3.0
					end
				end
			end
			return false
		end)

		Callbacks:RegisterClientCallback("Police:Breach", function(data, cb)
			Progress:Progress({
				name = "breach_action",
				duration = 3000,
				label = "Breaching",
				useWhileDead = false,
				canCancel = true,
				disarm = false,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "missprologuemcs_1",
					anim = "kick_down_player_zero",
					flags = 49,
				},
			}, function(cancelled)
				cb(not cancelled)
				if not cancelled then
					--Sounds.Play:Location(LocalPlayer.state.position, 20, "breach.ogg", 0.15)
				end
			end)
		end)

		local _cuffCd = false
		Keybinds:Add("pd_cuff", "LBRACKET", "keyboard", "Police - Cuff", function()
			if LocalPlayer.state.Character ~= nil and LocalPlayer.state.onDuty == "police" then
				if not _cuffCd then
					TriggerServerEvent("Police:Server:Cuff")
					_cuffCd = true
					SetTimeout(3000, function()
						_cuffCd = false
					end)
				end
			end
		end)

		Keybinds:Add("pd_uncuff", "RBRACKET", "keyboard", "Police - Uncuff", function()
			if LocalPlayer.state.Character ~= nil and LocalPlayer.state.onDuty == "police" then
				if not _cuffCd then
					TriggerServerEvent("Police:Server:Uncuff")
					_cuffCd = true
					SetTimeout(3000, function()
						_cuffCd = false
					end)
				end
			end
		end)

		-- Keybinds:Add("pd_toggle_cuff", "", "keyboard", "Police - Cuff / Uncuff", function()
		-- 	if LocalPlayer.state.Character ~= nil and LocalPlayer.state.onDuty == "police" then
		-- 		if not _cuffCd then
		-- 			TriggerServerEvent("Police:Server:ToggleCuff")
		-- 			_cuffCd = true
		-- 			CreateThread(function()
		-- 				Wait(2000)
		-- 				_cuffCd = false
		-- 			end)
		-- 		end
		-- 	end
		-- end)

		Keybinds:Add("tackle", "", "keyboard", "Tackle", function()
			if LocalPlayer.state.Character ~= nil then
				if
					not LocalPlayer.state.isCuffed
					and not LocalPlayer.state.tpLocation
					and not IsPedInAnyVehicle(LocalPlayer.state.ped)
					and not LocalPlayer.state.playingCasino
				then
					if GetEntitySpeed(LocalPlayer.state.ped) > 2.0 then
						local cPlayer, dist = Game.Players:GetClosestPlayer()
						local tarPlayer = GetPlayerServerId(cPlayer)
						if tarPlayer ~= 0 and dist <= 2.0 and GetGameTimer() - lastTackle > 7000 then
							lastTackle = GetGameTimer()
							TriggerServerEvent("Police:Server:Tackle", tarPlayer)

							loadAnimDict("swimming@first_person@diving")

							if
								IsEntityPlayingAnim(
									LocalPlayer.state.ped,
									"swimming@first_person@diving",
									"dive_run_fwd_-45_loop",
									3
								)
							then
								ClearPedSecondaryTask(LocalPlayer.state.ped)
							else
								TaskPlayAnim(
									LocalPlayer.state.ped,
									"swimming@first_person@diving",
									"dive_run_fwd_-45_loop",
									8.0,
									-8,
									-1,
									49,
									0,
									0,
									0,
									0
								)
								Wait(350)
								ClearPedSecondaryTask(LocalPlayer.state.ped)
								SetPedToRagdoll(LocalPlayer.state.ped, 500, 500, 0, 0, 0, 0)
							end
						else
							StupidRagdoll(true)
						end
					else
						StupidRagdoll(false)
					end
				end
			end
		end)

		Targeting.Zones:AddBox("pd-clockinoff-mrpd", "clipboard-list", vector3(441.96, -981.94, 30.69), 1.2, 1.2, {
			heading = 356,
			minZ = 30.49,
			maxZ = 31.49,
		}, policeDutyPoint, 2.0, true)

		Targeting.Zones:AddBox("pd-clockinoff-sandy", "clipboard-list", vector3(1833.55, 3678.69, 34.19), 1.0, 3.0, {
			heading = 30,
			--debugPoly=true,
			minZ = 33.79,
			maxZ = 35.59
		}, policeDutyPoint, 2.0, true)

		Targeting.Zones:AddBox("pd-clockinoff-pbpd", "clipboard-list", vector3(-447.18, 6013.36, 32.29), 0.8, 1.6, {
			heading = 45,
			minZ = 32.29,
			maxZ = 32.89,
		}, policeDutyPoint, 2.0, true)

		Targeting.Zones:AddBox("pd-clockinoff-davis", "clipboard-list", vector3(381.37, -1595.84, 30.05), 2.0, 1.0, {
			heading = 320,
			minZ = 29.85,
			maxZ = 31.05,
		}, policeDutyPoint, 2.0, true)

		Targeting.Zones:AddBox("pd-clockinoff-lamesa", "clipboard-list", vector3(837.23, -1289.2, 28.24), 0.8, 2.2, {
			heading = 0,
			--debugPoly=true,
			minZ = 27.24,
			maxZ = 29.04,
		}, policeDutyPoint, 2.0, true)

		Targeting.Zones:AddBox("pd-clockinoff-courthouse", "clipboard-list", vector3(-528.46, -189.44, 38.23), 1.0, 1.0, {
			heading = 30,
			--debugPoly=true,
			minZ = 37.63,
			maxZ = 39.23
		}, policeDutyPoint, 2.0, true)

		for k, v in ipairs(_pdStationPolys) do
			--print(v.options.name)
			Polyzone.Create:Poly(v.options.name, v.points, v.options, v.data)
		end

		Callbacks:RegisterClientCallback("Police:DeploySpikes", function(data, cb)
			Progress:ProgressWithStartEvent({
				name = "spikestrips",
				duration = 1000,
				label = "Laying Spikes",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
					anim = "plant_floor",
				},
				disarm = true,
			}, function()
				Weapons:UnequipIfEquippedNoAnim()
			end, function(status)
				if not status then
					local h = GetEntityHeading(PlayerPedId())
					local positions = {}
					for i = 1, 3 do
						table.insert(
							positions,
							GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, -1.5 + (3.5 * i), 0.15)
						)
					end
					cb({
						positions = positions,
						h = h,
					})
				else
					cb(nil)
				end
			end)
		end)

		Targeting.Zones:AddBox("prison-clockinoff", "clipboard", vector3(1838.94, 2578.14, 46.01), 2.0, 0.8, {
			heading = 305,
			--debugPoly=true,
			minZ = 45.81,
			maxZ = 46.61,
		}, {
			{
				icon = "clipboard-check",
				text = "Go On Duty",
				event = "Corrections:Client:OnDuty",
				jobPerms = {
					{
						job = "prison",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty",
				event = "Corrections:Client:OffDuty",
				jobPerms = {
					{
						job = "prison",
						reqDuty = true,
					},
				},
			},
			{
				icon = "clipboard-check",
				text = "Go On Duty (Medical)",
				event = "EMS:Client:OnDuty",
				jobPerms = {
					{
						job = "ems",
						workplace = "prison",
						reqOffDuty = true,
					},
				},
			},
			{
				icon = "clipboard",
				text = "Go Off Duty (Medical)",
				event = "EMS:Client:OffDuty",
				jobPerms = {
					{
						job = "ems",
						workplace = "prison",
						reqDuty = true,
					},
				},
			},
		}, 2.0, true)

		local locker = {
			{
				icon = "user-lock",
				text = "Open Personal Locker",
				event = "Police:Client:OpenLocker",
				jobPerms = {
					{
						job = "police",
						reqDuty = false,
					},
				},
			},
		}

		Targeting.Zones:AddBox("police-shitty-locker", "land-mine-on", vector3(461.59, -1000.0, 30.69), 1.0, 3.8, {
			heading = 0,
			--debugPoly=true,
			minZ = 29.69,
			maxZ = 32.69,
		}, locker, 3.0, true)

		Targeting.Zones:AddBox("police-shitty-locker-2", "land-mine-on", vector3(1841.51, 3682.08, 34.19), 2.0, 1, {
			heading = 30,
			--debugPoly=true,
			minZ = 33.19,
			maxZ = 35.59
		}, locker, 3.0, true)

		Targeting.Zones:AddBox("police-shitty-locker-3", "land-mine-on", vector3(-436.32, 6009.79, 37.0), 0.2, 2.2, {
			heading = 45,
			--debugPoly=true,
			minZ = 36.3,
			maxZ = 38.1,
		}, locker, 3.0, true)

		Targeting.Zones:AddBox("police-shitty-locker-4", "land-mine-on", vector3(360.08, -1592.9, 25.45), 0.5, 2.8, {
			heading = 50,
			--debugPoly=true,
			minZ = 24.45,
			maxZ = 27.45,
		}, locker, 3.0, true)

		Targeting.Zones:AddBox("police-shitty-locker-5", "land-mine-on", vector3(844.8, -1286.55, 28.24), 2.0, 1.2, {
			heading = 0,
			--debugPoly=true,
			minZ = 27.24,
			maxZ = 29.84,
		}, locker, 3.0, true)

		Targeting.Zones:AddBox("ems-shitty-locker-2", "land-mine-on", vector3(-439.04, -309.88, 34.91), 0.8, 0.8, {
			heading = 20,
			--debugPoly=true,
			minZ = 33.71,
			maxZ = 36.11,
		}, {
			{
				icon = "user-lock",
				text = "Open Personal Locker",
				event = "Police:Client:OpenLocker",
				jobPerms = {
					{
						job = "ems",
						reqDuty = false,
					},
				},
			},
		}, 3.0, true)
	end)
end)

AddEventHandler("Police:Client:DoApartmentBreach", function(values, data)
	Callbacks:ServerCallback("Police:Breach", {
		type = "apartment",
		property = tonumber(values.unit),
		id = data,
	}, function(s)
		if s then
			
		end
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Police", POLICE)
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	for k, v in ipairs(policeStationBlips) do
		Blips:Add("police_station_" .. k, "Police Department", v, 137, 38, 0.6)
	end
end)

RegisterNetEvent("Police:Client:Breached", function(type, id)
	_breached[type] = _breached[type] or {}
	_breached[type][id] = GlobalState["OS:Time"] + (60 * 5)
end)

RegisterNetEvent("Police:Client:GetTackled", function(s)
	if LocalPlayer.state.loggedIn then
		SetPedToRagdoll(LocalPlayer.state.ped, math.random(3000, 5000), math.random(3000, 5000), 0, 0, 0, 0)
		lastTackle = GetGameTimer()
	end
end)

POLICE = {
	IsPdCar = function(self, entity)
		return _pdModels[GetEntityModel(entity)]
	end
}

function StupidRagdoll(tackleAnim)
	local time = 5000
	if tackleAnim then
		TaskPlayAnim(
			LocalPlayer.state.ped,
			"swimming@first_person@diving",
			"dive_run_fwd_-45_loop",
			8.0,
			-8,
			-1,
			49,
			0,
			0,
			0,
			0
		)
		time = 1000
	end
	Wait(350)
	ClearPedSecondaryTask(LocalPlayer.state.ped)
	SetPedToRagdoll(LocalPlayer.state.ped, time, time, 0, 0, 0, 0)
end
