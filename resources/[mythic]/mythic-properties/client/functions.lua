local _moving = false
_stashModel = `hei_heist_bed_chestdrawer_04`
_logoutModel = `v_res_msonbed`
_closetModel = `prop_wardrobe_door_01`

Citizen.CreateThread(function()
	RequestModel(_stashModel)
	RequestModel(_logoutModel)
	RequestModel(_closetModel)
end)

function EnterProperty(data, backdoor)
	Callbacks:ServerCallback("Properties:EnterProperty", data.propertyId, function(state)
		if state then
			local prop = GlobalState[string.format("Property:%s", data.propertyId)]
			Interaction:Hide()
			DoScreenFadeOut(1000)
			while not IsScreenFadedOut() do
				Citizen.Wait(10)
			end
			Sounds.Play:One("door_open.ogg", 0.3)
			Citizen.Wait(200)

			local f = GlobalState[string.format("Properties:Interior:%s", prop.interior)]
			FreezeEntityPosition(PlayerPedId(), true)
			Citizen.Wait(50)

			if backdoor and f.backdoor then
				SetEntityCoords(PlayerPedId(), f.backdoor.x, f.backdoor.y, f.backdoor.z, 0, 0, 0, false)
				Citizen.Wait(100)
				SetEntityHeading(PlayerPedId(), f.backdoor.h)
			else
				SetEntityCoords(PlayerPedId(), f.x, f.y, f.z, 0, 0, 0, false)
				Citizen.Wait(100)
				SetEntityHeading(PlayerPedId(), f.h)
			end

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
end

function ExitProperty(data, backdoor)
	Callbacks:ServerCallback("Properties:ExitProperty", {}, function(property)
		local property = GlobalState[string.format("Property:%s", property)]

		if not property then return; end

		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		TriggerEvent('Interiors:Exit')
		Sync:Start()

		Sounds.Play:One("door_close.ogg", 0.3)
		Citizen.Wait(200)

		FreezeEntityPosition(PlayerPedId(), true)
		Citizen.Wait(50)

		Targeting.Zones:RemoveZone(string.format("property-%s-logout", property.id))
		Targeting.Zones:RemoveZone(string.format("property-%s-closet", property.id))
		Targeting.Zones:RemoveZone(string.format("property-%s-stash", property.id))
		Targeting.Zones:RemoveZone(string.format("property-%s-exit", property.id))
		Targeting.Zones:RemoveZone(string.format("property-%s-exit-back", property.id))
		Polyzone:Remove("property-int-zone")

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
			Citizen.Wait(100)
		end

		FreezeEntityPosition(PlayerPedId(), false)

		DoScreenFadeIn(500)
		while not IsScreenFadedIn() do
			Citizen.Wait(10)
		end
	end)
end