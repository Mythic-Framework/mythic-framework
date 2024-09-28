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

_dropzones = {}

local _defInvSettings = {
	muted = false,
	useBank = true,
}

function split(pString, pPattern)
	local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
	   if s ~= 1 or cap ~= "" then
	  table.insert(Table,cap)
	   end
	   last_end = e+1
	   s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
	   cap = pString:sub(last_end)
	   table.insert(Table, cap)
	end
	return Table
end

function BuildMetaDataTable(cData, item)
	local itemExist = itemsDatabase[item]
	local MetaData = {}

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
	elseif itemExist.name == "govid" then
		local genStr = "Male"
		if cData.Gender == 1 then
			genStr = "Female"
		end
		MetaData.Name = string.format("%s %s", cData.First, cData.Last)
		MetaData.Gender = genStr
		MetaData.PassportID = cData.User
		MetaData.StateID = cData.SID
		MetaData.DOB = cData.DOB
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
	elseif itemExist.name == "meth_bag" or itemExist.name == "meth_brick" or itemExist.name == "coke_bag" or itemExist.name == "coke_brick" then
		if not quality then
			quality = math.random(1, 100)
		end
		if itemExist.name == "meth_brick" then
			MetaData.Finished = os.time() + (60 * 60 * 24)
		end
	elseif itemExist.name == "paleto_access_codes" and not MetaData.AccessCodes then
		MetaData.AccessCodes = {
			Robbery:GetAccessCodes('paleto')[1]
		}
	end

	return MetaData
end

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
	Drugs = exports["mythic-base"]:FetchComponent("Drugs")
	Robbery = exports["mythic-base"]:FetchComponent("Robbery")
	Laptop = exports["mythic-base"]:FetchComponent("Laptop")
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
		"Drugs",
		"Robbery",
		"Laptop"
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		LoadItems()
		LoadSchematics()
		RegisterCallbacks()
		LoadEntityTypes()
		LoadShops()
		SetupGarbage()

		ClearDropZones()
		ClearBrokenItems()
		CleanupExpiredCooldowns()
		LoadCraftingCooldowns()

		RegisterCommands()
		RegisterStashCallbacks()
		RegisterTestBench()
		RegisterCraftingCallbacks()

        local f = Banking.Accounts:GetOrganization("government")
        _govAccount = f.Account

		Middleware:Add("Characters:Spawning", function(source)
			TriggerClientEvent("Inventory:Client:PolySetup", source, _polyInvs)

			local player = Fetch:Source(source)
			local char = player:GetData("Character")
			local sid = char:GetData("SID")
			
			refreshShit(sid, true)

			if char:GetData("InventorySettings") == nil then
				char:SetData("InventorySettings", _defInvSettings)
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
			TriggerClientEvent("Inventory:Client:DropzoneForceUpdate", source, _dropzones)
		end, 2)

		Middleware:Add("Characters:Logout", function(source)
			local p = promise.new()

			for k, v in pairs(_openInvs) do
				if v == source then
					_openInvs[k] = false
				end
			end

			Callbacks:ClientCallback(source, "Weapons:Logout", {}, function(data)
				if data ~= nil then
					Weapons:Save(source, data.slot, data.ammo, data.clip)
				end
				p:resolve(true)
			end)
			return Citizen.Await(p)
		end, 1)

		Middleware:Add("playerDropped", function(source)
			for k, v in pairs(_openInvs) do
				if v == source then
					_openInvs[k] = false
				end
			end

			return true
		end, 1)

		Middleware:Add("Characters:Created", function(source, cData)
			local player = Fetch:Source(source)
			local docs = {}

			local slot = 1
			for k, v in ipairs(Config.StartItems) do
				local metadata = BuildMetaDataTable(cData, v.name)
				Inventory:CreateItemWithNoMeta(cData.SID, v.name, v.count, slot, metadata, 1, true)
				slot += 1
			end

			return true
		end, 2)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Inventory", INVENTORY)
end)

RegisterServerEvent("Inventory:server:closePlayerInventory", function()
	local src = source
	local char = Fetch:Source(src):GetData("Character")
	if char ~= nil then
		_openInvs[string.format("%s-%s", char:GetData("SID"), 1)] = false
		refreshShit(char:GetData("SID"), true)
	end
end)

function sendRefreshForClient(_src, owner, invType, slot)
	--local data = Inventory:GetSlot(owner, slot, invType)
	TriggerClientEvent("Inventory:Client:SetSlot", _src, owner, invType, slot)
end

function refreshShit(sid, adding)
	local plyr = Fetch:SID(tonumber(sid))
	if plyr ~= nil then
		local source = plyr:GetData("Source")
		local char = plyr:GetData("Character")
		if char ~= nil then
			local inventory = getInventory(source, sid, 1)

			UpdateCharacterItemStates(source, inventory, true)
			UpdateCharacterGangChain(source, inventory)

			TriggerClientEvent("Inventory:Client:Cache", source, {
				size = (LoadedEntitys[1].slots or 10),
				name = char:GetData("First") .. " " .. char:GetData("Last"),
				inventory = inventory,
				invType = 1,
				capacity = LoadedEntitys[1].capacity,
				owner = sid,
				isWeaponEligble = Weapons:IsEligible(source),
				qualifications = char:GetData("Qualifications") or {},
			}, _refreshAttchs[sid] ~= nil)

			_refreshAttchs[sid] = nil
		end
	end
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

function getInventory(src, Owner, Type, limit)
	if LoadedEntitys[tonumber(Type)].shop then
		local char = Fetch:Source(src):GetData("Character")

		local items = {}
		if entityPermCheck(src, Type) then
			for k, v in ipairs(Config.ShopItemSets[LoadedEntitys[Type].itemSet]) do
				if itemsDatabase[v] ~= nil then
					local stack = itemsDatabase[v].storeStack or itemsDatabase[v].isStackable

					if not itemsDatabase[v].isStackable then
						stack = 1
					end

					if itemsDatabase[v].isStackable and stack > itemsDatabase[v].isStackable then
						stack = itemsDatabase[v].isStackable
					end

					local doc = {
						Slot = #items + 1,
						Label = itemsDatabase[v].label,
						Count = stack,
						Name = v,
						invType = 11,
						Quality = nil,
						MetaData = {},
						Owner = tostring(Owner),
						Price = itemsDatabase[v].price,
					}

					table.insert(items, doc)
				end
			end
		end
		return items
	else
		return MySQL.query.await('SELECT id, count(id) as Count, name as Owner, item_id as Name, dropped as Temp, MAX(quality) as Quality, information as MetaData, slot as Slot, MIN(creationDate) AS CreateDate FROM inventory WHERE NAME = ? GROUP BY slot ORDER BY slot ASC', {
			string.format("%s-%s", Owner, Type)
		}) or {}
	end
end

function getSlotCount(invType, vehClass, vehModel, override)
	if override then
		return override
	end

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

function getCapacity(invType, vehClass, vehModel, override)
	if override then
		return override
	end

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

function CreateStoreLog(inventory, item, count, buyer, metadata, itemId)
	MySQL.insert('INSERT INTO inventory_shop_logs (inventory, item, count, buyer, metadata, itemId) VALUES(?, ?, ?, ?, ?, ?)', {
		inventory, item, count, buyer, json.encode(metadata), itemId
	})
end

function DoMerge(source, data, cb)
	CreateThread(function()
		local player = Fetch:Source(source)
		local char = player:GetData("Character")
	
		local item = itemsDatabase[data.name]
		local cash = char:GetData("Cash")
	
		local entityFrom = LoadedEntitys[tonumber(data.invTypeFrom)]
		local entityTo = LoadedEntitys[tonumber(data.invTypeTo)]
	
		local invWeight = Inventory.Items:GetWeights(data.ownerTo, data.invTypeTo)
		local totWeight = invWeight + (data.countTo * itemsDatabase[data.name].weight)
	
		if data.ownerFrom == nil or data.slotFrom == nil or data.invTypeFrom == nil or data.ownerTo == nil or data.slotTo == nil or data.invTypeTo == nil then
			cb({ reason = "Invalid Move Data" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end
	
		if totWeight > getCapacity(data.invTypeTo, data.vehClassTo, data.vehModelTo, data.capacityOverrideTo) and data.ownerFrom ~= data.ownerTo then
			cb({ reason = "Inventory Over Weight" })
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			return
		end
	
		if data.countTo <= 0 then
			cb({ reason = "Can't Move 0 - Naughty Boy" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end
	
		if entityFrom.shop then
			local cost = math.ceil((item.price * tonumber(data.countTo)))
			local paymentType = (cash >= cost and 'cash' or (Banking.Balance:Has(char:GetData("BankAccount"), cost) and 'bank' or nil))
			if entityFrom.free or paymentType ~= nil then
				if -- Check if the item is either not a gun, or if it is that they have a Weapons license
					(item.type ~= 2
					or (
						item.type == 2
						and (not item.requiresLicense or item.requiresLicense and Weapons:IsEligible(source))
					))
					and (not item.qualification or hasValue(char:GetData("Qualifications"), item.qualification))
				then
					local paid = entityFrom.free
	
					if not paid then
						if paymentType == 'cash' then
							paid = Wallet:Modify(source, -(math.abs(cost)))
						else
							paid = Banking.Balance:Charge(char:GetData("BankAccount"), cost, {
								type = 'bill',
								title = 'Store Purchase',
								description = string.format('Bought x%s %s', data.countTo, item.label),
								data = {}
							})
							Phone.Notification:Add(source, "Bill Payment Successful", false, os.time() * 1000, 3000, "bank", {})
						end
	
						if paid then
							pendingShopDeposits[storeBankAccounts[entityFrom.id]] = pendingShopDeposits[storeBankAccounts[entityFrom.id]] or { amount = 0, transactions = 0 }
							pendingShopDeposits[storeBankAccounts[entityFrom.id]].amount += math.floor( (cost * STORE_SHARE_AMOUNT) )
							pendingShopDeposits[storeBankAccounts[entityFrom.id]].transactions += 1
	
							pendingShopDeposits[_govAccount] = pendingShopDeposits[_govAccount] or { amount = 0, transactions = 0, tax = true }
							pendingShopDeposits[_govAccount].amount += math.ceil(cost * (1.0 - STORE_SHARE_AMOUNT))
							pendingShopDeposits[_govAccount].transactions += 1
						end
					end
	
					if paid then
						local insData = Inventory:CreateItem(char:GetData("SID"), data.name, data.countTo, data.slotTo, {}, data.invTypeTo, false)
						CreateStoreLog(data.ownerFrom, data.name, data.countTo or 1, char:GetData("SID"), insData.metadata, insData.id)
					end
	
					sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
					sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
					return cb({ success = true })
				else
					sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
					sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
					cb({ reason = "Ineligible To Purchase Item" })
				end
			else
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				cb({ reason = "Not Enough Cash" })
			end
		else
			local slotFrom = Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
			local slotTo = Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

			if slotFrom == nil or slotTo == nil then
				cb({ reason = "Item No Longer In That Slot" })
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				return
			end

			MySQL.query.await('UPDATE inventory SET slot = ?, name = ?, dropped = ? WHERE name = ? AND slot = ? AND item_id = ?', {
				data.slotTo,
				string.format("%s-%s", data.ownerTo, data.invTypeTo),
				data.invTypeTo == 10 and 1 or 0,
				string.format("%s-%s", data.ownerFrom, data.invTypeFrom),
				data.slotFrom,
				data.name,
			})
			
			if data.ownerFrom ~= data.ownerTo then
				if data.invTypeFrom == 1 then
					local plyr = Fetch:SID(data.ownerFrom)
	
					if data.ownerFrom == data.ownerTo then
						if item.type == 2 then
							if (not item.isStackable and item.isStackable ~= -1) or data.countTo == slotFrom.Count then
								TriggerClientEvent(
									"Weapons:Client:Move",
									plyr:GetData("Source"),
									data.slotFrom,
									data.slotTo
								)
							end
							
							if item.isThrowable then
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
						elseif item.type == 10 then
							TriggerClientEvent(
								"Inventory:Container:Move",
								plyr:GetData("Source"),
								data.slotFrom,
								data.slotTo
							)
						end
					else
						if not item.isStackable or data.countTo == slotFrom.Count then
							if item.type == 2 then
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
							elseif item.type == 10 then
								TriggerClientEvent(
									"Inventory:Container:Remove",
									plyr:GetData("Source"),
									slotFrom,
									data.slotFrom
								)
							end
						else
							if item.isThrowable then
								TriggerClientEvent(
									"Weapons:Client:UpdateCount",
									plyr:GetData("Source"),
									data.slotFrom,
									(slotFrom.Count - data.countTo)
								)
							end
						end
					end
				end
		
				if data.invTypeTo == 1 then
					local plyr = Fetch:SID(data.ownerTo)
					if item.isThrowable then
						TriggerClientEvent(
							"Weapons:Client:UpdateCount",
							plyr:GetData("Source"),
							data.slotTo,
							((slotTo?.Count or 0) + data.countTo)
						)
					end
				end

				if data.inventory.position ~= nil then
					CreateDZIfNotExist(source, data.inventory.position)
				end
			end

			if data.ownerFrom ~= data.ownerTo and WEAPON_PROPS[item.name] ~= nil then
				_refreshAttchs[data.ownerFrom] = source
				_refreshAttchs[data.ownerTo] = source
			end

			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)

			return cb({ success = true })
		end
	end)
end

function DoSwap(source, data, cb)
	CreateThread(function()
		local player = Fetch:Source(source)
		local char = player:GetData("Character")
	
		local item = itemsDatabase[data.name]
		local cash = char:GetData("Cash")
	
		local entityFrom = LoadedEntitys[tonumber(data.invTypeFrom)]
		local entityTo = LoadedEntitys[tonumber(data.invTypeTo)]
	
		local invWeight = Inventory.Items:GetWeights(data.ownerTo, data.invTypeTo)
		local totWeight = invWeight + (data.countTo * itemsDatabase[data.name].weight)
	
		if data.ownerFrom == nil or data.slotFrom == nil or data.invTypeFrom == nil or data.ownerTo == nil or data.slotTo == nil or data.invTypeTo == nil then
			cb({ reason = "Invalid Move Data" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end
	
		if totWeight > getCapacity(data.invTypeTo, data.vehClassTo, data.vehModelTo, data.capacityOverrideTo) and data.ownerFrom ~= data.ownerTo then
			cb({ reason = "Inventory Over Weight" })
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			return
		end
	
		if data.countTo <= 0 then
			cb({ reason = "Can't Move 0 - Naughty Boy" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end
	
		if entityFrom.shop then
			cb({ reason = "Illegal Operation" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		else
			local slotFrom = Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
			local slotTo = Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

			if slotFrom == nil or slotTo == nil then
				cb({ reason = "Item No Longer In That Slot" })
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				return
			end
	
			MySQL.query.await('UPDATE inventory SET slot = ?, name = ?, dropped = ? WHERE name = ? AND slot = ?', {
				data.slotTo,
				string.format("%s-%s-PH-%s", data.ownerTo, data.invTypeTo, data.slotTo),
				data.invTypeTo == 10 and 1 or 0,
				string.format("%s-%s", data.ownerFrom, data.invTypeFrom),
				data.slotFrom,
			})

			MySQL.query.await('UPDATE inventory SET slot = ?, name = ?, dropped = ? WHERE name = ? AND slot = ?', {
				data.slotFrom,
				string.format("%s-%s", data.ownerFrom, data.invTypeFrom),
				data.invTypeFrom == 10 and 1 or 0,
				string.format("%s-%s", data.ownerTo, data.invTypeTo),
				data.slotTo,
			})
			
			MySQL.query.await('UPDATE inventory SET name = ? WHERE name = ?', {
				string.format("%s-%s", data.ownerTo, data.invTypeTo),
				string.format("%s-%s-PH-%s", data.ownerTo, data.invTypeTo, data.slotTo),
			})
			

			if data.ownerFrom ~= data.ownerTo then

				if data.invTypeFrom == 1 then
					local plyr = Fetch:SID(data.ownerFrom)
	
					if data.ownerFrom == data.ownerTo then
						if item.type == 2 then
							if (not item.isStackable and item.isStackable ~= -1) or data.countTo == slotFrom.Count then
								TriggerClientEvent(
									"Weapons:Client:Move",
									plyr:GetData("Source"),
									data.slotFrom,
									data.slotTo
								)
							end
							
							if item.isThrowable then
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
						elseif item.type == 10 then
							TriggerClientEvent(
								"Inventory:Container:Move",
								plyr:GetData("Source"),
								data.slotFrom,
								data.slotTo
							)
						end
					else
						if not item.isStackable or data.countTo == slotFrom.Count then
							if item.type == 2 then
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
							elseif item.type == 10 then
								TriggerClientEvent(
									"Inventory:Container:Remove",
									plyr:GetData("Source"),
									slotFrom,
									data.slotFrom
								)
							end
						else
							if item.isThrowable then
								TriggerClientEvent(
									"Weapons:Client:UpdateCount",
									plyr:GetData("Source"),
									data.slotFrom,
									(slotFrom.Count - data.countTo)
								)
							end
						end
					end
				end
		
				if data.invTypeTo == 1 then
					local plyr = Fetch:SID(data.ownerTo)
					if item.isThrowable then
						TriggerClientEvent(
							"Weapons:Client:UpdateCount",
							plyr:GetData("Source"),
							data.slotTo,
							((slotTo?.Count or 0) + data.countTo)
						)
					end
				end

				if data.inventory.position ~= nil then
					CreateDZIfNotExist(source, data.inventory.position)
				end
			end

			if data.ownerFrom ~= data.ownerTo and WEAPON_PROPS[item.name] ~= nil then
				_refreshAttchs[data.ownerFrom] = source
				_refreshAttchs[data.ownerTo] = source
			end

			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)

			return cb({ success = true })
		end
	end)
end

function DoMove(source, data, cb)
	CreateThread(function()
		local player = Fetch:Source(source)
		local char = player:GetData("Character")
	
		local item = itemsDatabase[data.name]
		local cash = char:GetData("Cash")
	
		local entityFrom = LoadedEntitys[tonumber(data.invTypeFrom)]
		local entityTo = LoadedEntitys[tonumber(data.invTypeTo)]
	
		local invWeight = Inventory.Items:GetWeights(data.ownerTo, data.invTypeTo)
		local totWeight = invWeight + (data.countTo * itemsDatabase[data.name].weight)
	
		if data.ownerFrom == nil or data.slotFrom == nil or data.invTypeFrom == nil or data.ownerTo == nil or data.slotTo == nil or data.invTypeTo == nil then
			cb({ reason = "Invalid Move Data" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end
	
		if totWeight > getCapacity(data.invTypeTo, data.vehClassTo, data.vehModelTo, data.capacityOverrideTo) and data.ownerFrom ~= data.ownerTo then
			cb({ reason = "Inventory Over Weight" })
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			return
		end
	
		if data.countTo <= 0 then
			cb({ reason = "Can't Move 0 - Naughty Boy" })
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
			return
		end
	
		if entityFrom.shop then
			local cost = math.ceil((item.price * tonumber(data.countTo)))
			local paymentType = (cash >= cost and 'cash' or (Banking.Balance:Has(char:GetData("BankAccount"), cost) and 'bank' or nil))
			if entityFrom.free or paymentType ~= nil then
				if -- Check if the item is either not a gun, or if it is that they have a Weapons license
					(item.type ~= 2
					or (
						item.type == 2
						and (not item.requiresLicense or item.requiresLicense and Weapons:IsEligible(source))
					))
					and (not item.qualification or hasValue(char:GetData("Qualifications"), item.qualification))
				then
					local paid = entityFrom.free
					if not paid then
						if paymentType == 'cash' then
							paid = Wallet:Modify(source, -(math.abs(cost)))
						else
							paid = Banking.Balance:Charge(char:GetData("BankAccount"), cost, {
								type = 'bill',
								title = 'Store Purchase',
								description = string.format('Bought x%s %s', data.countTo, item.label),
								data = {}
							})
							Phone.Notification:Add(source, "Bill Payment Successful", string.format('Bought x%s %s', data.countTo, item.label), os.time() * 1000, 3000, "bank", {})
						end

						if paid then
							pendingShopDeposits[storeBankAccounts[entityFrom.id]] = pendingShopDeposits[storeBankAccounts[entityFrom.id]] or { amount = 0, transactions = 0 }
							pendingShopDeposits[storeBankAccounts[entityFrom.id]].amount += math.floor( (cost * STORE_SHARE_AMOUNT) )
							pendingShopDeposits[storeBankAccounts[entityFrom.id]].transactions += 1
	
							pendingShopDeposits[_govAccount] = pendingShopDeposits[_govAccount] or { amount = 0, transactions = 0, tax = true }
							pendingShopDeposits[_govAccount].amount += math.ceil(cost * (1.0 - STORE_SHARE_AMOUNT))
							pendingShopDeposits[_govAccount].transactions += 1
						end
					end
	
					if paid then
						local insData = Inventory:CreateItem(char:GetData("SID"), data.name, data.countTo, data.slotTo, {}, data.invTypeTo, false)
						CreateStoreLog(data.ownerFrom, data.name, data.countTo or 1, char:GetData("SID"), insData.metadata, insData.id)
					end

					if data.ownerFrom ~= data.ownerTo and WEAPON_PROPS[item.name] ~= nil then
						_refreshAttchs[data.ownerFrom] = source
						_refreshAttchs[data.ownerTo] = source
					end
	
					sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
					sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
					return cb({ success = true })
				else
					sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
					sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
					cb({ reason = "Ineligible To Purchase Item" })
				end
			else
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				cb({ reason = "Not Enough Cash" })
			end
		else
			local slotFrom = Inventory:GetSlot(data.ownerFrom, data.slotFrom, data.invTypeFrom)
			local slotTo = Inventory:GetSlot(data.ownerTo, data.slotTo, data.invTypeTo)

			if slotFrom == nil then
				cb({ reason = "Item No Longer In That Slot" })
				sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
				sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)
				return
			end

			if data.isSplit then
				local itemIds = MySQL.query.await('SELECT id FROM inventory WHERE name = ? AND slot = ? AND item_id = ? ORDER BY id ASC LIMIT ?', {
					string.format("%s-%s", data.ownerFrom, data.invTypeFrom),
					data.slotFrom,
					data.name,
					data.countTo
				})

				local params = {}
				for k, v in ipairs(itemIds) do
					table.insert(params, v.id)
				end
				
				MySQL.query.await(string.format('UPDATE inventory SET slot = ?, name = ?, dropped = ? WHERE id IN (%s)', table.concat(params, ',')), {
					data.slotTo,
					string.format("%s-%s", data.ownerTo, data.invTypeTo),
					data.invTypeTo == 10 and 1 or 0
				})
			else
				MySQL.query.await('UPDATE inventory SET slot = ?, name = ?, dropped = ? WHERE name = ? AND slot = "?" AND item_id = ?', {
					data.slotTo,
					string.format("%s-%s", data.ownerTo, data.invTypeTo),
					(data.invTypeTo == 10 and 1 or 0),
					string.format("%s-%s", data.ownerFrom, data.invTypeFrom),
					data.slotFrom,
					data.name,
				})
			end
			
			if data.ownerFrom ~= data.ownerTo then
				if data.invTypeFrom == 1 then
					local plyr = Fetch:SID(data.ownerFrom)
	
					if data.ownerFrom == data.ownerTo then
						if item.type == 2 then
							if (not item.isStackable and item.isStackable ~= -1) or data.countTo == slotFrom.Count then
								TriggerClientEvent(
									"Weapons:Client:Move",
									plyr:GetData("Source"),
									data.slotFrom,
									data.slotTo
								)
							end
							
							if item.isThrowable then
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
						elseif item.type == 10 then
							TriggerClientEvent(
								"Inventory:Container:Move",
								plyr:GetData("Source"),
								data.slotFrom,
								data.slotTo
							)
						end
					else
						if not item.isStackable or data.countTo == slotFrom.Count then
							if item.type == 2 then
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
							elseif item.type == 10 then
								TriggerClientEvent(
									"Inventory:Container:Remove",
									plyr:GetData("Source"),
									slotFrom,
									data.slotFrom
								)
							end
						else
							if item.isThrowable then
								TriggerClientEvent(
									"Weapons:Client:UpdateCount",
									plyr:GetData("Source"),
									data.slotFrom,
									(slotFrom.Count - data.countTo)
								)
							end
						end
					end
				end
		
				if data.invTypeTo == 1 then
					local plyr = Fetch:SID(data.ownerTo)
					if item.isThrowable then
						TriggerClientEvent(
							"Weapons:Client:UpdateCount",
							plyr:GetData("Source"),
							data.slotTo,
							((slotTo?.Count or 0) + data.countTo)
						)
					end
				end

				if data.inventory.position ~= nil then
					CreateDZIfNotExist(source, data.inventory.position)
				end
			end

			if data.ownerFrom ~= data.ownerTo and WEAPON_PROPS[item.name] ~= nil then
				_refreshAttchs[data.ownerFrom] = source
				_refreshAttchs[data.ownerTo] = source
			end
		
			sendRefreshForClient(source, data.ownerFrom, data.invTypeFrom, data.slotFrom)
			sendRefreshForClient(source, data.ownerTo, data.invTypeTo, data.slotTo)

			return cb({ success = true })
		end
	end)
end

function CreateDZIfNotExist(source, coords)
	local id = string.format("%s:%s", math.ceil(coords.x), math.ceil(coords.y))
	local route = Player(source).state.currentRoute
	if not Inventory:DropExists(route, id) then
		Inventory:CreateDropzone(route, coords)
	end
end

function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Inventory:MergeItem", DoMerge)
	Callbacks:RegisterServerCallback("Inventory:SwapItem", DoSwap)
	Callbacks:RegisterServerCallback("Inventory:MoveItem", DoMove)

	Callbacks:RegisterServerCallback("Inventory:OpenTrunk", function(source, data, cb)
		local myCoords = GetEntityCoords(GetPlayerPed(source))
		local veh = NetworkGetEntityFromNetworkId(data.netId)

		if Entity(veh).state.VIN == nil then
			return cb(false)
		end

		local vehCoords = GetEntityCoords(veh)
		local dist = #(vector3(myCoords.x, myCoords.y, myCoords.z) - vector3(vehCoords.x, vehCoords.y, vehCoords.z))
		local lock = GetVehicleDoorLockStatus(veh)
		if dist < 8 and (lock == 0 or lock == 1) then
			Inventory:OpenSecondary(source, 4, Entity(veh).state.VIN, data.class or false, data.model or false)
			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:UseItem", function(source, data, cb)
		if entityPermCheck(source, data.invType) then
			local slot = Inventory:GetSlot(data.owner, data.slot, data.invType)
			if slot ~= nil then
				Inventory.Items:Use(source, slot, cb)
			else
				sendRefreshForClient(source, data.owner, data.invType, data.slot)
				cb(false)
			end
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:UseSlot", function(source, data, cb)
		if data and data.slot then
			local player = Fetch:Source(source)
			local char = player:GetData("Character")
			if player and char then
				local slotFrom = Inventory:GetSlot(char:GetData("SID"), data.slot, 1)
				if slotFrom ~= nil then
					if slotFrom.Count or 0 > 0 then
						Inventory.Items:Use(source, slotFrom, function(yea)
							if not yea then
								sendRefreshForClient(source, char:GetData("SID"), 1, slotFrom)
							end
							cb(yea)
						end)
					else
						sendRefreshForClient(source, char:GetData("SID"), 1, slotFrom)
						cb(false)
					end
				else
					sendRefreshForClient(source, char:GetData("SID"), 1, slotFrom)
					cb(false)
				end
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:CheckIfNearDropZone", function(source, data, cb)
		local playerPed = GetPlayerPed(source)
		local playerCoords = GetEntityCoords(playerPed)
		local route = Player(source).state.currentRoute
		cb(Inventory:CheckDropZones(route, vector3(playerCoords.x, playerCoords.y, playerCoords.z)))
	end)

	Callbacks:RegisterServerCallback("Inventory:Server:retreiveStores", function(source, data, cb)
		cb(shopLocations)
	end)

	Callbacks:RegisterServerCallback("Inventory:Search", function(source, data, cb)
		local plyr = Fetch:Source(data.serverId)
		if plyr ~= nil then
			local dest = plyr:GetData("Character")
			if dest ~= nil then
				Inventory.Search:Character(source, data.serverId, dest:GetData("SID"))
				cb(dest:GetData("SID"))
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
			Inventory:OpenSecondary(source, data.invType, data.owner, data.class or false, data.model or false, true)
		end
	end)

	Callbacks:RegisterServerCallback("Inventory:CloseSecondary", function(source, inventory, cb)
		if inventory.invType == 1 then
			refreshShit(inventory.owner)
		elseif inventory.invType == 10 then
			local route = Player(source).state.currentRoute
			local exists = Inventory:DropExists(route, inventory.owner)
			local hasItems = Inventory:HasItems(inventory.owner, 10)
			if inventory.position ~= nil and hasItems and not exists then
				Inventory:CreateDropzone(route, inventory.position)
			elseif exists and not hasItems then
				Inventory:RemoveDropzone(route, inventory.owner)
			end
		else
			if _refreshAttchs[inventory.owner] then
				TriggerClientEvent("Weapons:Client:Attach", source)
				_refreshAttchs[inventory.owner] = false
			end
		end

		_openInvs[string.format("%s-%s", inventory.owner, inventory.invType)] = false

		cb()
	end)
end

RegisterNetEvent("Inventory:Server:UpdateSettings", function(data)
	local src = source
	local player = Fetch:Source(src)
	if player ~= nil then
		local char = player:GetData("Character")
		if char ~= nil then
			local settings = char:GetData("InventorySettings") or _defInvSettings
			for k, v in pairs(data) do
				settings[k] = v
			end
			char:SetData("InventorySettings", settings)
		end
	end
end)

RegisterNetEvent("Inventory:Server:TriggerAction", function(data)
	local src = source
	local plyr = Fetch:Source(src)
	if plyr ~= nil then
		local char = plyr:GetData("Character")
		if char ~= nil then
			if LoadedEntitys[data.invType] ~= nil and LoadedEntitys[data.invType].action ~= nil then
				TriggerEvent(LoadedEntitys[data.invType].action.event, src, data)
			end
		end
	end
end)

RegisterNetEvent("Inventory:Server:Request", function(secondary)
	local src = source
	local player = Fetch:Source(src)
	local char = player:GetData("Character")


	local plyrInvData = {
		size = (LoadedEntitys[1].slots or 10),
		name = char:GetData("First") .. " " .. char:GetData("Last"),
		inventory = plyrInv,
		invType = 1,
		capacity = LoadedEntitys[1].capacity,
		owner = char:GetData("SID"),
		isWeaponEligble = Weapons:IsEligible(src),
		qualifications = char:GetData("Qualifications") or {},
		loaded = false,
	}

	TriggerClientEvent("Inventory:Client:Open", src, plyrInvData, secondary and Inventory:GetSecondaryData(src, secondary.invType, secondary.owner, secondary.class or false, secondary.model or false) or nil)

	plyrInvData.inventory = getInventory(src, char:GetData("SID"), 1)
	plyrInvData.loaded = true

	TriggerClientEvent("Inventory:Client:Cache", src, plyrInvData)
	TriggerClientEvent("Inventory:Client:Load", src, plyrInvData, secondary and Inventory:GetSecondary(src, secondary.invType, secondary.owner, secondary.class or false, secondary.model or false) or nil)
end)

local _inUse = {}
INVENTORY = {
	CreateDropzone = function(self, routeId, coords)
		local area = {
			id = string.format("%s:%s", math.ceil(coords.x), math.ceil(coords.y)),
			route = routeId,
			coords = {
				x = coords.x,
				y = coords.y,
				z = coords.z,
			},
		}

		table.insert(_dropzones, area)
		TriggerClientEvent("Inventory:Client:AddDropzone", -1, area)

		return area.id
	end,
	CheckDropZones = function(self, routeId, coords)
		local found = nil

		for k, v in ipairs(_dropzones) do
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

		return found
	end,
	RemoveDropzone = function(self, routeId, id)
		for k, v in ipairs(_dropzones) do
			if v.id == id and v.route == routeId then
				if not _doingThings[string.format("%s-%s", id, 10)] then
					table.remove(_dropzones, k)
					TriggerClientEvent("Inventory:Client:RemoveDropzone", -1, id)
				end
				break
			end
		end
	end,
	DropExists = function(self, routeId, id)
		for k, v in ipairs(_dropzones) do
			if v.id == id and v.route == routeId then
				return true
			end
		end

		return false
	end,
	GetInventory = function(self, source, owner, invType)
		return getInventory(source, owner, invType)
	end,
	GetSecondaryData = function(self, _src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride)
		if _src and invType and Owner then
			if entityPermCheck(_src, invType) or (isRaid and Player(_src).state.onDuty == "police") then
				if not _openInvs[string.format("%s-%s", Owner, invType)] or _openInvs[string.format("%s-%s", Owner, invType)] == _src then
					if not LoadedEntitys[invType].shop then
						_openInvs[string.format("%s-%s", Owner, invType)] = _src
					end
					
					local name = nameOverride or (LoadedEntitys[invType].name or "Unknown")
					if LoadedEntitys[tonumber(invType)].shop and shopLocations[Owner] ~= nil then
						name = string.format(
							"%s (%s)",
							shopLocations[Owner].name,
							LoadedEntitys[tonumber(invType)].name
						)
					end

					local requestedInventory = {
						size = getSlotCount(invType, vehClass, vehModel, slotOverride),
						name = name,
						class = vehClass,
						model = vehModel,
						capacity = getCapacity(invType, vehClass, vehModel, capacityOverride),
						shop = LoadedEntitys[tonumber(invType)].shop or false,
						free = LoadedEntitys[tonumber(invType)].free or false,
						inventory = {},
						invType = invType,
						owner = Owner,
						loaded = false,
						slotOverride = slotOverride,
						capacityOverride = capacityOverride,
					}

					return requestedInventory
				else
					return nil
				end
			end
		end
	end,
	GetSecondary = function(self, _src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride)
		if _src and invType and Owner then
			if entityPermCheck(_src, invType) or (isRaid and Player(_src).state.onDuty == "police") then
				if not _openInvs[string.format("%s-%s", Owner, invType)] or _openInvs[string.format("%s-%s", Owner, invType)] == _src then
					if not LoadedEntitys[invType].shop then
						_openInvs[string.format("%s-%s", Owner, invType)] = _src
					end

					local name = nameOverride or (LoadedEntitys[invType].name or "Unknown")
					if LoadedEntitys[tonumber(invType)].shop and shopLocations[Owner] ~= nil then
						name = string.format(
							"%s (%s)",
							shopLocations[Owner].name,
							LoadedEntitys[tonumber(invType)].name
						)
					end
	
					local requestedInventory = {
						size = getSlotCount(invType, vehClass, vehModel, slotOverride),
						name = name,
						class = vehClass,
						model = vehModel,
						capacity = getCapacity(invType, vehClass, vehModel, capacityOverride),
						shop = LoadedEntitys[tonumber(invType)].shop or false,
						free = LoadedEntitys[tonumber(invType)].free or false,
						action = LoadedEntitys[tonumber(invType)].action or false,
						inventory = getInventory(_src, Owner, invType),
						invType = invType,
						owner = Owner,
						loaded = true,
						slotOverride = slotOverride,
						capacityOverride = capacityOverride,
					}
					
					return requestedInventory
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	end,
	OpenSecondary = function(self, _src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride)
		if _src and invType and Owner then
			local player = Fetch:Source(_src)
			local char = player:GetData("Character")

			local plyrInvData = {
				size = (LoadedEntitys[1].slots or 10),
				name = char:GetData("First") .. " " .. char:GetData("Last"),
				inventory = {},
				invType = 1,
				capacity = LoadedEntitys[1].capacity,
				owner = char:GetData("SID"),
				isWeaponEligble = Weapons:IsEligible(_src),
				qualifications = char:GetData("Qualifications") or {},
			}
		
			TriggerEvent("Inventory:Server:Opened", _src, Owner, invType)

			TriggerClientEvent("Inventory:Client:Open", _src, plyrInvData, Inventory:GetSecondaryData(_src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride))
		
			plyrInvData.inventory = getInventory(_src, char:GetData("SID"), 1)
			plyrInvData.loaded = true
		
			TriggerClientEvent("Inventory:Client:Cache", _src, plyrInvData)
			TriggerClientEvent("Inventory:Client:Load", _src, plyrInvData, Inventory:GetSecondary(_src, invType, Owner, vehClass, vehModel, isRaid, nameOverride, slotOverride, capacityOverride))
		end
	end,
	GetSlots = function(self, Owner, Type)
		local db = MySQL.query.await('SELECT slot as Slot FROM inventory WHERE name = ? GROUP BY slot ORDER BY slot', {
			string.format("%s-%s", Owner, Type)
		})

		local slots = {}
		for k, v in ipairs(db) do
			table.insert(slots, v.Slot)
		end
		return slots
	end,
	HasItems = function(self, Owner, Type)
		return MySQL.single.await('SELECT COUNT(id) as count FROM inventory WHERE name = ?', {
			string.format("%s-%s", Owner, Type)
		}).count > 0
	end,
	GetMatchingSlot = function(self, Owner, Name, Count, Type)
		if not itemsDatabase[Name].isStackable then
			return nil
		end

		return (MySQL.single.await('SELECT slot as Slot FROM inventory WHERE name = ? AND item_id = ? GROUP BY slot HAVING COUNT(item_id) <= ?', {
			string.format("%s-%s", Owner, Type),
			Name,
			itemsDatabase[Name].isStackable - Count
		}))?.Slot
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
	GetSlot = function(self, Owner, Slot, Type)
		local item = MySQL.single.await('SELECT id, count(Name) as Count, name as Owner, item_id as Name, dropped as Temp, MAX(quality) as Quality, information as MetaData, slot as Slot, MIN(creationDate) as CreateDate FROM inventory WHERE name = ? AND slot = ? GROUP BY slot ORDER BY slot ASC', {
			string.format("%s-%s", Owner, Type),
			Slot
		})

		if item ~= nil then
			item.MetaData = json.decode(item.MetaData or "{}")
			item.Owner = Owner
			item.invType = Type
		end

		return item
	end,
	GetProvidedSlots = function(self, Owner, Type, Slots)
		return MySQL.single.await('SELECT id, count(Name) as Count, name as Owner, item_id as Name, dropped as Temp, MAX(quality) as Quality, information as MetaData, slot as Slot, MIN(creationDate) as CreateDate FROM inventory WHERE name = ? AND slot IN (?) GROUP BY slot ORDER BY slot ASC', {
			string.format("%s-%s", Owner, Type),
			Slots
		})
	end,
	GetItem = function(self, id)
		return MySQL.single.await('SELECT id, count(Name) as Count, name as Owner, item_id as Name, dropped as Temp, quality as Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE id = ?', {
			id
		})
	end,
	CreateItemWithNoMeta = function(self, Owner, Name, Count, Slot, MetaData, invType, isRecurse)
		if not Count or not tonumber(Count) or Count <= 0 then
			Count = 1
		end

		local itemExist = itemsDatabase[Name]
		if itemExist then
			local p = promise.new()

			if
				not itemExist.isStackable and Count > 1
				or Count > 50
				or (type(itemExist.isStackable) == "number" and Count > itemExist.isStackable and itemExist.isStackable > 0)
			then
				while
					not itemExist.isStackable and itemExist.isStackable ~= -1 and Count > 1
					or Count > 50
					or (type(itemExist.isStackable) == "number" and Count > itemExist.isStackable and itemExist.isStackable > 0)
				do
					local s = Count > 50 and 50 or itemExist.isStackable or 1
					self:CreateItemWithNoMeta(Owner, Name, Count, Slot, MetaData, invType, true)
					Count = Count - s
				end
			end

			return Inventory:AddSlot(Owner, Name, Count, MetaData, Slot, invType)
		else
			return false
		end
	end,
	CreateItem = function(self, Owner, Name, Count, Slot, md, invType, isRecurse, forceCreateDate, quality)
		local MetaData = table.copy(md or {})

		if not Count or not tonumber(Count) or Count <= 0 then
			Count = 1
		end

		local itemExist = itemsDatabase[Name]
		if itemExist then
			local p = promise.new()

			if
				not itemExist.isStackable and Count > 1
				or Count > 10000
				or (type(itemExist.isStackable) == "number" and Count > itemExist.isStackable and itemExist.isStackable > 0)
			then
				while
					not itemExist.isStackable and itemExist.isStackable ~= -1 and Count > 1
					or Count > 10000
					or (type(itemExist.isStackable) == "number" and Count > itemExist.isStackable and itemExist.isStackable > 0)
				do
					local s = Count > 10000 and 10000 or itemExist.isStackable or 1
					self:CreateItem(Owner, Name, Count, Slot, MetaData, invType, true, quality)
					Count = Count - s
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
				local plyr = Fetch:SID(Owner)
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
			elseif itemExist.name == "WEAPON_PETROLCAN" then
				MetaData.ammo = 4500
			elseif itemExist.name == "cigarette_pack" then
				MetaData.Count = 30
			elseif itemExist.name == "choplist" and not MetaData.ChopList then
				MetaData.ChopList = Phone.LSUnderground.Chopping:GenerateList(math.random(4, 8), math.random(3, 5))
			elseif itemExist.name == "meth_table" and not MetaData.MethTable then
				MetaData.MethTable = Drugs.Meth:GenerateTable(1)
			elseif itemExist.name == "adv_meth_table" and not MetaData.MethTable then
				MetaData.MethTable = Drugs.Meth:GenerateTable(2)
			elseif itemExist.name == "meth_bag" or itemExist.name == "meth_brick" or itemExist.name == "coke_bag" or itemExist.name == "coke_brick" then
				if not quality then
					quality = math.random(1, 100)
				end
				if itemExist.name == "meth_brick" then
					MetaData.Finished = os.time() + (60 * 60 * 24)
				end
			elseif itemExist.name == "paleto_access_codes" and not MetaData.AccessCodes then
				MetaData.AccessCodes = {
					Robbery:GetAccessCodes('paleto')[1]
				}
			end

			return Inventory:AddSlot(Owner, Name, Count, MetaData, Slot, invType, forceCreateDate or false, quality or false)
		else
			return false
		end
	end,
	AddItem = function(self, Owner, Name, Count, md, invType, vehClass, vehModel, entity, isRecurse, Slot, forceCreateDate, quality)
		local MetaData = table.copy(md or {})

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

		if invType == 1 then
			if not isRecurse then
				local plyr = Fetch:SID(Owner)
				TriggerClientEvent("Inventory:Client:Changed", plyr:GetData("Source"), "add", Name, Count)
			end
		end

		local itemExist = itemsDatabase[Name]
		if itemExist then
			local invWeight = Inventory.Items:GetWeights(Owner, invType)
			local totWeight = invWeight + (Count * itemExist.weight)

			if
				not itemExist.isStackable and Count > 1
				or Count > 10000
				or (type(itemExist.isStackable) == "number" and Count > itemExist.isStackable and itemExist.isStackable > 0)
			then
				while
					not itemExist.isStackable and Count > 1
					or Count > 10000
					or (type(itemExist.isStackable) == "number" and Count > itemExist.isStackable and itemExist.isStackable > 0)
				do
					local s = Count > 10000 and 10000 or itemExist.isStackable or 1
					self:AddItem(Owner, Name, s, MetaData, invType, vehClass, vehModel or false, entity or false, true, Slot or false, forceCreateDate or false, quality or false)
					Count = Count - s
				end
			end

			local slots = Inventory:GetFreeSlotNumbers(Owner, invType, vehClass, vehModel)
			if
				(totWeight > getCapacity(invType, vehClass, vehmodel) and itemExist.weight > 0)
				or (#slots == 0 or slots[1] > getSlotCount(invType, vehClass or false, vehModel or false))
			then
				local plyr = Fetch:SID(Owner)
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
					if MetaData[k] == nil then
						MetaData[k] = v
					end
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
				local plyr = Fetch:SID(Owner)
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
			elseif itemExist.name == "WEAPON_PETROLCAN" then
				MetaData.ammo = 4500
			elseif itemExist.name == "cigarette_pack" then
				MetaData.Count = 30
			elseif itemExist.name == "choplist" and not MetaData.ChopList then
				MetaData.ChopList = Phone.LSUnderground.Chopping:GenerateList(math.random(4, 8), math.random(3, 5))
			elseif itemExist.name == "meth_table" and not MetaData.MethTable then
				MetaData.MethTable = Drugs.Meth:GenerateTable(1)
			elseif itemExist.name == "adv_meth_table" and not MetaData.MethTable then
				MetaData.MethTable = Drugs.Meth:GenerateTable(2)
			elseif itemExist.name == "meth_bag" or itemExist.name == "meth_brick" or itemExist.name == "coke_bag" or itemExist.name == "coke_brick" then
				if not quality then
					quality = math.random(1, 100)
				end
				if itemExist.name == "meth_brick" then
					MetaData.Finished = os.time() + (60 * 60 * 24)
				end
			elseif itemExist.name == "paleto_access_codes" and not MetaData.AccessCodes then
				MetaData.AccessCodes = {
					Robbery:GetAccessCodes('paleto')[1]
				}
			end

			local retval = nil

			if not itemExist.isStackable then
				retval = Inventory:AddSlot(Owner, Name, 1, MetaData, slots[1], invType, forceCreateDate or false, quality or false)
			else
				local mSlot = Inventory:GetMatchingSlot(Owner, Name, Count, invType)
				if mSlot == nil then
					retval = Inventory:AddSlot(Owner, Name, Count, MetaData, slots[1], invType, forceCreateDate or false, quality or false)
				else
					retval = Inventory:AddSlot(Owner, Name, Count, MetaData, mSlot, invType, forceCreateDate or false, quality or false)
				end
			end

			if invType == 1 then
				if WEAPON_PROPS[Name] ~= nil then
					_refreshAttchs[Owner] = true
				end
				refreshShit(Owner, true)
			end

			return retval
		else
			return false
		end
	end,
	AddSlot = function(self, Owner, Name, Count, MetaData, Slot, Type, forceCreateDate, quality)
		if Count <= 0 then
			Logger:Error("Inventory", "[AddSlot] Cannot Add " .. Count .. " of an Item (" .. Owner .. ":" .. Type .. ")")
			return false
		end

		if Slot == nil then
			local freeSlots = Inventory:GetFreeSlotNumbers(Owner, Type)
			if #freeSlots == 0 then
				Logger:Error("Inventory", "[AddSlot] No Available Slots For " .. Owner .. ":" .. Type .. " And Passed Slot Was Nil")
				return false
			end
			Slot = freeSlots[1]
		end

		if itemsDatabase[Name] == nil then
			Logger:Error(
				"Inventory",
				string.format("Slot %s in %s-%s has invalid item %s", Slot, Owner, Type, Name)
			)
			return false
		end

		local qry = 'INSERT INTO inventory (name, item_id, slot, quality, information, creationDate, expiryDate, dropped) VALUES '
		local params = {}

		local created = forceCreateDate or os.time()
		local expiry = -1
		if itemsDatabase[Name].durability ~= nil and itemsDatabase[Name].isDestroyed then
			expiry = created + itemsDatabase[Name].durability
		end

		for i = 1, Count do
			table.insert(params, string.format("%s-%s", Owner, Type))
			table.insert(params, Name)
			table.insert(params, Slot)
			table.insert(params, quality or 0)
			table.insert(params, json.encode(MetaData))
			table.insert(params, created)
			table.insert(params, expiry)
			table.insert(params, Type == 10 and 1 or 0)
			qry = qry .. '(?, ?, ?, ?, ?, ?, ?, ?)'
			if i < Count then
				qry = qry .. ','
			end
		end

		qry = qry .. ';'

		local ids = MySQL.insert.await(qry, params)

		return { id = ids, metadata = MetaData}
	end,
	SetItemCreateDate = function(self, id, value)
		MySQL.query.await('UPDATE inventory SET creationDate = ? WHERE id = ?', {
			value,
			id,
		})
	end,
	SetMetaDataKey = function(self, id, key, value)
		local slot = Inventory:GetItem(id)
		if slot ~= nil then
			local md = json.decode(slot.MetaData or "{}")
			md[key] = value
			MySQL.query.await('UPDATE inventory SET information = ? WHERE id = ?', {
				json.encode(md),
				id,
			})
			return md
		else
			return {}
		end
	end,
	UpdateMetaData = function(self, id, updatingMeta)
		if type(updatingMeta) ~= "table" then
			return false
		end
		
		local slot = Inventory:GetItem(id)
		if slot ~= nil then
			local md = json.decode(slot.MetaData or "{}")

			for k, v in pairs(updatingMeta) do
				md[k] = v
			end

			MySQL.query.await('UPDATE inventory SET information = ? WHERE id = ?', {
				json.encode(md),
				id,
			})

			return md
		else
			return {}
		end
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

			local qry = MySQL.query.await('SELECT COUNT(id) as Count, item_id as Name FROM inventory WHERE name = ? GROUP BY item_id', {
				string.format("%s-%s", owner, invType)
			})

			for k, v in ipairs(qry) do
				counts[v.Name] = v.Count
			end

			return counts
		end,
		GetWeights = function(self, owner, invType)
			local items = MySQL.query.await('SELECT id, count(id) as Count, item_id as Name FROM inventory WHERE NAME = ? GROUP BY item_id', {
				string.format('%s-%s', owner, invType)
			})

			local weights = 0
			for k, slot in ipairs(items) do
				weights += (slot.Count * itemsDatabase[slot.Name].weight or 0)
			end

			return weights
		end,
		GetFirst = function(self, Owner, Name, invType)
			local item = MySQL.single.await("SELECT id, name as Owner, item_id as Name, dropped as Temp, quality as Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE NAME = ? AND item_id = ? ORDER BY quality DESC, creationDate ASC LIMIT 1", {
				string.format("%s-%s", Owner, invType),
				Name,
			})

			if item ~= nil then
				item.MetaData = json.decode(item.MetaData or "{}")
				item.Owner = Owner
				item.invType = invType
			end
			
			return item
		end,
		GetAll = function(self, Owner, Name, invType)
			local items = MySQL.query.await("SELECT id, name as Owner, item_id as Name, dropped as Temp, quality as Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE NAME = ? AND item_id = ? ORDER BY quality DESC, creationDate ASC", {
				string.format("%s-%s", Owner, invType),
				Name,
			})

			if #items > 0 then
				for k, v in ipairs(items) do
					items[k].MetaData = json.decode(items[k].MetaData or "{}")
					local t = split(items[k].Owner, '-')
					items[k].Owner = tonumber(t[1]) or t[1]
					items[k].invType = tonumber(t[2])
				end
			end

			return items
		end,
		Has = function(self, owner, invType, item, count)
			return (MySQL.single.await('SELECT id, count(id) as Count FROM inventory WHERE name = ? AND item_id = ? GROUP BY item_id', {
				string.format("%s-%s", owner, invType),
				item
			})?.Count or 0) >= (count or 1)
		end,
		HasId = function(self, owner, invType, id)
			return MySQL.single.await('SELECT id, count(Name) as Count FROM inventory WHERE id = ? AND name = ?', {
				id,
				string.format("%s-%s", owner, invType),
			}) ~= nil
		end,
		HasItems = function(self, source, items)
			local player = Fetch:Source(source)
			local char = player:GetData("Character")
			local charId = char:GetData("SID")
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
			local charId = char:GetData("SID")

			for k, v in ipairs(items) do
				if Inventory.Items:Has(charId, 1, v.item, v.count) then
					return true
				end
			end

			return false
		end,
		GetAllOfType = function(self, owner, invType, itemType)
			local f = {}
			local params = {}

			for k, v in pairs(itemsDatabase) do
				if v.type == itemType then
					table.insert(f, string.format('"%s"', v.name))
				end
			end

			local qry = string.format(
				'SELECT id, count(id) as Count, name as Owner, item_id as Name, dropped as Temp, quality as Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE name = ? AND item_id IN (%s) GROUP BY item_id ORDER BY creationDate ASC',
				table.concat(f, ',')
			)
			return MySQL.query.await(qry, { string.format("%s-%s", owner, invType) })
		end,
		GetAllOfTypeNoStack = function(self, owner, invType, itemType)
			local f = {}
			local params = {}

			for k, v in pairs(itemsDatabase) do
				if v.type == itemType then
					table.insert(f, string.format('"%s"', v.name))
				end
			end

			local qry = string.format(
				'SELECT id, name as Owner, item_id as Name, dropped as Temp, quality as Quality, information as MetaData, slot as Slot, creationDate as CreateDate FROM inventory WHERE name = ? AND item_id IN (%s)',
				table.concat(f, ',')
			)
			return MySQL.query.await(qry, { string.format("%s-%s", owner, invType) })
		end,
		RegisterUse = function(self, item, id, cb)
			if ItemCallbacks[item] == nil then
				ItemCallbacks[item] = {}
			end
			ItemCallbacks[item][id] = cb
		end,
		Use = function(self, source, item, cb)
			if item == nil then
				return cb(false)
			end

			if not itemsDatabase[item.Name]?.isUsable or _inUse[source] then
				return cb(false)
			end

			local itemData = itemsDatabase[item.Name]
			if
				not itemData.durability
				or item ~= nil
					and item.CreateDate ~= nil
					and item.CreateDate + itemData.durability > os.time()
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
					TriggerClientEvent("Inventory:Client:Changed", source, itemData.type == 2 and "holster" or "used", item.Name, 0, item.Slot)

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
					sendRefreshForClient(source, char:GetData("SID"), 1, item.Slot)
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
		Remove = function(self, owner, invType, item, count, skipUpdate)
			local results = MySQL.query.await("DELETE FROM inventory WHERE name = ? AND item_id = ? ORDER BY slot ASC, creationDate ASC LIMIT ?", {
				string.format("%s-%s", owner, invType),
				item,
				count,
			})

			if not skipUpdate then
				if invType == 1 then
					local plyr = Fetch:SID(owner)
					if plyr ~= nil then
						local source = plyr:GetData("Source")
						local char = plyr:GetData("Character")
						TriggerClientEvent("Inventory:Client:Changed", source, "removed", item, count)
						if WEAPON_PROPS[item] ~= nil then
							_refreshAttchs[owner] = source
						end
						refreshShit(owner)
					end
				end
			end

			return results.affectedRows >= count
		end,
		RemoveId = function(self, owner, invType, item)
			MySQL.query.await("DELETE FROM inventory WHERE id = ?", { item.id })

			if invType == 1 then
				local plyr = Fetch:SID(tonumber(owner))
				if plyr ~= nil then
					local source = plyr:GetData("Source")
					TriggerClientEvent("Inventory:Client:Changed", source, "removed", item.Name, 1)
					if WEAPON_PROPS[item.Name] ~= nil then
						_refreshAttchs[owner] = source
					end
					refreshShit(owner)
				end
			end

			return true
		end,
		RemoveAll = function(self, owner, type, item)
			if type == 1 then
				local plyr = Fetch:SID(owner)
				if plyr ~= nil then
					local count = MySQL.scalar.await('SELECT COUNT(item_id) as count FROM inventory WHERE name = ? and item_id = ?', {
						string.format("%s-%s", owner, type),
						item,
					})

					if count > 0 then
						TriggerClientEvent("Inventory:Client:Changed", plyr:GetData("Source"), "removed", item, count)
					end
				end
			end

			MySQL.query.await('DELETE FROM inventory WHERE name = ? AND item_id = ?', {
				string.format("%s-%s", owner, type),
				item,
			})
			return true
		end,
		RemoveSlot = function(self, Owner, Name, Count, Slot, invType)
			local slot = Inventory:GetSlot(Owner, Slot, invType)
			if slot == nil then
				Logger:Error(
					"Inventory",
					"Failed to remove " .. Count .. " from Slot " .. Slot .. " for " .. Owner,
					{ console = false }
				)
				return false
			else
				if slot.Count >= Count then
					MySQL.query.await('DELETE FROM inventory WHERE name = ? AND slot = "?" AND item_id = ? ORDER BY creationDate ASC LIMIT ?', {
						string.format("%s-%s", Owner, invType),
						Slot,
						Name,
						Count,
					})
	
					if invType == 1 then
						local plyr = Fetch:SID(Owner)
						if plyr ~= nil then
							local source = plyr:GetData("Source")
							local char = plyr:GetData("Character")
							TriggerClientEvent("Inventory:Client:Changed", source, "removed", Name, Count)
							if WEAPON_PROPS[item] ~= nil then
								_refreshAttchs[Owner] = source
							end
							refreshShit(Owner)
						end
					end
	
					return true
				else
					return false
				end
			end
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
			CreateThread(function()
				local p = promise.new()
				local plyr = Fetch:Source(source)
				if plyr ~= nil then
					local char = plyr:GetData("Character")
					if char ~= nil then
						local inv = getInventory(source, char:GetData("SID"), 1)

						if #inv > 0 then
							local freeSlots = Inventory:GetFreeSlotNumbers(char:GetData("SID"), 2)

							if #inv <= #freeSlots then
								local queries = {}

								for k, v in ipairs(inv) do
									table.insert(queries, {
										query = "UPDATE inventory SET name = ?, slot = ? WHERE name = ? AND slot = ?", 
										values = {
											string.format("%s-%s", char:GetData("SID"), 2),
											freeSlots[k],
											string.format("%s-%s", char:GetData("SID"), 1),
											v.Slot
										}
									})
								end

								MySQL.transaction.await(queries)
								refreshShit(char:GetData("SID"))

								Execute:Client(source, "Notification", "Success", "Retreived Items")
							else
								Execute:Client(source, "Notification", "Error", "Not Enough Slots Available")
							end
						else
							Execute:Client(source, "Notification", "Error", "No Items To Retreive")
						end
					end
					
					p:resolve(true)
				end
				Citizen.Await(p)
			end)
		end,
		Take = function(self, source)
			CreateThread(function()
				local p = promise.new()
				local plyr = Fetch:Source(source)
				if plyr ~= nil then
					local char = plyr:GetData("Character")
					if char ~= nil then
						local inv = getInventory(source, char:GetData("SID"), 2)

						if #inv > 0 then
							local freeSlots = Inventory:GetFreeSlotNumbers(char:GetData("SID"), 1)

							if #inv <= #freeSlots then
								local queries = {}

								for k, v in ipairs(inv) do
									table.insert(queries, {
										query = "UPDATE inventory SET name = ?, slot = ? WHERE name = ? AND slot = ?", 
										values = {
											string.format("%s-%s", char:GetData("SID"), 1),
											freeSlots[k],
											string.format("%s-%s", char:GetData("SID"), 2),
											v.Slot
										}
									})
								end

								MySQL.transaction.await(queries)
								refreshShit(char:GetData("SID"), true)

								Execute:Client(source, "Notification", "Success", "Retreived Items")
							else
								Execute:Client(source, "Notification", "Error", "Not Enough Slots Available")
							end
						else
							Execute:Client(source, "Notification", "Error", "No Items To Retreive")
						end
					end
					
					p:resolve(true)
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
				Execute:Client(tSrc, "Notification", "Info", "You Were Searched")
				Inventory:OpenSecondary(src, 1, id)
			end)
		end,
	},
	Rob = function(self, src, tSrc, id)
		Callbacks:ClientCallback(tSrc, "Inventory:ForceClose", {}, function(state)
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
		Remove = function(self, id)

		end,
	},
	IsOpen = function(self, invType, id)
		return _openInvs[string.format("%s-%s", invType, id)]
	end,
}

function UpdateCharacterItemStates(source, inventory, adding)
	local player = Fetch:Source(source)
	local char = player:GetData("Character")
	if not player or not char then
		return
	end
	local changedState = false
	local playerStates = char:GetData("States") or {}

	local allInventoryStates = {}
	for k, v in ipairs(inventory) do
		local item = itemsDatabase[v.Name]
		if item ~= nil and item.state ~= nil and (item.durability == nil or (os.time() - v.CreateDate < item.durability)) then
			table.insert(allInventoryStates, item.state)
		end
	end

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


function UpdateCharacterGangChain(source, inventory)
	local player = Fetch:Source(source)
	local char = player:GetData("Character")
	if not player or not char then
		return
	end

	local gangChains = {}
	for k, v in ipairs(inventory) do
		local item = itemsDatabase[v.Name]
		if item ~= nil and item.gangChain ~= nil then
			table.insert(gangChains, item.gangChain)
		end
	end

	local myGangChain = char:GetData("GangChain") or nil
	if myGangChain ~= nil and not Utils:DoesTableHaveValue(gangChains, myGangChain) then
		char:SetData("GangChain", "NONE")
	end
end