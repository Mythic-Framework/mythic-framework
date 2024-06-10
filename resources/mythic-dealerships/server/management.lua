_managementData = {}

DEALERSHIPS.Management = {
    LoadData = function(self)
        local p = promise.new()
        Database.Game:find({
            collection = 'dealer_data',
            query = {}
        }, function(success, results)
            if success then
                local fuckface = {}
                for k, v in ipairs(results) do
                    if v.dealership then
                        fuckface[v.dealership] = v
                    end
                end

                for k, v in pairs(_dealerships) do
                    if fuckface[k] then
                        _managementData[k] = fuckface[k]
                    else
                        _managementData[k] = _defaultDealershipSalesData
                    end
                end
                p:resolve(true)
            else
                p:resolve(false)
            end
        end)
        return Citizen.Await(p)
    end,
    SetData = function(self, dealerId, key, val)
        local data = _managementData[dealerId]
        if data then
            local dealerData = table.copy(data)
            dealerData.dealership = nil
            dealerData._id = nil
            dealerData[key] = val

            local p = promise.new()
            Database.Game:updateOne({
                collection = 'dealer_data',
                query = {
                    dealership = dealerId,
                },
                update = {
                    ['$set'] = dealerData
                },
                options = {
                    upsert = true,
                }
            }, function(success, results)
                if success then
                    _managementData[dealerId] = dealerData
                    p:resolve(_managementData[dealerId])
                else
                    p:resolve(false)
                end
            end)
            return Citizen.Await(p)
        end
        return false
    end,
    SetMultipleData = function(self, dealerId, updatingData)
        local data = _managementData[dealerId]
        if data then
            local dealerData = table.copy(data)
            dealerData.dealership = nil
            dealerData._id = nil

            for k, v in pairs(updatingData) do
                dealerData[k] = v
            end

            local p = promise.new()
            Database.Game:updateOne({
                collection = 'dealer_data',
                query = {
                    dealership = dealerId,
                },
                update = {
                    ['$set'] = dealerData
                },
                options = {
                    upsert = true,
                }
            }, function(success, results)
                if success then
                    _managementData[dealerId] = dealerData
                    p:resolve(_managementData[dealerId])
                else
                    p:resolve(false)
                end
            end)
            return Citizen.Await(p)
        end
        return false
    end,
    GetAllData = function(self, dealerId)
        return _managementData[dealerId]
    end,
    GetData = function(self, dealerId, key)
        local data = _managementData[dealerId]
        if data then
            return data[key]
        end
        return false
    end,
}