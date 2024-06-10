_warrants = {}
_charges = {}
_tags = {}
_notices = {}

local _ran = false

function Startup()
	if _ran then
		return
	end
	AddDefaultData()
	RegisterTasks()

	Database.Game:update({
		collection = "mdt_warrants",
		query = {
			expires = {
				["$lte"] = (os.time() * 1000),
			},
		},
		update = {
			['$set'] = {
				state = "expired",
			}
		}
	}, function(success, updated)
		if success then
			Logger:Trace("MDT", "Expired ^2" .. updated .. "^7 Old Warrants", { console = true })
		end

		Database.Game:find({
			collection = "mdt_warrants",
			query = {
				state = "active",
			}
		}, function(success, results)
			if not success then
				return
			end
	
			Logger:Trace("MDT", "Loaded ^2" .. #results .. "^7 Active Warrants", { console = true })
			_warrants = results
		end)
	end)

	Database.Game:find({
		collection = "mdt_charges",
		query = {}
	}, function(success, results)
		if not success then
			return
		end

		Logger:Trace("MDT", "Loaded ^2" .. #results .. "^7 Charges", { console = true })
		_charges = results
	end)

	Database.Game:find({
		collection = "mdt_tags",
		query = {}
	}, function(success, results)
		if not success then
			return
		end

		Logger:Trace("MDT", "Loaded ^2" .. #results .. "^7 Tags", { console = true })
		_tags = results
	end)

	Database.Game:find({
		collection = "mdt_notices",
		query = {}
	}, function(success, results)
		if not success then
			return
		end

		Logger:Trace("MDT", "Loaded ^2" .. #results .. "^7 Notices", { console = true })
		_notices = results
	end)

	Database.Game:find({
		collection = "vehicles",
		query = {
			Flags = {
				['$elemMatch'] = {
					radarFlag = true,
				}
			}
		},
		options = {
			projection = {
				VIN = 1,
				Flags = 1,
				RegisteredPlate = 1,
			}
		}
	}, function(success, results)
		if not success then
			return
		end

		for k,v in ipairs(results) do
			if v.RegisteredPlate and v.Type == 0 then
				Radar:AddFlaggedPlate(v.RegisteredPlate, 'Vehicle Flagged in MDT')
			end
		end
	end)

	_ran = true

	SetHttpHandler(function(req, res)
		if req.path == '/charges' then
			res.send(json.encode(_charges))
		end
	end)
end
