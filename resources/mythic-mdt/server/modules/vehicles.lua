_MDT.Vehicles = {
	Search = function(self, term)
		local p = promise.new()
		Database.Game:find({
			collection = "vehicles",
			query = {
				["$or"] = {
					{
						['Owner.Type'] = 0,
						['$expr'] = {
							['$regexMatch'] = {
								input = {
									['$toString'] = '$Owner.Id'
								},
								regex = term,
								options = "i",
							}
						}
					},
					{
						VIN = {
							['$regex'] = term,
							['$options'] = "i",
						}
					},
					{
						RegisteredPlate = {
							["$regex"] = term,
							["$options"] = "i",
						},
					},
					{
						["$expr"] = {
							["$regexMatch"] = {
								input = {
									["$concat"] = { "$Make", " ", "$Model" },
								},
								regex = term,
								options = "i",
							},
						},
					},
				},
			},
			options = {
				limit = 24,
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
	View = function(self, VIN)
		local p = promise.new()
		Database.Game:findOne({
			collection = "vehicles",
			query = {
				VIN = VIN,
			},
		}, function(success, results)
			if not success or #results <= 0 then
				p:resolve(false)
				return
			end
			local vehicle = results[1]

			if vehicle.Owner then
				if vehicle.Owner.Type == 0 then
					vehicle.Owner.Person = MDT.People:View(vehicle.Owner.Id)
				elseif vehicle.Owner.Type == 1 or vehicle.Owner.Type == 2 then
					local jobData = Jobs:DoesExist(vehicle.Owner.Id, vehicle.Owner.Workplace)
					if jobData then
						if jobData.Workplace then
							vehicle.Owner.JobName = string.format('%s (%s)', jobData.Name, jobData.Workplace.Name)
						else
							vehicle.Owner.JobName = jobData.Name
						end
					end
				end

				if vehicle.Owner.Type == 2 then
					vehicle.Owner.JobName = vehicle.Owner.JobName .. " (Dealership Buyback)"
				end
			end
			p:resolve(vehicle)
		end)
		return Citizen.Await(p)
	end,
	Flags = {
		Add = function(self, VIN, data, plate)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "vehicles",
				query = {
					VIN = VIN,
				},
				update = {
					["$push"] = {
						Flags = data,
					},
				},
			}, function(success, result)
				if success and data.radarFlag and plate then
					Radar:AddFlaggedPlate(plate, 'Vehicle Flagged in MDT')
				end
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		Remove = function(self, VIN, flag)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "vehicles",
				query = {
					VIN = VIN,
				},
				update = {
					["$pull"] = {
						Flags = {
							Type = flag
						},
					},
				},
			}, function(success, result)
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
	},
	UpdateStrikes = function(self, VIN, strikes)
		local p = promise.new()
		Database.Game:updateOne({
			collection = "vehicles",
			query = {
				VIN = VIN,
			},
			update = {
				["$set"] = {
					Strikes = strikes,
				},
			},
		}, function(success, result)
			p:resolve(success)
		end)
		return Citizen.Await(p)
	end,
	GetStrikes = function(self, VIN)
		local p = promise.new()
		Database.Game:findOne({
			collection = "vehicles",
			query = {
				VIN = VIN,
			},
			options = {
				projection = {
					VIN = 1,
					Strikes = 1,
					RegisteredPlate = 1,
				}
			}
		}, function(success, results)
			if success then
				local veh = results[1]
				local strikes = 0
				if veh and veh.Strikes and #veh.Strikes > 0 then
					strikes = #veh.Strikes
				end

				p:resolve(strikes)
			else
				p:resolve(0)
			end
		end)

		return Citizen.Await(p)
	end
}

AddEventHandler("MDT:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("MDT:Search:vehicle", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Vehicles:Search(data.term))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:View:vehicle", function(source, data, cb)
		if CheckMDTPermissions(source, false) then
			cb(MDT.Vehicles:View(data))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Create:vehicle-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(MDT.Vehicles.Flags:Add(data.parent, data.doc, data.plate))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Delete:vehicle-flag", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(MDT.Vehicles.Flags:Remove(data.parent, data.id))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("MDT:Update:vehicle-strikes", function(source, data, cb)
		if CheckMDTPermissions(source, false, 'police') then
			cb(MDT.Vehicles:UpdateStrikes(data.VIN, data.strikes))
		else
			cb(false)
		end
	end)
end)
