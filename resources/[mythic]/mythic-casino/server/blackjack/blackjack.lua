_blackjack = {}
_blackjackPlayers = {}

function GetDefaultBlackjackData(tableId, seats, bet)
    return {
        Starting = false,
        Started = false,
        Timeout = false,
        Id = tableId,
        Seats = seats,
        Bet = bet,
        DealerCards = {},
        SeatsPlayed = {},
    }
end

function StartBlackjackGame(tableId)
    if GlobalState["CasinoOpen"] and _blackjack[tableId] and not _blackjack[tableId].Starting and not _blackjack[tableId].Started then
        for k, v in pairs(_blackjack[tableId].Seats) do
            -- Check Source Still Active
            if v and v.Source then
                _blackjack[tableId].Seats[k].Joined = false
                _blackjack[tableId].Seats[k].Cards = {}

                TriggerClientEvent("Casino:Client:BlackjackConfirmBet", v.Source, _blackjack[tableId].Bet, tableId)
            end
        end

        _blackjack[tableId].Starting = true
        _blackjack[tableId].Timeout = false
        _blackjack[tableId].DealerCards = {}
        _blackjack[tableId].SeatsPlayed = {}
        _blackjack[tableId].Status = 1

        UpdateBlackjackGameState(tableId)

        SetTimeout(16000, function()
            if not _blackjack[tableId].Started then
                _blackjack[tableId].Timeout = true
            end
        end)

        CreateThread(function()
            while (not _blackjack[tableId].Timeout) and not GetBlackjackTableReady(tableId) do
                Wait(250)
            end

            Wait(1500)

            local joinedPlayers = 0

            for k, v in pairs(_blackjack[tableId].Seats) do
                if v and v.Source and v.Joined then
                    table.insert(_blackjack[tableId].SeatsPlayed, v.Chair)

                    joinedPlayers += 1
                end
            end

            if joinedPlayers > 0 then
                _blackjack[tableId].Started = true
                UpdateBlackjackGameState(tableId)

                for cardIndex = 1, 2 do
                    for k, v in pairs(_blackjack[tableId].Seats) do
                        if v and v.Source and v.Cards and v.Joined then
                            local randomCard = math.random(1, 52)

                            table.insert(v.Cards, randomCard)

                            TriggerClientEvent(
                                "Casino:Client:BlackjackDealInitialCard",
                                -1,
                                tableId,
                                v.Chair,
                                v.Cards,
                                cardIndex,
                                GetCurrentBlackjackHand(tableId, k)
                            )

                            Wait(2800)
                            UpdateBlackjackGameState(tableId)
                        end
                    end
    
                    if cardIndex == 1 then
                        local randomCard = math.random(1, 52)
    
                        table.insert(_blackjack[tableId].DealerCards, randomCard)
    
                        TriggerClientEvent(
                            "Casino:Client:BlackjackDealInitialCard",
                            -1,
                            tableId,
                            -1 - tableId,
                            _blackjack[tableId].DealerCards,
                            cardIndex,
                            GetCurrentBlackjackHand(tableId, "dealer")
                        )
                    end
    
                    Wait(2500)
                    UpdateBlackjackGameState(tableId)
                end

                _blackjack[tableId].Status = 2
                UpdateBlackjackGameState(tableId)
    
                for k, v in pairs(_blackjack[tableId].Seats) do
                    if v and v.Source and v.Cards and v.Joined then
                        local nextCardCount = 2
                        local currentHand = GetCurrentBlackjackHand(tableId, k)
    
                        if currentHand < 21 then
                            TriggerClientEvent("Casino:Client:BlackjackStandOrHit", -1, tableId, k)
    
                            while nextCardCount >= 1 do
                                local state = "stand"
                                local response = GetHitStandResponse(v.Source, GetCurrentBlackjackHand(tableId, k), nextCardCount == 2, v.Bet)
    
                                if response and response.success and response.state then
                                    state = response.state
                                end
    
                                if state == "hit" then
                                    nextCardCount += 1
                                    local randomCard = math.random(1, 52)
    
                                    table.insert(v.Cards, randomCard)
    
                                    TriggerClientEvent(
                                        "Casino:Client:BlackjackDealSingleCard",
                                        -1,
                                        tableId,
                                        v.Chair,
                                        randomCard,
                                        nextCardCount,
                                        GetCurrentBlackjackHand(tableId, k)
                                    )
    
                                    Wait(2000)
    
                                    UpdateBlackjackGameState(tableId)
                                    local currentHand = GetCurrentBlackjackHand(tableId, k)
    
                                    if currentHand > 21 then
                                        -- Going Bust
                                        TriggerClientEvent("Casino:Client:BlackjackBust", -1, tableId, k)
    
                                        nextCardCount = 0
                                        v.State = "bust"

                                        UpdateCharacterCasinoStats(v.Source, "blackjack", false, v.Bet)
                                        GiveCasinoFuckingMoney(v.Source, "Blackjack", v.Bet)
                                    elseif currentHand < 21 then
                                        -- Ask Again
                                        TriggerClientEvent("Casino:Client:BlackjackStandOrHit", -1, tableId, k)
                                    else -- Is 21
                                        nextCardCount = 0
                                        v.State = "stand"
                                    end
                                elseif state == "stand" then
                                    nextCardCount = 0
                                    v.State = "stand"
                                elseif state == "double" and nextCardCount == 2 then
                                    if Casino.Chips:Modify(v.Source, -v.Bet) then
                                        SendCasinoSpentChipsPhoneNotification(v.Source, v.Bet)
                                        v.Bet = v.Bet * 2

                                        local randomCard = math.random(1, 52)

                                        TriggerClientEvent("Casino:Client:BlackjackSyncChipsDoubleDown", -1, v.Bet, v.Chair)

                                        table.insert(v.Cards, randomCard)

                                        TriggerClientEvent(
                                            "Casino:Client:BlackjackDealSingleCard",
                                            -1,
                                            tableId,
                                            v.Chair,
                                            randomCard,
                                            nextCardCount + 1,
                                            GetCurrentBlackjackHand(tableId, k)
                                        )

                                        Wait(2000)

                                        UpdateBlackjackGameState(tableId)
                                        local currentHand = GetCurrentBlackjackHand(tableId, k)
    
                                        if currentHand > 21 then
                                            -- Going Bust
                                            TriggerClientEvent("Casino:Client:BlackjackBust", -1, tableId, k)
        
                                            nextCardCount = 0
                                            v.State = "bust"
    
                                            UpdateCharacterCasinoStats(v.Source, "blackjack", false, v.Bet)

                                            GiveCasinoFuckingMoney(v.Source, "Blackjack", v.Bet)
                                        end

                                        nextCardCount = 0
                                        v.State = "stand"
                                    end
                                end
                            end
                        else
                            nextCardCount = 0
                            v.State = "stand"
                        end

                        TriggerClientEvent("Casino:Client:BlackjackFinishStandOrHitPhase", -1, tableId, k)
                    end
                end

                local randomCard = math.random(1, 52)
                table.insert(_blackjack[tableId].DealerCards, randomCard)

                TriggerClientEvent(
                    "Casino:Client:BlackjackDealInitialCard",
                    -1,
                    tableId,
                    -1 - tableId,
                    _blackjack[tableId].DealerCards,
                    2,
                    GetCurrentBlackjackHand(tableId, "dealer")
                )

                Wait(2800)

                local dealerHand = GetCurrentBlackjackHand(tableId, "dealer")
                TriggerClientEvent("Casino:Client:BlackjackFlipDealerCard", -1, tableId, dealerHand)

                Wait(2800)
                _blackjack[tableId].Status = 3
                UpdateBlackjackGameState(tableId)

                local allBusted = true
                local highestPlayerHand = 0

                for k,v in pairs(_blackjack[tableId].Seats) do
                    if v and v.Source and v.Joined then
                        if v.State == "stand" then
                            allBusted = false

                            local pHand = GetCurrentBlackjackHand(tableId, k)
                            if pHand > highestPlayerHand and pHand <= 21 then
                                highestPlayerHand = pHand
                            end
                        end
                    end
                end

                if not allBusted then
                    if dealerHand < 17 then
                        local nextCardCount = 3

                        while dealerHand < 17 do
                            local randomCard = math.random(1, 52)
                            table.insert(_blackjack[tableId].DealerCards, randomCard)

                            TriggerClientEvent(
                                "Casino:Client:BlackjackDealSingleDealerCard",
                                -1,
                                tableId,
                                randomCard,
                                nextCardCount,
                                GetCurrentBlackjackHand(tableId, "dealer")
                            )

                            Wait(2800)

                            UpdateBlackjackGameState(tableId)

                            nextCardCount += 1
                            dealerHand = GetCurrentBlackjackHand(tableId, "dealer")
                        end
                    end
                end

                Wait(2500)

                local sentDealerBust = false
                local sentEveryoneBust = true
                local cleaningChairs = {}

                for k,v in pairs(_blackjack[tableId].Seats) do
                    if v and v.Source and v.Joined then
                        if v.State == "stand" then
                            local pHand = GetCurrentBlackjackHand(tableId, k)
                            local isWin = false
                            local isPush = false
                            local isDealerBust = false

                            if pHand <= 21 then

                                if dealerHand > 21 then
                                    isWin = true
                                    -- Win, Dealer Bust
                                    if not sentDealerBust then
                                        sentDealerBust = true
                                        isDealerBust = true
                                    end

                                    UpdateCharacterCasinoStats(v.Source, "blackjack", true, v.Bet)
                                elseif pHand > dealerHand and pHand <= 21 then
                                    isWin = true
                                    -- Win

                                    UpdateCharacterCasinoStats(v.Source, "blackjack", true, v.Bet)
                                elseif pHand == dealerHand then
                                    -- Push
                                    isWin = true
                                    isPush = true
                                else
                                    UpdateCharacterCasinoStats(v.Source, "blackjack", false, v.Bet)
                                    GiveCasinoFuckingMoney(v.Source, "Blackjack", v.Bet)
                                end
                            end

                            if isWin then
                                sentEveryoneBust = false

                                local wonAmount = v.Bet
                                if not isPush then
                                    wonAmount = v.Bet * 2
                                end

                                if Casino.Chips:Modify(v.Source, wonAmount) then
                                    SendCasinoWonChipsPhoneNotification(v.Source, wonAmount)
                                end

                                if isPush then
                                    TriggerClientEvent("Casino:Client:BlackjackDeclarePush", v.Source, tableId, k)
                                else
                                    TriggerClientEvent("Casino:Client:BlackjackDeclareWin", v.Source, tableId, k, isDealerBust)
                                end
                            else
                                TriggerClientEvent("Casino:Client:BlackjackDeclareLoss", v.Source, tableId, k)
                            end
                        end
                    end
                end


                _blackjack[tableId].Status = 4
                UpdateBlackjackGameState(tableId)

                TriggerClientEvent("Casino:Client:BlackjackGameFinished", -1, tableId, _blackjack[tableId].SeatsPlayed, sentDealerBust, sentEveryoneBust)
                Wait(4000 + (2500 * #_blackjack[tableId].SeatsPlayed))

                _blackjack[tableId].Starting = false
                _blackjack[tableId].Started = false

                local stillHasActivePlayers = false
                for k,v in pairs(_blackjack[tableId].Seats) do
                    if v and v.Source then
                        v.Joined = false

                        stillHasActivePlayers = true
                    end
                end

                if stillHasActivePlayers then
                    StartBlackjackGame(tableId)
                end
            else
                _blackjack[tableId].Starting = false
            end
        end)

        --GlobalState[string.format("Casino:Blackjack:%s", tableId)] = _blackjack[tableId]
        return true
    else
        return false
    end
end

function UpdateBlackjackGameState(tableId)
    if _blackjack[tableId] then
        GlobalState[string.format("Casino:Blackjack:%s", tableId)] = _blackjack[tableId]
    end
end

local usedVariations = {}

function GenerateRandomBJDealerVariation()
    local var = math.random(0, 13)

    while var == 7 or usedVariations[var] do
        var = math.random(0, 13)
        Wait(10)
    end

    usedVariations[var] = true
    return var
end

AddEventHandler("Casino:Server:Startup", function()
    for k, v in pairs(_blackjackTables) do
        local seats = {}
        for i = 0, 3 do
           seats[i] = false
        end

        local data = GetDefaultBlackjackData(k, seats, v.bet)

        _blackjack[k] = data
        GlobalState[string.format("Casino:Blackjack:%s", k)] = data

        v.dealerVariation = GenerateRandomBJDealerVariation()
    end

    GlobalState["Casino:BlackjackConfig"] = _blackjackTables

    Middleware:Add("Characters:Logout", function(source)
        HandleCharacterDisconnect(source)
	end)

	Middleware:Add("playerDropped", function(source)
        HandleCharacterDisconnect(source)
	end)

    Callbacks:RegisterServerCallback("Casino:JoinBlackjack", function(source, chairId, cb)
        local char = Fetch:Source(source):GetData("Character")
        if not char or _blackjackPlayers[source] then
            return cb(false)
        end

        local tableId, localChairId = GetBlackjackTableId(chairId)

        if _blackjack[tableId] and not _blackjack[tableId].Seats[localChairId] then

            if _blackjackTables[tableId].isVIP and not Inventory.Items:Has(char:GetData("SID"), 1, "diamond_vip", 1) then
                return cb(false, "vip")
            end

            _blackjack[tableId].Seats[localChairId] = {
                State = false,
                Chair = chairId,
                Source = source,
                First = char:GetData("First"),
                Last = char:GetData("Last"),
                SID = char:GetData("SID"),
                Joined = false,
                Cards = {}
            }

            _blackjackPlayers[source] = {
                Chair = chairId,
                Table = tableId,
                LocalChair = localChairId,
            }

            GlobalState[string.format("Casino:Blackjack:%s", tableId)] = _blackjack[tableId]
            cb(true, tableId, localChairId)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Casino:LeaveBlackjack", function(source, data, cb)
        --local char = Fetch:Source(source):GetData("Character")
        local blackjackPlayer = _blackjackPlayers[source]
        if not blackjackPlayer then
            return cb(false)
        end

        if _blackjack[blackjackPlayer.Table] and _blackjack[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair] then
            _blackjack[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair] = false
            _blackjackPlayers[source] = nil

            GlobalState[string.format("Casino:Blackjack:%s", blackjackPlayer.Table)] = _blackjack[blackjackPlayer.Table]
            cb(true)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Casino:StartBlackjack", function(source, data, cb)
        local blackjackPlayer = _blackjackPlayers[source]
        if not blackjackPlayer then
            return cb(false)
        end

        if _blackjack[blackjackPlayer.Table] and _blackjack[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair] then
            local success = StartBlackjackGame(blackjackPlayer.Table)

            cb(success)
        else
            cb(false)
        end
    end)

    -- Bet Confirmation
    Callbacks:RegisterServerCallback("Casino:BetBlackjack", function(source, data, cb)
        --local char = Fetch:Source(source):GetData("Character")
        local blackjackPlayer = _blackjackPlayers[source]
        if not blackjackPlayer then
            return cb(false)
        end

        if not data or type(data) ~= "number" or data < 100 then
            return cb(false)
        end

        if _blackjack[blackjackPlayer.Table] and _blackjack[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair] then
            if Casino.Chips:Modify(source, -data) then
                SendCasinoSpentChipsPhoneNotification(source, data)

                _blackjack[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair].Bet = data
                _blackjack[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair].Joined = true
                TriggerClientEvent("Casino:Client:BlackjackSyncChips", -1, data, blackjackPlayer.Chair)

                cb(true, _blackjack[blackjackPlayer.Table])
            else
                Execute:Client(source, "Notification", "Error", "Not Enough Chips")
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

function HandleCharacterDisconnect(source)
    local blackjackPlayer = _blackjackPlayers[source]
    if blackjackPlayer then
        if _blackjack[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair] then
            _blackjack[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair] = false
        end
        _blackjackPlayers[source] = nil
    end
end

function GetHitStandResponse(src, currentHand, canDouble, currentBet)
    local p = promise.new()
    Callbacks:ClientCallback(src, "Casino:Client:RequestHitStand", { currentHand = currentHand, canDouble = canDouble, currentBet = currentBet }, function(success, state)

        if p then
            p:resolve({ success = success, state = state })
        end
    end)

    SetTimeout(20000, function()
        if p then
            p:resolve({ success = false })
        end
    end)

    local res = Citizen.Await(p)
    p = nil
    return res
end


function GetCurrentBlackjackHand(tableId, chairId)
    local cards = nil

    if chairId == "dealer" then
        cards = _blackjack[tableId].DealerCards
    else
        cards = _blackjack[tableId].Seats[chairId].Cards
    end

    if cards then
        local hand = 0
        local numberOfAces = 0

        for k,v in pairs(cards) do
            local nextCard = getCardNumberFromCardId(v)
            if nextCard == 11 then
                numberOfAces = numberOfAces + 1
            else
                hand = hand + nextCard
            end
        end

        for i = 1, numberOfAces do 
            if i == 1 then
                if hand + 11 > 21 then
                    nextCard = 1
                else
                    nextCard = 11
                end
            else
                nextCard = 1
            end
            hand = hand + nextCard
        end
        return hand
    end
end

function GetBlackjackTableReady(tableId)
    local readyCount = 0
    for k,v in pairs(_blackjack[tableId].Seats) do
        if v and v.Source then
            if v.Joined then
                readyCount += 1
            end
        else
            readyCount += 1
        end
    end

    return readyCount >= 4
end

function GetBlackjackTableId(chairId)
    local tableId = -1
    for i = 0, chairId, 4 do
        tableId += 1
    end

    return tableId, (chairId % 4)
end

function getCardNumberFromCardId(cardId)
    if cardId == 1 then
        return 11
    elseif cardId == 2 then
        return 2
    elseif cardId == 3 then
        return 3
    elseif cardId == 4 then
        return 4
    elseif cardId == 5 then
        return 5
    elseif cardId == 6 then
        return 6
    elseif cardId == 7 then
        return 7
    elseif cardId == 8 then
        return 8
    elseif cardId == 9 then
        return 9
    elseif cardId == 10 then
        return 10
    elseif cardId == 11 then
        return 10
    elseif cardId == 12 then
        return 10
    elseif cardId == 13 then
        return 10
    elseif cardId == 14 then
        return 11
    elseif cardId == 15 then
        return 2
    elseif cardId == 16 then
        return 3
    elseif cardId == 17 then
        return 4        
    elseif cardId == 18 then
        return 5
    elseif cardId == 19 then
        return 6
    elseif cardId == 20  then
        return 7
    elseif cardId == 21 then
        return 8
    elseif cardId == 22 then
        return 9
    elseif cardId == 23 then
        return 10
    elseif cardId == 24 then
        return 10
    elseif cardId == 25 then
        return 10
    elseif cardId == 26 then
        return 10
    elseif cardId == 27 then
        return 11
    elseif cardId == 28 then
        return 2
    elseif cardId == 29 then
        return 3
    elseif cardId == 30 then
        return 4
    elseif cardId == 31 then
        return 5
    elseif cardId == 32 then
        return 6
    elseif cardId == 33 then
        return 7
    elseif cardId == 34 then
        return 8
    elseif cardId == 35 then
        return 9
    elseif cardId == 36 then
        return 10
    elseif cardId == 37 then
        return 10
    elseif cardId == 38 then
        return 10
    elseif cardId == 39 then
        return 10
    elseif cardId == 40 then
        return 11
    elseif cardId == 41 then
        return 2
    elseif cardId == 42 then
        return 3
    elseif cardId == 43 then
        return 4
    elseif cardId == 44 then
        return 5
    elseif cardId == 45 then
        return 6
    elseif cardId == 46 then
        return 7
    elseif cardId == 47 then
        return 8
    elseif cardId == 48 then
        return 9
    elseif cardId == 49 then
        return 10
    elseif cardId == 50 then
        return 10
    elseif cardId == 51 then
        return 10
    elseif cardId == 52 then
        return 10
    end
end




