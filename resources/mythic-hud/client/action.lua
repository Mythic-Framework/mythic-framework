ACTION = {
    Show = function(self, message, duration)
        local formattedMessage = string.gsub(message, "{keybind}([A-Za-z!\"#$%&'()*+,-./[\\%]^_`|~]+){/keybind}", function(key)
            local keyName = Keybinds:GetKey(key) or 'Unknown'
            return '{key}' .. keyName .. '{/key}'
        end)

        SendNUIMessage({
            type = 'SHOW_ACTION',
            data = {
                message = formattedMessage
            }
        })
    end,
    Hide = function(self)
        SendNUIMessage({
            type = 'HIDE_ACTION'
        })
    end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Action', ACTION)
end)