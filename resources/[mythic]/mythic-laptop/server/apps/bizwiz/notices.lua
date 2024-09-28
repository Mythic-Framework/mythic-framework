AddEventHandler("Laptop:Server:RegisterCallbacks", function()
	Database.Game:find({
		collection = "business_notices",
		query = {},
	}, function(success, results)
		if not success then
			return
		end

		Logger:Trace("Laptop", "[BizWiz] Loaded ^2" .. #results .. "^7 Business Notices", { console = true })
		_businessNotices = results
	end)

	Callbacks:RegisterServerCallback("Laptop:BizWiz:Notice:Create", function(source, data, cb)
		local job = CheckBusinessPermissions(source, "LAPTOP_CREATE_NOTICE")
		if job then
			cb(Laptop.BizWiz.Notices:Create(source, job, data.doc))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Laptop:BizWiz:Notice:Delete", function(source, data, cb)
		local job = CheckBusinessPermissions(source, "LAPTOP_DELETE_NOTICE")
		if job then
			cb(Laptop.BizWiz.Notices:Delete(job, data.id))
		else
			cb(false)
		end
	end)
end)

LAPTOP.BizWiz = LAPTOP.BizWiz or {}
LAPTOP.BizWiz.Notices = {
	Create = function(self, source, job, data)
		local char = Fetch:Source(source):GetData("Character")
		if char then
			local p = promise.new()

			data.job = job
			data.author = {
				SID = char:GetData("SID"),
				First = char:GetData("First"),
				Last = char:GetData("Last"),
			}

			Database.Game:insertOne({
				collection = "business_notices",
				document = data,
			}, function(success, result, insertIds)
				if not success then
					p:resolve(false)
					return
				end

				data._id = insertIds[1]
				table.insert(_businessNotices, data)

				local jobDutyData = Jobs.Duty:GetDutyData(job)
				if jobDutyData and jobDutyData.DutyPlayers then
					for k, v in ipairs(jobDutyData.DutyPlayers) do
						TriggerClientEvent("Laptop:Client:AddData", v, "businessNotices", data)
					end
				end

				p:resolve(insertIds[1])
			end)
			return Citizen.Await(p)
		end
		return false
	end,
	Delete = function(self, job, id)
		local p = promise.new()
		Database.Game:deleteOne({
			collection = "business_notices",
			query = {
				_id = id,
				job = job,
			},
		}, function(success, deleted)
			if not success then
				p:resolve(false)
				return
			end

			for k, v in ipairs(_businessNotices) do
				if v._id == id then
					table.remove(_businessNotices, k)
					break
				end
			end

			local jobDutyData = Jobs.Duty:GetDutyData(job)
			if jobDutyData and jobDutyData.DutyPlayers then
				for k, v in ipairs(jobDutyData.DutyPlayers) do
					TriggerClientEvent("Laptop:Client:RemoveData", v, "businessNotices", id)
				end
			end

			p:resolve(true)
		end)
		return Citizen.Await(p)
	end,
}
