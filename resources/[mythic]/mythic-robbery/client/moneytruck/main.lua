_, driverHash = AddRelationshipGroup('BOBCAT_SECURITY_DRIVER')
SetRelationshipBetweenGroups(5, relHash, `PLAYER`)
SetRelationshipBetweenGroups(5, `PLAYER`, relHash)


AddEventHandler("Robbery:Client:Setup", function()
	Callbacks:RegisterClientCallback("Robbery:Moneytruck:CheckForTruck", function(data, cb)
		local startPos = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0, 0.5, 0)
		local endPos = GetOffsetFromEntityInWorldCoords(LocalPlayer.state.ped, 0, 5.0, 0)
		local rayHandle = StartShapeTestRay(startPos.x, startPos.y, startPos.z, endPos.x, endPos.y, endPos.z, -1, LocalPlayer.state.ped, 0)
		local rayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
		if hit then
			if GetEntityHealth(entityHit) > 0 then
				local model = GetEntityModel(entityHit)
				if model == `stockade` then
					return cb(1, VehToNet(entityHit))
				elseif model == `stockade2` then
					return cb(2, VehToNet(entityHit))
				end
			end
		end

		return cb(nil)
	end)

    Callbacks:RegisterClientCallback("Robbery:Moneytruck:Thermite:Door", function(data, cb)
		local ent = NetworkGetEntityFromNetworkId(data.vNet)
		NetworkRequestControlOfEntity(ent)
		local truckCoords = GetEntityCoords(ent)
		local thermiteCoords = GetOffsetFromEntityInWorldCoords(ent, 0.0, -3.55, 0.0)
		_memPass = 1
		ThermiteShit({
				x = thermiteCoords.x,
				y = thermiteCoords.y,
				z = thermiteCoords.z + 1.0,
				h = GetEntityHeading(ent),
			}, data, cb)
	end)

    Callbacks:RegisterClientCallback("Robbery:Moneytruck:Spawn:Get", function(data, cb)
        if LocalPlayer.state.loggedIn then
			local randomLoc = FindRandomPointInSpace(LocalPlayer.state.ped)
            local found, loc, heading = GetClosestVehicleNodeWithHeading(randomLoc.x, randomLoc.y, randomLoc.z, 12, 3.0, 0)

            if found then
				if #(randomLoc - loc) <= 300 then
					cb(loc, heading)
				else
					cb(false)
				end
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)

	Callbacks:RegisterClientCallback("Robbery:MoneyTruck:CreatePeds", function(data, cb)
		local ent = NetworkGetEntityFromNetworkId(data.netId)

		for i = 1, data.amount do
			local model = `S_M_M_Security_01`
			if type == 2 then
				model = `s_m_m_armoured_03`
			end

			loadModel(model)

			local coords = GetEntityCoords(ent)

			local ped = CreatePed(5, model, coords.x + math.random(-15.0, 15.0), coords.y + math.random(-15.0, 15.0), coords.z, math.random(360) * 1.0, true, true)

			while not DoesEntityExist(ped) do
				Wait(1)
			end

			local w = _bobcatWeapons[math.random(#_bobcatWeapons)]
			Entity(ped).state:set('crimePed', true, true)
			GiveWeaponToPed(ped, w, 99999, false, true)
			SetCurrentPedWeapon(ped, w, true)

			SetEntityMaxHealth(ped, 2000)
			SetEntityHealth(ped, 2000)
			SetPedArmour(ped, 1000)

			SetEntityInvincible(p, true)

			DecorSetBool(ped, 'ScriptedPed', true)
			SetEntityAsMissionEntity(ped, 1, 1)

			SetPedRelationshipGroupDefaultHash(ped, `BOBCAT_SECURITY`)
			SetPedRelationshipGroupHash(ped, `BOBCAT_SECURITY`)
			SetPedRelationshipGroupHash(ped, `HATES_PLAYER`)
			SetCanAttackFriendly(ped, false, true)
			SetPedAsCop(ped)

			TaskTurnPedToFaceEntity(ped, LocalPlayer.state.ped, 1.0)

			SetPedCombatMovement(ped, 2)
			SetPedCombatRange(ped, 0)
			SetPedCombatAttributes(ped, 46, 1)
			SetPedCombatAttributes(ped, 292, 1)
			SetPedCombatAttributes(ped, 5000, 1)
			SetPedFleeAttributes(ped, 0, 0)
			SetPedAsEnemy(ped, true)
			
			SetPedSeeingRange(ped, 100.0)
			SetPedHearingRange(ped, 100.0)
			SetPedAlertness(ped, 3)

			TaskCombatHatedTargetsAroundPed(ped, 100.0, 0)

			local _, cur = GetCurrentPedWeapon(ped, true)
			SetPedInfiniteAmmo(ped, true, cur)
			SetPedDropsWeaponsWhenDead(ped, false)

			SetEntityInvincible(ped, false)
		end
	end)

	Callbacks:RegisterClientCallback("Robbery:MoneyTruck:MarkTruck", function(data, cb)
		local ent = NetworkGetEntityFromNetworkId(data)

		local text = "Bobcat Truck"
		if GetEntityModel(ent) == `stockade` then
			text = "Gruppe 6 Truck"
		end

		if ent ~= 0 then
			local blip = AddBlipForEntity(ent)

			SetBlipSprite(blip, 477)
			SetBlipColour(blip, 69)
			SetBlipScale(blip, 0.85)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(text)
			EndTextCommandSetBlipName(blip)

			SetTimeout((1000 * 60) * 10, function()
				RemoveBlip(blip)
			end)

			cb(true)
		else
			cb(false)
		end
	end)
end)

AddEventHandler("Robbery:Client:MoneyTruck:GrabLoot", function(entity, data)
	Callbacks:ServerCallback('Robbery:MoneyTruck:CheckLoot', VehToNet(entity.entity), function(s)
		if s then
			Progress:Progress({
				name = "moneytruck_loot",
				duration = (math.random(30) + 45) * 1000,
				label = "Grabbing Fat Lewts",
				useWhileDead = false,
				canCancel = true,
				ignoreModifier = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					anim = "type",
				},
			}, function(status)
				if not status then
					Callbacks:ServerCallback('Robbery:MoneyTruck:Loot', VehToNet(entity.entity), function(s2) end)
				else
					Callbacks:ServerCallback('Robbery:MoneyTruck:CancelLoot', VehToNet(entity.entity), function(s2) end)
				end
			end)
		end
	end)
end)