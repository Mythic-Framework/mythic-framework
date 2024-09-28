_inProgress = {}
_chopped = {}
_pChopping = {}

local _emailed = {}

AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("playerDropped", function(source, message)
		if _pChopping[source] ~= nil then
			_inProgress[_pChopping[source]] = nil
		end
	end, 5)
	Middleware:Add("Characters:Logout", function(source)
		if _pChopping[source] ~= nil then
			_inProgress[_pChopping[source]] = nil
		end
	end, 5)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	local r = math.random(#_chopDropoffs)
	GlobalState["PublicDropoff"] = _chopDropoffs[r]
	if r + 1 > #_chopDropoffs then
		GlobalState["PrivateDropoff"] = _chopDropoffs[1]
		GlobalState["PersonalDropoff"] = _chopDropoffs[2]
	else
		GlobalState["PrivateDropoff"] = _chopDropoffs[r + 1]
		if r + 2 > #_chopDropoffs then
			GlobalState["PersonalDropoff"] = _chopDropoffs[1]
		else
			GlobalState["PersonalDropoff"] = _chopDropoffs[r + 2]
		end
	end

	
    Chat:RegisterAdminCommand('choplists', function(source, args, rawCommand)
		if args[1] == "all" then
			Logger:Trace("Chopping", "Generating New Public Chop List")
			_publicChoplist = {
				list = Phone.LSUnderground.Chopping:GenerateList(10, 2),
				public = true,
			}

			for k, v in pairs(_inProgress) do
				if v.type == 1 then
					for k2, v2 in pairs(_pChopping) do
						if v2 == k then
							TriggerClientEvent("Phone:Client:LSUnderground:Chopping:CancelCurrent", k2)
							_pChopping[k2] = nil
						end
					end
					_inProgress[k] = nil
					_chopped[k] = nil
				end
			end
			
			Logger:Trace("Chopping", "Generating New VIP Chop List")
			_vipChopList = {
				list = Phone.LSUnderground.Chopping:GenerateList(10, 4),
				public = true,
			}

			for k, v in pairs(_inProgress) do
				if v.type == 2 then
					for k2, v2 in pairs(_pChopping) do
						if v2 == k then
							TriggerClientEvent("Phone:Client:LSUnderground:Chopping:CancelCurrent", k2)
							_pChopping[k2] = nil
						end
					end
					_inProgress[k] = nil
					_chopped[k] = nil
				end
			end
			
			for k, v in pairs(Fetch:All()) do
				local c = v:GetData("Character")
				if c ~= nil then
					local dutyData = Jobs.Duty:Get(v:GetData("Source"))
					if hasValue(c:GetData("States") or {}, "ACCESS_LSUNDERGROUND") and (not dutyData or dutyData.Id ~= "police") then
						Phone.Notification:Add(
							v:GetData("Source"),
							"New Chop List",
							"A New Public Chop List Is Available",
							os.time() * 1000,
							10000,
							"lsunderground",
							{
								view = "",
							}
						)

						Phone.Notification:Add(
							v:GetData("Source"),
							"New Chop List",
							"A New Private Chop List Is Available",
							os.time() * 1000,
							10000,
							"lsunderground",
							{
								view = "",
							}
						)
					end
				end
			end
		elseif args[1] == "public" then
			Logger:Trace("Chopping", "Generating New Public Chop List")
			_publicChoplist = {
				list = Phone.LSUnderground.Chopping:GenerateList(10, 2),
				public = true,
			}

			for k, v in pairs(_inProgress) do
				if v.type == 1 then
					for k2, v2 in pairs(_pChopping) do
						if v2 == k then
							TriggerClientEvent("Phone:Client:LSUnderground:Chopping:CancelCurrent", k2)
							_pChopping[k2] = nil
						end
					end
					_inProgress[k] = nil
					_chopped[k] = nil
				end
			end
			
			for k, v in pairs(Fetch:All()) do
				local c = v:GetData("Character")
				if c ~= nil then
					local dutyData = Jobs.Duty:Get(v:GetData("Source"))
					if hasValue(c:GetData("States") or {}, "ACCESS_LSUNDERGROUND") and (not dutyData or dutyData.Id ~= "police") then
						Phone.Notification:Add(
							v:GetData("Source"),
							"New Chop List",
							"A New Public Chop List Is Available",
							os.time() * 1000,
							10000,
							"lsunderground",
							{
								view = "",
							}
						)
					end
				end
			end
		elseif args[1] == "private" then
			Logger:Trace("Chopping", "Generating New VIP Chop List")
			_vipChopList = {
				list = Phone.LSUnderground.Chopping:GenerateList(10, 4),
				public = true,
			}

			for k, v in pairs(_inProgress) do
				if v.type == 2 then
					for k2, v2 in pairs(_pChopping) do
						if v2 == k then
							TriggerClientEvent("Phone:Client:LSUnderground:Chopping:CancelCurrent", k2)
							_pChopping[k2] = nil
						end
					end
					_inProgress[k] = nil
					_chopped[k] = nil
				end
			end
			
			for k, v in pairs(Fetch:All()) do
				local c = v:GetData("Character")
				if c ~= nil then
					local dutyData = Jobs.Duty:Get(v:GetData("Source"))
					if hasValue(c:GetData("States") or {}, "ACCESS_LSUNDERGROUND") and (not dutyData or dutyData.Id ~= "police") then
						Phone.Notification:Add(
							v:GetData("Source"),
							"New Chop List",
							"A New Private Chop List Is Available",
							os.time() * 1000,
							10000,
							"lsunderground",
							{
								view = "",
							}
						)
					end
				end
			end
		else
			Chat.Send.System:Single(source, "Invalid Type")
		end
    end, {
        help = 'Generates New Chop List',
		params = {
			{
				name = "Type",
				help = "What List Type: public, private, all",
			},
		},
    }, 1)

	Callbacks:RegisterServerCallback("Phone:LSUnderground:Chopping:CheckVehicle", function(source, data, cb)
		local entState = Entity(NetworkGetEntityFromNetworkId(data.vNet)).state
		local model = GetEntityModel(ent)

		local list = Phone.LSUnderground.Chopping:FindList(source, data.vNet)
		local isInProg = Phone.LSUnderground.Chopping:InProgress(source, list?.type, model, list?.listId)

		if list ~= nil and not isInProg then
			_pChopping[source] = entState.VIN
			_inProgress[entState.VIN] = {
				source = source,
				type = list.type,
				listId = list.listId,
				model = GetEntityModel(NetworkGetEntityFromNetworkId(data.vNet)),
			}
			_chopped[entState.VIN] = {
				parts = {},
				tires = {},
				wheels = {},
				body = false,
			}
			cb(true)
		else
			if isInProg then
				Execute:Client(source, "Notification", "Error", "Vehicle Already Being Chopped")
			end
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Phone:LSUnderground:Chopping:ChopPart", function(source, data, cb)
		if data?.index ~= nil then
			local plyr = Fetch:Source(source)
			local pState = Player(source).state
			local ent = NetworkGetEntityFromNetworkId(data.vNet)
			local entState = Entity(ent).state
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if not entState.Owned then
						local list = Phone.LSUnderground.Chopping:FindList(source, data.vNet)
						if list ~= nil then
							if not _chopped[entState.VIN].parts[data.index] then
								_chopped[entState.VIN].parts[data.index] = true

								local repLevel = Reputation:GetLevel(source, "Chopping") or 0
								local calcLvl = repLevel
								if calcLvl < 1 then calcLvl = 1 end
								calcLvl = math.ceil(calcLvl / 2)
								Loot:CustomWeightedSetWithCountAndModifier(_lootTables.materials, char:GetData("SID"), 1, calcLvl)
								Loot:CustomWeightedSetWithCountAndModifier(_lootTables.materials, char:GetData("SID"), 1, calcLvl)
							end
							SetVehicleDoorBroken(NetworkGetEntityFromNetworkId(data.vNet), data.index, true)
							return cb(true)
						end
					end
				end
			end
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Phone:LSUnderground:Chopping:ChopTire", function(source, data, cb)
		if data?.index ~= nil then
			local plyr = Fetch:Source(source)
			local pState = Player(source).state
			local entState = Entity(NetworkGetEntityFromNetworkId(data.vNet)).state
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if not entState.Owned then
						local list = Phone.LSUnderground.Chopping:FindList(source, data.vNet)
						if list ~= nil then
							if not _chopped[entState.VIN].tires[data.index] then
								_chopped[entState.VIN].tires[data.index] = true

								local repLevel = Reputation:GetLevel(source, "Chopping") or 0
								local calcLvl = repLevel
								if calcLvl < 1 then calcLvl = 1 end
								calcLvl = math.ceil(calcLvl / 2)
								Loot:CustomWeightedSetWithCountAndModifier(_lootTables.materials, char:GetData("SID"), 1, calcLvl)
								Inventory:AddItem(char:GetData("SID"), 'rubber', math.random(12, 78) * calcLvl, {}, 1)
							end
							return cb(true)
						end
					end
				end
			end
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Phone:LSUnderground:Chopping:ChopWheel", function(source, data, cb)
		if data?.index ~= nil then
			local plyr = Fetch:Source(source)
			local pState = Player(source).state
			local entState = Entity(NetworkGetEntityFromNetworkId(data.vNet)).state
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if not entState.Owned then
						local list = Phone.LSUnderground.Chopping:FindList(source, data.vNet)
						if list ~= nil then
							if not _chopped[entState.VIN].wheels[data.index] then
								_chopped[entState.VIN].wheels[data.index] = true

								local repLevel = Reputation:GetLevel(source, "Chopping") or 0
								local calcLvl = repLevel
								if calcLvl < 1 then calcLvl = 1 end
								calcLvl = math.ceil(calcLvl / 2)
								Loot:CustomWeightedSetWithCountAndModifier(_lootTables.materials, char:GetData("SID"), 1, calcLvl)
								Inventory:AddItem(char:GetData("SID"), 'rubber', math.random(12, 78) * calcLvl, {}, 1)
							end
							return cb(true)
						end
					end
				end
			end
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Phone:LSUnderground:Chopping:ChopVehicle", function(source, data, cb)
		local plyr = Fetch:Source(source)
		local pState = Player(source).state
		local entState = Entity(NetworkGetEntityFromNetworkId(data.vNet)).state
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if not entState.Owned then
					local list = Phone.LSUnderground.Chopping:FindList(source, data.vNet)
					if list ~= nil or _inProgress[entState.VIN] ~= nil then
						if not _chopped[entState.VIN]?.body then
							_chopped[entState.VIN].body = true

							local repLevel = Reputation:GetLevel(source, "Chopping") or 0
							local calcLvl = repLevel
							if calcLvl < 1 then calcLvl = 1 end
							calcLvl = math.ceil(calcLvl / 2)

							Loot:CustomWeightedSetWithCountAndModifier(_lootTables.materials, char:GetData("SID"), 1, calcLvl)
							Loot:CustomWeightedSetWithCountAndModifier(_lootTables.materials, char:GetData("SID"), 1, calcLvl)
							Loot:CustomWeightedSetWithCountAndModifier(_lootTables.materials, char:GetData("SID"), 1, calcLvl)
							Loot:CustomWeightedSetWithCount(_lootTables.parts, char:GetData("SID"), 1)

							if list?.entry?.hv then
								Loot:CustomWeightedSetWithCount(_lootTables.parts, char:GetData("SID"), 1)
								if list.type == 3 then
									Crypto.Exchange:Add("VRM", char:GetData("CryptoWallet"), math.random(5, 10))
								else
									Crypto.Exchange:Add("PLEB", char:GetData("CryptoWallet"), math.random(8, 14))
								end
								Wallet:Modify(source, math.random(500) + 500)
							else
								if list.type == 3 then
									Crypto.Exchange:Add("VRM", char:GetData("CryptoWallet"), math.random(2, 6))
								else
									Crypto.Exchange:Add("PLEB", char:GetData("CryptoWallet"), math.random(4, 7))
								end
								Wallet:Modify(source, math.random(200) + 200)
							end

							Reputation.Modify:Add(source, "Chopping", 250 * list.type)
							Phone.LSUnderground.Chopping:CreatePickupBox(source, list?.entry?.hv or false, list.type)

							SetTimeout(1000 * math.random(20, 60), function()
								Phone.Email:Send(
									source,
									"shadow@ls.undg",
									os.time() * 1000,
									"Recent Work",
									string.format(
										[[
												Good Work %s<br /><br />
												Some of my guys were able to get some more materials and parts out of that car, I've left those materials & parts in a package with the salvaging foreman.<br /><br />
												Goodluck with your future endeavors
											]],
										char:GetData("First")
									)
								)
							end)

							_pChopping[source] = nil
							Phone.LSUnderground.Chopping:RemoveFromList(
								source,
								list ~= nil and list?.type or _inProgress[entState.VIN]?.type,
								GetEntityModel(NetworkGetEntityFromNetworkId(data.vNet)),
								list ~= nil and list?.listId or _inProgress[entState.VIN]?.listId
							)
						end

						local veh = NetworkGetEntityFromNetworkId(data.vNet)
						local entState = Entity(veh).state
						_inProgress[entState.VIN] = nil
						Vehicles:Delete(veh, function() end)

						return cb(true)
					end
				end
			end
		end

		cb(false)
	end)

	Callbacks:RegisterServerCallback("Phone:LSUnderground:Chopping:CancelChop", function(source, data, cb)
		if _pChopping[source] ~= nil then
			_inProgress[_pChopping[source]] = nil
			_pChopping[source] = nil
		end
	end)

	Callbacks:RegisterServerCallback("Phone:LSUnderground:Chopping:Pickup", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local pickups = char:GetData("ChopPickups") or {}

		if #pickups > 0 then
			for k, v in ipairs(pickups) do
				Inventory:AddItem(char:GetData("SID"), "parts_box", 1, {
					Items = v.Items,
				}, 1)
			end
			char:SetData("ChopPickups", {})
		else
			Execute:Client(source, "Notification", "Error", "You Have Nothing To Pickup")
		end
	end)

	Callbacks:RegisterServerCallback("Phone:LSUnderground:Chopping:GetPublicList", function(source, data, cb)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if not _emailed[char:GetData("ID")] or os.time() > _emailed[char:GetData("ID")] then
					_emailed[char:GetData("ID")] = os.time() + (60 * 10)

					local str = [[
						Hello %s<br /><br />
						Here is the current outstanding public requests.<br /><br />
						Requested Vehicles:
						<ul>
					]]

					for k, v in ipairs(_publicChoplist.list) do
						if v.hv then
							str = str .. string.format("<li>(HIGHVALUE) %s</li>", v.name)
						else
							str = str .. string.format("<li>%s</li>", v.name)
						end
					end

					Phone.Email:Send(
						source,
						"shadow@ls.undg",
						os.time() * 1000,
						"Oustanding Public Requests",
						string.format(str, char:GetData("First")),
						{
							expires = (os.time() + (60 * 20)) * 1000,
						}
					)

					if char:GetData("ChopLists") ~= nil and #char:GetData("ChopLists") > 0 then
						local str = [[
							Hello %s<br /><br />
							Here is the current outstanding personal shopping lists you have.
						]]
						for k, v in pairs(char:GetData("ChopLists")) do
							str = str .. [[<br /><br />Requested Vehicles:<ul>]]

							for k, v in ipairs(v) do
								if v.hv then
									str = str .. string.format("<li>(HIGHVALUE) %s</li>", v.name)
								else
									str = str .. string.format("<li>%s</li>", v.name)
								end
							end

							str = str .. [[</ul>]]
						end

						Phone.Email:Send(
							source,
							"shadow@ls.undg",
							os.time() * 1000,
							"Oustanding Personal Requests",
							string.format(str, char:GetData("First"))
						)
					end
				else
					Execute:Client(source, "Notification", "Error", "Recently Requested Active Chop Lists")
				end
			end
		end
	end)

	Inventory.Items:RegisterUse("choplist", "Chopping", function(source, item, itemData)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
					local personalLists = char:GetData("ChopLists") or {}
					personalLists[Sequence:Get("PersonalChopList")] = item.MetaData.ChopList
					char:SetData("ChopLists", personalLists)

					if hasValue(char:GetData("States") or {}, "ACCESS_LSUNDERGROUND") then
						Phone.Notification:Add(
							source,
							"New Personal Choplist",
							"You've Received A New Persoanl Choplist",
							os.time() * 1000,
							7500,
							"lsunderground",
							{}
						)
					else
						local str = [[
							Hello %s<br /><br />
							We've got a new chop list setup that's just for you, these requests can only be fullfilled by you by also means everything from these requests are all yours aswell.<br /><br />
							Requested Vehicles:
							<ul>
						]]

						for k, v in ipairs(item.MetaData.ChopList) do
							if v.hv then
								str = str .. string.format("<li>(HIGHVALUE) %s</li>", v.name)
							else
								str = str .. string.format("<li>%s</li>", v.name)
							end
						end

						str = str .. "</ul>"

						Phone.Email:Send(
							source,
							"shadow@ls.undg",
							os.time() * 1000,
							"Recent Work",
							string.format(str, char:GetData("First"))
						)
					end
				end
			end
		end
	end)
end)

function TableLength(tbl)
	local cnt = 0
	for k, v in pairs(tbl) do
		cnt += 1
	end
	return cnt
end

PHONE.LSUnderground = PHONE.LSUnderground or {}
PHONE.LSUnderground.Chopping = {
	GenerateList = function(self, length, hvCount)
		local _l = {}

		if length <= 0 then
			length = 1
		end

		for i = 1, length do
			local ind = math.random(#_models.Normal)
			while _l[_models.Normal[ind]] ~= nil do
				ind = math.random(#_models.Normal)
			end

			_l[_models.Normal[ind]] = {
				model = _models.Normal[ind].model,
				name = _models.Normal[ind].name,
				hv = false,
			}
		end

		if hvCount > 0 then
			for i = 1, hvCount do
				local ind = math.random(#_models.Priority)
				while _l[_models.Priority[ind]] ~= nil do
					ind = math.random(#_models.Priority)
				end
	
				_l[_models.Priority[ind]] = {
					model = _models.Priority[ind].model,
					name = _models.Priority[ind].name,
					hv = true,
				}
			end
		end

		local t = {}
		for k, v in pairs(_l) do
			table.insert(t, v)
		end
		return t
	end,
	InProgress = function(self, source, type, model, listId)
		if type == nil or type == 3 and listId == nil then return false end

		if type == 1 or type == 2 then
			for k, v in pairs(_inProgress) do
				if v.type == type and v.model == model and v.source ~= source then
					Execute:Client(source, "Notification", "Error", "Vehicle Type Is Already Being Chopped")
					return true
				end
			end
		elseif type == 3 then
			for k, v in pairs(_inProgress) do
				if v.type == type and v.model == model and v.source ~= source and v.listId == listId then
					Execute:Client(source, "Notification", "Error", "Vehicle Type Is Already Being Chopped")
					return true
				end
			end
		end

		return false
	end,
	FindList = function(self, source, vehNet)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local pState = Player(source).state
				local ent = NetworkGetEntityFromNetworkId(vehNet)
				if ent ~= nil then
					local model = GetEntityModel(ent)
					if pState.inChopZone == "chopping_public" and Reputation:GetLevel(source, "Salvaging") >= 3 then
						local chopEntry = Phone.LSUnderground.Chopping:IsOnList(_publicChoplist.list, model)
						if not chopEntry then
							Execute:Client(source, "Notification", "Error", "Vehicle Not On Chop List")
							return nil
						elseif Phone.LSUnderground.Chopping:InProgress(source, 1, model) then
							return nil
						else
							return { entry = chopEntry, type = 1, model = model }
						end
					elseif
						pState.inChopZone == "chopping_private"
						and hasValue(char:GetData("States") or {}, "ACCESS_LSUNDERGROUND")
					then
						local chopEntry = Phone.LSUnderground.Chopping:IsOnList(_vipChopList.list, model)
						if not chopEntry then
							Execute:Client(source, "Notification", "Error", "Vehicle Not On Chop List")
							return nil
						elseif Phone.LSUnderground.Chopping:InProgress(source, 2, model) then
							return nil
						else
							return { entry = chopEntry, type = 2, model = model }
						end
					elseif
						pState.inChopZone == "chopping_personal"
						and (char:GetData("ChopLists") ~= nil and TableLength(char:GetData("ChopLists")) > 0)
					then
						local personallists = char:GetData("ChopLists")
						for k, v in pairs(personallists) do
							local chopEntry = Phone.LSUnderground.Chopping:IsOnList(v, model)
							if chopEntry ~= nil and chopEntry then
								return { listId = k, entry = chopEntry, type = 3, model = model }
							end
						end

						Execute:Client(source, "Notification", "Error", "Vehicle Not On Chop List")
						return nil
					else
						Execute:Client(source, "Notification", "Error", "Not In A Valid Dropoff Location")
						return nil
					end
				else
					Execute:Client(source, "Notification", "Error", "Invalid Entity")
					return nil
				end
			end
		end
	end,
	IsOnList = function(self, list, model)
		for k, v in ipairs(list) do
			if v.model == model then
				return v
			end
		end
		return false
	end,
	RemoveFromList = function(self, source, type, model, listId)
		if type == 1 then
			for k, v in ipairs(_publicChoplist.list) do
				if v.model == model then
					table.remove(_publicChoplist.list, k)

					if #_publicChoplist.list <= 0 then
						Logger:Trace("Chopping", "Generating New Public Chop List")
						_publicChoplist = {
							list = Phone.LSUnderground.Chopping:GenerateList(10, 2),
							public = true,
						}
			
						for k, v in pairs(_inProgress) do
							if v.type == 1 then
								for k2, v2 in pairs(_pChopping) do
									if v2 == k then
										TriggerClientEvent("Phone:Client:LSUnderground:Chopping:CancelCurrent", k2)
										_pChopping[k2] = nil
									end
								end
								_inProgress[k] = nil
								_chopped[k] = nil
							end
						end
						
						for k, v in pairs(Fetch:All()) do
							local c = v:GetData("Character")
							if c ~= nil then
								local dutyData = Jobs.Duty:Get(v:GetData("Source"))
								if hasValue(c:GetData("States") or {}, "ACCESS_LSUNDERGROUND") and (not dutyData or dutyData.Id ~= "police") then
									Phone.Notification:Add(
										v:GetData("Source"),
										"New Chop List",
										"A New Public Chop List Is Available",
										os.time() * 1000,
										10000,
										"lsunderground",
										{
											view = "",
										}
									)
								end
							end
						end
					end

					return true
				end
			end
		elseif type == 2 then
			for k, v in ipairs(_vipChopList.list) do
				if v.model == model then
					table.remove(_vipChopList.list, k)

					if #_vipChopList.list <= 0 then
						Logger:Trace("Chopping", "Generating New VIP Chop List")
						_vipChopList = {
							list = Phone.LSUnderground.Chopping:GenerateList(10, 4),
							public = true,
						}
			
						for k, v in pairs(_inProgress) do
							if v.type == 2 then
								for k2, v2 in pairs(_pChopping) do
									if v2 == k then
										TriggerClientEvent("Phone:Client:LSUnderground:Chopping:CancelCurrent", k2)
										_pChopping[k2] = nil
									end
								end
								_inProgress[k] = nil
								_chopped[k] = nil
							end
						end
						
						for k, v in pairs(Fetch:All()) do
							local c = v:GetData("Character")
							if c ~= nil then
								local dutyData = Jobs.Duty:Get(v:GetData("Source"))
								if hasValue(c:GetData("States") or {}, "ACCESS_LSUNDERGROUND") and (not dutyData or dutyData.Id ~= "police") then
									Phone.Notification:Add(
										v:GetData("Source"),
										"New Chop List",
										"A New Private Chop List Is Available",
										os.time() * 1000,
										10000,
										"lsunderground",
										{
											view = "",
										}
									)
								end
							end
						end
					end

					return true
				end
			end
		elseif type == 3 then
			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					local mylists = char:GetData("ChopLists")
					if mylists ~= nil and mylists[listId] ~= nil then
						local found = false
						for k, v in pairs(mylists[listId]) do
							if v.model == model then
								table.remove(mylists[listId], k)

								if #mylists[listId] <= 0 then
									mylists[listId] = nil
								end

								char:SetData("ChopLists", mylists)
								found = true
								break
							end
						end

						return found
					end
				end
			end
		end

		return false
	end,
	CreatePickupBox = function(self, source, wasHv, type)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local pickups = char:GetData("ChopPickups") or {}

				local repLevel = Reputation:GetLevel(source, "Chopping") or 0
				local calcLvl = repLevel
				if calcLvl < 1 then calcLvl = 1 end
				calcLvl = math.ceil(calcLvl / 2)
				
				local items = {
					Loot:CustomWeightedSetWithCountAndModifier(_boxTables.materials, char:GetData("SID"), 1, calcLvl, true),
					Loot:CustomWeightedSetWithCountAndModifier(_boxTables.materials, char:GetData("SID"), 1, calcLvl, true),
					Loot:CustomWeightedSetWithCountAndModifier(_boxTables.materials, char:GetData("SID"), 1, calcLvl, true),
					Loot:CustomWeightedSetWithCountAndModifier(_boxTables.materials, char:GetData("SID"), 1, calcLvl, true),
					Loot:CustomWeightedSetWithCount(_boxTables.parts, char:GetData("SID"), 1, true),
				}

				if wasHv then
					table.insert(
						items,
						Loot:CustomWeightedSetWithCount(_boxTables.materials, char:GetData("SID"), 1, true)
					)
					table.insert(
						items,
						Loot:CustomWeightedSetWithCount(_boxTables.materials, char:GetData("SID"), 1, true)
					)
					table.insert(
						items,
						Loot:CustomWeightedSetWithCount(_boxTables.materials, char:GetData("SID"), 1, true)
					)
					table.insert(items, Loot:CustomWeightedSetWithCount(_boxTables.parts, char:GetData("SID"), 1, true))
				end

				local repLevel = Reputation:GetLevel(source, "Chopping") or 0
				if repLevel >= 4 then
					table.insert(
						items,
						Loot:CustomWeightedSetWithCount(_boxTables.partsHG, char:GetData("SID"), 1, true)
					)
					if repLevel >= 5 then
						table.insert(
							items,
							Loot:CustomWeightedSetWithCount(_boxTables.partsHG, char:GetData("SID"), 1, true)
						)
					end
				end
				table.insert(pickups, {
					Items = items,
				})
				char:SetData("ChopPickups", pickups)
			end
		end
	end,
}
