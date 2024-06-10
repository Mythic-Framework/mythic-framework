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
	{ 19, { name = "electronic_parts", min = 5, max = 25 } },
	{ 19, { name = "plastic", min = 20, max = 120 } },
	{ 19, { name = "rubber", min = 20, max = 120 } },
	{ 19, { name = "copperwire", min = 50, max = 250 } },
	{ 19, { name = "glue", min = 10, max = 55 } },
	{ 5, { name = "ironbar", min = 10, max = 50 } },
}

function RegisterRandomItems()
	Inventory.Items:RegisterUse("cigarette", "RandomItems", function(source, item)
		if GetVehiclePedIsIn(GetPlayerPed(source)) == 0 then
			local char = Fetch:Source(source):GetData("Character")
			Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)
			Player(source).state.stressTicks = { "3", "3", "3", "3", "3", "3", "3", "3" }
		else
			Execute:Client(source, "Notification", "Error", "Cannot Be Used In A Vehicle")
		end
	end)

	Inventory.Items:RegisterUse("cigarette_pack", "RandomItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		if (item.MetaData.Count and tonumber(item.MetaData.Count) or 0) > 0 then
			Inventory:AddItem(char:GetData("ID"), "cigarette", 1, {}, 1)
			if tonumber(item.MetaData.Count) - 1 <= 0 then
				Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)
			else
				Inventory:SetMetaDataKey(char:GetData("ID"), 1, item.Slot, "Count", tonumber(item.MetaData.Count) - 1)
			end
		else
			Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)
			Execute:Client(source, "Notification", "Error", "Pack Has No More Cigarettes In It")
		end
	end)

	Inventory.Items:RegisterUse("armor", "RandomItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)
		SetPedArmour(GetPlayerPed(source), 50)
	end)

	Inventory.Items:RegisterUse("heavyarmor", "RandomItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)
		SetPedArmour(GetPlayerPed(source), 100)
	end)

	Inventory.Items:RegisterUse("pdarmor", "RandomItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)
		SetPedArmour(GetPlayerPed(source), 100)
	end)

	Inventory.Items:RegisterUse("parts_box", "RandomItems", function(source, itemData)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				Inventory:RemoveItem(itemData.Owner, itemData.Name, 1, itemData.Slot, itemData.invType)
				if itemData.MetaData.Items then
					for k, v in ipairs(itemData.MetaData.Items) do
						Inventory:AddItem(char:GetData("ID"), v.name, v.count, {}, 1)
					end
				end
			end
		end
	end)

	Inventory.Items:RegisterUse("birthday_cake", "RandomItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		Inventory:RemoveItem(char:GetData("ID"), item.Name, 1, item.Slot, 1)
		TriggerClientEvent('Inventory:Client:RandomItems:BirthdayCake', source)
	end)
end
