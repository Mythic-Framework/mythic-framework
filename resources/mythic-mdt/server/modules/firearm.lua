_MDT.Firearm = {
	Search = function(self, term)
		local p = promise.new()
		Database.Game:find({
			collection = "firearms",
			query = {
				["$and"] = {
					{
						["$or"] = {
							{
								["$expr"] = {
									["$regexMatch"] = {
										input = {
											["$concat"] = { "$Owner.First", " ", "$Owner.Last" },
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
											["$toString"] = "$Owner.SID",
										},
										regex = term,
										options = "i",
									},
								},
							},
							{
								Serial = {
									["$regex"] = term,
									["$options"] = "i",
								},
							},
						},
					},
					{
						Scratched = false,
					}
				}
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
	View = function(self, id)
		local p = promise.new()
		Database.Game:findOne({
			collection = "firearms",
			query = {
				_id = id,
			},
		}, function(success, results)
			if not success then
				p:resolve(false)
				return
			end
			p:resolve(results[1])
		end)
		return Citizen.Await(p)
	end,
	Flags = {
		Add = function(self, id, data)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "firearms",
				query = {
					_id = id,
				},
				update = {
					["$push"] = {
						Flags = data,
					},
				},
			}, function(success, result)
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		Remove = function(self, id, flag)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "firearms",
				query = {
					_id = id,
				},
				update = {
					["$pull"] = {
						Flags = {
							Type = flag,
						},
					},
				},
			}, function(success, result)
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
	},
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Search:firearm", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Firearm:Search(data.term))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:View:firearm", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Firearm:View(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Create:firearm-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Firearm.Flags:Add(data.parentId, data.doc))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Delete:firearm-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Firearm.Flags:Remove(data.parentId, data.id))
		else
			cb(false)
		end
	end)
end)
