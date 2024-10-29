_roulette = {}
_roulettePlayers = {}

function GetDefaultRouletteData(tableId, seats, isHighLimit)
    return {
        Starting = false,
        Started = false,
        Timeout = false,
        Id = tableId,
        Seats = seats,
        Bets = {},
        HighLimit = isHighLimit,
    }
end

function StartRouletteGame(tableId)
    if GlobalState["CasinoOpen"] and _roulette[tableId] and not _roulette[tableId].Starting and not _roulette[tableId].Started then
        for k, v in pairs(_roulette[tableId].Seats) do
            if v and v.Source then
                _roulette[tableId].Seats[k].TotalBet = 0
            end
        end

        TriggerClientEvent("Casino:Client:RouletteGameStarting", -1, tableId)

        _roulette[tableId].Starting = true
        _roulette[tableId].Bets = {}

        UpdateRouletteGameState(tableId)

        local randomSpinNumber = math.random(1, 38)

        local winningBetIndex = _rouletteTickToVal[randomSpinNumber]

        print(string.format("Roulette Game Table: %s Num: %s", tableId, winningBetIndex))

        SetTimeout(30000, function()
            _roulette[tableId].Started = true

            UpdateRouletteGameState(tableId)

            for k, v in pairs(_roulette[tableId].Seats) do
                if v and v.Source and v.TotalBet > 0 then
                    SendCasinoSpentChipsPhoneNotification(v.Source, v.TotalBet)
                end
            end

            if GetRouletteTableCount(tableId) > 0 then
                _roulette[tableId].WinningBet = winningBetIndex

                TriggerClientEvent("Casino:Client:RouletteGameSpinning", -1, tableId, randomSpinNumber, winningBetIndex)
                Wait(17500)

                CheckRouletteWinners(tableId, _roulette[tableId].Bets, _roulette[tableId].WinningBet)

                Wait(1000)

                TriggerClientEvent("Casino:Client:RouletteUpdateBets", -1, tableId, {})

                _roulette[tableId].Started = false
                _roulette[tableId].Starting = false
                _roulette[tableId].Bets = {}

                Wait(2000)

                if GetRouletteTableCount(tableId) > 0 then
                    StartRouletteGame(tableId)
                end
            else
                _roulette[tableId].Started = false
                _roulette[tableId].Starting = false
                _roulette[tableId].Bets = {}
            end
        end)

        --GlobalState[string.format("Casino:Blackjack:%s", tableId)] = _roulette[tableId]
        return true
    else
        return false
    end
end

function CheckRouletteWinners(tableId, bets, winningIndex)
    local totalsWon = {}
    local totalsLost = {}

    for k, v in ipairs(bets) do
        local betId = tostring(v.betId)

        if not totalsWon[v.Source] then
            totalsWon[v.Source] = 0
        end

        if not totalsLost[v.Source] then
            totalsLost[v.Source] = 0
        end

        -- All payouts are 1x higher due to player paying for the bet initially
        if (winningIndex == "0" and betId == "37") or (winningIndex == "00" and betId == "38") then
            -- 12 to 1
            totalsWon[v.Source] = math.floor(totalsWon[v.Source] + v.Amount * 13)
        elseif 
            (betId == "39" and _rouletteGroups.Red[winningIndex]) or
            (betId == "40" and _rouletteGroups.Black[winningIndex]) or
            (betId == "41" and _rouletteGroups.Even[winningIndex]) or
            (betId == "42" and _rouletteGroups.Odd[winningIndex]) or
            (betId == "43" and _rouletteGroups.Low[winningIndex]) or
            (betId == "44" and _rouletteGroups.High[winningIndex])
        then
            -- 1 to 1
            totalsWon[v.Source] = math.floor(totalsWon[v.Source] + v.Amount * 2)
        elseif tonumber(betId) >= 1 and tonumber(betId) <= 36 and tonumber(betId) == tonumber(winningIndex) then
            -- 10 to 1
            totalsWon[v.Source] = math.floor(totalsWon[v.Source] + v.Amount * 11)
        elseif 
            (betId == "45" and _rouletteGroups.First12[winningIndex]) or
            (betId == "46" and _rouletteGroups.Second12[winningIndex]) or
            (betId == "47" and _rouletteGroups.Third12[winningIndex]) or
            (betId == "48" and _rouletteGroups.TwoToOne1[winningIndex]) or
            (betId == "49" and _rouletteGroups.TwoToOne2[winningIndex]) or
            (betId == "50" and _rouletteGroups.TwoToOne3[winningIndex])
        then
            -- 2 to 1
            totalsWon[v.Source] = math.floor(totalsWon[v.Source] + v.Amount * 3)
        elseif 
            (betId == "51" and _rouletteGroups.Row1[winningIndex]) or
            (betId == "52" and _rouletteGroups.Row2[winningIndex]) or
            (betId == "53" and _rouletteGroups.Row3[winningIndex]) or
            (betId == "54" and _rouletteGroups.Row4[winningIndex]) or
            (betId == "55" and _rouletteGroups.Row5[winningIndex]) or
            (betId == "56" and _rouletteGroups.Row6[winningIndex]) or
            (betId == "57" and _rouletteGroups.Row7[winningIndex]) or
            (betId == "58" and _rouletteGroups.Row8[winningIndex]) or
            (betId == "59" and _rouletteGroups.Row9[winningIndex]) or
            (betId == "60" and _rouletteGroups.Row10[winningIndex]) or
            (betId == "61" and _rouletteGroups.Row11[winningIndex]) or
            (betId == "62" and _rouletteGroups.Row12[winningIndex])
        then
            -- 5 to 1
            totalsWon[v.Source] = math.floor(totalsWon[v.Source] + v.Amount * 6)
        else
            totalsLost[v.Source] = math.floor(totalsLost[v.Source] + v.Amount)
        end
    end

    for k, v in pairs(totalsWon) do
        if v > 0 then
            local plyr = Fetch:Source(k)
            if plyr then
                local char = plyr:GetData("Character")
                if char then
                    if Casino.Chips:Modify(k, v) then
                        SendCasinoWonChipsPhoneNotification(k, v)
                    end

                    UpdateCharacterCasinoStats(k, "roulette", true, v)
                end
            end
        end
    end

    for k, v in pairs(totalsLost) do
        if v > 0 then
            UpdateCharacterCasinoStats(k, "roulette", false, v)
            GiveCasinoFuckingMoney(k, "Roulette", v)
        end
    end

    if _roulette[tableId] then
        for k, v in pairs(_roulette[tableId].Seats) do
            if v and v.Source and v.TotalBet > 0 then
                TriggerClientEvent("Casino:Client:RouletteResultAnim", v.Source, v.TotalBet, totalsWon[v.Source])
            end
        end
    end
end

function UpdateRouletteGameState(tableId)
    if _roulette[tableId] then
        GlobalState[string.format("Casino:Roulette:%s", tableId)] = _roulette[tableId]
    end
end

local usedVariations = {}

function GenerateRandomRDealerVariation()
    local var = math.random(0, 13)

    while var == 7 or usedVariations[var] do
        var = math.random(0, 13)
        Wait(10)
    end

    usedVariations[var] = true
    return var
end

AddEventHandler("Casino:Server:Startup", function()
    for k, v in pairs(_rouletteTables) do
        local data = GetDefaultRouletteData(k, {false, false, false, false}, v.highLimit)

        _roulette[k] = data
        GlobalState[string.format("Casino:Roulette:%s", k)] = data

        v.dealerVariation = GenerateRandomRDealerVariation()
    end

    GlobalState["Casino:RouletteConfig"] = _rouletteTables

    Middleware:Add("Characters:Logout", function(source)
        HandleCharacterDisconnect(source)
	end)

	Middleware:Add("playerDropped", function(source)
        HandleCharacterDisconnect(source)
	end)

    Callbacks:RegisterServerCallback("Casino:JoinRoulette", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if not char or _roulettePlayers[source] then
            return cb(false)
        end

        local tableId, localChairId = data.table, data.chair

        if _roulette[tableId] and not _roulette[tableId].Seats[localChairId] then

            if _rouletteTables[tableId].isVIP and not Inventory.Items:Has(char:GetData("SID"), 1, "diamond_vip", 1) then
                return cb(false, "vip")
            end

            _roulette[tableId].Seats[localChairId] = {
                State = false,
                Source = source,
                First = char:GetData("First"),
                Last = char:GetData("Last"),
                SID = char:GetData("SID"),
                TotalBet = 0,
            }

            _roulettePlayers[source] = {
                Table = tableId,
                LocalChair = localChairId,
            }

            GlobalState[string.format("Casino:Roulette:%s", tableId)] = _roulette[tableId]
            cb(true, tableId, localChairId)

            Wait(5000)
            StartRouletteGame(tableId)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Casino:LeaveRoulette", function(source, data, cb)
        --local char = Fetch:Source(source):GetData("Character")
        local blackjackPlayer = _roulettePlayers[source]
        if not blackjackPlayer then
            return cb(false)
        end

        if _roulette[blackjackPlayer.Table] and _roulette[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair] then
            _roulette[blackjackPlayer.Table].Seats[blackjackPlayer.LocalChair] = false
            _roulettePlayers[source] = nil

            GlobalState[string.format("Casino:Roulette:%s", blackjackPlayer.Table)] = _roulette[blackjackPlayer.Table]
            cb(true)
        else
            cb(false)
        end
    end)

    -- Bets
    Callbacks:RegisterServerCallback("Casino:BetRoulette", function(source, data, cb)
        --local char = Fetch:Source(source):GetData("Character")
        local roulettePlayer = _roulettePlayers[source]
        if not roulettePlayer or not data then
            return cb(false)
        end

        local amount, betId = tonumber(data.amount), data.betId
        if type(amount) ~= "number" or amount < 100 or not betId then
            return cb(false)
        end

        if (amount >= 100) and _roulette[roulettePlayer.Table] and not _roulette[roulettePlayer.Table].Started and _roulette[roulettePlayer.Table].Seats[roulettePlayer.LocalChair] then
            if (_roulette[roulettePlayer.Table].Seats[roulettePlayer.LocalChair].TotalBet + amount) <= _rouletteTables[roulettePlayer.Table].maxBet then
                if Casino.Chips:Modify(source, -amount) then
                    --SendCasinoSpentChipsPhoneNotification(source, amount)

                    if amount > 10000 then
                        local shit = math.floor(amount / 10000)
                        for i = 1, shit do
                            table.insert(_roulette[roulettePlayer.Table].Bets, {
                                betId = betId,
                                Source = source,
                                Amount = 10000
                            })
                        end
                    else
                        table.insert(_roulette[roulettePlayer.Table].Bets, {
                            betId = betId,
                            Source = source,
                            Amount = math.floor(amount)
                        })
                    end

                    UpdateRouletteGameState(roulettePlayer.Table)

                    _roulette[roulettePlayer.Table].Seats[roulettePlayer.LocalChair].TotalBet += data.amount

                    TriggerClientEvent("Casino:Client:RouletteUpdateBets", -1, roulettePlayer.Table, _roulette[roulettePlayer.Table].Bets)

                    cb(true)
                else
                    Execute:Client(source, "Notification", "Error", "Not Enough Chips")
                    cb(false)
                end
            else
                Execute:Client(source, "Notification", "Error", "Over Table Bet Limit")
                cb(false)
            end
        else
            cb(false)
        end
    end)

    Chat:RegisterAdminCommand("forceroulette", function(source, args, rawCommand)
        local tid = tonumber(args[1])
        if _roulette[tid] then
            _roulette[tid].Starting = false
            _roulette[tid].Started = false
            StartRouletteGame(tid)
        end
	end, {
		help = "[Admin] Force Start Roulette",
		params = {
			{
				name = "Table",
				help = "Table ID",
			},
		},
	}, 1)
end)

function HandleCharacterDisconnect(source)
    local roulettePlayer = _roulettePlayers[source]
    if roulettePlayer then
        if _roulette[roulettePlayer.Table].Seats[roulettePlayer.LocalChair] then
            _roulette[roulettePlayer.Table].Seats[roulettePlayer.LocalChair] = false
        end
        _roulettePlayers[source] = nil
    end
end

function GetRouletteTableCount(tableId)
    local joinedPlayers = 0

    for k, v in pairs(_roulette[tableId].Seats) do
        if v and v.Source then
            joinedPlayers += 1
        end
    end

    return joinedPlayers
end