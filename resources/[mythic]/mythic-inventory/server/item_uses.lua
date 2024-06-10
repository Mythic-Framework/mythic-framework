local _partsTable = {
	{ 15, { name = "repair_part_electronics", min = 3, max = 5 } },
	{ 15, { name = "repair_part_axle", min = 3, max = 5 } },
	{ 15, { name = "repair_part_injectors", min = 3, max = 5 } },
	{ 15, { name = "repair_part_clutch", min = 3, max = 5 } },
	{ 15, { name = "repair_part_brakes", min = 3, max = 5 } },
	{ 15, { name = "repair_part_transmission", min = 3, max = 5 } },
	{ 10, { name = "repair_part_rad", min = 3, max = 5 } },
}

local _partsTableHG = {
	{ 20, { name = "repair_part_injectors_hg" } },
	{ 20, { name = "repair_part_clutch_hg" } },
	{ 20, { name = "repair_part_brakes_hg" } },
	{ 20, { name = "repair_part_transmission_hg" } },
	{ 20, { name = "repair_part_rad_hg" } },
}

local _materialsTable = {
	{ 19, { name = "electronic_parts", min = 20, max = 120 } },
	{ 19, { name = "plastic", min = 20, max = 120 } },
	{ 19, { name = "rubber", min = 20, max = 120 } },
	{ 19, { name = "copperwire", min = 50, max = 250 } },
	{ 19, { name = "glue", min = 10, max = 55 } },
	{ 5, { name = "ironbar", min = 10, max = 50 } },
}

function RegisterRandomItems()
	Inventory.Items:RegisterUse("cigarette", "RandomItems", function(source, item)
		if GetVehiclePedIsIn(GetPlayerPed(source)) == 0 then
			Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			Player(source).state.stressTicks = { "3", "3", "3", "3", "3", "3", "3", "3" }
		else
			Execute:Client(source, "Notification", "Error", "Cannot Be Used In A Vehicle")
		end
	end)

	Inventory.Items:RegisterUse("cigarette_pack", "RandomItems", function(source, item)
		if (item.MetaData.Count and tonumber(item.MetaData.Count) or 0) > 0 then
			Inventory:AddItem(item.Owner, "cigarette", 1, {}, 1)
			if tonumber(item.MetaData.Count) - 1 <= 0 then
				Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			else
				Inventory:SetMetaDataKey(item.id, "Count", tonumber(item.MetaData.Count) - 1)
			end
		else
			Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
			Execute:Client(source, "Notification", "Error", "Pack Has No More Cigarettes In It")
		end
	end)

	Inventory.Items:RegisterUse("armor", "RandomItems", function(source, item)
		Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		SetPedArmour(GetPlayerPed(source), 50)
	end)

	Inventory.Items:RegisterUse("heavyarmor", "RandomItems", function(source, item)
		Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		SetPedArmour(GetPlayerPed(source), 100)
	end)

	Inventory.Items:RegisterUse("pdarmor", "RandomItems", function(source, item)
		Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		SetPedArmour(GetPlayerPed(source), 100)
	end)

	Inventory.Items:RegisterUse("parts_box", "RandomItems", function(source, item)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
				if item.MetaData.Items then
					for k, v in ipairs(item.MetaData.Items) do
						Inventory:AddItem(item.Owner, v.name, v.count, {}, 1)
					end
				end
			end
		end
	end)

	Inventory.Items:RegisterUse("birthday_cake", "RandomItems", function(source, item)
		Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)
		TriggerClientEvent('Inventory:Client:RandomItems:BirthdayCake', source)
	end)

	Inventory.Items:RegisterUse("parachute", "RandomItems", function(source, item)
		Callbacks:ClientCallback(source, "Weapons:CanEquipParachute", {}, function(canEquip)
			if canEquip then
				local char = Fetch:Source(source):GetData("Character")
				if char then
					local states = char:GetData("States") or {}
					if not hasValue(states, "SCRIPT_PARACHUTE") then
						Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, item.invType)

						table.insert(states, "SCRIPT_PARACHUTE")
						char:SetData("States", states)
					else
						Execute:Client(source, "Notification", "Error", "Already Have Parachute Equipped")
					end
				end
			else
				Execute:Client(source, "Notification", "Error", "Cannot Equip Parachute")
			end
		end)
	end)

	Callbacks:RegisterServerCallback("Inventory:UsedParachute", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char then
			local states = char:GetData("States") or {}
			if hasValue(states, "SCRIPT_PARACHUTE") then
				for k, v in ipairs(states) do
					if v == "SCRIPT_PARACHUTE" then
						table.remove(states, k)
						char:SetData("States", states)
						break
					end
				end
			end
		end
	end)
end
