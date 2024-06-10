_effectCds = {
	meth = {},
	coke = {},
}

function RegisterItemUse()
	Inventory.Items:RegisterUse("meth_table", "DrugShit", function(source, slot, itemData)
		Callbacks:ClientCallback(source, "Drugs:Meth:PlaceTable", slot.id, function() end)
	end)

	Inventory.Items:RegisterUse("meth_pipe", "DrugShit", function(source, slot, itemData)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if _effectCds.meth[char:GetData("SID")] == nil or os.time() > _effectCds.meth[char:GetData("SID")] then
					local methItem = Inventory.Items:GetFirst(char:GetData("SID"), "meth_bag", 1)
					if methItem?.id ~= nil then
						_effectCds.meth[char:GetData("SID")] = os.time() + (60 * 1)
						if Inventory.Items:RemoveId(char:GetData("SID"), 1, methItem) then
							Callbacks:ClientCallback(source, "Drugs:Meth:Use", methItem.Quality, function(s)
								if s then
									Drugs.Addiction:Add(source, "Meth", 0.25)
									local drugStates = char:GetData("DrugStates") or {}
									drugStates["meth"] = {
										item = "meth_bag",
										expires = os.time() + (60 * 60),
									}
									char:SetData("DrugStates", drugStates)
									TriggerClientEvent("Drugs:Effects:Armor", source, methItem.Quality)
								end
							end)
						end
					else
						Execute:Client(source, "Notification", "Error", "You Need Meth To Smoke")
					end
				else
					Execute:Client(source, "Notification", "Error", "Cannot Use That Yet")
				end
			end
		end
	end)

	Inventory.Items:RegisterUse("meth_brick", "DrugShit", function(source, slot, itemData)
		local char = Fetch:Source(source):GetData("Character")
		if os.time() >= slot.MetaData.Finished then
			if Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
				Inventory:AddItem(
					char:GetData("SID"),
					"meth_bag",
					10,
					{},
					1,
					false,
					false,
					false,
					false,
					false,
					false,
					slot.Quality
				)
			end
		else
			Execute:Client(source, "Notification", "Error", "Not Ready Yet", 6000)
		end
	end)

	-- Inventory.Items:RegisterUse("meth_bag", "DrugShit", function(source, slot, itemData)
	-- 	local plyr = Fetch:Source(source)
	-- 	if plyr ~= nil then
	-- 		local char = plyr:GetData("Character")
	-- 		if char ~= nil then
	-- 			if _effectCds.meth[char:GetData("SID")] == nil or os.time() > _effectCds.meth[char:GetData("SID")] then
	-- 				_effectCds.meth[char:GetData("SID")] = os.time() + (60 * 1)
	-- 				if Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
	-- 					Callbacks:ClientCallback(source, "Drugs:Meth:Use", slot.Quality, function(s)
	-- 						if s then
	-- 							Drugs.Addiction:Add(source, "Meth", 0.25)
	-- 							TriggerClientEvent("Drugs:Effects:Armor", source, slot.Quality)
	-- 						end
	-- 					end)
	-- 				end
	-- 			else
	-- 				Execute:Client(source, "Notification", "Error", "Cannot Use That Yet")
	-- 			end
	-- 		end
	-- 	end
	-- end)

	Inventory.Items:RegisterUse("coke_brick", "DrugShit", function(source, slot, itemData)
		local char = Fetch:Source(source):GetData("Character")
		if Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
			Inventory:AddItem(
				char:GetData("SID"),
				"coke_bag",
				10,
				{},
				1,
				false,
				false,
				false,
				false,
				false,
				false,
				slot.Quality
			)
		end
	end)

	Inventory.Items:RegisterUse("coke_bag", "DrugShit", function(source, slot, itemData)
		local plyr = Fetch:Source(source)
		if plyr ~= nil then
			local char = plyr:GetData("Character")
			if char ~= nil then
				if _effectCds.coke[char:GetData("SID")] == nil or os.time() > _effectCds.coke[char:GetData("SID")] then
					_effectCds.coke[char:GetData("SID")] = os.time() + (60 * 3)
					if Inventory.Items:RemoveSlot(slot.Owner, slot.Name, 1, slot.Slot, slot.invType) then
						Callbacks:ClientCallback(source, "Drugs:Coke:Use", slot.Quality, function(s)
							if s then
								Drugs.Addiction:Add(source, "Coke", 0.25)
								TriggerClientEvent("Drugs:Effects:RunSpeed", source, slot.Quality)
							end
						end)
					end
				else
					Execute:Client(source, "Notification", "Error", "Cannot Use That Yet")
				end
			end
		end
	end)
end
