THREAD_VEHICLE = false
THREAD_VEHICLE_CLASS = 0

SWITCH_BACK_DELAY = 100

THREAD_TASKS = {}
PRE_THREAD_TASKS = {}

function AddTaskToVehicleThread(id, tickRatePerSecond, onlyInside, func, exitTrigger)
	THREAD_TASKS[id] = {
		max = tickRatePerSecond,
		current = 0,
		func = func,
		onlyInside = onlyInside,
		exitTrigger = exitTrigger,
	}
end

function AddTaskBeforeVehicleThread(id, func)
	PRE_THREAD_TASKS[id] = {
		func = func,
	}
end

AddEventHandler("Vehicles:Client:BecameDriver", function(veh, seat, class)
	CreateThread(function()
		if THREAD_VEHICLE then
			THREAD_VEHICLE = false
		end

		for k, v in pairs(THREAD_TASKS) do
			v.current = 0
		end

		if ResetVehicleHandlingOverrides then
			ResetVehicleHandlingOverrides(veh)
		end

		NetworkRequestControlOfEntity(veh)

		Logger:Trace("Vehicles", "Execute Vehicle Pre Thread Tasks")

		for k, v in pairs(PRE_THREAD_TASKS) do
			v.func(veh, class)
		end

		Logger:Trace("Vehicles", "Start Vehicle Thread on " .. veh)
		THREAD_VEHICLE = veh
		THREAD_VEHICLE_CLASS = GetVehicleClass(THREAD_VEHICLE)
	end)
end)

AddEventHandler("Vehicles:Client:ExitVehicle", function(veh)
	local engineRunning = GetIsVehicleEngineRunning(veh)
	for k, v in pairs(THREAD_TASKS) do
		if v.exitTrigger then
			v.func(THREAD_VEHICLE, THREAD_VEHICLE_CLASS, engineRunning, isInside, true)
		end
	end
end)

AddEventHandler("Vehicles:Client:CharacterLogin", function()
	CreateThread(function()
		while _characterLoaded do
			if THREAD_VEHICLE then
				if DoesEntityExist(THREAD_VEHICLE) then
					local engineRunning = GetIsVehicleEngineRunning(THREAD_VEHICLE)
					local isInside = VEHICLE_INSIDE and VEHICLE_SEAT == -1

					for k, v in pairs(THREAD_TASKS) do
						if not v.onlyInside or (v.onlyInside and isInside) then
							if v.current >= v.max then
								v.func(THREAD_VEHICLE, THREAD_VEHICLE_CLASS, engineRunning, isInside)
								v.current = 0
							else
								v.current = v.current + 1
							end
						end
					end
				else
					THREAD_VEHICLE = false
				end
			else
				Wait(1000)
			end
			Wait(250)
		end
	end)

	local cleanupTick = 0
	local syncTick = 0

	CreateThread(function()
		while _characterLoaded do
			local vehicles = GetGamePool("CVehicle")
			local tryingToEnter = GetVehiclePedIsTryingToEnter(GLOBAL_PED)
			local doSync = false
			syncTick = syncTick + 1
			if syncTick >= 3 then
				syncTick = 0
				doSync = true
			end
			for k, v in ipairs(vehicles) do
				if NetworkGetEntityIsNetworked(v) then
					if
						(not IsEntityDead(v) and v ~= VEHICLE_INSIDE and tryingToEnter ~= v)
						and NetworkHasControlOfEntity(v)
					then
						local sb = Entity(v).state
						if sb and sb.VEH_IGNITION then
							SetVehicleEngineOn(v, true, true, true)
						end
					end

					if doSync then
						if not SYNCED_VEHICLES[v] then
							AddSyncedVehicle(v)
						end

						if NetworkHasControlOfEntity(v) then
							local state = Entity(v).state
							if state and state.VIN then
								local data = state.awaitingProperties
								if data then
									Logger:Info(
										"Vehicles",
										string.format("Applying Vehicle Properties To Vehicle VIN: %s", state.VIN)
									)
									if data.needInit then
										local properties = GetVehicleProperties(v, true)
										TriggerServerEvent(
											"Vehicles:Server:PlayerSetProperties",
											state.ServerEntity,
											properties
										)
										state:set("awaitingProperties", false, true)
									else
										SetVehicleProperties(v, data.properties)
										if data.damage then
											SetVehicleDamageData(v, data.damage)
										end
										state:set("awaitingProperties", false, true)
									end
								end

								if state.awaitingEngineHealth then
									SetVehicleEngineHealth(v, state.awaitingEngineHealth + 0.0)
									state:set("awaitingEngineHealth", false, true)
								end

								if state.awaitingBlownUp then
									NetworkExplodeVehicle(v, 0, 0, 0)
									state:set("awaitingBlownUp", false, true)
								end
							end
						end
					end
				end
			end

			cleanupTick = cleanupTick + 1
			if cleanupTick >= 7 then
				cleanupTick = 0
				if RunVehicleSyncCleanup then
					RunVehicleSyncCleanup()
				end
			end

			Wait(750)
		end
	end)

    CreateThread( function()
		local restoreMode1, restoreMode2 = nil, nil
        while _characterLoaded do
			if IsPedInAnyVehicle(LocalPlayer.state.ped) then
				playerPed = PlayerPedId()
				if IsPedArmed(playerPed, 6) then
					if IsPedDoingDriveby(playerPed) then
						if GetFollowPedCamViewMode() <= 2 or GetFollowVehicleCamViewMode() <= 2 then
							LocalPlayer.state.adjustingCam = true
							local curWeapon = Weapons:GetEquippedHash()
							SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
							SetCurrentPedVehicleWeapon(playerPed, `WEAPON_UNARMED`)
							SetPlayerCanDoDriveBy(PlayerId(),false)
							restoreMode1 = GetFollowPedCamViewMode()
							restoreMode2 = GetFollowVehicleCamViewMode()
							SetFollowPedCamViewMode(4)
							SetFollowVehicleCamViewMode(4)
							SetCamViewModeForContext(2, 4)
							SetCamViewModeForContext(3, 4)
							Wait(250)
							SetCurrentPedWeapon(playerPed, curWeapon, true)
							SetCurrentPedVehicleWeapon(playerPed, curWeapon)
							SetPlayerCanDoDriveBy(PlayerId(), true)
							LocalPlayer.state.adjustingCam = false
						end
					else
						DisableControlAction(0,36,true)
						if GetPedStealthMovement(playerPed) == 1 then
							SetPedStealthMovement(playerPed,0)
						end

						if restoreMode1 ~= nil or restoreMode2 ~= nil then
							if restoreMode1 ~= nil then
								SetFollowPedCamViewMode(restoreMode1)
								restoreMode1 = nil
							end
							if restoreMode2 ~= nil then
								SetFollowVehicleCamViewMode(restoreMode2)
								SetCamViewModeForContext(2, restoreMode2)
								SetCamViewModeForContext(3, restoreMode2)
								restoreMode2 = nil
							end
						end
					end
				end
				Wait(1)
			else
				Wait(200)
			end
        end
    end)
end)