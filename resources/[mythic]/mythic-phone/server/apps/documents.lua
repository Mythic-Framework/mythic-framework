PHONE.Documents = {
	Create = function(self, source, doc)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil and type(doc) == "table" then
            local p = promise.new()

            doc.owner = char:GetData("ID")
            doc.time = os.time()

			Database.Game:insertOne({
				collection = "character_documents",
				document = doc,
			}, function(success, res, insertedIds)
                if success then
                    doc._id = insertedIds[1]
                    p:resolve(doc)
                else
                    p:resolve(false)
                end
			end)

            return Citizen.Await(p)
		end
        return false
	end,
    Edit = function(self, source, id, doc)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil and type(doc) == "table" then
            local p = promise.new()

			Database.Game:findOneAndUpdate({
				collection = "character_documents",
                query = {
                    owner = char:GetData("ID"),
                    _id = id,
                },
				update = {
                    ["$set"] = {
                        title = doc.title,
                        content = doc.content,
                        time = os.time(),
                    }
                },
                options = {
                    returnDocument = 'after',
                }
			}, function(success, res)
                p:resolve(success)

                if res and res.sharedWith then
                    for k, v in ipairs(res.sharedWith) do
                        if v.ID then
                            local char = Fetch:ID(v.ID)
                            if char then
                                TriggerClientEvent("Phone:Client:UpdateData", char:GetData("Source"), "myDocuments", res._id, res)
                            end
                        end
                    end
                end
			end)

            return Citizen.Await(p)
		end
        return false
	end,
	Delete = function(self, source, id)
        local char = Fetch:Source(source):GetData("Character")
        if char ~= nil then
            local p = promise.new()

            Database.Game:findOne({
                collection = "character_documents",
                query = {
                    _id = id,
                }
            }, function(success, results)
                if success and #results > 0 then
                    local doc = results[1]
                    if doc then
                        if doc.owner == char:GetData("ID") then
                            Database.Game:deleteOne({
                                collection = "character_documents",
                                query = {
                                    _id = id,
                                },
                            }, function(success)
                                p:resolve(success)

                                if success then
                                    if success and doc and doc.sharedWith then
                                        for k, v in ipairs(doc.sharedWith) do
                                            if v.ID then
                                                local char = Fetch:ID(v.ID)
                                                if char then
                                                    TriggerClientEvent("Phone:Client:RemoveData", char:GetData("Source"), "myDocuments", doc._id)
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        else
                            Database.Game:updateOne({
                                collection = "character_documents",
                                query = {
                                    _id = id,
                                },
                                update = {
                                    ["$pull"] = {
                                        sharedWith = { ID = char:GetData("ID") }
                                    }
                                },
                            }, function(success, updated)
                                p:resolve(success)
                            end)
                        end
                    else
                        p:resolve(false)
                    end
                else
                    p:resolve(false)
                end
            end)

            return Citizen.Await(p)
        end
        return false
	end,
}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "character_documents",
			query = {
                ['$or'] = {
                    {
                        owner = char:GetData("ID"),
                    },
                    {
                        ['sharedWith.ID'] = char:GetData("ID"),
                    }
                }
			},
		}, function(success, docs)
			TriggerClientEvent("Phone:Client:SetData", source, "myDocuments", docs)
		end)
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "character_documents",
			query = {
                ['$or'] = {
                    {
                        owner = char:GetData("ID"),
                    },
                    {
                        ['sharedWith.ID'] = char:GetData("ID"),
                    }
                }
			},
		}, function(success, docs)
			TriggerClientEvent("Phone:Client:SetData", source, "myDocuments", docs)
		end)
	end, 2)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
    Callbacks:RegisterServerCallback("Phone:Documents:Create", function(source, data, cb)
		cb(Phone.Documents:Create(source, data))
	end)

    Callbacks:RegisterServerCallback("Phone:Documents:Edit", function(source, data, cb)
		cb(Phone.Documents:Edit(source, data.id, data.data))
	end)

	Callbacks:RegisterServerCallback("Phone:Documents:Delete", function(source, data, cb)
		cb(Phone.Documents:Delete(source, data))
	end)

    Callbacks:RegisterServerCallback("Phone:Documents:Refresh", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
		Database.Game:find({
			collection = "character_documents",
			query = {
				owner = char:GetData("ID"),
                ['sharedWith.ID'] = char:GetData("ID"),
			},
		}, function(success, docs)
            cb("myDocuments", docs)
		end)
	end)

    Callbacks:RegisterServerCallback("Phone:Documents:Share", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
        if char and data and data.type and data.document then
            local target = nil
            if not data.nearby then
                if not data.target then
                    return cb(false)
                end

                target = Fetch:SID(data.target)
                if target then
                    target = target:GetData("Character")
                end

                if not target then
                    return cb(false)
                end

                if target:GetData("SID") == char:GetData("SID") then
                    return cb(false)
                end
            end

            local shareData = nil

            if data.type == 1 then
                data.document._id = nil
                data.document.sharedBy = {
                    ID = char:GetData("ID"),
                    First = char:GetData("First"),
                    Last = char:GetData("Last"),
                    SID = char:GetData("SID"),
                }
                data.document.shared = true
                data.document.sharedWith = {}

                sharedData = {
                    isCopy = true,
                    document = data.document,
                }
            elseif data.type == 2 or data.type == 3 then
                sharedData = {
                    isCopy = false,
                    document = {
                        _id = data.document._id,
                        title = data.document.title,
                        sharedBy = {
                            ID = char:GetData("ID"),
                            First = char:GetData("First"),
                            Last = char:GetData("Last"),
                            SID = char:GetData("SID"),
                        }
                    },
                    requireSignature = data.type == 3,
                }
            end

            if sharedData then
                if target then
                    TriggerClientEvent("Phone:Client:ReceiveShare", target:GetData("Source"), {
                        type = "documents",
                        data = sharedData,
                    }, os.time() * 1000)

                    return cb(true)
                else
                    local myPed = GetPlayerPed(source)
                    local myCoords = GetEntityCoords(myPed)
                    local myBucket = GetPlayerRoutingBucket(source)
                    for k, v in pairs(Fetch:All()) do
                        local tsrc = v:GetData("Source")
                        local tped = GetPlayerPed(tsrc)
                        local coords = GetEntityCoords(tped)
                        if tsrc ~= source and #(myCoords - coords) <= 5.0 and GetPlayerRoutingBucket(tsrc) == myBucket then
                            TriggerClientEvent("Phone:Client:ReceiveShare", tsrc, {
                                type = "documents",
                                data = sharedData,
                            }, os.time() * 1000)
                        end
                    end

                    return cb(true)
                end
            end
        end

        cb(false)
	end)

    Callbacks:RegisterServerCallback("Phone:Documents:RecieveShare", function(source, data, cb)
        if data then
            if data.isCopy then
                cb(Phone.Documents:Create(source, data.document))
            else
                local char = Fetch:Source(source):GetData("Character")
                if char then
                    Database.Game:findOneAndUpdate({
                        collection = "character_documents",
                        query = {
                            _id = data.document._id,
                            owner = { ['$ne'] = char:GetData("ID") },
                            ['sharedWith.ID'] = { ['$ne'] = char:GetData("ID") },
                        },
                        update = {
                            ["$push"] = {
                                sharedWith = {
                                    Time = os.time(),
                                    ID = char:GetData("ID"),
                                    First = char:GetData("First"),
                                    Last = char:GetData("Last"),
                                    SID = char:GetData("SID"),
                                    RequireSignature = data.requireSignature,
                                },
                            },
                            ["$set"] = {
                                sharedBy = data.document.sharedBy
                            }
                        },
                        options = {
                            returnDocument = 'after',
                        }
                    }, function(success, res)
                        if success then
                            cb(res)
                        else
                            cb(false)
                        end
                    end)
                else
                    cb(false)
                end
            end
        else
            cb(false)
        end
	end)

    Callbacks:RegisterServerCallback("Phone:Documents:Sign", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char then
            Database.Game:findOneAndUpdate({
                collection = "character_documents",
                query = {
                    _id = data,
                    owner = { ['$ne'] = char:GetData("ID") },
                    ['signed.ID'] = { ['$ne'] = char:GetData("ID") },
                },
                update = {
                    ["$push"] = {
                        signed = {
                            Time = os.time(),
                            ID = char:GetData("ID"),
                            First = char:GetData("First"),
                            Last = char:GetData("Last"),
                            SID = char:GetData("SID"),
                        },
                    }
                },
                options = {
                    returnDocument = 'after',
                }
            }, function(success, res)
                cb(success)

                if res and res.sharedWith then
                    for k, v in ipairs(res.sharedWith) do
                        if v.ID then
                            local char = Fetch:ID(v.ID)
                            if char then
                                TriggerClientEvent("Phone:Client:UpdateData", char:GetData("Source"), "myDocuments", res._id, res)
                            end
                        end
                    end

                    local char = Fetch:ID(res.owner)
                    if char then
                        TriggerClientEvent("Phone:Client:UpdateData", char:GetData("Source"), "myDocuments", res._id, res)
                    end
                end
            end)
        else
            cb(false)
        end
	end)
end)
