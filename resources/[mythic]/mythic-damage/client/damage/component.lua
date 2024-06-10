DAMAGE = {
	_required = { "Heal", "Alerts" },
	GetDamage = function(self)
		return _damagedLimbs
	end,
	IsLimping = function(self)
		return IsInjuryCausingLimp()
	end,
	GetDamageLabel = function(self, severity)
		return Config.WoundStates[severity]
	end,
	GetBleedLabel = function(self, severity)
		return Config.BleedingStates[severity]
	end,
	Pickup = function(self)
		Callbacks:ServerCallback("Damage:Revive", false, function(s)
			local player = PlayerPedId()

			if LocalPlayer.state.isDead then
				DoScreenFadeOut(1000)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
			end

			LocalPlayer.state:set("isDead", false, true)
			LocalPlayer.state:set("deadData", nil, true)
			LocalPlayer.state:set("isDeadTime", nil, true)

			if IsPedDeadOrDying(player) then
				local playerPos = GetEntityCoords(player, true)
				NetworkResurrectLocalPlayer(playerPos, true, true, false)
			end

			if s then
				AnimpostfxStop("DeathFailMPIn")
				AnimpostfxStop("PPPurple")
				AnimpostfxStop("DrugsMichaelAliensFight")
				AnimpostfxStop("DeathFailMPDark")
				Hud:Dead(false)
				ClearPedTasksImmediately(player)
			end

			SetEntityInvincible(player, false)
			SetEntityHealth(player, 110)
			ClearPedBloodDamage(player)
			Status:Reset()
			Damage.Alerts:All()
			DoScreenFadeIn(1000)
		end)
	end,
	Heal = function(self)
		Callbacks:ServerCallback("Damage:Revive", true, function(s)
			local isKnockout = LocalPlayer.state.deadData?.isMinor == true

			print(isKnockout)

			local player = PlayerPedId()

			if LocalPlayer.state.isDead then
				DoScreenFadeOut(1000)
				while not IsScreenFadedOut() do
					Citizen.Wait(10)
				end
			end

			LocalPlayer.state:set("isDead", false, true)
			LocalPlayer.state:set("deadData", nil, true)
			LocalPlayer.state:set("isDeadTime", nil, true)

			if IsPedDeadOrDying(player) then
				local playerPos = GetEntityCoords(player, true)
				NetworkResurrectLocalPlayer(playerPos, true, true, false)
			end

			if s then
				AnimpostfxStop("DeathFailMPIn")
				AnimpostfxStop("PPPurple")
				AnimpostfxStop("DrugsMichaelAliensFight")
				AnimpostfxStop("DeathFailMPDark")
				Hud:Dead(false)
				ClearPedTasksImmediately(player)
			end
			SetEntityInvincible(player, false)

			if isKnockout then
				SetEntityHealth(player, 125)
			else
				SetEntityHealth(player, GetEntityMaxHealth(player))
				_damagedLimbs = {}
				bleedTickTimer = 0
				bleedTickEvidenceTimer = 0
				advanceBleedTimer = 0
				LocalPlayer.state.onDrugs = 0
				LocalPlayer.state.wasOnDrugs = false
				LocalPlayer.state.onPainKillers = 0
				LocalPlayer.state.wasOnPainKillers = false
				Status:Reset()
			end

			SetPlayerSprint(PlayerId(), true)
			ClearPedBloodDamage(player)
			Damage.Alerts:All()
			DoScreenFadeIn(1000)
		end)
	end,
	Alerts = {
		Reset = function(self)
			Notification.Persistent:Remove(bleedNotifId)
			Notification.Persistent:Remove(limbNotifId)
			Notification.Persistent:Remove(bleedMoveNotifId)
		end,
		All = function(self)
			Damage.Alerts:Bleed()
			Damage.Alerts:Limbs()
		end,
		Bleed = function(self)
			local player = PlayerPedId()
			if not IsEntityDead(player) and LocalDamage ~= nil and LocalDamage.Bleed > 0 then
				Notification.Persistent:Custom(
					bleedNotifId,
					string.format(Config.Strings.BleedAlert, Config.BleedingStates[LocalDamage.Bleed]),
					Config.NotifStyle
				)
			else
				Notification.Persistent:Remove(bleedNotifId)
			end
		end,
		Limbs = function(self)
			local player = PlayerPedId()
			if not IsEntityDead(player) then
				local size = cTable(_damagedLimbs)
				if size > 0 then
					local limbDamageMsg = ""
					if size <= Config.AlertShowInfo then
						local c = 0
						for k, v in pairs(_damagedLimbs) do
							c = c + 1
							limbDamageMsg = string.format(
								Config.Strings.LimbAlert,
								v.label,
								Config.WoundStates[v.severity]
							)
							if c < size then
								limbDamageMsg = limbDamageMsg .. Config.Strings.LimbAlertSeperator
							end
						end
					else
						limbDamageMsg = Config.Strings.LimbAlertMultiple
					end

					Notification.Persistent:Custom(limbNotifId, limbDamageMsg, "clipboard-medical", Config.NotifStyle)
				else
					Notification.Persistent:Remove(limbNotifId)
				end
			else
				Notification.Persistent:Remove(limbNotifId)
			end
		end,
		Debug = function(self, ped, bone, weapon, damageDone)
			Notification:Standard("Bone: " .. Config.Bones[bone])
			if Config.MinorInjurWeapons[weapon] ~= nil then
				Notification:Standard("Minor Weapon : " .. weapon, 10000)
			else
				Notification:Standard("Major Weapon : " .. weapon, 10000)
			end
			Notification:Standard("Crit Area: " .. tostring(Config.CriticalAreas[Config.Bones[bone]] ~= nil), 10000)
			Notification:Standard(
				"Stagger Area: "
					.. tostring(
						Config.StaggerAreas[Config.Bones[bone]] ~= nil
							and (Config.StaggerAreas[Config.Bones[bone]].armored or GetPedArmour(ped) <= 0)
					),
				10000
			)
			Notification:Standard("Dmg Done: " .. damageDone, 10000)
		end,
	},
	CheckDamage = function(self, ped, bone, weapon, damageDone)
		if weapon == nil then
			return
		end

		if Config.Bones[bone] ~= nil and not IsEntityDead(ped) then
			if Config.Debug then
				Damage.Alerts:Debug(ped, bone, weapon, damageDone)
			end

			Damage.Apply:Effects(ped, bone, weapon, damageDone)

			Callbacks:ServerCallback("Damage:ApplyDamage", {
				bone = bone,
				wepClass = Config.Weapons[weapon],
			}, function()
				if LocalDamage.Limbs[Config.Bones[bone]].severity == 1 then
					_damagedLimbs[Config.Bones[bone]] = {
						label = LocalDamage.Limbs[Config.Bones[bone]].label,
						severity = LocalDamage.Limbs[Config.Bones[bone]].severity,
					}
				elseif _damagedLimbs[Config.Bones[bone]] ~= nil then
					_damagedLimbs[Config.Bones[bone]].severity = LocalDamage.Limbs[Config.Bones[bone]].severity
				end

				Damage.Alerts:All()
				Damage.Apply:Movement(ped)
			end)
		else
			if not IsEntityDead(ped) then
				Logger:Error("Damage", string.format("Bone Not In Index - Report This!\tBone Index: %s", bone))
			end
		end
	end,
	Apply = {
		StandardDamage = function(self, value, armorFirst)
			ApplyDamageToPed(LocalPlayer.state.ped, value, armorFirst)
		end,
		Bleed = function(self, level)
			Callbacks:ServerCallback("Damage:ApplyBleed", level, function(new)
				Damage.Alerts:All()
			end)
		end,
		Effects = function(self, bone, weapon, damageDone)
			local armor = GetPedArmour(LocalPlayer.state.ped)

			if Config.MinorInjurWeapons[weapon] and damageDone < Config.DamageMinorToMajor then
				if Config.CriticalAreas[Config.Bones[bone]] then
					if armor <= 0 then
						Damage.Apply:Bleed(1)
					end
				end

				if
					Config.StaggerAreas[Config.Bones[bone]] ~= nil
					and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0)
				then
					if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].minor) then
						SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
					end
				end
			elseif
				Config.MajorInjurWeapons[weapon]
				or (Config.MinorInjurWeapons[weapon] and damageDone >= Config.DamageMinorToMajor)
			then
				if Config.CriticalAreas[Config.Bones[bone]] ~= nil then
					if armor > 0 and Config.CriticalAreas[Config.Bones[bone]].armored then
						if math.random(100) <= math.ceil(Config.MajorArmoredBleedChance) then
							Damage.Apply:Bleed(1)
						end
					else
						Damage.Apply:Bleed(1)
					end
				else
					if armor > 0 then
						if math.random(100) < Config.MajorArmoredBleedChance then
							Damage.Apply:Bleed(1)
						end
					else
						if math.random(100) < (Config.MajorArmoredBleedChance * 2) then
							Damage.Apply:Bleed(1)
						end
					end
				end

				if
					Config.StaggerAreas[Config.Bones[bone]] ~= nil
					and (Config.StaggerAreas[Config.Bones[bone]].armored or armor <= 0)
				then
					if math.random(100) <= math.ceil(Config.StaggerAreas[Config.Bones[bone]].major) then
						SetPedToRagdoll(LocalPlayer.state.ped, 1500, 2000, 3, true, true, false)
					end
				end
			end
		end,
		Movement = function(self)
			if IsInjuryCausingLimp() and not (LocalPlayer.state.onPainKillers > 0) then
				if not LocalPlayer.state.isLimping then
					LocalPlayer.state.isLimping = true
					Animations.PedFeatures:RequestFeaturesUpdate()
				end
			else
				if LocalPlayer.state.isLimping then
					LocalPlayer.state.isLimping = false
					Animations.PedFeatures:RequestFeaturesUpdate()
				end
			end
		end,
	},
}
