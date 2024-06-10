function RegisterCallbacks()
    Callbacks:RegisterClientCallback('Vehicles:Admin:GetVehicleToDelete', function(data, cb)
        if LocalPlayer.state.loggedIn then
            if VEHICLE_INSIDE then
                return cb(VehToNet(VEHICLE_INSIDE))
            else
                local data = Targeting:GetEntityPlayerIsLookingAt()
                if data and data.entity and DoesEntityExist(data.entity) and IsEntityAVehicle(data.entity) then
                    return cb(VehToNet(data.entity))
                end
            end
        end
        cb(false)
    end)

    Callbacks:RegisterClientCallback('Vehicles:Admin:GetVehicleInsideData', function(data, cb)
        if LocalPlayer.state.loggedIn then
            if VEHICLE_INSIDE then
                return cb({
                    vehicle = VehToNet(VEHICLE_INSIDE),
                    model = GetEntityModel(VEHICLE_INSIDE),
                    properties = GetVehicleProperties(VEHICLE_INSIDE)
                })
            end
        end
        cb(false)
    end)

    Callbacks:RegisterClientCallback('Vehicles:Admin:GetVehicleSpawnData', function(model, cb)
        if LocalPlayer.state.loggedIn and IsModelValid(model) then
            local spawnLocation = GetOffsetFromEntityInWorldCoords(GLOBAL_PED, 2.0, 2.0, 0.0)
            return cb(spawnLocation, GetEntityHeading(GLOBAL_PED))
        end
        cb(false)
    end)
end