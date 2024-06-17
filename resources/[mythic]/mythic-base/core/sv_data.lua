local _data = {}
local _inserting = {}

COMPONENTS.Default = {
    _required = { 'Add' },
    _name = { 'base' },
    _protected = true,
    Add = function(self, collection, date, data)
        CreateThread(function()
            -- Prevents doing this operation multiple times because earlier
            -- Calls haven't finished yet
            while _inserting[collection] ~= nil do Wait(10) end

            for k, v in ipairs(data) do
                v.default = true
            end

            _inserting[collection] = true
            COMPONENTS.Database.Game:findOne({
                collection = 'defaults',
                query = {
                    collection = collection
                }
            }, function(s, r)
                if not s then COMPONENTS.Logger:Error('Data', ('Failed To Retrieve Details For %s Default Data'):format(collection)) _inserting[collection] = nil return end
    
                if #r == 0 or r[1].date < date then
                    COMPONENTS.Database.Game:delete({
                        collection = collection,
                        query = {
                            default = true
                        }
                    }, function(s2, r2)
                        if not s then COMPONENTS.Logger:Error('Data', ('Failed To Remove Existing Default Data For %s'):format(collection)) _inserting[collection] = nil return end
    
                        COMPONENTS.Database.Game:insert({
                            collection = collection,
                            documents = data
                        }, function(s3, r3)
                            if not s then COMPONENTS.Logger:Error('Data', ('Failed Adding Default Data For %s'):format(collection)) _inserting[collection] = nil return end
    
                            local qry = {
                                collection = collection
                            }
    
                            if #r > 0 then qry._id = r[1]._id end
    
                            COMPONENTS.Database.Game:updateOne({
                                collection = 'defaults',
                                update = {
                                    ['$set'] = {
                                        collection = collection,
                                        date = date
                                    }
                                },
                                query = qry,
                                options = {
                                    upsert = true
                                }
                            }, function(success, result)
                                _inserting[collection] = nil
                                if not s then COMPONENTS.Logger:Error('Data', ('Failed Updating Details For %s Default Data'):format(collection)) return end
                            end)
                        end)
                    end)
                else
                    _inserting[collection] = nil
                end
            end)
        end)
    end,
    AddAuth = function(self, collection, date, data)
        CreateThread(function()
            -- Prevents doing this operation multiple times because earlier
            -- Calls haven't finished yet
            while _inserting[collection] ~= nil do Wait(10) end

            for k, v in ipairs(data) do
                v.default = true
            end

            _inserting[collection] = true
            COMPONENTS.Database.Game:findOne({
                collection = 'defaults',
                query = {
                    collection = collection
                }
            }, function(s, r)
                if not s then COMPONENTS.Logger:Error('Data', ('Failed To Retrieve Details For %s Default Data'):format(collection)) _inserting[collection] = nil return end
    
                if #r == 0 or r[1].date < date then
                    COMPONENTS.Database.Auth:delete({
                        collection = collection,
                        query = {
                            default = true
                        }
                    }, function(s2, r2)
                        if not s then COMPONENTS.Logger:Error('Data', ('Failed To Remove Existing Default Data For %s'):format(collection)) _inserting[collection] = nil return end
    
                        COMPONENTS.Database.Auth:insert({
                            collection = collection,
                            documents = data
                        }, function(s3, r3)
                            if not s then COMPONENTS.Logger:Error('Data', ('Failed Adding Default Data For %s'):format(collection)) _inserting[collection] = nil return end
    
                            local qry = {
                                collection = collection
                            }
    
                            if #r > 0 then qry._id = r[1]._id end
    
                            COMPONENTS.Database.Game:updateOne({
                                collection = 'defaults',
                                update = {
                                    ['$set'] = {
                                        collection = collection,
                                        date = date
                                    }
                                },
                                query = qry,
                                options = {
                                    upsert = true
                                }
                            }, function(success, result)
                                _inserting[collection] = nil
                                if not s then COMPONENTS.Logger:Error('Data', ('Failed Updating Details For %s Default Data'):format(collection)) return end
                            end)
                        end)
                    end)
                else
                    _inserting[collection] = nil
                end
            end)
        end)
    end
}