local _platform = nil
local _platformVehicle = nil

AddEventHandler("Casino:Client:Enter", function()
    Wait(2000)

    if _insideCasino then
        local vehData = GlobalState["Casino:Vehicle"]
        if vehData then
            CreateCasinoShowcaseVehicle(vehData)
        end
    end
end)

AddEventHandler("Casino:Client:Exit", function()
    DeleteCasinoShowcaseVehicle()
end)

AddStateBagChangeHandler("Casino:Vehicle", nil, function(bagName, key, value, _unused, replicated)
    if _insideCasino then
        CreateCasinoShowcaseVehicle(value)
    end
end)

function CreateCasinoShowcaseVehicle(vehData)
    DeleteCasinoShowcaseVehicle()

    if not vehData then return; end

    Game.Vehicles:SpawnLocal(vector3(975.5, 40.41, 72.21), vehData.vehicle, 0.0, function(veh)
        _platformVehicle = veh

        if vehData.properties then
            Vehicles.Properties:Set(veh, vehData.properties)
        end

        FreezeEntityPosition(veh, true)
        SetVehicleDoorsLocked(veh, 2)
        SetVehicleLights(veh, 2)
        SetVehicleHasUnbreakableLights(veh, true)
        SetVehicleNumberPlateText(veh, "SPIN2WIN")
        SetVehicleDirtLevel(veh, 0.0)
        --RollDownWindows(veh)

        CreateThread(function()
            _platform = GetClosestObjectOfType(974.22, 39.76, 72.16, 10.0, -1561087446, 0, 0, 0)

            while _insideCasino and _platformVehicle do
                local curHeading = GetEntityHeading(_platform)

                if curHeading >= 360 then
                    curHeading = 0.0
                end

                SetEntityHeading(_platform, curHeading + 0.075)
                SetEntityHeading(_platformVehicle, curHeading + 0.075)
                Wait(0)
            end
        end)
    end)
end

function DeleteCasinoShowcaseVehicle()
    if _platformVehicle then
        Game.Vehicles:Delete(_platformVehicle)
        _platformVehicle = nil
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        DeleteCasinoShowcaseVehicle()
    end
end)