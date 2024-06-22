local videoWallRenderTarget = nil
local showBigWin = false


-- CASINO_SNWFLK_PL XMAS
-- CASINO_HLW_PL SKULL

function StartCasinoWallsThread()
    RequestStreamedTextureDict("Prop_Screen_Vinewood")

    while not HasStreamedTextureDictLoaded("Prop_Screen_Vinewood") do
        Wait(100)
    end

    RegisterNamedRendertarget("casinoscreen_01")

    LinkNamedRendertarget(`vw_vwint01_video_overlay`)

    videoWallRenderTarget = GetNamedRendertargetRenderId("casinoscreen_01")

    CreateThread(function()
        local lastUpdatedTvChannel = 0

        while _insideCasino do
            Wait(0)

            if videoWallRenderTarget then
                local currentTime = GetGameTimer()

                if showBigWin then
                    setVideoWallTvChannelWin()

                    lastUpdatedTvChannel = GetGameTimer() - 33666
                    showBigWin = false
                else
                    if (currentTime - lastUpdatedTvChannel) >= 42666 then
                        setVideoWallTvChannel()

                        lastUpdatedTvChannel = currentTime
                    end
                end

                SetTextRenderId(videoWallRenderTarget)
                SetScriptGfxDrawOrder(4)
                SetScriptGfxDrawBehindPausemenu(true)
                DrawInteractiveSprite("Prop_Screen_Vinewood", "BG_Wall_Colour_4x4", 0.25, 0.5, 0.5, 1.0, 0.0, 255, 255, 255, 255)
                DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            end
        end

        ReleaseNamedRendertarget("casinoscreen_01")

        videoWallRenderTarget = nil
        showBigWin = false
    end)
end

function setVideoWallTvChannel()
    SetTvChannelPlaylist(0, "CASINO_DIA_PL", true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(0)
end

function setVideoWallTvChannelWin()
    SetTvChannelPlaylist(0, "CASINO_WIN_PL", true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(-1)
    SetTvChannel(0)
end

AddEventHandler("Casino:Client:Enter", function()
    StartCasinoWallsThread()
end)

RegisterNetEvent("Casino:Client:BigWin", function()
    if _insideCasino then
        showBigWin = true
    end
end)