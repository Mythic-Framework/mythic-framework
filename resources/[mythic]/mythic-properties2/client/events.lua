_isEntering = false

-- RegisterNetEvent("Properties:Client:Cleanup", function(propertyId)
-- 	if propertyId ~= nil then
-- 		local property = GlobalState[string.format("Property:%s", propertyId)]
-- 		if property ~= nil then
-- 			local property = GlobalState[string.format(
-- 				"Property:%s",
-- 				GlobalState[string.format("%s:Property", LocalPlayer.state.ID)]
-- 			)]

-- 			if property and property.id then
-- 				Targeting.Zones:RemoveZone(string.format("property-%s-logout", property.id))
-- 				Targeting.Zones:RemoveZone(string.format("property-%s-closet", property.id))
-- 				Targeting.Zones:RemoveZone(string.format("property-%s-stash", property.id))
-- 				Targeting.Zones:RemoveZone(string.format("property-%s-exit", property.id))
-- 				Targeting.Zones:RemoveZone(string.format("property-%s-exit-back", property.id))
-- 				Targeting.Zones:RemoveZone(string.format("property-%s-warehouse", property.id))
-- 				Targeting.Zones:RemoveZone(string.format("property-%s-office", property.id))
-- 			end
-- 		end
-- 	end
-- end)

RegisterNetEvent("Properties:Client:Doorbell", function(propertyId)
	if _insideProperty and propertyId == _insideProperty.id then
		Sounds.Play:One("doorbell.ogg", 0.75)
	end
end)

RegisterNetEvent("Properties:Client:InnerStuff", function(propertyData, int, furniture)
	_insideProperty = propertyData
	_insideInterior = int
	_isEntering = true

	local interior = PropertyInteriors[int]

	TriggerEvent("Interiors:Enter", interior.locations.front.coords, propertyData.id, int, propertyData.data)

	-- if wakeUp and intr.locations.wakeup then
	-- 	SetTimeout(250, function()
	-- 		Animations.Emotes:WakeUp(intr.locations.wakeup)
	-- 	end)
	-- end

	Sync:Stop(1)

	CreatePropertyZones(propertyData.id, int)

	CreateFurniture(furniture)

	_isEntering = false

	Wait(500)
	Sync:Stop(1)
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
	if LocalPlayer.state.loggedIn and data.PROPERTY_INTERIOR_ZONE and _insideProperty and not _isEntering then
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
	if not _propertiesLoaded then
		return
	end

	local property = _properties[data]
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
	while LocalPlayer.state.Character == nil or not _propertiesLoaded or not LocalPlayer.state.loggedIn do
		Wait(100)
	end

	local ownedProps = Properties:GetPropertiesWithAccess()

	if ownedProps then
		for k, v in ipairs(ownedProps) do
			if v.type == 'house' then
				Blips:Add('property-'.. v.id, 'House: ' .. v.label, vector3(v.location.front.x, v.location.front.y, v.location.front.z), 40, 53, 0.6, 2)
			elseif v.type == 'office' then
				Blips:Add('property-'.. v.id, 'Office: ' .. v.label, vector3(v.location.front.x, v.location.front.y, v.location.front.z), 475, 53, 0.6, 2)
			elseif v.type == 'warehouse' then
				Blips:Add('property-'.. v.id, 'Warehouse: ' .. v.label, vector3(v.location.front.x, v.location.front.y, v.location.front.z), 473, 53, 0.6, 2)
			end
		end
	end
end)