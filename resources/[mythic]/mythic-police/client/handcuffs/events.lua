AddEventHandler("Handcuffs:Client:DoCuffBreak", function()
	if _cuffPromise ~= nil then
		_cuffPromise:resolve(true)
		Notification:Success("You Broke Out Of The Cuffs")
	end
end)

AddEventHandler("Handcuffs:Client:FailCuffBreak", function()
	if _cuffPromise ~= nil then
		ResetTimer()
		_cuffPromise:resolve(false)
		Notification:Error("Failed Breaking Out Of Cuffs")
	end
end)

AddEventHandler("Handcuffs:Client:HardCuff", function(entity, data)
	TriggerServerEvent("Handcuffs:Server:HardCuff", entity.serverId)
end)

AddEventHandler("Handcuffs:Client:SoftCuff", function(entity, data)
	TriggerServerEvent("Handcuffs:Server:SoftCuff", entity.serverId)
end)

AddEventHandler("Handcuffs:Client:Uncuff", function(entity, data)
	TriggerServerEvent("Handcuffs:Server:Uncuff", entity.serverId)
end)

RegisterNetEvent("Handcuffs:Client:CuffingAnim", function()
	if not IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
		local animDict = "mp_arrest_paired"
		local anim = "cop_p2_back_right"

		loadAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Wait(0)
		end

		Wait(100)
		TaskPlayAnim(LocalPlayer.state.ped, animDict, anim, 8.0, -8, -1, 16, 0, 0, 0, 0)
		Wait(3250)
		ClearPedTasksImmediately(LocalPlayer.state.ped)
	end
end)

RegisterNetEvent("Handcuffs:Client:UncuffingAnim", function()
	if not IsPedInAnyVehicle(LocalPlayer.state.ped, true) then
		local animDict = "mp_arresting"
		local anim = "a_uncuff"

		loadAnimDict(animDict)

		Weapons:UnequipIfEquipped()

		while not HasAnimDictLoaded(animDict) do
			Wait(0)
		end

		if IsEntityPlayingAnim(LocalPlayer.state.ped, animDict, anim, 3) then
			ClearPedSecondaryTask(LocalPlayer.state.ped)
		else
			TaskPlayAnim(LocalPlayer.state.ped, animDict, anim, 1.0, 1.0, 3000, 16, -1, 0, 0, 0)
		end
	end
end)

_cuffFlags = 17
local lastFlag = nil
function cuffAnim()
	if
		IsPedInAnyVehicle(LocalPlayer.state.ped)
		or LocalPlayer.state.isHospitalized
		or IsPedBeingStunned(LocalPlayer.state.ped)
	then
		return
	end

	RequestAnimDict("mp_arresting")
	while not HasAnimDictLoaded("mp_arresting") do
		Wait(1)
	end
	ClearPedTasksImmediately(LocalPlayer.state.ped)
	TaskPlayAnim(LocalPlayer.state.ped, "mp_arresting", "idle", 8.0, 8.0, -1, _cuffFlags, 0.0, 0, 0, 0)
end

AddEventHandler("Handcuffs:Client:DoShittyAnim", function()
	Wait(100)
	cuffAnim()
end)

local _cuffThreading = false
RegisterNetEvent("Handcuffs:Client:CuffThread", function(cId)
	if _cuffThreading then
		return
	end
	_cuffThreading = true

	CreateThread(function()
		-- Wait till this is synced from server
		while not LocalPlayer.state.isCuffed do
			Wait(10)
		end

		while LocalPlayer.state.isCuffed do
			-- if not LocalPlayer.state.isHardCuffed then
			-- 	FreezeEntityPosition(LocalPlayer.state.ped, true)
			-- end
			-- if not IsEntityPlayingAnim(LocalPlayer.state.ped, "mp_arrest_paired", "crook_p2_back_right", 3) then
			-- 	beingCuffedAnim(tonumber(cId))
			-- end
			Wait(5)

			Weapons:UnequipIfEquipped()

			if not LocalPlayer.state.isHardCuffed and IsPedClimbing(LocalPlayer.state.ped) then
				Wait(500)
				SetPedToRagdoll(LocalPlayer.state.ped, 3000, 1000, 0, 0, 0, 0)
			end

			-- if CanPedRagdoll(LocalPlayer.state.ped) then
			-- 	SetPedCanRagdoll(LocalPlayer.state.ped, false)
			-- end

			DisableControlAction(1, 75, true) -- F
			DisableControlAction(1, 25, true) -- Aim
			DisableControlAction(1, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(1, 140, true) --Disables Melee Actions
			DisableControlAction(1, 141, true) --Disables Melee Actions
			DisableControlAction(1, 142, true) --Disables Melee Actions
			DisableControlAction(1, 37, true) --Disables INPUT_SELECT_WEAPON (tab) Actions
			DisablePlayerFiring(LocalPlayer.state.ped, true) -- Disable weapon firing

			if
				not LocalPlayer.state.isHospitalized
				and (
					(
						not IsEntityPlayingAnim(LocalPlayer.state.ped, "mp_arresting", "idle", 3)
						and not LocalPlayer.state.isDead
						and not LocalPlayer.state.inTrunk
					)
					or (
						IsPedRagdoll(LocalPlayer.state.ped)
						and not LocalPlayer.state.isDead
						and not LocalPlayer.state.inTrunk
					)
				)
			then
				cuffAnim()
			end
			if LocalPlayer.state.isDead or LocalPlayer.state.inTrunk then
				Wait(1000)
			end
		end

		-- if not CanPedRagdoll(LocalPlayer.state.ped) then
		-- 	SetPedCanRagdoll(LocalPlayer.state.ped, true)
		-- end
		ClearPedTasks(LocalPlayer.state.ped)
		FreezeEntityPosition(LocalPlayer.state.ped, false)
		_cuffThreading = false
	end)
end)
