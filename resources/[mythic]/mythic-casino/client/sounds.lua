function StartCasinoBackgroundAudioThread()
    CreateThread(function()
        while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
            Wait(0)
        end

        while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
            Wait(0)
        end

        while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1) do
            Wait(0)
        end

        while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1) do
            Wait(0)
        end

        while _insideCasinoAudio do
            if not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
                PlayStreamFromPosition(996.13,38.48,71.07)
            end

            if IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
                StartAudioScene("DLC_VW_Casino_General")
            end

            Wait(500)
        end

        StopCasinoBackgroundAudio()
    end)
end

AddEventHandler("Casino:Client:Enter", function()
    StartCasinoBackgroundAudioThread()
end)

function StopCasinoBackgroundAudio()
    if IsStreamPlaying() then
        StopStream()
    end

    if IsAudioSceneActive("DLC_VW_Casino_General") then
        StopAudioScene("DLC_VW_Casino_General")
    end
end