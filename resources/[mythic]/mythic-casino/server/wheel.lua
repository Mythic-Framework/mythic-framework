local targetSlice = 2
local numSpins = 10

local _wheelAccumulator = 0
local _wheelSpins = 0

AddEventHandler("Casino:Server:Startup", function()
    GlobalState["Casino:WheelStarted"] = false
    GlobalState["Casino:WheelSpinning"] = false
    GlobalState["Casino:WheelLastRotation"] = 0.0
    GlobalState["Casino:WheelLocked"] = false

    Callbacks:RegisterServerCallback("Casino:WheelStart", function(source, data, cb)
        if not GlobalState["Casino:WheelStarted"] then
            if data?.turbo then
                local char = Fetch:Source(source):GetData("Character")

                if char and Wallet:Has(source, 7500) and Inventory.Items:Has(char:GetData("SID"), 1, "diamond_vip", 1) then
                    GlobalState["Casino:WheelStarted"] = {
                        Source = source,
                        Turbo = true,
                    }

                    SetTimeout(3000, function()
                        GlobalState["Casino:WheelStarted"] = false
                    end)

                    cb(true)
                else
                    cb(false, true)
                end
            else
                if Wallet:Has(source, 1500) then
                    GlobalState["Casino:WheelStarted"] = {
                        Source = source,
                        Turbo = false,
                    }

                    SetTimeout(3000, function()
                        GlobalState["Casino:WheelStarted"] = false
                    end)

                    cb(true)
                else
                    cb(false, true)
                end
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Casino:WheelSpin", function(source, data, cb)
        if GlobalState["Casino:WheelStarted"] and GlobalState["Casino:WheelStarted"].Source == source and Wallet:Modify(source, GlobalState["Casino:WheelStarted"].Turbo and -7500 or -1500) then
            GlobalState["Casino:WheelSpinning"] = source

            if GlobalState["Casino:WheelStarted"].Turbo then
                _wheelAccumulator += 7500
                GiveCasinoFuckingMoney(source, "Lucky Wheel", 7500)

                for i = 1, 5 do
                    local randomPrize = GenerateWheelPrize()

                    SpinTheFuckingWheel(randomPrize.slice)

                    GiveWheelPrize(source, randomPrize)

                    Wait(1000)

                    if randomPrize.bigWin then
                        GlobalState["Casino:WheelLocked"] = true
                        break
                    end
                end

                GlobalState["Casino:WheelSpinning"] = false
            else
                _wheelAccumulator += 1500
                GiveCasinoFuckingMoney(source, "Lucky Wheel", 1500)

                local randomPrize = GenerateWheelPrize()

                SpinTheFuckingWheel(randomPrize.slice)

                GiveWheelPrize(source, randomPrize)
            end

            GlobalState["Casino:WheelSpinning"] = false

            cb(true)

            _wheelSpins += 1
            if _wheelSpins > 10 then
                _wheelSpins = 0
                Casino.Config:Set("wheel-accumulator", _wheelAccumulator)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Casino:UnlockWheel", function(source, data, cb)
        if Player(source).state.onDuty == "casino" and GlobalState["Casino:WheelLocked"] then
            GlobalState["Casino:WheelLocked"] = false
            cb(true)
        else
            cb(false)
        end
    end)

    while not _casinoConfigLoaded do
        Wait(250)
    end

    _wheelAccumulator = Casino.Config:Get("wheel-accumulator") or 0
end)

AddEventHandler("Core:Server:ForceSave", function()
	Casino.Config:Set("wheel-accumulator", _wheelAccumulator)
end)

function GenerateWheelPrize()
    local prizes = GetWheelPrizeConfig()

    if _wheelAccumulator >= 90000 then
        table.insert(prizes, {3, { slice = 7, type = "cash", value = 90000 }})
    end

    if _wheelAccumulator >= 200000 and math.random(9) == 4 then
        table.insert(prizes, {1, { slice = 12, type = "mystery" }})
    end

    if _wheelAccumulator >= 200000 and math.random(20) == 13 then
        table.insert(prizes, {3, { slice = 20, type = "cash", value = 150000, bigWin = true }})
    end

    if _wheelAccumulator >= 2000000 and math.random(17) == 7 then -- This might be too low paired with 2 randoms
        table.insert(prizes, {5, { slice = 5, type = "house", bigWin = true }})
        table.insert(prizes, {5, { slice = 19, type = "vehicle", bigWin = true }})
    end

    local randomPrize = Utils:WeightedRandom(prizes)

    if randomPrize.bigWin then
        Casino.Config:Set("wheel-accumulator", 0)
        _wheelAccumulator = 0
    end

    return randomPrize
end

function SpinTheFuckingWheel(slice)
    local p = promise.new()
    local offset = math.random(2, 16)
    local spins = math.random(6, 12)

    local sliceWidth = 360.0 / 20
    local finalRotation = (sliceWidth * slice) - offset

    TriggerClientEvent("Casino:Client:SpinWheel", -1)

    SetTimeout(math.random(3, 5) * 1000, function()
        GlobalState["Casino:WheelLastRotation"] = finalRotation
        TriggerClientEvent("Casino:Client:WheelLastRotation", -1, finalRotation)

        Wait(250)

        p:resolve(true)
    end)

    return Citizen.Await(p)
end

function GiveWheelPrize(source, randomPrize)
    local plyr = Fetch:Source(source)
    if plyr then
        local char = plyr:GetData("Character")
        if char then
            if randomPrize.bigWin then
                TriggerClientEvent("Casino:Client:BigWin", -1)
            end

            if randomPrize.type == "cash" then
                local value = randomPrize.value
                if value == "random" then
                    if math.random(100) == 42 then
                        value = (math.random(10, 25) * 1000)
                    else
                        value = (math.random(1, 10) * 1000)
                    end
                end

                if Wallet:Modify(source, value) then
                    UpdateCharacterCasinoStats(source, "wheel", true, value)

                    if value >= 90000 then
                        SaveCasinoBigWin(source, "wheel", string.format("Won Large Cash Prize ($%s)", value), randomPrize)
                    else
                        _wheelAccumulator -= value
                    end
                end
            elseif randomPrize.type == "chips" then
                local value = randomPrize.value
                if value == "random" then
                    if math.random(100) == 42 then
                        value = (math.random(10, 25) * 1000)
                    else
                        value = (math.random(1, 10) * 1000)
                    end
                end

                if Casino.Chips:Modify(source, value) then
                    SendCasinoWonChipsPhoneNotification(source, value)

                    UpdateCharacterCasinoStats(source, "wheel", true, value)

                    _wheelAccumulator -= value
                end
            elseif randomPrize.type == "alcohol" then
                Loot:CustomWeightedSetWithCount({
                    { 25, { name = "diamond_drink", min = 1, max = 1 } },
                    { 25, { name = "wine_glass", min = 1, max = 1 } },
                    { 25, { name = "whiskey_glass", min = 1, max = 1 } },
                    { 25, { name = "pina_colada", min = 1, max = 1 } },
                    { 25, { name = "raspberry_mimosa", min = 1, max = 1 } },
                    { 10, { name = "sausageroll", min = 1, max = 1 } },
                    { 10, { name = "soda", min = 1, max = 1 } },
                }, char:GetData("SID"), 1)
            elseif randomPrize.type == "vehicle" then
                SaveCasinoBigWin(source, "wheel", "Won Vehicle Prize", randomPrize)

                SendCasinoPhoneNotification(source, "Vehicle Won!", "Please contact casino staff to claim your prize.", 10000)

                --SetPrizeDisabled(randomPrize.slice, 10)
            elseif randomPrize.type == "house" then
                SaveCasinoBigWin(source, "wheel", "Won Real Estate Discount Prize", randomPrize)

                SendCasinoPhoneNotification(source, "Real Estate Discount Won!", "Please contact casino staff to claim your prize.", 10000)

                --SetPrizeDisabled(randomPrize.slice, 7)
            elseif randomPrize.type == "mystery" then
                SaveCasinoBigWin(source, "wheel", "Won Mystery Prize", randomPrize)

                SendCasinoPhoneNotification(source, "Mystery Prize Won!", "Please contact casino staff to claim your prize.", 10000)

                --SetPrizeDisabled(randomPrize.slice, 7)
            end
        end
    end
end