STORE_SHARE_AMOUNT = 0.8

itemsDatabase = {}
itemClasses = {}
itemsWithState = {}

_schematics = _schematics or {}

itemsLoaded = false

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

function ClearDropZones()
	Database.Game:find({
		collection = "dropzones",
		query = {},
	}, function(success, dropzones)
		if not success then
			return
		end
		local totalDeleted = 0
		if dropzones[1] then
			for i = 1, #dropzones do
				local done = false
				Database.Game:delete({
					collection = "inventory",
					query = {
						invType = 10,
						Owner = dropzones[i].randomIdent,
					},
				}, function(delsuccess, deleted)
					if not delsuccess then
						return
					end

					Database.Game:deleteOne({
						collection = "dropzones",
						query = {
							randomIdent = dropzones[i].randomIdent,
						},
					}, function(successdr, dropdelete)
						if not successdr then
							return
						end
						totalDeleted = totalDeleted + 1
						done = true
					end)
				end)
				while not done do
					Wait(0)
				end
			end

			if totalDeleted > 0 then
				Logger:Trace("Inventory", totalDeleted .. " Dropzones have been deleted from the server")
			end
		end

		Database.Game:delete({
			collection = "inventory",
			query = {
				invType = 16,
			},
		}, function(delsuccess, deleted)
			if not delsuccess then
				return
			end
			if deleted > 0 then
				Logger:Trace("Inventory", deleted .. " Items have been collected from trash containers.")
			end
		end)
	end)
end

function ClearGarbage()
	local garbageIds = {}
	for k, v in ipairs(_entityTypes) do
		if v.trash then
			table.insert(garbageIds, v.id)
		end
	end

	Database.Game:delete({
		collection = "inventory",
		query = {
			invType = {
				["$in"] = garbageIds,
			},
		},
	}, function(delsuccess, deleted)
		if not delsuccess then
			return
		end
		if deleted > 0 then
			Logger:Trace("Inventory", deleted .. " Items have been collected from trash cans.")
		end
	end)

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
					UpdateCharacterItemStates(source, true)
				end)
			end

			if v.type == 1 and itemsDatabase[v.name].statusChange ~= nil then
				Inventory.Items:RegisterUse(v.name, "StatusConsumable", function(source, item) -- Foodies
					local char = Fetch:Source(source):GetData("Character")
					Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)

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
						local char = Fetch:Source(source):GetData("Character")
						if state then
							Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)
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
							Citizen.Wait(3000)
							char:SetData("GangChain", v.gangChain)
						else
							TriggerClientEvent("Ped:Client:ChainAnim", source)
							Citizen.Wait(3000)
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

	Chat:RegisterAdminCommand("printinv", function(source, args, rawCommand)
		local plyr = Fetch:SID(tonumber(args[1]))
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				Inventory:PrintSlots(char:GetData("ID"), 1)
			else
			end
		else
		end
	end, {
		help = "Print Inventory Slots To Console",
		params = {
			{
				name = "State ID",
				help = "State ID of the inventory you want to print",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("printinv2", function(source, args, rawCommand)
		local plyr = Fetch:SID(tonumber(args[1]))
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				Inventory:PrintSlots2(char:GetData("ID"), 1)
			else
			end
		else
		end
	end, {
		help = "Print Inventory Slots To Console",
		params = {
			{
				name = "State ID",
				help = "State ID of the inventory you want to print",
			},
		},
	}, 1)

	Chat:RegisterAdminCommand("closeinv", function(source, args, rawCommand)
		Logger:Info("Inventory", "Closing all inventories")
		_openInvs = {}
	end, {
		help = "Close All Inventories",
	}, 0)

	Chat:RegisterAdminCommand("clearinventory", function(source, args, rawCommand)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):SID(tonumber(args[1]))
		if player == nil then
			Execute:Client(source, "Notification", "Error", "This player is not online")
			return
		end
		local char = player:GetData("Character")
		Inventory:Delete(char:GetData("ID"), 1, function(success)
			Execute:Client(
				char:GetData("Source"),
				"Notification",
				"Error",
				"Your inventory was cleared by " .. tostring(source)
			)
			Execute:Client(source, "Notification", "Success", "You cleared the inventory of " .. tostring(src))
		end, true)
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
			Inventory:Delete(Owner, Type, function(success)
				Execute:Client(source, "Notification", "Success", string.format("You cleared inventory of %s:%s", Owner, Type))
			end, true)
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
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local char = player:GetData("Character")
		if tostring(args[1]) ~= nil and tonumber(args[2]) ~= nil then
			local itemExist = itemsDatabase[args[1]]
			if itemExist then
				if itemExist.type ~= 2 then
					Inventory:AddItem(char:GetData("ID"), args[1], tonumber(args[2]), {}, 1)
				else
					Execute:Client(
						source,
						"Notification",
						"Error",
						"You can only give items with this command, try /giveweapon"
					)
				end
			else
				Execute:Client(source, "Notification", "Error", "Item not located")
			end
		end
	end, {
		help = "Give Item",
		params = {
			{
				name = "Item Name",
				help = "The name of the Item",
			},
			{
				name = "Item Count",
				help = "The count of the Item",
			},
		},
	}, 2)

	Chat:RegisterAdminCommand("giveweapon", function(source, args, rawCommand)
		local player = exports["mythic-base"]:FetchComponent("Fetch"):Source(source)
		local char = player:GetData("Character")
		if tostring(args[1]) ~= nil then
			local weapon = string.upper(args[1])
			local itemExist = itemsDatabase[weapon]
			if itemExist then
				if itemExist.type == 2 then
					if itemExist.isThrowable then
						Inventory:AddItem(char:GetData("ID"), weapon, tonumber(args[2]), { ammo = 1, clip = 0 }, 1)
					else
						local ammo = 0
						if args[2] ~= nil then
							ammo = tonumber(args[2])
						end

						Inventory:AddItem(
							char:GetData("ID"),
							weapon,
							1,
							{ ammo = ammo, clip = 0, Scratched = args[3] == "1" or nil },
							1
						)
					end
				else
					Execute:Client(
						source,
						"Notification",
						"Error",
						"You can only give weapons with this command, try /giveitem"
					)
				end
			else
				Execute:Client(source, "Notification", "Error", "Weapon not located")
			end
		end
	end, {
		help = "Give Weapon",
		params = {
			{
				name = "Weapon Name",
				help = "The name of the Weapon",
			},
			{
				name = "Ammo",
				help = "[Optional] The amount of ammo with the weapon.",
			},
			{
				name = "Is Scratched?",
				help = "Whether to spawn with a normal serial number registered to you, or a scratched serial number (1 = true, 0 = false).",
			},
		},
	}, 3)

	Chat:RegisterAdminCommand("vanityitem", function(source, args, rawCommand)
		local label, image, amount, text, action = args[1], args[2], tonumber(args[3]), args[4], args[5]
		local player = Fetch:Source(source)
		if player and player.Permissions:GetLevel() >= 100 then
			local char = player:GetData("Character")
			if char and label and image and amount and amount > 0 then
				Inventory:AddItem(char:GetData("ID"), "vanityitem", amount, {
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
end
