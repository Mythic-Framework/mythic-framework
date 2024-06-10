AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Pwnzor', PWNZOR)
end)

PWNZOR = PWNZOR or {}