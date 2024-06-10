RegisterNetEvent('VOIP:Phone:Client:SyncCallData', function(callTable, channel)
	CALL_DATA = callTable
	for tgt, enabled in pairs(CALL_DATA) do
		if tgt ~= playerServerId then
			VOIP:ToggleVoice(tgt, enabled, 'phone')
		end
	end
end)

RegisterNetEvent('VOIP:Phone:Client:AddPlayerToCall', function(plySource)
	if CALL_CHANNEL and CALL_CHANNEL > 0 then
		CALL_DATA[plySource] = false
	end
end)

RegisterNetEvent('VOIP:Phone:Client:RemovePlayerFromCall', function(plySource)
	if plySource == PLAYER_SERVER_ID then
		for tgt, enabled in pairs(CALL_DATA) do
			if tgt ~= PLAYER_SERVER_ID then
				VOIP:ToggleVoice(tgt, false, 'phone')
			end
		end
		CALL_DATA = {}
		MumbleClearVoiceTargetPlayers(1)
		VOIP:SetPlayerTargets(RADIO_TALKING and RADIO_DATA or {}, CALL_DATA)
	else
		CALL_DATA[plySource] = nil
		VOIP:ToggleVoice(plySource, false, 'phone')
		MumbleClearVoiceTargetPlayers(1)
		VOIP:SetPlayerTargets(RADIO_TALKING and RADIO_DATA or {}, CALL_DATA)
	end

	UpdateVOIPIndicatorStatus()
end)

RegisterNetEvent('VOIP:Phone:Client:SetPlayerTalkState', function(targetSource, enabled)
	if targetSource ~= PLAYER_SERVER_ID then
		CALL_DATA[targetSource] = enabled
		VOIP:ToggleVoice(targetSource, enabled, 'phone')
	end
end)

RegisterNetEvent('VOIP:Phone:Client:SetPlayerCall', function(callChannel)
	CALL_CHANNEL = callChannel

	if CALL_CHANNEL and CALL_CHANNEL > 0 then
		StopUsingMegaphone()
	end

	UpdateVOIPIndicatorStatus()
end)

AddEventHandler('VOIP:Client:TalkingState', function(state)
	if CALL_CHANNEL and CALL_CHANNEL > 0 then
		if state then
			VOIP:SetPlayerTargets(RADIO_TALKING and RADIO_DATA or {}, CALL_DATA)
		else
			MumbleClearVoiceTargetPlayers(1)
		end
		TriggerServerEvent('VOIP:Phone:Server:SetTalking', state)
	end
end)