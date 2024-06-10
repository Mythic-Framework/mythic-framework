function RegisterChatCommands()
	-- Spawning and Deleting Temporary Admin Vehicles
	Chat:RegisterAdminCommand("sv", function(source, args, rawCommand)
		local vehModel = GetHashKey(args[1])
		Callbacks:ClientCallback(
			source,
			"Vehicles:Admin:GetVehicleSpawnData",
			vehModel,
			function(spawnCoords, spawnHeading)
				if spawnCoords then
					Vehicles:SpawnTemp(source, vehModel, spawnCoords, spawnHeading, function(veh, VIN)
						Vehicles.Keys:Add(source, VIN)
					end)
				else
					Chat.Send.Server:Single(source, "Invalid Vehicle Model")
				end
			end
		)
	end, {
		help = "Spawn Vehicle With Given Model",
		params = {
			{
				name = "Model Name",
				help = "Name of the model you want to spawn",
			},
		},
	}, 1)

	Chat:RegisterStaffCommand("dv", function(source, args, rawCommand)
		Callbacks:ClientCallback(source, "Vehicles:Admin:GetVehicleToDelete", false, function(vehNet)
			local targetVehicle = NetworkGetEntityFromNetworkId(vehNet)
			Vehicles:Delete(targetVehicle, function() end)
		end)
	end, {
		help = "Deletes a Vehicle You Are Inside or Looking at",
		params = {},
	}, 0)

	Chat:RegisterAdminCommand("vehiclescount", function(source, args, rawCommand)
		local count = 0
		for k, v in pairs(ACTIVE_OWNED_VEHICLES) do
			count = count + 1
		end

		Chat.Send.Server:Single(source, count .. " Total Owned Vehicles Spawned")
	end, {
		help = "[Dev] Get Total Owned Vehicle Count",
		params = {},
	}, 0)

	Chat:RegisterAdminCommand("clearvehicle", function(source, args, rawCommand)
		local VIN = args[1]
		if not VIN then return; end

		Vehicles.Owned:Delete(VIN, function(success, nonExist)
			if success then
				if nonExist then
					Chat.Send.Server:Single(source, "Successfully Deleted - It Didn't Exist")
				else
					Chat.Send.Server:Single(source, "Successfully Deleted & Saved")
				end
			else
				Chat.Send.Server:Single(source, "Failed to Delete")
			end
		end, true)
	end, {
		help = "[Dev] Delete Owned Vehicle From Map By VIN",
		params = {
			{
				name = "VIN",
				help = "VIN of Vehicle",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("addownedvehicle", function(source, args, rawCommand)
		local targetSource, vehHash, make, model, class, value, vehType = table.unpack(args)

		if not targetSource or not vehHash or not make or not model then
			Chat.Send.System:Single(source, "Invalid Arguments")
			return
		end

		local player = Fetch:SID(tonumber(targetSource))
		if player then
			local char = player:GetData("Character")
			if char then
				local stateId = char:GetData("SID")

				vehType = tonumber(vehType) or 0
				vehHash = GetHashKey(vehHash)

				if type(vehHash) == "number" and make and model then
					Vehicles.Owned:AddToCharacter(stateId, vehHash, vehType, {
						make = make,
						model = model,
						class = class,
						value = math.tointeger(value),
					}, function(success, vehicle)
						if success then
							Chat.Send.System:Single(
								source,
								string.format(
									"Successfully Added Vehicle to State ID: %s With VIN: %s",
									stateId,
									vehicle.VIN
								)
							)
						else
							Chat.Send.System:Single(source, "Error Adding Vehicle")
						end
					end)
				end
			else
				Chat.Send.System:Single(source, "Player Not Logged In")
			end
		else
			Chat.Send.System:Single(source, "Invalid State ID")
		end
	end, {
		help = "Add Owned Vehicle to Player",
		params = {
			{
				name = "State ID",
				help = "State ID of Target Character",
			},
			{
				name = "Vehicle Model",
				help = "Vehicle Model (Spawn Code)",
			},
			{
				name = "Make",
				help = "Make of Vehicle e.g Dodge",
			},
			{
				name = "Model",
				help = "Model Name of Vehicle e.g Charger",
			},
			{
				name = "Class",
				help = "Class of Vehicle e.g S, A+, A, B",
			},
			{
				name = "Value",
				help = "Monetary Value of Vehicle e.g 50000",
			},
			{
				name = "Vehicle Type",
				help = "Vehicle/Car = 0; Boats = 1; Aircraft = 2; (NOT REQUIRED - 0)",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("addfleetvehicle", function(source, args, rawCommand)
		local jobId, workplaceId, level, vehHash, make, model, class, value, vehType, qual = table.unpack(args)
		if not jobId or not workplaceId or not level or not vehHash or not make or not model then
			Chat.Send.System:Single(source, "Invalid Arguments")
			return
		end

		vehType = tonumber(vehType)
		vehHash = GetHashKey(vehHash)
		level = tonumber(level)

		if workplaceId == "false" or workplaceId == "all" then
			workplaceId = false
		end

		if not qual or qual == "false" or qual == "all" then
			qual = false
		end

		local jobExists = Jobs:DoesExist(jobId, workplaceId)
		if type(vehHash) == "number" and jobExists and level and level >= 0 and level < 10 and make and model then
			Vehicles.Owned:AddToFleet(jobId, workplaceId, level, vehHash, vehType, {
				make = make,
				model = model,
				class = class,
				value = math.tointeger(value),
			}, function(success, vehicle)
				if success then
					Chat.Send.System:Single(
						source,
						string.format("Successfully Added Vehicle to Fleet With VIN: %s", vehicle.VIN)
					)
				else
					Chat.Send.System:Single(source, "Error Adding Vehicle To Fleet")
				end
			end, false, qual)
		else
			Chat.Send.System:Single(source, "Error Adding Vehicle To Fleet")
		end
	end, {
		help = "Add a Fleet Vehicle to a Job",
		params = {
			{
				name = "Job ID",
				help = "ID of Target Job For Fleet Vehicle",
			},
			{
				name = "Workplace ID",
				help = 'ID of Workplace. Put "false" or "all" for All Workplaces to Access the Fleet Vehicle',
			},
			{
				name = "Required Level",
				help = "Required Fleet Vehicle Level to Spawn the Vehicle",
			},
			{
				name = "Vehicle Model",
				help = "Vehicle Model (Spawn Code)",
			},
			{
				name = "Make",
				help = "Make of Vehicle e.g Dodge",
			},
			{
				name = "Model",
				help = "Model Name of Vehicle e.g Charger",
			},
			{
				name = "Class",
				help = "Class of Vehicle e.g S, A+, A, B",
			},
			{
				name = "Value",
				help = "Monetary Value of Vehicle e.g 50000",
			},
			{
				name = "Vehicle Type",
				help = "Vehicle/Car = 0; Boats = 1; Aircraft = 2; (NOT REQUIRED - Default: 0)",
			},
			{
				name = "Qualification",
				help = "Job Qualification Put \"false\" or \"all\" for All to Access the Fleet Vehicle",
			},
		},
	}, -1)

	Chat:RegisterAdminCommand("forceaudio", function(source, args, rawCommand)
		Callbacks:ClientCallback(source, "Vehicles:Admin:GetVehicleInsideData", false, function(veh)
			local audio = args[1]:upper()
			if audio == "remove" or audio == "false" then
				audio = false
			end

			if veh and veh.vehicle then
				local v = NetworkGetEntityFromNetworkId(veh.vehicle)
				if v and DoesEntityExist(v) then
					local ent = Entity(v)
					if ent and ent.state and ent.state.VIN then
						local vehicle = Vehicles.Owned:GetActive(ent.state.VIN)
						if vehicle then
							vehicle:SetData("ForcedAudio", audio)
							ent.state.ForcedAudio = audio

							TriggerClientEvent("Vehicle:Client:ForceAudio", -1, veh.vehicle, audio)

							Vehicles.Owned:ForceSave(ent.state.VIN)

							Execute:Client(source, "Notification", "Success", "Done")
						else
							ent.state.ForcedAudio = audio
							TriggerClientEvent("Vehicle:Client:ForceAudio", -1, veh.vehicle, audio)

							Execute:Client(source, "Notification", "Success", "Done")
						end
						return
					end
				end
			end

			Execute:Client(source, "Notification", "Error", "Error")
		end)
	end, {
		help = "Force Overrides a Vehicle Engine Audio & Saves It",
		params = {
			{
				name = "Audio String",
				help = "Do 'false' or 'remove' to put back to normal",
			},
		},
	}, 1)

	Chat:RegisterCommand("seat", function(source, args, rawCommand)
		local seatNum = tonumber(args[1])
		if seatNum and seatNum > 0 then
			TriggerClientEvent("Vehicles:Client:Actions:SwitchSeat", source, seatNum - 2)
		end
	end, {
		help = "Switch Seats in Current Vehicle",
		params = {
			{
				name = "Seat Number",
				help = "e.g 1-4",
			},
		},
	}, 1)

	Chat:RegisterCommand("door", function(source, args, rawCommand)
		local doorNum = args[1]
		local action = string.lower(doorNum)
		if action == "open" or action == "shut" or action == "close" then
			TriggerClientEvent("Vehicles:Client:Actions:ToggleDoor", source, doorNum)
			return
		end

		local doorNum = tonumber(doorNum)
		if doorNum and doorNum > 0 then
			TriggerClientEvent("Vehicles:Client:Actions:ToggleDoor", source, doorNum - 1)
		end
	end, {
		help = "Toggle Doors in Current Vehicle",
		params = {
			{
				name = "Door Number",
				help = "e.g 1-4",
			},
		},
	}, 1)

	Chat:RegisterCommand("win", function(source, args, rawCommand)
		local winNum = args[1]
		local action = string.lower(winNum)
		if action == "open" or action == "shut" or action == "close" then
			TriggerClientEvent("Vehicles:Client:Actions:ToggleWindow", source, winNum)
			return
		end

		local winNum = tonumber(doorNum)
		if winNum and winNum > 0 then
			TriggerClientEvent("Vehicles:Client:Actions:ToggleWindow", source, winNum - 1)
		end
	end, {
		help = "Toggle Windows in Current Vehicle",
		params = {
			{
				name = "Window Number",
				help = "e.g 1-4",
			},
		},
	}, 1)

	-- Chat:RegisterCommand('slimjim', function(source, args, rawCommand)
	--     TriggerClientEvent('Vehicles:Client:AttemptSlimJim', source)
	-- end, {
	--     help = 'Attempt to Slimjim a Vehicle',
	--     params = {}
	-- }, -1)

	Chat:RegisterCommand("givekeys", function(source, args, rawCommand)
		Callbacks:ClientCallback(
			source,
			"Vehicles:Keys:GetVehicleToShare",
			{},
			function(data, sids)
				local veh = NetworkGetEntityFromNetworkId(data)
				if veh and DoesEntityExist(veh) then
					local vehEnt = Entity(veh)
					if
						vehEnt
						and vehEnt.state
						and vehEnt.state.VIN
						and Vehicles.Keys:Has(source, vehEnt.state.VIN, false)
					then
						for k, v in ipairs(sids) do
							Vehicles.Keys:Add(v, vehEnt.state.VIN)
							Execute:Client(
								v,
								"Notification",
								"Info",
								"You Received Keys to a Vehicle",
								3000,
								"key"
							)
						end

						Execute:Client(
							source,
							"Notification",
							"Success",
							"You Gave Everyone Nearby Keys",
							3000,
							"key"
						)
					end
				end
			end
		)
	end, {
		help = "Share Keys of Nearby Vehicle With Nearby Players",
		params = {},
	}, 0)

	Chat:RegisterCommand("transfer", function(source, args, rawCommand)
		local target = tonumber(args[1])
		if target and target > 0 then
			local player = Fetch:Source(source)
			local targetPlayer = Fetch:SID(target)
			if targetPlayer and player and targetPlayer:GetData("Source") ~= player:GetData("Source") then
				local char = player:GetData("Character")
				if targetPlayer:GetData("Character") and char then
					Callbacks:ClientCallback(source, "Vehicles:Transfers:GetTarget", {}, function(data)
						local veh = NetworkGetEntityFromNetworkId(data)
						if veh and DoesEntityExist(veh) then
							local vehEnt = Entity(veh)
							if vehEnt?.state?.VIN and vehEnt?.state?.Owned and vehEnt?.state?.Owner?.Type == 0 and vehEnt?.state?.Owner?.Id == char:GetData("SID") then
								TriggerClientEvent('Vehicles:Tranfers:BeginConfirmation', source, {
									SID = target,
									Make = vehEnt.state.Make,
									Model = vehEnt.state.Model,
									VIN = vehEnt.state.VIN,
									Plate = vehEnt.state.Plate,
								})
							end
						end
					end)
					return
				end
			end
		end
		Execute:Client(source, 'Notification', 'Error', 'Invalid State ID')
	end, {
		help = "Transfer Ownership of the Vehicle You Are Looking at or In to Another Person",
		params = {
			{
				name = "State ID",
				help = "The person you want to make the new owner",
			},
		},
	}, 1)
end
