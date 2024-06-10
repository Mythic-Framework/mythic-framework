local _pzs = {}
local _inPoly = false
local _menu = false

AddEventHandler("Apartment:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Ped = exports["mythic-base"]:FetchComponent("Ped")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Action = exports["mythic-base"]:FetchComponent("Action")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Input = exports["mythic-base"]:FetchComponent("Input")
	Apartment = exports["mythic-base"]:FetchComponent("Apartment")
	Characters = exports["mythic-base"]:FetchComponent("Characters")
	Wardrobe = exports["mythic-base"]:FetchComponent("Wardrobe")
	Sync = exports["mythic-base"]:FetchComponent("Sync")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Apartment", {
		"Callbacks",
		"Utils",
		"Blips",
		"Notification",
		"Action",
		"Polyzone",
		"Ped",
		"Sounds",
		"Targeting",
		"Interaction",
		"Action",
		"ListMenu",
		"Input",
		"Apartment",
		"Characters",
		"Wardrobe",
		"Sync",
		"Animations",
	}, function(error)
		if #error > 0 then
			return
		end -- Do something to handle if not all dependencies loaded
		RetrieveComponents()

		for k, v in ipairs(GlobalState["Apartments"]) do
			local aptId = string.format("apt-%s", v)
			local apt = GlobalState[string.format("Apartment:%s", v)]

			Polyzone.Create:Box(aptId, apt.coords, apt.length, apt.width, apt.options, {
				tier = k
			})

			Blips:Add(aptId, apt.name, apt.coords, 475, 25)
			_pzs[aptId] = {
				name = apt.name,
				id = apt.id,
			}
		end

		Interaction:RegisterMenu("apt-exit", "Exit Apartment", "door-open", function(data)
			Interaction:Hide()
			Apartment:Exit()
		end, function()
			if
				not LocalPlayer.state.isDead
				and GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)] ~= nil
			then
				local p = GlobalState[string.format(
					"Apartment:%s",
					LocalPlayer.state.inApartment.type
				)]

				local dist = #(
						vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
						- vector3(p.interior.spawn.x, p.interior.spawn.y, p.interior.spawn.z)
					)
				return dist <= 2.0
			else
				return false
			end
		end)

		-- Interaction:RegisterMenu("apt-visitors", "Check Visitors", "hand-back-fist", function(data)
		-- 	Interaction:Hide()
		-- 	CheckVisitors()
		-- end, function()
		-- 	if GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)] ~= nil then
		-- 		local p = GlobalState[string.format(
		-- 			"Apartment:%s",
		-- 			GlobalState[string.format(
		-- 				"Apartment:Interior:%s",
		-- 				GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)]
		-- 			)]
		-- 		)]
		-- 		local dist = #(
		-- 				vector3(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y, LocalPlayer.state.myPos.z)
		-- 				- vector3(p.interior.spawn.x, p.interior.spawn.y, p.interior.spawn.z)
		-- 			)
		-- 		return dist <= 2.0
		-- 	else
		-- 		return false
		-- 	end
		-- end)
	end)
end)


AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Apartment", _APTS)
end)

RegisterNetEvent("Characters:Client:Spawn", function()
	for k, v in ipairs(GlobalState["Apartments"]) do
		local aptId = string.format("apt-%s", v)
		local apt = GlobalState[string.format("Apartment:%s", v)]

		Blips:Add(aptId, apt.name, apt.coords, 475, 25)
	end
end)

-- function CheckVisitors()
-- 	Callbacks:ServerCallback("Apartment:GetRequests", {}, function(requets)
-- 		if #reqeusts > 0 then
-- 			local menu = {
-- 				label = _pzs[_inPoly].name,
-- 			}
-- 			local its = {}

-- 			for k, v in ipairs(requests) do
-- 				table.insert(its, {
-- 					label = string.format("%s %s", v.First, v.Last),
-- 					description = "Requesting To Enter Apartment",
-- 					data = _inPoly,
-- 				})
-- 				menu[string.format("request-%s", v.SID)] = {
-- 					label = string.format("Allow %s %s?", v.First, v.Last),
-- 					items = {
-- 						{
-- 							label = "Yes",
-- 							description = "Allow Them To Enter",
-- 							event = "Apartment:Client:Enter",
-- 							data = _inPoly,
-- 						},
-- 						{
-- 							label = "Breach Apartment",
-- 							description = "Breach An Apartment",
-- 							event = "Apartment:Client:Enter",
-- 							data = _inPoly,
-- 						},
-- 					},
-- 				}
-- 			end

-- 			menu.items = menu

-- 			ListMenu:Show(menu)
-- 		else
-- 			Notification:Error("You Have No Requesting Visitors")
-- 		end
-- 	end)
-- end

RegisterNetEvent("Apartment:Client:InnerStuff", function(aptId, unit, wakeUp)
	while GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)] == nil do
		Citizen.Wait(10)
		print("Interior Stuff Waiting, This Shouldn't Spam")
	end
	
	local p = GlobalState[string.format("Apartment:%s", aptId)]
	TriggerEvent("Interiors:Enter", vector3(p.interior.spawn.x, p.interior.spawn.y, p.interior.spawn.z))

	if wakeUp then
		Citizen.SetTimeout(250, function()
			Animations.Emotes:WakeUp(p.interior.wakeup)
		end)
	end

	Targeting.Zones:AddBox(
		string.format("apt-%s-exit", aptId),
		"door-open",
		p.interior.locations.exit.coords,
		p.interior.locations.exit.length,
		p.interior.locations.exit.width,
		p.interior.locations.exit.options,
		{
			{
				icon = "door-open",
				text = "Exit",
				event = "Apartment:Client:ExitEvent",
				data = unit,
			},
		},
		3.0,
		true
	)

	Targeting.Zones:AddBox(
		string.format("apt-%s-logout", aptId),
		"bed-front",
		p.interior.locations.logout.coords,
		p.interior.locations.logout.length,
		p.interior.locations.logout.width,
		p.interior.locations.logout.options,
		{
			{
				icon = "bed-front",
				text = "Switch Characters",
				event = "Apartment:Client:Logout",
				data = unit,
				isEnabled = function(data)
					return unit == LocalPlayer.state.Character:GetData("SID")
				end,
			},
		},
		3.0,
		true
	)

	Targeting.Zones:AddBox(
		string.format("apt-%s-wardrobe", propertyId),
		"shirt",
		p.interior.locations.wardrobe.coords,
		p.interior.locations.wardrobe.length,
		p.interior.locations.wardrobe.width,
		p.interior.locations.wardrobe.options,
		{
			{
				icon = "bars-staggered",
				text = "Wardrobe",
				event = "Apartment:Client:Wardrobe",
				data = unit,
				isEnabled = function(data)
					return unit == LocalPlayer.state.Character:GetData("SID")
				end,
			},
		},
		3.0,
		true
	)

	Targeting.Zones:AddBox(
		string.format("property-%s-stash", propertyId),
		"toolbox",
		p.interior.locations.stash.coords,
		p.interior.locations.stash.length,
		p.interior.locations.stash.width,
		p.interior.locations.stash.options,
		{
			{
				icon = "toolbox",
				text = "Stash",
				event = "Apartment:Client:Stash",
				data = propertyId,
			},
		},
		2.0,
		true
	)

	Targeting.Zones:Refresh()
	Citizen.Wait(1000)
	Sync:Stop(1)
end)

AddEventHandler("Apartment:Client:ExitEvent", function()
	Apartment:Exit()
end)

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if _pzs[id] and string.format("apt-%s", LocalPlayer.state.Character:GetData("Apartment") or 1) == id then
		while GetVehiclePedIsIn(LocalPlayer.state.ped) ~= 0 do
			Citizen.Wait(10)
		end

		_inPoly = {
			id = id,
			data = data.tier
		}

		-- local str = "{keybind}secondary_action{/keybind} View Options"
		-- if string.format("apt-%s", LocalPlayer.state.Character:GetData("Apartment") or 1) == id then
		-- 	str = string.format("{keybind}primary_action{/keybind}: Enter {keybind}secondary_action{/keybind}: Other", _pzs[id].name)
		-- end

		local str = string.format("{keybind}primary_action{/keybind} To Enter %s", _pzs[id].name)

		Action:Show(str)
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if id == _inPoly?.id then
		_inPoly = nil
		Action:Hide()
	end
end)

AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
	if
		_inPoly
		and (LocalPlayer.state.Character:GetData("Apartment") or 1) == _inPoly.data
		and not LocalPlayer.state.isDead
	then
		Apartment:Enter(_inPoly.data, -1)
	end
end)

AddEventHandler("Apartment:Client:Enter", function(data)
	Apartment:Enter(data)
end)

AddEventHandler("Apartment:Client:RequestEntry", function(data)
	Input:Show("Request Entry", "Unit Number (Owner State ID)", {
		{
			id = "unit",
			type = "number",
			options = {
				inputProps = {
					maxLength = 4,
				},
			},
		},
	}, "Apartment:Client:DoRequestEntry", _inPoly)
end)

AddEventHandler("Apartment:Client:DoRequestEntry", function(values, data)
	Callbacks:ServerCallback("Apartment:RequestEntry", {
		inZone = data,
		target = values.unit,
	})
end)

AddEventHandler("Apartment:Client:Stash", function(t, data)
	Apartment.Extras:Stash()
end)

AddEventHandler("Apartment:Client:Wardrobe", function(t, data)
	Apartment.Extras:Wardrobe()
end)

AddEventHandler("Apartment:Client:Logout", function(t, data)
	Apartment.Extras:Logout()
end)

_APTS = {
	Enter = function(self, tier, id)
		Callbacks:ServerCallback("Apartment:Enter", {
			id = id or -1,
			tier = tier,
		}, function(s)
			if s then
				Sounds.Play:One("door_open.ogg", 0.15)

				DoScreenFadeOut(1000)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end

				local p = GlobalState[string.format("Apartment:%s", s)]

				FreezeEntityPosition(PlayerPedId(), true)
				Citizen.Wait(50)
				SetEntityCoords(
					PlayerPedId(),
					p.interior.spawn.x,
					p.interior.spawn.y,
					p.interior.spawn.z,
					0,
					0,
					0,
					false
				)
				Citizen.Wait(100)
				SetEntityHeading(PlayerPedId(), p.interior.spawn.h)

				local time = GetGameTimer()
				while (not HasCollisionLoadedAroundEntity(PlayerPedId()) and (GetGameTimer() - time) < 10000) do
					Citizen.Wait(100)
				end

				FreezeEntityPosition(PlayerPedId(), false)

				DoScreenFadeIn(1000)
				while not IsScreenFadedIn() do
					Citizen.Wait(10)
				end
			end
		end)
	end,
	Exit = function(self)
		local apartmentId = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)]
		local p = GlobalState[string.format(
			"Apartment:%s",
			LocalPlayer.state.inApartment.type
		)]

		Callbacks:ServerCallback("Apartment:Exit", {}, function()
			DoScreenFadeOut(1000)
			while not IsScreenFadedOut() do
				Citizen.Wait(10)
			end

			TriggerEvent("Interiors:Exit")
			Sync:Start()

			Sounds.Play:One("door_close.ogg", 0.3)
			Citizen.Wait(200)

			SetEntityCoords(PlayerPedId(), p.coords.x, p.coords.y, p.coords.z, 0, 0, 0, false)
			Citizen.Wait(100)
			SetEntityHeading(PlayerPedId(), p.heading)

			for k, v in pairs(p.interior.locations) do
				Targeting.Zones:RemoveZone(string.format("apt-%s-%s", k, apartmentId))
			end

			Targeting.Zones:Refresh()

			DoScreenFadeIn(1000)
			while not IsScreenFadedIn() do
				Citizen.Wait(10)
			end
		end)
	end,
	GetNearApartment = function(self)
		if _inPoly?.id ~= nil and _pzs[_inPoly?.id]?.id ~= nil then
			return GlobalState[string.format("Apartment:%s", _pzs[_inPoly?.id].id)]
		else
			return nil
		end
	end,
	Extras = {
		Stash = function(self)
			Callbacks:ServerCallback("Apartment:Validate", {
				id = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)],
				type = "stash",
			})
		end,
		Wardrobe = function(self)
			Callbacks:ServerCallback("Apartment:Validate", {
				id = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)],
				type = "wardrobe",
			}, function(state)
				if state then
					Wardrobe:Show()
				end
			end)
		end,
		Logout = function(self)
			Callbacks:ServerCallback("Apartment:Validate", {
				id = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)],
				type = "logout",
			}, function(state)
				if state then
					Characters:Logout()
				end
			end)
		end,
	},
}
