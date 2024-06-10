_weaponModels = {}
local weaponAttachments = {
	flashlight = {},
	muzzle = {
		["WEAPON_PISTOL"] = {
			"COMPONENT_AT_PI_SUPP",
		},
		["WEAPON_PISTOL_MK2"] = {
			"COMPONENT_AT_PI_SUPP_02",
		},
		["WEAPON_COMBATPISTOL"] = {
			"COMPONENT_AT_PI_SUPP",
		},
		["WEAPON_APPISTOL"] = {
			"COMPONENT_AT_PI_SUPP",
		},
		["WEAPON_PISTOL50"] = {
			"COMPONENT_AT_AR_SUPP_02",
		},
		["WEAPON_HEAVYPISTOL"] = {
			"COMPONENT_AT_PI_SUPP",
		},
		["WEAPON_SNSPISTOL_MK2"] = {
			"COMPONENT_AT_PI_COMP_02",
		},
		["WEAPON_MICROSMG"] = {
			"COMPONENT_AT_AR_SUPP_02",
		},
		["WEAPON_SMG"] = {
			"COMPONENT_AT_PI_SUPP",
		},
		["WEAPON_ASSAULTSMG"] = {
			"COMPONENT_AT_AR_SUPP_02",
		},
		["WEAPON_SMG_MK2"] = {
			"COMPONENT_AT_PI_SUPP",
			"COMPONENT_AT_MUZZLE_01",
			"COMPONENT_AT_MUZZLE_02",
			"COMPONENT_AT_MUZZLE_03",
			"COMPONENT_AT_MUZZLE_04",
			"COMPONENT_AT_MUZZLE_05",
			"COMPONENT_AT_MUZZLE_06",
			"COMPONENT_AT_MUZZLE_07",
		},
	},
	barrel = {
		["WEAPON_SMG_MK2"] = {
			"COMPONENT_AT_SB_BARREL_01",
			"COMPONENT_AT_SB_BARREL_02",
		},
	},
	magazine = {},
}

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
					if Inventory.Items:Remove(char:GetData("ID"), 1, data.Name, 1) then
						Inventory:GetSlot(char:GetData("ID"), data.Slot, 1, function(slotUsed)
							if slotUsed == nil then
								TriggerClientEvent("Weapons:Client:ForceUnequip", source)
							end

							cb()
						end)
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
	Save = function(self, source, slot, ammo, clip)
		local char = Fetch:Source(source):GetData("Character")
		Inventory:SetMetaDataKey(char:GetData("ID"), 1, slot, "ammo", ammo)
		Inventory:SetMetaDataKey(char:GetData("ID"), 1, slot, "clip", clip)
	end,
	Purchase = function(self, cId, item, isScratched, isCompanyOwned)
		local p = promise.new()

		if not isCompanyOwned then
			local plyr = Fetch:CharacterData("ID", cId)
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
						if itemData ~= nil and itemData.component ~= nil then
							if itemData.component.strings[data.item] ~= nil then
								Callbacks:ClientCallback(
									source,
									"Weapons:EquipAttachment",
									itemData.label,
									function(notCancelled)
										if notCancelled then
											Inventory:GetSlot(char:GetData("ID"), data.slot, 1, function(slotData)
												print(json.encode(slotData, { indent = true }))
												local unequipItem = nil
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
												end

												local comps = table.copy(slotData.MetaData.WeaponComponents or {})
												comps[itemData.component.type] = {
													type = itemData.component.type,
													item = item.Name,
													attachment = itemData.component.strings[data.item],
												}

												Inventory:RemoveItem(item.Owner, item.Name, 1, item.Slot, 1)
												if unequipItem ~= nil then
													local returnData = Inventory.Items:GetData(unequipItem)
													if returnData?.component?.returnItem then
														Inventory:AddItem(item.Owner, unequipItem, 1, {}, 1)
													end
												end

												print(json.encode(comps, { indent = true }))

												Inventory:SetMetaDataKey(
													char:GetData("ID"),
													1,
													slotData.Slot,
													"WeaponComponents",
													comps
												)

												Citizen.Wait(400)

												TriggerClientEvent("Weapons:Client:UpdateAttachments", source, comps)

												p:resolve(true)
											end)
										else
											p:resolve(false)
										end
									end
								)
							else
								Execute:Client(source, "Notification", "Error", "This Does Not Fit On This Weapon")
								p:resolve(false)
							end
						else
							Execute:Client(source, "Notification", "Error", "Something Was Not Defined")
							p:resolve(false)
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
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Weapons", WEAPONS)
end)

RegisterNetEvent("Weapon:Server:UpdateAmmo", function(slot, ammo, clip)
	Weapons:Save(source, slot, ammo, clip)
end)

RegisterNetEvent("Weapon:Server:UpdateAmmoDiff", function(diff, ammo, clip)
	local _src = source
	Inventory:SetMetaDataKey(diff.owner, diff.type, diff.slot, "ammo", ammo)
	Inventory:SetMetaDataKey(diff.owner, diff.type, diff.slot, "clip", clip)
end)
