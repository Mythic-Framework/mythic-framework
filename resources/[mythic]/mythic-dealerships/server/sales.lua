RegisterNetEvent('Dealerships:Server:StartSale', function(dealership, type, data)
    
end)

function RegisterVehicleSaleCallbacks()
    Callbacks:RegisterServerCallback('Dealerships:Sales:StartSale', function(source, saleData, cb)
        local dealership = saleData?.dealership
        local type = saleData?.type
        local data = saleData?.data

        if dealership and type and data then
            local dealerData = _dealerships[dealership]
            local customerStateId, vehicle = math.tointeger(data.customer), data.vehicle
            local char = Fetch:Source(source):GetData('Character')
            if char and dealerData and customerStateId and vehicle and Jobs.Permissions:HasPermissionInJob(source, dealerData.id, 'dealership_sell') then
                local targetPlayer = Fetch:SID(customerStateId)
                if targetPlayer then
                    local targetCharacter = targetPlayer:GetData('Character')
                    if targetCharacter then
                        local playerCoords = GetEntityCoords(GetPlayerPed(source))
                        local targetCoords = GetEntityCoords(GetPlayerPed(targetCharacter:GetData('Source')))
                        if #(playerCoords - targetCoords) <= 15.0 then
                            local targetSrc = targetCharacter:GetData('Source')
    
                            local profitPercent = Dealerships.Management:GetData(dealership, 'profitPercentage')
                            local commissionPercent = Dealerships.Management:GetData(dealership, 'commission')
    
                            local saleVehicleData = Dealerships.Stock:FetchDealerVehicle(dealerData.id, vehicle)
                            if profitPercent and commissionPercent and saleVehicleData and saleVehicleData.quantity > 0 and saleVehicleData.data.price and saleVehicleData.data.price > 0 then
                                local vehiclePrice = saleVehicleData.data.price
                                local priceMultiplier = 1 + (profitPercent / 100)
                                local commissionMultiplier = (commissionPercent / 100)
                                local salePrice = Utils:Round(vehiclePrice * priceMultiplier, 0)
    
                                local playerCommission = Utils:Round((salePrice - vehiclePrice) * commissionMultiplier, 0)
                                local dealerRecieves = Utils:Round(salePrice - playerCommission, 0)
    
    
                                if type == 'full' then
                                    Billing:Create(targetSrc, dealerData.abbreviation .. ' - Sales', salePrice, '', function(wasPayed, withAccount)
                                        if wasPayed then
                                            local removeSuccess = Dealerships.Stock:Remove(dealerData.id, saleVehicleData.vehicle, 1)
                                            if removeSuccess then
                                                Vehicles.Owned:AddToCharacter(targetCharacter:GetData('SID'), GetHashKey(saleVehicleData.vehicle), 0, { 
                                                    make = saleVehicleData.data.make,
                                                    model = saleVehicleData.data.model,
                                                    class = saleVehicleData.data.class,
                                                    value = salePrice,
                                                }, function(success, vehicleData)
                                                    if success and vehicleData then
                                                        Dealerships.Records:Create(dealerData.id, {
                                                            time = os.time(),
                                                            type = type,
                                                            vehicle = {
                                                                VIN = vehicleData.VIN,
                                                                vehicle = saleVehicleData.vehicle,
                                                                data = saleVehicleData.data,
                                                            },
                                                            profitPercent = profitPercent,
                                                            salePrice = salePrice,
                                                            dealerProfits = dealerRecieves,
                                                            commission = playerCommission,
                                                            seller = {
                                                                ID = char:GetData('ID'),
                                                                SID = char:GetData('SID'),
                                                                First = char:GetData('First'),
                                                                Last = char:GetData('Last'),
                                                            },
                                                            buyer = {
                                                                ID = targetCharacter:GetData('ID'),
                                                                SID = targetCharacter:GetData('SID'),
                                                                First = targetCharacter:GetData('First'),
                                                                Last = targetCharacter:GetData('Last'),
                                                            },
                                                            newQuantity = removeSuccess,
                                                        })
            
                                                        Execute:Client(source, 'Notification', 'Success', 'Completed Sales Process - The Customer Received their Vehicle', 7500, 'car')
                                                        SendCompletedCashSaleEmail({
                                                            SID = targetCharacter:GetData('SID'),
                                                            First = targetCharacter:GetData('First'),
                                                            Last = targetCharacter:GetData('Last'),
                                                            Source = targetSrc,
                                                        }, dealerData, saleVehicleData.data, salePrice, vehicleData.VIN, vehicleData.RegisteredPlate)
                                                        
                                                        SendDealerProfits(dealerData, dealerRecieves, char:GetData('BankAccount'), playerCommission, saleVehicleData.data, {
                                                            SID = targetCharacter:GetData('SID'),
                                                            First = targetCharacter:GetData('First'),
                                                            Last = targetCharacter:GetData('Last'),
                                                            Source = targetSrc,
                                                        })

                                                        if salePrice >= 50000 then
                                                            local creditIncrease = math.floor(salePrice / 2000)
                                                            if creditIncrease > 150 then
                                                                creditIncrease = 150
                                                            end

                                                            Loans.Credit:Increase(targetCharacter:GetData('SID'), creditIncrease)
                                                        end
                                                    else
                                                        Execute:Client(source, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car')
                                                        Execute:Client(targetSrc, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car')
                                                    end
                                                end, false, dealerData.storage)
                                            else
                                                Execute:Client(source, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car')
                                                Execute:Client(targetSrc, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car')
                                            end
                                        else
                                            Execute:Client(source, 'Notification', 'Error', 'Payment Failed', 5000, 'car')
                                        end
                                    end)

                                    cb(true, 'Initiating Sales Process')
                                elseif type == 'loan' then
    
                                    local loanData = Loans:GetAllowedLoanAmount(targetCharacter:GetData('SID'))
                                    local hasLoans = Loans:GetPlayerLoans(targetCharacter:GetData('SID'), 'vehicle')
    
                                    if #hasLoans <= 1 then
                                        if loanData and loanData.maxBorrowable and loanData.maxBorrowable > 0 then
                                            local defaultInterestRate = Loans:GetDefaultInterestRate()
                                            local downPaymentPercent, loanWeeks = math.tointeger(data.downPayment), math.tointeger(data.loanWeeks)
            
                                            if downPaymentPercent and loanWeeks and defaultInterestRate then
            
                                                local downPayment = Utils:Round(salePrice * (downPaymentPercent / 100), 0)
                                                local salePriceAfterDown = salePrice - downPayment
                                                local afterInterest = Utils:Round(salePriceAfterDown * (1 + (defaultInterestRate / 100)), 0)
            
                                                local perWeek = Utils:Round(afterInterest / loanWeeks, 0)
            
                                                if loanData.maxBorrowable >= salePriceAfterDown then
                                                    SendPendingLoanEmail({
                                                        SID = targetCharacter:GetData('SID'),
                                                        First = targetCharacter:GetData('First'),
                                                        Last = targetCharacter:GetData('Last'),
                                                        Source = targetSrc,
                                                    }, dealerData, saleVehicleData.data, downPaymentPercent, downPayment, loanWeeks, perWeek, salePriceAfterDown, function()
                                                        Execute:Client(source, 'Notification', 'Info', 'The Loan Terms Were Accepted by the Customer', 5000, 'car')
                                                        Billing:Create(
                                                            targetSrc, 
                                                            dealerData.name, 
                                                            downPayment,
                                                            string.format('Vehicle Loan Downpayment, %s %s', saleVehicleData.data.make, saleVehicleData.data.model),
                                                            function(wasPayed, withAccount)
                                                                if wasPayed then
                                                                    local preGenerateVIN = Vehicles.Identification.VIN:GenerateOwned()
                                                                    local loanSuccess = Loans:CreateVehicleLoan(targetSrc, preGenerateVIN, salePrice, downPayment, loanWeeks)
                                                                    local removeSuccess = Dealerships.Stock:Remove(dealerData.id, saleVehicleData.vehicle, 1)
    
                                                                    if loanSuccess and removeSuccess then
                                                                        Vehicles.Owned:AddToCharacter(targetCharacter:GetData('SID'), GetHashKey(saleVehicleData.vehicle), 0, { 
                                                                            make = saleVehicleData.data.make,
                                                                            model = saleVehicleData.data.model,
                                                                            class = saleVehicleData.data.class,
                                                                            value = saleVehicleData.data.price
                                                                        }, function(success, vehicleData)
                                                                            if success and vehicleData then
                                                                                Dealerships.Records:Create(dealerData.id, {
                                                                                    time = os.time(),
                                                                                    type = type,
                                                                                    loan = {
                                                                                        length = loanWeeks,
                                                                                        downPayment = downPayment,
                                                                                    },
                                                                                    vehicle = {
                                                                                        VIN = vehicleData.VIN,
                                                                                        vehicle = saleVehicleData.vehicle,
                                                                                        data = saleVehicleData.data,
                                                                                    },
                                                                                    profitPercent = profitPercent,
                                                                                    salePrice = salePrice,
                                                                                    dealerProfits = dealerRecieves,
                                                                                    commission = playerCommission,
                                                                                    seller = {
                                                                                        ID = char:GetData('ID'),
                                                                                        SID = char:GetData('SID'),
                                                                                        First = char:GetData('First'),
                                                                                        Last = char:GetData('Last'),
                                                                                    },
                                                                                    buyer = {
                                                                                        ID = targetCharacter:GetData('ID'),
                                                                                        SID = targetCharacter:GetData('SID'),
                                                                                        First = targetCharacter:GetData('First'),
                                                                                        Last = targetCharacter:GetData('Last'),
                                                                                    },
                                                                                    newQuantity = removeSuccess,
                                                                                })
                
                                                                                Execute:Client(source, 'Notification', 'Success', 'Completed Sales Process - The Customer Received their Vehicle', 7500, 'car')
                                                                                SendCompletedLoanSaleEmail({
                                                                                    SID = targetCharacter:GetData('SID'),
                                                                                    First = targetCharacter:GetData('First'),
                                                                                    Last = targetCharacter:GetData('Last'),
                                                                                    Source = targetSrc,
                                                                                }, dealerData, saleVehicleData.data, downPaymentPercent, downPayment, loanWeeks, perWeek, salePriceAfterDown, vehicleData.VIN, vehicleData.RegisteredPlate)
                
                                                                                SendDealerProfits(dealerData, dealerRecieves, char:GetData('BankAccount'), playerCommission, saleVehicleData.data, {
                                                                                    SID = targetCharacter:GetData('SID'),
                                                                                    First = targetCharacter:GetData('First'),
                                                                                    Last = targetCharacter:GetData('Last'),
                                                                                    Source = targetSrc,
                                                                                })
                                                                            else
                                                                                Execute:Client(source, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car')
                                                                                Execute:Client(targetSrc, 'Notification', 'Error', 'Error Completing Vehicle Sale', 5000, 'car')
                                                                            end
                                                                        end, false, dealerData.storage, preGenerateVIN)
                                                                    end
                                                                else
                                                                    Execute:Client(source, 'Notification', 'Error', 'Loan Downpayment Failed', 5000, 'car')
                                                                end
                                                            end
                                                        )
                                                    end)

                                                    cb(true, 'Initiating Sales Process')
                                                else
                                                    cb(false, 'Person Doesn\'t Qualify for Loan')
                                                end
                                            else
                                                cb(false, 'Error Initiating Sale')
                                            end
                                        else
                                            cb(false, 'Person Doesn\'t Qualify for Loan')
                                        end
                                    else
                                        cb(false, 'Person Has a Vehicle Loan')
                                    end
                                else
                                    cb(false, 'Error Initiating Sale')
                                end
                            else
                                cb(false, 'Vehicle Isn\'t In Stock')
                            end
                        else
                            cb(false, 'The Customer is Required to be Present')
                        end

                        return
                    end
                end
            end

            cb(false, 'Ensure that the Customer\'s State ID is Correct')
        else
            cb(false, 'Error Initiating Sale')
        end
    end)
end

function SendCompletedCashSaleEmail(charData, dealerData, vehicleInfoData, price, VIN, plate)
    Phone.Email:Send(
        charData.Source,
        dealerData.emails.sales,
        os.time() * 1000,
        string.format('Vehicle Purchase - %s %s', vehicleInfoData.make, vehicleInfoData.model),
        string.format(
            [[
                Dear %s %s,
                We thank you for completing your purchase of a <b>%s %s</b> for $%s, it has been a pleasure doing business with you.
                Your new vehicle will be delivered as quickly as possible.<br><br>
                The Vehicle VIN is <b>%s</b><br>
                The Vehicle License Plate is <b>%s</b><br>
                <br><br>
                Thanks, %s
            ]],
            charData.First,
            charData.Last,
            vehicleInfoData.make,
            vehicleInfoData.model,
            formatNumberToCurrency(math.floor(price)),
            VIN,
            plate,
            dealerData.name
        ),
        {}
    )
end

local _pendingLoanAccept = {}

function SendPendingLoanEmail(charData, dealerData, vehicleInfoData, downPaymentPercent, downPayment, loanWeeks, weeklyPayments, remaining, cb)
    if not _pendingLoanAccept[charData.SID] then
        _pendingLoanAccept[charData.SID] = cb
        Phone.Email:Send(
            charData.Source,
            dealerData.emails.loans,
            os.time() * 1000,
            string.format('Vehicle Loan - %s %s', vehicleInfoData.make, vehicleInfoData.model),
            string.format(
                [[
                    Dear %s %s, 
                    Thank you for applying for a vehicle loan for a %s %s. The terms of this loan are set out below.<br><br>
                    Down payment: <b>$%s</b> (%s%%)<br>
                    Remaining Amount Owed: <b>$%s</b> (Interest Applied)<br>
                    Loan Length: <b>%s Weeks</b><br>
                    Weekly Payments: <b>$%s</b><br><br>

                    Missing loan payments will lead to an increase in the loans interest rate and a missed payment fee.
                    It may also lead to the eventual seizure of your vehicle by the State of San Andreas.
                    <br><br>
                    If you agree with these terms, please click the link attached above to begin the loan acceptance process.
                    <br><br>
                    Thanks, %s
                ]],
                charData.First,
                charData.Last,
                vehicleInfoData.make,
                vehicleInfoData.model,
                formatNumberToCurrency(math.floor(downPayment)),
                downPaymentPercent,
                formatNumberToCurrency(math.floor(remaining)),
                loanWeeks,
                formatNumberToCurrency(math.floor(weeklyPayments)),
                dealerData.name
            ),
            {
                hyperlink = {
                    event = 'Dealerships:Server:AcceptLoan',
                },
                expires = (os.time() + (60 * 5)) * 1000,
            }
        )

        SetTimeout(60000 * 5, function()
            _pendingLoanAccept[charData.SID] = nil
        end)
    else
        cb(false, 1)
    end
end

RegisterNetEvent('Dealerships:Server:AcceptLoan', function(_, email)
    local src = source
    local char = Fetch:Source(src):GetData('Character')
    if char then
        Phone.Email:Delete(char:GetData('ID'), email)
        local stateId = char:GetData('SID')

        if _pendingLoanAccept[stateId] then
            _pendingLoanAccept[stateId]()
            _pendingLoanAccept[stateId] = nil
        end
    end
end)


function SendCompletedLoanSaleEmail(charData, dealerData, vehicleInfoData, downPaymentPercent, downPayment, loanWeeks, weeklyPayments, remaining, VIN, plate)
    Phone.Email:Send(
        charData.Source,
        dealerData.emails.loans,
        os.time() * 1000,
        string.format('Vehicle Loan - %s %s', vehicleInfoData.make, vehicleInfoData.model),
        string.format(
            [[
                Dear %s %s, 
                Thank you for taking out a vehicle loan for a %s %s, it has been a pleasure doing business with you.
                Your new vehicle will be delivered as quickly as possible.<br><br>
                
                The Vehicle VIN is <b>%s</b><br>
                The Vehicle License Plate is <b>%s</b><br>
                <br><br>
                
                The terms of this loan are set out below.<br><br>
                Down payment: <b>$%s</b> (%s%%)<br>
                Remaining Amount Owed: <b>$%s</b> (Interest Applied)<br>
                Loan Length: <b>%s Weeks</b><br>
                Weekly Payments: <b>$%s</b><br><br>

                Missing loan payments will lead to an increase in the loans interest rate and a missed payment fee.
                It may also lead to the eventual seizure of your vehicle by the State of San Andreas.
                <br><br>
                Thanks, %s
            ]],
            charData.First,
            charData.Last,
            vehicleInfoData.make,
            vehicleInfoData.model,
            VIN,
            plate,
            formatNumberToCurrency(math.floor(downPayment)),
            downPaymentPercent,
            formatNumberToCurrency(math.floor(remaining)),
            loanWeeks,
            formatNumberToCurrency(math.floor(weeklyPayments)),
            dealerData.name
        )
    )
end

function SendDealerProfits(dealerData, dealerProfits, playerBankAccount, playerProfits, vehicleInfoData, buyerData)
    local dealerAccount = Banking.Accounts:GetOrganization(dealerData.id)
    if dealerAccount then
        Banking.Balance:Deposit(dealerAccount.Account, math.floor(dealerProfits), {
            type = 'transfer',
            title = 'Vehicle Purchase',
            description = string.format('Vehicle Sale of a %s %s to %s %s (State ID %s)', vehicleInfoData.make, vehicleInfoData.model, buyerData.First, buyerData.Last, buyerData.SID),
            data = {},
        })
    end

    Banking.Balance:Deposit(playerBankAccount, math.floor(playerProfits), {
        type = 'transfer',
        title = dealerData.abbreviation .. ' - Commission',
        description = string.format('Vehicle Sale Commission from your %s employment.', dealerData.name),
        data = {}
    })
end
