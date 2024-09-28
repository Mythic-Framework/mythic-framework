local _inPoly = true

local _cabinets = {
	{
		coords = vector3(224.33, 373.39, 106.15),
		length = 1.3,
		width = 1.0,
		options = {
			heading = 341,
			--debugPoly = true,
			minZ = 105.15,
			maxZ = 107.75,
		},
	},
}

local _pdAlarm = vector3(-630.732, -237.111, 38.078)
local _officeHack = vector3(226.563, 370.663, 106.556)

local _weapons = {
	[GetHashKey("WEAPON_CROWBAR")] = true,
	[GetHashKey("WEAPON_PONY")] = true,
	[GetHashKey("WEAPON_HAMMER")] = true,
	[GetHashKey("WEAPON_BAT")] = true,
	[GetHashKey("WEAPON_DRBAT")] = true,
	[GetHashKey("WEAPON_SLEDGE")] = true,
	[GetHashKey("WEAPON_GOLFCLUB")] = true,
	[GetHashKey("WEAPON_STONE_HATCHET")] = true,
	[GetHashKey("WEAPON_WRENCH")] = true,
	[GetHashKey("WEAPON_SHOVEL")] = true,
}

AddEventHandler("Robbery:Client:Setup", function()
	Polyzone.Create:Poly("vangelico", {
		vector2(-627.94396972656, -240.6435546875),
		vector2(-636.67626953125, -229.46875),
		vector2(-620.25476074219, -220.87989807129),
		vector2(-612.01623535156, -234.92085266113),
	}, {
		minZ = 35.0,
		maxZ = 40.0,
		--debugPoly = true,
	})

	Targeting.Zones:AddBox("vangelico-pd", "calculator", vector3(-620.09, -223.81, 38.06), 1.0, 1.0, {
		name = "vangelico-pd",
		heading = 35,
		--debugPoly = true,
		minZ = 37.91,
		maxZ = 39.11,
	}, {
		{
			icon = "calculator",
			text = "Secure Store",
			event = "Robbery:Client:Vangelico:SecureStore",
			data = {},
			jobPerms = {
				{
					job = "police",
					reqDuty = true,
				},
			},
			isEnabled = function(data)
				return GlobalState["Vangelico:State"] == 1
			end,
		},
	})

	while not GlobalState["VangelicoCases"] do
		Wait(10)
	end

	for k, v in ipairs(GlobalState["VangelicoCases"]) do
		local pId = string.format("Vangelico:Case:%s", k)
		Targeting.Zones:AddBox(pId, "container-storage", v.coords, v.length, v.width, v.options, {
			{
				icon = "hammer",
				text = "Smash Case",
				event = "Robbery:Client:Vangelico:BreakCase",
				data = {
					index = k,
					coords = v.coords,
				},
				isEnabled = function(data)
					return (
							(GlobalState["Duty:police"] or 0) >= GlobalState["VangelicoRequiredPd"]
							or GlobalState["Vangelico:InProgress"]
						)
						and not GlobalState['RobberiesDisabled']
						and (not GlobalState["RestartLockdown"] or (GlobalState["RestartLockdown"] and GlobalState["Vangelico:InProgress"]))
						and (not GlobalState["AntiShitlord"] or GetCloudTimeAsInt() > GlobalState["AntiShitlord"] or GlobalState["Vangelico:InProgress"])
						and GlobalState["Vangelico:State"] ~= 2
						and (
							(not GlobalState[pId] or GlobalState[pId] < GlobalState["OS:Time"])
							and _weapons[GetSelectedPedWeapon(LocalPlayer.state.ped)]
						)
				end,
			},
		}, 3.0, true)
	end

	-- for k, v in ipairs(_cabinets) do
	-- 	local pId = string.format("Vangelico:Cabinet:%s", k)
	-- 	Targeting.Zones:AddBox(pId, "container-storage", v.coords, v.length, v.width, v.options, {
	-- 		{
	-- 			icon = "cabinet-filing",
	-- 			text = "Search Filing Cabinet",
	-- 			event = "Robbery:Client:Vangelico:SearchCabinet",
	-- 			data = {
	-- 				index = k,
	-- 				coords = v.coords,
	-- 			},
	-- 			isEnabled = function(data)
	-- 				return not GlobalState[pId] and _weapons[GetSelectedPedWeapon(LocalPlayer.state.ped)]
	-- 			end,
	-- 		},
	-- 	}, 3.0, true)
	-- end
end)

AddEventHandler("Robbery:Client:Vangelico:SecureStore", function(entity, data)
	Progress:Progress({
		name = "secure_vangelico",
		duration = 30000,
		label = "Securing",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			anim = "cop3",
		},
	}, function(status)
		if not status then
			Callbacks:ServerCallback("Robbery:Vangelico:SecureStore")
		end
	end)
end)

AddEventHandler("Polyzone:Enter", function(id, point, insideZones, data)
	if id == "vangelico" then
		Targeting:AddObject(GetHashKey("hei_prop_hei_keypad_03"), "calculator", {
			-- {
			-- 	icon = "bell",
			-- 	text = "Disable Alarm",
			-- 	event = "Robbery:Client:Vangelico:DisableAlarm",
			-- 	jobs = { "police" },
			-- 	jobDuty = true,
			-- 	data = {},
			-- 	isEnabled = function()
			-- 		local dist = #(
			-- 				vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z)
			-- 				- _pdAlarm
			-- 			)
			-- 		return dist <= 2.0 and GlobalState["Vangelico:Alarm"]
			-- 	end,
			-- },
			-- {
			-- 	icon = "terminal",
			-- 	text = "Hack Keypad",
			-- 	event = "Robbery:Client:Vangelico:HackKeypad",
			-- 	item = "sequencer",
			-- 	data = {},
			-- 	isEnabled = function()
			-- 		local dist = #(
			-- 				vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z)
			-- 				- _officeHack
			-- 			)
			-- 		return dist <= 2.0 and not GlobalState["Vangelico:Lockdown"]
			-- 	end,
			-- },
			-- {
			-- 	icon = "address-card",
			-- 	text = "Use Keycard",
			-- 	event = "Robbery:Client:Vangelico:UseKeycard",
			-- 	item = "xg_keycard",
			-- 	data = {},
			-- 	isEnabled = function()
			-- 		local dist = #(
			-- 				vector3(LocalPlayer.state.position.x, LocalPlayer.state.position.y, LocalPlayer.state.position.z)
			-- 				- _officeHack
			-- 			)
			-- 		return dist <= 2.0 and not GlobalState["Vangelico:Lockdown"]
			-- 	end,
			-- },
		}, 3.0)
	end
end)

AddEventHandler("Polyzone:Exit", function(id, point, insideZones, data)
	if id == "vangelico" then
		Targeting:RemoveObject(GetHashKey("hei_prop_hei_keypad_03"))
	end
end)

function loadParticle()
	if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
		RequestNamedPtfxAsset("scr_jewelheist")
	end
	while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
		Wait(0)
	end
	SetPtfxAssetNextCall("scr_jewelheist")
end

function loadAnimation()
	loadAnimDict("missheist_jewel")
	TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2.0, "robberyglassbreak", 0.5)
	TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
	Wait(2200)
end

AddEventHandler("Robbery:Client:Vangelico:BreakCase", function(entity, data)
	local pId = string.format("Vangelico:Case:%s", data.index)
	if
		(not GlobalState[pId] or GlobalState[pId] < GlobalState["OS:Time"])
		and _weapons[GetSelectedPedWeapon(LocalPlayer.state.ped)]
	then
		loadParticle()
		TaskTurnPedToFaceCoord(LocalPlayer.state.ped, data.coords.x, data.coords.y, data.coords.z, 1.0)

		CreateThread(function()
			Wait(600)
			Sounds.Play:Location(data.coords, 10.0, "jewel_glass.ogg", 0.15)
			StartParticleFxLoopedAtCoord(
				"scr_jewel_cab_smash",
				data.coords.x,
				data.coords.y,
				data.coords.z,
				0.0,
				0.0,
				0.0,
				1.0,
				false,
				false,
				false,
				false
			)
		end)

		Progress:ProgressWithTickEvent({
			name = "vangelico_action",
			duration = (math.random(10) * 1000) + 50000,
			label = "Robbing",
			tickrate = 100,
			useWhileDead = false,
			canCancel = true,
			vehicle = false,
			disarm = false,
			ignoreModifier = true,
			controlDisables = {
				disableMovement = true,
				disableCarMovement = true,
				disableCombat = true,
			},
			animation = {
				animDict = "missheist_jewel",
				anim = "smash_case",
				flags = 17,
			},
		}, function()
			if
				(not GlobalState[pId] or GlobalState[pId] < GlobalState["OS:Time"])
				and _weapons[GetSelectedPedWeapon(LocalPlayer.state.ped)]
			then
				return
			end
			Progress:Cancel()
		end, function(cancelled)
			if not cancelled then
				Callbacks:ServerCallback("Robbery:Vangelico:BreakCase", data.index)
			end
		end)
	end
end)
