_hasKnockedOut = false

local _healTickRunning = false
local _armrTickRunning = false

local _cd = {}

function wasMinorDeath(hash, damage)
	if Config.DeathTypes[hash] == nil or not Config.DeathTypes[hash].minor and (damage == nil or damage <= 70) then
		return false
	else
		return true
	end
end

AddEventHandler("Characters:Client:Spawn", function()
	playerHealth = GetEntityHealth(LocalPlayer.state.ped)
	playerArmor = GetPedArmour(LocalPlayer.state.ped)

	Citizen.CreateThread(function()
		if _healTickRunning then
			return
		end
		_healTickRunning = true
		while LocalPlayer.state.loggedIn do
			if LocalPlayer.state.healTicks ~= nil then
				local chp = GetEntityHealth(LocalPlayer.state.ped)
				local max = GetEntityMaxHealth(LocalPlayer.state.ped)

				if chp >= max then
					LocalPlayer.state:set("healTicks", nil, true)
				else
					local heal = LocalPlayer.state.healTicks[1] or 0
					if chp + heal > max then
						heal = max - chp
					end

					if chp + heal <= max then
						Logger:Trace(
							"Damage",
							string.format("Heal Tick: %s (Original: %s)", heal, LocalPlayer.state.healTicks[1])
						)
						SetEntityHealth(LocalPlayer.state.ped, chp + heal)
					end

					local t = LocalPlayer.state.healTicks
					table.remove(t, 1)
					if #t > 0 then
						LocalPlayer.state:set("healTicks", t, true)
					else
						LocalPlayer.state:set("healTicks", nil, true)
					end
				end
				Citizen.Wait(10000)
			else
				Citizen.Wait(2000)
			end
		end
		_healTickRunning = false
	end)

	Citizen.CreateThread(function()
		if _armrTickRunning then
			return
		end
		_armrTickRunning = true
		while LocalPlayer.state.loggedIn do
			if LocalPlayer.state.armorTicks ~= nil then
				local car = GetPedArmour(LocalPlayer.state.ped)
				local max = GetPlayerMaxArmour(LocalPlayer.state.PlayerID)

				if car >= max then
					LocalPlayer.state:set("armorTicks", nil, true)
				else
					local gen = LocalPlayer.state.armorTicks[1] or 0
					if car + gen > max then
						gen = max - car
					end

					if car + gen <= max then
						Logger:Trace(
							"Damage",
							string.format("Armor Tick: %s (Original: %s)", gen, LocalPlayer.state.armorTicks[1])
						)
						SetPedArmour(LocalPlayer.state.ped, car + gen)
					end

					local t = LocalPlayer.state.armorTicks
					table.remove(t, 1)
					if #t > 0 then
						LocalPlayer.state:set("armorTicks", t, true)
					else
						LocalPlayer.state:set("armorTicks", nil, true)
					end
				end
				Citizen.Wait(10000)
			else
				Citizen.Wait(2000)
			end
		end
		_armrTickRunning = false
	end)
end)

RegisterNetEvent("Characters:Client:Logout", function()
	LocalPlayer.state.isLimping = false
end)

function nearPlayer(dist)
	local peds = GetGamePool("CPed")
	local myCoords = GetEntityCoords(LocalPlayer.state.ped)
	for _, ped in ipairs(peds) do
		if ped ~= LocalPlayer.state.ped and IsPedAPlayer(ped) then
			local entCoords = GetEntityCoords(ped)
			if #(entCoords - myCoords) <= dist then
				return true
			end
		end
	end

	return false
end

function diecunt(ped, isMinor)
	if not _hasKnockedOut then
		_hasKnockedOut = true
		Citizen.SetTimeout(60000 * 5, function()
			_hasKnockedOut = false
		end)
	else
		isMinor = false
	end

	LocalPlayer.state:set("isHospitalized", false, true)
	LocalPlayer.state:set("isDead", true, true)
	LocalPlayer.state:set("deadData", {
		isMinor = isMinor,
	}, true)
	LocalPlayer.state:set("isDeadTime", GetCloudTimeAsInt(), true)

	while not LocalPlayer.state.isDead do
		Citizen.Wait(1)
	end

	TriggerEvent("Ped:Client:Died")
	TriggerServerEvent("Ped:Server:Died")

	if (Jail:IsJailed() or not nearPlayer(100.0)) and not isMinor then
		TriggerServerEvent("EmergencyAlerts:Server:DoPredefined", "injuredPerson")
	end
	Hud:Dead(true)
	DoDeadStuff(isMinor)
	DisableControls()
	respawnCd(isMinor)
end

AddEventHandler("Damage:Client:Triggers:PedKilledByVehicle", function(ped, vehicle)
	if ped == PlayerPedId() and not LocalPlayer.state.isDead then
		diecunt(ped, false)
	end
end)

AddEventHandler("Damage:Client:Triggers:PedKilledByPlayer", function(ped, player, weapon, isMelee)
	if ped == PlayerPedId() and not LocalPlayer.state.isDead then
		diecunt(ped, wasMinorDeath(weapon))
	end
end)

AddEventHandler("Damage:Client:Triggers:PedKilledByPed", function(ped, attacker, weapon, isMelee)
	if ped == PlayerPedId() and not LocalPlayer.state.isDead then
		diecunt(ped, wasMinorDeath(weapon))
	end
end)

AddEventHandler("Damage:Client:Triggers:PedDied", function(ped, attacker, weapon, isMelee)
	if ped == PlayerPedId() and not LocalPlayer.state.isDead then
		diecunt(ped, wasMinorDeath(weapon))
	end
end)

AddEventHandler("Damage:Client:Triggers:EntityDamaged", function(ped, attacker, weapon, isMelee)
	if ped == PlayerPedId() then
		if IsPedDeadOrDying(ped, true) or GetEntityHealth(ped) <= (GetEntityMaxHealth(ped) - 100) then
			diecunt(ped, wasMinorDeath(weapon))
		else
			if not LocalPlayer.state.isDead then
				local health = GetEntityHealth(ped)
				local armor = GetPedArmour(ped)

				if not playerHealth then
					playerHealth = health
				end

				if not playerArmor then
					playerArmor = armor
				end

				local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
				local healthDamaged = (playerHealth ~= health) -- Players health was damaged

				local damageDone = (playerHealth - health)

				if damageDone >= (GetEntityMaxHealth(ped) - 100) then
					return diecunt(ped, wasMinorDeath(weapon, damageDone))
				end

				if armorDamaged or healthDamaged then
					local hit, bone = GetPedLastDamageBone(ped)
					local bodypart = Config.Bones[bone]
					--local weapon = GetDamagingWeapon(ped)

					if hit and bodypart ~= "NONE" then
						if not _cd[bodypart] then
							if damageDone >= Config.HealthDamage then
								local checkDamage = true
								if weapon ~= nil then
									if
										armorDamaged and (bodypart == "SPINE" or bodypart == "UPPER_BODY")
										or weapon == Config.WeaponClasses["NOTHING"]
									then
										checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
									end

									if checkDamage then
										if IsDamagingEvent(damageDone, weapon) then
											Damage:CheckDamage(ped, bone, weapon, damageDone)
										end
									end
								end
							elseif Config.AlwaysBleedChanceWeapons[weapon] then
								if math.random(100) < Config.AlwaysBleedChance then
									Damage.Apply:Bleed(1)
								end

								if weapon ~= nil then
									Callbacks:ServerCallback("Damage:ApplySkeleDamage", {
										bone = bone,
										wepClass = Config.Weapons[weapon],
									})
								end
							else
								if weapon ~= nil then
									Callbacks:ServerCallback("Damage:ApplySkeleDamage", {
										bone = bone,
										wepClass = Config.Weapons[weapon],
									})
								end
							end

							_cd[bodypart] = true
							Citizen.SetTimeout(15000, function()
								_cd[bodypart] = nil
							end)
						end
					end
				end

				playerHealth = health
				playerArmor = armor
				ProcessDamage(ped)
			end

			if LocalPlayer.state.onPainKillers ~= nil and LocalPlayer.state.onPainKillers > 0 then
				LocalPlayer.state.onPainKillers = LocalPlayer.state.onPainKillers - 1
			elseif LocalPlayer.state.wasOnPainKillers then
				LocalPlayer.state.wasOnPainKillers = false
				SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
				Notification:Custom(Config.Strings.PainKillersExpired, 5000, "pills", Config.NotifStyle)
			end

			if LocalPlayer.state.onDrugs ~= nil and LocalPlayer.state.onDrugs > 0 then
				LocalPlayer.state.onDrugs = LocalPlayer.state.onDrugs - 1
			elseif LocalPlayer.state.wasOnDrugs then
				LocalPlayer.state.wasOnDrugs = false
				SetPedToRagdoll(ped, 1500, 2000, 3, true, true, false)
				Notification:Custom(Config.Strings.AdrenalineExpired, 5000, "pills", Config.NotifStyle)
			end
		end
	end
end)
