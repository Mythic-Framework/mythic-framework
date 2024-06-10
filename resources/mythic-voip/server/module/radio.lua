_fuckingVOIPRadio = {
	Radio = {
		AddToChannel = function(self, source, radioChannel)
			if not voiceData[source] then return end
			Logger:Trace('VOIP', ('Adding %s to Radio Channel %s'):format(source, radioChannel))
			radioData[radioChannel] = radioData[radioChannel] or {}
			for player, _ in pairs(radioData[radioChannel]) do
				TriggerClientEvent('VOIP:Radio:Client:AddPlayerToRadio', player, source)
			end
	
			voiceData[source].Radio = radioChannel
			radioData[radioChannel][source] = false

			local sendingCoords = {}
			local sendingInVeh = {}
			for k, v in pairs(radioData[radioChannel]) do
				if v then
					local ped = GetPlayerPed(k)
					local coords = GetEntityCoords(ped)
					local tpCoords = Player(k)?.state?.tpLocation
					if tpCoords then
						coords = vector3(tpCoords.x, tpCoords.y, tpCoords.z)
					end

					sendingCoords[k] = coords
					sendingInVeh[k] = GetVehiclePedIsIn(ped, false)
				end
			end

			TriggerClientEvent('VOIP:Radio:Client:SyncRadioData', source, radioData[radioChannel], sendingCoords, sendingInVeh)
		end,
		RemoveFromChannel = function(self, source, radioChannel)
			Logger:Trace('VOIP', ('Removing %s from Radio Channel %s'):format(source, radioChannel))
	
			radioData[radioChannel] = radioData[radioChannel] or {}
			for player, _ in pairs(radioData[radioChannel]) do
				TriggerClientEvent('VOIP:Radio:Client:RemovePlayerFromRadio', player, source)
			end
	
			radioData[radioChannel][source] = nil
	
			if voiceData[source] then
				voiceData[source].Radio = 0
			end
		end,
		SetChannel = function(self, source, radioChannel)
			local radioChannel = tonumber(radioChannel)
			local plyVoice = voiceData[source]
			if not plyVoice or not radioChannel then return end
	
			if radioChannel ~= 0 and plyVoice.Radio == 0 then
				VOIP.Radio:AddToChannel(source, radioChannel)
			elseif radioChannel == 0 and plyVoice.Radio > 0 then
				VOIP.Radio:RemoveFromChannel(source, plyVoice.Radio)
			elseif plyVoice.Radio > 0 then
				VOIP.Radio:RemoveFromChannel(source, plyVoice.Radio)
				VOIP.Radio:AddToChannel(source, radioChannel)
			end
			TriggerClientEvent('VOIP:Radio:Client:SetPlayerRadio', source, radioChannel)
		end,
		SetTalking = function(self, source, talking)
			local plyVoice = voiceData[source]
			if not plyVoice then return end
	
			local radioChannelData = radioData[plyVoice.Radio]
			if not radioChannelData then return end

			local ped = GetPlayerPed(source)
			local pedCoords = GetEntityCoords(ped)
			local pedVeh = GetVehiclePedIsIn(ped, false)

			local tpCoords = Player(source)?.state?.tpLocation
			if tpCoords then
				pedCoords = vector3(tpCoords.x, tpCoords.y, tpCoords.z)
			end
		
			for player, _ in pairs(radioChannelData) do
				if player ~= source then
					TriggerClientEvent('VOIP:Radio:Client:SetPlayerTalkState', player, source, talking, pedCoords, pedVeh)
				end
			end
		end,
	}
}

AddEventHandler('Proxy:Shared:ExtendReady', function(component)
    if component == 'VOIP' then
        exports['mythic-base']:ExtendComponent(component, _fuckingVOIPRadio)
    end
end)

RegisterServerEvent('VOIP:Radio:Server:SetChannel', function(targetChannel)
	VOIP.Radio:SetChannel(source, targetChannel)
end)

RegisterServerEvent('VOIP:Radio:Server:SetTalking', function(isTalking)
	VOIP.Radio:SetTalking(source, isTalking)
end)