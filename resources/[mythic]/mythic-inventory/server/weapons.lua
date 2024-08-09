_weaponModels = {}

function tableContains(tbl, value)
	for k, v in ipairs(tbl or {}) do
		if v == value then
			return true
		end
	end
	return false
end

AddEventHandler("Weapons:Shared:DependencyUpdate", WeaponsComponents)
function WeaponsComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Weapons = exports["mythic-base"]:FetchComponent("Weapons")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Weapons", {
		"Fetch",
		"Logger",
		"Inventory",
		"Weapons",
		"Middleware",
		"Callbacks",
	}, function(error)
		if #error > 0 then
			return
		end
		WeaponsComponents()

		Middleware:Add("playerDropped", function(source)
			local plyr = Fetch:Source(source)
			local ped = GetPlayerPed(source)
			for k, v in ipairs(GetAllObjects()) do
				if GetEntityAttachedTo(v) == ped and _weaponModels[GetEntityModel(v)] then
					DeleteEntity(v)
				end
			end
		end, 2)

		Callbacks:RegisterServerCallback("Weapons:UseThrowable", function(source, data, cb)
			local plyr = Fetch:Source(source)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					if Inventory.Items:Remove(char:GetData("SID"), 1, data.Name, 1) then
						local slotUsed = Inventory:GetSlot(char:GetData("SID"), data.Slot, 1)
						if slotUsed == nil then
							TriggerClientEvent("Weapons:Client:ForceUnequip", source)
						end

						cb()
					end
				else
					cb()
				end
			else
				cb()
			end
		end)
	end)
end)

WEAPONS = {
	IsEligible = function(self, source)
		local char = Fetch:Source(source):GetData("Character")
		local licenses = char:GetData("Licenses")
		if licenses ~= nil and licenses.Weapons ~= nil then
			return licenses.Weapons.Active
		else
			return false
		end
	end,
	Save = function(self, source, id, ammo, clip)
		local char = Fetch:Source(source):GetData("Character")
		Inventory:UpdateMetaData(id, {
			ammo = ammo,
			clip = clip,
		})
	end,
	Purchase = function(self, sid, item, isScratched, isCompanyOwned)
		local p = promise.new()

		if not isCompanyOwned then
			local plyr = Fetch:SID(sid)
			if plyr ~= nil then
				local char = plyr:GetData("Character")
				if char ~= nil then
					local hash = GetHashKey(item.name)
					local sn = string.format("SA-%s-%s", math.abs(hash), Sequence:Get(item.name))
					local model = nil
					if itemsDatabase[item.name] then
						model = itemsDatabase[item.name].label
					end
	
					if isScratched == nil then
						isScratched = false
					end
	
					Database.Game:insertOne({
						collection = "firearms",
						document = {
							Serial = sn,
							Item = item.name,
							Model = model,
							Owner = {
								Char = char:GetData("ID"),
								SID = char:GetData("SID"),
								First = char:GetData("First"),
								Last = char:GetData("Last"),
							},
							PurchaseTime = (os.time() * 1000),
							Scratched = isScratched,
						},
					}, function(success)
						p:resolve(true)
					end)
	
					Citizen.Await(p)
					return sn
				end
			end
		else
			local hash = GetHashKey(item.name)
			local sn = string.format("SA-%s-%s", math.abs(hash), Sequence:Get(item.name))
			local model = nil
			if itemsDatabase[item.name] then
				model = itemsDatabase[item.name].label
			end

			if isScratched == nil then
				isScratched = false
			end

			local flags = nil
			if isCompanyOwned.stolen then
				flags = {
					{
						Date = os.time() * 1000,
						Type = "stolen",
						Description = "Stolen In Armed Robbery"
					}
				}
			end

			Database.Game:insertOne({
				collection = "firearms",
				document = {
					Serial = sn,
					Item = item.name,
					Model = model,
					Owner = {
						Company = isCompanyOwned.name,
					},
					PurchaseTime = (os.time() * 1000),
					Scratched = isScratched,
				},
			}, function(success)
				p:resolve(true)
			end)

			Citizen.Await(p)
			return sn
		end
	end,
	GetComponentItem = function(self, type, component)
		for k, v in pairs(itemsDatabase) do
			if v.component ~= nil and v.component.type == type and v.component.string == component then
				return v.name
			end
		end
		return nil
	end,
	EquipAttachment = function(self, source, item)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local p = promise.new()
				Callbacks:ClientCallback(source, "Weapons:Check", {}, function(data)
					if not data then
						Execute:Client(source, "Notification", "Error", "No Weapon Equipped")
						p:resolve(false)
					else
						local itemData = Inventory.Items:GetData(item.Name)
						local weaponData = Inventory.Items:GetData(data.item)
						if itemData ~= nil and itemData.component ~= nil then
							if itemData.component.strings[weaponData.weapon or weaponData.name] ~= nil then
								Callbacks:ClientCallback(
									source,
									"Weapons:EquipAttachment",
									itemData.label,
									function(notCancelled)
										if notCancelled then
											local slotData = Inventory:GetItem(data.id)

											if slotData ~= nil then
												slotData.MetaData = json.decode(slotData.MetaData or "{}")

												local unequipItem = nil
												local unequipCreated = nil
												if
													slotData.MetaData.WeaponComponents ~= nil
													and slotData.MetaData.WeaponComponents[itemData.component.type]
														~= nil
												then
													if
														slotData.MetaData.WeaponComponents[itemData.component.type].attachment
														== itemData.component.string
													then
														Execute:Client(
															source,
															"Notification",
															"Error",
															"Attachment Already Equipped"
														)
														return p:resolve(false)
													end
													unequipItem =
														slotData.MetaData.WeaponComponents[itemData.component.type].item
													unequipCreated =
														slotData.MetaData.WeaponComponents[itemData.component.type].created
												end
	
												local comps = table.copy(slotData.MetaData.WeaponComponents or {})
												comps[itemData.component.type] = {
													type = itemData.component.type,
													item = item.Name,
													created = item.CreateDate,
													attachment = itemData.component.strings[weaponData.weapon or weaponData.name],
												}
	
												Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1)
												if unequipItem ~= nil then
													local returnData = Inventory.Items:GetData(unequipItem)
													if returnData?.component?.returnItem then
														Inventory:AddItem(item.Owner, unequipItem, 1, {}, 1, false, false, false, false, false, unequipCreated or os.time())
													end
												end
	
												Inventory:SetMetaDataKey(
													slotData.id,
													"WeaponComponents",
													comps
												)
	
												Wait(400)
	
												TriggerClientEvent("Weapons:Client:UpdateAttachments", source, comps)
	
												return p:resolve(true)
											else
												return p:resolve(false)
											end
											
										else
											return p:resolve(false)
										end
									end
								)
							else
								Execute:Client(source, "Notification", "Error", "This Does Not Fit On This Weapon")
								return p:resolve(false)
							end
						else
							Execute:Client(source, "Notification", "Error", "Something Was Not Defined")
							return p:resolve(false)
						end
					end
				end)

				return Citizen.Await(p)
			else
				return false
			end
		else
			return false
		end
	end,
	RemoveAttachment = function(self, source, slotId, attachment)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				local slot = Inventory:GetSlot(char:GetData("SID"), slotId, 1)
				if slot ~= nil then
					if slot.MetaData.WeaponComponents ~= nil and slot.MetaData.WeaponComponents[attachment] ~= nil then
						local itemData = Inventory.Items:GetData(slot.MetaData.WeaponComponents[attachment].item)
						if itemData ~= nil then
							Inventory:AddItem(char:GetData("SID"), itemData.name, 1, {}, 1, false, false, false, false, false, slot.MetaData.WeaponComponents[attachment].created or os.time())
							slot.MetaData.WeaponComponents[attachment] = nil	
							Inventory:SetMetaDataKey(
								slot.id,
								"WeaponComponents",
								slot.MetaData.WeaponComponents
							)
							TriggerClientEvent("Weapons:Client:UpdateAttachments", source, slot.MetaData.WeaponComponents)
						end
					end
				end
			end
		end
	end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Weapons", WEAPONS)
end)

RegisterNetEvent("Weapon:Server:UpdateAmmo", function(slot, ammo, clip)
	Weapons:Save(source, slot, ammo, clip)
end)

RegisterNetEvent("Weapon:Server:UpdateAmmoDiff", function(diff, ammo, clip)
	local _src = source
	Inventory:UpdateMetaData(diff.id, {
		ammo = ammo,
		clip = clip,
	})
end)

RegisterNetEvent("Weapons:Server:RemoveAttachment", function(slotId, attachment)
	Weapons:RemoveAttachment(source, slotId, attachment)
end)

RegisterNetEvent("Weapons:Server:DoFlashFx", function(coords, netId)
	TriggerEvent("Particles:Server:DoFx", coords, "flash")
	TriggerClientEvent("Weapons:Client:DoFlashFx", -1, coords.x, coords.y, coords.z, 10000, 8, 20.0, netId, 25, 1.6)
end)