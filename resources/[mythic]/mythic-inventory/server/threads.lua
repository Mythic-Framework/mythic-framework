local _started = false
local _forcing = false

AddEventHandler("Core:Server:ForceSave", function()
	_forcing = true
	Logger:Trace("Inventory", string.format("Force Save Triggered - %s Inventories", #createdInventories))

	while #createdInventories > 0 do
		print("attemting save " .. createdInventories[1].owner)
		local p = promise.new()
		local slots = Inventory:GetSlots(createdInventories[1].owner, createdInventories[1].type)
		local save = {}
		for k, v in ipairs(slots) do
			if v ~= nil then
				local slotData = GlobalState[string.format("inventory:%s:%s", createdInventories[1].id, v)]
				if slotData ~= nil then
					table.insert(save, slotData)
				end
			end
		end

		Database.Game:updateOne({
			collection = "inventory",
			query = {
				Owner = createdInventories[1].owner,
				invType = createdInventories[1].type,
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
				return
			end
			Logger:Info(
				"Inventory",
				string.format(
					"Force Saved Inventory: ^2%s^7 (Type: ^3%s^7)",
					createdInventories[1].owner,
					createdInventories[1].type
				),
				{ console = true, database = true },
				{
					owner = createdInventories[1].owner,
					type = createdInventories[1].type,
					inventory = save,
				}
			)
			p:resolve(true)
		end)

		Citizen.Await(p)
		table.remove(createdInventories, 1)
	end
	_forcing = false
end)

function ExistsInRetard(id)
	for k, v in ipairs(createdInventories) do
		if v.id == id then
			return true
		end
	end
	return false
end

function RemoveFromRetard(id)
	for k, v in ipairs(createdInventories) do
		if v.id == id then
			table.remove(createdInventories, k)
			return true
		end
	end
	return false
end

function InventoryThreads()
	if _started then
		return
	end
	_started = true

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000 * 60 * 10)
			for k, v in pairs(pendingShopDeposits) do
				if v.tax then
					Logger:Trace("Inventory", string.format("Depositing ^2$%s^7 To ^3%s^7 For Tax On ^2%s^7 Store Transactions", v.amount, k, v.transactions))
					Banking.Balance:Deposit(k, v.amount, {
						type = 'deposit',
						title = 'Sales Tax',
						description = string.format("Deposit For Sales Tax On %s Store Sales", v.transactions),
						data = {},
					}, true)
				else
					Logger:Trace("Inventory", string.format("Depositing ^2$%s^7 To ^3%s^7 For ^2%s^7 Store Transactions", v.amount, k, v.transactions))
					Banking.Balance:Deposit(k, v.amount, {
						type = 'deposit',
						title = 'Store Sales',
						description = string.format("Deposit For %s Store Sales", v.transactions),
						data = {},
					}, true)
				end

				pendingShopDeposits[k] = nil
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			if _forcing then
				Logger:Trace("Inventory", "Force Inventory Saving Occuring, Waiting To Scan Saves To Not Interfere")
				Citizen.Wait(30000)
			else
				if #createdInventories == 0 then
					Logger:Trace("Inventory", "No Inventories To Save, Waiting...")
					Citizen.Wait(60000)
				else
					local p = promise.new()

					if
						_exitSaving[string.format("%s:%s", createdInventories[1].owner, createdInventories[1].type)]
						or createdInventories[1].unloaded
					then
						Logger:Trace(
							"Inventory",
							string.format(
								"^2%s:%s^7 Unloaded, Skipping Save",
								createdInventories[1].owner,
								createdInventories[1].type
							)
						)
						table.remove(createdInventories, 1)
						Citizen.Wait((1000 * 60 * 5) / (#createdInventories or 1))
					else
						local slots = Inventory:GetSlots(createdInventories[1].owner, createdInventories[1].type)
						local save = {}
						for k, v in ipairs(slots) do
							if v ~= nil then
								local slotData = GlobalState[string.format(
									"inventory:%s:%s",
									createdInventories[1].id,
									v
								)]
								if slotData ~= nil then
									table.insert(save, slotData)
								end
							end
						end

						Database.Game:updateOne({
							collection = "inventory",
							query = {
								Owner = createdInventories[1].owner,
								invType = createdInventories[1].type,
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
								Logger:Error(
									"Inventory",
									string.format(
										"Failed Saving Inventory ^2%s:%s^7 To Database",
										createdInventories[1].owner,
										createdInventories[1].type
									)
								)
								p:resolve(false)
								return
							end
							Logger:Info(
								"Inventory",
								string.format(
									"Saved Inventory: ^2%s^7 (Type: ^3%s^7)",
									createdInventories[1].owner,
									createdInventories[1].type
								),
								{ console = true, database = true },
								{
									owner = createdInventories[1].owner,
									type = createdInventories[1].type,
									inventory = save,
								}
							)
							p:resolve(true)
						end)

						Citizen.Await(p)
						table.remove(createdInventories, 1)
						Citizen.Wait(math.abs(math.ceil(((1000 * 60 * 5) / (#createdInventories or 1)))))
					end
				end
			end
			Citizen.Wait(1)
		end
	end)
end
