function StartUsingMicrophone(withRange)
    if PLAYER_CONNECTED and (not CALL_CHANNEL or CALL_CHANNEL <= 0) and not RADIO_TALKING and not USING_MEGAPHONE then
        CreateThread(function()
            Logger:Info('VOIP', 'Microphone On')
            USING_MICROPHONE = true

            MumbleSetAudioInputIntent(`music`)

            UpdateVOIPIndicatorStatus()
            while _characterLoaded and USING_MICROPHONE and (not CALL_CHANNEL or CALL_CHANNEL <= 0) and not LocalPlayer.state.isDead and not USING_MEGAPHONE do
                --TriggerServerEvent('VOIP:Server:Microphone:SetPlayerState', true)

                NetworkSetTalkerProximity(VOIP_CONFIG.MicrophoneRange + 0.0)
                Wait(7500)
            end

            StopUsingMicrophone()
            StopUsingMegaphone()
        end)
    end
end

function StopUsingMicrophone()
    if USING_MICROPHONE then
        Logger:Info('VOIP', 'Microphone Off')
        USING_MICROPHONE = false
        TriggerServerEvent('VOIP:Server:Microphone:SetPlayerState', false)

        MumbleSetAudioInputIntent(`speech`)

        NetworkSetTalkerProximity(CURRENT_VOICE_MODE_DATA.Range + 0.0)
        UpdateVOIPIndicatorStatus()
    end
end

-- RegisterNetEvent('VOIP:Client:Microphone:SetPlayerState', function(targetSource, state)
--     if VOIP ~= nil and LocalPlayer.state.loggedIn then
--         VOIP:ToggleVoice(targetSource, state, 'microphone')
--     end
-- end)

function CreateMicrophonePolyzones()
    Polyzone.Create:Box('microphone_rockford_records_stage', vector3(-1006.03, -254.44, 39.47), 9.4, 2.6, {
        heading = 325,
        --debugPoly=true,
        minZ = 38.47,
        maxZ = 42.07
    }, {
        VOIP_MICROPHONE = true,
        VOIP_MICROPHONE_RANGE = 40.0,
    })

    Polyzone.Create:Box('microphone_unicorn_dj', vector3(120.51, -1281.51, 29.48), 3.2, 1.8, {
        heading = 30,
        --debugPoly=true,
        minZ = 28.48,
        maxZ = 31.48
    }, {
        VOIP_MICROPHONE = true,
        --VOIP_MICROPHONE_RANGE = 40.0,
    })

    Polyzone.Create:Box('microphone_triad_stage', vector3(-840.07, -718.52, 28.28), 6.0, 4.6, {
        heading = 320,
        --debugPoly=true,
        minZ = 27.28,
        maxZ = 29.68
    }, {
        VOIP_MICROPHONE = true,
        VOIP_MICROPHONE_RANGE = 40.0,
    })

    Polyzone.Create:Box('microphone_tequila_stage', vector3(-551.23, 284.04, 82.98), 8.0, 3.0, {
        heading = 355,
        --debugPoly=true,
        minZ = 81.98,
        maxZ = 85.18
    }, {
        VOIP_MICROPHONE = true,
        VOIP_MICROPHONE_RANGE = 40.0,
    })

    Polyzone.Create:Box('microphone_rockford_records_booth1', vector3(-1001.02, -282.4, 44.8), 2, 2, {
        heading = 324,
        --debugPoly=true,
        minZ = 43.8,
        maxZ = 46.6
    }, {
        VOIP_MICROPHONE = true,
        VOIP_MICROPHONE_RANGE = 12.0,
    })

    Polyzone.Create:Box('microphone_rockford_records_booth2', vector3(-1006.51, -289.22, 44.8), 1.6, 2, {
        heading = 28,
        --debugPoly=true,
        minZ = 43.8,
        maxZ = 46.4
    }, {
        VOIP_MICROPHONE = true,
        VOIP_MICROPHONE_RANGE = 15.0,
    })

    Polyzone.Create:Box('microphone_rockford_records_booth3', vector3(-1007.51, -294.11, 44.8), 4.2, 6.4, {
        heading = 27,
        --debugPoly=true,
        minZ = 43.8,
        maxZ = 47.2
    }, {
        VOIP_MICROPHONE = true,
        VOIP_MICROPHONE_RANGE = 15.0,
    })

    Polyzone.Create:Box('microphone_vinewoodbowl', vector3(685.97, 576.13, 130.46), 18.0, 18.2, {
        heading = 340,
        --debugPoly=true,
        minZ = 129.46,
        maxZ = 133.46
    }, {
        VOIP_MICROPHONE = true,
        VOIP_MICROPHONE_RANGE = 75.0,
    })

    Polyzone.Create:Box('microphone_triad_studio', vector3(-813.82, -719.33, 32.34), 6.6, 5.2, {
        heading = 0,
        --debugPoly=true,
        minZ = 31.34,
        maxZ = 34.74
    }, {
        VOIP_MICROPHONE = true,
        VOIP_MICROPHONE_RANGE = 15.0,
    })
end

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	if data and data.VOIP_MICROPHONE then
        StartUsingMicrophone(data.VOIP_MICROPHONE_RANGE or VOIP_CONFIG.MicrophoneRange)
    end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	if data and data.VOIP_MICROPHONE then
        StopUsingMicrophone()
    end
end)