function StartUsingMegaphone()
    if PLAYER_CONNECTED and (not CALL_CHANNEL or CALL_CHANNEL <= 0) and not RADIO_TALKING and not USING_MICROPHONE then
        CreateThread(function()
            Logger:Info('VOIP', 'Megaphone On')
            USING_MEGAPHONE = true
            Animations.Emotes:Play('megaphone', false, false, true)
            UpdateVOIPIndicatorStatus()
            while _characterLoaded and USING_MEGAPHONE and (not CALL_CHANNEL or CALL_CHANNEL <= 0) and not LocalPlayer.state.isDead and not USING_MICROPHONE do
                TriggerServerEvent('VOIP:Server:Megaphone:SetPlayerState', true)

                NetworkSetTalkerProximity(VOIP_CONFIG.MegaphoneRange + 0.0)
                Wait(7500)
            end

            StopUsingMegaphone()
            StopUsingMicrophone()
        end)
    end
end

function StopUsingMegaphone()
    if USING_MEGAPHONE then
        Logger:Info('VOIP', 'Megaphone Off')
        USING_MEGAPHONE = false
        TriggerServerEvent('VOIP:Server:Megaphone:SetPlayerState', false)

        NetworkSetTalkerProximity(CURRENT_VOICE_MODE_DATA.Range + 0.0)
        Animations.Emotes:ForceCancel()
        UpdateVOIPIndicatorStatus()
    end
end

RegisterNetEvent('VOIP:Client:Megaphone:SetPlayerState', function(targetSource, state)
    if VOIP ~= nil and LocalPlayer.state.loggedIn then
        VOIP:ToggleVoice(targetSource, state, 'megaphone')
    end
end)

RegisterNetEvent('VOIP:Client:Megaphone:Use', function()
    if not USING_MEGAPHONE then
        StartUsingMegaphone()
    else
        StopUsingMegaphone()
    end
end)

RegisterNetEvent("Characters:Client:SetData", function()
	Wait(1000)
	if LocalPlayer.state.loggedIn and USING_MEGAPHONE then
		if not CheckCharacterHasMegaphone() then
            StopUsingMegaphone()
        end
	end
end)

function CheckCharacterHasMegaphone()
	local character = LocalPlayer.state.Character
	if character then
		local states = character:GetData('States') or {}
		for k, v in ipairs(states) do
			if v == 'MEGAPHONE' then
				return true
			end
		end
	end
	return false
end