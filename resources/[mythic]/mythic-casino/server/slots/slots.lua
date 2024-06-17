_slotMachines = {}
_slotMachineCount = 44

local slotValues = {
    [1] = "2",
	[2] = "3",
	[3] = "6",
	[4] = "2",
	[5] = "4",
	[6] = "1",
	[7] = "6",
	[8] = "5",
	[9] = "2",
	[10] = "1",
	[11] = "3",
	[12] = "6",
	[13] = "7",
	[14] = "1",
	[15] = "4",
	[16] = "5",
}

local slotMultipliers = {
    ["1"] = 4,
	["2"] = 4,
	["3"] = 5,
	["4"] = 5,
	["5"] = 7,
	["6"] = 7,
	["7"] = 10,
}

local slotRandom = {
    {15, 1},
    {15, 2},
    {12, 3}, -- Bigger Prize (6)
    {15, 4},
    {15, 5},
    {15, 6},
    {12, 7}, -- Bigger Prize (6)
    {15, 8},
    {15, 9},
    {15, 10},
    {15, 11},
    {12, 12}, -- Bigger Prize (6)
    {15, 13},
    {15, 14},
    {15, 15},
    {15, 16},
}

AddEventHandler("Casino:Server:Startup", function()
    for i = 1, _slotMachineCount do
        _slotMachines[i] = false
    end

    --GlobalState["Casino:SlotMachines"] = _slotMachines

    Middleware:Add("Characters:Logout", function(source)
        for k, v in pairs(_slotMachines) do
            if v and v.Source== source then
                _slotMachines[k] = false
            end
        end
	end)

	Middleware:Add("playerDropped", function(source)
        for k, v in pairs(_slotMachines) do
            if v and v.Source == source then
                _slotMachines[k] = false
            end
        end
	end)

    Callbacks:RegisterServerCallback("Casino:SlotMachineSit", function(source, machineId, cb)
        local char = Fetch:Source(source):GetData("Character")
        if not char or _slotMachines[machineId] then
            return cb(false)
        end

        for k, v in pairs(_slotMachines) do
            if v and v.Source == source then
                _slotMachines[k] = false
            end
        end

        _slotMachines[machineId] = {
            Source = source,
            Spinning = false,
        }

        cb(true)
    end)

    Callbacks:RegisterServerCallback("Casino:SlotMachinePlay", function(source, data, cb)
        --local char = Fetch:Source(source):GetData("Character")
        local bet = math.floor(data.bet)

        if GlobalState["CasinoOpen"] and bet >= 100 and bet <= 2500 then
            for k, v in pairs(_slotMachines) do
                if v and v.Source == source then
                    if Casino.Chips:Modify(source, -bet) then
                        GiveCasinoFuckingMoney(source, "Slots", bet)
                        SendCasinoSpentChipsPhoneNotification(source, bet)

                        _slotMachines[k].Spinning = true

                        local time = math.random(3, 5) * 1000
                        local sound = "no_win"
                        local reel1 = Utils:WeightedRandom(slotRandom)
                        local reel2 = Utils:WeightedRandom(slotRandom)
                        local reel3 = Utils:WeightedRandom(slotRandom)

                        local tripleChance = math.random(100)
                        local canHaveTriple = (tripleChance >= 60 and tripleChance <= 69)

                        if not canHaveTriple or slotValues[reel3] == "7" then
                            while slotValues[reel3] == slotValues[reel2] do
                                reel3 = Utils:WeightedRandom(slotRandom)
                                Wait(5)
                            end
                        end

                        local a = slotValues[reel1]
                        local b = slotValues[reel2]
                        local c = slotValues[reel3]

                        local winnings = 0
                        if a == b and b == c and a == c then
                            local mult = slotMultipliers[a]
                            winnings = bet * mult
                            if mult >= 10 then
                                sound = "jackpot"
                            else
                                sound = "big_win"
                            end
                        elseif a == "6" and b == "6" then
                            winnings = bet * 3
                            sound = "small_win"
                        elseif a == "6" and c == "6" then
                            winnings = bet * 3
                            sound = "small_win"
                        elseif b == "6" and c == "6" then
                            winnings = bet * 3
                            sound = "small_win"
                        elseif a == "6" then
                            winnings = bet * 2
                            sound = "small_win"
                        elseif b == "6" then
                            winnings = bet * 2
                            sound = "small_win"
                        elseif c == "6" then
                            winnings = bet * 2
                            sound = "small_win"
                        end

                        winnings = math.floor(winnings)

                        SetTimeout(time, function()
                            if _slotMachines[k] then
                                local plyr = Fetch:Source(source)
                                if plyr then
                                    local char = plyr:GetData("Character")
                                    if char then
                                        if winnings > 0 then
                                            if Casino.Chips:Modify(source, winnings) then
                                                SendCasinoWonChipsPhoneNotification(source, winnings)
                                            end

                                            UpdateCharacterCasinoStats(source, "slots", true, winnings)
                                        else
                                            UpdateCharacterCasinoStats(source, "slots", false, bet)
                                        end
                                    end
                                end

                                _slotMachines[k].Spinning = false
                            end
                        end)

                        return cb(true, { reel1, reel2, reel3 }, time, sound, winnings)
                    else
                        Execute:Client(source, "Notification", "Error", "Not Enough Chips")
                        return cb(false)
                    end
                end
            end

            cb(false)
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Casino:SlotMachineLeave", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if not char then
            return cb(false)
        end

        for k, v in pairs(_slotMachines) do
            if v and v.Source == source and not v.Spinning then
                _slotMachines[k] = false

                return cb(true)
            end
        end

        cb(false)
    end)
end)