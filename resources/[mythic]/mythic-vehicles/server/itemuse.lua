function RegisterItemUses()
	Inventory.Items:RegisterUse("lockpick", "Vehicles", function(source, slot, itemData)
		SetTimeout(500, function()
			Callbacks:ClientCallback(source, "Vehicles:Lockpick", true, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
					else
						Inventory:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	Inventory.Items:RegisterUse("adv_lockpick", "Vehicles", function(source, slot, itemData)
		SetTimeout(500, function()
			Callbacks:ClientCallback(source, "Vehicles:AdvLockpick", true, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
					else
						Inventory:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	Inventory.Items:RegisterUse("electronics_kit", "Vehicles", function(source, slot, itemData)
		SetTimeout(500, function()
			Callbacks:ClientCallback(source, "Vehicles:Hack", true, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
					else
						Inventory:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	Inventory.Items:RegisterUse("adv_electronics_kit", "Vehicles", function(source, slot, itemData)
		SetTimeout(500, function()
			Callbacks:ClientCallback(source, "Vehicles:AdvHack", true, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
					else
						Inventory:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	Inventory.Items:RegisterUse("screwdriver", "Vehicles", function(source, slot, itemData)
		SetTimeout(1500, function()
			Callbacks:ClientCallback(source, "Vehicles:Lockpick", {
				{
					base = 4000,
					mod = 900,
				},
				{
	
					base = 3500,
					mod = 900,
				},
				false
			}, function(using, success)
				if using then
					local newValue = slot.CreateDate - (60 * 60 * 24)
					if success then
						newValue = slot.CreateDate - (60 * 60 * 12)
					end
					if (os.time() - itemData.durability >= newValue) then
						Inventory.Items:RemoveId(slot.Owner, slot.invType, slot)
					else
						Inventory:SetItemCreateDate(slot.id, newValue)
					end
				end
			end)
		end)
	end)

	Inventory.Items:RegisterUse("repairkit", "Vehicles", function(source, itemData)
		Callbacks:ClientCallback(source, "Vehicles:RepairKit", false, function(success)
			if success then
				Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)
			end
		end)
	end)

	Inventory.Items:RegisterUse("repairkitadv", "Vehicles", function(source, itemData)
		Callbacks:ClientCallback(source, "Vehicles:RepairKit", true, function(success)
			if success then
				Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)
			end
		end)
	end)

	Inventory.Items:RegisterUse("fakeplates", "Vehicles", function(source, itemData)
		local currentMeta = itemData.MetaData or {}
		if not currentMeta.Plate then -- Data needs generating
			local updatingMetaData = {}

			updatingMetaData.Plate = Vehicles.Identification.Plate:Generate(true)
			updatingMetaData.VIN = Vehicles.Identification.VIN:GenerateLocal() -- Might not be completely unique but odds are low and idc
			updatingMetaData.OwnerName = Generator.Name:First() .. " " .. Generator.Name:Last()
			updatingMetaData.SID = Sequence:Get("Character")
			updatingMetaData.Vehicle = Vehicles:RandomName()

			currentMeta = Inventory:UpdateMetaData(itemData.id, updatingMetaData)
		end

		if not currentMeta.Vehicle then
			currentMeta.Vehicle = Vehicles:RandomName()

			Inventory:UpdateMetaData(iitemData.id, {
				Vehicle = currentMeta.Vehicle
			})
		end

		if currentMeta then
			Callbacks:ClientCallback(source, "Vehicles:GetFakePlateAddingVehicle", {}, function(veh)
				if not veh then
					return
				end
				veh = NetworkGetEntityFromNetworkId(veh)
				if veh and DoesEntityExist(veh) then
					local vehState = Entity(veh).state
					if not vehState.VIN then
						return
					end

					local vehicle = Vehicles.Owned:GetActive(vehState.VIN)
					if not vehicle then
						return
					end
					if not vehicle:GetData("FakePlate") then
						vehicle:SetData("FakePlate", currentMeta.Plate)
						vehicle:SetData("FakePlateData", currentMeta)

						SetVehicleNumberPlateText(veh, currentMeta.Plate)
						vehState.FakePlate = currentMeta.Plate

						Vehicles.Owned:ForceSave(vehState.VIN)

						Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)

						Execute:Client(source, "Notification", "Success", "Fake Plate Installed")
					else
						Execute:Client(source, "Notification", "Error", "A Fake Plate is Already Installed")
					end
				end
			end)
		end
	end)

	Inventory.Items:RegisterUse("carpolish", "Vehicles", function(source, itemData)
		UseCarPolish(source, itemData, 1)
	end)

	Inventory.Items:RegisterUse("carpolish_high", "Vehicles", function(source, itemData)
		UseCarPolish(source, itemData, 2)
	end)

	Inventory.Items:RegisterUse("carclean", "Vehicles", function(source, itemData)
		TriggerClientEvent("Vehicles:Client:CleaningKit", source)
	end)

	Inventory.Items:RegisterUse("car_bomb", "Vehicles", function(source, itemData)
		Callbacks:ClientCallback(source, "Vehicles:UseCarBomb", {}, function(veh, reason, config)
			if not veh then
				if reason then
					Execute:Client(source, "Notification", "Error", reason)
				end
				return
			end
			veh = NetworkGetEntityFromNetworkId(veh)
			if veh and DoesEntityExist(veh) then
				local char = Fetch:Source(source):GetData('Character')
				if char then
					local vehState = Entity(veh).state
					if not vehState.VIN then
						return
					end
	
					if not vehState.CarBomb then
						vehState.CarBomb = {
							Speed = config.minSpeed,
							Removal = config.removalTime,
							ExplosionTicks = config.preExplosionTicks,
							InstalledBy = char:GetData("SID"),
						}

						Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)

						Execute:Client(source, "Notification", "Success", "Car Bomb Installed")
					else
						Execute:Client(source, "Notification", "Error", "Vehicle Already Has Car Bomb")
					end
				else
					Execute:Client(source, "Notification", "Error", "Error Installing Car Bomb")
				end
			end
		end)
	end)

	Inventory.Items:RegisterUse("harness", "Vehicles", function(source, itemData)
		Callbacks:ClientCallback(source, "Vehicles:InstallHarness", {}, function(veh)
			if not veh then
				return
			end
			veh = NetworkGetEntityFromNetworkId(veh)
			if veh and DoesEntityExist(veh) then
				local vehState = Entity(veh).state
				if not vehState.VIN then
					return
				end

				if Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType) then
					vehState.Harness = 10
					Execute:Client(source, "Notification", "Success", "Harness Installed")
				end
			end
		end)
	end)

	Inventory.Items:RegisterUse("nitrous", "Vehicles", function(source, itemData)
		if itemData?.MetaData?.Nitrous and itemData?.MetaData?.Nitrous > 0 then
			Callbacks:ClientCallback(source, "Vehicles:InstallNitrous", {}, function(veh)
				if not veh then
					return
				end
				veh = NetworkGetEntityFromNetworkId(veh)
				if veh and DoesEntityExist(veh) then
					local vehState = Entity(veh).state
					if not vehState.VIN then
						return
					end

					if Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType) then
						vehState.Nitrous = itemData.MetaData.Nitrous + 0.0
						Execute:Client(source, "Notification", "Success", "Nitrous Oxide Installed")
					end
				end
			end)
		else
			Execute:Client(source, "Notification", "Error", "The Bottle is Empty!")
		end
	end)
end

local polishTypes = {
	{ -- Normal Polish
		length = (60 * 60 * 24 * 7), -- Lasts for a week
		multiplier = 2,
	},
	{ -- High Polish
		length = (60 * 60 * 24 * 14), -- Lasts for 2 weeks
		multiplier = 3,
	}
}

function UseCarPolish(source, itemData, type)
	local typeData = polishTypes[type]
	if not type then return end

	Callbacks:ClientCallback(source, "Vehicles:UseCarPolish", {}, function(veh)
		if not veh then
			return
		end
		veh = NetworkGetEntityFromNetworkId(veh)
		if veh and DoesEntityExist(veh) then
			local vehState = Entity(veh).state
			if not vehState.VIN then
				return
			end

			if (not vehState.Polish) or (vehState.Polish?.Type ~= type) or (vehState.Polish?.Time and (os.time() - vehState.Polish?.Time) >= (60 * 60 * 24)) then
				vehState.Polish = {
					Type = t,
					Expires = os.time() + typeData.length,
					Time = os.time(),
					Mult = typeData.multiplier,
				}

				Inventory.Items:RemoveSlot(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)

				Execute:Client(source, "Notification", "Success", "Polish Applied")
			else
				Execute:Client(source, "Notification", "Error", "Vehicle Already Has That Polish and It Was Recently Installed")
			end
		end
	end)
end

RegisterNetEvent('Vehicles:Server:HarnessDamage', function()
	local src = source
	local veh = GetVehiclePedIsIn(GetPlayerPed(src), false)
	if DoesEntityExist(veh) then
		local vehState = Entity(veh)
		if vehState and vehState.state.VIN and vehState.state.Harness and vehState.state.Harness > 0 then
			vehState.state.Harness = vehState.state.Harness - 1
		end
	end
end)

RegisterNetEvent('Vehicles:Server:RemoveBomb', function(vNet)
	local veh = NetworkGetEntityFromNetworkId(vNet)
	if veh and DoesEntityExist(veh) then
		local vehState = Entity(veh)
		if vehState and vehState.state.VIN and vehState.state.CarBomb then
			vehState.state.CarBomb = false
		end
	end
end)

RegisterServerEvent('Vehicles:Server:NitrousUsage', function(vNet, used)
    local veh = NetworkGetEntityFromNetworkId(vNet)

    local ent = Entity(veh)
    if ent and ent.state and ent.state.Nitrous then
		ent.state.Nitrous = ent.state.Nitrous - used
		if ent.state.Nitrous < 0 then
			ent.state.Nitrous = 0.0
		end
    end
end)