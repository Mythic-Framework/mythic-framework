ORIGINAL_HANDLING = {}

local valTypes = {
    Float = true,
    Int = true,
    Vector = true,
}

local handlingFunctions = {
    Get = {
        Float = GetVehicleHandlingFloat,
        Int = GetVehicleHandlingInt,
        Vector = GetVehicleHandlingVector,
    },
    Set = {
        Float = SetVehicleHandlingFloat,
        Int = SetVehicleHandlingInt,
        Vector = SetVehicleHandlingVector,
    }
}

function SetVehicleHandlingOverride(veh, fieldName, valType, val)
    if DoesEntityExist(veh) and valType and valTypes[valType] and val ~= nil then
        if not ORIGINAL_HANDLING[veh] then
            ORIGINAL_HANDLING[veh] = {}
        end

        if not ORIGINAL_HANDLING[veh][fieldName] then
            ORIGINAL_HANDLING[veh][fieldName] = {
                type = valType,
                value = handlingFunctions.Get[valType](veh, 'CHandlingData', fieldName),
            }
        end

        handlingFunctions.Set[valType](veh, 'CHandlingData', fieldName, val)

        return true
    end
    return false
end

function SetVehicleHandlingOverrideMultiplier(veh, fieldName, valType, val)
    if DoesEntityExist(veh) and valType and valTypes[valType] and val ~= nil then
        if not ORIGINAL_HANDLING[veh] then
            ORIGINAL_HANDLING[veh] = {}
        end

        if not ORIGINAL_HANDLING[veh][fieldName] then
            ORIGINAL_HANDLING[veh][fieldName] = {
                type = valType,
                value = handlingFunctions.Get[valType](veh, 'CHandlingData', fieldName),
            }
        end

        handlingFunctions.Set[valType](veh, 'CHandlingData', fieldName, ORIGINAL_HANDLING[veh][fieldName].value * val)

        return true
    end
    return false
end

function ResetVehicleHandlingOverride(veh, fieldName, skipChecks)
    if (DoesEntityExist(veh) and ORIGINAL_HANDLING[veh] and fieldName) or skipChecks then
        local originalValue = ORIGINAL_HANDLING[veh][fieldName]
        if originalValue and originalValue.type and originalValue.value then
            handlingFunctions.Set[originalValue.type](veh, 'CHandlingData', fieldName, originalValue.value)
            return true
        end
    end
    return false
end

function ResetVehicleHandlingOverrides(veh)
    if DoesEntityExist(veh) and ORIGINAL_HANDLING[veh] then
        for k, v in pairs(ORIGINAL_HANDLING[veh]) do
            ResetVehicleHandlingOverride(veh, k, true)
        end
        return true
    end
    return false
end

AddEventHandler('Vehicles:Client:ExitVehicle', function(veh)
    if ResetVehicleHandlingOverrides(veh) then
        Logger:Info('Vehicles', 'Resetting Applied Handling Overrides For Vehicle')
    end
end)