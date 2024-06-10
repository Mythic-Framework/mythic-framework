_MDT.Reports = {
	Search = function(self, term, type, tagsFilter)
        if not term then term = '' end
		local p = promise.new()

        local aggregation = {
            {
                ['$addFields'] = {
                    ['suspects.suspect'] = {
                        ["$map"] = {
                            ["input"] = "$suspects.suspect",
                            ["as"] = "u",
                            ["in"] = {
                                ["$mergeObjects"] = {
                                    "$$u",
                                    {
                                        FullName = { ["$concat"] = { "$$u.First", " ", "$$u.Last" } }
                                    }
                                }
                            }
                        }
                    }
                }
            },
        }

        local filterMatchQuery = {}
        if tagsFilter and #tagsFilter > 0 then
            filterMatchQuery.tags = { ['$in'] = tagsFilter }
        end

        if type then
            filterMatchQuery.type = type
        end

        if filterMatchQuery.type or filterMatchQuery.tags then
            table.insert(aggregation, {
                ['$match'] = filterMatchQuery,
            })
        end

        table.insert(aggregation, {
            ['$match'] = {
                ['$or'] = {
                    {
                        ['suspects.suspect.FullName'] = { ['$regex'] = term, ['$options'] = 'i' }
                    },
                    {
                        title = { ['$regex'] = term, ['$options'] = 'i' }
                    },
                    {
                        ["$expr"] = {
                            ["$regexMatch"] = {
                                input = {
                                    ["$toString"] = "$ID",
                                },
                                regex = term,
                                options = "i",
                            },
                        },
                    },
                },
            },
        })

        table.insert(aggregation, {
            ["$sort"] = {
                time = -1,
            }
        })

        if #term <= 0 then
            table.insert(aggregation, {
                ["$limit"] = 24
            })
        end

        table.insert(aggregation, {
            ["$unwind"] = {
                path = '$suspects.suspect',
                preserveNullAndEmptyArrays = true,
            }
        })

		Database.Game:aggregate({
            collection = "mdt_reports",
            aggregate = aggregation,
        }, function(success, results)
            if not success then
				p:resolve(false)
                return
            end
            GlobalState['MDT:Metric:Search'] = GlobalState['MDT:Metric:Search'] + 1
			p:resolve(results)
        end)
		return Citizen.Await(p)
	end,
    SearchEvidence = function(self, term)
        if not term then term = '' end
		local p = promise.new()

        local aggregation = {
            {
                ['$addFields'] = {
                    ['suspects.suspect'] = {
                        ["$map"] = {
                            ["input"] = "$suspects.suspect",
                            ["as"] = "u",
                            ["in"] = {
                                ["$mergeObjects"] = {
                                    "$$u",
                                    {
                                        FullName = { ["$concat"] = { "$$u.First", " ", "$$u.Last" } }
                                    }
                                }
                            }
                        }
                    }
                }
            },
        }

        local filterMatchQuery = {}

        if filterMatchQuery.type or filterMatchQuery.tags then
            table.insert(aggregation, {
                ['$match'] = filterMatchQuery,
            })
        end

        table.insert(aggregation, {
            ['$match'] = {
                ['$or'] = {
                    {
                        ['evidence'] = {
                            ['$elemMatch'] = {
                                value = { ['$regex'] = term, ['$options'] = 'i' }
                            }
                        }
                    },
                },
            },
        })

        table.insert(aggregation, {
            ["$sort"] = {
                time = -1,
            }
        })

        if #term <= 0 then
            table.insert(aggregation, {
                ["$limit"] = 24
            })
        end

        table.insert(aggregation, {
            ["$unwind"] = {
                path = '$suspects.suspect',
                preserveNullAndEmptyArrays = true,
            }
        })

		Database.Game:aggregate({
            collection = "mdt_reports",
            aggregate = aggregation,
        }, function(success, results)
            if not success then
				p:resolve(false)
                return
            end
            GlobalState['MDT:Metric:Search'] = GlobalState['MDT:Metric:Search'] + 1
			p:resolve(results)
        end)
		return Citizen.Await(p)
	end,
	Mine = function(self, char)
		local p = promise.new()
        Database.Game:find({
            collection = "mdt_reports",
            query = {
                ["$or"] = {
                    { primaries = char:GetData("Callsign") },
                    { ["author.SID"] = char:GetData("SID") },
                },
            },
        }, function(success, results)
            if not success then
				p:resolve(false)
                return
            end
			p:resolve(results)
        end)
		GlobalState['MDT:Metric:Search'] = GlobalState['MDT:Metric:Search'] + 1
		return Citizen.Await(p)
	end,
	View = function(self, id)
		local p = promise.new()
        Database.Game:findOne({
            collection = "mdt_reports",
            query = {
                _id = id,
            },
        }, function(success, report)
			if not report then
				p:resolve(false)
				return
			end
			p:resolve(report[1])
        end)
		return Citizen.Await(p)
	end,
	Create = function(self, data)
		local p = promise.new()
        data.ID = Sequence:Get('Report')
		Database.Game:insertOne({
			collection = "mdt_reports",
			document = data,
		}, function(success, result, insertId)
			if not success then
				p:resolve(false)
				return
			end
			p:resolve({
				_id = insertId[1],
				ID = data.ID,
			})
		end)
		GlobalState['MDT:Metric:Reports'] = GlobalState['MDT:Metric:Reports'] + 1
		return Citizen.Await(p)
	end,
	Update = function(self, id, char, report)
		local p = promise.new()
		Database.Game:updateOne({
			collection = "mdt_reports",
			query = {
				_id = id,
			},
			update = {
				["$set"] = report,
				["$push"] = {
					history = {
						Time = (os.time() * 1000),
						Char = char:GetData("SID"),
						Log = string.format(
								"%s Updated Report",
								char:GetData("First") .. " " .. char:GetData("Last")
						),
					},
				},
			},
		}, function(success, result)
			p:resolve(success)
		end)
		return Citizen.Await(p)
	end,
    Delete = function(self, id)
        local p = promise.new()

        Database.Game:deleteOne({
			collection = "mdt_reports",
			query = {
				_id = id,
			},
		}, function(success, deleted)
			p:resolve(success)
		end)
		return Citizen.Await(p)
    end,
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
    Callbacks:RegisterServerCallback("MDT:Search:report", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
		if CheckMDTPermissions(source, false) or char:GetData("Attorney") then
			cb(MDT.Reports:Search(data.term, data.reportType, data.tags))
		else
			cb(false)
		end
    end)

    Callbacks:RegisterServerCallback("MDT:Search:report-evidence", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Reports:SearchEvidence(data.term))
		else
			cb(false)
		end
    end)

    Callbacks:RegisterServerCallback("MDT:Search:myReport", function(source, data, cb)
        -- local char = Fetch:Source(source):GetData("Character")
		-- if char:GetData('Job').Id == 'police' then
		-- 	cb(MDT.Reports:Mine(char))
		-- else
		-- 	cb(false)
		-- end
    end)

    Callbacks:RegisterServerCallback("MDT:Create:report", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
		if CheckMDTPermissions(source, false) then
			data.doc.author = {
				SID = char:GetData("SID"),
				First = char:GetData("First"),
				Last = char:GetData("Last"),
				Callsign = char:GetData("Callsign"),
			}
			cb(MDT.Reports:Create(data.doc))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("MDT:Update:report", function(source, data, cb)
        local char = Fetch:Source(source):GetData('Character')
		if char and CheckMDTPermissions(source, false) then
            data.Report.lastUpdated = {
                Time = (os.time() * 1000),
                SID = char:GetData("SID"),
                First = char:GetData("First"),
                Last = char:GetData("Last"),
                Callsign = char:GetData("Callsign"),
            }
			cb(MDT.Reports:Update(data.ID, char, data.Report))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("MDT:Delete:report", function(source, data, cb)
		if CheckMDTPermissions(source, true) then
			cb(MDT.Reports:Delete(data.id))
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("MDT:View:report", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
		if CheckMDTPermissions(source, false) or char:GetData("Attorney") then
			cb(MDT.Reports:View(data))
        else
			cb(false)
		end
    end)
end)
