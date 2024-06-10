local showroomsLoaded = false

DEALERSHIPS.Showroom = {
    Load = function(self)
        local p = promise.new()
        Database.Game:find({
            collection = 'dealer_showrooms',
        }, function(success, results)
            local showRoomData = {}
            if success and #results > 0 then
                for k, v in ipairs(results) do
                    if _dealerships[v.dealership] then
                        showRoomData[v.dealership] = v.showroom or {}
                    end
                end

                GlobalState.DealershipShowrooms = showRoomData
                showroomsLoaded = true
            end
            p:resolve(success)
        end)
        return Citizen.Await(p)
    end,

    Update = function(self, dealershipId, showroom)
        if _dealerships[dealershipId] then
            if type(showroom) ~= 'table' then 
                showroom = {} 
            end
            
            local p = promise.new()
            Database.Game:findOneAndUpdate({
                collection = 'dealer_showrooms',
                query = { dealership = dealershipId },
                update = {
                    ['$set'] = {
                        dealership = dealershipId,
                        showroom = showroom,
                    }
                },
                options = {
                    upsert = true,
                }
            }, function(success, result)
                if success then
                    -- FiveM is dumb
                    local currentData = GlobalState.DealershipShowrooms
                    currentData[dealershipId] = showroom
                    GlobalState.DealershipShowrooms = currentData
                    
                    TriggerClientEvent('Dealerships:Client:ShowroomUpdate', -1, dealershipId)
                    p:resolve(showroom)
                else
                    p:resolve(false)
                end
            end)
            return Citizen.Await(p)
        end
        return false
    end,
    
    UpdatePos = function(self, dealershipId, position, vehicleData)
        if _dealerships[dealershipId] and (#_dealerships[dealershipId].showroom >= position) then
            position = tostring(position)
            local showroomData = GlobalState.DealershipShowrooms[dealershipId] or {}
            showroomData[position] = type(vehicleData) == 'table' and vehicleData or nil

            return Dealerships.Showroom:Update(dealershipId, showroomData)
        end
        return false
    end,
}