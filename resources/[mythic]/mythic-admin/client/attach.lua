local lastSpectateLocation
local isSpectateEnabled = false
local storedTargetPed
local storedTargetPlayerId
local storedGameTag
local storedTargetData


local _isInvis = false
RegisterNetEvent('Admin:Client:Invisible', function()
    if _isInvis then
        SetEntityVisible(LocalPlayer.state.ped, true)
        Notification:Info("Invisibility: Off")
        _isInvis = false
    else
        SetEntityVisible(LocalPlayer.state.ped, false)
        Notification:Info("Invisibility: On")
        _isInvis = true
    end
end)

AddEventHandler('Characters:Client:Logout', function()
    if _isInvis then
        SetEntityVisible(LocalPlayer.state.ped, true)
        _isInvis = false
    end

    if isSpectateEnabled then
        toggleSpectate(storedTargetPed)
        preparePlayerForSpec(false)
    end
end)

local function InstructionalButton(controlButton, text)
    ScaleformMovieMethodAddParamPlayerNameString(controlButton)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function createScaleformThread()
    CreateThread(function()
        -- yay, scaleforms
        local scaleform = RequestScaleformMovie("instructional_buttons")
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(1)
        end
        PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
        PushScaleformMovieFunctionParameterInt(200)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(1)
        InstructionalButton(GetControlInstructionalButton(0, GetHashKey('+cancel_action') | 0x80000000, 1), "Exit Spectate Mode")
        PopScaleformMovieFunctionVoid()


        PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(80)
        PopScaleformMovieFunctionVoid()

        while isSpectateEnabled do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Wait(0)
        end
        SetScaleformMovieAsNoLongerNeeded()
    end)
end

local function calculateSpectatorCoords(coords)
    return vec3(coords.x, coords.y, coords.z - 15.0)
end

--- Called every 50 frames in SpectateMode to determine whether or not to recreate the GamerTag
local function createGamerTagInfo()
    if storedGameTag and IsMpGamerTagActive(storedGameTag) then
        SetMpGamerTagVisibility(storedGameTag, 4, NetworkIsPlayerTalking(storedTargetPlayerId))
        return
    end
    if not storedTargetData then return end
    local nameTag = ('%s %s (%s) [%s]'):format(storedTargetData?.First, storedTargetData?.Last, storedTargetData?.SID, storedTargetData?.Account)
    storedGameTag = CreateFakeMpGamerTag(storedTargetPed, nameTag, false, false, '', 0, 0, 0, 0)
    SetMpGamerTagVisibility(storedGameTag, 2, 1)  --set the visibility of component 2(healthArmour) to true
    SetMpGamerTagAlpha(storedGameTag, 2, 255) --set the alpha of component 2(healthArmour) to 255
    SetMpGamerTagHealthBarColor(storedGameTag, 129) --set component 2(healthArmour) color to 129(HUD_COLOUR_YOGA)

    SetMpGamerTagAlpha(targetTag, 4, 255)
    SetMpGamerTagVisibility(storedGameTag, 4, NetworkIsPlayerTalking(storedTargetPlayerId))
end

local function clearGamerTagInfo()
    if not storedGameTag then return end
    RemoveMpGamerTag(storedGameTag)
    storedGameTag = nil
end

local function preparePlayerForSpec(bool)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, bool)
    SetEntityVisible(playerPed, not bool, 0)
end

local function createSpectatorTeleportThread()
    CreateThread(function()
        while isSpectateEnabled do
            Wait(500)

            -- Check if ped still exists
            if not DoesEntityExist(storedTargetPed) then
                local _ped = GetPlayerPed(storedTargetPlayerId)
                if _ped > 0 then
                    if _ped ~= storedTargetPed then
                        storedTargetPed = _ped
                    end
                    storedTargetPed = _ped
                else
                    toggleSpectate(storedTargetPed, storedTargetPlayerId)
                    break
                end
            end

            -- Update Teleport
            local newSpectateCoords = calculateSpectatorCoords(GetEntityCoords(storedTargetPed))
            SetEntityCoords(PlayerPedId(), newSpectateCoords.x, newSpectateCoords.y, newSpectateCoords.z, 0, 0, 0, false)
        end
    end)
end

local function toggleSpectate(targetPed, targetPlayerId)
    local playerPed = PlayerPedId()

    if isSpectateEnabled then
        isSpectateEnabled = false

        if not lastSpectateLocation then
            Notification:Error('Last location previous to spectate was not stored properly')
        end

        if not storedTargetPed then
            Notification:Error("Target ped was not stored to unspectate")
        end

        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do Wait(0) end

        RequestCollisionAtCoord(lastSpectateLocation.x, lastSpectateLocation.y, lastSpectateLocation.z)
        SetEntityCoords(playerPed, lastSpectateLocation.x, lastSpectateLocation.y, lastSpectateLocation.z)
        -- The player is still frozen while we wait for collisions to load
        while not HasCollisionLoadedAroundEntity(playerPed) do
            Wait(5)
        end

        preparePlayerForSpec(false)

        NetworkSetInSpectatorMode(false, storedTargetPed)
        clearGamerTagInfo()
        DoScreenFadeIn(500)

        storedTargetPed = nil
    else
        storedTargetPed = targetPed
        storedTargetPlayerId = targetPlayerId
        local targetCoords = GetEntityCoords(targetPed)

        RequestCollisionAtCoord(targetCoords.x, targetCoords.y, targetCoords.z)
        while not HasCollisionLoadedAroundEntity(targetPed) do
            Wait(5)
        end

        NetworkSetInSpectatorMode(true, targetPed)
        DoScreenFadeIn(500)
        isSpectateEnabled = true
        createSpectatorTeleportThread()
        createScaleformThread()
    end
end

-- Run whenever we failed to resolve a target player to spectate
local function cleanupFailedResolve()
    local playerPed = PlayerPedId()

    RequestCollisionAtCoord(lastSpectateLocation.x, lastSpectateLocation.y, lastSpectateLocation.z)
    SetEntityCoords(playerPed, lastSpectateLocation.x, lastSpectateLocation.y, lastSpectateLocation.z)
    -- The player is still frozen while we wait for collisions to load
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Wait(5)
    end
    preparePlayerForSpec(false)

    DoScreenFadeIn(500)

    Notification:Error("Failed to Spectate")
end

RegisterNetEvent('Admin:Client:Attach', function(tSource, tCoord, tData)
    if tSource and tCoord then
        CloseMenu()
        lastSpectateLocation = GetEntityCoords(LocalPlayer.state.ped)

        local targetPlayerId = GetPlayerFromServerId(tSource)
        if targetPlayerId == PlayerId() then
            return
        end

        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do Wait(0) end

        local tpCoords = calculateSpectatorCoords(tCoord)
        SetEntityCoords(LocalPlayer.state.ped, tpCoords.x, tpCoords.y, tpCoords.z, 0, 0, 0, false)
        preparePlayerForSpec(true)

        --- We need to wait to make sure that the player is actually available once we teleport
        --- this can take some time so we do this. Automatically breaks if a player isn't resolved
        --- within 5 seconds.
        local resolvePlayerAttempts = 0
        local resolvePlayerFailed

        repeat
            if resolvePlayerAttempts > 100 then
                resolvePlayerFailed = true
                break;
            end
            Wait(50)
            targetPlayerId = GetPlayerFromServerId(tSource)
            resolvePlayerAttempts = resolvePlayerAttempts + 1
        until (GetPlayerPed(targetPlayerId) > 0) and targetPlayerId ~= -1

        if resolvePlayerFailed then
            return cleanupFailedResolve()
        end

        storedTargetData = tData

        toggleSpectate(GetPlayerPed(targetPlayerId), targetPlayerId)

        CreateThread(function()
            while isSpectateEnabled do
                createGamerTagInfo()
                Wait(50)
            end
            clearGamerTagInfo()
        end)
    else
        if isSpectateEnabled then
            toggleSpectate(storedTargetPed)
            preparePlayerForSpec(false)
        end
    end
end)

AddEventHandler("Keybinds:Client:KeyDown:cancel_action", function()
	if isSpectateEnabled then
        toggleSpectate(storedTargetPed)
        preparePlayerForSpec(false)
    end
end)