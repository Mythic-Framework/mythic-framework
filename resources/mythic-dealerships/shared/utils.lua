function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

function FormatDealerStockToCategories(stockData)
    local sortedVehicles = {}
    local totalVehicles = 0
    local totalQuantity = 0

    if type(stockData) == 'table' and #stockData > 0 then
        for k, v in ipairs(stockData) do
            local category = (v.data.category and _catalogCategories[v.data.category]) and v.data.category or 'misc'
    
            if not sortedVehicles[category] then
                sortedVehicles[category] = {}
            end
    
            table.insert(sortedVehicles[category], {
                vehicle = v.vehicle,
                quantity = v.quantity,
                make = v.data.make and v.data.make or 'Unknown',
                model = v.data.model and v.data.model or 'Unknown',
                category = category,
                class = v.data.class,
                price = v.data.price,
                lastStocked = v.lastStocked,
                lastPurchase = v.lastPurchase,
            })
            
            totalVehicles = totalVehicles + 1
            totalQuantity = totalQuantity + v.quantity
        end

        for k, v in pairs(sortedVehicles) do
            table.sort(v, function(a, b)
                return string.lower(a.make) < string.lower(b.make)
            end)
        end
    end

    return {
        total = totalVehicles,
        totalQuantity = totalQuantity,
        sorted = sortedVehicles,
    }
end

local function dumbFuckingShitCuntFucker(type, amount)
    if not amount or amount > 1 then
        return type .. 's'
    end
    return type
end

function GetFormattedTimeFromSeconds(seconds)
    local days = 0
    local hours = Utils:Round(seconds / 3600, 0)
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
        local minutes = Utils:Round(seconds / 60, 0)
        timeString = string.format('%d %s', minutes, dumbFuckingShitCuntFucker('minute', minutes))
    end
    return timeString
end

function formatNumberToCurrency(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return minus .. int:reverse():gsub("^,", "") .. fraction
end