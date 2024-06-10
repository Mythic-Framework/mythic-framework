function IsDamagingEvent(damageDone, weapon)
	local luck = math.random(100)
	local multi = damageDone / Config.HealthDamage
	return true
	-- return (luck < (Config.HealthDamage * multi))
	-- 	or (damageDone >= Config.ForceInjury)
	-- 	or (multi > Config.MaxInjuryChanceMulti)
	-- 	or Config.ForceInjuryWeapons[weapon]
end

function IsInjuryCausingLimp()
	if LocalDamage == nil then
		return false
	end
	for k, v in pairs(LocalDamage.Limbs) do
		if v.causeLimp and v.isDamaged then
			return true
		end
	end
	return false
end

function GetDamagingWeapon(ped)
	for k, v in pairs(Config.Weapons) do
		if HasPedBeenDamagedByWeapon(ped, k, 0) then
			ClearEntityLastDamageEntity(ped)
			return v
		end
	end
	return nil
end

function ProcessDamage(ped)
	if not IsEntityDead(ped) or not (LocalPlayer.state.onDrugs > 0) and not LocalPlayer.state.isHospitalized then
		for part, v in pairs(_damagedLimbs) do
			if
				(part == "LLEG" and v.severity > 1)
				or (part == "RLEG" and v.severity > 1)
				or (part == "LFOOT" and v.severity > 2)
				or (part == "RFOOT" and v.severity > 2)
			then
				if legCount >= Config.LegInjuryTimer then
					if not IsPedRagdoll(ped) and IsPedOnFoot(ped) then
						local chance = math.random(100)
						if IsPedRunning(ped) or IsPedSprinting(ped) then
							if chance <= Config.LegInjuryChance.Running then
								Notification:Custom(
									Config.Strings.InjurNoRun,
									5000,
									"clipboard-medical",
									Config.NotifStyle
								)
								ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.08) -- change this float to increase/decrease camera shake
								SetPedToRagdollWithFall(
									ped,
									1500,
									2000,
									1,
									GetEntityForwardVector(ped),
									1.0,
									0.0,
									0.0,
									0.0,
									0.0,
									0.0,
									0.0
								)
							end
						else
							if chance <= Config.LegInjuryChance.Walking then
								Notification:Custom(
									Config.Strings.InjurStumble,
									5000,
									"clipboard-medical",
									Config.NotifStyle
								)
								ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.08) -- change this float to increase/decrease camera shake
								SetPedToRagdollWithFall(
									ped,
									1500,
									2000,
									1,
									GetEntityForwardVector(ped),
									1.0,
									0.0,
									0.0,
									0.0,
									0.0,
									0.0,
									0.0
								)
							end
						end
					end
					legCount = 0
				else
					legCount = legCount + 1
				end
			elseif
				(part == "LARM" and v.severity > 1)
				or (part == "LHAND" and v.severity > 1)
				or (part == "LFINGER" and v.severity > 2)
				or (part == "RARM" and v.severity > 1)
				or (part == "RHAND" and v.severity > 1)
				or (part == "RFINGER" and v.severity > 2)
			then
				if armcount >= Config.ArmInjuryTimer then
					local chance = math.random(100)

					if
						(part == "LARM" and v.severity > 1)
						or (part == "LHAND" and v.severity > 1)
						or (part == "LFINGER" and v.severity > 2)
					then
						local isDisabled = 15
						Citizen.CreateThread(function()
							while isDisabled > 0 do
								if IsPedInAnyVehicle(ped, true) then
									DisableControlAction(0, 63, true) -- veh turn left
								end

								if IsPlayerFreeAiming(PlayerId()) then
									DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
								end

								isDisabled = isDisabled - 1
								Citizen.Wait(1)
							end
						end)
					else
						local isDisabled = 15
						Citizen.CreateThread(function()
							while isDisabled > 0 do
								if IsPedInAnyVehicle(ped, true) then
									DisableControlAction(0, 63, true) -- veh turn left
								end

								if IsPlayerFreeAiming(PlayerId()) then
									DisableControlAction(0, 25, true) -- Disable weapon firing
								end

								isDisabled = isDisabled - 1
								Citizen.Wait(1)
							end
						end)
					end

					armcount = 0
				else
					armcount = armcount + 1
				end
			elseif part == "HEAD" and v.severity > 2 then
				if headCount >= Config.HeadInjuryTimer then
					local chance = math.random(100)

					if chance <= Config.HeadInjuryChance then
						Notification:Custom(Config.Strings.Blackout, 5000, "clipboard-medical", Config.NotifStyle)
						SetFlash(0, 0, 100, 10000, 100)

						DoScreenFadeOut(100)
						while not IsScreenFadedOut() do
							Citizen.Wait(0)
						end

						if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
							ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.08) -- change this float to increase/decrease camera shake
							SetPedToRagdoll(ped, 5000, 1, 2)
						end

						Citizen.Wait(5000)
						DoScreenFadeIn(250)
					end
					headCount = 0
				else
					headCount = headCount + 1
				end
			end
		end
	end
end
