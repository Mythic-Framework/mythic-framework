local _moving = false

function EnterProperty(data, backdoor)
	Callbacks:ServerCallback("Properties:EnterProperty", data.propertyId, function(state, pId, int)
		if state then
			Interaction:Hide()

			DoScreenFadeOut(1000)
			while not IsScreenFadedOut() do
				Wait(10)
			end

			while not _propertiesLoaded do
				Wait(100)
			end

			local property = _properties[pId]

			Sounds.Play:One("door_open.ogg", 0.3)
			Wait(200)
			FreezeEntityPosition(PlayerPedId(), true)
			Wait(50)

			local interior = PropertyInteriors[int]

			if backdoor and interior.locations.back then
				SetEntityCoords(PlayerPedId(), interior.locations.back.coords.x, interior.locations.back.coords.y, interior.locations.back.coords.z, 0, 0, 0, false)
				Wait(100)
				SetEntityHeading(PlayerPedId(), interior.locations.back.heading)
			else
				SetEntityCoords(PlayerPedId(), interior.locations.front.coords.x, interior.locations.front.coords.y, interior.locations.front.coords.z, 0, 0, 0, false)
				Wait(100)
				SetEntityHeading(PlayerPedId(), interior.locations.front.heading)
			end

			local time = GetGameTimer()
			while (not HasCollisionLoadedAroundEntity(PlayerPedId()) and (GetGameTimer() - time) < 10000) do
				Wait(100)
			end

			FreezeEntityPosition(PlayerPedId(), false)

			DoScreenFadeIn(1000)
			while not IsScreenFadedIn() do
				Wait(10)
			end
		end
	end)
end

function ExitProperty(data, backdoor)
	Callbacks:ServerCallback("Properties:ExitProperty", {}, function(pId)
		_insideProperty = false
		_insideInterior = false

		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end

		while not _propertiesLoaded do
			Wait(100)
		end

		local property = _properties[pId]

		if not property then return; end

		DestroyFurniture(true)
		SetFurnitureEditMode(false)
		if _placingFurniture then
			ObjectPlacer:Cancel(true, true)
			Phone:ResetRoute()
			_placingFurniture = false
			LocalPlayer.state.placingFurniture = false
			LocalPlayer.state.furnitureEdit = false
		end

		TriggerEvent('Interiors:Exit')
		Sync:Start()

		Sounds.Play:One("door_close.ogg", 0.3)
		Wait(200)

		FreezeEntityPosition(PlayerPedId(), true)
		Wait(50)

		-- Targeting.Zones:RemoveZone(string.format("property-%s-logout", pId))
		-- Targeting.Zones:RemoveZone(string.format("property-%s-closet", pId))
		-- Targeting.Zones:RemoveZone(string.format("property-%s-stash", pId))
		Targeting.Zones:RemoveZone(string.format("property-%s-exit", pId))
		Targeting.Zones:RemoveZone(string.format("property-%s-exit-back", pId))
		--Polyzone:Remove("property-int-zone")

		if backdoor and property.location.backdoor then
			SetEntityCoords(
				PlayerPedId(),
				property.location.backdoor.x,
				property.location.backdoor.y,
				property.location.backdoor.z,
				0,
				0,
				0,
				false
			)
			SetEntityHeading(PlayerPedId(), property.location.backdoor.h)
		else
			SetEntityCoords(
				PlayerPedId(),
				property.location.front.x,
				property.location.front.y,
				property.location.front.z,
				0,
				0,
				0,
				false
			)
			SetEntityHeading(PlayerPedId(), property.location.front.h)
		end

		local time = GetGameTimer()
		while (not HasCollisionLoadedAroundEntity(PlayerPedId()) and (GetGameTimer() - time) < 10000) do
			Wait(100)
		end

		FreezeEntityPosition(PlayerPedId(), false)

		DoScreenFadeIn(500)
		while not IsScreenFadedIn() do
			Wait(10)
		end
	end)

	Notification.Persistent:Remove("furniture")

	if _previewingInterior then
        EndPreview()
	end
end

RegisterNetEvent("Properties:Client:ForceExitProperty", function()
	ExitProperty()
end)