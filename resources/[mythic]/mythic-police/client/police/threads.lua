AddEventHandler("Characters:Client:Spawn", function()
	Citizen.Wait(5000)
	StartThreads()
end)

local _ignored = {
	[`WEAPON_PETROLCAN`] = true,
	[`WEAPON_FIREEXTINGUISHER`] = true,
	[`WEAPON_FLARE`] = true,
	[`WEAPON_TASER`] = true,
	[`WEAPON_BALL`] = true,
	[`WEAPON_SNOWBALL`] = true,
	[`WEAPON_GRENADE`] = true,
	[`WEAPON_BZGAS`] = true,
	[`WEAPON_MOLOTOV`] = true,
	[`WEAPON_STICKYBOMB`] = true,
	[`WEAPON_PROXMINE`] = true,
	[`WEAPON_PIPEBOMB`] = true,
	[`WEAPON_SMOKEGRENADE`] = true,
	[`WEAPON_FLARE`] = true,
	[`WEAPON_FIREEXTINGUISHER`] = true,
	[`WEAPON_PETROLCAN`] = true,
}

local _excludes = {
	{ coords = vector3(1713.17, 2586.68, 59.88), dist = 250 }, -- prison
	{ coords = vector3(-106.63, 6467.72, 31.62), dist = 45 }, -- paleto bank
	{ coords = vector3(251.21, 217.45, 106.28), dist = 20 }, -- city bank
	{ coords = vector3(-622.25, -230.93, 38.05), dist = 10 }, -- jewlery store
	{ coords = vector3(233.37, 373.31, 106.14), dist = 20 }, -- xgems
	{ coords = vector3(699.91, 132.29, 80.74), dist = 55 }, -- power 1
	{ coords = vector3(2739.55, 1532.99, 57.56), dist = 235 }, -- power 2
	{ coords = vector3(12.53, -1097.99, 29.8), dist = 10 }, -- Adam's Apple / Pillbox Weapon shop
}

function StartThreads()
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			local cw = GetSelectedPedWeapon(LocalPlayer.state.ped)
			local isArmed = false
			local isOrigin = false
			if not _ignored[cw] then
				if not isArmed then
					if IsPedArmed(LocalPlayer.state.ped, 7) and not IsPedArmed(LocalPlayer.state.ped, 1) then
						cw = GetSelectedPedWeapon(LocalPlayer.state.ped)
						isArmed = true
					end
				end

				if IsPedShooting(LocalPlayer.state.ped) and not _ignored[cw] then
					if LocalPlayer.state.onDuty ~= "police" then
						local veh = GetVehiclePedIsIn(LocalPlayer.state.ped)
						if veh ~= 0 then
							EmergencyAlerts:CreateIfReported(500.0, "shotsfiredvehicle", true, {
								icon = "car",
								details = string.format("%s", GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh))))
							})
						elseif IsPedCurrentWeaponSilenced(LocalPlayer.state.ped) then
							EmergencyAlerts:CreateIfReported(10.0, "shotsfired", true)
						else
							EmergencyAlerts:CreateIfReported(900.0, "shotsfired", true)
						end
					end

					if
						IsPedArmed(LocalPlayer.state.ped, 6)
						and not IsPedSwimming(LocalPlayer.state.ped)
					then
						LocalPlayer.state:set("GSR", GlobalState["OS:Time"], true)
					end
					Citizen.Wait(60000)
				end
			else
				Citizen.Wait(1000)
			end

			Citizen.Wait(50)
		end
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if LocalPlayer.state.GSR and IsPedSwimming(LocalPlayer.state.ped) then
				LocalPlayer.state:set("GSR", nil, true)
			end
			Citizen.Wait(3000)
		end
	end)

	local _blacklistedWeps = {
		[`WEAPON_UNARMED`] = true,
		[`WEAPON_FLASHLIGHT`] = true,
	}
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if not LocalPlayer.state.isDead then
				if
					not _blacklistedWeps[GetCurrentPedWeapon(LocalPlayer.state.ped, true)]
					and IsPlayerFreeAiming(LocalPlayer.state.PlayerID)
				then
					Status.Modify:Add("PLAYER_STRESS", 1, false, true)
					Citizen.Wait(40000)
				end
				Citizen.Wait(100)
			else
				Citizen.Wait(10000)
			end
		end
	end)
end
