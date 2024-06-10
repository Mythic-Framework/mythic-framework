local inCarWash = false
local usingCarWash = false

local carWashLocations = {
    {
        center = vector3(23.94, -1391.87, 29.37),
        length = 4.0,
        width = 19.4,
        options = {
            heading = 0,
            minZ = 28.37,
            maxZ = 31.97
        }
    },
    {
        center = vector3(-699.9, -933.25, 19.01),
        length = 9.8,
        width = 4.8,
        options = {
            heading = 0,
            minZ = 18.01,
            maxZ = 22.01
        }
    },
}

AddEventHandler('Vehicles:Client:StartUp', function()
    for k, v in ipairs(carWashLocations) do
        Polyzone.Create:Box('carwash_'.. k, v.center, v.length, v.width, v.options, {
            carwash = true,
        })
    end
end)

AddEventHandler('Polyzone:Enter', function(id, point, insideZone, data)
    if data.carwash and VEHICLE_INSIDE and VEHICLE_SEAT == -1 and not inCarWash then
        inCarWash = true
        Action:Show('{keybind}primary_action{/keybind} Use Car Wash for $100')
    end
end)

AddEventHandler('Polyzone:Exit', function(id, point, insideZone, data)
    if inCarWash and data and data.carwash then
        inCarWash = false
        Action:Hide()
    end
end)

AddEventHandler('Keybinds:Client:KeyUp:primary_action', function()
    if inCarWash and not usingCarWash then
        if VEHICLE_INSIDE and VEHICLE_SEAT == -1 then
            if GetVehicleDirtLevel(VEHICLE_INSIDE) > 1.0 then
                local char = LocalPlayer.state.Character
                if char and char:GetData('Cash') >= 250 then
                    usingCarWash = true
                    Progress:Progress({
                        name = "vehicle_clean",
                        duration = 10 * 1000,
                        label = "Cleaning Vehicle",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        disarm = true,
                    }, function(cancelled)
                        usingCarWash = false
                        if cancelled then return end
                        Callbacks:ServerCallback('Vehicles:CleanVehicle', {
                            vNet = VehToNet(VEHICLE_INSIDE),
                            bill = true,
                        })
                    end)
                else
                    Notification:Error('Not Enough Cash')
                end
            else
                Notification:Error('This Vehicle Isn\'t Dirty!')
            end
        end
    end
end)

RegisterNetEvent('Vehicles:Client:CleaningKit', function()
    local target = Targeting:GetEntityPlayerIsLookingAt()
    if not usingCarWash and target and target.entity and DoesEntityExist(target.entity) and IsEntityAVehicle(target.entity) and #(GetEntityCoords(target.entity) - GetEntityCoords(GLOBAL_PED)) <= 2.0 then
        Animations.Emotes:Play('clean', false, 14000, true)
        usingCarWash = true
        Progress:Progress({
            name = "vehicle_clean",
            duration = 14000,
            label = "Cleaning Vehicle",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            disarm = true,
        }, function(cancelled)
            usingCarWash = false
            if cancelled then return end
            if DoesEntityExist(target.entity) and #(GetEntityCoords(target.entity) - GetEntityCoords(GLOBAL_PED)) <= 2.0 then
                Callbacks:ServerCallback('Vehicles:CleanVehicle', {
                    vNet = VehToNet(target.entity),
                    bill = false,
                }, function(success)
                    if success then
                        Notification:Success('Vehicle Cleaned')
                    end
                end)
            end
        end)
    end
end)