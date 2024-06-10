local _error = error
local _trace = Citizen.Trace

local errorWords = {"failure", "error", "not", "failed", "not safe", "invalid", "cannot", ".lua", "server", "client", "attempt", "traceback", "stack", "function"}

function error(...)
    local resource = GetCurrentResourceName()
    print(string.format("-----RESOURCE--ERROR-----"))
    print(...)
    print(string.format("-------------------------"))
    if GlobalState.IsProduction then
        TriggerServerEvent("Error:Server:Report", resource, ...)
    end
end

function Citizen.Trace(...)
    if type(...) == "string" then
        args = string.lower(...)
        for _, word in ipairs(errorWords) do
            if string.find(args, word) then
                error(...)
                return
            end
        end
    end
    _trace(...)
end
