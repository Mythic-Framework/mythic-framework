_MDT.Warrants = {
	Search = function(self, term)
		local p = promise.new()
		Database.Game:find({
			collection = "mdt_warrants",
			query = {},
		}, function(success, results)
			if not success then
				p:resolve(false)
				return
			end

			p:resolve(results)
		end)

		return Citizen.Await(p)
	end,
	View = function(self, id)
		local p = promise.new()
		Database.Game:findOne({
			collection = "mdt_warrants",
			query = {
				_id = data,
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
	Create = function(self, data)
		local p = promise.new()
		Database.Game:insertOne({
			collection = "mdt_warrants",
			document = data,
		}, function(success, result, insertId)
			if not success then
				p:resolve(false)
				return
			end
			data._id = insertId[1]
			table.insert(_warrants, data)
			for user, _ in pairs(_onDutyUsers) do
				TriggerClientEvent("MDT:Client:AddData", user, "warrants", data)
			end
			for user, _ in pairs(_onDutyLawyers) do
				TriggerClientEvent("MDT:Client:AddData", user, "warrants", data)
			end
			p:resolve(success)
		end)
		GlobalState["MDT:Metric:Warrants"] = GlobalState["MDT:Metric:Warrants"] + 1
		return Citizen.Await(p)
	end,
	Update = function(self, id, state, updater)
		local p = promise.new()
		Database.Game:updateOne({
			collection = "mdt_warrants",
			query = {
				_id = id,
			},
			update = {
				["$set"] = {
					state = state,
				},
				["$push"] = {
					history = updater,
				},
			},
		}, function(success, result)
			if not success then
				p:resolve(false)
				return
			end

			for k, v in ipairs(_warrants) do
				if v._id == id then
					v.state = state

					for user, _ in pairs(_onDutyUsers) do
						TriggerClientEvent("MDT:Client:UpdateData", user, "warrants", id, v)
					end

					for user, _ in pairs(_onDutyLawyers) do
						TriggerClientEvent("MDT:Client:UpdateData", user, "warrants", id, v)
					end
				end
			end

			p:resolve(true)
		end)

		return Citizen.Await(p)
	end,
	-- Delete = function(self, id)
	-- 	local p = promise.new()
	-- 	Database.Game:updateOne({
	-- 		collection = "mdt_warrants",
	-- 		query = {
	-- 			_id = id,
	-- 		},
	-- 	}, function(success, result)
	-- 		if not success then
	-- 			p:resolve(false)
	-- 			return
	-- 		end
	-- 		cb(insertId[1])

	-- 		data.doc._id = insertId[1]
	-- 		table.insert(_warrants, data.doc)

	-- 		for user, _ in pairs(_onDutyUsers) do
	-- 			TriggerClientEvent("MDT:Client:AddData", user, "warrants", data.doc)
	-- 		end
	-- 	end)
	-- 	return Citizen.Await(p)
	-- end,
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Search:warrant", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		cb(MDT.Warrants:Search(data.term))
	end)

	Callbacks:RegisterServerCallback("MDT:View:warrant", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Warrants:View(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Create:warrant", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")

		if char and CheckMDTPermissions(source, false) then
			data.doc.author = {
				SID = char:GetData("SID"),
				First = char:GetData("First"),
				Last = char:GetData("Last"),
				Callsign = char:GetData("Callsign"),
			}
			data.doc.ID = Sequence:Get("Warrant")
			cb(MDT.Warrants:Create(data.doc))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Update:warrant", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")

		if char and CheckMDTPermissions(source, false) then
			local updater = {
				SID = char:GetData("SID"),
				First = char:GetData("First"),
				Last = char:GetData("Last"),
				Callsign = char:GetData("Callsign"),
				Action = string.format("Updated Warrant State To: %s", data.state),
				Date = os.time() * 1000,
			}
			if CheckMDTPermissions(source, false) then
				cb(MDT.Warrants:Update(data.id, data.state, updater))
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	-- Callbacks:RegisterServerCallback("MDT:Delete:warrant", function(source, data, cb)
	-- 	local char = Fetch:Source(source):GetData("Character")

	-- 	if CheckMDTPermissions(source, false) then
	-- 		cb(MDT.Warrants:Delete(data.id))
	-- 	else
	-- 		cb(false)
	-- 	end
	-- end)
end)
