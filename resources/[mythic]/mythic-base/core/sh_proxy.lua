local _req = { 'ExportsReady' }
local _deps = {}
if IsDuplicityVersion() then _req = { 'ExportsReady', 'DatabaseReady' } end

COMPONENTS.Proxy = {
    _required = _req,
    _name = 'base',
    ExportsReady = false,
}

AddEventHandler('onResourceStart', function(resource)
    if COMPONENTS.Proxy.ExportsReady then
        if resource ~= GetCurrentResourceName() then
            TriggerEvent('Proxy:Shared:RegisterReady')

            if GetGameTimer() > 10000 then
                TriggerEvent('Core:Shared:Ready')
            end
            collectgarbage()
        end
    end
end)

function NotifyDependencyUpdate(component)
    if _deps[component] ~= nil then
        for k, v in ipairs(_deps[component]) do
            TriggerEvent(v .. ':Shared:DependencyUpdate')
        end
    end
end

exports('RegisterComponent', function(component, data)
    local _overriding = false

    if COMPONENTS[component] ~= nil then
        if COMPONENTS[component]._protected then
            COMPONENTS.Logger:Warn('Proxy', string.format("Attempt To Override Protected Component: ^2%s^7", tostring(component)), { console = true })
            return
        else
            if COMPONENTS[component]._required and #COMPONENTS[component]._required > 0 then
                for k, v in ipairs(COMPONENTS[component]._required) do
                    if data[v] == nil then
                        COMPONENTS.Logger:Warn('Proxy', string.format("Attempt To Extend Component While Missing Required Attribute: ^2%s^7", tostring(v)), { console = true })
                        return
                    end
                end
            end
        end

        _overriding = true
        COMPONENTS.Logger:Trace('Proxy', string.format("Overriding Existing Component: ^2%s^7", tostring(component)), { console = true })
    end

	COMPONENTS.Logger:Trace('Proxy', string.format("Registered Component: %s", tostring(component)), { console = true })
    COMPONENTS[component] = data

    if _overriding then
        if COMPONENTS[component]._name ~= nil then 
            NotifyDependencyUpdate(COMPONENTS[component]._name)
        else
            NotifyDependencyUpdate(component)
        end
    end
    TriggerEvent('Proxy:Shared:ExtendReady', component)
end)

exports('FetchComponent', function(component)
    if not COMPONENTS[component] then
        COMPONENTS.Logger:Warn('Proxy', string.format("^1Attempt To Fetch Non-Existent Component^7: ^2%s^7", tostring(component)), { console = true })
        return nil
    end

    return COMPONENTS[component]
end)

exports('ExtendComponent', function(component, data)
    if COMPONENTS[component] ~= nil then
        if COMPONENTS[component]._protected == nil then
            for k, v in pairs(data) do
                COMPONENTS[component][k] = v
            end

            if COMPONENTS[component]._name ~= nil then 
                NotifyDependencyUpdate(COMPONENTS[component]._name)
            else
                NotifyDependencyUpdate(component)
            end
        else
            COMPONENTS.Logger:Warn('Proxy', string.format("Attempt To Extend Protected Component: ^2%s^7", tostring(component)), { console = true })
        end
    else
        COMPONENTS.Logger:Warn('Proxy', string.format("Attempt To Extend Non-Existent Component: ^2%s^7", tostring(component)), { console = true })
    end
end)

exports('RequestDependencies', function(c, d, cb)
    CreateThread(function()
        local _loaded = false
        local _attempts = {}
        local _errs = {}
        while not _loaded do
            for k, v in pairs(d) do
                if COMPONENTS[v] ~= nil then
                    d[k] = nil
                    
                    if _deps[v] == nil then _deps[v] = {} end
                    table.insert(_deps[v], c)
                else
                    if _attempts[v] == nil then
                        _attempts[v] = 1
                    elseif _attempts[v] > 50 then
                        table.insert(_errs, v)
                        COMPONENTS.Logger:Error('Proxy', ('[^2%s^7] Failed To Load For [^3%s^7]'):format(v, c), { console = true })
                        d[k] = nil
                    else
                        _attempts[v] = _attempts[v] + 1
                    end
                end
            end

            if #d == 0 then
                _loaded = true
            end

            Wait(100)
        end

        cb(_errs)
        collectgarbage()
    end)
end)