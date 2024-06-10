_fuckingVOIPPhone = {
	Phone = {
		AddToCall = function(self, source, callChannel)
            if not voiceData[source] then return end
            Logger:Trace('VOIP', ('Adding %s to Call %s'):format(source, callChannel))
			callData[callChannel] = callData[callChannel] or {}
			for player, _ in pairs(callData[callChannel]) do
				if player ~= source then
					TriggerClientEvent('VOIP:Phone:Client:AddPlayerToCall', player, source)
				end
			end
			callData[callChannel][source] = false
			voiceData[source].Call = callChannel
			TriggerClientEvent('VOIP:Phone:Client:SyncCallData', source, callData[callChannel])
		end,
        RemoveFromCall = function(self, source, callChannel)
            if not voiceData[source] then return end
            Logger:Trace('VOIP', ('Removing %s from Call %s'):format(source, callChannel))

			callData[callChannel] = callData[callChannel] or {}
			for player, _ in pairs(callData[callChannel]) do
				TriggerClientEvent('VOIP:Phone:Client:RemovePlayerFromCall', player, source)
			end

			callData[callChannel][source] = nil
			voiceData[source].Call = 0
		end,
		SetCall = function(self, source, callChannel)
			local plyVoice = voiceData[source]
			local callChannel = tonumber(callChannel)
            if not plyVoice or not callChannel then return end

			if callChannel ~= 0 and plyVoice.Call == 0 then
				VOIP.Phone:AddToCall(source, callChannel)
			elseif callChannel == 0 and plyVoice.Call > 0 then
				VOIP.Phone:RemoveFromCall(source, plyVoice.Call)
			elseif plyVoice.Call > 0 then
				VOIP.Phone:RemoveFromCall(source, plyVoice.Call)
				VOIP.Phone:AddToCall(source, callChannel)
			end
            TriggerClientEvent('VOIP:Phone:Client:SetPlayerCall', source, callChannel)
		end,
		SetTalking = function(self, source, talking)
			local plyVoice = voiceData[source]
            if not plyVoice then return end
			local callData = callData[plyVoice.Call]
			if callData then
				for player, _ in pairs(callData) do
					if player ~= source then
						TriggerClientEvent('VOIP:Phone:Client:SetPlayerTalkState', player, source, talking)
					end
				end
			end
		end,
	}
}

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'VOIP' then
        exports['mythic-base']:ExtendComponent(component, _fuckingVOIPPhone)
    end
end)

RegisterNetEvent('VOIP:Phone:Server:SetCall', function(callChannel)
    VOIP.Phone:SetCall(source, callChannel)
end)

RegisterNetEvent('VOIP:Phone:Server:SetTalking', function(talking)
    VOIP.Phone:SetTalking(source, talking)
end)