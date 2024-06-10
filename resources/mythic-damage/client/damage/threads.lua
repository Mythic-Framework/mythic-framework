function StartTracking()
	Damage.Alerts:All()
	Damage.Apply:Movement()

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if not LocalPlayer.state.inCreator then
				Citizen.Wait(10000)
				local myhp = GetEntityHealth(LocalPlayer.state.ped) - 100
				if myhp <= 10 then
					SetFlash(0, 0, 500, math.random(10) * 1000, 500)
				elseif myhp <= 25 then
					SetFlash(0, 0, 500, math.random(5) * 1000, 500)
				elseif myhp <= 50 then
					SetFlash(0, 0, 500, math.random(2) * 1000, 500)
				else
					SetFlash(0, 0, 1, 0, 1)
				end
			else
				Citizen.Wait(30000)
			end
		end
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn ~= nil do
			local size = cTable(_damagedLimbs)
			if size > 0 then
				local level = 0
				for k, v in pairs(_damagedLimbs) do
					if v.severity > level then
						level = v.severity
					end
				end

				SetPedMoveRateOverride(LocalPlayer.state.ped, Config.MovementRate[level])

				Citizen.Wait(500)
			else
				Citizen.Wait(1000)
			end
		end
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if
				LocalDamage ~= nil
				and not LocalPlayer.state.isHospitalized
				and not LocalPlayer.state.isDead
				and LocalDamage.Bleed > 0
				and (LocalPlayer.state.tourniquet == nil or LocalPlayer.state.tourniquet < GetGameTimer())
			then
				if bleedTickTimer >= Config.BleedTickRate then
					if not LocalPlayer.state.isDead then
						if LocalDamage.Bleed > 0 then
							if LocalDamage.Bleed == 1 then
								SetFlash(0, 0, 100, 100, 100)
							elseif LocalDamage.Bleed == 2 then
								SetFlash(0, 0, 100, 250, 100)
							elseif LocalDamage.Bleed == 3 then
								SetFlash(0, 0, 100, 500, 100)
							elseif LocalDamage.Bleed == 4 then
								SetFlash(0, 0, 100, 500, 100)
							end

							local bleedDamage = tonumber(LocalDamage.Bleed) * Config.BleedTickDamage
							ApplyDamageToPed(LocalPlayer.state.ped, bleedDamage, false)
							playerHealth = playerHealth - bleedDamage

							if advanceBleedTimer >= Config.AdvanceBleedTimer then
								Damage.Apply:Bleed(1)
								advanceBleedTimer = 0
							else
								advanceBleedTimer = advanceBleedTimer + 1
							end
						end
					end
					bleedTickTimer = 0
				else
					bleedTickTimer = bleedTickTimer + 1
				end

				if bleedTickEvidenceTimer >= math.floor(Config.BleedEvidenceRate / math.max(1, LocalDamage.Bleed)) then
					TriggerEvent("Evidence:Client:BleedOnFloor")
					bleedTickEvidenceTimer = 0
				else
					bleedTickEvidenceTimer = bleedTickEvidenceTimer + 1
				end
			end

			Citizen.Wait(1000)
		end
	end)

	local prevPos = nil
	Citizen.CreateThread(function()
		prevPos = GetEntityCoords(LocalPlayer.state.ped, true)
		while LocalPlayer.state.loggedIn do
			if
				LocalDamage ~= nil
				and not LocalPlayer.state.isHospitalized
				and not LocalPlayer.state.isDead
				and LocalDamage.Bleed > 0
				and (LocalPlayer.state.tourniquet == nil or LocalPlayer.state.tourniquet < GetGameTimer())
			then
				if math.floor(bleedTickTimer % (Config.BleedTickRate / 10)) == 0 then
					local moving = #(
							vector2(prevPos.x, prevPos.y)
							- vector2(LocalPlayer.state.myPos.x, LocalPlayer.state.myPos.y)
						)
					if (moving > 1 and not IsPedInAnyVehicle(LocalPlayer.state.ped)) and LocalDamage.Bleed > 2 then
						Notification.Persistent:Custom(
							bleedMoveNotifId,
							"You notice blood oozing from your wounds faster when you're moving",
							Config.NotifStyle
						)
						advanceBleedTimer = advanceBleedTimer + Config.BleedMovementAdvance
						bleedTickTimer = bleedTickTimer + Config.BleedMovementTick
						prevPos = LocalPlayer.state.myPos
					else
						Notification.Persistent:Remove(bleedMoveNotifId)
						bleedTickTimer = bleedTickTimer + 1
					end
				end
			end

			Citizen.Wait(300)
		end
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn do
			if IsInjuryCausingLimp() then
				local luck = math.random(100)
				if
					(IsPedJumping(LocalPlayer.state.ped) and luck <= 85)
					or (IsPedSprinting(LocalPlayer.state.ped) and luck <= 4)
				then
					SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
				end

				Citizen.Wait(100)
			else
				Citizen.Wait(2500)
			end
		end
	end)

	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn and LocalPlayer.state.Character do
			-- if not LocalPlayer.state.isDead then
			-- 	local health = GetEntityHealth(LocalPlayer.state.ped)
			-- 	local armor = GetPedArmour(LocalPlayer.state.ped)

			-- 	if not playerHealth then
			-- 		playerHealth = health
			-- 	end

			-- 	if not playerArmor then
			-- 		playerArmor = armor
			-- 	end

			-- 	local armorDamaged = (playerArmor ~= armor and armor < (playerArmor - Config.ArmorDamage) and armor > 0) -- Players armor was damaged
			-- 	local healthDamaged = (playerHealth ~= health) -- Players health was damaged

			-- 	local damageDone = (playerHealth - health)

			-- 	if armorDamaged or healthDamaged then
			-- 		local hit, bone = GetPedLastDamageBone(LocalPlayer.state.ped)
			-- 		local bodypart = Config.Bones[bone]
			-- 		local weapon = GetDamagingWeapon(LocalPlayer.state.ped)

			-- 		if hit and bodypart ~= "NONE" then
			-- 			if damageDone >= Config.HealthDamage then
			-- 				local checkDamage = true
			-- 				if weapon ~= nil then
			-- 					if
			-- 						armorDamaged and (bodypart == "SPINE" or bodypart == "UPPER_BODY")
			-- 						or weapon == Config.WeaponClasses["NOTHING"]
			-- 					then
			-- 						checkDamage = false -- Don't check damage if the it was a body shot and the weapon class isn't that strong
			-- 					end

			-- 					if checkDamage then
			-- 						if IsDamagingEvent(damageDone, weapon) then
			-- 							Damage:CheckDamage(ped, bone, weapon, damageDone)
			-- 						end
			-- 					end
			-- 				end
			-- 			elseif Config.AlwaysBleedChanceWeapons[weapon] then
			-- 				if math.random(100) < Config.AlwaysBleedChance then
			-- 					Damage.Apply:Bleed(1)
			-- 				end
			-- 			end
			-- 		end
			-- 	end

			-- 	playerHealth = health
			-- 	playerArmor = armor
			-- 	ProcessDamage(LocalPlayer.state.ped)
			-- end

			if LocalPlayer.state.onPainKillers ~= nil and LocalPlayer.state.onPainKillers > 0 then
				LocalPlayer.state.onPainKillers = LocalPlayer.state.onPainKillers - 1
			elseif LocalPlayer.state.wasOnPainKillers then
				LocalPlayer.state.wasOnPainKillers = false
				-- SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
				-- Notification:Custom(Config.Strings.PainKillersExpired, 5000, "pills", Config.NotifStyle)
			end

			if LocalPlayer.state.onDrugs ~= nil and LocalPlayer.state.onDrugs > 0 then
				LocalPlayer.state.onDrugs = LocalPlayer.state.onDrugs - 1
			elseif LocalPlayer.state.wasOnDrugs then
				LocalPlayer.state.wasOnDrugs = false
				-- SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
				-- Notification:Custom(Config.Strings.AdrenalineExpired, 5000, "pills", Config.NotifStyle)
			end

			Damage.Apply:Movement(LocalPlayer.state.ped)
			Citizen.Wait(200)
		end
	end)
end

local _respawning = false
local _waiting = false
local _countdown = 300
local _sendToHosp = false

LocalPlayer.state.isDead = false

function DisableControls()
	Citizen.CreateThread(function()
		while LocalPlayer.state.loggedIn and LocalPlayer.state.isDead do
			DisableControlAction(0, 30, true) -- disable left/right
			DisableControlAction(0, 31, true) -- disable forward/back
			DisableControlAction(0, 36, true) -- INPUT_DUCK
			DisableControlAction(0, 21, true) -- disable sprint
			DisableControlAction(0, 44, true) -- disable cover
			DisableControlAction(0, 63, true) -- veh turn left
			DisableControlAction(0, 64, true) -- veh turn right
			DisableControlAction(0, 71, true) -- veh forward
			DisableControlAction(0, 72, true) -- veh backwards
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(1, 37, true) -- disable weapon select
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 142, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			Citizen.Wait(1)
		end
	end)
end

local koDict = "mini@cpr@char_b@cpr_def"
local koAnim = "cpr_pumpchest_idle"

local deadDict = "dead"
local deadAnim = "dead_d"

local vehDict = "veh@low@front_ps@idle_duck"
local vehAnim = "sit"

function DoDeadStuff(isMinor)
	_sendToHosp = false

	local ped = PlayerPedId()
	Citizen.CreateThread(function()
		while GetEntitySpeed(ped) > 0.5 do
			Citizen.Wait(1)
		end

		DoScreenFadeOut(1000)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		AnimpostfxPlay("DeathFailMPIn", 100.0, true)
		AnimpostfxPlay("PPPurple", 100.0, true)
		AnimpostfxPlay("DrugsMichaelAliensFight", 100.0, true)
		AnimpostfxPlay("DeathFailMPDark", 100.0, true)

		local aDict = deadDict
		local aAnim = deadAnim

		if isMinor then
			aDict = koDict
			aAnim = koAnim
		end

		loadAnimDict(aDict)
		loadAnimDict(vehDict)

		local seat = 0
		local veh = GetVehiclePedIsIn(ped)
		if veh ~= 0 then
			local m = GetEntityModel(veh)
			for k = -1, GetVehicleModelNumberOfSeats(m) do
				if GetPedInVehicleSeat(veh, k) == ped then
					seat = k
				end
			end
		end
		local loc = GetEntityCoords(ped)
		--SetEntityCoords(ped, loc)
		NetworkResurrectLocalPlayer(loc, true, true, false)

		if not veh then
			ClearPedTasksImmediately(ped)
		else
			TaskWarpPedIntoVehicle(ped, veh, seat)
			Citizen.Wait(300)
		end

		Damage.Alerts:Reset()

		DoScreenFadeIn(300)

		ClearPedTasksImmediately(ped)
		while
			LocalPlayer.state.loggedIn
			and LocalPlayer.state.isDead
			and not LocalPlayer.state.isHospitalized
			and not _sendToHosp
		do
			SetEntityInvincible(ped, true)
			SetEntityHealth(ped, 200)
			if IsPedInAnyVehicle(ped) then
				TaskPlayAnim(ped, vehDict, vehAnim, 8.0, -8, -1, 1, 0, 0, 0, 0)
			elseif IsEntityInWater(ped) then
				SetPedToRagdoll(PlayerPedId(), 3000, 3000, 3, 0, 0, 0)
				Citizen.Wait(2500)
			elseif LocalPlayer.state.inTrunk then
				-- dosomething?
			else
				TaskPlayAnim(ped, aDict, aAnim, 1.0, 1.0, -1, 1, 0, 0, 0, 0)
			end
			Citizen.Wait(100)
		end

		AnimpostfxStop("DeathFailMPIn")
		AnimpostfxStop("PPPurple")
		AnimpostfxStop("DrugsMichaelAliensFight")
		AnimpostfxStop("DeathFailMPDark")

		if not LocalPlayer.state.isHospitalized then
			if not LocalPlayer.state.loggedIn then
				DoScreenFadeIn(0)
			else
				DoScreenFadeOut(1000)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
			end

			SetEntityInvincible(ped, false)
			Hud:Dead(false)
			ClearPedTasksImmediately(ped)

			if LocalPlayer.state.loggedIn then
				if _sendToHosp then
					LocalPlayer.state:set("isHospitalized", true, true)
					Hospital:SendToBed(Config.Beds[_sendToHosp], false, _sendToHosp)
				else
					DoScreenFadeIn(1000)
				end
			end
		end
	end)
end

AddEventHandler("Keybinds:Client:KeyUp:secondary_action", function()
	if (LocalPlayer.state.isDead and not LocalPlayer.state.isHospitalized) and _countdown <= 0 then
		_respawning = true

		if not LocalPlayer.state.deadData?.isMinor then
			Progress:Progress({
				name = "hospital_action",
				duration = 10000,
				label = "Respawning",
				useWhileDead = true,
				canCancel = true,
				ignoreModifier = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = false,
			}, function(status)
				if not status then
					Callbacks:ServerCallback("Hospital:Respawn", {}, function(bedId)
						if bedId ~= nil then
							_sendToHosp = bedId
							_waiting = false
						else
							Notification:Error("Unable To Respawn Yet, Please Wait")
						end
					end)
				end
				_respawning = false
			end)
		else
			Damage:Heal()
			_respawning = false
		end
	end
end)

local _threading = false
local _counting = false
function respawnCd(isMinor)
	if _threading then
		return
	end
	_threading = true
	_countdown = isMinor and Config.KnockoutTimer or Config.RespawnTimer
	_waiting = true
	_respawning = false
	Citizen.CreateThread(function()
		local key = Keybinds:GetKey("secondary_action")
		while
			LocalPlayer.state.loggedIn
			and (LocalPlayer.state.isDead and not LocalPlayer.state.isHospitalized)
			and _waiting
		do
			if _respawning then
				DrawUIText(4, true, 0.5, 0.9, 0.35, 255, 255, 255, 255, (not LocalPlayer.state.deadData?.isMinor) and "Respawning, Please Wait..." or "Standing Up, Please Wait...")
			else
				if _countdown > 0 then
					DrawUIText(
						4,
						true,
						0.5,
						0.9,
						0.35,
						255,
						255,
						255,
						255,
						(not LocalPlayer.state.deadData?.isMinor) and string.format("Respawn Available In %s Seconds", _countdown)
							or string.format("Knocked Out, Can Get Up In %s Seconds", _countdown)
					)
				else
					local cost = 5000
					if not GlobalState["Duty:ems"] or GlobalState["Duty:ems"] == 0 then
						cost = 150
					end
					DrawUIText(
						4,
						true,
						0.5,
						0.9,
						0.35,
						255,
						255,
						255,
						255,
						(not LocalPlayer.state.deadData?.isMinor) and string.format("Press ~r~(%s)~s~ To Respawn ($%s)", key, cost)
							or string.format("Press ~r~(%s)~s~ To Stand Up", key)
					)
				end
			end
			Citizen.Wait(1)
		end
		_threading = false
	end)

	if not _counting then
		_counting = true
		Citizen.CreateThread(function()
			while LocalPlayer.state.loggedIn and _countdown >= 0 and LocalPlayer.state.isDead and _counting do
				Citizen.Wait(1000)
				_countdown = _countdown - 1
			end
			_counting = false
		end)
	end
end

Citizen.CreateThread(function()
	while LocalPlayer.state.ped == nil do
		Citizen.Wait(1)
	end

	while true do
		SetEntityMaxHealth(LocalPlayer.state.ped, 200)
		if Config.RegenRate >= 0 and Config.RegenRate <= 1.0 then
			SetPlayerHealthRechargeMultiplier(LocalPlayer.state.PlayerID, Config.RegenRate)
		else
			SetPlayerHealthRechargeMultiplier(LocalPlayer.state.PlayerID, 0.0)
		end

		Citizen.Wait(1000)
	end
end)
