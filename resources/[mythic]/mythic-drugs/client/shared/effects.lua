
local _runSpeedTime = 0
RegisterNetEvent("Drugs:Effects:RunSpeed", function(quality)
	if _runSpeedTime > 0 then
		return
	end

    local addiction = LocalPlayer.state.Character:GetData("Addiction")?.Coke?.Factor or 0.0
	_runSpeedTime = 60 * (1.0 - (addiction / 100))

	local ped = PlayerPedId()
	local pId = PlayerId()
	local loops = 0

    local speedMod = 0.49 * (quality / 100)
    if speedMod > 0.49 then
        speedMod = 0.49
    end

    local total = 1.0 + speedMod

    LocalPlayer.state.drugsRunSpeed = true
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
	SetRunSprintMultiplierForPlayer(pId, total)
	SetSwimMultiplierForPlayer(pId, total)

    StatSetInt(`MP0_STAMINA`, 100, true)
	while _runSpeedTime > 0 and not LocalPlayer.state.isDead do
        total = 1.0 + (speedMod * (1.0 - (loops / 100)))

        SetRunSprintMultiplierForPlayer(pId, total)
        SetSwimMultiplierForPlayer(pId, total)

		loops = loops + 1
		Wait(1000)
		RestorePlayerStamina(pId, 1.0)
		_runSpeedTime = _runSpeedTime - 1
		if IsPedRagdoll(ped) then
			SetPedToRagdoll(ped, math.random(5), math.random(5), 3, 0, 0, 0)
		end
	end
    StopScreenEffect("DrugsMichaelAliensFight")
	_runSpeedTime = 0
	SetRunSprintMultiplierForPlayer(pId, 1.0)
	SetSwimMultiplierForPlayer(pId, 1.0)
    StatSetInt(`MP0_STAMINA`, 25, true)
    LocalPlayer.state.drugsRunSpeed = false
end)

local _armorTime = 0
RegisterNetEvent("Drugs:Effects:Armor", function(quality)
	-- TriggerEvent("addiction:drugTaken", "meth")
	if _armorTime > 0 then
		return
	end

    local addiction = LocalPlayer.state.Character:GetData("Addiction")?.Meth?.Factor or 0.0
    
	_armorTime = 0
	local drugEffectApplyArmorMulti = 0.0
	local drugEffectQualityMulti = 1.0
	local sprintEffectFactor = 1.0
	local drugEffectQuality = quality and quality or 20
	if drugEffectQuality > 25 and drugEffectQuality <= 50 then
		drugEffectQualityMulti = 2.0
		drugEffectApplyArmorMulti = 1.0
	elseif drugEffectQuality > 50 and drugEffectQuality <= 62.5 then
		drugEffectQualityMulti = 3.0
		drugEffectApplyArmorMulti = 1.0
	elseif drugEffectQuality > 62.5 and drugEffectQuality <= 75 then
		drugEffectQualityMulti = 6.0
		drugEffectApplyArmorMulti = 1.0
	elseif drugEffectQuality > 75 and drugEffectQuality <= 90 then
		drugEffectQualityMulti = 12.0
		drugEffectApplyArmorMulti = 1.0
	elseif drugEffectQuality > 90 and drugEffectQuality <= 99 then
		drugEffectQualityMulti = 18.0
		drugEffectApplyArmorMulti = 2.0
	elseif drugEffectQuality > 99 then
		drugEffectQualityMulti = 30.0
		drugEffectApplyArmorMulti = 3.0
	end

	_armorTime = (drugEffectQualityMulti * 6) * (1.0 - (addiction / 100))

	local loops = 0
	while _armorTime > 0 and not LocalPlayer.state.isDead do
		loops = loops + 1
		Wait(1000)
		_armorTime = _armorTime - 1
		if IsPedRagdoll(PlayerPedId()) then
			SetPedToRagdoll(PlayerPedId(), math.random(5), math.random(5), 3, 0, 0, 0)
		end
		if drugEffectApplyArmorMulti > 0 then
			local armor = GetPedArmour(PlayerPedId())
			SetPedArmour(PlayerPedId(), math.floor(armor + drugEffectApplyArmorMulti))
		end
	end
	_armorTime = 0
end)
