AddEventHandler("Crypto:Server:Startup", function()
    while Crypto == nil do
        Wait(10)
    end

    Crypto.Coin:Create("Vroom", "VRM", 100, false, false)
    Crypto.Coin:Create("Plebeian", "PLEB", 250, true, 190)
end)

AddEventHandler("Phone:Server:RegisterCallbacks", function()
    Callbacks:RegisterServerCallback("Phone:Crypto:Buy", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char then
            return cb(Crypto.Exchange:Buy(data.Short, char:GetData("SID"), data.Quantity))
        end
        cb(false)
    end)

    Callbacks:RegisterServerCallback("Phone:Crypto:Sell", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char then
            return cb(Crypto.Exchange:Sell(data.Short, char:GetData("SID"), data.Quantity))
        end
        cb(false)
    end)

    Callbacks:RegisterServerCallback("Phone:Crypto:Transfer", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char and char:GetData("SID") ~= data.Target then
            return cb(Crypto.Exchange:Transfer(data.Short, char:GetData("SID"), data.Target, data.Quantity))
        end
        cb(false)
    end)
end)
