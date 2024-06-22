function FlipVehicle(vehicle, correctPitch)
    if vehicle and DoesEntityExist(vehicle) then
        local vehicleRot = GetEntityRotation(vehicle)
        SetEntityRotation(vehicleRot.x, correctPitch, vehicleRot.z)
        Wait(50)
        SetVehicleOnGroundProperly(vehicle)
    end
end

AddEventHandler('Vehicles:Client:FlipVehicle', function(entityData)
    if not entityData then return end
    TaskTurnPedToFaceEntity(LocalPlayer.state.ped, entityData.entity, 1)
    Wait(250)
    Progress:ProgressWithTickEvent({
		name = "flipping_vehicle",
		duration = math.random(13, 20) * 1000,
		label = "Flipping Vehicle",
		canCancel = true,
		tickrate = 500,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "missfinale_c2ig_11",
			anim = "pushcar_offcliff_f",
			flags = 15,
		},
	}, function()
		if not DoesEntityExist(entityData.entity) or (#(GetEntityCoords(entityData.entity) - LocalPlayer.state.position) > 5.0) then
            Progress:Cancel()
			return
        end
	end, function(wasCancelled)
		if not wasCancelled then
            local correctPitch = GetEntityRotation(LocalPlayer.state.ped).y
            if not NetworkGetEntityIsNetworked(entityData.entity) or NetworkHasControlOfEntity(entityData.entity) then
                FlipVehicle(entityData.entity, correctPitch)
            else
                local netId = VehToNet(entityData.entity)
                TriggerServerEvent('Vehicles:Server:FlipVehicle', netId, correctPitch)
            end
        end
	end)
end)

RegisterNetEvent('Vehicles:Client:FlipVehicleRequest', function(netVeh, correctPitch)
    Logger:Info('Vehicles', string.format('Flipping Vehicle %s By Server Request', netVeh))
    local vehicle = NetToVeh(netVeh)
    FlipVehicle(vehicle, correctPitch)
end)