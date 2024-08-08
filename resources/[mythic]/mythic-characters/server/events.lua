RegisterServerEvent('Characters:Server:Spawning', function()
    Middleware:TriggerEvent('Characters:Spawning', source)
end)

RegisterServerEvent('Ped:LeaveCreator', function()
    local plyr = Fetch:Source(source)
    if plyr ~= nil then
        local char = plyr:GetData('Character')
        if char ~= nil then
            if char:GetData('New') then
                char:SetData('New', false)
            end
        end
    end
end)