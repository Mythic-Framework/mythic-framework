-- Dealership Sale Records

DEALERSHIPS.Records = {
    Get = function(self, dealership)
        if _dealerships[dealership] then
            local p = promise.new()
            Database.Game:find({
                collection = 'dealer_records',
                query = {
                    dealership = dealership,
                }
            }, function(success, results)
                if success then
                    p:resolve(results or {})
                else
                    p:resolve(false)
                end
            end)
            return Citizen.Await(p)
        end
        return false
    end,
    Create = function(self, dealership, document)
        if type(document) == 'table' then
            document.dealership = dealership
            local p = promise.new()
            Database.Game:insertOne({
                collection = 'dealer_records',
                document = document,
            }, function(success, inserted)
                p:resolve(success and inserted > 0)
            end)
            return Citizen.Await(p)
        end
        return false
    end,
    CreateBuyBack = function(self, dealership, document)
        if type(document) == 'table' then
            document.dealership = dealership
            local p = promise.new()
            Database.Game:insertOne({
                collection = 'dealer_records_buybacks',
                document = document,
            }, function(success, inserted)
                p:resolve(success and inserted > 0)
            end)
            return Citizen.Await(p)
        end
        return false
    end,
}