local pendingBillId = 0
PENDING_BILLS = {}
PENDING_BILLS_CB = {}

function GetBillingId()
    pendingBillId = pendingBillId + 1
    return pendingBillId
end

_BILLING = {
    Create = function(self, source, name, amount, description, cb)
        local char = Fetch:Source(source):GetData('Character')
        if char then
            local stateId = char:GetData('SID')
            local newBillingId = GetBillingId()
            local billData = {
                Type = false,
                Id = newBillingId,
                Name = name,
                Account = false,
                Amount = amount,
                Description = description,
                Biller = false,
                Timestamp = os.time(),
            }
            
            if not PENDING_BILLS[stateId] then PENDING_BILLS[stateId] = {} end
            table.insert(PENDING_BILLS[stateId], billData)
            SendNewBillNotificationToPhone(source, billData)

            PENDING_BILLS_CB[newBillingId] = cb
            return true
        end
        return false
    end,
    PlayerCreateOrganizationBill = function(self, billingSource, stateId, account, amount, description)
        local amount = math.tointeger(amount)
        local target = Fetch:SID(tonumber(stateId))
        if account and amount and amount > 0 and target then
            local targetChar = target:GetData('Character')
            local billingChar = Fetch:Source(billingSource):GetData('Character')

            if targetChar and billingChar and targetChar:GetData('SID') ~= billingChar:GetData('SID') then
                local billerStateId = billingChar:GetData('SID')
                local account = Banking.Accounts:Get(account)
                if account and account.Type == 'organization' and HasBankAccountPermission(billingSource, account, 'BILL', billerStateId) then
                    local targetStateId = targetChar:GetData('SID')
                    local newBillingId = GetBillingId()
                    local billData = {
                        Type = true,
                        Id = newBillingId,
                        Name = account.Name or account.Account,
                        Account = account.Account,
                        Amount = amount,
                        Description = description,
                        Biller = billerStateId,
                        Timestamp = os.time(),
                    }

                    if not PENDING_BILLS[targetStateId] then PENDING_BILLS[targetStateId] = {} end
                    table.insert(PENDING_BILLS[targetStateId], billData)
                    SendNewBillNotificationToPhone(targetChar:GetData('Source'), billData)

                    PENDING_BILLS_CB[newBillingId] = function(wasPayed, withAccount)
                        if wasPayed then
                            local success = Banking.Balance:Deposit(billData.Account, billData.Amount, {
                                type = 'bill',
                                transactionAccount = withAccount,
                                title = 'Bill Payment',
                                description = string.format('Bill Payment From State ID: %s With Account: %s. Bill Description: %s', targetStateId, withAccount, billData.Description),
                                data = {
                                    biller = billerStateId,
                                    character = targetStateId,
                                }
                            })

                            if success then
                                Phone.Notification:Add(billingSource, "Bill Payment Received", string.format("Payment for a bill you sent to State ID: %s was just received.", targetStateId), os.time() * 1000, 5000, "bank", {})
                            end
                        end
                    end
                    return true
                end
            end
        end
        return false
    end,
    Dismiss = function(self, source, billId)
        local char = Fetch:Source(source):GetData('Character')
        if char and billId then
            local stateId = char:GetData('SID')
            local characterBills = PENDING_BILLS[stateId]
            for k, v in ipairs(characterBills) do
                if v.Id == billId then
                    if PENDING_BILLS_CB[billId] then
                        PENDING_BILLS_CB[billId](false)
                        PENDING_BILLS_CB[billId] = nil
                    end
                    PENDING_BILLS[stateId][k] = nil

                    return true
                end
            end
        end
        return false
    end,
    Accept = function(self, source, billId, withAccount)
        local char = Fetch:Source(source):GetData('Character')
        if char and billId then
            local stateId = char:GetData('SID')
            local characterBills = PENDING_BILLS[stateId]
            for k, v in ipairs(characterBills) do
                if v.Id == billId then
                    local account = false
                    if withAccount then
                        account = Banking.Accounts:Get(withAccount)
                    else
                        account = Banking.Accounts:GetPersonal(stateId)
                    end
                    if PENDING_BILLS_CB[billId] and account and (account.Balance >= v.Amount) and HasBankAccountPermission(source, account, 'WITHDRAW', stateId) then
                        local success = Banking.Balance:Withdraw(account.Account, v.Amount, {
                            type = 'bill',
                            transactionAccount = v.Account,
                            title = 'Payment for a Bill',
                            description = string.format('Payment for a Bill From %s. Bill Description: %s', v.Name, v.Description),
                            data = {
                                biller = v.Biller,
                                character = stateId,
                            }
                        })

                        if success then
                            if PENDING_BILLS_CB[billId] then
                                PENDING_BILLS_CB[billId](true, account.Account)
                                PENDING_BILLS_CB[billId] = nil
                            end
                            PENDING_BILLS[stateId][k] = nil
                            return true
                        end
                    end
                    break
                end
            end
        end
        return false
    end,
    Fine = function(self, finingSource, targetSource, amount)
        local amount = math.tointeger(amount)
        if amount and amount > 0 then
            local finingChar = Fetch:Source(finingSource):GetData('Character')
            local targetChar = Fetch:Source(targetSource)
            if targetChar then
                targetChar = targetChar:GetData('Character')
            end

            if finingChar and targetChar and finingChar:GetData('SID') ~= targetChar:GetData('SID') then
                local targetCharSID = targetChar:GetData('SID')
                local finingCharSID = finingChar:GetData('SID')

                local targetCharAccount = Banking.Accounts:GetPersonal(targetCharSID)
                local finingCharAccount = Banking.Accounts:GetPersonal(finingCharSID)
                local policeJob = Jobs.Permissions:HasJob(finingSource, 'police')

                local policeAccount = Banking.Accounts:GetOrganization(string.format('police-%s', policeJob?.Workplace?.Id or ''))
                if not policeAccount then
                    policeAccount = Banking.Accounts:GetOrganization('police')
                end

                if targetCharAccount and finingCharAccount then
                    local finerCut = 0.15 -- THE PERSON THAT IS CREATING THE FINE GETS A CUT OF THE FINE
                    local policeCut = 0.25
                    local stateCut = 1.0 - finerCut - policeCut

                    local finerCutAmount = math.floor(amount * finerCut)
                    local policeCutAmount = math.floor(amount * policeCut)
                    local stateCutAmount = math.floor(amount * stateCut)

                    local success = Banking.Balance:Withdraw(targetCharAccount.Account, amount, {
                        type = 'fine',
                        title = 'Fine Payment',
                        description = 'Fine From the State of San Andreas',
                        data = {
                            finer = finingCharSID
                        }
                    })

                    if success then
                        Banking.Balance:Deposit(finingCharAccount.Account, finerCutAmount, {
                            type = 'fine_profit',
                            title = 'Fine Profit',
                            description = string.format('Your Earned %% of Fine Profit', targetCharSID),
                            data = {
                                fined = targetCharSID,
                            }
                        })

                        if policeAccount then
                            Banking.Balance:Deposit(policeAccount.Account, policeCutAmount, {
                                type = 'fine_profit',
                                title = 'Fine Profit',
                                description = string.format('Fine Profit (Fine to State ID: %s By State ID: %s)', targetCharSID, finingCharSID),
                                data = {
                                    finer = finingCharSID,
                                    fined = targetCharSID,
                                }
                            })
                        end

                        Banking.Balance:Deposit(100000, stateCutAmount, {
                            type = 'fine_profit',
                            title = 'Fine Profit',
                            description = string.format('Fine Profit (Fine to State ID: %s By State ID: %s)', targetCharSID, finingCharSID),
                            data = {
                                finer = finingCharSID,
                                fined = targetCharSID,
                            }
                        })

                        Phone.Notification:Add(targetSource, "Received Fine", string.format("You received a fine of $%d from the State of San Andreas", amount), os.time() * 1000, 7500, "bank", {})

                        return {
                            amount = amount,
                            cut = finerCutAmount,
                        }
                    end
                end
            end
        end
        return false
    end,
    Charge = function(self, source, amount, title, description)
        local amount = math.tointeger(amount)
        if amount and amount > 0 then
            local targetChar = Fetch:Source(source)
            if targetChar then
                targetChar = targetChar:GetData('Character')
            end

            if targetChar then
                local targetCharSID = targetChar:GetData('SID')
                local targetCharAccount = Banking.Accounts:GetPersonal(targetCharSID)

                if targetCharAccount then
                    local success = Banking.Balance:Withdraw(targetCharAccount.Account, amount, {
                        type = 'bill',
                        title = title,
                        description = description,
                        data = {}
                    })

                    if success then
                        Phone.Notification:Add(source, "New Bank Charge", string.format("Received Charge of $%d - %s", amount, title), os.time() * 1000, 7500, "bank", {})

                        return amount
                    end
                end
            end
        end
        return false
    end,
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Billing", _BILLING)
end)

function SendNewBillNotificationToPhone(source, billData)
    Phone.Notification:Add(source, "Received New Bill", string.format("$%d Bill From %s", billData.Amount, billData.Name), os.time() * 1000, 7500, "bank", {
        accept = "Phone:Nui:Bank:AcceptBill",
        cancel = "Phone:Nui:Bank:DenyBill",
    }, {
        bill = billData.Id
    })
end