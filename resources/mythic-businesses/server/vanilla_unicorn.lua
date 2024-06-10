AddEventHandler('Businesses:Server:Startup', function()
    Callbacks:RegisterServerCallback('VU:MakeItRain', function(source, data, cb)
        local player = Fetch:Source(source)
        local target = Fetch:Source(data?.target)

        if player and target and data?.type then
            local char = player:GetData('Character')
            local targetChar = target:GetData('Character')

            if char and targetChar and Player(targetChar:GetData('Source')).state.onDuty == 'unicorn' then
                local itemData = Inventory.Items:GetData(data.type)
                if data.type == 'cash' then
                    if Wallet:Modify(char:GetData('Source'), -100) then
                        Wallet:Modify(targetChar:GetData('Source'), 100)
                        return cb(true)
                    end
                elseif itemData then
                    if Inventory.Items:Has(char:GetData('SID'), 1, data.type, 1) then
                        if Inventory.Items:Remove(char:GetData('SID'), 1, data.type, 1) then
                            Wallet:Modify(targetChar:GetData('Source'), itemData.price)

                            return cb(true)
                        end
                    end
                end
            end
        end

        cb(false)
    end)
end)