function StartCookThread()
    if _threading then
        return
    end
    _threading = true

    CreateThread(function()
        while _threading do
            for k, v in pairs(_inProgCooks) do
                if os.time() > v.end_time then
                    _placedTables[k].pickupReady = true
                    Logger:Info("Drugs:Meth", string.format("Cook For Table %s Is Ready For Pickup", k))
                    TriggerClientEvent("Drugs:Client:Meth:UpdateTableData", -1, k, _placedTables[k])
                    _inProgCooks[k] = nil
                end
            end

            Wait(60000)
        end
    end)
end