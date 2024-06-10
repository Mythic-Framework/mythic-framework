loadedInventorys = {}
LoadedEntitys = {}
ItemCallbacks = {}
createdInventories = {}

GlobalState["Dropzones"] = {}
_polyInvs = {}
_openInvs = {}
_doingThings = {}
_exitSaving = {}
_govAccount = nil
_hasAttchs = {}

_refreshAttchs = {}

AddEventHandler("Inventory:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Database = exports["mythic-base"]:FetchComponent("Database")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Sequence = exports["mythic-base"]:FetchComponent("Sequence")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Default = exports["mythic-base"]:FetchComponent("Default")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	EntityTypes = exports["mythic-base"]:FetchComponent("EntityTypes")
	Chat = exports["mythic-base"]:FetchComponent("Chat")
	Wallet = exports["mythic-base"]:FetchComponent("Wallet")
	Execute = exports["mythic-base"]:FetchComponent("Execute")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Crafting = exports["mythic-base"]:FetchComponent("Crafting")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Reputation = exports["mythic-base"]:FetchComponent("Reputation")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Generator = exports["mythic-base"]:FetchComponent("Generator")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Banking = exports["mythic-base"]:FetchComponent("Banking")
	Robbery = exports["mythic-base"]:FetchComponent("Robbery")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Inventory", {
		"Database",
		"Callbacks",
		"Sequence",
		"Fetch",
		"Logger",
		"Utils",
		"Inventory",
		"Chat",
		"EntityTypes",
		"Default",
		"Wallet",
		"Middleware",
		"Crafting",
		"Execute",
		"Animations",
		"Weapons",
		"Jobs",
		"Reputation",
		"Vehicles",
		"Generator",
		"Phone",
		"Banking",
		"Robbery",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		LoadItems()
		LoadSchematics()

		RegisterCallbacks()
		loadedInventorys = {}
		ClearDropZones()
		ClearGarbage()
		LoadEntityTypes()
		LoadShops()
		RegisterCommands()
		RegisterStashCallbacks()

		RegisterTestBench()
		RegisterCraftingCallbacks()

		InventoryThreads()

        local f = Banking.Accounts:GetOrganization("government")
        _govAccount = f.Account

		Middleware:Add("Characters:Spawning", function(source)
			TriggerClientEvent("Inventory:Client:PolySetup", source, _polyInvs)
		end, 1)

		Middleware:Add("Characters:CharacterSelected", function(source)
			local player = Fetch:Source(source)
			local char = player:GetData("Character")

			if GlobalState[("inventory:%s:%s:slots"):format(char:GetData("ID"), 1)] == nil then
				GlobalState[("inventory:%s:%s:slots"):format(char:GetData("ID"), 1)] = Inventory:Load(
					char:GetData("ID"),
					1
				)
			end

			if GlobalState[("inventory:%s:%s:slots"):format(char:GetData("ID"), 2)] == nil then
				GlobalState[("inventory:%s:%s:slots"):format(char:GetData("ID"), 2)] = Inventory:Load(
					char:GetData("ID"),
					2,
					true
				)
			end

			for k, v in ipairs(createdInventories) do
				if v.owner == char:GetData("ID") then
					v.unloaded = nil
				end
			end
		end, 1)

		Middleware:Add("Characters:Spawning", function(source)
			local benches = {}
			for k, v in pairs(_types) do
				table.insert(benches, {
					id = v.id,
					label = v.label,
					targeting = v.targeting,
					location = v.location,
					restrictions = v.restrictions,
					canUseSchematics = v.canUseSchematics,
				})
			end
			TriggerClientEvent("Crafting:Client:CreateBenches", source, benches)
		end, 2)

		Middleware:Add("Characters:Spawning", function(source)
			UpdateCharacterItemStates(source, true)
			UpdateCharacterGangChain(source)
		end, 3)

		Middleware:Add("Characters:Logout", function(source)
			local p = promise.new()
			Callbacks:ClientCallback(source, "Weapons:Logout", {}, function(data)
				if data ~= nil then
					Weapons:Save(source, data.slot, data.ammo, data.clip)
				end
				p:resolve(true)
			end)
			return Citizen.Await(p)
		end, 1)

		-- These can likely be removed once things are proven stable
		Middleware:Add("Characters:Logout", SavePlayerInventory, 2)
		Middleware:Add("playerDropped", SavePlayerInventory, 2)

		Middleware:Add("Characters:Created", function(source, cData)
			local player = Fetch:Source(source)
			local docs = {}

			local slot = 1
			for k, v in ipairs(Config.StartItems) do
				local itemExist = itemsDatabase[v.name]
				if itemExist ~= nil then
					local MetaData = {}

					if itemExist.staticMetadata ~= nil then
						for k, v in pairs(itemExist.staticMetadata) do
							MetaData[k] = v
						end
					end

					if itemExist.type == 2 then
						if not MetaData.SerialNumber and not itemExist.noSerial then
							if MetaData.Scratched then
								MetaData.ScratchedSerialNumber = Weapons:Purchase(cData.ID, itemExist, true)
								MetaData.Scratched = nil
							else
								MetaData.SerialNumber = Weapons:Purchase(cData.ID, itemExist, false)
							end
						end
					elseif itemExist.type == 10 and not MetaData.Container then
						MetaData.Container = string.format("container:%s", Sequence:Get("Container"))
					elseif itemExist.type == 11 and not MetaData.Quality then
						MetaData.Quality = math.random(100)
					elseif itemExist.name == "govid" then
						local genStr = "Male"
						if cData.Gender == 1 then
							genStr = "Female"
						end
						MetaData.Name = string.format("%s %s", cData.First, cData.Last)
						MetaData.Gender = genStr
						MetaData.PassportID = player:GetData("AccountID")
						MetaData.StateID = cData.SID
						MetaData.DOB = cData.DOB
					elseif itemExist.name == "moneybag" and not MetaData.Finished then
						MetaData.Finished = os.time() + (60 * 60 * 24 * math.random(1, 3))
					elseif itemExist.name == "crypto_voucher" and not MetaData.CryptoCoin and not MetaData.Quantity then
						MetaData.CryptoCoin = "PLEB"
						MetaData.Quantity = math.random(25, 50)
					elseif itemExist.name == "choplist" and not MetaData.ChopList then
						MetaData.ChopList = Phone.LSUnderground.Chopping:GenerateList(math.random(4, 8), math.random(3, 5))
					end

					if not MetaData.CreateDate then
						MetaData.CreateDate = os.time()
					end

					table.insert(docs, {
						Name = v.name,
						Count = v.count,
						Slot = slot,
						MetaData = MetaData,
						invType = 1,
						Owner = cData.ID,
					})
					slot = slot + 1
				end
			end

			Database.Game:insertOne({
				collection = "inventory",
				document = {
					Owner = cData.ID,
					invType = 1,
					Slots = docs,
				},
			})
		end, 2)
	end)
end)

function DoTheSave(owner, invType, unload)
	if GlobalState[("inventory:%s:%s:slots"):format(owner, invType)] ~= nil then
		_exitSaving[string.format("%s:%s", owner, invType)] = true
		local p = promise.new()
		local slots = GlobalState[("inventory:%s:%s:slots"):format(owner, invType)]
		local save = {}
		for k, v in ipairs(slots) do
			local key = string.format("inventory:%s:%s:%s", owner, invType, v)
			local item = GlobalState[key]
			table.insert(save, item)
			if unload then
				GlobalState[key] = nil
			end
		end
		if unload then
			GlobalState[("inventory:%s:%s:slots"):format(owner, invType)] = nil
			for k, v in ipairs(createdInventories) do
				if v.type == invType and v.owner == owner then
					createdInventories[k].unloaded = true
				end
			end
		end
		Database.Game:updateOne({
			collection = "inventory",
			query = {
				Owner = owner,
				invType = invType,
			},
			update = {
				["$set"] = {
					Slots = save,
				},
			},
			options = {
				upsert = true,
			},
		}, function(success, result)
			if not success then
				p:resolve(true)
				return
			end
			Logger:Info(
				"Inventory",
				string.format("Save ^2%s:%s^7", owner, invType),
				{ console = true, database = true },
				{
					owner = owner,
					type = invType,
					inventory = save,
				}
			)

			if unload then
				_openInvs[string.format("%s-%s", invType, owner)] = nil
			end

			p:resolve(true)
		end)

		Citizen.Await(p)
		_exitSaving[string.format("%s:%s", owner, invType)] = false
	end
end

function SavePlayerInventory(source)
	local player = Fetch:Source(source)
	if player then
		local char = player:GetData("Character")
		if char ~= nil and GlobalState[("inventory:%s:%s:slots"):format(char:GetData("ID"), 1)] ~= nil then
			DoTheSave(char:GetData("ID"), 1, true)
			DoTheSave(char:GetData("ID"), 2, true)
		end
	end

	for k, v in pairs(_openInvs) do
		if v == source then
			_openInvs[k] = nil
		end
	end
end

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Inventory", INVENTORY)
end)

RegisterServerEvent("Inventory:server:closePlayerInventory", function()
	local src = source
	local char = Fetch:Source(source):GetData("Character")
	if char ~= nil then
		_openInvs[string.format("%s-%s", 1, char:GetData("ID"))] = false
	end

	if _refreshAttchs[char:GetData("ID")] then
		TriggerClientEvent("Weapons:Client:Attach", src)
		_refreshAttchs[char:GetData("ID")] = false
	end
end)

RegisterServerEvent("Inventory:server:closeSecondary", function(inventory)
	local _src = source
	_openInvs[string.format("%s-%s", inventory.invType, inventory.owner)] = false

	if inventory.invType == 10 then
		local route = Player(_src).state.currentRoute
		local hasItems = #Inventory:GetSlots(inventory.owner, 10) > 0
		local exists = Inventory:DropExists(route, inventory.owner)
		if inventory.position ~= nil and hasItems and not exists then
			Inventory:CreateDropzone(route, inventory.position)
		elseif not hasItems then
			Inventory:RemoveDropzone(route, inventory.owner)
		end
	end

	local src = source
	if loadedInventorys[src] then
		loadedInventorys[src] = nil
	end
end)

function sendRefreshForClient(_src, owner, invType, slot)
	Inventory:GetSlot(owner, slot, invType, function(slotData)
		TriggerClientEvent("Inventory:Client:SetSlot", _src, owner, slot, slotData)
	end)
end

function entityPermCheck(source, invType)
	local plyr = Fetch:Source(source)
	local char = plyr:GetData("Character")

	local shittyInvData = LoadedEntitys[tonumber(invType)]

	if shittyInvData then
		return (
				shittyInvData.restriction == nil
				or (shittyInvData.restriction.job ~= nil and Jobs.Permissions:HasJob(
					source,
					shittyInvData.restriction.job.id,
					shittyInvData.restriction.job.workplace or false,
					shittyInvData.restriction.job.grade or false,
					false,
					false,
					shittyInvData.restriction.job.permissionKey or "JOB_STORAGE"
				) and (not shittyInvData.restriction.job.duty or Player(source).state.onDuty == shittyInvData.restriction.job.id))
				or (shittyInvData.restriction.state and hasValue(
					char:GetData("States"),
					shittyInvData.restriction.state
				))
				or (
					shittyInvData.restriction.rep ~= nil
					and Reputation:GetLevel(source, shittyInvData.restriction.rep.id) >= shittyInvData.restriction.rep.level
				)
				or (shittyInvData.restriction.character ~= nil and shittyInvData.restriction.character == char:GetData(
					"ID"
				))
				or (shittyInvData.restriction.admin and plyr.Permissions:IsAdmin())
			)
	else
		return false
	end
end

function getSlotCount(invType, vehClass, vehModel)
	if LoadedEntitys[tonumber(invType)].isTrunk and (vehClass or vehModel) then
		if vehModel and _modelOverride[vehModel] ~= nil then
			return _modelOverride[vehModel].trunk.slots
		else
			return _trunkSizes[vehClass].slots
		end
	elseif LoadedEntitys[tonumber(invType)].isGlovebox and (vehClass or vehModel) then
		if vehModel and _modelOverride[vehModel] ~= nil then
			return _modelOverride[vehModel].glovebox.slots
		else
			return _gloveboxSizes[vehClass].slots
		end
	elseif LoadedEntitys[tonumber(invType)].shop and LoadedEntitys[tonumber(invType)].itemSet ~= nil and Config.ShopItemSets[LoadedEntitys[tonumber(invType)].itemSet] ~= nil then
		return #Config.ShopItemSets[LoadedEntitys[tonumber(invType)].itemSet]
	else
		return LoadedEntitys[tonumber(invType)].slots
	end
end

function getCapacity(invType, vehClass, vehModel)
	if LoadedEntitys[tonumber(invType)].isTrunk and (vehClass or vehModel) then
		if vehModel and _modelOverride[vehModel] ~= nil then
			return _modelOverride[vehModel].trunk.capacity
		else
			return _trunkSizes[vehClass].capacity
		end
	elseif LoadedEntitys[tonumber(invType)].isGlovebox and (vehClass or vehModel) then
		if vehModel and _modelOverride[vehModel] ~= nil then
			return _modelOverride[vehModel].glovebox.capacity
		else
			return _gloveboxSizes[vehClass].capacity
		end
	else
		return LoadedEntitys[tonumber(invType)].capacity
	end
end

function parse_json_date(json_date)
	local pattern = "(%d+)%-(%d+)%-(%d+)%a(%d+)%:(%d+)%:([%d%.]+)([Z%+%-])(%d?%d?)%:?(%d?%d?)"
	local year, month, day, hour, minute, seconds, offsetsign, offsethour, offsetmin = json_date:match(pattern)
	local timestamp = os.time({ year = year, month = month, day = day, hour = hour, min = minute, sec = seconds })

	if timestamp == nil then
		return os.time()
	end

	local offset = 0
	if offsetsign ~= "Z" then
		offset = tonumber(offsethour) * 60 + tonumber(offsetmin)
		if xoffset == "-" then
			offset = offset * -1
		end
	end

	return timestamp + offset
end

function DoMove(source, data, cb)
	local player = Fetch:Source(source)
	local char = player:GetData("Character")
	local invWeight = Inventory.Items:GetWeights(data.ownerTo, data.invTypeTo)
	local totWeight = invWeight + (data.countTo * itemsDatabase[data.name].weight)

	if data.ownerFrom == nil or data.slotFrom == nil or data.invTypeFrom == nil or data.ownerTo == nil or data.slotTo == nil or data.invTypeTo == nil then
		cb({ reason = "Invalid Move Data" })
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		if not LoadedEntitys[tonumber(data.invTypeFrom)].shop then
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		end
		return
	end

	if totWeight > getCapacity(data.invTypeTo, data.vehClassTo, data.vehModelTo) and data.ownerFrom ~= data.ownerTo then
		cb({ reason = "Inventory Over Weight" })
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		if not LoadedEntitys[tonumber(data.invTypeFrom)].shop then
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		end
		return
	end

	if data.countTo <= 0 then
		cb({ reason = "Can't Move 0 - Naughty Boy" })
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
		if not LoadedEntitys[tonumber(data.invTypeFrom)].shop then
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		end
		return
	end

	if itemsDatabase[data.name] then
		_doingThings[string.format("%s:%s", data.ownerFrom, data.invTypeFrom)] = true
		_doingThings[string.format("%s:%s", data.ownerTo, data.invTypeTo)] = true

		-- This is a shop, we need to handle this differently
		if entityPermCheck(source, data.invTypeFrom) and entityPermCheck(source, data.invTypeTo) then
			if LoadedEntitys[tonumber(data.invTypeTo)].shop then
				return
			end

			if
				data.invTypeTo ~= 10
				and (not LoadedEntitys[tonumber(data.invTypeTo)].isVehicle or (LoadedEntitys[tonumber(data.invTypeTo)].isVehicle and Vehicles.Owned:GetActive(
					data.ownerTo
				)))
				and not ExistsInRetard(string.format("%s:%s", data.ownerTo, data.invTypeTo))
			then
				Logger:Trace("Inventory", string.format("Adding ^2%s:%s^7 To Be Saved", data.ownerTo, data.invTypeTo))
				table.insert(createdInventories, {
					id = string.format("%s:%s", data.ownerTo, data.invTypeTo),
					owner = data.ownerTo,
					type = data.invTypeTo,
				})
			end

			if LoadedEntitys[tonumber(data.invTypeFrom)].shop then
				local item = itemsDatabase[data.name]
				local cash = char:GetData("Cash")
				local entity = LoadedEntitys[tonumber(data.invTypeFrom)]
				if cash >= (item.price * tonumber(data.countTo)) or entity.free then -- Check and make sure player has needed cash to purchase requested items & qty
					if -- Check if the item is either not a gun, or if it is that they have a Weapons license
						(item.type ~= 2
						or (
							item.type == 2
							and (not item.requiresLicense or item.requiresLicense and Weapons:IsEligible(source))
						))
						and (not item.qualification or hasValue(char:GetData("Qualifications"), item.qualification))
					then
						local p = promise.new()
						local toRemoveFromPlayer = (item.price * tonumber(data.countTo))

						-- Get destination slot to use for logic
						Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
							if slotTo == nil then -- destination slot is nil, just create new slot
								if
									Inventory:AddSlot(
										data.ownerTo,
										data.name,
										data.countTo,
										{},
										data.slotTo,
										data.invTypeTo
									)
								then -- charge the cunt
									if not entity.free then
										Wallet:Modify(source, -(math.abs(toRemoveFromPlayer)))
										if storeBankAccounts[entity.id] ~= nil then
											pendingShopDeposits[storeBankAccounts[entity.id]] = pendingShopDeposits[storeBankAccounts[entity.id]] or { amount = 0, transactions = 0 }
											pendingShopDeposits[storeBankAccounts[entity.id]].amount += math.floor( (toRemoveFromPlayer * STORE_SHARE_AMOUNT) )
											pendingShopDeposits[storeBankAccounts[entity.id]].transactions += 1
		
											pendingShopDeposits[_govAccount] = pendingShopDeposits[_govAccount] or { amount = 0, transactions = 0, tax = true }
											pendingShopDeposits[_govAccount].amount += math.ceil(toRemoveFromPlayer * (1.0 - STORE_SHARE_AMOUNT))
											pendingShopDeposits[_govAccount].transactions += 1
										end
									end

									sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
									cb({ success = true })
									p:resolve(true)
								else
									sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
									cb({ success = false })
									p:resolve(false)
								end
							else
								-- Destination slot has an item that is different, or has an item that isn't stackable,
								-- or has an item and the amount trying to buy would exceed stack limit
								if
									slotTo.Name ~= data.name
									or not item.isStackable
									or item.isStackable == -1
									or (slotTo.Count + data.countTo) > item.isStackable
								then
									cb({ success = false })
									p:resolve(false)
								else
									if -- Attempt to add to destination slot
										Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo)
									then -- charge the cunt
										if not entity.free then
											Wallet:Modify(source, -(math.abs(toRemoveFromPlayer)))
											if storeBankAccounts[entity.id] ~= nil then
												pendingShopDeposits[storeBankAccounts[entity.id]] = pendingShopDeposits[storeBankAccounts[entity.id]] or { amount = 0, transactions = 0 }
												pendingShopDeposits[storeBankAccounts[entity.id]].amount += math.floor( (toRemoveFromPlayer * STORE_SHARE_AMOUNT) )
												pendingShopDeposits[storeBankAccounts[entity.id]].transactions += 1
			
												pendingShopDeposits[_govAccount] = pendingShopDeposits[_govAccount] or { amount = 0, transactions = 0, tax = true }
												pendingShopDeposits[_govAccount].amount += math.ceil(toRemoveFromPlayer * (1.0 - STORE_SHARE_AMOUNT))
												pendingShopDeposits[_govAccount].transactions += 1
											end
										end

										sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
										cb({ success = true })
										p:resolve(true)
									else
										cb({ success = false })
										p:resolve(false)
									end
								end
							end
						end)

						-- Some items have metadata we have to handle when they get the item
						-- or in this case buy it, check that the operation was successful
						-- and then handle whatever that is
						if Citizen.Await(p) then
							if item.staticMetadata ~= nil then
								for k, v in pairs(item.staticMetadata) do
									Inventory:SetMetaDataKey(data.ownerTo, 1, data.slotTo, k, v)
								end
							end

							if item.type == 2 and not item.noSerial then
								-- Weapon Serial Number
								Inventory:SetMetaDataKey(
									data.ownerTo,
									1,
									data.slotTo,
									"SerialNumber",
									Weapons:Purchase(data.ownerTo, item, false)
								)
							elseif item.type == 10 then
								-- Container ID
								Inventory:SetMetaDataKey(
									data.ownerTo,
									1,
									data.slotTo,
									"Container",
									string.format("container:%s", Sequence:Get("Container"))
								)
							elseif item.type == 11 then
								Inventory:SetMetaDataKey(data.ownerTo, 1, data.slotTo, "Quality", math.random(100))
							elseif item.name == "govid" then
								local plyr = Fetch:CharacterData("ID", data.ownerTo)
								local char = plyr:GetData("Character")

								local genStr = "Male"
								if char:GetData("Gender") == 1 then
									genStr = "Female"
								end
								Inventory:SetManyMetaDataKeys(data.ownerTo, 1, data.slotTo, {
									Name = string.format("%s %s", char:GetData("First"), char:GetData("Last")),
									Gender = genStr,
									PassportID = plyr:GetData("AccountID"),
									StateID = char:GetData("SID"),
									DOB = char:GetData("DOB"),
								})
							elseif item.name == "moneybag" then
								Inventory:SetManyMetaDataKeys(data.ownerTo, 1, data.slotTo, {
									Finished = os.time() + (60 * 60 * 24 * math.random(1, 3))
								})
							elseif item.name == "crypto_voucher" then
								Inventory:SetManyMetaDataKeys(data.ownerTo, 1, data.slotTo, {
									CryptoCoin = "PLEB",
									Quantity = math.random(25, 50),
								})
							elseif item.name == "vpn" then
								Inventory:SetMetaDataKey(data.ownerTo, 1, data.slotTo, "VpnName", {
									First = Generator.Name:First(),
									Last = Generator.Name:Last(),
								})
							elseif item.name == "WEAPON_PETROLCAN" then
								Inventory:SetMetaDataKey(data.ownerTo, 1, data.slotTo, "ammo", 4500)
							elseif item.name == "cigarette_pack" then
								Inventory:SetMetaDataKey(data.ownerTo, 1, data.slotTo, "Count", 30)
							elseif item.name == "choplist" then
								Inventory:SetMetaDataKey(data.ownerTo, 1, data.slotTo, "ChopList", Phone.LSUnderground.Chopping:GenerateList(math.random(4, 8), math.random(3, 5)))
							end

							-- Item Creation Date (Used For Degen)
							Inventory:SetMetaDataKey(data.ownerTo, 1, data.slotTo, "CreateDate", os.time())

							UpdateCharacterItemStates(source, true)

							if item.gangChain ~= nil then
								UpdateCharacterGangChain(source)
							end

							if WEAPON_PROPS[item.name] ~= nil then
								_refreshAttchs[data.ownerTo] = true
							end
						end
					else
						sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
						cb({ reason = "Ineligible To Purchase Item" })
					end
				else
					sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
					cb({ reason = "Not Enough Cash" })
				end
			else
				if -- inventory & slot is the same, we dont need to do anything
					data.ownerFrom == data.ownerTo
					and data.slotFrom == data.slotTo
					and data.invTypeFrom == data.invTypeTo
				then
					cb({ success = true })
				else -- start the checks of what we need to do, starting off getting both slot from & to
					if
						data.invTypeFrom ~= 10
						and (not LoadedEntitys[tonumber(data.invTypeFrom)].isVehicle or (LoadedEntitys[tonumber(
							data.invTypeFrom
						)].isVehicle and Vehicles.Owned:GetActive(data.ownerFrom)))
						and not ExistsInRetard(string.format("%s:%s", data.ownerFrom, data.invTypeFrom))
					then
						Logger:Trace(
							"Inventory",
							string.format("Adding ^2%s:%s^7 To Be Saved", data.ownerFrom, data.invTypeFrom)
						)
						table.insert(createdInventories, {
							id = string.format("%s:%s", data.ownerFrom, data.invTypeFrom),
							owner = data.ownerFrom,
							type = data.invTypeFrom,
						})
					end

					Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom, function(slotFrom)
						if slotFrom then
							Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo, function(slotTo)
								local p = promise.new()
								local item = itemsDatabase[data.name]
								local itemFrom = itemsDatabase[slotFrom.Name]
								if slotTo == nil then -- Destination slot doesn't exists, so we're going to create it
									local removed = false
									if data.countTo >= slotFrom.Count then -- We're moving the entire stack, so we can remove that slot
										removed = Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
									else -- not moving whole stack, so we need to reduce how much we're moving from origin slot
										removed = Inventory:RemoveAmount(
											data.ownerFrom,
											data.slotFrom,
											data.countTo,
											data.invTypeFrom
										)
									end

									if removed then
										Inventory:AddSlot( -- Add moving qty to new slot
											data.ownerTo,
											data.name,
											data.countTo,
											slotFrom.MetaData,
											data.slotTo,
											data.invTypeTo
										)
		
										-- Some bullshit return stuff that tbh idk what its needed for
										cb({ success = true })
										sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
										sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
										p:resolve(true)
									else
										-- Some bullshit return stuff that tbh idk what its needed for
										cb({ reason = "Failed Removing Item" })
										sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
										sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
										p:resolve(false)
									end
								else -- destination slot exists, so we need to do some checks to figure out what to do
									local itemTo = itemsDatabase[slotTo.Name]
									if -- either items are not the same, item is not stackable, or we're trying to merge more than what can be in a stack, so swap slots
										itemTo ~= nil
										and (slotFrom.Name ~= slotTo.Name
										or (not itemFrom.isStackable and itemFrom.isStackable ~= -1)
										or (itemFrom.isStackable > 0 and (data.countTo + slotTo.Count) > itemFrom.isStackable))
									then
										local fromInvWeight = Inventory.Items:GetWeights(data.ownerFrom, data.invTypeFrom)
										local maxWeight = getCapacity(data.invTypeFrom, data.vehClassFrom, data.vehModelFrom)
										local newWeight = fromInvWeight - (slotFrom.Count * (itemFrom.weight or 0))
										newWeight += (slotTo.Count * (itemTo.weight or 0))

										if newWeight <= maxWeight then
											Inventory:SwapSlots(
												data.ownerFrom,
												data.ownerTo,
												data.slotFrom,
												data.slotTo,
												data.invTypeFrom,
												data.invTypeTo
											)
											cb({ success = true })
										else
											cb({ reason = "Inventory Over Weight" })
										end
									else -- We can move the moving qty onto destination slot, so we need to figure out how we're moving it
										if data.countTo >= slotFrom.Count then -- Moving entire slot, so we can just remove origin slot
											Inventory:RemoveSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
										else -- not moving entire slot, so we deduct move qty from origin
											Inventory:RemoveAmount(
												data.ownerFrom,
												data.slotFrom,
												data.countTo,
												data.invTypeFrom
											)
										end
	
										-- Add to destination slot
										Inventory:AddToSlot(data.ownerTo, data.slotTo, data.countTo, data.invTypeTo, slotFrom.MetaData)
										cb({ success = true })
									end
	
									-- Some bullshit return stuff that tbh idk what its needed for
									sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
									sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
									p:resolve(true)
								end
	
								-- Various cleanup things that need to be done if the operation was successful
								if Citizen.Await(p) then
									if data.invTypeFrom == 1 then
										local plyr = Fetch:CharacterData("ID", data.ownerFrom)
										UpdateCharacterItemStates(plyr:GetData("Source"), true)

										if itemFrom.gangChain ~= nil and plyr:GetData("Character"):GetData("GangChain") == itemFrom.gangChain then
											UpdateCharacterGangChain(plyr:GetData("Source"))
										end

										if data.ownerFrom == data.ownerTo then
											if itemFrom.type == 2 then
												if (not itemFrom.isStackable and itemFrom.isStackable ~= -1) or data.countTo == slotFrom.Count then
													TriggerClientEvent(
														"Weapons:Client:Move",
														plyr:GetData("Source"),
														data.slotFrom,
														data.slotTo
													)
												end
												
												if itemFrom.isThrowable then
													TriggerClientEvent(
														"Weapons:Client:UpdateCount",
														plyr:GetData("Source"),
														data.slotFrom,
														(slotFrom.Count - data.countTo)
													)
													TriggerClientEvent(
														"Weapons:Client:UpdateCount",
														plyr:GetData("Source"),
														data.slotTo,
														((slotTo?.Count or 0) + data.countTo)
													)
												end
											elseif itemFrom.type == 10 then
												TriggerClientEvent(
													"Inventory:Container:Move",
													plyr:GetData("Source"),
													data.slotFrom,
													data.slotTo
												)
											end
										else
											if  (not itemFrom.isStackable and itemFrom.isStackable ~= -1) or data.countTo == slotFrom.Count then
												if itemFrom.type == 2 then
													TriggerClientEvent(
														"Weapons:Client:Remove",
														plyr:GetData("Source"),
														slotFrom,
														data.slotFrom,
														{
															owner = data.ownerTo,
															type = data.invTypeTo,
															slot = data.slotTo,
														}
													)
												elseif itemFrom.type == 10 then
													TriggerClientEvent(
														"Inventory:Container:Remove",
														plyr:GetData("Source"),
														slotFrom,
														data.slotFrom
													)
												end
											else
												if data.invTypeFrom == 1 and itemFrom.isThrowable then
													TriggerClientEvent(
														"Weapons:Client:UpdateCount",
														Fetch:CharacterData("ID", data.ownerFrom):GetData("Source"),
														data.slotFrom,
														(slotFrom.Count - data.countTo)
													)
												end
												
												if data.invTypeTo == 1 and itemFrom.isThrowable then
													TriggerClientEvent(
														"Weapons:Client:UpdateCount",
														Fetch:CharacterData("ID", data.ownerTo):GetData("Source"),
														data.slotTo,
														((slotTo?.Count or 0) + data.countTo)
													)
												end
											end
										end
									end
	
									if data.invTypeTo == 1 then
										local plyr = Fetch:CharacterData("ID", data.ownerTo)
										UpdateCharacterItemStates(plyr:GetData("Source"), true)

										if itemFrom.gangChain ~= nil and plyr:GetData("Character"):GetData("GangChain") == itemFrom.gangChain then
											UpdateCharacterGangChain(plyr:GetData("Source"))
										end

										if itemFrom.isThrowable then
											TriggerClientEvent(
												"Weapons:Client:UpdateCount",
												plyr:GetData("Source"),
												data.slotTo,
												((slotTo?.Count or 0) + data.countTo)
											)
										end
									end
								end

								
								if WEAPON_PROPS[itemFrom.name] ~= nil then
									_refreshAttchs[data.ownerFrom] = true
									if data.ownerTo ~= data.ownerFrom then
										_refreshAttchs[data.ownerTo] = true
									end
								end
							end)
						else
							cb({ reason = "Error" })
							sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
							if not LoadedEntitys[tonumber(data.invTypeFrom)].shop then
								sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
							end
						end
					end)
				end
			end
		end
	else
		-- is there a pwnzer thing for this or ?
		cb({ reason = "Item does not exist" })
		sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
		sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
	end

	_doingThings[string.format("%s:%s", data.ownerFrom, data.invTypeFrom)] = false
	_doingThings[string.format("%s:%s", data.ownerTo, data.invTypeTo)] = false
end

function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Inventory:HasItem", function(source, data, cb)
		local player = Fetch:Source(source)
		local char = player:GetData("Character")
		cb(Inventory.Items:Has(char:GetData("ID"), 1, data.item, data.count))
	end)

	Callbacks:RegisterServerCallback("Inventory:HasItems", function(source, data, cb)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local char = player:GetData("Character")
		local charId = char:GetData("ID")

		for k, v in ipairs(data) do
			if not Inventory.Items:Has(charId, 1, v.item, v.count) then
				return cb(false)
			end
		end

		cb(true)
	end)

	Callbacks:RegisterServerCallback("Inventory:HasAnyItems", function(source, data, cb)
		cb(Inventory.Items:HasAnyItems(source, data))
	end)

	Callbacks:RegisterServerCallback("Inventory:OpenTrunk", function(source, data, cb)
		local myCoords = GetEntityCoords(GetPlayerPed(source))
		local veh = NetworkGetEntityFromNetworkId(data.netId)

		if Entity(veh).state.VIN == nil then
			return cb(false)
		end

		if not _openInvs[string.format("%s-%s", 4, Entity(veh).state.VIN)] then
			local vehCoords = GetEntityCoords(veh)
			local dist = #(vector3(myCoords.x, myCoords.y, myCoords.z) - vector3(vehCoords.x, vehCoords.y, vehCoords.z))
			local lock = GetVehicleDoorLockStatus(veh)
			if dist < 8 and (lock == 0 or lock == 1) then
				Inventory:OpenSecondary(source, 4, Entity(veh).state.VIN, data.class or false, data.model or false)
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:Server:RemoveItem", function(source, data, cb)
		if data.item.Owner and data.item.Name and data.item.Slot and data.item.invType then
			Inventory:RemoveItem(
				data.item.Owner,
				data.item.Name,
				(data.amount or 1),
				data.item.Slot,
				data.item.invType,
				cb
			)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:UseSlot", function(source, data, cb)
		if data and data.slot then
			local player = Fetch:Source(source)
			local char = player:GetData("Character")
			if player and char then
				Inventory:GetSlot(char:GetData("ID"), data.slot, 1, function(slotFrom)
					if slotFrom ~= nil then
						if slotFrom?.Count or 0 > 0 then
							Inventory.Items:Use(source, slotFrom, function(yea)
								--TriggerClientEvent("Inventory:Client:RefreshPlayer", source)
								cb(yea)
							end)
						else
							cb(false)
						end
					else
						cb(false)
					end
				end)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:GetSecondInventory", function(source, data, cb)
		local src = source
		local reqInt = loadedInventorys[src]
		if reqInt then
			Inventory:Get(source, reqInt.owner, reqInt.invType, function(inventory)
				cb({
					size = LoadedEntitys[reqInt.invType].slots,
					name = LoadedEntitys[reqInt.invType].name,
					capacity = LoadedEntitys[reqInt.invType].capacity,
					inventory = inventory.inventory,
					invType = reqInt.invType,
					owner = reqInt.owner,
					free = reqInt.free or false,
				})
			end)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:GetHotbar", function(source, data, cb)
		local player = Fetch:Source(source)
		local char = player:GetData("Character")
		Inventory:Get(source, char:GetData("ID"), 1, function(inventory)
			cb({
				size = (LoadedEntitys[1].slots or 10),
				name = char:GetData("First") .. " " .. char:GetData("Last"),
				capacity = LoadedEntitys[1].capacity,
				inventory = inventory.inventory,
				invType = 1,
				owner = char:GetData("ID"),
			})
		end)
	end)

	Callbacks:RegisterServerCallback("Inventory:GetPlayerInventory", function(source, data, cb)
		local player = Fetch:Source(source)
		local char = player:GetData("Character")

		if not _openInvs[string.format("%s-%s", 1, char:GetData("ID"))] then
			_openInvs[string.format("%s-%s", 1, char:GetData("ID"))] = source
			Inventory:Get(source, char:GetData("ID"), 1, function(inventory)
				cb({
					size = (LoadedEntitys[1].slots or 10),
					name = char:GetData("First") .. " " .. char:GetData("Last"),
					inventory = inventory.inventory,
					invType = 1,
					capacity = LoadedEntitys[1].capacity,
					owner = char:GetData("ID"),
					isWeaponEligble = Weapons:IsEligible(source),
					qualifications = char:GetData("Qualifications") or {},
				})
			end)
		else
			cb(nil)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:MoveItem", DoMove)

	Callbacks:RegisterServerCallback("Inventory:UseItem", function(source, data, cb)
		if entityPermCheck(source, data.invType) then
			Inventory:GetSlot(data.owner, data.slot, data.invType, function(slot)
				Inventory.Items:Use(source, slot, cb)
			end)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:CheckIfNearDropZone", function(source, data, cb)
		local playerPed = GetPlayerPed(source)
		local playerCoords = GetEntityCoords(playerPed)
		local route = Player(source).state.currentRoute
		cb(Inventory:CheckDropZones(route, playerCoords))
	end)

	Callbacks:RegisterServerCallback("Inventory:Server:retreiveStores", function(source, data, cb)
		cb(shopLocations)
	end)

	Callbacks:RegisterServerCallback("Inventory:Search", function(source, data, cb)
		local plyr = Fetch:Source(data.serverId)
		if plyr ~= nil then
			local dest = plyr:GetData("Character")
			if dest ~= nil then
				Inventory.Search:Character(source, data.serverId, dest:GetData("ID"))
				cb(dest:GetData("ID"))
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:Raid", function(source, data, cb)
		local dest = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		if pState.onDuty ~= nil and pState.onDuty == "police" and Jobs.Permissions:HasPermissionInJob(source, 'police', 'PD_RAID') then
			if not _openInvs[string.format("%s-%s", data.invType, data.owner)] then
				Inventory:OpenSecondary(source, data.invType, data.owner, data.class or false, data.model or false, true)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:CloseSecondary", function(source, inventory, cb)
		_openInvs[string.format("%s-%s", inventory.invType, inventory.owner)] = false
		if inventory.invType == 10 then
			local route = Player(source).state.currentRoute
			local hasItems = #Inventory:GetSlots(inventory.owner, 10) > 0
			local exists = Inventory:DropExists(route, inventory.owner)
			if inventory.position ~= nil and hasItems and not exists then
				Inventory:CreateDropzone(route, inventory.position)
			elseif not hasItems then
				Inventory:RemoveDropzone(route, inventory.owner)
			end
		end

		if _refreshAttchs[inventory.owner] then
			TriggerClientEvent("Weapons:Client:Attach", source)
			_refreshAttchs[inventory.owner] = false
		end

		if loadedInventorys[source] then
			loadedInventorys[source] = nil
		end

		cb()
	end)
end

RegisterServerEvent("Inventory:Server:requestSecondaryInventory", function(inv)
	if not _openInvs[string.format("%s-%s", inv.invType, inv.owner)] then
		Inventory:OpenSecondary(source, inv.invType, inv.owner, inv.class or false, inv.model or false)
	end
end)

local _inUse = {}
INVENTORY = {
	CreateDropzone = function(self, routeId, coords)
		local area = {
			id = string.format("%s:%s", coords.x, coords.y),
			route = routeId,
			coords = {
				x = coords.x,
				y = coords.y,
				z = coords.z,
			},
		}

		local drops = GlobalState["Dropzones"] or {}
		table.insert(drops, area)
		GlobalState["Dropzones"] = drops

		Citizen.Wait(300)
		TriggerClientEvent("Inventory:Client:DropzoneForceUpdate", -1)

		return string.format("%s:%s", coords.x, coords.y)
	end,
	CheckDropZones = function(self, routeId, coords)
		local found = nil
		if GlobalState["Dropzones"] ~= nil then
			for k, v in ipairs(GlobalState["Dropzones"]) do
				if v.route == routeId then
					local dz = v.coords
					local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(dz.x, dz.y, dz.z))
					if distance < 2.0 and (found == nil or distance < found.distance) then
						found = {
							id = v.id,
							position = v.coords,
							distance = distance,
							route = v.route,
						}
					end
				end
			end
		end

		if found ~= nil then
			return found
		else
			return found
		end
	end,
	RemoveDropzone = function(self, routeId, id)
		local t = GlobalState["Dropzones"]
		for k, v in ipairs(t) do
			if v.id == id and v.route == routeId then
				local hasItems = #Inventory:GetSlots(id, 10) > 0
				if not hasItems and not _doingThings[string.format("%s:%s", id, 10)] and not _openInvs[string.format("%s:%s", id, 10)] then
					table.remove(t, k)
					GlobalState["Dropzones"] = t
				end
				break
			end
		end
	end,
	DropExists = function(self, routeId, id)
		for k, v in ipairs(GlobalState["Dropzones"]) do
			if v.id == id and v.route == routeId then
				return true
			end
		end

		return false
	end,
	OpenSecondary = function(self, _src, invType, Owner, vehClass, vehModel, isRaid)
		if _src and invType and Owner then
			if entityPermCheck(_src, invType) or (isRaid and Player(_src).state.onDuty == "police") then
				local invSlots = Inventory:GetSlots(invType, Owner)

				if not LoadedEntitys[tonumber(invType)].shop then
					_openInvs[string.format("%s-%s", invType, Owner)] = _src
				end

				loadedInventorys[_src] = {
					owner = Owner,
					invType = tonumber(invType),
					source = tonumber(_src),
					class = vehClass,
					model = vehModel,
				}
				if loadedInventorys[_src] then
					local reqInt = loadedInventorys[_src]
					Inventory:Get(_src, Owner, invType, function(inventory)
						local name = (LoadedEntitys[invType].name or "Unknown")
						if LoadedEntitys[tonumber(invType)].shop and shopLocations[Owner] ~= nil then
							name = string.format(
								"%s (%s)",
								shopLocations[Owner].name,
								LoadedEntitys[tonumber(invType)].name
							)
						end

						local slots = getSlotCount(invType, vehClass, vehModel)

						loadedInventorys[_src].entity = {
							slots = slots,
							name = name,
						}

						local requestedInventory = {
							size = slots,
							name = name,
							class = vehClass,
							model = vehModel,
							capacity = getCapacity(invType, vehClass, vehModel),
							shop = LoadedEntitys[tonumber(invType)].shop or false,
							free = LoadedEntitys[tonumber(invType)].free or false,
							inventory = inventory.inventory,
							invType = invType,
							owner = Owner,
						}
						TriggerClientEvent("Inventory:client:loadSecondary", _src, requestedInventory)
					end)
				end
			end
		end
	end,
	GetSlots = function(self, Owner, invType)
		local slots = GlobalState[("inventory:%s:%s:slots"):format(Owner, invType)]
		if slots == nil then
			slots = Inventory:Load(Owner, invType)
			GlobalState[("inventory:%s:%s:slots"):format(Owner, invType)] = slots
		end

		table.sort(slots)

		return slots
	end,
	Load = function(self, Owner, Type, nilIfEmpty)
		local p = promise.new()
		Database.Game:find({
			collection = "inventory",
			query = {
				Owner = Owner,
				invType = Type,
			},
		}, function(success, results)
			if not success then
				Utils:Print("Error")
				return p:resolve({})
			end

			if nilIfEmpty and #results == 0 then
				GlobalState[("inventory:%s:%s:slots"):format(Owner, Type)] = nil
				return p:resolve(nil)
			end

			local slots = {}
			if #results > 0 then
				for k, v in ipairs(results[1].Slots) do
					local key = ("inventory:%s:%s:%s"):format(Owner, Type, v.Slot)
					if
						itemsDatabase[v.Name]
						and (
							itemsDatabase[v.Name].durability == nil
							or not itemsDatabase[v.Name].isDestroyed
							or (os.time() - (v?.MetaData?.CreateDate or os.time()) < itemsDatabase[v.Name].durability)
						)
					then
						table.insert(slots, v.Slot)
						GlobalState[key] = v
					else
						if Type == 0 then
							local plyr = Fetch:CharacterData("ID", Owner)
							if plyr ~= nil then
								TriggerClientEvent("Inventory:Client:Changed", plyr:GetData("Source"), "removed", v.Name, v.Count)
							end
						end

						GlobalState[key] = nil
					end
				end
				GlobalState[("inventory:%s:%s:slots"):format(Owner, Type)] = slots
			end

			p:resolve(slots)
		end)

		return Citizen.Await(p)
	end,
	Get = function(self, src, Owner, Type, cb)
		if LoadedEntitys[tonumber(Type)].shop then
			local char = Fetch:Source(src):GetData("Character")

			local items = {}
			if entityPermCheck(src, Type) then
				for k, v in pairs(Config.ShopItemSets[LoadedEntitys[Type].itemSet]) do
					if itemsDatabase[v] ~= nil then
						local stack = itemsDatabase[v].isStackable

						if not itemsDatabase[v].isStackable then
							stack = 1
						elseif itemsDatabase[v].isStackable == -1 then
							stack = 1000
						end

						items[tostring(k)] = {
							Slot = k,
							Label = itemsDatabase[v].label,
							Count = stack,
							Name = v,
							invType = 11,
							MetaData = {},
							Owner = tostring(Owner),
							Price = itemsDatabase[v].price,
						}
					end
				end
			end
			cb({
				inventory = items,
				owner = Owner,
				InvType = Type,
			})
		else
			local table = {}
			local slots = {}
			if GlobalState[("inventory:%s:%s:slots"):format(Owner, Type)] == nil then
				slots = Inventory:Load(Owner, Type)
			else
				slots = Inventory:GetSlots(Owner, Type)
			end

			for k, v in ipairs(slots) do
				local item = GlobalState[("inventory:%s:%s:%s"):format(Owner, Type, v)]
				if item ~= nil then
					local data = itemsDatabase[item.Name]
					if
						data ~= nil
						and (
							data.durability == nil
							or (item.MetaData == nil or item.MetaData.CreateDate == nil)
							or not data.isDestroyed
							or (item.MetaData.CreateDate + data.durability > os.time())
						)
					then
						item.Label = data.label
						table[tostring(item.Slot)] = item
					else
						Inventory:RemoveSlot(Owner, item.Slot, Type)
					end
				end
			end

			cb({
				inventory = table,
				owner = Owner,
				InvType = Type,
			})
		end
	end,
	Delete = function(self, Owner, Type, cb, reload)
		Database.Game:delete({
			collection = "inventory",
			query = {
				Owner = Owner,
				invType = Type,
			},
		}, function(success, results)
			if not success then
				return
			end

			GlobalState[("inventory:%s:%s:slots"):format(Owner, Type)] = nil

			local slotAmount = LoadedEntitys[tonumber(Type)]?.slots or 100
			for i = 0, slotAmount do
				GlobalState[("inventory:%s:%s:%s"):format(Owner, Type, i)] = nil
			end

			if results > 0 and reload then
				GlobalState[("inventory:%s:%s:slots"):format(Owner, Type)] = Inventory:Load(Owner, Type)
			end

			if cb ~= nil then
				cb(results > 0)
			end
		end)
	end,
	GetMatchingSlot = function(self, Owner, Name, Count, invType)
		local slots = Inventory:GetSlots(Owner, invType)

		if not itemsDatabase[Name].isStackable and itemsDatabase[Name].isStackable ~= -1 then
			return nil
		end

		local p = promise.new()
		local f = false
		for k, v in ipairs(slots) do
			Inventory:GetSlot(Owner, v, invType, function(slot)
				if
					slot.Name == Name
					and ((slot.Count + Count) <= itemsDatabase[slot.Name].isStackable or itemsDatabase[slot.Name].isStackable == -1)
					and (itemsDatabase[slot.Name].durability == nil or ((os.time() - slot.MetaData.CreateDate) <= 3600))
				then
					f = true
					p:resolve(slot)
				end
			end)
		end

		if not f then
			p:resolve(nil)
		end

		return Citizen.Await(p)
	end,
	SwapSlots = function(self, OwnerFrom, OwnerTo, SlotFrom, SlotTo, invTypeFrom, invTypeTo)
		local p = promise.new()
		Inventory:GetSlot(OwnerFrom, SlotFrom, invTypeFrom, function(slotFrom)
			Inventory:GetSlot(OwnerTo, SlotTo, invTypeTo, function(slotTo)
				slotTo.Slot = SlotFrom
				slotFrom.Slot = SlotTo
				GlobalState[("inventory:%s:%s:%s"):format(OwnerFrom, invTypeFrom, SlotFrom)] = slotTo
				GlobalState[("inventory:%s:%s:%s"):format(OwnerTo, invTypeTo, SlotTo)] = slotFrom
				p:resolve({ slotTo, slotFrom })
			end)
		end)

		local r = Citizen.Await(p)
		return r[1], r[2]
	end,
	GetFreeSlotNumbers = function(self, Owner, invType, vehClass, vehModel)
		local result = Inventory:GetSlots(Owner, invType)
		local occupiedTable = {}
		local unOccupiedSlots = {}
		for k, v in ipairs(result) do
			occupiedTable[v] = true
		end

		local total = 8
		if LoadedEntitys[invType] ~= nil then
			total = getSlotCount(invType, vehClass or false, vehModel or false)
		else
			Logger:Error("Inventory", string.format("Entity Type ^2%s^7 Was Attempted To Be Loaded", invType))
		end

		for i = 1, total do
			if not occupiedTable[i] then
				table.insert(unOccupiedSlots, i)
			end
		end

		table.sort(unOccupiedSlots)

		return unOccupiedSlots
	end,
	GetSlot = function(self, Owner, Slot, invType, cb)
		local result = GlobalState[("inventory:%s:%s:%s"):format(Owner, invType, Slot)]
		cb(result)
	end,
	AddItem = function(self, Owner, Name, Count, MetaData, invType, vehClass, vehModel, entity, isRecurse)
		if vehClass == nil then
			vehClass = false
		end

		if vehModel == nil then
			vehModel = false
		end

		if entity == nil then
			entity = false
		end

		if not Count or not tonumber(Count) or Count <= 0 then
			Count = 1
		end

		local itemExist = itemsDatabase[Name]
		if itemExist then
			local p = promise.new()

			local invWeight = Inventory.Items:GetWeights(Owner, invType)
			local totWeight = invWeight + (Count * itemExist.weight)

			if
				not itemExist.isStackable and itemExist.isStackable ~= -1 and Count > 1
				or (type(itemExist.isStackable) == "number" and Count > itemExist.isStackable and itemExist.isStackable > 0)
			then
				while
					not itemExist.isStackable and itemExist.isStackable ~= -1 and Count > 1
					or (type(itemExist.isStackable) == "number" and Count > itemExist.isStackable and itemExist.isStackable > 0)
				do
					local s = itemExist.isStackable or 1
					self:AddItem(Owner, Name, s, MetaData, invType, vehClass or false, vehModel or false, entity or false, true)
					Count = Count - s
				end
			end

			local slots = Inventory:GetFreeSlotNumbers(Owner, invType, vehClass, vehModel)
			if
				(totWeight > getCapacity(invType, vehClass, vehmodel) and itemExist.weight > 0)
				or (#slots == 0 or slots[1] > getSlotCount(invType, vehClass or false, vehModel or false))
			then
				local plyr = Fetch:CharacterData("ID", Owner)
				local coords = { x = 900.441, y = -1757.186, z = 21.359 }
				local route = 0

				if plyr ~= nil then
					local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(plyr:GetData("Source"))))
					coords = { x = x, y = y, z = z - 0.98 }
					route = Player(plyr:GetData("Source")).state.currentRoute
				elseif entity ~= nil then
					local x, y, z = table.unpack(GetEntityCoords(entity))
					coords = { x = x, y = y, z = z }
					route = GetEntityRoutingBucket(entity)
				end

				invType = 10
				local dz = Inventory:CheckDropZones(route, coords)
				if dz == nil then
					Owner = Inventory:CreateDropzone(route, coords)
				else
					Owner = dz.id
				end

				slots = Inventory:GetFreeSlotNumbers(Owner, invType, vehClass, vehModel)
			end

			if itemExist.staticMetadata ~= nil then
				for k, v in pairs(itemExist.staticMetadata) do
					MetaData[k] = v
				end
			end

			if itemExist.type == 2 then
				if not MetaData.SerialNumber and not itemExist.noSerial then
					if MetaData.Scratched then
						MetaData.ScratchedSerialNumber = Weapons:Purchase(Owner, itemExist, true, MetaData.Company)
						MetaData.Scratched = nil
					else
						MetaData.SerialNumber = Weapons:Purchase(Owner, itemExist, false, MetaData.Company)
					end
					MetaData.Company = nil
				end
			elseif itemExist.type == 10 and not MetaData.Container then
				MetaData.Container = string.format("container:%s", Sequence:Get("Container"))
			elseif itemExist.type == 11 and not MetaData.Quality then
				MetaData.Quality = math.random(100)
			elseif itemExist.name == "govid" and invType == 1 then
				local plyr = Fetch:CharacterData("ID", Owner)
				local char = plyr:GetData("Character")
				local genStr = "Male"
				if char:GetData("Gender") == 1 then
					genStr = "Female"
				end
				MetaData.Name = string.format("%s %s", char:GetData("First"), char:GetData("Last"))
				MetaData.Gender = genStr
				MetaData.PassportID = plyr:GetData("AccountID")
				MetaData.StateID = char:GetData("SID")
				MetaData.DOB = char:GetData("DOB")
			elseif itemExist.name == "moneybag" and not MetaData.Finish then
				MetaData.Finished = os.time() + (60 * 60 * 24 * math.random(1, 3))
			elseif itemExist.name == "crypto_voucher" and not MetaData.CryptoCoin and not MetaData.Quantity then
				MetaData.CryptoCoin = "PLEB"
				MetaData.Quantity = math.random(25, 50)
			elseif itemExist.name == "vpn" then
				MetaData.VpnName = {
					First = Generator.Name:First(),
					Last = Generator.Name:Last(),
				}
			elseif itemExist.name == "cigarette_pack" then
				MetaData.Count = 30
			elseif itemExist.name == "choplist" and not MetaData.ChopList then
				MetaData.ChopList = Phone.LSUnderground.Chopping:GenerateList(math.random(4, 8), math.random(3, 5))
			end

			if not MetaData.CreateDate then
				MetaData.CreateDate = os.time()
			end

			if not itemExist.isStackable and itemExist.isStackable ~= -1 then
				Inventory:AddSlot(Owner, Name, 1, MetaData, slots[1], invType)
				p:resolve(true)
			else
				local mSlot = Inventory:GetMatchingSlot(Owner, Name, Count, invType)
				if mSlot == nil then
					p:resolve(Inventory:AddSlot(Owner, Name, Count, MetaData, slots[1], invType))
				else
					p:resolve(Inventory:AddToSlot(Owner, mSlot.Slot, Count, invType, mSlot.MetaData))
				end
			end

			local retval = Citizen.Await(p)

			if invType == 1 then
				local plyr = Fetch:CharacterData("ID", Owner)
				TriggerClientEvent("Inventory:Client:Changed", plyr:GetData("Source"), "add", Name, Count)
				UpdateCharacterItemStates(plyr:GetData("Source"), true)

				if itemExist.gangChain ~= nil and plyr:GetData("Character"):GetData("GangChain") == itemExist.gangChain then
					UpdateCharacterGangChain(source)
				end

				if WEAPON_PROPS[itemExist.name] ~= nil and not _refreshAttchs[Owner] then
					_refreshAttchs[Owner] = true
				end

				if _refreshAttchs[Owner] then
					Citizen.Wait(1000)
					TriggerClientEvent("Weapons:Client:Attach", plyr:GetData("Source"))
					_refreshAttchs[Owner] = false
				end
			end

			return retval
		else
			return false
		end
	end,
	RemoveItem = function(self, Owner, Name, Count, Slot, invType)
		local p = promise.new()
		Inventory:GetSlot(Owner, Slot, invType, function(slot)
			if slot == nil then
				Logger:Error(
					"Inventory",
					"Failed to remove " .. Count .. " from Slot " .. Slot .. " for " .. Owner,
					{ console = false }
				)
				p:resolve(false)
			else
				if slot.Count - Count <= 0 then
					Inventory:RemoveSlot(Owner, slot.Slot, invType)
				else
					Inventory:RemoveAmount(Owner, slot.Slot, Count, invType)
					continue = false
				end

				if invType == 1 then
					local plyr = Fetch:CharacterData("ID", Owner)
					TriggerClientEvent("Inventory:Client:Changed", plyr:GetData("Source"), "removed", Name, Count)
					UpdateCharacterItemStates(plyr:GetData("Source"))

					if itemsDatabase[Name].gangChain ~= nil and plyr:GetData("Character"):GetData("GangChain") == itemsDatabase[Name].gangChain then
						UpdateCharacterGangChain(source)
					end
					sendRefreshForClient(plyr:GetData("Source"), Owner, invType, Slot)
				end
				p:resolve(true)
			end
		end)
		return Citizen.Await(p)
	end,
	RemoveAmount = function(self, owner, slot, amount, invType, cb)
		local p = promise.new()
		Inventory:GetSlot(owner, slot, invType, function(result)
			if result == nil then
				Logger:Error("Inventory", "[RemoveAmount] Slot " .. slot .. " Does Not Exists for " .. owner)
				p:resolve(false)
				return
			end
			result.Count = result.Count - amount
			GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)] = result
			p:resolve(result)
		end)
		return Citizen.Await(p)
	end,
	AddSlot = function(self, Owner, Name, Count, MetaData, Slot, invType, cb)
		if Count <= 0 then
			Logger:Error("Inventory", "[AddSlot] Cannot Add " .. Count .. " of an Item (" .. Owner .. " - " .. invType .. ")")
			return false
		end

		if Slot == nil then
			local freeSlots = Inventory:GetFreeSlotNumbers(Owner, invType)
			if #freeSlots == 0 then
				Logger:Error("Inventory", "[AddSlot] No Available Slots For " .. Owner .. " - " .. invType .. " And Passed Slot Was Nil")
				return false
			end
			Slot = freeSlots[1]
		end

		local p = promise.new()
		Inventory:GetSlot(Owner, Slot, invType, function(result)
			if result then
				Logger:Error("Inventory", "Slot " .. tostring(Slot) .. " Already Exists for " .. Owner)
				p:resolve(false)
				return
			end

			if itemsDatabase[Name] == nil then
				Logger:Error(
					"Inventory",
					string.format("Slot %s in %s (%s) has invalid item %s", Slot, Owner, invType, Name)
				)
				p:resolve(false)
				return
			end

			local doc = {
				Owner = Owner,
				Name = Name,
				Count = Count,
				MetaData = MetaData,
				Slot = Slot,
				invType = invType,
			}
			GlobalState[("inventory:%s:%s:%s"):format(Owner, invType, Slot)] = doc
			local slots = Inventory:GetSlots(Owner, invType)
			table.insert(slots, Slot)
			GlobalState[("inventory:%s:%s:slots"):format(Owner, invType)] = slots
			p:resolve(doc)
		end)
		return Citizen.Await(p)
	end,
	RemoveSlot = function(self, Owner, Slot, invType)
		local p = promise.new()
		Inventory:GetSlot(Owner, Slot, invType, function(result)
			if result == nil then
				Logger:Error("Inventory", "[RemoveSlot] Slot " .. Slot .. " Does Not Exists for " .. Owner)
				p:resolve(false)
				return
			end
			local slots = GlobalState[("inventory:%s:%s:slots"):format(Owner, invType)]
			local newSlots = {}
			for k, v in ipairs(slots) do
				if v ~= Slot then
					table.insert(newSlots, v)
				end
			end

			GlobalState[("inventory:%s:%s:slots"):format(Owner, invType, Slot)] = newSlots
			GlobalState[("inventory:%s:%s:%s"):format(Owner, invType, Slot)] = nil

			p:resolve(true)
		end)
		return Citizen.Await(p)
	end,
	AddToSlot = function(self, Owner, Slot, Count, invType, metaData)
		if Count <= 0 then
			Logger:Error("Inventory", "[AddToSlot] Cannot Add " .. Count .. " of an Item (" .. Owner .. " - " .. invType .. ")")
			return false
		end

		local p = promise.new()
		Inventory:GetSlot(Owner, Slot, invType, function(result)
			if result == nil then
				Logger:Error("Inventory", "[AddToSlot] Slot " .. Slot .. " Does Not Exists for " .. Owner)
				p:resolve(false)
				return
			end

			if metaData?.CreateDate and metaData?.CreateDate < result?.MetaData?.CreateDate then
				result.MetaData.CreateDate = metaData?.CreateDate
			end

			result.Count = (result?.Count or 0) + (Count or 1)
			GlobalState[("inventory:%s:%s:%s"):format(Owner, invType, Slot)] = result
			p:resolve(result)
		end)
		return Citizen.Await(p)
	end,
	DoSlotsMatch = function(self, Left, Right)
		local metaMatch = true

		for k, v in pairs(Left.MetaData) do
			if Right[k] ~= Left[k] then
				metaMatch = false
				break
			end
		end

		for k, v in pairs(Right.MetaData) do
			if Right[k] ~= Left[k] then
				metaMatch = false
				break
			end
		end

		return Left.Name == Right.Name and metaMatch
	end,
	SetMetaDataKey = function(self, owner, invType, slot, key, value)
		local result = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)] or {}
		local meta = result.MetaData or {}
		meta[key] = value
		result.MetaData = meta
		GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)] = result

		if
			invType ~= 10
			and (not LoadedEntitys[tonumber(invType)].isVehicle or (LoadedEntitys[tonumber(invType)].isVehicle and Vehicles.Owned:GetActive(
				owner
			)))
			and not ExistsInRetard(string.format("%s:%s", owner, invType))
		then
			Logger:Trace("Inventory", string.format("Adding ^2%s:%s^7 To Be Saved", owner, invType))
			table.insert(createdInventories, {
				id = string.format("%s:%s", owner, invType),
				owner = owner,
				type = invType,
			})
		end

		return result.MetaData
	end,
	SetManyMetaDataKeys = function(self, owner, invType, slot, kvs)
		local result = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
		local meta = result.MetaData or {}

		for k, v in pairs(kvs) do
			meta[k] = v
		end

		result.MetaData = meta
		GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)] = result

		if
			invType ~= 10
			and (not LoadedEntitys[tonumber(invType)].isVehicle or (LoadedEntitys[tonumber(invType)].isVehicle and Vehicles.Owned:GetActive(
				owner
			)))
			and not ExistsInRetard(string.format("%s:%s", owner, invType))
		then
			Logger:Trace("Inventory", string.format("Adding ^2%s:%s^7 To Be Saved", owner, invType))
			table.insert(createdInventories, {
				id = string.format("%s:%s", owner, invType),
				owner = owner,
				type = invType,
			})
		end

		return result.MetaData
	end,
	UpdateMetaData = function(self, owner, invType, slot, updatingMeta)
		if type(updatingMeta) ~= "table" then
			return false
		end
		local result = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
		local meta = result.MetaData or {}

		for k, v in pairs(updatingMeta) do
			meta[k] = v
		end

		result.MetaData = meta
		GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)] = result

		if
			invType ~= 10
			and (not LoadedEntitys[tonumber(invType)].isVehicle or (LoadedEntitys[tonumber(invType)].isVehicle and Vehicles.Owned:GetActive(
				owner
			)))
			and not ExistsInRetard(string.format("%s:%s", owner, invType))
		then
			Logger:Trace("Inventory", string.format("Adding ^2%s:%s^7 To Be Saved", owner, invType))
			table.insert(createdInventories, {
				id = string.format("%s:%s", owner, invType),
				owner = owner,
				type = invType,
			})
		end

		return result.MetaData
	end,
	SetMetaData = function(self, owner, invType, slot, meta)
		local result = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
		result.MetaData = meta
		GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)] = result

		if
			invType ~= 10
			and (not LoadedEntitys[tonumber(invType)].isVehicle or (LoadedEntitys[tonumber(invType)].isVehicle and Vehicles.Owned:GetActive(
				owner
			)))
			and not ExistsInRetard(string.format("%s:%s", owner, invType))
		then
			Logger:Trace("Inventory", string.format("Adding ^2%s:%s^7 To Be Saved", owner, invType))
			table.insert(createdInventories, {
				id = string.format("%s:%s", owner, invType),
				owner = owner,
				type = invType,
			})
		end

		return result.MetaData
	end,
	Items = {
		GetData = function(self, item)
			return itemsDatabase[item]
		end,
		GetCount = function(self, owner, invType, item)
			local counts = Inventory.Items:GetCounts(owner, invType)
			return counts[item] or 0
		end,
		GetCounts = function(self, owner, invType)
			local counts = {}
			local slots = Inventory:GetSlots(owner, invType)
			for k, slot in ipairs(slots) do
				local slotData = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
				if
					itemsDatabase[slotData.Name].durability == nil
					or ((tonumber(slotData.MetaData.CreateDate or os.time())) + tonumber(itemsDatabase[slotData.Name].durability)) >= os.time()
				then
					counts[slotData.Name] = (counts[slotData.Name] or 0) + slotData.Count
				end
			end
			return counts
		end,
		GetWeights = function(self, owner, invType)
			local weights = 0
			local slots = Inventory:GetSlots(owner, invType)
			for k, slot in ipairs(slots) do
				local slotData = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
				weights = weights + (slotData.Count * itemsDatabase[slotData.Name].weight)
			end
			return weights
		end,
		GetFirst = function(self, Owner, Name, invType)
			local slots = Inventory:GetSlots(Owner, invType)

			local p = promise.new()
			local f = false
			for k, v in ipairs(slots) do
				Inventory:GetSlot(Owner, v, invType, function(slot)
					if slot.Name == Name then
						f = true
						p:resolve(slot)
					end
				end)
			end

			if not f then
				p:resolve(nil)
			end

			return Citizen.Await(p)
		end,
		GetAll = function(self, Owner, Name, invType)
			local slots = Inventory:GetSlots(Owner, invType)

			local p = promise.new()
			local its = {}
			for k, v in ipairs(slots) do
				Inventory:GetSlot(Owner, v, invType, function(slot)
					if slot.Name == Name then
						p:resolve(slot)
					else
						p:resolve(nil)
					end
				end)

				local isItem = Citizen.Await(p)
				if isItem ~= nil then
					table.insert(its, isItem)
				end
			end

			return its
		end,
		Has = function(self, owner, invType, item, count)
			return Inventory.Items:GetCount(owner, invType, item) >= count
		end,
		HasItems = function(self, source, items)
			local player = Fetch:Source(source)
			local char = player:GetData("Character")
			local charId = char:GetData("ID")
			for k, v in ipairs(items) do
				if not Inventory.Items:Has(charId, 1, v.item, v.count) then
					return false
				end
			end
			return true
		end,
		HasAnyItems = function(self, source, items)
			local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
			local char = player:GetData("Character")
			local charId = char:GetData("ID")

			for k, v in ipairs(items) do
				if Inventory.Items:Has(charId, 1, v.item, v.count) then
					return true
				end
			end

			return false
		end,
		GetAllStates = function(self, owner, invType)
			local invStates = {}
			local slots = Inventory:GetSlots(owner, invType)
			for k, slot in ipairs(slots) do
				local slotData = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
				if slotData ~= nil then
					local item = itemsDatabase[slotData.Name]

					if item ~= nil and item.state ~= nil and (item.durability == nil or (os.time() - (slotData?.MetaData?.CreateDate or os.time()) < item.durability)) then
						table.insert(invStates, item.state)
					end
				end
			end
			return invStates
		end,
		HasWithState = function(self, owner, invType, state)
			local allStates = Inventory.Items:GetAllStates(owner, invType)

			if Utils:DoesTableHaveValue(allStates, state) then
				return true
			end
			return false
		end,
		GetAllGangChains = function(self, owner, invType)
			local gangChains = {}
			local slots = Inventory:GetSlots(owner, invType)
			for k, slot in ipairs(slots) do
				local slotData = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
				if slotData ~= nil then
					local item = itemsDatabase[slotData.Name]
					if item ~= nil and item.gangChain ~= nil then
						table.insert(gangChains, item.gangChain)
					end
				end
			end
			return gangChains
		end,
		GetAllOfType = function(self, owner, invType, itemType)
			local its = {}
			local slots = Inventory:GetSlots(owner, invType)
			for k, slot in ipairs(slots) do
				local slotData = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
				if slotData ~= nil then
					local item = itemsDatabase[slotData.Name]
					if item ~= nil and item.type == itemType then
						table.insert(its, item.name)
					end
				end
			end
			return its
		end,
		HasGangChain = function(self, owner, invType, gangChain)
			local gangChains = Inventory.Items:GetAllGangChains(owner, invType)
			return Utils:DoesTableHaveValue(gangChains, gangChain)
		end,
		RegisterUse = function(self, item, id, cb)
			if ItemCallbacks[item] == nil then
				ItemCallbacks[item] = {}
			end
			ItemCallbacks[item][id] = cb
		end,
		Use = function(self, source, item, cb)
			if not itemsDatabase[item.Name]?.isUsable or _inUse[source] then
				return cb(false)
			end

			local itemData = itemsDatabase[item.Name]
			if
				not itemData.durability
				or item.MetaData ~= nil
					and item.MetaData.CreateDate ~= nil
					and item.MetaData.CreateDate + itemData.durability > os.time()
			then
				if itemData.closeUi then
					TriggerClientEvent("Inventory:CloseUI", source)
				end

				if
					itemData.useRestrict == nil
					or (itemData.useRestrict.job ~= nil and Jobs.Permissions:HasJob(
						source,
						itemData.useRestrict.job.id,
						itemData.useRestrict.job.workplace or false,
						itemData.useRestrict.job.grade or false,
						false,
						false,
						itemData.useRestrict.job.permissionKey or false
					) and (not itemData.useRestrict.job.duty or Player(source).state.onDuty == itemData.useRestrict.job.id))
					or (itemData.useRestrict.state and hasValue(char:GetData("States"), itemData.useRestrict.state))
					or (itemData.useRestrict.rep ~= nil and Reputation:GetLevel(source, itemData.useRestrict.rep.id) >= itemData.useRestrict.rep.level)
					or (itemData.useRestrict.character ~= nil and itemData.useRestrict.character == char:GetData("ID"))
					or (itemData.useRestrict.admin and plyr.Permissions:IsAdmin())
				then
					_inUse[source] = true
					TriggerClientEvent("Inventory:Client:InUse", source, _inUse[source])
					TriggerClientEvent("Inventory:Client:Changed", source, "used", item.Name, 0)

					local used = true
					if itemData.animConfig ~= nil then
						used = false
						local p = promise.new()
						Callbacks:ClientCallback(source, "Inventory:ItemUse", itemData.animConfig, function(state)
							p:resolve(state)
						end)
						used = Citizen.Await(p)
					end

					if used then
						local retard = false
						if ItemCallbacks[item.Name] ~= nil then
							for k, callback in pairs(ItemCallbacks[item.Name]) do
								retard = true
								callback(source, item, itemsDatabase[item.Name])
							end
						elseif itemData.imitate and ItemCallbacks[itemData.imitate] ~= nil then
							for k, callback in pairs(ItemCallbacks[itemData.imitate]) do
								retard = true
								callback(source, item, itemsDatabase[item.Name])
							end
						end

						if retard then
							TriggerClientEvent("Markers:ItemAction", source, item)
						end
					end

					local char = Fetch:Source(source):GetData("Character")
					sendRefreshForClient(source, char:GetData("ID"), 1, item.Slot)
					_inUse[source] = false
					TriggerClientEvent("Inventory:Client:InUse", source, _inUse[source])
					cb(used)
				else
					Execute:Client(source, "Notification", "Error", "You Can't Use That")
					cb(false)
				end

			else
				cb(false)
			end
		end,
		Remove = function(self, owner, invType, item, count)
			count = count or 1

			local ocount = count
			local slots = Inventory:GetSlots(owner, invType)
			local itemCount = 0
			for k, slot in ipairs(slots) do
				local slotData = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, slot)]
				if slotData.Name == item then
					if slotData.Count > count then
						Inventory:RemoveAmount(owner, slotData.Slot, count, invType)
						count = 0
						break
					else
						Inventory:RemoveSlot(owner, slotData.Slot, invType)
						count = count - slotData.Count
					end
				end
			end

			if invType == 1 and count == 0 then
				local plyr = Fetch:CharacterData("ID", owner)
				TriggerClientEvent("Inventory:Client:Changed", plyr:GetData("Source"), "removed", item, ocount)
				UpdateCharacterItemStates(plyr:GetData("Source"))

				if itemsDatabase[item].gangChain ~= nil and plyr:GetData("Character"):GetData("GangChain") == itemsDatabase[item].gangChain then
					UpdateCharacterGangChain(source)
				end
			end

			return count == 0
		end,
		RemoveList = function(self, owner, invType, items)
			for k, v in ipairs(items) do
				Inventory.Items:Remove(owner, invType, v.name, v.count)
			end
		end,
		GetWithStaticMetadata = function(self, masterKey, mainIdName, textureIdName, gender, data)
			for k, v in pairs(itemsDatabase) do
				if v.staticMetadata ~= nil
					and v.staticMetadata[masterKey] ~= nil
					and v.staticMetadata[masterKey][gender] ~= nil
					and v.staticMetadata[masterKey][gender][mainIdName] == data[mainIdName]
					and v.staticMetadata[masterKey][gender][textureIdName] == data[textureIdName]
				then
					return k
				end
			end

			return nil
		end,
	},
	Holding = {
		Put = function(self, source)
			Citizen.CreateThread(function()
				local p = promise.new()
				local plyr = Fetch:Source(source)
				if plyr ~= nil then
					local char = plyr:GetData("Character")
					if char ~= nil then
						local slots = Inventory:GetSlots(char:GetData("ID"), 1)
						local freeSlots = Inventory:GetFreeSlotNumbers(char:GetData("ID"), 2)
						for k, slot in ipairs(slots) do
							if #freeSlots >= k then
								local slotData = GlobalState[("inventory:%s:%s:%s"):format(char:GetData("ID"), 1, slot)]
								DoMove(source, {
									name = slotData.Name,
									ownerFrom = char:GetData("ID"),
									slotFrom = slot,
									invTypeFrom = 1,
									ownerTo = char:GetData("ID"),
									slotTo = freeSlots[k],
									invTypeTo = 2,
									countTo = slotData.Count,
								}, function() end)
								Citizen.Wait(1)
							else
								Execute:Client(source, "Notification", "Error", "No Available Slots")
								break
							end
						end
						p:resolve(true)
					end
				end
				Citizen.Await(p)
			end)
		end,
		Take = function(self, source)
			Citizen.CreateThread(function()
				local p = promise.new()
				local plyr = Fetch:Source(source)
				if plyr ~= nil then
					local char = plyr:GetData("Character")
					if char ~= nil then
						local slots = Inventory:GetSlots(char:GetData("ID"), 2)

						if #slots > 0 then
							local freeSlots = Inventory:GetFreeSlotNumbers(char:GetData("ID"), 1)
							for k, slot in ipairs(slots) do
								local slotData = GlobalState[("inventory:%s:%s:%s"):format(char:GetData("ID"), 2, slot)]
								if #freeSlots >= k then
									DoMove(source, {
										name = slotData.Name,
										ownerFrom = char:GetData("ID"),
										slotFrom = slot,
										invTypeFrom = 2,
										ownerTo = char:GetData("ID"),
										slotTo = freeSlots[k],
										invTypeTo = 1,
										countTo = slotData.Count,
									}, function() end)
									Citizen.Wait(1)
								else
									Execute:Client(source, "Notification", "Error", "No Available Slots")
									p:resolve(false)
									return
								end
							end
							Execute:Client(source, "Notification", "Success", "Retreived Items")
						else
							Execute:Client(source, "Notification", "Error", "No Items To Retreive")
						end
						p:resolve(true)
					end
				end
				Citizen.Await(p)
			end)
		end,
	},
	Container = {
		Open = function(self, src, item, identifier)
			Callbacks:ClientCallback(src, "Inventory:Container:Open", {
				item = item,
				container = ("container:%s"):format(identifier),
			}, function()
				Inventory:OpenSecondary(src, itemsDatabase[item.Name].container, ("container:%s"):format(identifier))
			end)
		end,
	},
	Stash = {
		Open = function(self, src, invType, identifier)
			Inventory:OpenSecondary(src, invType, ("stash:%s"):format(identifier))
		end,
	},
	Shop = {
		Open = function(self, src, identifier)
			Inventory:OpenSecondary(src, 11, ("shop:%s"):format(identifier))
		end,
	},
	Search = {
		Character = function(self, src, tSrc, id)
			Callbacks:ClientCallback(tSrc, "Inventory:ForceClose", {}, function(state)
				_openInvs[string.format("%s-%s", 1, id)] = false
				Execute:Client(tSrc, "Notification", "Info", "You Were Searched")
				Inventory:OpenSecondary(src, 1, id)
			end)
		end,
	},
	Rob = function(self, src, tSrc, id)
		Callbacks:ClientCallback(tSrc, "Inventory:ForceClose", {}, function(state)
			_openInvs[string.format("%s-%s", 1, id)] = false
			Inventory:OpenSecondary(src, 1, id)
		end)
	end,
	Poly = {
		Create = function(self, data)
			table.insert(_polyInvs, data.id)
			GlobalState[string.format("Inventory:%s", data.id)] = data
		end,
		-- Add = {
		-- 	Box = function(self, id, coords, length, width, options, entityId, restrictions)

		-- 	end,
		-- 	Poly = function(self) end,
		-- 	Circle = function(self) end,
		-- },
		Remove = function(self, id) end,
	},
	IsOpen = function(self, invType, id)
		return _openInvs[string.format("%s-%s", invType, id)]
	end,
	PrintSlots = function(self, owner, invType)
		local slots = Inventory:GetSlots(owner, invType)

		local total = getSlotCount(invType, false, false)

		for i = 1, total+1, 1 do
			local slot = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, i)]
			print(string.format("_____SLOT %s_____", i))
			print(json.encode(slot or {}, { indent = true }))
			print(string.format("_____SLOT %s_____", i))
		end

		print(string.format("Inventory: %s:%s, Pending Save: %s", owner, invType, tostring(ExistsInRetard(string.format("%s:%s", owner, invType)))))
	end,
	PrintSlots2 = function(self, owner, invType)
		local slots = Inventory:GetSlots(owner, invType)
		for k, v in ipairs(slots) do
			local slot = GlobalState[("inventory:%s:%s:%s"):format(owner, invType, v)]
			print(string.format("_____SLOT %s_____", v))
			print(json.encode(slot or {}, { indent = true }))
			print(string.format("_____SLOT %s_____", v))
		end
		print(string.format("Inventory: %s:%s, Pending Save: %s", owner, invType, tostring(ExistsInRetard(string.format("%s:%s", owner, invType)))))
	end,
}

function UpdateCharacterItemStates(source, adding)
	local player = Fetch:Source(source)
	local char = player:GetData("Character")
	if not player or not char then
		return
	end
	local changedState = false
	local playerStates = char:GetData("States") or {}
	local allInventoryStates = Inventory.Items:GetAllStates(char:GetData("ID"), 1)

	if adding then
		for item, itemState in pairs(allInventoryStates) do
			if not Utils:DoesTableHaveValue(playerStates, itemState) then
				table.insert(playerStates, itemState)
				changedState = true
			end
		end
	end

	local s = {}
	for i = #playerStates, 1, -1 do
		if
			not Utils:DoesTableHaveValue(allInventoryStates, playerStates[i])
			and string.sub(playerStates[i], 1, string.len("SCRIPT")) ~= "SCRIPT"
			and string.sub(playerStates[i], 1, string.len("ACCESS")) ~= "ACCESS"
		then
			table.remove(playerStates, i)
			changedState = true
		end
	end

	if changedState then
		char:SetData("States", playerStates)
	end
end


function UpdateCharacterGangChain(source)
	local player = Fetch:Source(source)
	local char = player:GetData("Character")
	if not player or not char then
		return
	end

	local myGangChain = char:GetData("GangChain") or nil
	if myGangChain ~= nil and not Inventory.Items:HasGangChain(char:GetData("ID"), 1, myGangChain) then
		char:SetData("GangChain", "NONE")
	end
end