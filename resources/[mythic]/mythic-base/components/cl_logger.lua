local function doLog(level, component, log)
    local prefix = '[LOG]'
    if level > 0 then
        if level == 1 then
            prefix = '[TRACE]'
        elseif level == 2 then
            prefix = '[^5INFO^7] '
        elseif level == 3 then
            prefix = '[^3WARN^7] '
        elseif level == 4 then
            prefix = '[^1ERROR^7]'
        elseif level == 5 then
            prefix = '[^9CRITICAL^7]'
        end
    end

    if COMPONENTS.Convar.LOGGING.value == nil or level >= COMPONENTS.Convar.LOGGING.value then
        local formattedLog = string.format('%s\t[^2%s^7] %s', prefix, component, log)
        print(formattedLog)
    end
end

AddEventHandler('Logger:Log', function(component, log) COMPONENTS.Logger:Log(component, log) end)
AddEventHandler('Logger:Trace', function(component, log) COMPONENTS.Logger:Trace(component, log) end)
AddEventHandler('Logger:Info', function(component, log) COMPONENTS.Logger:Info(component, log) end)
AddEventHandler('Logger:Warn', function(component, log) COMPONENTS.Logger:Warn(component, log) end)
AddEventHandler('Logger:Error', function(component, log) COMPONENTS.Logger:Error(component, log) end)
AddEventHandler('Logger:Critical', function(component, log) COMPONENTS.Logger:Critical(component, log) end)

COMPONENTS.Logger = {
    _required = { 'Log' },
    _name = 'base',
    Trace = function(self, component, log, flags, data)
        doLog(1, component, log)
    end,
    Info = function(self, component, log, flags, data)
        doLog(2, component, log)
    end,
    Warn = function(self, component, log, flags, data)
        doLog(3, component, log)
    end,
    Error = function(self, component, log, flags, data)
        doLog(4, component, log)
    end,
    Critical = function(self, component, log, flags, data)
        doLog(5, component, log)
    end,
    Log = function (self, component, log, flags, extra)
        doLog(0, component, log)
    end
}