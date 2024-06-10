function hasValue(tbl, value)
	for k, v in ipairs(tbl) do
		if v == value or (type(v) == "table" and hasValue(v, value)) then
			return true
		end
	end
	return false
end

local function dumbFuckingShitCuntFucker(type, amount)
    if amount ~= 1 then
        return type .. 's'
    end
    return type
end

function GetFormattedTimeFromSeconds(seconds)
    local days = 0
    local hours = math.floor(seconds / 3600)
    if hours >= 24 then
        days = math.floor(hours / 24)
        hours = math.ceil(hours - (days * 24))
    end

    local timeString
    if days > 0 or hours > 0 then
        if days > 1 then
            if hours > 0 then
                timeString = string.format('%d %s and %d %s', days, dumbFuckingShitCuntFucker('day', days), hours, dumbFuckingShitCuntFucker('hour', hours))
            else
                timeString = string.format('%d %s', days, dumbFuckingShitCuntFucker('day', days))
            end
        else
            timeString = string.format('%d %s', hours, dumbFuckingShitCuntFucker('hour', hours))
        end
    else
        local minutes = math.ceil(seconds / 60)
		if minutes <= 0 then
			minutes = 1
		end

        timeString = string.format('%d %s', minutes, dumbFuckingShitCuntFucker('minute', minutes))
    end
    return timeString
end