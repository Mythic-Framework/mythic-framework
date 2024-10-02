AddEventHandler('Tow:Client:RequestJob', function()
    Callbacks:ServerCallback('Tow:RequestJob', {}, function(success)
        if success then
            Notification:Success('You are Now Employed at Tow Yard', 5000, 'truck-pickup')
        else
            Notification:Error('Employement Request Failed', 5000, 'truck-pickup')
        end
    end)
end)

AddEventHandler('Tow:Client:QuitJob', function()
    Callbacks:ServerCallback('Tow:QuitJob', {}, function(success)
        if not success then
            Notification:Error('Request to Quit Failed', 5000, 'truck-pickup')
        end
    end)
end)

AddEventHandler('Tow:Client:OnDuty', function()
    Callbacks:ServerCallback('Tow:OnDuty', {})
end)

AddEventHandler('Tow:Client:OffDuty', function()
    Callbacks:ServerCallback('Tow:OffDuty', {})
end)

AddEventHandler('Tow:Client:RequestTruck', function()
    local availableSpace = GetClosestAvailableParkingSpace(LocalPlayer.state.position, _towSpaces)
    if availableSpace then
        Callbacks:ServerCallback('Tow:RequestTruck', availableSpace, function(vehNet)
            if vehNet ~= nil then
                SetEntityAsMissionEntity(NetToVeh(vehNet))
            end
        end)
    else
        Notification:Error('Parking Space Occupied, Move Out the Way!', 7500, 'truck-pickup')
    end
end)

AddEventHandler('Tow:Client:ReturnTruck', function()
    Callbacks:ServerCallback('Tow:ReturnTruck', {})
end)

AddEventHandler('Tow:Client:RequestImpound', function(entityData)
    local myTowTruck = GlobalState[string.format('TowTrucks:%s', LocalPlayer.state.Character:GetData('SID'))]
    if myTowTruck then
        myTowTruck = NetToVeh(myTowTruck)
    end

    if entityData and entityData.entity and DoesEntityExist(entityData.entity) and (not myTowTruck or myTowTruck ~= entityData.entity) and #(GetEntityCoords(entityData.entity) - GetEntityCoords(LocalPlayer.state.ped)) <= 10.0 and IsVehicleEmpty(entityData.entity) and Polyzone:IsCoordsInZone(GetEntityCoords(entityData.entity), 'tow_impound_zone') then
        Progress:ProgressWithTickEvent({
            name = 'veh_impound',
            duration = 10 * 1000,
            label = 'Impounding Vehicle',
            useWhileDead = false,
            canCancel = true,
            vehicle = false,
            disarm = false,
			ignoreModifier = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                anim = 'clipboard',
            },
        }, function()
            if not DoesEntityExist(entityData.entity) or (#(GetEntityCoords(entityData.entity) - GetEntityCoords(LocalPlayer.state.ped)) > 10.0) or not IsVehicleEmpty(entityData.entity) then
                Progress:Cancel()
            end
        end, function(cancelled)
            if not cancelled and DoesEntityExist(entityData.entity) and (#(GetEntityCoords(entityData.entity) - GetEntityCoords(LocalPlayer.state.ped)) <= 10.0) and IsVehicleEmpty(entityData.entity) then
                Callbacks:ServerCallback('Vehicles:Impound', {
                    vNet = VehToNet(entityData.entity),
                    type = 'impound',
                }, function(success)
                    if success then
                        Notification:Success('Vehicle Impounded Successfully')
                    else
                        Notification:Error('Impound Failed Miserably')
                    end
                end)
            else
                Notification:Error('Impound Failed')
            end
        end)
    else
        Notification:Error('Cannot Impound That Vehicle')
    end
end)
