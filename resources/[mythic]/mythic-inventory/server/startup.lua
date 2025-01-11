STORE_SHARE_AMOUNT = 0.8

repairWindow = (60 * 60 * 24) * 7 -- Give 7 day period before we completely delete item

itemsDatabase = {}
itemClasses = {}
itemsWithState = {}

_schematics = _schematics or {}

itemsLoaded = false
_started = false

function LoadSchematics()
	Database.Game:find({
		collection = "schematics",
		query = {},
	}, function(success, schems)
		if success then
			for k, v in ipairs(schems) do
				_knownRecipes[v.bench] = _knownRecipes[v.bench] or {}
				table.insert(_knownRecipes[v.bench], _schematics[v.item])
				if _types[v.bench] ~= nil then
					local f = table.copy(_schematics[v.item] or {})
					f.schematic = v.item
					Crafting:AddRecipeToBench(v.bench, v.item, f)
				end
			end
			_knownRecipes = schems
		end
	end)
end

local tmpItems = { '"paleto_access_codes"' }
function ClearDropZones()
	local f = MySQL.query.await("DELETE FROM inventory WHERE dropped = ?", { 1 })

	Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Items In Dropzones", f.affectedRows))

	local trash = 0
	for k, v in pairs(LoadedEntitys) do
		if v.trash then
			local f2 = MySQL.query.await("DELETE FROM inventory WHERE name LIKE '%-?'", { v.id })
			trash += f2.affectedRows
		end
	end

	Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Items In Trash Inventories", trash))
	local delTmp =
		MySQL.query.await(string.format("DELETE FROM inventory WHERE item_id IN (%s)", table.concat(tmpItems, ",")))
	Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Temporary Items", delTmp.affectedRows))
end

function countTable(t)
	local c = 0
	for k, v in pairs(t) do
		c += 1
	end
	return c
end

function ClearBrokenItems()
	if _started then
		return
	end
	_started = true

	-- local count = 0
	-- Logger:Warn("Inventory", "^1DELETING EXPIRED ITEMS, THIS WILL LIKELY TAKE A MINUTE^7")
	-- local total = countTable(itemsDatabase)
	-- local checked = 0
	-- CreateThread(function()
	-- 	for k, v in pairs(itemsDatabase) do
	-- 		if v.durability ~= nil and v.isDestroyed then
	-- 			MySQL.single("SELECT COUNT(*) as Count FROM inventory WHERE item_id = ? and expiryDate = -1", {
	-- 				v.name,
	-- 			}, function(c)
	-- 				if c.Count > 0 then
	-- 					local expiredTime = os.time() - v.durability
	-- 					local deleteTime = expiredTime - repairWindow
	-- 					MySQL.query(
	-- 						"UPDATE inventory SET expiryDate = creationDate + ? WHERE item_id = ? and expiryDate = -1",
	-- 						{
	-- 							v.durability + repairWindow,
	-- 							v.name,
	-- 						}
	-- 					)
	-- 				end

	-- 				checked += 1
	-- 			end)
	-- 			-- MySQL.single('SELECT COUNT(*) as Count FROM inventory WHERE item_id = ? AND creationDate <= ?', {
	-- 			-- 	v.name, deleteTime
	-- 			-- }, function(c)
	-- 			-- 	if c.Count > 0 then
	-- 			-- 		MySQL.query('DELETE FROM inventory WHERE item_id = ? AND creationDate <= ?', {
	-- 			-- 			v.name, deleteTime
	-- 			-- 		}, function(d)
	-- 			-- 			if d.affectedRows > 0 then
	-- 			-- 				Logger:Info("Inventory", string.format("^1Cleaned Up ^2%s^1 Degraded ^2%s^7", d.affectedRows, v.name))
	-- 			-- 			end
	-- 			-- 			checked += 1
	-- 			-- 		end)
	-- 			-- 	else
	-- 			-- 		checked += 1
	-- 			-- 	end
	-- 			-- end)
	-- 		else
	-- 			checked += 1
	-- 		end
	-- 	end
	-- end)

	-- while checked < total do
	-- 	Wait(100)
	-- end

	-- Logger:Warn("Inventory", "^1FINISHED DELETING EXPIRED ITEMS^7")

	CreateThread(function()
		while _started do
			MySQL.query("DELETE FROM inventory WHERE expiryDate < ? AND expiryDate != -1", { os.time() }, function(d)
				Logger:Info("Inventory", string.format("Cleaned Up ^2%s^7 Degraded Items", d.affectedRows))
			end)
			Wait((1000 * 60) * 30)
		end
	end)
end

function SetupGarbage()
	if _trashCans then
		for storageId, storage in ipairs(_trashCans) do
			Inventory.Poly:Create(storage)
		end
	end
end

function LoadItems()
	local c = 0
	for _, its in pairs(_itemsSource) do
		for k, v in ipairs(its) do
			c = c + 1
			itemClasses[v.type] = itemClasses[v.type] or {}
			table.insert(itemClasses[v.type], v.name)
			itemsDatabase[v.name] = v

			if v.state ~= nil then
				itemsWithState[v.name] = v.state

				Inventory.Items:RegisterUse(v.name, "CharacterState", function(source, item)
					refreshShit(Fetch:Source(source):GetData("Character"):GetData("SID"))
				end)
			end

			if v.type == 1 and itemsDatabase[v.name].statusChange ~= nil then
				Inventory.Items:RegisterUse(v.name, "StatusConsumable", function(source, item) -- Foodies
					local char = Fetch:Source(source):GetData("Character")
					Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)

					if itemsDatabase[item.Name].statusChange.Add ~= nil then
						for k, v in pairs(itemsDatabase[item.Name].statusChange.Add) do
							TriggerClientEvent("Status:Client:updateStatus", source, k, true, v)
						end
					end

					if itemsDatabase[item.Name].statusChange.Remove ~= nil then
						for k, v in pairs(itemsDatabase[item.Name].statusChange.Remove) do
							TriggerClientEvent("Status:Client:updateStatus", source, k, false, -v)
						end
					end

					if itemsDatabase[item.Name].statusChange.Ignore ~= nil then
						for k, v in pairs(itemsDatabase[item.Name].statusChange.Ignore) do
							Player(source).state[string.format("ignore%s", k)] = v
						end
					end

					if itemsDatabase[v.name].progressModifier ~= nil then
						Execute:Client(
							source,
							"Progress",
							"Modifier",
							itemsDatabase[v.name].progressModifier.modifier,
							math.random(
								itemsDatabase[v.name].progressModifier.min,
								itemsDatabase[v.name].progressModifier.max
							) * (60 * 1000)
						)
					end

					if itemsDatabase[v.name].energyModifier ~= nil then
						TriggerClientEvent(
							"Inventory:Client:SpeedyBoi",
							source,
							itemsDatabase[v.name].energyModifier.modifier,
							itemsDatabase[v.name].energyModifier.duration * 1000,
							itemsDatabase[v.name].energyModifier.cooldown * 1000,
							itemsDatabase[v.name].energyModifier.skipScreenEffects
						)
					end

					if itemsDatabase[v.name].healthModifier ~= nil then
						TriggerClientEvent(
							"Inventory:Client:HealthModifier",
							source,
							itemsDatabase[v.name].healthModifier
						)
					end

					if itemsDatabase[v.name].armourModifier ~= nil then
						TriggerClientEvent(
							"Inventory:Client:ArmourModifier",
							source,
							itemsDatabase[v.name].armourModifier
						)
					end

					if itemsDatabase[v.name].stressTicks ~= nil then
						Player(source).state.stressTicks = itemsDatabase[v.name].stressTicks
					end
				end)
			elseif v.type == 2 then
				Inventory.Items:RegisterUse(v.name, "Weapons", function(source, item)
					TriggerClientEvent("Weapons:Client:Use", source, item)
				end)
			elseif v.type == 9 then
				Inventory.Items:RegisterUse(v.name, "Ammo", function(source, item)
					Callbacks:ClientCallback(source, "Weapons:AddAmmo", itemsDatabase[item.Name], function(state)
						if state then
							Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
						end
					end)
				end)
			elseif v.type == 10 then
				Inventory.Items:RegisterUse(v.name, "Containers", function(source, item)
					Inventory.Container:Open(source, item, item.MetaData.Container)
				end)
			elseif v.type == 15 and v.gangChain ~= nil then
				Inventory.Items:RegisterUse(v.name, "GangChains", function(source, item)
					local char = Fetch:Source(source):GetData("Character")
					if v.gangChain ~= nil then
						if v.gangChain ~= char:GetData("GangChain") then
							TriggerClientEvent("Ped:Client:ChainAnim", source)
							Wait(3000)
							char:SetData("GangChain", v.gangChain)
						else
							TriggerClientEvent("Ped:Client:ChainAnim", source)
							Wait(3000)
							char:SetData("GangChain", "NONE")
						end
					end
				end)
			elseif v.type == 16 and v.component ~= nil then
				Inventory.Items:RegisterUse(v.name, "WeaponAttachments", function(source, item)
					Weapons:EquipAttachment(source, item)
				end)
			elseif v.type == 17 and v.schematic ~= nil then
				_schematics[v.name] = v.schematic
				v.schematic.schematic = v.name
			end

			if v.drugState ~= nil then
				Inventory.Items:RegisterUse(v.name, "DrugStates", function(source, item)
					local plyr = Fetch:Source(source)
					if plyr ~= nil then
						local char = plyr:GetData("Character")
						if char ~= nil then
							local drugStates = char:GetData("DrugStates") or {}
							drugStates[v.drugState.type] = {
								item = v.name,
								expires = os.time() + v.drugState.duration,
							}
							char:SetData("DrugStates", drugStates)
						end
					end
				end)
			end
		end
	end

	itemsLoaded = true

	RegisterRandomItems()
	Logger:Trace("Inventory", string.format("Loaded ^2%s^7 Items", c))
end

function LoadEntityTypes()
	for k, v in ipairs(_entityTypes) do
		LoadedEntitys[tonumber(v.id)] = v
	end
	Logger:Trace("Inventory", string.format("Loaded ^2%s^7 Inventory Entity Types", #_entityTypes))
end

shopLocations = {}
storeBankAccounts = {}
pendingShopDeposits = {}
function LoadShops()
	CreateThread(function()
		Wait(10000)

		local f = Banking.Accounts:GetOrganization("dgang")

		for k, v in ipairs(_shops) do
			local id = k
			if v.id ~= nil then
				id = v.id
			else
				v.id = k
			end

			v.restriction = LoadedEntitys[v.entityId].restriction
			shopLocations[string.format("shop:%s", id)] = v
		end

		for k, v in pairs(_entityTypes) do
			storeBankAccounts[v.id] = f.Account
		end

		Database.Game:find({
			collection = "store_bank_accounts",
		}, function(success, results)
			if success and #results > 0 then
				for k, v in ipairs(results) do
					storeBankAccounts[v.Shop] = v.Account
				end
			end
		end)

		Logger:Trace("Inventory", string.format("Loaded ^2%s^7 Shop Locations", #_shops))
	end)
end

function RegisterCommands()
	Chat:RegisterAdminCommand("storebank", function(source, args, rawCommand)
		Database.Game:updateOne({
			collection = "store_bank_accounts",
			update = {
				["$set"] = {
					Shop = tonumber(args[1]),
					Account = tonumber(args[2]),
				},
			},
			query = {
				Shop = tonumber(args[1]),
			},
			options = {
				upsert = true,
			},
		}, function(success, result)
			if success then
				storeBankAccounts[string.format("shop:%s", tonumber(args[1]))] = tonumber(args[2])
			end
		end)
	end, {
		help = "Link Bank Account To Shop",
		params = {
			{
				name = "Shop ID",
				help = "Shop ID To Attach Bank Account To",
			},
			{
				name = "Account Number",
				help = "Account Number To Attach Bank Account To",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("closeinv", function(source, args, rawCommand)
		Logger:Info("Inventory", "Closing all inventories")
		_openInvs = {}
	end, {
		help = "Close All Inventories",
	}, 0)

	Chat:RegisterAdminCommand("removecd", function(source, args, rawCommand)
		RemoveCraftingCooldown(source, args[1], args[2])
	end, {
		help = "Remove Crafting Cooldown From A Bench",
		params = {
			{
				name = "Bench ID",
				help = "Unique ID of the bench to interact with",
			},
			{
				name = "Craft Key",
				help = "Unique key for the craft item",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("clearinventory", function(source, args, rawCommand)
		if not args[1] or not tonumber(args[1]) then
			if source == 0 then
				print("You must provide a valid SID.")
			else
				Execute:Client(source, "Notification", "Error", "You must provide a valid SID.")
			end
			return
		end

		local sid = tonumber(args[1])
		local name = string.format("%s-%s", sid, 1)

		local query = "DELETE FROM inventory WHERE name = ?"

		local queryResult = MySQL.query.await(query, { name })
		if not queryResult then
			if source == 0 then
			else
				Execute:Client(source, "Notification", "Error", "Failed to clear the inventory. Database error.")
			end
			return
		end

		if source == 0 then
		else
			Execute:Client(
				source,
				"Notification",
				"Success",
				"You cleared the inventory of SID: " .. tostring(sid)
			)
		end

		local player = exports["mythic-base"]:FetchComponent("Fetch"):SID(sid)
		if player then
			local char = player:GetData("Character")
			if char then
				Execute:Client(
					char:GetData("Source"),
					"Notification",
					"Error",
					"Your inventory has been cleared"
				)
				if itemsDatabase then
					refreshShit(sid, true)
				end
			end
		end
	end, {
		help = "Clear Player Inventory",
		params = {
			{
				name = "SID",
				help = "SID of the Player",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("clearinventory2", function(source, args, rawCommand)
		local Owner, Type = args[1], tonumber(args[2])

		if Owner and Type then
			MySQL.query.await("DELETE * FROM inventory WHERE Owner = ?", { string.format("%s:%s", Owner, Type) })
			Execute:Client(
				source,
				"Notification",
				"Success",
				string.format("You cleared inventory of %s:%s", Owner, Type)
			)
		end
	end, {
		help = "Clear Inventory",
		params = {
			{
				name = "Owner",
				help = "Inventory Owner",
			},
			{
				name = "Type",
				help = "Inventory Type",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("giveitem", function(source, args, rawCommand)
		local targetSID
		if args[1] == "me" then
			targetSID = Fetch:Source(source):GetData("Character"):GetData("SID")
		else
			targetSID = tonumber(args[1])
		end

		local player = targetSID and Fetch:SID(targetSID)

		if player == nil then
			Execute:Client(source, "Notification", "Error", "This player is not online")
			return
		end

		local char = player:GetData("Character")

		if tostring(args[2]) ~= nil and tonumber(args[3]) ~= nil then
			local itemExist = itemsDatabase[args[2]]
			if itemExist then
				if itemExist.type ~= 2 then
					Inventory:AddItem(char:GetData("SID"), args[2], tonumber(args[3]), {}, 1)
					Execute:Client(source, "Notification", "Success", "You gave " .. args[3] .. "x " .. args[2] .. " to " .. tostring(char:GetData("SID")))
				else
					Execute:Client(source, "Notification", "Error", "You can only give items with this command, try /giveweapon")
				end
			else
				Execute:Client(source, "Notification", "Error", "Item not located")
			end
		end
	end, {
		help = "Give Item",
		params = {
			{
				name = "SID",
				help = "SID of the Player or 'me' to give to yourself",
			},
			{
				name = "Item Name",
				help = "The name of the Item",
			},
			{
				name = "Item Count",
				help = "The count of the Item",
			},
		},
	}, 3)

	Chat:RegisterAdminCommand("giveweapon", function(source, args, rawCommand)
		local targetSID
		if args[1] == "me" then
			targetSID = Fetch:Source(source):GetData("Character"):GetData("SID")
		else
			targetSID = tonumber(args[1])
		end

		local player = targetSID and Fetch:SID(targetSID)

		if player == nil then
			Execute:Client(source, "Notification", "Error", "This player is not online")
			return
		end

		local char = player:GetData("Character")

		if tostring(args[2]) ~= nil then
			local weapon = string.upper(args[2])
			local itemExist = itemsDatabase[weapon]
			if itemExist then
				if itemExist.type == 2 then
					if itemExist.isThrowable then
						Inventory:AddItem(char:GetData("SID"), weapon, tonumber(args[3]), { ammo = 1, clip = 0 }, 1)
					else
						local ammo = 0
						if args[3] ~= nil then
							ammo = tonumber(args[3])
						end

						Inventory:AddItem(
							char:GetData("SID"),
							weapon,
							1,
							{ ammo = ammo, clip = 0, Scratched = args[4] == "1" or nil },
							1
						)
					end
					Execute:Client(source, "Notification", "Success", "You gave weapon " .. weapon .. " to " .. tostring(char:GetData("SID")))
				else
					Execute:Client(source, "Notification", "Error", "You can only give weapons with this command, try /giveitem")
				end
			else
				Execute:Client(source, "Notification", "Error", "Weapon not located")
			end
		end
	end, {
		help = "Give Weapon",
		params = {
			{
				name = "SID",
				help = "SID of the Player or 'me' to give to yourself",
			},
			{
				name = "Weapon Name",
				help = "The name of the Weapon",
			},
			{
				name = "Ammo",
				help = "The amount of ammo with the weapon.",
			},
			{
				name = "Is Scratched?",
				help = "Whether to spawn with a normal serial number registered to you, or a scratched serial number (1 = true, 0 = false).",
			},
		},
	}, 4)

	Chat:RegisterAdminCommand("vanityitem", function(source, args, rawCommand)
		local label, image, amount, text, action = args[1], args[2], tonumber(args[3]), args[4], args[5]
		local player = Fetch:Source(source)
		if player and player.Permissions:GetLevel() >= 100 then
			local char = player:GetData("Character")
			if char and label and image and amount and amount > 0 then
				Inventory:AddItem(char:GetData("SID"), "vanityitem", amount, {
					CustomItemLabel = label,
					CustomItemImage = image,
					CustomItemText = text or "",
					CustomItemAction = action,
				}, 1)
			else
				Execute:Client(source, "Notification", "Error", "Wrong")
			end
		end
	end, {
		help = "Create a Vanity Item",
		params = {
			{
				name = "Label",
				help = "Item Label",
			},
			{
				name = "Image",
				help = "Item Image URL - Imgur",
			},
			{
				name = "Amount",
				help = "Amount to Give",
			},
			{
				name = "Text",
				help = "Tooltip Text",
			},
			{
				name = "Action ID",
				help = "Unique Item ID If We Want to Assign an Action Later",
			},
		},
	}, -1)

	Chat:RegisterCommand("reloaditems", function(source, args, rawCommand)
		TriggerClientEvent("Inventory:Client:ReloadItems", source)
	end, {
		help = "Attempts To Force Reload Inventory Items",
	}, 0)
end
