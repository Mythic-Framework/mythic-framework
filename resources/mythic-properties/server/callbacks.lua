function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Properties:RingDoorbell", function(source, data, cb)
		TriggerClientEvent("Properties:Client:Doorbell", -1, data)
		cb()
	end)

	Callbacks:RegisterServerCallback("Properties:RequestAgent", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = GlobalState[string.format("Property:%s", data)]
		if property ~= nil then
			for k, v in pairs(Fetch:All()) do
				local c = v:GetData("Character")
				if c ~= nil then
					if Jobs.Permissions:HasPermissionInJob(v:GetData("Source"), 'realestate', 'JOB_SELL') then
						Phone.Email:Send(
							v:GetData("Source"),
							char:GetData("Alias").email,
							os.time() * 1e3,
							"Requesting Agent",
							string.format(
								"Hello,<br /><br />I am interested in buying %s and would like to view the property.<br /><br />You can reach me at %s.<br /><br />Thanks!<br />- %s %s",
								property.label,
								char:GetData("Phone"),
								char:GetData("First"),
								char:GetData("Last")
							),
							{
								location = {
									x = property.location.front.x,
									y = property.location.front.y,
									z = property.location.front.z,
								},
								expires = (os.time() + (60 * 20)) * 1000,
							}
						)
					end
				end
			end
			cb(true)
			return
		end
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Properties:EditProperty", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = GlobalState[string.format("Property:%s", data.property)]
		if property ~= nil and Player(source).state.onDuty == "realestate" and data.location then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)

			if data.location == "garage" then
				local pos = {
					x = coords.x + 0.0,
					y = coords.y + 0.0,
					z = coords.z + 0.0,
					h = heading + 0.0
				}

				cb(Properties.Manage:AddGarage(data.property, pos))
			elseif data.location == "backdoor" then
				local pos = {
					x = coords.x + 0.0,
					y = coords.y + 0.0,
					z = coords.z - 1.2,
					h = heading + 0.0
				}

				cb(Properties.Manage:AddBackdoor(data.property, pos))
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Properties:SpawnInside", function(source, data, cb)
		local property = GlobalState[string.format("Property:%s", data.id)]
		if property ~= nil then
			local routeId = Routing:RequestRouteId("Properties:" .. data.id, false)
			Routing:AddPlayerToRoute(source, routeId)
			GlobalState[string.format("%s:Property", source)] = data.id
			Middleware:TriggerEvent("Properties:Enter", source, data.id)
			TriggerClientEvent("Properties:Client:InnerStuff", source, data.id, true)

			Player(source).state.tpLocation = property?.location?.front
		end
		cb(true)
	end)

	Callbacks:RegisterServerCallback("Properties:EnterProperty", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = GlobalState[string.format("Property:%s", data)]

		if
			(property.keys ~= nil and property.keys[char:GetData("ID")])
			or (not property.sold and Jobs.Permissions:HasPermissionInJob(source, 'realestate', 'JOB_DOORS'))
			or not property.locked or Police:IsInBreach(source, 'property', data)
		then
			Pwnzor.Players:TempPosIgnore(source)
			local routeId = Routing:RequestRouteId("Properties:" .. data, false)
			Routing:AddPlayerToRoute(source, routeId)
			GlobalState[string.format("%s:Property", source)] = data
			Middleware:TriggerEvent("Properties:Enter", source, data)
			TriggerClientEvent("Properties:Client:InnerStuff", source, data)

			Player(source).state.tpLocation = property?.location?.front

			cb(true)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Properties:ExitProperty", function(source, data, cb)
		local property = GlobalState[string.format("%s:Property", source)]

		Pwnzor.Players:TempPosIgnore(source)
		Middleware:TriggerEvent("Properties:Exit", source, data)
		Routing:RoutePlayerToGlobalRoute(source)
		GlobalState[string.format("%s:Property", source)] = nil

		Player(source).state.tpLocation = nil

		cb(property)
	end)

	Callbacks:RegisterServerCallback("Properties:ChangeLock", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = GlobalState[string.format("Property:%s", data.id)]

		if
			(property.keys ~= nil and property.keys[char:GetData("ID")])
			or (not property.sold and Jobs.Permissions:HasPermissionInJob(source, 'realestate', 'JOB_DOORS'))
		then
			cb(Properties.Utils:SetLock(data.id, data.state))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Properties:Validate", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local property = GlobalState[string.format("Property:%s", data.id)]

		if data.type == "closet" then
			cb(property.keys and property.keys[char:GetData("ID")] ~= nil)
		elseif data.type == "logout" then
			cb(property.keys and property.keys[char:GetData("ID")] ~= nil)
		elseif data.type == "stash" then
			if property.keys and property.keys[char:GetData("ID")] ~= nil and property.id or Police:IsInBreach(source, 'property', property.id, true) then
				local invType = 1000
				if property.interior and PropertyConfig[property.interior] and PropertyConfig[property.interior].invType then
					invType = PropertyConfig[property.interior].invType
				end

				local invId = string.format('Property:%s', property.id)

				Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
					invType = invType,
					owner = invId,
				}, function()
					Inventory:OpenSecondary(source, invType, invId)
				end)
			end

			cb(true)
		else
			cb(false)
		end
	end)
end
