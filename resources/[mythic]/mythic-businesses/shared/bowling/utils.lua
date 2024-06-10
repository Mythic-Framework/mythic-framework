function GetBowlingPinLayout(center)
    local points = {}
    -- Back Row
    for i = 0, 3 do
        local row = vector3(center.x - 0.2, center.y - 0.45, center.z)
        table.insert(points, vector3(row.x, row.y + (0.3 * i), row.z))
    end
    -- Middle Row
    for i = 0, 2 do
        local row = vector3(center.x, center.y - 0.3, center.z)
        table.insert(points, vector3(row.x, row.y + (0.3 * i), row.z))
    end
    -- 2
    for i = 0, 1 do
        local row = vector3(center.x + 0.2, center.y - 0.15, center.z)
        table.insert(points, vector3(row.x, row.y + (0.3 * i), row.z))
    end
    -- Front Row
    table.insert(points, vector3(center.x + 0.4, center.y, center.z))

    return points
end

function IsPlayerInBowlingAlley(bowlingPlayers, playerSID)
    for k, v in ipairs(bowlingPlayers) do
        if v.SID == playerSID then
            return v
        end
    end

    return false
end