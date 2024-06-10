AddEventHandler("Apartment:Server:SpawnInside", function()
    
end)

RegisterNetEvent("Apartment:Server:LeavePoly", function()
    local src = source
    if _requestors[src] ~= nil then
        for k, v in ipairs(_requests) do
            if v == src then
                table.remove(_requests, k)
                return
            end
        end
    end
end)