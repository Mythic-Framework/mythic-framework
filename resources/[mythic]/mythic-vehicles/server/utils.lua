local _trailerModels = {
    [`trailers`] = true,
    [`trailers2`] = true,
    [`trailers3`] = true,
    [`tvtrailer`] = true,
    [`trailers4`] = true,
    [`boattrailer`] = true,
    [`trailersmall`] = true,
    [`tr2`] = true,
    [`tr4`] = true,
    [`tanker`] = true,
    [`tanker2`] = true,
    [`trflat`] = true,
    [`trailerlogs`] = true,
    [`trailerlarge`] = true,
    [`proptrailer`] = true,
    [`20fttrailer`] = true,
}

local CREATE_AUTOMOBILE = `CREATE_AUTOMOBILE`
function CreateAutomobile(model, coords, heading)
    if not _trailerModels[model] then
        if not heading then heading = 0.0 end
        local veh = Citizen.InvokeNative(CREATE_AUTOMOBILE, model, coords.x, coords.y, coords.z, heading + 0.0)
        if DoesEntityExist(veh) then
            return veh
        end
        return nil
    else
        local veh = CreateVehicle(model, coords.x, coords.y, coords.z + 0.2, heading + 0.0, true, true)
        while not DoesEntityExist(veh) do Wait(10) end
        TriggerClientEvent("Vehicles:Client:SetDespawnStuff", -1, veh)
        return veh
    end
end

function ParseImpoundData(fine, hold, impounder)
    if not fine then
        fine = 0
    end
    if type(hold) ~= 'number' or hold <= 0 then 
        hold = 0
    end

    return {
        Type = 0,
        Id = 0,
        Fine = fine,
        TimeHold = (hold > 0 and {
            ImpoundedAt = os.time(),
            ExpiresAt = os.time() + (hold * 3600),
            Length = (hold * 3600),
        } or false),
        Impounder = impounder,
    }
end

function GetVehicleTypeDefaultStorage(vehicleType)
    for k, v in pairs(_vehicleStorage) do
        if v.default and vehicleType == v.vehType then
            return {
                Type = 1,
                Id = k
            }
        end
    end

    return {
        Type = 0,
        Id = 0
    }
end

function DoesVehiclePassStorageRestrictions(source, restrictedData)
    for k,v in ipairs(restrictedData) do
        if Jobs.Permissions:HasJob(source, v.JobId, v.WorkplaceId) then
            return true
        end
    end
    return false
end