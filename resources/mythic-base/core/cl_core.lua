COMPONENTS.Core = {
	_required = { "Init" },
	_name = "base",
}

Citizen.CreateThread(function()
	LocalPlayer.state.PlayerID = PlayerId()
	StatSetInt(`MP0_STAMINA`, 25, true)

	AddStateBagChangeHandler(
		"isAdmin",
		string.format("player:%s", GetPlayerServerId(LocalPlayer.state.PlayerID)),
		function(bagName, key, value, _unused, replicated)
			if value then
				StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
			else
				StatSetInt(`MP0_SHOOTING_ABILITY`, 5, true)
			end
		end
	)
end)

_baseThreading = false
function COMPONENTS.Core.Init(self)
	if _baseThreading then
		return
	end
	_baseThreading = true

	ShutdownLoadingScreenNui()
	ShutdownLoadingScreen()

	LocalPlayer.state.ped = PlayerPedId()
	LocalPlayer.state.myPos = GetEntityCoords(LocalPlayer.state.ped)

	SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN", false)
	SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", false)

	Citizen.CreateThread(function()
		while _baseThreading do
			Citizen.Wait(1000)
			local ped = PlayerPedId()
			if ped ~= LocalPlayer.state.ped then
				LocalPlayer.state.ped = ped
				SetEntityProofs(LocalPlayer.state.ped, false, false, false, false, false, true, false, false)
				SetPedDropsWeaponsWhenDead(LocalPlayer.state.ped, false)
				SetPedAmmoToDrop(LocalPlayer.state.ped, 0)
				TriggerEvent("Weapons:Client:Attach")
			end
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			Citizen.Wait(60000)
			collectgarbage("collect")
		end 
	end)	

	Citizen.CreateThread(function()
		while _baseThreading do
			Citizen.Wait(100)
			LocalPlayer.state.myPos = GetEntityCoords(LocalPlayer.state.ped)
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			if NetworkIsPlayerActive(PlayerId()) then
				TriggerEvent("Core:Client:SessionStarted")
				TriggerServerEvent("Core:Server:SessionStarted")
				break
			end
			Citizen.Wait(100)
		end
	end)

	Citizen.CreateThread(function()
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

			if IsPedInCover(LocalPlayer.state.ped, 0) and not IsPedAimingFromCover(LocalPlayer.state.ped) then
				DisablePlayerFiring(LocalPlayer.state.ped, true)
			end
			Citizen.Wait(1)
		end
	end)

	Citizen.CreateThread(function()
		while _baseThreading do
			InvalidateIdleCam()
			InvalidateVehicleIdleCam()
			Wait(25000)
		end
	end)

	Citizen.CreateThread(function()
		for i = 1, 25 do
			EnableDispatchService(i, false)
		end

		while _baseThreading do
			local ped = PlayerPedId()
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

			Citizen.Wait(2)
		end
	end)

	Citizen.CreateThread(function()
		local resetcounter = 0
		local jumpDisabled = false

		while _baseThreading do
			Citizen.Wait(100)
			if jumpDisabled and resetcounter > 0 and IsPedJumping(PlayerPedId()) then
				SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
				resetcounter = 0
			end

			if not jumpDisabled and IsPedJumping(PlayerPedId()) then
				jumpDisabled = true
				resetcounter = 10
				Citizen.Wait(1200)
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

Citizen.CreateThread(function()
	while not exports or exports[GetCurrentResourceName()] == nil do
		Citizen.Wait(1)
	end

	COMPONENTS.Core:Init()

	TriggerEvent("Proxy:Shared:RegisterReady")
	for k, v in pairs(COMPONENTS) do
		TriggerEvent("Proxy:Shared:ExtendReady", k)
	end

	Citizen.Wait(1000)

	COMPONENTS.Proxy.ExportsReady = true
	TriggerEvent("Core:Shared:Ready")
	return
end)

AddEventHandler("onResourceStopped", function(resourceName)
	TriggerServerEvent("Core:Server:ResourceStopped", resourceName)
end)