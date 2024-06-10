function table.count(table)
    local i = 0
    for k, v in pairs(table) do
        i = i + 1
    end
    return i
end

function table.indexOfKey(table, key)
    local i = 1
    for k, v in pairs(table) do
        if k == key then
            return i
        end
        i = i + 1
    end
    return nil
end