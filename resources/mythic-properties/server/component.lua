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
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()
		RegisterCallbacks()
		DefaultData()
		Startup()
		RegisterSpawnFunction()

		SetupPropertyCrafting()
	end)
end)

function RegisterSpawnFunction()
	Middleware:Add("Characters:Logout", function(source)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			GlobalState[string.format("Char:Properties:%s", charId)] = nil
		end
		TriggerClientEvent("Properties:Client:Cleanup", source, GlobalState[string.format("%s:Property", source)])
		GlobalState[string.format("%s:Property", source)] = nil

		if Player(source)?.state?.tpLocation then
			Player(source).state.tpLocation = nil
		end
	end)
	Middleware:Add("Characters:GetSpawnPoints", function(source, charId)
		local p = promise.new()

		Database.Game:find({
			collection = "properties",
			query = {
				[string.format("keys.%s", charId)] = {
					["$exists"] = true,
				},
				foreclosed = {
					["$ne"] = true,
				},
				type = {
					["$nin"] = {
						"container",
						"warehouse",
					}
				}
			},
		}, function(success, results)
			if not success or not #results then
				p:resolve({})
				return
			end
			local spawns = {}

			local keys = {}

			for k, v in pairs(results) do
				table.insert(keys, v._id)
				local property = GlobalState[string.format("Property:%s", v._id)]
				if property ~= nil then
					local prop = GlobalState[string.format("Properties:Interior:%s", property.interior)]
					local icon = "house"
					if prop.type == "warehouse" then
						icon = "warehouse"
					elseif prop.type == "office" then
						icon = "building"
					end

					if prop ~= nil then
						table.insert(spawns, {
							id = property.id,
							label = property.label,
							location = {
								x = prop.x,
								y = prop.y,
								z = prop.z,
								h = prop.h,
							},
							icon = icon,
							event = "Properties:SpawnInside",
						})
					end
				end
			end
			GlobalState[string.format("Char:Properties:%s", charId)] = keys
			p:resolve(spawns)
		end)

		return Citizen.Await(p)
	end, 3)
end

PROPERTIES = {
	Manage = {
		Add = function(self, source, type, interior, price, label, pos)
			if PropertyTypes[type] then
				local p = promise.new()
				local doc = {
					type = type,
					label = label,
					price = price,
					sold = false,
					owner = false,
					interior = interior,
					location = {
						front = pos,
					},
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

						table.insert(_props, doc.id)
						GlobalState["Properties"] = _props
						GlobalState[string.format("Property:%s", doc.id)] = doc
	
						while GlobalState[string.format("Property:%s", doc.id)] == nil do
							Citizen.Wait(5)
						end
	
						Chat.Send.Server:Single(source, "Property Added, Property ID: " .. doc.id)
						TriggerClientEvent("Properties:Client:Add", -1, doc.id)
					end
	
					p:resolve(success)
				end)
				return Citizen.Await(p)
			else
				Chat.Send.Server:Single(source, "Invalid Property Type")
				return false
			end
		end,
		AddFrontdoor = function(self, id, pos)
			if not GlobalState[string.format("Property:%s", id)] or not pos then
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
					local p = GlobalState[string.format("Property:%s", id)]
					if p and p.location then
						p.location.front = pos
					end
					GlobalState[string.format("Property:%s", id)] = p
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		AddBackdoor = function(self, id, pos)
			if not GlobalState[string.format("Property:%s", id)] or not pos then
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
					local p = GlobalState[string.format("Property:%s", id)]
					if p and p.location then
						p.location.backdoor = pos
					end
					GlobalState[string.format("Property:%s", id)] = p
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		AddGarage = function(self, id, pos)
			if not GlobalState[string.format("Property:%s", id)] or pos == nil then
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
					local p = GlobalState[string.format("Property:%s", id)]
					if p and p.location then
						p.location.garage = pos
					end
					GlobalState[string.format("Property:%s", id)] = p
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		SetInterior = function(self, id, interior)
			if not GlobalState[string.format("Property:%s", id)] or not interior then
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
						interior = interior,
					},
				},
			}, function(success, results)
				if success then
					local p = GlobalState[string.format("Property:%s", id)]
					if p and p.interior then
						p.interior = interior
					end
					GlobalState[string.format("Property:%s", id)] = p
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		SetLabel = function(self, id, label)
			if not GlobalState[string.format("Property:%s", id)] or not label then
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
					local p = GlobalState[string.format("Property:%s", id)]
					if p and p.label then
						p.label = label
					end
					GlobalState[string.format("Property:%s", id)] = p
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		SetPrice = function(self, id, price)
			if not GlobalState[string.format("Property:%s", id)] or not price then
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
					local p = GlobalState[string.format("Property:%s", id)]
					if p and p.price then
						p.price = price
					end
					GlobalState[string.format("Property:%s", id)] = p
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		SetData = function(self, id, key, value)
			if not key or not GlobalState[string.format("Property:%s", id)] then
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
					local p = GlobalState[string.format("Property:%s", id)]
					if p then
						if not p.data then p.data = {} end
						p.data[key] = value
					end
					GlobalState[string.format("Property:%s", id)] = p
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
					for k, v in ipairs(_props) do
						if v == id then
							table.remove(_props, k)
						end
					end

					GlobalState["Properties"] = _props
					GlobalState[string.format("Property:%s", id)] = nil
				end
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
	},
	Commerce = {
		Sell = function(self, propertyId)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = propertyId,
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
				if success then
					local p = GlobalState[string.format("Property:%s", propertyId)]
					p.sold = false

					if p.keys then
						for k, v in pairs(p.keys) do
							local t = GlobalState[string.format("Char:Properties:%s", v.Char)]
							if t ~= nil then
								for k2, v2 in ipairs(t) do
									if v2 == propertyId then
										table.remove(t, k2)
										GlobalState[string.format("Char:Properties:%s", v.Char)] = t
										break
									end
								end
							end
						end
					end

					p.keys = nil

					GlobalState[string.format("Property:%s", propertyId)] = p
				end
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		Buy = function(self, propertyId, owner, payment)
			local p = promise.new()
			Database.Game:updateOne({
				collection = "properties",
				query = {
					_id = propertyId,
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
					local p = GlobalState[string.format("Property:%s", propertyId)]
					p.sold = true
					p.keys = {
						[owner.Char] = owner,
					}
					p.soldAt = os.time()

					GlobalState[string.format("Property:%s", propertyId)] = p
					table.insert(GlobalState[string.format("Char:Properties:%s", owner.Char)], propertyId)
				end
				p:resolve(success)
			end)

			return Citizen.Await(p)
		end,
		Foreclose = function(self, id, state)
			if not GlobalState[string.format("Property:%s", id)] and state ~= nil then
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
					local p = GlobalState[string.format("Property:%s", id)]
					if p then
						p.foreclosed = state
					end
					GlobalState[string.format("Property:%s", id)] = p
				end

				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
	},
	Utils = {
		IsNearProperty = function(self, source)
			local mypos = GetEntityCoords(GetPlayerPed(source))

			if GlobalState["Properties"] == nil then
				return false
			else
				local closest = nil
				for k, v in ipairs(GlobalState["Properties"]) do
					local prop = GlobalState[string.format("Property:%s", v)]
					local dist = #(
							vector3(mypos.x, mypos.y, mypos.z)
							- vector3(prop.location.front.x, prop.location.front.y, prop.location.front.z)
						)
					if dist < 3.0 and (not closest or dist < closest.dist) then
						closest = {
							dist = dist,
							propertyId = prop.id,
						}
					end
				end
				return closest
			end
		end,
		GetConfig = function(self, interior)
			if interior then
				return PropertyConfig[interior]
			else
				return PropertyConfig
			end
		end,
		GetRandomHouseUpToTier = function(self, tier)
			local r = nil
			while r == nil do
				local rand = _props[math.random(#_props)]
				local prop = GlobalState[string.format("Property:%s", rand)]

				if prop.type == 'house' and tier >= prop.interior then
					r = rand
				end

				Citizen.Wait(1)
			end
			return r
		end,
		GetRandomHouseWithinTiers = function(self, low, high)
			local r = nil
			while r == nil do
				local rand = _props[math.random(#_props)]
				local prop = GlobalState[string.format("Property:%s", rand)]
				local giveUp = 0

				if prop.type == 'house' and (high >= prop.interior) and (prop.interior >= low) then
					if not prop.sold or giveUp >= 5 then
						r = rand
					else
						giveUp += 1
					end
				end

				Citizen.Wait(1)
			end
			return r
		end,
		SetLock = function(self, id, locked)
			local property = GlobalState[string.format("Property:%s", id)]
			if property ~= nil then
				property.locked = locked
				GlobalState[string.format("Property:%s", id)] = property
				return true
			else
				return false
			end
		end,
		ToggleLock = function(self, id)
			local property = GlobalState[string.format("Property:%s", id)]
			if property ~= nil then
				property.locked = not property.locked
				GlobalState[string.format("Property:%s", id)] = property
				return true
			else
				return false
			end
		end,
	},
	Keys = {
		Give = function(self, char, id, isOwner)
			local p = promise.new()

			Database.Game:findOneAndUpdate({
				collection = "properties",
				query = {
					_id = id,
				},
				update = {
					["$set"] = {
						[string.format("keys.%s", char:GetData("ID"))] = {
							Char = char:GetData("ID"),
							First = char:GetData("First"),
							Last = char:GetData("Last"),
							SID = char:GetData("SID"),
							Owner = isOwner,
						},
					},
				},
				options = {
					returnDocument = 'after',
				},
			}, function(success, result)
				if success then
					GlobalState[string.format("Property:%s", id)] = doPropertyThings(result)
					if GlobalState[string.format("Char:Properties:%s", char:GetData("ID"))] ~= nil then
						table.insert(GlobalState[string.format("Char:Properties:%s", char:GetData("ID"))], id)
					else
						GlobalState[string.format("Char:Properties:%s", char:GetData("ID"))] = {
							id,
						}
					end
				end
				p:resolve(success)
			end)

			TriggerClientEvent("Properties:Client:AddBlips", char:GetData('Source'))

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
					GlobalState[string.format("Property:%s", id)] = doPropertyThings(result)
					if GlobalState[string.format("Char:Properties:%s", target)] ~= nil then
						for k, v in ipairs(GlobalState[string.format("Char:Properties:%s", target)]) do
							if v == id then
								table.remove(GlobalState[string.format("Char:Properties:%s", target)], k)
								break
							end
						end
					end
				end
				p:resolve(success)
			end)
			return Citizen.Await(p)
		end,
		Has = function(self, propId, charId)
			local property = GlobalState[string.format("Property:%s", propId)]

			if property and property.keys ~= nil then
				return property.keys[charId]
			end
			return false
		end,
		HasBySID = function(self, propId, stateId)
			local property = GlobalState[string.format("Property:%s", propId)]

			if property and property.keys ~= nil then
				for k, v in pairs(property.keys) do
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
					local property = GlobalState[string.format("Property:%s", propertyId)]
					if property and property.data and ((value == nil and property.data[key]) or property.data[key] == value) then
						return property.id
					end
				end
			end
			return false
		end,
	},
	Get = function(self, propertyId)
		return GlobalState[string.format("Property:%s", propertyId)]
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Properties", PROPERTIES)
end)
