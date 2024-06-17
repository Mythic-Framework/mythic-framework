local tempTakenPlates = {}

function IsPersonalPlateValid(plate)
    plate = string.upper(plate)

    local res = string.match(plate, "[A-HJ-NPR-Z0-9 ]+", 1)
    local trimmedLength = #plate:gsub(" ", "")

    local addedSpacing = math.floor((8 - trimmedLength) / 2)

    if res and res == plate and trimmedLength >= 4 then
        if trimmedLength < 8 then
            return string.rep(" ", addedSpacing) .. plate .. string.rep(" ", (8 - trimmedLength) - addedSpacing)
        else
            return plate
        end
    end

    return false
end

function IsPersonalPlateTaken(plate)
    if GENERATED_TEMP_PLATES[plate] then
        return true
    end

    if tempTakenPlates[plate] then
        return true
    end

    local test = IsPlateOwned(plate)
    return test
end

function RegisterPersonalPlateCallbacks()
    Inventory.Items:RegisterUse("personal_plates", "Vehicles", function(source, itemData)
        local char = Fetch:Source(source):GetData("Character")
        if not char or (Player(source).state.onDuty ~= "government" and Player(source).state.onDuty ~= "dgang") then
            Execute:Client(source, "Notification", "Error", "Error")
            return
        end

        Callbacks:ClientCallback(source, "Vehicles:GetPersonalPlate", {}, function(veh, plate)
            if not veh or not plate then
                return
            end
            veh = NetworkGetEntityFromNetworkId(veh)
            if veh and DoesEntityExist(veh) then
                local vehState = Entity(veh).state
                if not vehState.VIN then
                    Execute:Client(source, "Notification", "Error", "Error")
                    return
                end

                local vehicle = Vehicles.Owned:GetActive(vehState.VIN)
                if not vehicle then
                    Execute:Client(source, "Notification", "Error", "Can't Do It on This Vehicle")
                    return
                end

                if vehicle:GetData("FakePlate") then
                    Execute:Client(source, "Notification", "Error", "Can't Do It on This Vehicle")
                    return
                end

                local originalPlate = vehicle:GetData("RegisteredPlate")
                local newPlate = IsPersonalPlateValid(plate)

                if not newPlate then
                    Execute:Client(source, "Notification", "Error", "Invalid Plate Formatting")
                    return
                end

                if IsPersonalPlateTaken(newPlate) then
                    Execute:Client(source, "Notification", "Error", "That Plate is Taken")
                    return
                end

                tempTakenPlates[vehicle:GetData("RegisteredPlate")] = true
                tempTakenPlates[newPlate] = true

                local previousPlateChanges = vehicle:GetData("PreviousPlates") or {}

                table.insert(previousPlateChanges, {
                    time = os.time(),
                    oldPlate = vehicle:GetData("RegisteredPlate"),
                    newPlate = newPlate,
                    doneBy = char:GetData("SID")
                })

                vehicle:SetData("PreviousPlates", previousPlateChanges)
                vehicle:SetData("RegisteredPlate", newPlate)
                SetVehicleNumberPlateText(veh, newPlate)
                vehState.Plate = newPlate
                vehState.RegisteredPlate = newPlate

                Vehicles.Owned:ForceSave(vehState.VIN)
                Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)

                Execute:Client(source, "Notification", "Success", "Personal Plate Setup")
                Logger:Info('Vehicles', string.format("Personal Plate Change For Vehicle: %s. %s -> %s", vehState.VIN, originalPlate, newPlate))
            else
                Execute:Client(source, "Notification", "Error", "Error")
            end
        end)
	end)
end

-- SetTimeout(2500, function()
--     print(IsPersonalPlateValid('FFFF'))
--     print(IsPersonalPlateValid('FFFFF'))
--     print(IsPersonalPlateValid('FFFFFF'))
--     print(IsPersonalPlateValid('FFFFFFF'))
--     print(IsPersonalPlateValid('FFFFFFFF'))
-- end)

