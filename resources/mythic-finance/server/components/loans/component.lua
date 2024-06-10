_LOANS = {
    GetAllowedLoanAmount = function(self, stateId, type)
        if not type then type = 'vehicle' end
        if _creditScoreConfig.allowedLoanMultipliers[type] then
            local creditScore = GetCharacterCreditScore(stateId)

            local creditMult = 0
            for k, v in ipairs(_creditScoreConfig.allowedLoanMultipliers[type]) do
                if creditScore >= v.value then
                    creditMult = v.multiplier
                else
                    break
                end
            end

            return {
                creditScore = creditScore,
                maxBorrowable = creditScore * creditMult,
            }
        end
    end,
    GetDefaultInterestRate = function(self)
        return _loanConfig.defaultInterestRate
    end,
    GetPlayerLoans = function(self, stateId, type)
        local p = promise.new()
        Database.Game:find({
            collection = 'loans',
            query = {
                SID = stateId,
                Type = type,
                ['$or'] = {
                    {
                        Remaining = {
                            ['$gt'] = 0,
                        }
                    },
                    {
                        Remaining = 0,
                        LastPayment = {
                            ['$gte'] = os.time() + (60 * 60 * 24 * 1)
                        }
                    }
                }
            }
        }, function(success, results)
            if not success then
                p:resolve(false)
                return
            end
            p:resolve(results)
        end)
        return Citizen.Await(p)
    end,
    CreateVehicleLoan = function(self, targetSource, VIN, totalCost, downPayment, totalWeeks)
        local char = Fetch:Source(targetSource):GetData('Character')
        if char then
            local p = promise.new()
            local remainingCost = totalCost - downPayment
            local timeStamp = os.time()

            local doc = {
                Creation = timeStamp,
                SID = char:GetData('SID'),
                Type = 'vehicle',
                AssetIdentifier = VIN,
                Defaulted = false,
                InterestRate = _loanConfig.defaultInterestRate,
                Total = totalCost,
                Remaining = remainingCost,
                Paid = downPayment,
                DownPayment = downPayment,
                TotalPayments = totalWeeks,
                PaidPayments = 0,
                MissablePayments = _loanConfig.missedPayments.limit,
                MissedPayments = 0,
                TotalMissedPayments = 0,
                NextPayment = timeStamp + _loanConfig.paymentInterval,
                LastPayment = 0,
            }

            Database.Game:insertOne({
                collection = 'loans',
                document = doc,
            }, function(success, inserted)
                if success and inserted > 0 then
                    p:resolve(true)
                else
                    p:resolve(false)
                end
            end)

            local res = Citizen.Await(p)
            return res
        end
        return false
    end,
    CreatePropertyLoan = function(self, targetSource, propertyId, totalCost, downPayment, totalWeeks)
        local char = Fetch:Source(targetSource):GetData('Character')
        if char then
            local p = promise.new()
            local remainingCost = totalCost - downPayment
            local timeStamp = os.time()

            local doc = {
                Creation = timeStamp,
                SID = char:GetData('SID'),
                Type = 'property',
                AssetIdentifier = propertyId,
                Defaulted = false,
                InterestRate = _loanConfig.defaultInterestRate,
                Total = totalCost,
                Remaining = remainingCost,
                Paid = downPayment,
                DownPayment = downPayment,
                TotalPayments = totalWeeks,
                PaidPayments = 0,
                MissablePayments = _loanConfig.missedPayments.limit,
                MissedPayments = 0,
                TotalMissedPayments = 0,
                NextPayment = timeStamp + _loanConfig.paymentInterval,
                LastPayment = 0,
            }

            Database.Game:insertOne({
                collection = 'loans',
                document = doc,
            }, function(success, inserted)
                if success and inserted > 0 then
                    p:resolve(true)
                else
                    p:resolve(false)
                end
            end)

            local res = Citizen.Await(p)
            return res
        end
        return false
    end,
    MakePayment = function(self, source, loanId, inAdvanced, advancedPaymentCount)
        local char = Fetch:Source(source):GetData('Character')
        if char then
            local SID = char:GetData('SID')
            local Account = char:GetData('BankAccount')
            local loan = GetLoanByID(loanId, SID)
            if loan then
                local timeStamp = os.time()

                local remainingPayments = loan.TotalPayments - loan.PaidPayments

                local totalCreditGained = _creditScoreConfig.addition.loanPaymentMin
                if loan.Total >= 50000 then
                    totalCreditGained += (math.floor(loan.Total / 50000) * 10)

                    if totalCreditGained > _creditScoreConfig.addition.loanPaymentMax then
                        totalCreditGained = _creditScoreConfig.addition.loanPaymentMax
                    end
                end

                if remainingPayments > 0 and loan.Remaining > 0 then
                    local interestMult = ((100 + loan.InterestRate) / 100)
                    local creditScoreIncrease = 0
                    local actuallyAdvancedPayments = 0
                    local payments = 1
                    if loan.MissedPayments > 0 then
                        payments = loan.MissedPayments

                        if payments > remainingPayments then
                            payments = remainingPayments
                        end

                        creditScoreIncrease += math.floor(((totalCreditGained / loan.TotalPayments) * payments) / 2)
                    else
                        local timeUntilDue = loan.NextPayment - timeStamp
                        local doneMinLoanLength = (timeStamp - loan.Creation) >= (60 * 60 * 24 * 10)

                        if timeUntilDue >= (_loanConfig.paymentInterval * 4) and not doneMinLoanLength then -- Can only pay 2 weeks in advanced or wait until loan is 1 week old
                            return {
                                success = false,
                                message = 'Can\'t Pay That Far in Advanced - Hold Loan For At Least 10 Days',
                            }
                        end

                        local loanPaymentCreditIncrease = math.floor(totalCreditGained / loan.TotalPayments)
                        creditScoreIncrease += loanPaymentCreditIncrease

                        local earlyTime = loan.NextPayment - (_loanConfig.paymentInterval * 0.5)
                        if timeStamp <= earlyTime then -- Well Done You Are Early
                            creditScoreIncrease += 2
                        end
                    end

                    -- TODO: (maybe) Interest Going to the Government Account?

                    local dueAmount = math.ceil(((loan.Remaining / remainingPayments) * payments) * interestMult)
                    local chargeSuccess = Banking.Balance:Charge(Account, dueAmount, {
                        type = 'loan',
                        title = 'Loan Payment',
                        description = string.format('Loan Payment for %s %s', GetLoanTypeName(loan.Type), loan.AssetIdentifier),
                        data = {
                            loan = loan._id,
                        }
                    })

                    if chargeSuccess then
                        local updateQuery
                        local loanPaidOff = false
                        local nowRemainingPayments = remainingPayments - payments
                        if nowRemainingPayments <= 0 then
                            loanPaidOff = true
                        end


                        if loan.Defaulted then -- Unseize Assets
                            if loan.Type == 'vehicle' then
                                Vehicles.Owned:Seize(loan.AssetIdentifier, false)
                            elseif loan.Type == 'property' then

                            end
                        end

                        if loanPaidOff then
                            if loan.TotalMissedPayments <= 0 then
                                creditScoreIncrease += _creditScoreConfig.addition.completingLoanNoMissed
                            else
                                creditScoreIncrease += _creditScoreConfig.addition.completingLoan
                            end

                            updateQuery = {
                                ['$set'] = {
                                    LastPayment = timeStamp,
                                    NextPayment = 0,
                                    Remaining = 0,
                                    Defaulted = false,
                                },
                                ['$inc'] = {
                                    Paid = dueAmount,
                                    PaidPayments = payments,
                                }
                            }
                        else
                            updateQuery = {
                                ['$set'] = {
                                    LastPayment = timeStamp,
                                    NextPayment = (loan.NextPayment + _loanConfig.paymentInterval),
                                    Defaulted = false,
                                },
                                ['$inc'] = {
                                    Paid = dueAmount,
                                    PaidPayments = payments,
                                    Remaining = -dueAmount,
                                },
                            }

                            if loan.MissedPayments > 0 then
                                updateQuery['$set']['MissedPayments'] = 0
                                updateQuery['$set']['MissablePayments'] = math.max(1, loan.MissablePayments - loan.MissedPayments)
                            end
                        end

                        local updated = UpdateLoanById(loan._id, updateQuery)

                        if creditScoreIncrease > 0 then
                            IncreaseCharacterCreditScore(SID, creditScoreIncrease)
                        end

                        if updated then
                            return {
                                success = true,
                                paidOff = loanPaidOff,
                                paymentAmount = dueAmount,
                                creditIncrease = creditScoreIncrease,
                            }
                        end
                    else
                        return {
                            success = false,
                            message = 'Insufficient Funds in Checking Account',
                        }
                    end
                end
            end
        end
        return {
            success = false,
        }
    end,
    HasRemainingPayments = function(self, assetType, assetId)
        local p = promise.new()

        Database.Game:findOne({
            collection = 'loans',
            query = {
                Type = assetType,
                AssetIdentifier = assetId,
            }
        }, function(success, results)
            if success and #results > 0 then
                local l = results[1]
                if l and l.Remaining and l.Remaining > 0 then
                    p:resolve(true)
                else
                    p:resolve(false)
                end
            else
                p:resolve(false)
            end
        end)

        return Citizen.Await(p)
    end,
    Credit = {
        Get = function(self, stateId)
            return GetCharacterCreditScore(stateId)
        end,
        Set = function(self, stateId, newVal)
            return SetCharacterCreditScore(stateId, newVal)
        end,
        Increase = function(self, stateId, increase)
            return IncreaseCharacterCreditScore(stateId, increase)
        end,
        Decrease = function(self, stateId, decrease)
            return DecreaseCharacterCreditScore(stateId, decrease)
        end,
    }
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Loans", _LOANS)
end)

function GetLoanByID(loanId, stateId)
    local p = promise.new()
    Database.Game:findOne({
        collection = 'loans',
        query = {
            _id = loanId,
            SID = stateId,
        }
    }, function(success, results)
        if success and #results > 0 then
            p:resolve(results[1])
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function UpdateLoanById(loanId, update)
    local p = promise.new()
    Database.Game:updateOne({
        collection = 'loans',
        query = {
            _id = loanId,
        },
        update = update,
    }, function(success, updated)
        if success and updated > 0 then
            p:resolve(true)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end