_hasMenu = false

RegisterNetEvent('Admin:Client:Menu:RecievePermissionData', function(userData, permission, permissionName, permissionLevel)
    if not _hasMenu then
        _hasMenu = true

        SendNUIMessage({
            type = "SET_USERDATA",
            data = {
                user = userData,
                permission = permission,
                permissionName = permissionName,
                permissionLevel = permissionLevel,
            }
        })
    end
end)

function OpenMenu()
    if not _menuOpen and _hasMenu then
        _menuOpen = true
        SendNUIMessage({ type = "APP_SHOW" })
		SetNuiFocus(true, true)
    end
end

function CloseMenu()
    if _menuOpen then
        SendNUIMessage({ type = "APP_HIDE" })
		SetNuiFocus(false, false)


        _menuOpen = false
    end
end

RegisterNetEvent('Admin:Client:Menu:Open', function()
    OpenMenu()
end)

RegisterNetEvent('UI:Client:Reset', function(apps)
    CloseMenu()
end)

RegisterNUICallback('Close', function(data, cb)
	cb('OK')
	CloseMenu()
end)

RegisterNUICallback('GetPlayerList', function(data, cb)
    if data and data.disconnected then
        Callbacks:ServerCallback('Admin:GetDisconnectedPlayerList', data, cb)
    else
        Callbacks:ServerCallback('Admin:GetPlayerList', data, cb)
    end
end)

RegisterNUICallback('GetPlayer', function(data, cb)
    Callbacks:ServerCallback('Admin:GetPlayer', data, cb)
end)

RegisterNUICallback('GetCurrentVehicle', function(data, cb)
    local insideVehicle = GetVehiclePedIsIn(LocalPlayer.state.ped, true)
    if insideVehicle and insideVehicle > 0 and DoesEntityExist(insideVehicle) then
        local vehState = Entity(insideVehicle).state
        local vehicleCoords = GetEntityCoords(insideVehicle)
        local vehicleHeading = GetEntityHeading(insideVehicle)
        local currentSeat = 'Not In Vehicle'
        for i = -1, 14 do
            if GetPedInVehicleSeat(insideVehicle, i) == LocalPlayer.state.ped then
                currentSeat = i
                break
            end
        end

        cb({
            Make = vehState.Make,
            Model = vehState.Model,
            VIN = vehState.VIN,
            Owned = vehState.Owned,
            Owner = vehState.Owner,
            Plate = vehState.Plate,
            Value = vehState.Value,
            EntityModel = GetEntityModel(insideVehicle),
            Coords = {
                x = vehicleCoords.x,
                y = vehicleCoords.y,
                z = vehicleCoords.z,
            },
            Heading = vehicleHeading,
            Seat = currentSeat,
            Fuel = vehState.Fuel,
            Damage = vehState.Damage,
            DamagedParts = vehState.DamagedParts,
        })
    else
        cb(false)
    end
end)

RegisterNUICallback('ActionPlayer', function(data, cb)
    Callbacks:ServerCallback('Admin:ActionPlayer', data, cb)
end)

RegisterNUICallback('KickPlayer', function(data, cb)
    Callbacks:ServerCallback('Admin:KickPlayer', data, cb)
end)

RegisterNUICallback('BanPlayer', function(data, cb)
    Callbacks:ServerCallback('Admin:BanPlayer', data, cb)
end)

RegisterNUICallback('CurrentVehicleAction', function(data, cb)
    local insideVehicle = GetVehiclePedIsIn(LocalPlayer.state.ped, true)
    if insideVehicle and insideVehicle > 0 and DoesEntityExist(insideVehicle) then
        Callbacks:ServerCallback('Admin:CurrentVehicleAction', data, function(canDo)
            if canDo then
                if data.action == 'repair' then
                    if Vehicles.Repair:Normal(insideVehicle) then
                        return cb({
                            success = true,
                            message = 'Vehicle Repaired',
                        })
                    end
                elseif data.action == 'repair_full' then
                    if Vehicles.Repair:Full(insideVehicle) then
                        return cb({
                            success = true,
                            message = 'Vehicle Repaired Fully',
                        })
                    end
                elseif data.action == 'repair_engine' then
                    if Vehicles.Repair:Engine(insideVehicle) then
                        return cb({
                            success = true,
                            message = 'Engine Repaired',
                        })
                    end
                elseif data.action == 'explode' then
                    NetSync:NetworkExplodeVehicle(insideVehicle, 1, 0)
                    return cb({
                        success = true,
                        message = 'Vehicle Exploded',
                    })
                elseif data.action == 'alarm' then
                    if IsVehicleAlarmSet(insideVehicle) then
                        SetVehicleAlarm(insideVehicle, false)
                    else
                        SetVehicleAlarm(insideVehicle, true)
                        SetVehicleAlarmTimeLeft(insideVehicle, 25000)
                    end

                    return cb({
                        success = true,
                        message = 'Vehicle Alarm Activated',
                    })
                elseif data.action == 'fuel' then
                    Entity(insideVehicle).state:set('Fuel', 100, true)

                    return cb({
                        success = true,
                        message = 'Vehicle Refueled',
                    })
                -- elseif data.action == 'delete' then
                elseif data.action == 'customs' then
                    TriggerEvent('VehicleCustoms:Client:Admin', true, 0.0)

                    SetTimeout(1000, function()
                        CloseMenu()
                    end)

                    return cb({
                        success = true,
                        message = 'Opened',
                    })
                end

                cb(false)
            else
                cb(false);
            end
        end)
    else
        cb({
            success = false,
            message = 'No Longer In Vehicle Control',
        })
    end
end)

RegisterNUICallback('StopAllAttach', function(data, cb)
	cb('OK')
	AdminStopAttach()
end)

RegisterNUICallback('GetPlayerHistory', function(data, cb)
	cb({
        current = GlobalState.PlayerCount or 0,
        max = GlobalState.MaxPlayers or 1,
        queue = GlobalState.QueueCount or 0,
        history = GlobalState.AdminPlayerHistory
    })
end)

RegisterNUICallback('ToggleInvisible', function(data, cb)
    Callbacks:ServerCallback('Admin:ToggleInvisible', data, cb)
end)

RegisterNUICallback('ToggleIDs', function(data, cb)
    cb('OK')

    if LocalPlayer.state.isDev then
        ToggleAdminPlayerIDs()
    end
end)

function CopyClipboard(txt)
    SendNUIMessage({
        type = "COPY",
        data = {
            data = txt,
        }
    })
end