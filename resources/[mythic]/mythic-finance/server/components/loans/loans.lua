local _ranStartup = false

function RunLoanStartup()
    if _ranStartup then return end
    _ranStartup = true

    Database.Game:count({
        collection = 'loans',
        query = {
            Remaining = {
                ['$gt'] = 0,
            }
        }
    }, function(success, count)
        if success then
            Logger:Trace('Loans', 'Loaded ^2' .. count .. '^7 Active Loans')
        end
    end)
end

AddEventHandler('Finance:Server:Startup', function()
    RunLoanStartup()
    RegisterLoanCallbacks()

    CreateLoanTasks()
end)

function CreateLoanTasks()
    Tasks:Register('loan_payment', 60, function()
    --RegisterCommand('testloans', function()
        local TASK_RUN_TIMESTAMP = os.time()

        Database.Game:aggregate({
            collection = 'loans',
            aggregate = {
                {
                    ['$match'] = {
                        ['$and'] = {
                            { -- Due now
                                NextPayment = { 
                                    ['$gt'] = 0,
                                    ['$lte'] = (TASK_RUN_TIMESTAMP)
                                }
                            },
                            { -- There is still cost remaining
                                Defaulted = false,
                                Remaining = { 
                                    ['$gte'] = 0 
                                } 
                            },
                        }
                    }
                },
                {
                    ['$set'] = {
                        InterestRate = {
                            ['$add'] = { '$InterestRate', _loanConfig.missedPayments.interestIncrease }
                        },
                        LastMissedPayment = TASK_RUN_TIMESTAMP,
                        MissedPayments = {
                            ['$add'] = { '$MissedPayments', 1 },
                        },
                        TotalMissedPayments = {
                            ['$add'] = { '$TotalMissedPayments', 1 },
                        },
                        NextPayment = {
                            ['$add'] = { '$NextPayment', _loanConfig.paymentInterval },
                        },
                        Remaining = {
                            ['$add'] = { 
                                '$Remaining',
                                { ['$multiply'] = { '$Total', (_loanConfig.missedPayments.charge / 100) } }
                            }
                        }
                    },
                },
                {
                    ['$merge'] = {
                        into = 'loans',
                        on = '_id',
                        whenMatched = 'replace',
                        whenNotMatched = 'discard',
                    }
                }
            }
        }, function(success, results)
            if success then
                -- Get All the Loans are now need to be defaulted and notify/seize
                Database.Game:find({
                    collection = 'loans',
                    query = {
                        ['$expr'] = {
                            ['$gte'] = {
                                "$MissedPayments",
                                "$MissablePayments"
                            }
                        },
                        Defaulted = false,
                    }
                }, function(success, results)
                    if success and #results > 0 then
                        local updatingAssets = {}

                        for k, v in ipairs(results) do
                            table.insert(updatingAssets, v.AssetIdentifier)
                        end

                        Database.Game:update({
                            collection = 'loans',
                            query = {
                                AssetIdentifier = {
                                    ['$in'] = updatingAssets
                                }
                            },
                            update = {
                                ['$set'] = {
                                    Defaulted = true,
                                }
                            }
                        }, function(success, updated)
                            if success then
                                Logger:Info('Loans', '^2' .. #results .. '^7 Loans Have Just Been Defaulted')
                                for k, v in ipairs(results) do
                                    if v.SID then
                                        DecreaseCharacterCreditScore(v.SID, _creditScoreConfig.removal.defaultedLoan)
                                        local onlineChar = Fetch:SID(v.SID)
                                        if onlineChar then
                                            SendDefaultedLoanNotification(onlineChar:GetData('Source'), v)
                                        end
                                    end

                                    if v.AssetIdentifier then
                                        if v.Type == 'vehicle' then
                                            Vehicles.Owned:Seize(v.AssetIdentifier, true)
                                        elseif v.Type == 'property' then
                                            -- TODO: PROPERTY TEMP SEIZURE
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end)

                -- Notify if someone just missed a payment.
                Database.Game:find({
                    collection = 'loans',
                    query = {
                        ['$expr'] = {
                            ['$lt'] = {
                                "$MissedPayments",
                                "$MissablePayments"
                            }
                        },
                        Defaulted = false,
                        LastMissedPayment = TASK_RUN_TIMESTAMP,
                    }
                }, function(success, results)
                    if success and #results > 0 then
                        Logger:Info('Loans', '^2' .. #results .. '^7 Loan Payments Were Just Missed')
                        for k, v in ipairs(results) do
                            if v.SID then
                                DecreaseCharacterCreditScore(v.SID, _creditScoreConfig.removal.missedLoanPayment)

                                local onlineChar = Fetch:SID(v.SID)
                                if onlineChar then
                                    SendMissedLoanNotification(onlineChar:GetData('Source'), v)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end)

    Tasks:Register('loan_reminder', 120, function()
        local TASK_RUN_TIMESTAMP = os.time()
        -- Get All Loans That are Due Soon
        Database.Game:find({
            collection = 'loans',
            query = {
                Remaining = {
                    ['$gt'] = 0,
                },
                Defaulted = false,
                ['$or'] = {
                    { -- The payment is due soon
                        NextPayment = {
                            ['$gt'] = 0,
                            ['$lte'] = (TASK_RUN_TIMESTAMP + (60 * 60 * 6)), -- Payment is due within the next 6 hours
                        }
                    },
                    { -- The last payment was missed, annoy them by constantly sending them notifications
                        MissedPayments = {
                            ['$gt'] = 0,
                        }
                    },
                }
            }
        }, function(success, results)
            print("this might hitch the server (loan_reminder task)")
            if success and #results > 0 then
                for k, v in ipairs(results) do
                    if v.SID then
                        local onlineChar = Fetch:SID(v.SID)
                        if onlineChar then
                            Phone.Notification:Add(onlineChar:GetData("Source"), "Loan Payment Due", "You have a loan payment that is due very soon.", os.time() * 1000, 7500, "loans", {})
                        end

                        Wait(100)
                    end
                end
            end
        end)
    end)
end

function SendMissedLoanNotification(source, loanData)
    Phone.Notification:Add(source, "Loan Payment Missed", "You just missed a loan payment on one of your loans.", os.time() * 1000, 7500, "loans", {})
end

function SendDefaultedLoanNotification(source, loanData)
    Phone.Notification:Add(source, "Loan Defaulted", "One of your loans just got defaulted and the assets are going to be seized.", os.time() * 1000, 7500, "loans", {})
end

local typeNames = {
    vehicle = 'Vehicle Loan',
    property = 'Property Loan',
}

function GetLoanTypeName(type)
    return typeNames[type]
end