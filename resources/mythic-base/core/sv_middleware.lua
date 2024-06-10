local _middlewares = {}

AddEventHandler('onResourceStart', function(resource)
    if COMPONENTS.Proxy.ExportsReady then
        if resource ~= GetCurrentResourceName() then
            _middlewares = {}
            collectgarbage()
        end
    end
end)

COMPONENTS.Middleware = {
    TriggerEvent = function(self, event, source, ...)
        if _middlewares[event] then
            table.sort(_middlewares[event], function(a,b) return a.prio < b.prio end)
            
            for k, v in pairs(_middlewares[event]) do
                v.cb(source, ...)
            end
        end
    end,
	TriggerEventWithData = function(self, event, source, ...)
        if _middlewares[event] then
			-- Making bold assumption this is only going to be done with data you want inserted into a table
			local data = {}
            table.sort(_middlewares[event], function(a,b) return a.prio < b.prio end)
            for k, v in pairs(_middlewares[event]) do
				for k2, v2 in ipairs(v.cb(source, ...)) do
					v2.ID = #data + 1
					table.insert(data, v2)
				end
            end
			table.sort(data, function(a,b) return a.ID < b.ID end)
			return data
        end
	end,
    Add = function(self, event, cb, prio)
        
        if prio == nil then
            prio = 1
        end

        if _middlewares[event] == nil then
            _middlewares[event] = {}
        end
        
        table.insert(_middlewares[event], {cb = cb, prio = prio})
    end
}