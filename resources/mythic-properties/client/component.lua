AddEventHandler("Properties:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Characters = exports["mythic-base"]:FetchComponent("Characters")
	Wardrobe = exports["mythic-base"]:FetchComponent("Wardrobe")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Properties = exports["mythic-base"]:FetchComponent("Properties")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Sync = exports["mythic-base"]:FetchComponent("Sync")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Crafting = exports["mythic-base"]:FetchComponent("Crafting")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Properties", {
		"Callbacks",
		"Inventory",
		"Logger",
		"Utils",
		"Notification",
		"Action",
		"Targeting",
		"Sounds",
		"Characters",
		"Wardrobe",
		"Interaction",
		"Inventory",
		"Properties",
		"Jobs",
		"Sync",
		"Crafting",
		"Blips",
		"Polyzone",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()

		Interaction:RegisterMenu("properties", "Property", "house", function(data)
			Interaction:ShowMenu({
				{
					icon = "door-open",
					label = "Enter",
					action = function()
						EnterProperty(data, false)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]
						return ((prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil)
							or (not prop.sold and LocalPlayer.state.onDuty == "realestate" and Jobs.Permissions:HasPermissionInJob(
								"realestate",
								"JOB_DOORS"
							))
							or not prop.locked) and not prop.foreclosed
					end,
				},
				{
					icon = "lock-open",
					label = "Unlock",
					action = function()
						Callbacks:ServerCallback("Properties:ChangeLock", {
							id = data.propertyId,
							state = false,
						}, function(state)
							if state then
								Notification:Success("Property Unlocked")
							else
								Notification:Error("Unable to Unlock Property")
							end
							Interaction:Hide()
						end)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]
						if
							((prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil)
							or (
								not prop.sold
								and LocalPlayer.state.onDuty == "realestate"
								and Jobs.Permissions:HasPermissionInJob("realestate", "JOB_DOORS")
							)) and not prop.foreclosed
						then
							return prop.locked
						else
							return false
						end
					end,
				},
				{
					icon = "lock",
					label = "Lock",
					action = function()
						Callbacks:ServerCallback("Properties:ChangeLock", {
							id = data.propertyId,
							state = true,
						}, function(state)
							if state then
								Notification:Success("Property Locked")
							else
								Notification:Error("Unable to Unlock Property")
							end
							Interaction:Hide()
						end)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]

						if
							((prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil)
							or (
								not GlobalState[string.format("Property:%s", data.propertyId)].sold
								and LocalPlayer.state.onDuty == "realestate"
								and Jobs.Permissions:HasPermissionInJob("realestate", "JOB_DOORS")
							)) and not prop.foreclosed
						then
							return not GlobalState[string.format("Property:%s", data.propertyId)].locked
						else
							return false
						end
					end,
				},
				{
					icon = "bells",
					label = "Ring Doorbell",
					action = function()
						Callbacks:ServerCallback("Properties:RingDoorbell", data.propertyId, function()
							Sounds.Play:One("doorbell.ogg", 0.75)
						end)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]
						return prop.sold and not prop.foreclosed and prop.type == "house"
					end,
				},
				{
					icon = "house-chimney-crack",
					label = "Property is Foreclosed",
					action = function()
						Notification:Error('This Property Has Been Foreclosed! This is why you should pay your property loans...', 10000)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]
						return prop.foreclosed
					end,
				},
				{
					icon = "sign-hanging",
					label = "Request Agent",
					action = function()
						Callbacks:ServerCallback("Properties:RequestAgent", data.propertyId, function(state)
							if state then
								Notification:Success("Notification Sent")
							else
								Notification:Error("Unable To Send Notification")
							end
							Interaction:Hide()
						end)
					end,
					shouldShow = function()
						return not GlobalState[string.format("Property:%s", data.propertyId)].sold
					end,
				},
			})
		end, function()
			return Properties:GetNearHouse()
		end, function()
			local prop = Properties:GetNearHouse()
			return type(prop) == "table" and GlobalState[string.format("Property:%s", prop.propertyId)]?.label or 'Property'
		end)

		Interaction:RegisterMenu("properties-backdoor", "Property", "house", function(data)
			Interaction:ShowMenu({
				{
					icon = "door-open",
					label = "Enter",
					action = function()
						EnterProperty(data, true)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]
						return ((prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil) or not prop.locked) and not prop.foreclosed
					end,
				},
				{
					icon = "lock-open",
					label = "Unlock",
					action = function()
						Callbacks:ServerCallback("Properties:ChangeLock", {
							id = data.propertyId,
							state = false,
						}, function(state)
							if state then
								Notification:Success("Property Unlocked")
							else
								Notification:Error("Unable to Unlock Property")
							end
							Interaction:Hide()
						end)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]
						if
							(prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil) and not prop.foreclosed
						then
							return prop.locked
						else
							return false
						end
					end,
				},
				{
					icon = "lock",
					label = "Lock",
					action = function()
						Callbacks:ServerCallback("Properties:ChangeLock", {
							id = data.propertyId,
							state = true,
						}, function(state)
							if state then
								Notification:Success("Property Locked")
							else
								Notification:Error("Unable to Unlock Property")
							end
							Interaction:Hide()
						end)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]

						if
							(prop.keys ~= nil and prop.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil) and not prop.foreclosed
						then
							return not GlobalState[string.format("Property:%s", data.propertyId)].locked
						else
							return false
						end
					end,
				},
				{
					icon = "house-chimney-crack",
					label = "Property is Foreclosed",
					action = function()
						Notification:Error('This Property Has Been Foreclosed! This is why you should pay your property loans...', 10000)
					end,
					shouldShow = function()
						local prop = GlobalState[string.format("Property:%s", data.propertyId)]
						return prop.foreclosed
					end,
				},
			})
		end, function()
			return Properties:GetNearHouseBackdoor()
		end, function()
			local prop = Properties:GetNearHouseBackdoor()
			return type(prop) == "table" and GlobalState[string.format("Property:%s", prop.propertyId)]?.label or 'Property'
		end)

		Interaction:RegisterMenu("house-exit", "Exit", "door-open", function(data)
			Interaction:Hide()
			ExitProperty(data, data == 'back')
		end, function()
			if GlobalState[string.format("%s:Property", LocalPlayer.state.ID)] ~= nil then
				local property = GlobalState[string.format(
					"Property:%s",
					GlobalState[string.format("%s:Property", LocalPlayer.state.ID)]
				)]
				local intr = GlobalState[string.format("Properties:Interior:%s", property.interior)]
				local dist = #(
						vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
						- intr.exit
					)
				if dist <= 2.0 then
					return 'front'
				elseif intr.backdoorExit then
					backDist = #(
						vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
						- intr.backdoorExit
					)

					if backDist <= 2.0 then
						return 'back'
					else
						return false
					end
				end
			else
				return false
			end
		end)

		Interaction:RegisterMenu("house-lock", "Lock", "lock", function(data)
			Interaction:Hide()
			Callbacks:ServerCallback("Properties:ChangeLock", {
				id = data,
				state = true,
			}, function(state)
				if state then
					Notification:Success("Property Locked")
				else
					Notification:Error("Unable to Lock Property")
				end
			end)
		end, function()
			if GlobalState[string.format("%s:Property", LocalPlayer.state.ID)] ~= nil then
				local property = GlobalState[string.format(
					"Property:%s",
					GlobalState[string.format("%s:Property", LocalPlayer.state.ID)]
				)]

				if property.locked then
					return false
				end

				local intr = GlobalState[string.format("Properties:Interior:%s", property.interior)]
				local dist = #(
						vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
						- intr.exit
					)
				local backDist
				if intr.backdoorExit then
					backDist = #(
						vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
						- intr.backdoorExit
					)
				end
				if (dist <= 2.0 or (backDist and backDist <= 2.0)) then
					return property.id
				end
			else
				return false
			end
		end)

		Interaction:RegisterMenu("house-unlock", "Unlock", "unlock", function(data)
			Interaction:Hide()
			Callbacks:ServerCallback("Properties:ChangeLock", {
				id = data,
				state = false,
			}, function(state)
				if state then
					Notification:Success("Property Unlocked")
				else
					Notification:Error("Unable to Unlock Property")
				end
			end)
		end, function()
			if GlobalState[string.format("%s:Property", LocalPlayer.state.ID)] ~= nil then
				local property = GlobalState[string.format(
					"Property:%s",
					GlobalState[string.format("%s:Property", LocalPlayer.state.ID)]
				)]

				if
					property.locked
					and (
						(property.keys ~= nil and property.keys[LocalPlayer.state.Character:GetData("ID")] ~= nil)
						or (
							not property.sold
							and LocalPlayer.state.onDuty == "realestate"
							and Jobs.Permissions:HasPermissionInJob("realestate", "JOB_DOORS")
						)
					)
				then
					local intr = GlobalState[string.format("Properties:Interior:%s", property.interior)]
					local dist = #(
							vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
							- intr.exit
						)
					local backDist
					if intr.backdoorExit then
						backDist = #(
							vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
							- intr.backdoorExit
						)
					end
					if (dist <= 2.0 or (backDist and backDist <= 2.0)) then
						return property.id
					end
				else
					return false
				end
			else
				return false
			end
		end)

		for k, v in ipairs(GlobalState["Properties:InteriorZones"]) do
			Polyzone.Create:Box(
				string.format("property-int-zone-%s", k),
				v.center,
				v.length,
				v.width,
				v.options,
				{
					PROPERTY_INTERIOR_ZONE = true,
				}
			)
		end
	end)
end)

PROPERTIES = {
	Enter = function(self, id)
		EnterProperty({
			propertyId = id,
		}, false)
	end,
	GetNearHouse = function(self)
		if LocalPlayer.state.currentRoute ~= 0 then
			return false
		end

		local mypos = GetEntityCoords(PlayerPedId())

		if GlobalState["Properties"] == nil then
			return false
		else
			local closest = nil
			for k, v in ipairs(GlobalState["Properties"]) do
				local prop = GlobalState[string.format("Property:%s", v)]
				local dist = #(
						vector3(mypos.x, mypos.y, mypos.z)
						- vector3(prop.location.front.x, prop.location.front.y, prop.location.front.z)
					)
				if dist < 3.0 and (not closest or dist < closest.dist) then
					closest = {
						dist = dist,
						propertyId = prop.id,
					}
				end
			end
			return closest
		end
	end,
	GetNearHouseBackdoor = function(self)
		if LocalPlayer.state.currentRoute ~= 0 then
			return false
		end

		local mypos = GetEntityCoords(PlayerPedId())

		if GlobalState["Properties"] == nil then
			return false
		else
			local closest = nil
			for k, v in ipairs(GlobalState["Properties"]) do
				local prop = GlobalState[string.format("Property:%s", v)]
				if prop.location.backdoor then
					local dist = #(
							vector3(mypos.x, mypos.y, mypos.z)
							- vector3(prop.location.backdoor.x, prop.location.backdoor.y, prop.location.backdoor.z)
						)
					if dist < 3.0 and (not closest or dist < closest.dist) then
						closest = {
							dist = dist,
							propertyId = prop.id,
						}
					end
				end
			end
			return closest
		end
	end,
	GetNearHouseGarage = function(self, coordOverride)
		if LocalPlayer.state.currentRoute ~= 0 then
			return false
		end

		local mypos = coordOverride and coordOverride or GetEntityCoords(PlayerPedId())

		if GlobalState["Properties"] == nil then
			return false
		else
			local closest = nil
			for k, v in ipairs(GlobalState["Properties"]) do
				local prop = GlobalState[string.format("Property:%s", v)]
				if prop.location.garage then
					local dist = #(
							vector3(mypos.x, mypos.y, mypos.z)
							- vector3(prop.location.garage.x, prop.location.garage.y, prop.location.garage.z)
						)
					if dist < 4.0 and (not closest or dist < closest.dist) then
						closest = {
							coords = prop.location.garage,
							dist = dist,
							propertyId = prop.id,
						}
					end
				end
			end
			return closest
		end
	end,
	Extras = {
		Stash = function(self)
			Callbacks:ServerCallback("Properties:Validate", {
				id = GlobalState[string.format("%s:Property", LocalPlayer.state.ID)],
				type = "stash",
			})
		end,
		Closet = function(self)
			Callbacks:ServerCallback("Properties:Validate", {
				id = GlobalState[string.format("%s:Property", LocalPlayer.state.ID)],
				type = "closet",
			}, function(state)
				if state then
					Wardrobe:Show()
				end
			end)
		end,
		Logout = function(self)
			Callbacks:ServerCallback("Properties:Validate", {
				id = GlobalState[string.format("%s:Property", LocalPlayer.state.ID)],
				type = "logout",
			}, function(state)
				if state then
					Characters:Logout()
				end
			end)
		end,
	},
	Keys = {
		HasAccessWithData = function(self, key, value) -- Has Access to a Property with a specific data/key value
			if LocalPlayer.state.loggedIn then
				local propertyKeys = GlobalState[string.format("Char:Properties:%s", LocalPlayer.state.Character:GetData("ID"))]

				for _, propertyId in ipairs(propertyKeys) do
					local property = GlobalState[string.format("Property:%s", propertyId)]
					if property and property.data and ((value == nil and property.data[key]) or property.data[key] == value) then
						return property.id
					end
				end
			end
			return false
		end,
	}
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Properties", PROPERTIES)
end)
