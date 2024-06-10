characterLoaded = false
local disableAllKeys = false
local disabledKeys = {}
_registeredKeybinds = {}

AddEventHandler('Keybinds:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Keybinds = exports['mythic-base']:FetchComponent('Keybinds')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Keybinds', {
        'Logger',
        'Utils',
        'Keybinds',
    }, function(error)
        if #error > 0 then
            return
        end
        RetrieveComponents()

        -- Register the global binds from the config
        for k, v in pairs(Config.GlobalKeybinds) do
            _registeredKeybinds[k] = v
            _registeredKeybinds[k].global = true
            KeyMappingAdd(k, _registeredKeybinds[k])
        end
    end)
end)

RegisterNetEvent('Characters:Client:Spawn')
AddEventHandler('Characters:Client:Spawn', function()
    characterLoaded = true
end)

RegisterNetEvent('Characters:Client:Logout')
AddEventHandler('Characters:Client:Logout', function()
    characterLoaded = false
end)

function KeyMappingAdd(id, data)
    local down = '+'.. id
    local up = '-'.. id
    RegisterCommand(down, function() KeyMappingTrigger(id, false) end)
    RegisterCommand(up, function() KeyMappingTrigger(id, true) end)
    RegisterKeyMapping(down, data.description .. '~', data.defaultPad, data.defaultKey)
end

function KeyMappingTrigger(id, keyup)
    if characterLoaded and not IsKeyDisabled(id) and _registeredKeybinds[id] then
        if keyup then
            if not _registeredKeybinds[id].global and _registeredKeybinds[id].keyupCb then
                _registeredKeybinds[id].keyupCb()
            else
                TriggerEvent('Keybinds:Client:KeyUp:'.. id)
            end
        else
            if not _registeredKeybinds[id].global and _registeredKeybinds[id].keydownCb then
                _registeredKeybinds[id].keydownCb()
            else -- Send event if global or for some reason the callbacks aren't there
                TriggerEvent('Keybinds:Client:KeyDown:'.. id)
            end
        end
    end
end

function IsKeyDisabled(key)
    if disableAllKeys then
        return true
    end

    for k, v in ipairs(disabledKeys) do
        if v == key then
            return true
        end
    end

    return false
end

KEYBINDS = {
    Add = function(self, id, key, pad, desc, keydownCb, keyupCb, global)
        if _registeredKeybinds[id] then
            if not _registeredKeybinds[id].global then -- Do this in case of resource restarts it makes it easier
                _registeredKeybinds[id].keydownCb = keydownCb
                _registeredKeybinds[id].keyupCb = keyupCb
            end
            return
        end

        if not key then return end

        _registeredKeybinds[id] = {
            global = global, -- For the odd chance that a global bind is added this way
            defaultKey = key,
            defaultPad = (pad and pad or 'keyboard'),
            description = (desc and desc or ''),
            keydownCb = (not global and keydownCb or nil),
            keyupCb = (not global and keyupCb or nil),
        }

        KeyMappingAdd(id, _registeredKeybinds[id])
    end,
    Enable = function(self) -- Re-enable all keys again
        disableAllKeys = false
        disabledKeys = {}
    end,
    Disable = function(self, keys)
        if keys == nil then -- disable all keys
            disableAllKeys = true 
        else
            if type(keys) == 'string' then -- disable one or a set of specific keys
                keys = { keys }
            end
            disabledKeys = keys
        end
    end,
    IsDisabled = function(self, key)
        return IsKeyDisabled(key)
    end,
    GetKey = function(self, id)
        if not _registeredKeybinds[id] then return false; end
        local key = GetControlInstructionalButton(0, GetHashKey('+'.. id) | 0x80000000, 1):gsub("t_", "")
        if key:find('^b_') then
            key = _dumbFuckingKeyStrings[key] or 'Unknown'
        end
        return key
    end,
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Keybinds', KEYBINDS)
end)