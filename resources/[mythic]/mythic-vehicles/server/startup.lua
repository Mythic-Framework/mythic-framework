local _ran = false

function Startup()
    if _ran then return end
    _ran = true

    Database.Game:count({
        collection = 'vehicles',
        query = {
            ['Owner.Type'] = 0,
        }
    }, function(success, count)
        if success then
            Logger:Trace('Vehicles', string.format('Loaded ^2%s^7 Character Owned Vehicles', count))
        end
    end)

    Database.Game:count({
        collection = 'vehicles',
        query = {
            ['Owner.Type'] = 1,
        }
    }, function(success, count)
        if success then
            Logger:Trace('Vehicles', string.format('Loaded ^2%s^7 Fleet Owned Vehicles', count))
        end
    end)

    CreateThread(function()
        -- Let the server startup, no vehicles need to be saved in the first 2 mins
        Wait(120000)
        while true do
            local savingVINs = {}
            for k, v in pairs(ACTIVE_OWNED_VEHICLES) do
                if v ~= nil then
                    local vData = v:GetData()
                    if vData.EntityId and DoesEntityExist(vData.EntityId) then
                        local vehEnt = Entity(vData.EntityId)
                        if (vehEnt and vehEnt.state and vehEnt.state.NeedSave) then
                            vehEnt.state.NeedSave = false
                            table.insert(savingVINs, vData.VIN)
                        end
                    end
                end
            end

            if #savingVINs > 0 then
                local timeSpread = math.floor((720 * 1000) / #savingVINs)
                if timeSpread < 2000 then
                    timeSpread = 2000
                end
    
                Logger:Info('Vehicles', 'Running Periodical Save For '.. #savingVINs .. ' Vehicles')
    
                for k, v in ipairs(savingVINs) do
                    SaveVehicle(v)
                    Wait(timeSpread)
                end
            else
                Wait(180000)
            end
        end
    end)
end