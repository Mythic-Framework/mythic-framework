_MDT.Properties = {
	Search = function(self, term)
		local p = promise.new()
		Database.Game:find({
			collection = "properties",
			query = {
                type = {
                    ['$nin'] = {
                        'container',
                    }
                },
				unlisted = {
					["$ne"] = true,
				},
				["$or"] = {
					{
						['$expr'] = {
							['$regexMatch'] = {
								input = {
									['$toString'] = '$owner.SID'
								},
								regex = term,
								options = "i",
							}
						}
					},
					{
						["$expr"] = {
							["$regexMatch"] = {
								input = {
									["$concat"] = { "$owner.First", " ", "$owner.Last" },
								},
								regex = term,
								options = "i",
							},
						},
					},
					{
						label = {
							['$regex'] = term,
							['$options'] = "i",
						}
					},
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
	-- View = function(self, VIN)
	-- 	local p = promise.new()
	-- 	Database.Game:findOne({
	-- 		collection = "vehicles",
	-- 		query = {
	-- 			VIN = VIN,
	-- 		},
	-- 	}, function(success, results)
	-- 		if not success or #results <= 0 then
	-- 			p:resolve(false)
	-- 			return
	-- 		end
	-- 		local vehicle = results[1]

	-- 		if vehicle.Owner then
	-- 			if vehicle.Owner.Type == 0 then
	-- 				vehicle.Owner.Person = MDT.People:View(vehicle.Owner.Id)
	-- 			elseif vehicle.Owner.Type == 1 then
	-- 				local jobData = Jobs:DoesExist(vehicle.Owner.Id, vehicle.Owner.Workplace)
	-- 				if jobData then
	-- 					if jobData.Workplace then
	-- 						vehicle.Owner.JobName = string.format('%s (%s)', jobData.Name, jobData.Workplace.Name)
	-- 					else
	-- 						vehicle.Owner.JobName = jobData.Name
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 		p:resolve(vehicle)
	-- 	end)
	-- 	return Citizen.Await(p)
	-- end,
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Search:property", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Properties:Search(data.term))
		else
			cb(false)
		end
	end)

	-- Callbacks:RegisterServerCallback("MDT:View:vehicle", function(source, data, cb)
	-- 	if CheckMDTPermissions(source, false) then
	-- 		cb(MDT.Vehicles:View(data))
	-- 	else
	-- 		cb(false)
	-- 	end
	-- end)
end)
