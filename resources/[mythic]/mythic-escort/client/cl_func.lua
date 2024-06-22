local _gJobs = {
	police = 3000,
	ems = 1500,
}

function DoEscort()
	local cPlayer, Dist = Game.Players:GetClosestPlayer()
	local tarPlayer = GetPlayerServerId(cPlayer)

	if LocalPlayer.state.myEscorter == nil and not LocalPlayer.state.isDead then
		if tarPlayer ~= 0 and Dist <= 1 then
			local tState = Player(tarPlayer).state
			if
				LocalPlayer.state.isEscorting == nil
				and not IsPedInAnyVehicle(LocalPlayer.state.ped, true)
				and not IsPedInAnyVehicle(GetPlayerPed(tarPlayer), true)
				and not Hud:IsDisabledAllowDead()
				and not tState.isHospitalized
				and (tState.isEscorting == nil and tState.myEscorter == nil)
			then
				Escort:DoEscort(tarPlayer, cPlayer)
			elseif LocalPlayer.state.isEscorting ~= nil then
				Escort:StopEscort()
			end
		end
	end
end

function StartEscortThread(t)
	while LocalPlayer.state.isEscorting == nil do
		Wait(10)
	end

	CreateThread(function()
		local ped = GetPlayerPed(t)
		local myped = PlayerPedId()

		while LocalPlayer.state.isEscorting ~= nil do
			if (not LocalPlayer.state.onDuty or (LocalPlayer.state.onDuty ~= "ems")) and not IsPedSwimming(ped) then
				DisableControlAction(1, 21, true) -- Sprint
			end
			DisableControlAction(1, 23, true) -- F
			Wait(5)
		end
	end)
end

RegisterNetEvent("Escort:Client:Escorted", function()
	while LocalPlayer.state.myEscorter == nil do
		Wait(10)
	end

	if LocalPlayer.state.isCuffed then
		TriggerEvent("Handcuffs:Client:DoShittyAnim")
	end

	if LocalPlayer.state.sitting then
		TriggerEvent("Animations:Client:StandUp", true)
	end

	if LocalPlayer.state.doingAction then
		Progress:Cancel()
	end

	CreateThread(function()
		local ped = GetPlayerPed(GetPlayerFromServerId(LocalPlayer.state.myEscorter))
		local myped = PlayerPedId()

		while not DoesEntityExist(ped) do
			Wait(1)
			ped = GetPlayerPed(GetPlayerFromServerId(LocalPlayer.state.myEscorter))
		end

		AttachEntityToEntity(
			LocalPlayer.state.ped,
			ped,
			11816,
			0.54,
			0.44,
			0.0,
			0.0,
			0.0,
			0.0,
			false,
			false,
			false,
			false,
			2,
			true
		)
		while LocalPlayer.state.myEscorter ~= nil do
			DisableControlAction(1, 21, true) -- Sprint
			DisableControlAction(1, 22, true) -- Jump
			DisableControlAction(1, 23, true) -- F
			Wait(5)
		end
		DetachEntity(LocalPlayer.state.ped, true, true)
	end)
end)

AddEventHandler("Escort:Client:PutIn", function(entity, data)
	Callbacks:ServerCallback("Escort:DoPutIn", {
		veh = NetworkGetNetworkIdFromEntity(entity.entity),
		class = GetVehicleClass(entity.entity),
		seatCount = GetVehicleModelNumberOfSeats(GetEntityModel(entity.entity)),
	}, function(state) end)
end)

AddEventHandler("Escort:Client:PullOut", function(entity, data)
	local vehmodel = GetEntityModel(entity.entity)
	for i = -1, GetVehicleModelNumberOfSeats(vehmodel) do
		local ent = GetPedInVehicleSeat(entity.entity, i)
		if ent ~= 0 then
			local dur = 5000
			if _gJobs[LocalPlayer.state.onDuty] ~= nil then
				dur = _gJobs[LocalPlayer.state.onDuty]
			end

			Progress:ProgressWithTickEvent({
				name = "unseat",
				duration = dur,
				label = "Unseating",
				useWhileDead = false,
				canCancel = true,
				animation = false,
				ignoreModifier = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
			}, function()
				if
					#(GetEntityCoords(LocalPlayer.state.ped) - GetEntityCoords(entity.entity)) <= 5.0
					and GetPedInVehicleSeat(entity.entity, i) == ent
				then
					return
				end
				Progress:Cancel()
			end, function(cancelled)
				if not cancelled then
					local playerId = NetworkGetPlayerIndexFromPed(ent)
					Escort:DoEscort(GetPlayerServerId(playerId), playerId)
				end
			end)
		end
	end
end)
