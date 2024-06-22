COMPONENTS.Core = {
	_required = { "Init" },
	_name = "base",
}

local function disableScenarios()
	local scenarios = {
		"WORLD_MOUNTAIN_LION_REST",
		"WORLD_MOUNTAIN_LION_WANDER",
		"DRIVE",
		"WORLD_VEHICLE_POLICE_BIKE",
		"WORLD_VEHICLE_POLICE_CAR",
		"WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
		"WORLD_VEHICLE_DRIVE_SOLO",
		"WORLD_VEHICLE_BIKER",
		"WORLD_VEHICLE_DRIVE_PASSENGERS",
		"WORLD_VEHICLE_SALTON_DIRT_BIKE",
		"WORLD_VEHICLE_BICYCLE_MOUNTAIN",
		"PROP_HUMAN_SEAT_CHAIR",
		"WORLD_VEHICLE_ATTRACTOR",
		"WORLD_HUMAN_LEANING",
		"WORLD_HUMAN_HANG_OUT_STREET",
		"WORLD_HUMAN_DRINKING",
		"WORLD_HUMAN_SMOKING",
		"WORLD_HUMAN_GUARD_STAND",
		"WORLD_HUMAN_CLIPBOARD",
		"WORLD_HUMAN_HIKER",
		"WORLD_VEHICLE_EMPTY",
		"WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
		"WORLD_HUMAN_PAPARAZZI",
		"WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
		"WORLD_VEHICLE_PARK_PARALLEL",
		"WORLD_VEHICLE_CONSTRUCTION_SOLO",
		"WORLD_VEHICLE_CONSTRUCTION_PASSENGERS",
		"WORLD_VEHICLE_TRUCK_LOGS",
		"WORLD_VEHICLE_AMBULANCE",
		"WORLD_VEHICLE_BICYCLE_BMX",
		"WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
		"WORLD_VEHICLE_BICYCLE_BMX_FAMILY",
		"WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
		"WORLD_VEHICLE_BICYCLE_BMX_VAGOS",
		"WORLD_VEHICLE_BICYCLE_ROAD",
		"WORLD_VEHICLE_BOAT_IDLE",
		"WORLD_VEHICLE_BOAT_IDLE_ALAMO",
		"WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
		"WORLD_VEHICLE_BROKEN_DOWN",
		"WORLD_VEHICLE_BUSINESSMEN",
		"WORLD_VEHICLE_HELI_LIFEGUARD",
		"WORLD_VEHICLE_CLUCKIN_BELL_TRAILER",
		"WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED",
		"WORLD_VEHICLE_FARM_WORKER",
		"WORLD_VEHICLE_FIRE_TRUCK",
		"WORLD_VEHICLE_MARIACHI",
		"WORLD_VEHICLE_MECHANIC",
		"WORLD_VEHICLE_MILITARY_PLANES_BIG",
		"WORLD_VEHICLE_MILITARY_PLANES_SMALL",
		"WORLD_VEHICLE_PASSENGER_EXIT",
		"WORLD_VEHICLE_POLICE",
		"WORLD_VEHICLE_QUARRY",
		"WORLD_VEHICLE_SALTON",
		"WORLD_VEHICLE_SECURITY_CAR",
		"WORLD_VEHICLE_STREETRACE",
		"WORLD_VEHICLE_TOURBUS",
		"WORLD_VEHICLE_TOURIST",
		"WORLD_VEHICLE_TANDL",
		"WORLD_VEHICLE_TRACTOR",
		"WORLD_VEHICLE_TRACTOR_BEACH",
		"WORLD_VEHICLE_TRUCKS_TRAILERS",
		"WORLD_VEHICLE_DISTANT_EMPTY_GROUND",
	}

	for i = 1, #scenarios do
		SetScenarioTypeEnabled(scenarios[i], false)
	end

	SetMaxWantedLevel(0)
	SetCreateRandomCopsNotOnScenarios(false)
	SetCreateRandomCops(false)
	SetCreateRandomCopsOnScenarios(false)
end

local function disableDispatch()
	for i = 1, 32 do
		EnableDispatchService(i, false)
	end
end

CreateThread(function()
	LocalPlayer.state:set('clientID', PlayerId())
	LocalPlayer.state:set('serverID', GetPlayerServerId(PlayerId()))
	StatSetInt(`MP0_STAMINA`, 25, true)

	AddStateBagChangeHandler(
		"isAdmin",
		string.format("player:%s", LocalPlayer.state.serverID),
		function(bagName, key, value, _unused, replicated)
			if value then
				StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
			else
				StatSetInt(`MP0_SHOOTING_ABILITY`, 5, true)
			end
		end
	)
end)

local _baseThreading = false
function COMPONENTS.Core.Init(self)
	if _baseThreading then
		return
	end
	_baseThreading = true

	ShutdownLoadingScreenNui()
	ShutdownLoadingScreen()

	LocalPlayer.state:set('ped', PlayerPedId())
	LocalPlayer.state:set('position', GetEntityCoords(LocalPlayer.state.ped))

	disableScenarios()
	disableDispatch()

	CreateThread(function()
		while _baseThreading do
			Wait(1000)
			local ped = PlayerPedId()
			if ped ~= LocalPlayer.state.ped then
				LocalPlayer.state:set('ped', ped)
				SetEntityProofs(LocalPlayer.state.ped, false, false, false, false, false, true, false, false)
				SetPedDropsWeaponsWhenDead(LocalPlayer.state.ped, false)
				SetPedAmmoToDrop(LocalPlayer.state.ped, 0)
				TriggerEvent("Weapons:Client:Attach")
			end
		end
	end)

	CreateThread(function()
		while _baseThreading do
			Wait(60000)
			collectgarbage("collect")
		end
	end)

	CreateThread(function()
		while _baseThreading do
			Wait(100)
			LocalPlayer.state:set('position', GetEntityCoords(LocalPlayer.state.ped))
		end
	end)

	CreateThread(function()
		while _baseThreading do
			if NetworkIsPlayerActive(PlayerId()) then
				TriggerEvent("Core:Client:SessionStarted")
				TriggerServerEvent("Core:Server:SessionStarted")
				break
			end
			Wait(100)
		end
	end)

	CreateThread(function()
		SetRadarBigmapEnabled(false, false)

		Wait(5)

		while _baseThreading do
			SetRadarBigmapEnabled(false, false)
			DisableControlAction(0, 14, true)
			DisableControlAction(0, 15, true)
			DisableControlAction(0, 16, true)
			DisableControlAction(0, 17, true)
			DisableControlAction(0, 37, true)
			DisableControlAction(0, 99, true)
			DisableControlAction(0, 100, true)
			DisableControlAction(0, 116, true)
			DisableControlAction(0, 157, true)
			DisableControlAction(0, 158, true)
			DisableControlAction(0, 159, true)
			DisableControlAction(0, 160, true)
			DisableControlAction(0, 161, true)
			DisableControlAction(0, 162, true)
			DisableControlAction(0, 163, true)
			DisableControlAction(0, 164, true)
			DisableControlAction(0, 165, true)
			DisableControlAction(0, 261, true)
			DisableControlAction(0, 262, true)
			HideHudComponentThisFrame(1)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(19)
			HideHudComponentThisFrame(20)
			--DontTiltMinimapThisFrame()

			SetVehicleDensityMultiplierThisFrame(0.3)
			SetPedDensityMultiplierThisFrame(0.8)
			SetRandomVehicleDensityMultiplierThisFrame(0.4)
			SetParkedVehicleDensityMultiplierThisFrame(0.5)
			SetScenarioPedDensityMultiplierThisFrame(0.8, 0.8)
			NetworkSetFriendlyFireOption(true)

			if IsPedInCover(LocalPlayer.state.ped, false) and not IsPedAimingFromCover(LocalPlayer.state.ped) then
				DisablePlayerFiring(LocalPlayer.state.ped, true)
			end
			Wait(1)
		end
	end)

	CreateThread(function()
		while _baseThreading do
			InvalidateIdleCam()
			InvalidateVehicleIdleCam()
			Wait(25000)
		end
	end)

	CreateThread(function()
		while _baseThreading do
			local ped = LocalPlayer.state.ped
			SetPedHelmet(ped, false)
			if IsPedInAnyVehicle(ped, false) then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
					SetPedConfigFlag(ped, 184, true)
					if GetIsTaskActive(ped, 165) then
						SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
					end
				end
			end

			SetMaxWantedLevel(0)
			SetCreateRandomCopsNotOnScenarios(false)
			SetCreateRandomCops(false)
			SetCreateRandomCopsOnScenarios(false)

			Wait(2)
		end
	end)

	CreateThread(function()
		local resetcounter = 0
		local jumpDisabled = false

		while _baseThreading do
			Wait(100)
			local ped = LocalPlayer.state.ped
			if jumpDisabled and resetcounter > 0 and IsPedJumping(ped) then
				SetPedToRagdoll(ped, 1000, 1000, 3, false, false, false)
				resetcounter = 0
			end

			if not jumpDisabled and IsPedJumping(ped) then
				jumpDisabled = true
				resetcounter = 10
				Wait(1200)
			end

			if resetcounter > 0 then
				resetcounter = resetcounter - 1
			else
				if jumpDisabled then
					resetcounter = 0
					jumpDisabled = false
				end
			end
		end
	end)
end

CreateThread(function()
	local resourceName = GetCurrentResourceName()
	while not exports or exports[resourceName] == nil do
		Wait(1)
	end

	COMPONENTS.Core:Init()

	TriggerEvent("Proxy:Shared:RegisterReady")
	for k, _ in pairs(COMPONENTS) do
		TriggerEvent("Proxy:Shared:ExtendReady", k)
	end

	Wait(1000)

	COMPONENTS.Proxy.ExportsReady = true
	TriggerEvent("Core:Shared:Ready")
	return
end)

AddEventHandler("onResourceStopped", function(resourceName)
	TriggerServerEvent("Core:Server:ResourceStopped", resourceName)
end)
