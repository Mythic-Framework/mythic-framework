local salesMenu
local salesMenuSub

local saleData = {}

local loanData = {
    weeks = 10,
    downpayment = 30,
}

AddEventHandler('Dealerships:Client:OpenSales', function(hit, data)
    if data and data.dealerId then
        OpenDealershipSales(data.dealerId)
    end
end)

function OpenDealershipSales(dealerId)
    local dealerData = _dealerships[dealerId]
    if dealerData then
        Callbacks:ServerCallback('Dealerships:Sales:FetchData', dealerId, function(authed, stocks, serverTime, defaultInterestRate, dealerMData)
            if not authed then
                Notification:Error('You\'re Not Authorized to Make Sales', 3500, 'car-building')
                return
            end
            
            local stockData = FormatDealerStockToCategories(stocks)
            salesMenuSub = {}
            
            salesMenu = Menu:Create('salesMenu', string.format('View %s Stock', _dealerships[dealerId].abbreviation), function()
            
            end, function()
                salesMenu = nil
                salesMenuSub = nil
                collectgarbage()
            end)
            salesMenu.Add:Text(string.format('There are %s different models of vehicle, totalling %s vehicles', stockData.total, stockData.totalQuantity), { 'pad', 'center', 'code' })

            local orderedCategories = Utils:GetTableKeys(_catalogCategories)
            table.sort(orderedCategories, function(a, b)
                return _catalogCategories[a] < _catalogCategories[b]
            end)

            local minSaleMultiplier = 1 + (dealerMData.profitPercentage / 100)

            for _, category in ipairs(orderedCategories) do
                if stockData.sorted[category] and #stockData.sorted[category] > 0 then
                    salesMenuSub[category] = Menu:Create('salesMenuCat-'.. category, _catalogCategories[category])
        
                    for k, v in ipairs(stockData.sorted[category]) do
                        if v.quantity > 0 then
                            local vehMenuIdentifier = string.format('c:%s:%s', category, v.vehicle)
                            local vehName = v.make .. ' ' .. v.model
                            salesMenuSub[vehMenuIdentifier] = Menu:Create('salesMenu-'.. vehMenuIdentifier, vehName)
                            salesMenuSub[vehMenuIdentifier].Add:Text(string.format(
                                [[
                                    Make & Model: %s<br>
                                    Class: %s<br>
                                    Category: %s<br>
                                    Minimum Sale Price: %s<br>
                                    Last Purchased: %s<br>
                                ]],
                                vehName,
                                v.class and string.upper(v.class) or '?',
                                _catalogCategories[v.category],
                                v.price and ('$' ..formatNumberToCurrency(math.floor(Utils:Round(v.price * minSaleMultiplier, 0)))) or '$?',
                                (v.lastPurchased and GetFormattedTimeFromSeconds(serverTime - v.lastPurchased) .. ' ago.' or 'Never')
                            ), { 'code', 'pad'})

                            local cashSaleIdentifier = vehMenuIdentifier .. '-cash-sale'
                            local loanSaleIdentifier = vehMenuIdentifier .. '-loan-sale'


                            -- Cash Sales Menu
                            salesMenuSub[cashSaleIdentifier] = Menu:Create('salesMenu-'.. cashSaleIdentifier, vehName .. ' - New Sale')
                            local saleTextElem = salesMenuSub[cashSaleIdentifier].Add:Text(VehicleSalesGetCashText(dealerMData, dealerData, v), { 'code', 'pad' })

                            salesMenuSub[cashSaleIdentifier].Add:Number('Customers State ID', {
                                current = saleData.customer
                            }, function(data)
                                saleData.customer = data.data.value
                            end)
                            salesMenuSub[cashSaleIdentifier].Add:Button('Send Sale Request', { success = true }, function()
                                TriggerServerEvent('Dealerships:Server:StartSale', dealerId, 'full', {
                                    vehicle = v.vehicle,
                                    customer = saleData.customer,
                                    profitPercentage = saleData.profit or dealerData.profitPercents.min,
                                })
                                salesMenu:Close()
                            end)
                            --salesMenuSub[cashSaleIdentifier].Add:SubMenuBack('Go Back', {})

        

                            -- Loan Sales Menu
                            salesMenuSub[loanSaleIdentifier] = Menu:Create('salesMenu-'.. loanSaleIdentifier, vehName .. ' - New Sale')
        
                            local saleTextElem = salesMenuSub[loanSaleIdentifier].Add:Text(VehicleSalesGetLoanText(dealerMData, dealerData, v, loanData, defaultInterestRate), { 'code', 'pad' })

                            salesMenuSub[loanSaleIdentifier].Add:Slider('Down Payment %', {
                                current = loanData.downpayment,
                                min = 25,
                                max = 80,
                                step = 5,
                            }, function(data)
                                loanData.downpayment = data.data.value
                                salesMenuSub[loanSaleIdentifier].Update:Item(saleTextElem, VehicleSalesGetLoanText(dealerMData, dealerData, v, loanData, defaultInterestRate), { 'code', 'pad' })
                            end)

                            salesMenuSub[loanSaleIdentifier].Add:Slider('Loan Length (Weeks)', {
                                current = loanData.weeks,
                                min = 6,
                                max = 16,
                                step = 1,
                            }, function(data)
                                loanData.weeks = data.data.value
                                salesMenuSub[loanSaleIdentifier].Update:Item(saleTextElem, VehicleSalesGetLoanText(dealerMData, dealerData, v, loanData, defaultInterestRate), { 'code', 'pad' })
                            end)
                            salesMenuSub[loanSaleIdentifier].Add:Number('Customers State ID', {
                                current = saleData.customer
                            }, function(data)
                                saleData.customer = data.data.value
                            end)
                            salesMenuSub[loanSaleIdentifier].Add:Button('Send Sale Request', { success = true }, function()
                                TriggerServerEvent('Dealerships:Server:StartSale', dealerId, 'loan', {
                                    vehicle = v.vehicle,
                                    customer = saleData.customer,
                                    downPayment = loanData.downpayment,
                                    loanWeeks = loanData.weeks,
                                })
                                salesMenu:Close()
                            end)
                            --salesMenuSub[loanSaleIdentifier].Add:SubMenuBack('Go Back', {})



                            salesMenuSub[vehMenuIdentifier].Add:SubMenu('Sell (As Full Payment)', salesMenuSub[cashSaleIdentifier], {})
                            salesMenuSub[vehMenuIdentifier].Add:SubMenu('Sell (As Loan)', salesMenuSub[loanSaleIdentifier], {})

                            salesMenuSub[vehMenuIdentifier].Add:SubMenuBack('Go Back', {})
                            salesMenuSub[category].Add:SubMenu(vehName, salesMenuSub[vehMenuIdentifier], {})
                        end
                    end
        
                    salesMenuSub[category].Add:SubMenuBack('Go Back', {})
                    salesMenu.Add:SubMenu(_catalogCategories[category], salesMenuSub[category], {})
                end
            end
    
            salesMenu:Show()
        end)
    end
end


function VehicleSalesGetCashText(dealerMData, dealerData, vehData)
    local priceMultiplier = 1 + (dealerMData.profitPercentage / 100)
    local salePrice = Utils:Round(vehData.price * priceMultiplier, 0)
    local dealerProfit = salePrice - vehData.price
    local earnedCommission = Utils:Round(dealerProfit * (dealerMData.commission / 100), 0)

    return string.format(
        [[
            Selling Vehicle: %s %s<br>
            Customer Pays: $%s<br>
            Your Earned Commission: $%s<br>
        ]],
        vehData.make,
        vehData.model,
        formatNumberToCurrency(math.floor(salePrice)),
        formatNumberToCurrency(math.floor(earnedCommission))
    )
end

function VehicleSalesGetLoanText(dealerMData, dealerData, vehData, loanData, defaultInterest)
    local priceMultiplier = 1 + (dealerMData.profitPercentage / 100)
    local salePrice = Utils:Round(vehData.price * priceMultiplier, 0)
    local dealerProfit = salePrice - vehData.price
    local earnedCommission = Utils:Round(dealerProfit * (dealerMData.commission / 100), 0)

    local downPayment = Utils:Round(salePrice * (loanData.downpayment / 100), 0)
    local salePriceAfterDown = salePrice - downPayment

    local afterInterest = Utils:Round(salePriceAfterDown * (1 + (defaultInterest / 100)), 0)
    local perWeek = Utils:Round((afterInterest / loanData.weeks), 0)

    return string.format(
        [[
            Selling Vehicle: %s %s<br>
            Loan Interest Rate: %s%%<br>
            Downpayment: %s%% ($%s)<br>
            Remaining Cost With Interest Applied: $%s<br>
            Loan Length (Weeks): %s<br>
            Weekly Payment: $%s<br>
            Your Earned Commission: $%s<br>
        ]],
        vehData.make,
        vehData.model,
        defaultInterest,
        loanData.downpayment,
        formatNumberToCurrency(math.floor(downPayment)),
        formatNumberToCurrency(math.floor(afterInterest)),
        loanData.weeks,
        formatNumberToCurrency(math.floor(perWeek)),
        formatNumberToCurrency(math.floor(earnedCommission))
    )
end