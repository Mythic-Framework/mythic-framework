AddEventHandler("Vehicles:Client:StartUp", function()
    Callbacks:RegisterClientCallback("Vehicles:GetPersonalPlate", function(data, cb)
        local target = Targeting:GetEntityPlayerIsLookingAt()
        if target and target.entity and DoesEntityExist(target.entity) and IsEntityAVehicle(target.entity) then
            if Vehicles:HasAccess(target.entity) and (Vehicles.Utils:IsCloseToRearOfVehicle(target.entity) or Vehicles.Utils:IsCloseToFrontOfVehicle(target.entity)) then
                local settingPlate = GetNewPersonalPlate()

                if settingPlate then
                    cb(VehToNet(target.entity), settingPlate)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

local platePromise
function GetNewPersonalPlate()
    platePromise = promise.new()
    Input:Show("New Personal Plate", "Personal Plate", {
		{
			id = "plate",
			type = "text",
			options = {
				inputProps = {
                    pattern = "[A-HJ-NPR-Z0-9 ]+",
                    maxlength = 8,
                },
                helperText = "Plates cannot include the letters O, Q, I and must include at least 3 characters. SPACES FOR PADDING ARE ADDED AUTOMATICALLY!"
			},
		},
	}, "Vehicles:Client:RecievePersonalPlateInput", {})

    return Citizen.Await(platePromise)
end

AddEventHandler("Vehicles:Client:RecievePersonalPlateInput", function(values)
    if platePromise then
        platePromise:resolve(values?.plate)
        platePromise = nil
    end
end)

AddEventHandler("Input:Closed", function()
    if platePromise then
        platePromise:resolve(false)
        platePromise = nil
    end
end)