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

---@diagnostic disable-next-line: duplicate-set-field
function Citizen.Trace(...)
    if type(...) == "string" then
        local args = string.lower(...)
        for _, word in ipairs(errorWords) do
            if string.find(args, word) then
                error(...)
                return
            end
        end
    end
    _trace(...)
end