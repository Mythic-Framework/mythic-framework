local satOnSeat = nil

ROULETTE_SITTING_SCENE = nil

_rouletteCam = nil
_rouletteCamMode = 1

local aimingAtBet = -1
local lastAimedBet = -1

function RoulettePopulateTableData(tableId)
    _rouletteTableData[tableId].numbersData = {}
    _rouletteTableData[tableId].betData = {}

    local tableObj = GetRouletteTableObject(tableId)

    local e = 1
    for i = 0, 11, 1 do
        for j = 0, 2, 1 do
            table.insert(_rouletteTableData[tableId].numbersData, {
                name = e + 1,
                hoverPos = GetOffsetFromEntityInWorldCoords(tableObj, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                hoverObject = "vw_prop_vw_marker_02a"
            })
            local offset = nil
            if j == 0 then
                offset = 0.155
            elseif j == 1 then
                offset = 0.171
            elseif j == 2 then
                offset = 0.192
            end

            table.insert(_rouletteTableData[tableId].betData, {
                betId = e,
                name = e + 1,
                pos = GetOffsetFromEntityInWorldCoords(tableObj, (0.081 * i) - 0.057, (0.167 * j) - 0.192, 0.9448),
                objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.081 * i - 0.057, 0.167 * j - 0.192, 0.9448),
                hoverNumbers = {e}
            })

            e = e + 1
        end
    end
    table.insert(_rouletteTableData[tableId].numbersData, {
        name = "Zero",
        hoverPos = GetOffsetFromEntityInWorldCoords(tableObj, -0.137, -0.148, 0.9448),
        hoverObject = "vw_prop_vw_marker_01a"
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "Zero",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, -0.137, -0.148, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, -0.137, -0.148, 0.9448),
        hoverNumbers = {#_rouletteTableData[tableId].numbersData}
    })

    table.insert(_rouletteTableData[tableId].numbersData, {
        name = "Double Zero",
        hoverPos = GetOffsetFromEntityInWorldCoords(tableObj, -0.133, 0.107, 0.9448),
        hoverObject = "vw_prop_vw_marker_01a"
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "Double Zero",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, -0.133, 0.107, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, -0.133, 0.107, 0.9448),
        hoverNumbers = {#_rouletteTableData[tableId].numbersData}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "RED",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.3, -0.4, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.3, -0.4, 0.9448),
        hoverNumbers = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "BLACK",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.5, -0.4, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.5, -0.4, 0.9448),
        hoverNumbers = {0, 2, 4, 6, 8, 9, 11, 13, 15, 17, 20, 22, 24, 26, 27, 29, 31, 33, 35}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "EVEN",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.15, -0.4, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.15, -0.4, 0.9448),
        hoverNumbers = {2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "ODD",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.65, -0.4, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.65, -0.4, 0.9448),
        hoverNumbers = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35}
    })

    table.insert(_rouletteTableData[tableId].betData,{
        betId = #_rouletteTableData[tableId].betData,
        name = "1to18",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, -0.02, -0.4, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, -0.02, -0.4, 0.9448),
        hoverNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "19to36",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.78, -0.4, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.78, -0.4, 0.9448),
        hoverNumbers = {19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "1st 12",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.05, -0.31, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.05, -0.3, 0.9448),
        hoverNumbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "2nd 12",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.4, -0.31, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.4, -0.3, 0.9448),
        hoverNumbers = {13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "3rd 12",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.75, -0.31, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.75, -0.3, 0.9448),
        hoverNumbers = {25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "2to1",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.91, -0.15, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.91, -0.15, 0.9448),
        hoverNumbers = {1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "2to1",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.91, 0.0, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.91, 0.0, 0.9448),
        hoverNumbers = {2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35}
    })

    table.insert(_rouletteTableData[tableId].betData, {
        betId = #_rouletteTableData[tableId].betData,
        name = "2to1",
        pos = GetOffsetFromEntityInWorldCoords(tableObj, 0.91, 0.15, 0.9448),
        objectPos = GetOffsetFromEntityInWorldCoords(tableObj, 0.91, 0.15, 0.9448),
        hoverNumbers = {3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36}
    })

    for i = 0, 11 do
        table.insert(_rouletteTableData[tableId].betData, {
            betId = #_rouletteTableData[tableId].betData,
            name = "Row " .. i + 1,
            pos = GetOffsetFromEntityInWorldCoords(tableObj, (0.081 * i) - 0.057, -0.27, 0.9448),
            objectPos = GetOffsetFromEntityInWorldCoords(tableObj, (0.081 * i) - 0.057, -0.27, 0.9448),
            hoverNumbers = {(3 * i) + 1, (3 * i) + 2, (3 * i) + 3}
        })
    end
end

function RouletteEnableCamera(tableId, state)
    local tableData = _rouletteTableData[tableId]

    if state then
        RouletteSpeakPed(tableId, "MINIGAME_DEALER_GREET")

        local rot = vector3(270.0, -90.0, tableData.heading + 270.0)
        _rouletteCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", tableData.coords.x, tableData.coords.y, tableData.coords.z + 2.0, rot.x, rot.y, rot.z, 80.0, true, 2)
        SetCamActive(_rouletteCam, true)
        RenderScriptCams(true, 900, 900, true, false)

        --RouletteBetRenderState(tableId, true)
    else
        if DoesCamExist(_rouletteCam) then
            DestroyCam(_rouletteCam, false)
        end

        RenderScriptCams(false, 900, 900, true, false)

        RouletteSpeakPed(tableId, "MINIGAME_DEALER_LEAVE_NEUTRAL_GAME")


    end
end

_rouletteRenderBets = false

function RouletteBetRenderState(tableId, state)
    _rouletteRenderBets = state

    if _rouletteRenderBets then
        CreateThread(function()
            while _rouletteRenderBets do
                if aimingAtBet ~= -1 and lastAimedBet ~= aimingAtBet then
                    lastAimedBet = aimingAtBet
                    local bettingData = _rouletteTableData[tableId].betData[aimingAtBet]
                    if bettingData ~= nil then
                        RouletteHoverNumbers(tableId, bettingData.hoverNumbers)
                    else
                        RouletteHoverNumbers(tableId, {})
                    end
                end

                if aimingAtBet == -1 and lastAimedBet ~= -1 then
                    lastAimedBet = -1
                    RouletteHoverNumbers(tableId, {})
                end

                Wait(5)
            end
        end)

        CreateThread(function()
            while _rouletteRenderBets do
                ShowCursorThisFrame()

                local cx, cy = GetNuiCursorPosition()
                local rx, ry = GetActiveScreenResolution()

                local n = 40 -- this is for the cursor point, how much to tolerate in range, increasing it you will find it easier to click on the bets.

                local foundBet = false

                for i = 1, #_rouletteTableData[tableId].betData, 1 do
                    local bettingData = _rouletteTableData[tableId].betData[i]
                    local onScreen, screenX, screenY = World3dToScreen2d(bettingData.pos.x, bettingData.pos.y, bettingData.pos.z)
                    local l = math.sqrt(math.pow(screenX * rx - cx, 2) + math.pow(screenY * ry - cy, 2))
                    if l < n then
                        aimingAtBet = i
                        foundBet = true

                        if IsControlJustReleased(0, 24) then
                            PlaySoundFrontend(-1, "DLC_VW_BET_DOWN", "dlc_vw_table_games_frontend_sounds", true)
                            RoulettePlaceChips(aimingAtBet)
                        end
                    end
                end

                if not foundBet then
                    aimingAtBet = -1
                end
                Wait(0)
            end
        end)
    end
end

function RouletteCreateBetObjects(tableId, bets)
    for k, v in ipairs(_rouletteTableData[tableId].betObjects) do
        if DoesEntityExist(v.obj) then
            DeleteObject(v.obj)
        end
    end

    _rouletteTableData[tableId].betObjects = {}

    local existBetId = {}

    for i = 1, #bets, 1 do
        local t = _rouletteTableData[tableId].betData[bets[i].betId]

        if existBetId[bets[i].betId] == nil then
            existBetId[bets[i].betId] = 0
        else
            existBetId[bets[i].betId] = existBetId[bets[i].betId] + 1
        end

        if t ~= nil then
            local betModelObject = getRouletteBetObjectType(bets[i].Amount)

            if betModelObject ~= nil then
                loadModel(betModelObject)

                local obj = CreateObject(betModelObject, t.objectPos.x, t.objectPos.y, t.objectPos.z + (existBetId[bets[i].betId] * 0.0081), false)
                SetEntityHeading(obj, _rouletteTableData[tableId].heading)

                table.insert(_rouletteTableData[tableId].betObjects, {
                    obj = obj,
                    Amount = bets[i].Amount,
                    Source = bets[i].Source
                })
            end
        end
    end
end

function RouletteHoverNumbers(tableId, hoveredNumbers)
    for k,v in ipairs(_rouletteTableData[tableId].hoverObjects) do
        if DoesEntityExist(v) then
            DeleteObject(v)
        end
    end

    _rouletteTableData[tableId].hoverObjects = {}

    for i = 1, #hoveredNumbers, 1 do
        local t = _rouletteTableData[tableId].numbersData[hoveredNumbers[i]]
        if t ~= nil then
            RequestModel(GetHashKey(t.hoverObject))
            while not HasModelLoaded(GetHashKey(t.hoverObject)) do
                Wait(1)
            end

            local obj = CreateObject(GetHashKey(t.hoverObject), t.hoverPos, false)
            SetEntityHeading(obj, _rouletteTableData[tableId].heading)

            table.insert(_rouletteTableData[tableId].hoverObjects, obj)
        end
    end
end

function RouletteSpin(tableId, tickRate, winIndex)
    local tableData = _rouletteTableData[tableId]
    local tablePed = _rouletteDealerPeds[tableId]

    local tableObj = GetRouletteTableObject(tableId)

    if DoesEntityExist(tableObj) and DoesEntityExist(tablePed) then
        RouletteSpeakPed(tableId, "MINIGAME_DEALER_CLOSED_BETS")
        TaskPlayAnim(tablePed, "anim_casino_b@amb@casino@games@roulette@dealer", "no_more_bets", 3.0, 3.0, -1, 0, 0, true, true, true)

        Wait(1500)

        if DoesEntityExist(tableData.ballObject) then
            DeleteObject(tableData.ballObject)
        end

        TaskPlayAnim(tablePed, "anim_casino_b@amb@casino@games@roulette@dealer", "spin_wheel", 3.0, 3.0, -1, 0, 0, true, true, true)

        loadModel(`vw_prop_roulette_ball`)

        local ballOffset = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Roulette_Wheel"))

        loadAnim("anim_casino_b@amb@casino@games@roulette@table")

        Wait(3000)

        tableData.ballObject = CreateObject(`vw_prop_roulette_ball`, ballOffset, false)

        SetEntityHeading(tableData.ballObject, tableData.heading)
        SetEntityCoordsNoOffset(tableData.ballObject, ballOffset, false, false, false)
        local h = GetEntityRotation(tableData.ballObject)
        SetEntityRotation(tableData.ballObject, h.x, h.y, h.z + 90.0, 2, false)

        if DoesEntityExist(tableObj) and DoesEntityExist(tablePed) then

            PlayEntityAnim(tableData.ballObject, "intro_ball", "anim_casino_b@amb@casino@games@roulette@table", 1000.0, false, true, true, 0, 136704)
            PlayEntityAnim(tableData.ballObject, "loop_ball", "anim_casino_b@amb@casino@games@roulette@table", 1000.0, false, true, false, 0, 136704)

            PlayEntityAnim(tableObj, "intro_wheel", "anim_casino_b@amb@casino@games@roulette@table", 1000.0, false, true, true, 0, 136704)
            PlayEntityAnim(tableObj, "loop_wheel", "anim_casino_b@amb@casino@games@roulette@table", 1000.0, false, true, false, 0, 136704)

            PlayEntityAnim(tableData.ballObject, string.format("exit_%s_ball", tickRate), "anim_casino_b@amb@casino@games@roulette@table", 1000.0, false, true, false, 0, 136704)
            PlayEntityAnim(tableObj, string.format("exit_%s_wheel", tickRate), "anim_casino_b@amb@casino@games@roulette@table", 1000.0, false, true, false, 0, 136704)

            Wait(11000)

            RouletteSpeakPed(tableId, "MINIGAME_ROULETTE_BALL_" .. winIndex)

            Wait(1500)

            if DoesEntityExist(tableObj) and DoesEntityExist(tablePed) then
                TaskPlayAnim(tablePed, "anim_casino_b@amb@casino@games@roulette@dealer", "clear_chips_zone1", 3.0, 3.0, -1, 0, 0, true, true, true)
                Wait(1500)
                TaskPlayAnim(tablePed, "anim_casino_b@amb@casino@games@roulette@dealer", "clear_chips_zone2", 3.0, 3.0, -1, 0, 0, true, true, true)
                Wait(1500)
                TaskPlayAnim(tablePed, "anim_casino_b@amb@casino@games@roulette@dealer", "clear_chips_zone3", 3.0, 3.0, -1, 0, 0, true, true, true)

                Wait(2000)
                if DoesEntityExist(tableObj) and DoesEntityExist(tablePed) then
                    TaskPlayAnim(tablePed, "anim_casino_b@amb@casino@games@roulette@dealer", "idle", 3.0, 3.0, -1, 0, 0, true, true, true)
                end

                -- if DoesEntityExist(tableData.ballObject) then
                --     DeleteObject(tableData.ballObject)
                -- end
            end
        end
    end
end

function RouletteSpeakPed(tableId, speakName)
    PlayAmbientSpeech1(_rouletteDealerPeds[tableId], speakName, "SPEECH_PARAMS_FORCE_NORMAL_CLEAR", 1)
end

function RouletteChangeCameraMode(tableId)
    local tableData = _rouletteTableData[tableId]

    local tableObj = GetRouletteTableObject(tableId)

    if DoesCamExist(_rouletteCam) then
        if _rouletteCamMode == 1 then
            DoScreenFadeOut(200)
            while not IsScreenFadedOut() do
                Wait(1)
            end
            _rouletteCamMode = 2
            local camOffset = GetOffsetFromEntityInWorldCoords(tableObj, 1.45, -0.15, 2.15)
            SetCamCoord(_rouletteCam, camOffset)
            SetCamRot(_rouletteCam, -58.0, 0.0, tableData.heading + 90.0, 2)
            SetCamFov(_rouletteCam, 80.0)
            DoScreenFadeIn(200)
        elseif _rouletteCamMode == 2 then
            DoScreenFadeOut(200)
            while not IsScreenFadedOut() do
                Wait(1)
            end
            _rouletteCamMode = 3
            local camOffset = GetWorldPositionOfEntityBone(tableObj, GetEntityBoneIndexByName(tableObj, "Roulette_Wheel"))
            local rot = vector3(270.0, -90.0, tableData.heading + 270.0)
            SetCamCoord(_rouletteCam, camOffset + vector3(0.0, 0.0, 0.5))
            SetCamRot(_rouletteCam, rot, 2)
            SetCamFov(_rouletteCam, 80.0)
            DoScreenFadeIn(200)
        elseif _rouletteCamMode == 3 then
            DoScreenFadeOut(200)
            while not IsScreenFadedOut() do
                Wait(1)
            end
            _rouletteCamMode = 1
            local rot = vector3(270.0, -90.0, tableData.heading + 270.0)
            SetCamCoord(_rouletteCam, tableData.coords + vector3(0.0, 0.0, 2.0))
            SetCamRot(_rouletteCam, rot, 2)
            SetCamFov(_rouletteCam, 80.0)
            DoScreenFadeIn(200)
        end
    end
end

function RouletteSitDownAnim(chairData)
    ROULETTE_SITTING_SCENE = NetworkCreateSynchronisedScene(chairData.position, chairData.rotation, 2, 1, 0, 1065353216, 0, 1065353216)
    loadAnim("anim_casino_b@amb@casino@games@shared@player@")

    NetworkAddPedToSynchronisedScene(LocalPlayer.state.ped, ROULETTE_SITTING_SCENE, "anim_casino_b@amb@casino@games@shared@player@", "sit_enter_left", 2.0, -2.0, 13, 16, 2.0, 0)
    NetworkStartSynchronisedScene(ROULETTE_SITTING_SCENE)

    Wait(4000)

    NetworkStopSynchronisedScene(ROULETTE_SITTING_SCENE)
end

function RouletteStandUpAnim(chairId)
    loadAnim("anim_casino_b@amb@casino@games@shared@player@")

    local whichAnim = nil
    if chairId == 1 then
        whichAnim = "sit_exit_left"
    elseif chairId == 2 then
        whichAnim = "sit_exit_right"
    elseif chairId == 3 then
        whichAnim = ({"sit_exit_left", "sit_exit_right"})[math.random(1, 2)]
    elseif chairId == 4 then
        whichAnim = "sit_exit_left"
    end

    _rouletteForceIdle = false

    TaskPlayAnim(LocalPlayer.state.ped, "anim_casino_b@amb@casino@games@shared@player@", whichAnim, 1.0, 1.0, 2500, 0)
end

local fuckface = {
    [100] = `vw_prop_chip_100dollar_x1`,
    [500] = `vw_prop_chip_500dollar_x1`,
    [1000] = `vw_prop_chip_1kdollar_x1`,
    [5000] = `vw_prop_chip_5kdollar_x1`,
    [10000] = `vw_prop_chip_10kdollar_x1`
}

function getRouletteBetObjectType(betAmount)
    return fuckface[betAmount]
end

function DoRouletteBetAnimation()
    _rouletteForceIdle = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@blackjack@player", getAnimNameFromBet(100))

    SetTimeout(duration, function()
        _rouletteForceIdle = true
    end)
end 

function DoRouletteLossAnimation()
    _rouletteForceIdle = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@shared@player@", "reaction_bad_var_01")
    SetTimeout(duration * 0.9, function()
        _rouletteForceIdle = true
    end)
end 

function DoRoulettePushAnimation()
    _rouletteForceIdle = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@shared@player@", "reaction_impartial_var_01")
    SetTimeout(duration * 0.9, function()
        _rouletteForceIdle = true
    end)
end 

function DoRouletteWinAnimation()
    _rouletteForceIdle = false
    local duration = doStupidFuckingAnimation("anim_casino_b@amb@casino@games@shared@player@", "reaction_good_var_01")
    SetTimeout(duration * 0.9, function()
        _rouletteForceIdle = true
    end)
end 

function GetRouletteTableObject(tableId)
    local tData = _rouletteTables[tableId]
    if tData then
        local tableObj = GetClosestObjectOfType(tData.table.coords.x, tData.table.coords.y, tData.table.coords.z, 1.0, tData.table.prop, 0, 0, 0)
        while tableObj == 0 do
            Wait(50)
            table = GetClosestObjectOfType(tData.table.coords.x, tData.table.coords.y, tData.table.coords.z, 1.0, tData.table.prop, 0, 0, 0)
        end

        return tableObj
    end
end