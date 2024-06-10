UISOUNDS = {
    Play = {
        Generic = function(self, clientId, id, sound, library)
            TriggerClientEvent('UISounds:Client:Play:Generic', clientId, id, sound, library)
        end,
        Coords = function(self, clientId, id, sound, library, coords)
            TriggerClientEvent('UISounds:Client:Play:Coords', clientId, id, sound, library, coords)
        end,
        Entity = function(self, clientId, id, sound, library, entity)
            TriggerClientEvent('UISounds:Client:Play:Entity', clientId, id, sound, library, entity)
        end,
        FrontEnd = function(self, clientId, id, sound, library)
            TriggerClientEvent('UISounds:Client:Play:FrontEnd', clientId, id, sound, library)
        end
    }
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('UISounds', UISOUNDS)
end)