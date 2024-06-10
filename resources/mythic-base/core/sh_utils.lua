COMPONENTS.Utils = {
    _required = { 'Print' },
    _name = 'base',
    Print = function(self, t, s)
        if t then
            if type(t) ~= 'table' then 
                COMPONENTS.Logger:Trace("Utils", "^1 [^3debug^1] ["..type(t).."] ^7 "..t, { console = true })
                return
            else
                for k, v in pairs(t) do
                    local kfmt = '["' .. tostring(k) ..'"]'
                    if type(k) ~= 'string' then
                        kfmt = '[' .. k .. ']'
                    end
                    local vfmt = '"'.. tostring(v) ..'"'
                    if type(v) == 'table' then
                        self:Print(v, (s or '')..kfmt)
                    else
                        if type(v) ~= 'string' then
                            vfmt = tostring(v)
                        end
                        COMPONENTS.Logger:Trace("Utils", " ^1[^3debug^1] ["..type(t).."]^7 "..(s or '')..kfmt..' = '..vfmt, { console = true })
                    end
                end
            end
        else
            COMPONENTS.Logger:Error("Utils", "^1Error Printing Request - The Passed through variable seems to be nil^7", { console = true })
        end
    end,
    GetTableLength = function(self, t)
        local count = 0
        for _ in pairs(t) do
            count = count + 1
        end
        return count
    end,
    GetTableKeys = function(self, t)
        local keys = {}
        for k,v in pairs(t) do
            table.insert(keys,k)
        end
        return keys
    end,
    DoesTableHaveValue = function(self, t, val)
        for k, v in ipairs(t) do
            if v == val then
                return true
            end
        end
        return false
    end,
    Round = function(self, n, precision)
        if precision then
            return math.floor( (n * 10^precision) + 0.5 ) / (10^precision)
        end
        return math.floor( n + 0.5 )
    end,
    WeightedRandom = function(self, pool)
        local poolsize = 0
        for k, v in ipairs(pool) do
            if type(v[1]) == 'number' then
                poolsize = poolsize + tonumber(v[1])
            else
                return
            end
        end

        local selection = math.random(1, poolsize)

        for k, v in ipairs(pool) do
            selection = selection - v[1]
            if (selection <= 0) then
                return v[2]
            end
        end
    end,
}