function SetVehicleFrontTrackWidth(vehicle, width)
    if width then
        SetVehicleWheelXOffset(vehicle, 0, -width / 2)
        SetVehicleWheelXOffset(vehicle, 1, width / 2)
    end
end

function SetVehicleRearTrackWidth(vehicle, width)
    if width then
        SetVehicleWheelXOffset(vehicle, 2, -width / 2)
        SetVehicleWheelXOffset(vehicle, 3, width / 2)
    end
end