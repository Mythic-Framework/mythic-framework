_isEntering = false

RegisterNetEvent("Properties:Client:Cleanup", function(propertyId)
	if propertyId ~= nil then
		local property = GlobalState[string.format("Property:%s", propertyId)]
		if property ~= nil then
			local property = GlobalState[string.format(
				"Property:%s",
				GlobalState[string.format("%s:Property", LocalPlayer.state.ID)]
			)]

			if property and property.id then
				Targeting.Zones:RemoveZone(string.format("property-%s-logout", property.id))
				Targeting.Zones:RemoveZone(string.format("property-%s-closet", property.id))
				Targeting.Zones:RemoveZone(string.format("property-%s-stash", property.id))
				Targeting.Zones:RemoveZone(string.format("property-%s-exit", property.id))
				Targeting.Zones:RemoveZone(string.format("property-%s-exit-back", property.id))
				Targeting.Zones:RemoveZone(string.format("property-%s-warehouse", property.id))
				Targeting.Zones:RemoveZone(string.format("property-%s-office", property.id))
			end
		end
	end
end)

RegisterNetEvent("Properties:Client:Doorbell", function(propertyId)
	if propertyId == GlobalState[string.format("%s:Property", LocalPlayer.state.ID)] then
		Sounds.Play:One("doorbell.ogg", 0.75)
	end
end)

RegisterNetEvent("Properties:Client:InnerStuff", function(propertyId, wakeUp)
	_isEntering = true

	while GlobalState[string.format("%s:Property", LocalPlayer.state.ID)] == nil do
		Citizen.Wait(10)
		print("Interior Stuff Waiting, This Shouldn't Spam")
	end

	local property = GlobalState[string.format("Property:%s", propertyId)]
	local intr = GlobalState[string.format("Properties:Interior:%s", property.interior)]

	TriggerEvent("Interiors:Enter", vector3(intr.x, intr.y, intr.z), propertyId, property.interior, property.data)

	if wakeUp and intr.locations.wakeup then
		Citizen.SetTimeout(250, function()
			Animations.Emotes:WakeUp(intr.locations.wakeup)
		end)
	end

	Targeting.Zones:RemoveZone(string.format("property-%s-logout", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-closet", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-stash", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-exit", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-exit-back", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-warehouse", propertyId))
	Targeting.Zones:RemoveZone(string.format("property-%s-office", propertyId))

	Citizen.Wait(100)

	if intr.locations.logout then
		Targeting.Zones:AddBox(
			string.format("property-%s-logout", propertyId),
			"bed-front",
			vector3(intr.locations.logout.x, intr.locations.logout.y, intr.locations.logout.z),
			intr.locations.logout.l,
			intr.locations.logout.w,
			intr.locations.logout.extras,
			{
				{
					icon = "bed-front",
					text = "Switch Characters",
					event = "Properties:Client:Logout",
					data = propertyId,
					isEnabled = function(data)
						local property = GlobalState[string.format("Property:%s", data)]
						return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil
					end,
				},
			},
			3.0,
			true
		)
	end

	if intr.locations.closet then
		Targeting.Zones:AddBox(
			string.format("property-%s-closet", propertyId),
			"shirt",
			vector3(intr.locations.closet.x, intr.locations.closet.y, intr.locations.closet.z),
			intr.locations.closet.l,
			intr.locations.closet.w,
			intr.locations.closet.extras,
			{
				{
					icon = "shirt",
					text = "Wardrobe",
					event = "Properties:Client:Closet",
					data = propertyId,
					isEnabled = function(data)
						local property = GlobalState[string.format("Property:%s", data)]
						return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil
					end,
				},
			},
			3.0,
			true
		)
	end

	Targeting.Zones:AddBox(
		string.format("property-%s-stash", propertyId),
		"toolbox",
		vector3(intr.locations.stash.x, intr.locations.stash.y, intr.locations.stash.z),
		intr.locations.stash.l,
		intr.locations.stash.w,
		intr.locations.stash.extras,
		{
			{
				icon = "toolbox",
				text = "Stash",
				event = "Properties:Client:Stash",
				data = propertyId,
				isEnabled = function(data)
					local property = GlobalState[string.format("Property:%s", data)]
					return (property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil) or LocalPlayer.state.onDuty == "police"
				end,
			},
		},
		2.0,
		true
	)

	Targeting.Zones:AddBox(
		string.format("property-%s-exit", propertyId),
		"door-open",
		vector3(intr.locations.exit.x, intr.locations.exit.y, intr.locations.exit.z),
		intr.locations.exit.l,
		intr.locations.exit.w,
		intr.locations.exit.extras,
		{
			{
				icon = "door-open",
				text = "Exit",
				event = "Properties:Client:Exit",
				data = {
					property = propertyId,
					backdoor = false,
				},
			},
		},
		2.0,
		true
	)

	if intr.locations.backdoor then
		Targeting.Zones:AddBox(
			string.format("property-%s-exit-back", propertyId),
			"door-open",
			vector3(intr.locations.backdoor.x, intr.locations.backdoor.y, intr.locations.backdoor.z),
			intr.locations.backdoor.l,
			intr.locations.backdoor.w,
			intr.locations.backdoor.extras,
			{
				{
					icon = "door-open",
					text = "Exit",
					event = "Properties:Client:Exit",
					data = {
						property = propertyId,
						backdoor = true,
					},
				},
			},
			2.0,
			true
		)
	end

	-- if intr.locations.warehouse then
	-- 	Targeting.Zones:AddBox(
	-- 		string.format("property-%s-warehouse", propertyId),
	-- 		"warehouse-full",
	-- 		vector3(intr.locations.warehouse.x, intr.locations.warehouse.y, intr.locations.warehouse.z),
	-- 		intr.locations.warehouse.l,
	-- 		intr.locations.warehouse.w,
	-- 		intr.locations.warehouse.extras,
	-- 		{
	-- 			{
	-- 				icon = "bed-front",
	-- 				text = "Switch Characters",
	-- 				event = "Properties:Client:Logout",
	-- 				data = propertyId,
	-- 				isEnabled = function(data)
	-- 					local property = GlobalState[string.format("Property:%s", data)]
	-- 					return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil
	-- 				end,
	-- 			},
	-- 			{
	-- 				icon = "shirt",
	-- 				text = "Wardrobe",
	-- 				event = "Properties:Client:Closet",
	-- 				data = propertyId,
	-- 				isEnabled = function(data)
	-- 					local property = GlobalState[string.format("Property:%s", data)]
	-- 					return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil
	-- 				end,
	-- 			},
	-- 		},
	-- 		2.0,
	-- 		true
	-- 	)
	-- end

	if intr.locations.office then
		Targeting.Zones:AddBox(
			string.format("property-%s-office", propertyId),
			"phone-office",
			vector3(intr.locations.office.x, intr.locations.office.y, intr.locations.office.z),
			intr.locations.office.l,
			intr.locations.office.w,
			intr.locations.office.extras,
			{
				{
					icon = "clipboard",
					text = "Go On/Off Duty",
					event = "Properties:Client:Duty",
					data = propertyId,
					isEnabled = function(data)
						local property = GlobalState[string.format("Property:%s", data)]
						return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil and property?.data?.jobDuty
					end,
				},
			},
			2.0,
			true
		)
	end

	if intr.locations.crafting and GlobalState[string.format("Property:Crafting:%s", propertyId)] then
		local menu = {
			{
				icon = "screwdriver-wrench",
				text = "Use",
				event = "Properties:Client:Crafting",
				data = propertyId,
				isEnabled = function(data)
					local property = GlobalState[string.format("Property:%s", data)]
					return property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil
				end,
			},
		}

		if GlobalState[string.format("Property:Crafting:%s", propertyId)].schematics then
			table.insert(menu, {
				icon = "memo-circle-check",
				text = "Add Schematic To Bench",
				event = "Crafting:Client:AddSchematic",
				data = {
					id = string.format("property-%s", propertyId),
				},
				isEnabled = function(data, entityData)
					return Inventory.Items:HasType(17, 1)
				end,
			})
		end

		Targeting.Zones:AddBox(
			string.format("property-%s-crafting", propertyId),
			"screwdriver-wrench",
			vector3(intr.locations.crafting.x, intr.locations.crafting.y, intr.locations.crafting.z),
			intr.locations.crafting.l,
			intr.locations.crafting.w,
			intr.locations.crafting.extras,
			menu,
			2.0,
			true
		)
	end

	Citizen.Wait(1000)
	Sync:Stop(1)
	Targeting.Zones:Refresh()

	_isEntering = false
end)

---- TARGETTING EVENTS ----
AddEventHandler("Properties:Client:Stash", function(t, data)
	Properties.Extras:Stash()
end)

AddEventHandler("Properties:Client:Closet", function(t, data)
	Properties.Extras:Closet()
end)

AddEventHandler("Properties:Client:Logout", function(t, data)
	Properties.Extras:Logout()
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if data.PROPERTY_INTERIOR_ZONE and GlobalState[string.format("%s:Property", LocalPlayer.state.ID)] then
        print("Exit Property By Leaving Polyzone")
		ExitProperty()
    end
end)

AddEventHandler("Properties:Client:Exit", function(t, data)
	ExitProperty(data.property, data.backdoor)
end)

AddEventHandler("Properties:Client:Crafting", function(t, data)
	Crafting.Benches:Open('property-'..data)
end)

AddEventHandler("Properties:Client:Duty", function(t, data)
	local property = GlobalState[string.format("Property:%s", data)]
	if property?.data?.jobDuty then
		if LocalPlayer.state.onDuty == property?.data?.jobDuty then
			Jobs.Duty:Off(property?.data?.jobDuty)
		else
			Jobs.Duty:On(property?.data?.jobDuty)
		end
	end
end)


RegisterNetEvent("Characters:Client:Spawn", function()
	TriggerEvent("Properties:Client:AddBlips")
end)

RegisterNetEvent("Properties:Client:AddBlips", function()
	while LocalPlayer.state.Character == nil do
		Citizen.Wait(5)
	end

	if GlobalState.Properties then
		for k, v in ipairs(GlobalState.Properties) do
			local prop = GlobalState[string.format("Property:%s", v)]
			if prop and prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil then
				if prop.type == 'house' then
					Blips:Add('property-'.. prop.id, 'House: ' .. prop.label, vector3(prop.location.front.x, prop.location.front.y, prop.location.front.z), 40, 53, 0.6, 2)
				elseif prop.type == 'office' then
					Blips:Add('property-'.. prop.id, 'Office: ' .. prop.label, vector3(prop.location.front.x, prop.location.front.y, prop.location.front.z), 475, 53, 0.6, 2)
				elseif prop.type == 'warehouse' then
					Blips:Add('property-'.. prop.id, 'Warehouse: ' .. prop.label, vector3(prop.location.front.x, prop.location.front.y, prop.location.front.z), 473, 53, 0.6, 2)
				end
			end
		end
	end
end)