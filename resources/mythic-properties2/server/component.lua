AddEventHandler("Properties:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Database = exports["mythic-base"]:FetchComponent("Database")
	Default = exports["mythic-base"]:FetchComponent("Default")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Routing = exports["mythic-base"]:FetchComponent("Routing")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Police = exports["mythic-base"]:FetchComponent("Police")
	Crafting = exports["mythic-base"]:FetchComponent("Crafting")
	Pwnzor = exports["mythic-base"]:FetchComponent("Pwnzor")
	Banking = exports["mythic-base"]:FetchComponent("Banking")
	Loans = exports["mythic-base"]:FetchComponent("Loans")
	Billing = exports["mythic-base"]:FetchComponent("Billing")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	RegisterChatCommands()
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Properties", {
		"Callbacks",
		"Middleware",
		"Logger",
		"Fetch",
		"Database",
		"Default",
		"Chat",
		"Properties",
		"Routing",
		"Phone",
		"Jobs",
		"Inventory",
		"Police",
		"Crafting",
		"Pwnzor",
		"Banking",
		"Loans",
		"Billing",
		"Utils",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		RegisterMiddleware()
		DefaultData()
		Startup()

		CreateFurnitureCallbacks()

		SetupPropertyCrafting()
	end)
end)


PROPERTIES = {
	Manage = {
		Add = function(self, source, type, interior, price, label, pos)
			if PropertyTypes[type] then
				if PropertyInteriors[interior] and PropertyInteriors[interior].type == type then
					local p = promise.new()
					local doc = {
						type = type,
						label = label,
						price = price,
						sold = false,
						owner = false,
						location = {
							front = pos,
						},
						upgrades = {
							interior = interior,
						}
					}
	
					Database.Game:insertOne({
						collection = "properties",
						document = doc,
					}, function(success, result, insertedIds)
						if success then
							doc.id = insertedIds[1]
							doc.interior = interior
							doc.locked = true
	
							for k, v in pairs(doc.location) do
								for k2, v2 in pairs(v) do
									doc.location[k][k2] = doc.location[k][k2] + 0.0
								end
							end
	
							_properties[doc.id] = doc
	
							Chat.Send.Server:Single(source, "Property Added, Property ID: " .. doc.id)
	
							TriggerClientEvent("Properties:Client:Update", -1, doc.id, doc)
						end
	
						p:resolve(success)
					end)
					return Citizen.Await(p)
				else
					Chat.Send.Server:Single(source, "Invalid Interior Combination")
					return false
				end
			else
				Chat.Send.Server:Single(source, "Invalid Property Type")
				return false
			end
		end,
		AddFrontdoor = function(self, id, pos)
			if not _properties[id] or not pos then
				return false
			end

			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						['location.front'] = pos,
					},
				},
			}, function(success, results)
				if success then
					if _properties[id] and _properties[id].location then
						_properties[id].location.front = pos

						TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
					end
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		AddBackdoor = function(self, id, pos)
			if not _properties[id] or not pos then
				return false
			end

			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						['location.backdoor'] = pos,
					},
				},
			}, function(success, results)
				if success then
					if _properties[id] and _properties[id].location then
						_properties[id].location.backdoor = pos

						TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
					end
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		AddGarage = function(self, id, pos)
			if not _properties[id] or pos == nil then
				return false
			end

			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						['location.garage'] = pos,
					},
				},
			}, function(success, results)
				if success then
					if _properties[id] and _properties[id].location then
						_properties[id].location.garage = pos

						TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
					end
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		SetLabel = function(self, id, label)
			if not _properties[id] or not label then
				return false
			end

			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						label = label,
					},
				},
			}, function(success, results)
				if success then
					if _properties[id] and _properties[id].label then
						_properties[id].label = label

						TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
					end
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		SetPrice = function(self, id, price)
			if not _properties[id] or not price then
				return false
			end

			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						price = price,
					},
				},
			}, function(success, results)
				if success then
					if _properties[id] and _properties[id].price then
						_properties[id].price = price

						TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
					end
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		SetData = function(self, id, key, value)
			if not key or not _properties[id] then
				return false
			end

			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						[string.format('data.%s', key)] = value,
					},
				},
			}, function(success, results)
				if success then
					if _properties[id] then
						if not _properties[id].data then _properties[id].data = {} end
						_properties[id].data[key] = value

						TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
					end
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		Delete = function(self, id)
			local p = promise.new()
			Database.Game:deleteOne({
				collection = "properties",
				query = {
					_id = id,
				},
			}, function(success, result)
				if success then
					_properties[id] = nil

					TriggerClientEvent("Properties:Client:Update", -1, id, nil)
				end
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
	},
	Upgrades = {
		Set = function(self, id, upgrade, level)
			local property = _properties[id]
			if property then
				local upgradeData = PropertyUpgrades[property.type][upgrade]
				if upgradeData and upgrade ~= "interior" then

					if level < 1 then
						level = 1
					end

					if level > #upgradeData.levels then
						level = #upgradeData.levels
					end

					local p = promise.new()
					Database.Game:updateOne({
						collection = "properties",
						query = {
							_id = id,
						},
						update = {
							["$set"] = {
								[string.format('upgrades.%s', upgrade)] = level,
							},
						},
					}, function(success, results)
						if success then
							if _properties[id] then
								if not _properties[id].upgrades then _properties[id].upgrades = {} end
								_properties[id].upgrades[upgrade] = level

								TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
							end
						end

						p:resolve(success)
					end)
					return Citizen.Await(p)
				end
			end

			return false
		end,
		Get = function(self, id, upgrade)
			local property = _properties[id]
			if property and property.upgrades and property.upgrades[upgrade] then
				return property.upgrades[upgrade]
			end
			return 1
		end,
		Increase = function(self, id, upgrade)
			local property = _properties[id]
			if property then
				local currentLevel = Properties.Upgrades:Get(id, upgrade)
				local success = Properties.Upgrades:Set(id, upgrade, currentLevel + 1)

				return success
			end
			return false
		end,
		Decrease = function(self, id, upgrade)
			local property = _properties[id]
			if property then
				local currentLevel = Properties.Upgrades:Get(id, upgrade)
				local success = Properties.Upgrades:Set(id, upgrade, currentLevel - 1)

				return success
			end
			return false
		end,
		SetInterior = function(self, id, interior)
			local property = _properties[id]
			if property then
				local intData = PropertyInteriors[interior]

				if intData and intData.type == property.type then
					local p = promise.new()
					Database.Game:updateOne({
						collection = "properties",
						query = {
							_id = id,
						},
						update = {
							["$set"] = {
								["upgrades.interior"] = interior,
							},
						},
					}, function(success, results)
						if success then
							if _properties[id] then
								if not _properties[id].upgrades then _properties[id].upgrades = {} end
								_properties[id].upgrades["interior"] = interior

								TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
							end
						end

						p:resolve(success)
					end)
					return Citizen.Await(p)
				end
			end
		end,
	},
	Commerce = {
		Sell = function(self, id)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						sold = false,
						owner = false,
					},
					["$unset"] = {
						keys = true,
					},
				},
			}, function(success, results)
				if success and _properties[id] then
					_properties[id].sold = false

					if _properties[id].keys then
						for k, v in pairs(_properties[id].keys) do
							local t = GlobalState[string.format("Char:Properties:%s", v.Char)]
							if t ~= nil then
								for k2, v2 in ipairs(t) do
									if v2 == id then
										table.remove(t, k2)
										GlobalState[string.format("Char:Properties:%s", v.Char)] = t
										break
									end
								end
							end
						end
					end

					_properties[id].keys = nil
					TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
				end
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		Buy = function(self, id, owner, payment)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						soldAt = os.time(),
						sold = true,
						owner = owner,
						keys = {
							[owner.Char] = owner,
						},
					},
				},
			}, function(success, results)
				if success then
					_properties[id].sold = true
					_properties[id].keys = {
						[owner.Char] = owner,
					}
					_properties[id].soldAt = os.time()

					table.insert(GlobalState[string.format("Char:Properties:%s", owner.Char)], propertyId)

					TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
				end
				p:resolve(success)
			end)

			return Citizen.Await(p)
		end,
		Foreclose = function(self, id, state)
			if not _properties[propertyId] and state ~= nil then
				return false
			end

			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						foreclosed = state,
						foreclosedTime = state and os.time() or false,
					},
				},
			}, function(success, results)
				if success then
					if _properties[id] then
						_properties[id].foreclosed = state

						TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])
					end
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
	},
	Utils = {
		IsNearProperty = function(self, source)
			local myPos = GetEntityCoords(GetPlayerPed(source))
			local closest = nil
			for k, v in pairs(_properties) do
				local dist = #(myPos - vector3(v.location.front.x, v.location.front.y, v.location.front.z))
				if dist < 3.0 and (not closest or dist < closest.dist) then
					closest = {
						dist = dist,
						propertyId = v.id,
					}
				end
			end
			return closest
		end,
		SetLock = function(self, id, locked)
			if _properties[id] then
				_properties[id].locked = locked
				TriggerClientEvent("Properties:Client:SetLocks", -1, id, _properties[id].locked)
				return true
			else
				return false
			end
		end,
		ToggleLock = function(self, id)
			if _properties[id] then
				_properties[id].locked = not _properties[id].locked
				TriggerClientEvent("Properties:Client:SetLocks", -1, id, _properties[id].locked)
				return true
			else
				return false
			end
		end,
	},
	Keys = {
		Give = function(self, charData, id, isOwner, permissions, updating)
			local p = promise.new()

			Database.Game:findOneAndUpdate({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						[string.format("keys.%s", charData.ID)] = {
							Char = charData.ID,
							First = charData.First,
							Last = charData.Last,
							SID = charData.SID,
							Owner = isOwner,
							Permissions = permissions,
						},
					},
				},
				options = {
					returnDocument = 'after',
				},
			}, function(success, result)
				if success then
					_properties[id] = doPropertyThings(result)

					TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])

					if not updating then
						if GlobalState[string.format("Char:Properties:%s", charData.ID)] ~= nil then
							local t = GlobalState[string.format("Char:Properties:%s", charData.ID)]
							table.insert(t, id)
							GlobalState[string.format("Char:Properties:%s", charData.ID)] = t
						else
							GlobalState[string.format("Char:Properties:%s", charData.ID)] = {
								id,
							}
						end
					end
				end
				p:resolve(success)

				if charData.Source then
					TriggerClientEvent("Properties:Client:AddBlips", charData.Source)
				end
			end)

			return Citizen.Await(p)
		end,
		Take = function(self, target, id)
			local p = promise.new()

			Database.Game:findOneAndUpdate({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$unset"] = {
						[string.format("keys.%s", target)] = true,
					},
				},
				options = {
					returnDocument = 'after',
				},
			}, function(success, result)
				if success then
					_properties[id] = doPropertyThings(result)

					TriggerClientEvent("Properties:Client:Update", -1, id, _properties[id])

					local t = GlobalState[string.format("Char:Properties:%s", target)]
					if t ~= nil then
						for k, v in ipairs(t) do
							if v == id then
								table.remove(t, k)
								break
							end
						end

						GlobalState[string.format("Char:Properties:%s", target)] = t
					end
				end
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		Has = function(self, id, charId)
			if _properties[id] and _properties[id].keys ~= nil then
				return _properties[id].keys[charId]
			end
			return false
		end,
		HasBySID = function(self, id, stateId)
			if _properties[id] and _properties[id].keys ~= nil then
				for k, v in pairs(_properties[id].keys) do
					if v.SID == stateId then
						return true
					end
				end
			end
			return false
		end,
		HasAccessWithData = function(self, source, key, value) -- Has Access to a Property with a specific data/key value
			local char = Fetch:Source(source):GetData("Character")
			if char then
				local propertyKeys = GlobalState[string.format("Char:Properties:%s", char:GetData("ID"))]

				for _, propertyId in ipairs(propertyKeys) do
					local property = _properties[propertyId]
					if property and property.data and ((value == nil and property.data[key]) or property.data[key] == value) then
						return property.id
					end
				end
			end
			return false
		end,
	},
	Get = function(self, propertyId)
		return _properties[propertyId]
	end,
	ForceEveryoneLeave = function(self, propertyId)
		local property = _properties[propertyId]
		if property then
			if _insideProperties[property.id] then
				for k, v in pairs(_insideProperties[property.id]) do
					TriggerClientEvent("Properties:Client:ForceExitProperty", k, property.id)
				end
			end
		end
	end,
	GetMaxParkingSpaces = function(self, propertyId)
		local property = _properties[propertyId]
		if property then
			local garageLevel = property?.upgrades?.garage or 1

			if garageLevel and garageLevel >= 1 and PropertyGarage[property.type] and PropertyGarage[property.type][garageLevel] then
				return PropertyGarage[property.type][garageLevel].parking
			end
		end
	end
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Properties", PROPERTIES)
end)
