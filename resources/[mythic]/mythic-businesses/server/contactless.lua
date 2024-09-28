_pendingContactless = {}

AddEventHandler("Businesses:Server:Startup", function()
    Callbacks:RegisterServerCallback("Contactless:Create", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        -- Should probably do some better checking here but I cannot be fucked
        if char and data and data.job and data.terminalId and data.payment and data.payment > 0 and data.payment <= 10000 then
            if Player(source).state.onDuty == data.job then
                if not _pendingContactless[data.terminalId] then
                    local amount = math.floor(data.payment)

                    local jobData = Jobs:Get(data.job)
                    local jobBank = Banking.Accounts:GetOrganization(data.job)

                    _pendingContactless[data.terminalId] = {
                        job = data.job,
                        jobName = jobData.Name,
                        jobAccount = jobBank?.Account,
                        amount = amount,
                        description = data.description,
                        billerSource = source,
                        biller = {
                            First = char:GetData("First"),
                            Last = char:GetData("Last"),
                            SID = char:GetData("SID"),
                        },
                    }

                    GlobalState[string.format("PendingContactless:%s", data.terminalId)] = amount
                    cb(true)
                else
                    cb(false, "There is a payment already pending!")
                end
            else
                cb(false, "Not on Duty")
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Contactless:Clear", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char and data and data.job and data.terminalId then
            if Player(source).state.onDuty == data.job then
                if _pendingContactless[data.terminalId] then
                    _pendingContactless[data.terminalId] = nil
                    GlobalState[string.format("PendingContactless:%s", data.terminalId)] = false
                else
                    cb(false, "No payments pending!")
                end
            else
                cb(false, "Not on Duty")
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Contactless:Pay", function(source, data, cb)
        local char = Fetch:Source(source):GetData("Character")
        if char and data and data.terminalId and _pendingContactless[data.terminalId] and GlobalState[string.format("PendingContactless:%s", data.terminalId)] then
            GlobalState[string.format("PendingContactless:%s", data.terminalId)] = false

            local pData = _pendingContactless[data.terminalId]

            local wSuccess = Banking.Balance:Charge(char:GetData("BankAccount"), pData.amount, {
                type = 'bill',
                transactionAccount = pData.jobAccount,
                title = 'Contactless Payment',
                description = string.format('Contactless Payment to %s. Description: %s', pData.jobName, pData.description),
                data = {
                    biller = pData.biller.SID,
                    character = char:GetData("SID"),
                }
            })

            if wSuccess then
                if pData.jobAccount then
                    local success = Banking.Balance:Deposit(pData.jobAccount, pData.amount, {
                        type = 'bill',
                        transactionAccount = char:GetData("BankAccount"),
                        title = 'Contactless Payment',
                        description = string.format('Contactless Payment From State ID: %s. Description: %s', char:GetData("SID"), pData.description),
                        data = {
                            biller = pData.biller.SID,
                            character = char:GetData("SID"),
                        }
                    })
                end

                Phone.Notification:Add(pData.billerSource, "Contactless Payment Received", string.format("Received $%s for %s.", math.floor(pData.amount), pData.jobName), os.time() * 1000, 8000, "bank", {})
                Execute:Client(pData.billerSource, "Notification", "Success", "Contactless Payment Received")

                Phone.Notification:Add(source, "Contactless Payment Accepted", string.format("Paid $%s to %s", math.floor(pData.amount), pData.jobName), os.time() * 1000, 8000, "bank", {})

                Laptop.BizWiz.Receipts:Create(pData.job, {
                    type = "Contactless Terminal",
                    time = os.time() * 1000,
                    author = pData.biller,
                    workers = {},
                    paymentPaid = pData.amount,
                    notes = pData.description,
                    job = pData.job,
                    customerNumber = "",
                    customerName = string.format("%s %s", char:GetData("First"), char:GetData("Last")),
                })

                _pendingContactless[data.terminalId] = false

                cb(true)
            else
                Phone.Notification:Add(pData.billerSource, "Contactless Payment Failed", string.format("Payment of $%s for %s failed.", math.floor(pData.amount), pData.jobName), os.time() * 1000, 8000, "bank", {})
                Execute:Client(pData.billerSource, "Notification", "Error", "Contactless Payment Failed")

                Phone.Notification:Add(source, "Contactless Payment Failed", string.format("Payment of $%s to %s just failed. Is your balance sufficient?", math.floor(pData.amount), pData.jobName), os.time() * 1000, 8000, "bank", {})

                GlobalState[string.format("PendingContactless:%s", data.terminalId)] = pData.amount

                cb(false)
            end
        else
            cb(false)
        end
    end)
end)