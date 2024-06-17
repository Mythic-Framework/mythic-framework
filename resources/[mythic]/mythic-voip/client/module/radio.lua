local radioRanges = {
	radio = {
		min = 0.0,
		max = 600.0,
	},
	radio_med = {
		min = 600.0,
		max = 1200.0,
	},
	radio_far = {
		min = 1200.0,
		max = 1800.0,
	},
	radio_really_far = {
		min = 1800.0,
		max = 2400.0,
	}
}

function GetRadioSubmixType(playerCoords, playerVeh)
	if RADIO_CHANNEL >= 100 then -- Shitty Radio
		local isInVehicle = playerVeh and playerVeh > 0
		local dist = #(GetEntityCoords(LocalPlayer.state.ped) - playerCoords)

		if playerVeh and playerVeh > 0 then
			dist *= 0.75
		end

		local filter = false
		for k, v in pairs(radioRanges) do
			if dist >= v.min and dist < v.max then
				filter = k
			end
		end

		if filter then
			return filter, false
		else
			return false, 0.0
		end
	else
		return "radio", false
	end
end

RegisterNetEvent('VOIP:Radio:Client:SyncRadioData', function(radioData, coordsData, vehData)
	RADIO_DATA = radioData
	Logger:Trace('VOIP', 'Syncing Radio')
	for tgt, talking in pairs(RADIO_DATA) do
		if tgt ~= PLAYER_SERVER_ID then
			if talking then
				local submix, vol = GetRadioSubmixType(coordsData[tgt], vehData[tgt])
				VOIP:ToggleVoice(tgt, talking, submix, vol)
			else
				VOIP:ToggleVoice(tgt, false)
			end
		end
	end
end)

RegisterNetEvent('VOIP:Radio:Client:SetPlayerTalkState', function(targetSource, isTalking, playerCoords, inVeh)
	if isTalking then
		local submix, vol = GetRadioSubmixType(playerCoords, inVeh)

		VOIP:ToggleVoice(targetSource, isTalking, submix, vol)
	else
		VOIP:ToggleVoice(targetSource, false)
	end
	
	RADIO_DATA[targetSource] = isTalking
	VOIP:MicClicks(isTalking)
end)

RegisterNetEvent('VOIP:Radio:Client:AddPlayerToRadio', function(targetSource)
	Logger:Trace('VOIP', ('%s Joined Current Radio Channel'):format(targetSource))
	RADIO_DATA[targetSource] = false
	if RADIO_TALKING then
		VOIP:SetPlayerTargets(RADIO_DATA, PLAYER_TALKING and CALL_DATA or {})
	end
end)

RegisterNetEvent('VOIP:Radio:Client:RemovePlayerFromRadio', function(targetSource)
	if targetSource == PLAYER_SERVER_ID then
		Logger:Trace('VOIP', 'Leaving Current Radio Channel - Clearing Up')
		for tgt, enabled in pairs(RADIO_DATA) do
			if tgt ~= PLAYER_SERVER_ID then
				VOIP:ToggleVoice(tgt, false)
			end
		end
		RADIO_DATA = {}
		VOIP:SetPlayerTargets({}, PLAYER_TALKING and CALL_DATA or {})
	else
		Logger:Trace('VOIP', ('%s Left Current Radio Channel'):format(targetSource))
		RADIO_DATA[targetSource] = nil
		VOIP:ToggleVoice(targetSource, false)
		if RADIO_TALKING then
			VOIP:SetPlayerTargets(RADIO_DATA, PLAYER_TALKING and CALL_DATA or {})
		end
	end
end)

function RadioKeyDown()
	if not RADIO_TALKING and RADIO_CHANNEL and RADIO_CHANNEL > 0 and not LocalPlayer.state.isDead then
		StopUsingMegaphone()
		LoadAnim('random@arrests')
		Logger:Trace('VOIP', 'Starting Radio Broadcast')
		VOIP:SetPlayerTargets(RADIO_DATA, PLAYER_TALKING and CALL_DATA or {})
		TriggerServerEvent('VOIP:Radio:Server:SetTalking', true)
		RADIO_TALKING = true
		VOIP:MicClicks(true)
		UpdateVOIPIndicatorStatus()
		CreateThread(function()
			while RADIO_TALKING and _characterLoaded do
				Wait(0)
				SetControlNormal(0, 249, 1.0)
				SetControlNormal(1, 249, 1.0)
				SetControlNormal(2, 249, 1.0)

				if not IsEntityPlayingAnim(GLOBAL_PED, 'random@arrests', 'generic_radio_chatter', 3) then
					TaskPlayAnim(GLOBAL_PED, 'random@arrests', 'generic_radio_chatter', 8.0, 0.0, -1, 49, 0, false, false, false)
				end
			end

			StopAnimTask(PlayerPedId(), 'random@arrests', 'generic_radio_chatter', 3.0)
		end)
	end
end

function RadioKeyUp()
	if RADIO_CHANNEL and RADIO_CHANNEL > 0 and RADIO_TALKING then
		Logger:Trace('VOIP', 'Stopping Radio Broadcast')
		RADIO_TALKING = false
		TriggerServerEvent('VOIP:Radio:Server:SetTalking', false)
		MumbleClearVoiceTargetPlayers(1)
		VOIP:MicClicks(false)
		UpdateVOIPIndicatorStatus()
	end
end

AddEventHandler('Ped:Client:Died', function()
    RadioKeyUp()
end)

RegisterNetEvent('VOIP:Radio:Client:SetPlayerRadio', function(channel)
	RADIO_CHANNEL = channel
	Logger:Trace('VOIP', ('New Radio Channel: %s'):format(channel))
	UpdateVOIPIndicatorStatus()
end)