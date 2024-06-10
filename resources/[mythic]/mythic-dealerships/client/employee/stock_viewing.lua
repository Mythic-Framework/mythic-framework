local stockViewing
local stockViewingSub

AddEventHandler('Dealerships:Client:StockViewing', function(hit, data)
    if data and data.dealerId then
        ViewDealershipStocks(data.dealerId)
    end
end)

function ViewDealershipStocks(dealerId)
    local dealerData = _dealerships[dealerId]
    if dealerData then
        Callbacks:ServerCallback('Dealerships:StockViewing:FetchData', dealerId, function(authed, stocks, serverTime, dealerProfitPercent)
            if not authed then
                Notification:Error('You\'re Not Authorized to View Stock', 3500, 'car-building')
                return
            end

            local stockData = FormatDealerStockToCategories(stocks)
            stockViewingSub = {}
            
            stockViewing = Menu:Create('stockViewing', string.format('View %s Stock', dealerData.abbreviation), function()
            
            end, function()
                stockViewing = nil
                stockViewingSub = nil
                collectgarbage()
            end)
            --stockViewing.Add:Text(string.format('There are %s different models of vehicle, totalling %s vehicles', stockData.total, stockData.totalQuantity), { 'pad', 'center', 'code' })

            local orderedCategories = Utils:GetTableKeys(_catalogCategories)
            table.sort(orderedCategories, function(a, b)
                return _catalogCategories[a] < _catalogCategories[b]
            end)

            local saleMultiplier = 1 + (dealerProfitPercent / 100)

            for _, category in ipairs(orderedCategories) do
                if stockData.sorted[category] and #stockData.sorted[category] > 0 then
                    stockViewingSub[category] = Menu:Create('stockViewingCat-'.. category, _catalogCategories[category])
        
                    for k, v in ipairs(stockData.sorted[category]) do
                        stockViewingSub[category].Add:Text(string.format(
                            [[
                                Make: %s<br>
                                Model: %s<br>
                                Quantity In Stock: %s<br>
                                Class: %s<br>
                                Category: %s<br>
                                Wholesale Value: %s<br>
                                Dealer Sale Price: %s<br>
                                Last Purchased: %s<br>
                                Last Restocked: %s<br>
                                Vehicle Identifier: %s<br>
                            ]],
                            v.make,
                            v.model,
                            v.quantity,
                            v.class and string.upper(v.class) or '?',
                            _catalogCategories[v.category],
                            v.price and '$' .. formatNumberToCurrency(v.price) or '$?',
                            v.price and '$' .. formatNumberToCurrency(math.floor(Utils:Round(v.price * saleMultiplier, 0))) or '$?',
                            (v.lastPurchased and GetFormattedTimeFromSeconds(serverTime - v.lastPurchased) .. ' ago.' or 'Never'),
                            GetFormattedTimeFromSeconds(serverTime - v.lastStocked) .. ' ago.',
                            string.upper(v.vehicle)
                        ), { 'code', 'pad'})
                    end
        
                    stockViewingSub[category].Add:SubMenuBack('Go Back', {})
                    stockViewing.Add:SubMenu(_catalogCategories[category], stockViewingSub[category], {})
                end
            end
    
            stockViewing:Show()
        end)
    end
end