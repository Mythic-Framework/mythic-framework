DEALERSHIPS.Stock = {
    FetchAll = function(self)
        local p = promise.new()
        Database.Game:find({
            collection = 'dealer_stock',
            query = {}
        }, function(success, result)
            if success then
                p:resolve(result)
            else
                p:resolve(false)
            end
        end)
        return Citizen.Await(p)
    end,
    FetchDealer = function(self, dealerId)
        local p = promise.new()
        Database.Game:find({
            collection = 'dealer_stock',
            query = {
                dealership = dealerId,
            }
        }, function(success, result)
            if success then
                p:resolve(result)
            else
                p:resolve(false)
            end
        end)
        return Citizen.Await(p)
    end,
    FetchDealerVehicle = function(self, dealerId, vehModel)
        local p = promise.new()
        Database.Game:findOne({
            collection = 'dealer_stock',
            query = {
                dealership = dealerId,
                vehicle = vehModel,
            }
        }, function(success, result)
            if success and #result > 0 then
                p:resolve(result[1])
            else
                p:resolve(false)
            end
        end)
        return Citizen.Await(p)
    end,
    HasVehicle = function(self, dealerId, vehModel)
        local vehicle = Dealerships.Stock:FetchDealerVehicle(dealerId, vehModel)
        if vehicle and vehicle.quantity > 0 then
            return vehicle.quantity
        else
            return false
        end
    end,
    Add = function(self, dealerId, vehModel, modelType, quantity, vehData)
        vehData = ValidateVehicleData(vehData)
        if _dealerships[dealerId] and vehModel and vehData and quantity > 0 then
            local isStocked = Dealerships.Stock:FetchDealerVehicle(dealerId, vehModel)
            local p = promise.new()
            if isStocked then -- The vehicle is already stocked
                Database.Game:updateOne({
                    collection = 'dealer_stock',
                    query = {
                        dealership = dealerId,
                        vehicle = vehModel,
                    },
                    update = {
                        ['$inc'] = {
                            quantity = quantity,
                        },
                        ['$set'] = {
                            data = vehData,
                            lastStocked = os.time(),
                        }
                    }
                }, function(success, result)
                    if success and result > 0 then
                        p:resolve({
                            success = true,
                            existed = true,
                        })
                    else
                        p:resolve(false)
                    end
                end)
            else
                Database.Game:insertOne({
                    collection = 'dealer_stock',
                    document = {
                        dealership = dealerId,
                        vehicle = vehModel,
                        modelType = modelType,
                        data = vehData,
                        quantity = quantity,
                        lastStocked = os.time(),
                    }
                }, function(success, result)
                    if success and result > 0 then
                        p:resolve({
                            success = true,
                            existed = false,
                        })
                    else
                        p:resolve(false)
                    end
                end)
            end
            return Citizen.Await(p)
        end
        return false
    end,
    Increase = function(self, dealerId, vehModel, amount)
        if _dealerships[dealerId] and vehModel and amount > 0 then
            local isStocked = Dealerships.Stock:FetchDealerVehicle(dealerId, vehModel)
            if isStocked then -- The vehicle is already stocked
                local p = promise.new()
                Database.Game:updateOne({
                    collection = 'dealer_stock',
                    query = {
                        dealership = dealerId,
                        vehicle = vehModel,
                    },
                    update = {
                        ['$inc'] = {
                            quantity = amount,
                        },
                        ['$set'] = {
                            lastStocked = os.time(),
                        }
                    }
                }, function(success, result)
                    if success and result > 0 then
                        p:resolve({ success = true })
                    else
                        p:resolve(false)
                    end
                end)
                return Citizen.Await(p)
            else
                return false
            end
        end
        return false
    end,
    Update = function(self, dealerId, vehModel, setting)
        if _dealerships[dealerId] and vehModel and type(setting) == "table" then
            local isStocked = Dealerships.Stock:FetchDealerVehicle(dealerId, vehModel)
            if isStocked then -- The vehicle is already stocked
                local p = promise.new()
                Database.Game:updateOne({
                    collection = 'dealer_stock',
                    query = {
                        dealership = dealerId,
                        vehicle = vehModel,
                    },
                    update = {
                        ['$set'] = setting
                    }
                }, function(success, result)
                    if success and result > 0 then
                        p:resolve({ success = true })
                    else
                        p:resolve(false)
                    end
                end)
                return Citizen.Await(p)
            else
                return false
            end
        end
        return false 
    end,
    Ensure = function(self, dealerId, vehModel, quantity, vehData)
        if _dealerships[dealerId] and vehModel then
            local isStocked = Dealerships.Stock:FetchDealerVehicle(dealerId, vehModel)
            if isStocked then
                local missingQuantity = quantity - isStocked.quantity
                if missingQuantity >= 1 then
                    return Dealerships.Stock:Add(dealerId, vehModel, missingQuantity, vehData)
                end
            else
                return Dealerships.Stock:Add(dealerId, vehModel, quantity, vehData)
            end
        end
        return false
    end,
    Remove = function(self, dealerId, vehModel, quantity)
        if _dealerships[dealerId] and vehModel and quantity > 0 then
            local isStocked = Dealerships.Stock:FetchDealerVehicle(dealerId, vehModel)

            if isStocked and isStocked.quantity > 0 then
                local newQuantity = isStocked.quantity - quantity
                if newQuantity >= 0 then
                    local p = promise.new()
                    Database.Game:updateOne({
                        collection = 'dealer_stock',
                        query = {
                            dealership = dealerId,
                            vehicle = vehModel,
                        },
                        update = {
                            ['$set'] = {
                                quantity = newQuantity,
                                lastPurchase = os.time(),
                            }
                        }
                    }, function(success, result)
                        if success and result > 0 then
                            p:resolve(newQuantity)
                        else
                            p:resolve(false)
                        end
                    end)
                    return Citizen.Await(p)
                end
            end
        end
        return false
    end,
}

local requiredAttributes = {
    make = 'string',
    model = 'string',
    class = 'string',
    category = 'string',
    price = 'number'
}

function ValidateVehicleData(data)
    if type(data) ~= 'table' then
        return false
    end
    for k, v in pairs(requiredAttributes) do
        if data[k] == nil or type(data[k]) ~= v then
            return false
        end
    end

    return data
end