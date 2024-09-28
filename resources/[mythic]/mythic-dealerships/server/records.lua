-- Dealership Sale Records

DEALERSHIPS.Records = {
    Get = function(self, dealership)
        if _dealerships[dealership] then
            local p = promise.new()
            Database.Game:find({
                collection = 'dealer_records',
                query = {
                    dealership = dealership,
                },
                options = {
                    limit = 100,
                    sort = {
                        time = -1,
                    },
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
    GetPage = function(self, category, term, dealership, page, perPage)
        if _dealerships[dealership] then
            local p = promise.new()

            local skip = 0
            if page > 1 then
                skip = perPage * (page - 1)
            end

            local orQuery = {
                {
                    ["$expr"] = {
                        ["$regexMatch"] = {
                            input = {
                                ["$concat"] = {
                                    { ['$convert'] = { input = "$seller.First", to = "string", onError = "error" }},
                                    " ", 
                                    { ['$convert'] = { input = "$seller.Last", to = "string", onError = "error" } }
                                },
                            },
                            regex = term,
                            options = "i",
                        },
                    },
                },
                {
                    ["$expr"] = {
                        ["$regexMatch"] = {
                            input = {
                                ["$concat"] = { "$buyer.First", " ", "$buyer.Last" },
                            },
                            regex = term,
                            options = "i",
                        },
                    },
                },
                {
                    ["$expr"] = {
                        ["$regexMatch"] = {
                            input = {
                                ["$concat"] = { "$vehicle.data.make", " ", "$vehicle.data.model" },
                            },
                            regex = term,
                            options = "i",
                        },
                    },
                },
            }

            local andQuery = {
                {
                    dealership = dealership,
                },
            }
            
            if #term > 0 then
                table.insert(andQuery, {
                    ["$or"] = orQuery,
                })
            end

            if category ~= "all" then
                table.insert(andQuery, {
                    ["vehicle.data.category"] = category,
                })
            end

            Database.Game:find({
                collection = 'dealer_records',
                query = {
                    ["$and"] = andQuery,
                },
                options = {
                    sort = {
                        time = -1,
                    },
                    skip = skip,
                    limit = perPage + 1,
                }
            }, function(success, results)
                if success then
                    local more = false
                    if #results > perPage then
                        more = true
                        table.remove(results)
                    end

                    p:resolve({
                        data = results,
                        more = more,
                    })
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