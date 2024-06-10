local requiredCharacterData = {
	SID = 1,
	User = 1,
	First = 1,
	Last = 1,
	Gender = 1,
	Origin = 1,
	Jobs = 1,
	DOB = 1,
	Callsign = 1,
	Phone = 1,
	Licenses = 1,
	Qualifications = 1,
	Flags = 1,
	Mugshot = 1,
	MDTSystemAdmin = 1,
	MDTHistory = 1,
	Attorney = 1,
	LastClockOn = 1,
	TimeClockedOn = 1,
}

_MDT.People = {
	Search = {
		People = function(self, term)
			local p = promise.new()
			Database.Game:find({
				collection = "characters",
				query = {
					["$and"] = {
						{
							["$or"] = {
								{
									["$expr"] = {
										["$regexMatch"] = {
											input = {
												["$concat"] = { "$First", " ", "$Last" },
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
												["$toString"] = "$SID",
											},
											regex = term,
											options = "i",
										},
									},
								},
							},
						},
						{
							["$or"] = {
								{ Deleted = false },
								{ Deleted = {
									["$exists"] = false,
								} },
							},
						},
					},
				},
				options = {
					projection = requiredCharacterData,
					limit = 12,
				},
			}, function(success, results)
				if not success then
					p:resolve(false)
					return
				end
				p:resolve(results)
			end)
			GlobalState["MDT:Metric:Search"] = GlobalState["MDT:Metric:Search"] + 1
			return Citizen.Await(p)
		end,
		Government = function(self)
			local p = promise.new()
			Database.Game:find({
				collection = "characters",
				query = {
					Jobs = {
						["$elemMatch"] = {
							Id = {
								["$in"] = _governmentJobs,
							},
						},
					},
				},
				options = {
					projection = requiredCharacterData,
				},
			}, function(success, results)
				if not success then
					p:resolve(false)
					return
				end
				p:resolve(results)
			end)
			return Citizen.Await(p)
		end,
		NotGovernment = function(self)
			local p = promise.new()
			Database.Game:find({
				collection = "characters",
				query = {
					Jobs = {
						["$not"] = {
							["$elemMatch"] = {
								Id = {
									["$in"] = _governmentJobs,
								},
							},
						},
					},
				},
				options = {
					projection = requiredCharacterData,
				},
			}, function(success, results)
				if not success then
					p:resolve(false)
					return
				end
				p:resolve(results)
			end)
			return Citizen.Await(p)
		end,
		Job = function(self, job, term)
			local p = promise.new()

			local qry = {
				Jobs = {
					["$elemMatch"] = {
						Id = job,
					},
				},
			}

			if term then
				qry = {
					["$and"] = {
						{
							["$or"] = {
								{
									["$expr"] = {
										["$regexMatch"] = {
											input = {
												["$concat"] = { "$First", " ", "$Last" },
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
												["$toString"] = "$SID",
											},
											regex = term,
											options = "i",
										},
									},
								},
							},
						},
						{
							Jobs = {
								["$elemMatch"] = {
									Id = job,
								},
							},
						},
					},
				}
			end

			Database.Game:find({
				collection = "characters",
				query = qry,
				options = {
					projection = requiredCharacterData,
					limit = term and 12 or nil,
				},
			}, function(success, results)
				if not success then
					p:resolve(false)
					return
				end
				p:resolve(results)
			end)
			return Citizen.Await(p)
		end,
		NotJob = function(self, job)
			local p = promise.new()
			Database.Game:find({
				collection = "characters",
				query = {
					Jobs = {
						["$not"] = {
							["$elemMatch"] = {
								Id = job,
							},
						},
					},
				},
				options = {
					projection = requiredCharacterData,
				},
			}, function(success, results)
				if not success then
					p:resolve(false)
					return
				end
				p:resolve(results)
			end)
			return Citizen.Await(p)
		end,
	},
	View = function(self, id, requireAllData)
		local SID = tonumber(id)
		local p = promise.new()
		Database.Game:findOne({
			collection = "characters",
			query = {
				SID = SID,
			},
			options = {
				projection = requiredCharacterData,
			},
		}, function(success, character)
			if not success or #character < 0 then
				p:resolve(false)
				return
			end

			if requireAllData then
				Database.Game:findOne({
					collection = "character_convictions",
					query = {
						SID = SID,
					},
				}, function(success2, convictions)
					if not success2 then
						p:resolve(false)
						return
					end

					Database.Game:find({
						collection = "vehicles",
						query = {
							["Owner.Type"] = 0,
							["Owner.Id"] = SID,
						},
					}, function(success, vehicles)
						if not success2 then
							p:resolve(false)
							return
						end
						local char = character[1]
						local ownedBusinesses = {}

						if char.Jobs then
							for k, v in ipairs(char.Jobs) do
								local jobData = Jobs:Get(v.Id)
								if jobData.Owner and jobData.Owner == char.SID then
									table.insert(ownedBusinesses, v.Id)
								end
							end
						end

						p:resolve({
							data = char,
							convictions = convictions[1],
							vehicles = vehicles,
							ownedBusinesses = ownedBusinesses,
						})
					end)
				end)
			else
				p:resolve(character[1])
			end
		end)
		return Citizen.Await(p)
	end,
	Update = function(self, requester, id, key, value)
		local p = promise.new()
		local logVal = value
		if type(value) == "table" then
			logVal = json.encode(value)
		end

		local update = {
			["$set"] = {
				[key] = value,
			},
		}

		if requester == -1 then
			update["$push"] = {
				MDTHistory = {
					Time = (os.time() * 1000),
					Char = -1,
					Log = string.format("System Updated Profile, Set %s To %s", key, logVal),
				},
			}
		else
			update["$push"] = {
				MDTHistory = {
					Time = (os.time() * 1000),
					Char = requester:GetData("SID"),
					Log = string.format(
						"%s Updated Profile, Set %s To %s",
						requester:GetData("First") .. " " .. requester:GetData("Last"),
						key,
						logVal
					),
				},
			}
		end

		Database.Game:updateOne({
			collection = "characters",
			query = {
				SID = id,
			},
			update = update,
		}, function(success, results)
			if success then
				local target = Fetch:SID(id)
				if target then
					target:GetData("Character"):SetData(key, value)
				end
			end
			p:resolve(success)
		end)
		return Citizen.Await(p)
	end,
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Search:people", function(source, data, cb)
		cb(MDT.People.Search:People(data.term))
	end)

	Callbacks:RegisterServerCallback("MDT:Search:government", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.People.Search:Government(data.term))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Search:not-government", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.People.Search:NotGovernment(data.term))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Search:job", function(source, data, cb)
		if CheckMDTPermissions(source, false) or CheckBusinessPermissions(source) then
			cb(MDT.People.Search:Job(data.job, data.term))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Search:not-job", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.People.Search:NotJob(data.job, data.term))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:View:person", function(source, data, cb)
		cb(MDT.People:View(data, true))
	end)

	Callbacks:RegisterServerCallback("MDT:Update:person", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char and CheckMDTPermissions(source, false) and data.SID then
			cb(MDT.People:Update(char, data.SID, data.Key, data.Data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:CheckCallsign", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			Database.Game:findOne({
				collection = "characters",
				query = {
					Callsign = data,
				},
			}, function(success, results)
				cb(#results == 0)
			end)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:CheckParole", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			Database.Game:findOne({
				collection = "characters",
				query = {
					SID = data,
				},
				options = {
					projection = {
						SID = -1,
						Parole = 1,
					},
				},
			}, function(success, results)
				if results[1].Parole ~= nil then
					cb(results[1].Parole)
				else
					cb(false)
				end
			end)
		else
			cb(false)
		end
	end)
end)
