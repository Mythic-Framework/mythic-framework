function EMSItems()
	-- Inventory.Items:RegisterUse("tourniquet", "MedicalItems", function(source, item)
	-- 	local char = Fetch:Source(source):GetData("Character")
	-- 	if char:GetData("Damage").Bleed > 0 then
	-- 		if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
	-- 			Player(source).state.tourniquet = (
	-- 					GetGameTimer() + ((1000 * 60 * 5) / char:GetData("Damage").Bleed or 1)
	-- 				)
	-- 		end
	-- 	else
	-- 		Execute:Client(source, "Notification", "Error", "You're Not Bleeding")
	-- 	end
	-- end)

	Inventory.Items:RegisterUse("morphine", "MedicalItems", function(source, item)
		if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
			Damage.Effects:Painkiller(source, 1)
		end
	end)

	Inventory.Items:RegisterUse("oxy", "MedicalItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state
		if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
			Damage.Effects:Painkiller(source, 2)

			if pState.healTicks ~= nil then
				local f = pState.healTicks
				for i = 1, 5 do
					table.insert(f, "5")
				end
				pState.healTicks = f
			else
				pState.healTicks = { "5", "5", "5", "5", "5" }
			end
		end
	end)

	Inventory.Items:RegisterUse("bandage", "MedicalItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		local ped = GetPlayerPed(source)
		local curr = GetEntityHealth(ped)
		local max = GetEntityMaxHealth(ped)
		local pState = Player(source).state
		if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
			local heal = 10
			if curr < (max * 0.75) then
				local p = promise.new()
				Callbacks:ClientCallback(source, "EMS:Heal", heal, function(s)
					p:resolve(s)
				end)
				Citizen.Await(p)
			end

			if pState.healTicks ~= nil then
				local f = pState.healTicks
				for i = 1, 2 do
					table.insert(f, "5")
				end
				pState.healTicks = f
			else
				pState.healTicks = { "5", "5" }
			end
		end
	end)

	Inventory.Items:RegisterUse("firstaid", "MedicalItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		local ped = GetPlayerPed(source)
		local curr = GetEntityHealth(ped)
		local max = GetEntityMaxHealth(ped)
		local pState = Player(source).state
		if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
			local p = promise.new()
			local heal = 15
			if curr + heal > max then
				heal = max - curr
			end
			Callbacks:ClientCallback(source, "EMS:Heal", heal, function(s)
				p:resolve(s)
			end)
			Citizen.Await(p)

			if pState.healTicks ~= nil then
				local f = pState.healTicks
				for i = 1, 2 do
					table.insert(f, "10")
				end

				table.insert(f, "5")
				
				pState.healTicks = f
			else
				pState.healTicks = { "10", "10", "5" }
			end
		end
	end)

	Inventory.Items:RegisterUse("ifak", "MedicalItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		local ped = GetPlayerPed(source)
		local curr = GetEntityHealth(ped)
		local max = GetEntityMaxHealth(ped)
		local pState = Player(source).state
		if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
			local p = promise.new()
			local heal = 30
			if curr + heal > max then
				heal = max - curr
			end
			Callbacks:ClientCallback(source, "EMS:Heal", heal, function(s)
				p:resolve(s)
			end)
			Citizen.Await(p)

			if pState.healTicks ~= nil then
				local f = pState.healTicks
				for i = 1, 2 do
					table.insert(f, "15")
				end
				table.insert(f, "10")
				for i = 1, 2 do
					table.insert(f, "5")
				end
				
				pState.healTicks = f
			else
				pState.healTicks = { "15", "15", "10", "5", "5" }
			end
		end
	end)

	-- Inventory.Items:RegisterUse("gauze", "MedicalItems", function(source, item)
	-- 	local char = Fetch:Source(source):GetData("Character")
	-- 	if Inventory.Items:RemoveSlot(item.Owner, item.Name, 1, item.Slot, 1) then
	-- 		local dmg = char:GetData("Damage")
	-- 		if dmg.Bleed > 1 then
	-- 			dmg.Bleed = dmg.Bleed - 1
	-- 			char:SetData("Damage", dmg)
	-- 		else
	-- 			Execute:Client(source, "Notification", "Error", "You continue bleeding through the gauze")
	-- 		end
	-- 	end
	-- end)

	Inventory.Items:RegisterUse("medicalkit", "MedicalItems", function(source, item)
		local char = Fetch:Source(source):GetData("Character")
		if Jobs.Permissions:HasJob(source, "ems", false, false, 2) then
			local myCoords = GetEntityCoords(GetPlayerPed(source))
			for k, v in pairs(Fetch:All()) do
				if v ~= nil then
					if v:GetData("Source") ~= source and Player(v:GetData("Source")).state.isHospitalized then
						local tPos = GetEntityCoords(GetPlayerPed(v:GetData("Source")))
						local dist = #(vector3(myCoords.x, myCoords.y, myCoords.z) - vector3(tPos.x, tPos.y, tPos.z))
						if dist <= 5 then
							TriggerClientEvent("EMS:Client:TreatWounds", source, v:GetData("Source"))
							return
						end
					end
				end
			end
			Execute:Client(source, "Notification", "Error", "Not Near Any Hospitalized Patients")
		else
			Execute:Client(source, "Notification", "Error", "You're not trained to use this")
		end
	end)
end
