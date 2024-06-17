local _drunkMovementClipsets = {
	"move_m@drunk@slightlydrunk",
	"move_m@drunk@moderatedrunk",
	"move_m@drunk@verydrunk",
}

local _drunkVehicleActions = {
	1,
	4,
	5,
	7,
	9,
	21,
	22,
	30,
	31,
	32,
}

AddEventHandler("Characters:Client:Spawn", function()
	CreateThread(function()
		local wasDrunk = false
		local lastShakeTime = 0
		local drunkMovement = 0
		local lastMovement = 0
		local nextStumble = 0
		local lastBlackout = 0

		LoadAnimSets(_drunkMovementClipsets)

		Wait(10000)

		while LocalPlayer.state.loggedIn do
			if not LocalPlayer.state.isDead then
				local val = Status.Get:Single("PLAYER_DRUNK").value or 0

				if val >= 10 then
					if not wasDrunk then
						wasDrunk = true
						LocalPlayer.state:set('isDrunk', val, true)
					end

					if val > 30 then
						if lastShakeTime < GetGameTimer() then
							ShakeGameplayCam("DRUNK_SHAKE", math.min((val / 170), 0.7))
							lastShakeTime = GetGameTimer() + 60000
						end
					else
						ShakeGameplayCam("DRUNK_SHAKE", 0.0)
					end

					if val >= 25 then
						local mvUpdate = lastMovement < GetGameTimer()
						if mvUpdate then
							local newMovement = 0
							if val >= 70 then
								newMovement = 3
							elseif val >= 40 then
								newMovement = 2
							elseif val >= 25 then
								newMovement = 1
							end

							if newMovement ~= drunkMovement then
								drunkMovement = newMovement
								if newMovement > 0 and _drunkMovementClipsets[newMovement] then
									SetPedMovementClipset(LocalPlayer.state.ped, _drunkMovementClipsets[newMovement], 1.0)
									LocalPlayer.state:set('drunkMovement', true, false)
								else
									ResetPedMovementClipset(LocalPlayer.state.ped, 0.0)
									LocalPlayer.state:set('drunkMovement', false, false)
								end
							end
							lastMovement = GetGameTimer() + 15000
						end
					elseif drunkMovement > 0 then
						lastMovement = 0
						drunkMovement = 0
						nextStumble = 0
						ResetPedMovementClipset(LocalPlayer.state.ped, 0.0)
						LocalPlayer.state:set('drunkMovement', false, false)
					end

					if val > 40 then
						if nextStumble <= 0 then
							local rem = math.floor(100 - val)
							if rem < 12 then
								rem = 12
							elseif rem > 40 then
								rem = 40
							end

							nextStumble = GetGameTimer() + (rem * 1000)
						end
					elseif nextStumble > 0 then
						nextStumble = 0
					end

					if nextStumble > 0 and nextStumble <= GetGameTimer() then
						local time = math.random(2, 5) * 1000
						SetPedToRagdoll(LocalPlayer.state.ped, time, time, 0, 0, 0, 0)
						nextStumble = 0
					end

					if val > 65 then
						if lastBlackout <= 0 then
							lastBlackout = GetGameTimer() + (math.random(10, 30) * 1000)
						else
							if lastBlackout <= GetGameTimer() then
								DrunkTemporaryBlackout()

								local veh = GetVehiclePedIsIn(LocalPlayer.state.ped, false)
								if veh and GetPedInVehicleSeat(veh, -1) == LocalPlayer.state.ped then
									TaskVehicleTempAction(LocalPlayer.state.ped, veh, _drunkVehicleActions[math.random(#_drunkVehicleActions)], 5000)
								end

								lastBlackout = GetGameTimer() + (30000 + (math.random(5, 25) * 1000))
							end
						end
					end


					SetPedIsDrunk(LocalPlayer.state.ped, true)
					SetPedMotionBlur(LocalPlayer.state.ped, true)
					SetPedConfigFlag(LocalPlayer.state.ped, 100, true)

					Wait(1000)
				elseif wasDrunk then
					wasDrunk = false
					LocalPlayer.state:set('isDrunk', false, true)
					LocalPlayer.state:set('drunkMovement', false, false)

					lastShakeTime = 0
					drunkMovement = 0
					lastMovement = 0
					nextStumble = 0
					lastBlackout = 0

					SetPedIsDrunk(LocalPlayer.state.ped, false)
					SetPedMotionBlur(LocalPlayer.state.ped, false)
					SetPedConfigFlag(LocalPlayer.state.ped, 100, false)
					ShakeGameplayCam("DRUNK_SHAKE", 0.0)

					Wait(10000)
				else
					Wait(10000)
				end
			else
				Wait(10000)
			end
		end

		if wasDrunk then
			SetPedIsDrunk(PlayerPedId(), false)
			SetPedMotionBlur(PlayerPedId(), false)
			SetPedConfigFlag(PlayerPedId(), 100, false)
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
			ResetPedMovementClipset(LocalPlayer.state.ped, 0.0)
		end
	end)
end)

local _alcoholConfig = {
    wine = {
        anim = 'wine',
        actionLabel = 'Enjoying Wine',
        initialTime = 10 * 1000,
        maxTime = (60 * 1000 * 3),
        drunkBaseline = 15,
        drunkPerTick = 3, -- Every 5 seconds
        thirst = 15,
        stressRelief = 5,
    },
    beer = {
        anim = 'beer',
        actionLabel = 'Drinking Beer',
        initialTime = 8 * 1000,
        maxTime = (60 * 1000 * 3),
        drunkBaseline = 12,
        drunkPerTick = 3, -- Every 5 seconds
        thirst = 15,
        stressRelief = 4,
    },
    whiskey = {
        anim = 'whiskey',
        actionLabel = 'Drinking Whiskey',
        initialTime = 8 * 1000,
        maxTime = (60 * 1000 * 7),
        drunkBaseline = 13,
        drunkPerTick = 4, -- Every 5 seconds
        thirst = 5,
        stressRelief = 3,
    },
	tequila = {
        anim = 'tequila',
        actionLabel = 'Drinking Tequila',
        initialTime = 8 * 1000,
        maxTime = (60 * 1000 * 7),
        drunkBaseline = 13,
        drunkPerTick = 4, -- Every 5 seconds
        thirst = 5,
        stressRelief = 3,
    },
	rum = {
        anim = 'whiskey',
        actionLabel = 'Drinking Rum',
        initialTime = 8 * 1000,
        maxTime = (60 * 1000 * 7),
        drunkBaseline = 13,
        drunkPerTick = 4, -- Every 5 seconds
        thirst = 5,
        stressRelief = 6,
    },
    vodka = {
        anim = 'vodka',
        actionLabel = 'Drinking Vodka',
        initialTime = 8 * 1000,
        maxTime = (60 * 1000 * 7),
        drunkBaseline = 16,
        drunkPerTick = 5, -- Every 5 seconds
        thirst = 10,
        stressRelief = 5,
    },
	vodka_shot = {
        anim = 'shotglass',
        actionLabel = 'Drinking Shot of Vodka',
        initialTime = 8 * 1000,
        maxTime = (20 * 1000),
        drunkBaseline = 20,
        drunkPerTick = 5, -- Every 5 seconds
        thirst = 5,
        stressRelief = 5,
    },
    tequila_shot = {
        anim = 'shotglass',
        actionLabel = 'Drinking Shot of Tequila',
        initialTime = 8 * 1000,
        maxTime = (20 * 1000),
        drunkBaseline = 20,
        drunkPerTick = 5, -- Every 5 seconds
        thirst = 5,
        stressRelief = 5,
    },
    tequila_sunrise = {
        anim = 'cocktail',
        actionLabel = 'Drinking Tequila Sunrise',
        initialTime = 8 * 1000,
        maxTime = (60 * 1000 * 3),
        drunkBaseline = 10,
        drunkPerTick = 3, -- Every 5 seconds
        thirst = 5,
        stressRelief = 20,
    },
	whiskey_glass = {
        anim = 'shotglass',
        actionLabel = 'Drinking Whiskey',
        initialTime = 10 * 1000,
        maxTime = (60 * 1000 * 2),
        drunkBaseline = 16,
        drunkPerTick = 5, -- Every 5 seconds
        thirst = 10,
        stressRelief = 8,
    },
	cocktail = {
        anim = 'cocktail',
        actionLabel = 'Drinking Cocktail',
        initialTime = 8 * 1000,
        maxTime = (60 * 1000 * 3),
        drunkBaseline = 10,
        drunkPerTick = 3, -- Every 5 seconds
        thirst = 15,
        stressRelief = 10,
    },
    jaeger_bomb = {
        anim = 'shotglass',
        actionLabel = 'Drinking Shot',
        initialTime = 8 * 1000,
        maxTime = (20 * 1000),
        drunkBaseline = 20,
        drunkPerTick = 5, -- Every 5 seconds
        thirst = 5,
        stressRelief = 20,
    },
    diamond_drink = {
        anim = 'cocktail',
        actionLabel = 'Drinking Cocktail',
        initialTime = 8 * 1000,
        maxTime = (20 * 1000),
        drunkBaseline = 20,
        drunkPerTick = 3, -- Every 5 seconds
        thirst = 15,
        stressRelief = 20,
    },
    pint_mcdougles = {
        anim = 'glass',
        actionLabel = 'Drinking Pint',
        initialTime = 8 * 1000,
        maxTime = (30 * 1000),
        drunkBaseline = 5,
        drunkPerTick = 2, -- Every 5 seconds
        thirst = 25,
        stressRelief = 15,
    }
}

function IsDrinkingAlcohol()
    local doingAnim = Animations.Emotes:Get()
    for k,v in pairs(_alcoholConfig) do
        if v.anim == doingAnim then
            return true
        end
    end
    return false
end

function RegisterDrunkCallbacks()
    Callbacks:RegisterClientCallback('Status:DrinkAlcohol', function(data, cb)
        if IsDrinkingAlcohol() then
            Notification:Error('Already Drinking!')
            return cb(false)
        end

        local alcohol = _alcoholConfig[data]
        if alcohol then
            Animations.Emotes:Play(alcohol.anim, false, alcohol.initialTime, true)
            Progress:Progress({
                name = data,
                duration = alcohol.initialTime,
                label = alcohol.actionLabel,
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                },
            }, function(cancelled)
                cb(not cancelled)
                if not cancelled then
                    Animations.Emotes:ForceCancel()
                    Animations.Emotes:Play(alcohol.anim, false, false, false)

                    local drunkLevel = Status.Get:Single("PLAYER_DRUNK").value
                    if drunkLevel < alcohol.drunkBaseline then
                        Status.Set:Single("PLAYER_DRUNK", alcohol.drunkBaseline)
                    end

                    Status.Modify:Add("PLAYER_THIRST", alcohol.thirst)
                    Status.Modify:Remove("PLAYER_STRESS", alcohol.stressRelief, true)

                    local endTime = GetGameTimer() + alcohol.maxTime

                    CreateThread(function()
                        local tick = 3
                        while LocalPlayer.state.loggedIn and Animations.Emotes:Get() == alcohol.anim do
                            if tick >= 5 then
                                Status.Modify:Add("PLAYER_DRUNK", alcohol.drunkPerTick)

                                tick = 0
                                if endTime <= GetGameTimer() then
                                    Animations.Emotes:ForceCancel()
                                    break
                                end
                            else
                                tick += 1
                            end
                            Wait(1000)
                        end
                    end)
                end
            end)
        else
            cb(false)
        end
    end)
end

function DrunkTemporaryBlackout()
	CreateThread(function()
		DoScreenFadeOut(500)
		Wait(3500)
		DoScreenFadeIn(500)
	end)
end