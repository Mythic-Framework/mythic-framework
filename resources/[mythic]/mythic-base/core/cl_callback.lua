local _sCallbacks = {}
local _cCallbacks = {}

COMPONENTS.Callbacks = {
    _required = { 'ServerCallback', 'RegisterClientCallback', 'DoClientCallback' },
    _name = 'base',
    ServerCallback = function(self, event, data, cb, extraId)
        id = event
        if extraId ~= nil then
            id = string.format("%s-%s", event, extraId)
        else
            extraId = ''
        end

        data = data or {}
        _sCallbacks[id] = cb
        TriggerServerEvent('Callbacks:Server:TriggerEvent', event, data, extraId)
    end,
    RegisterClientCallback = function(self, event, cb)
        _cCallbacks[event] = cb
    end,
    DoClientCallback = function(self, event, extraId, data)
        if _cCallbacks[event] ~= nil then
            CreateThread(function()
                _cCallbacks[event](data, function(...)
                    TriggerServerEvent('Callbacks:Server:ReceiveCallback', event, extraId, ...)
                end)
            end)
        end
    end,
}

RegisterNetEvent('Callbacks:Client:TriggerEvent')
AddEventHandler('Callbacks:Client:TriggerEvent', function(event, data, extraId)
    if data == nil then data = {} end
    COMPONENTS.Callbacks:DoClientCallback(event, extraId, data)
end)

RegisterNetEvent('Callbacks:Client:ReceiveCallback')
AddEventHandler('Callbacks:Client:ReceiveCallback', function(event, extraId, ...)
    local id = event
    if extraId ~= '' then
        id = string.format("%s-%s", event, extraId)
    end

    if _sCallbacks[id] ~= nil then
        _sCallbacks[id](...)
        _sCallbacks[id] = nil
        collectgarbage()
    end
end)