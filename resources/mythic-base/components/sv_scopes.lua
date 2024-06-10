-- local _scopes = {}

-- COMPONENTS.Scopes = {
--     _name = 'base',
--     GetScope = function(self, scopeOwner)
--         return _scopes[tostring(scopeOwner)]
--     end,
--     IsPlayerInScope = function(self, source, scopeOwner)
--         local targets = _scopes[tostring(scopeOwner)]
--         if targets then
--             return targets[tostring(source)]
--         end
--         return false
--     end,
--     TriggerScopeEvent = function(self, eventName, scopeOwner, ...)
--         local targets = _scopes[tostring(scopeOwner)]
--         if targets then
--             for target, _ in pairs(targets) do
--                 TriggerClientEvent(eventName, target, ...)
--             end
--         end

--         TriggerClientEvent(eventName, scopeOwner, ...)
--     end,
-- }

-- AddEventHandler('playerEnteredScope', function(data)
--     local playerEntering, player = data["player"], data["for"]

--     if not _scopes[player] then
--         _scopes[player] = {}
--     end
--     _scopes[player][playerEntering] = true

--     TriggerClientEvent('Scopes:Client:PlayerEnterScope', player, playerEntering, false)
-- end)

-- AddEventHandler('playerLeftScope', function(data)
--     local playerLeaving, player = data["player"], data["for"]

--     if not _scopes[player] then return end
--     _scopes[player][playerLeaving] = nil

--     TriggerClientEvent('Scopes:Client:PlayerLeftScope', player, playerLeaving, false)
-- end)

-- AddEventHandler('playerDropped', function()
--     local src = tostring(source)
--     if not src then return end

--     _scopes[src] = nil

--     for owner, tbl in pairs(_scopes) do
--         if tbl[src] then
--             tbl[src] = nil
--             TriggerClientEvent('Scopes:Client:PlayerLeftScope', owner, src, true)
--         end
--     end
-- end)