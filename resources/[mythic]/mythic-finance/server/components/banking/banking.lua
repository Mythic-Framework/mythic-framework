function GenerateBankAccountNumber()
    local bankAccount = math.random(100001, 999999)
    while IsAccountNumberInUse(bankAccount) do
        bankAccount = math.random(100001, 999999)
    end

    return bankAccount
end

function IsAccountNumberInUse(account)
    local p = promise.new()

    Database.Game:find({
        collection = 'bank_accounts',
        query = {
            Account = account
        }
    }, function(success, results)
        if success and #results > 0 then
            p:resolve(true)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function FindBankAccount(query)
    local p = promise.new()

    Database.Game:findOne({
        collection = 'bank_accounts',
        query = query,
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

function FindBankAccounts(query)
    local p = promise.new()

    Database.Game:find({
        collection = 'bank_accounts',
        query = query,
    }, function(success, results)
        if success and #results > 0 then
            p:resolve(results)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function CreateBankAccount(document)
    if type(document) ~= 'table' then return false end
    local p = promise.new()

    if not document.Account then
        document.Account = GenerateBankAccountNumber()
    end

    if not document.Name then
        document.Name = document.Account
    end

    if not document.Balance or document.Balance < 0 then
        document.Balance = 0
    end

    Database.Game:insertOne({
        collection = 'bank_accounts',
        document = document,
    }, function(success, inserted, insertedIds)
        if success and inserted > 0 then
            document._id = insertedIds[1]
            p:resolve(document)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function UpdateBankAccount(searchQuery, updateQuery)
    local p = promise.new()

    Database.Game:findOneAndUpdate({
        collection = 'bank_accounts',
        query = searchQuery,
        update = updateQuery,
        options = {
            returnDocument = 'after',
        }
    }, function(success, results)
        if success and results then
            p:resolve(results)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function FindBankAccountTransactions(query)
    local p = promise.new()

    Database.Game:find({
        collection = 'bank_accounts_transactions',
        query = query,
        options = {
            limit = 80,
            sort = {
                Timestamp = -1
            }
        }
    }, function(success, results)
        if success and #results > 0 then
            p:resolve(results)
        else
            p:resolve(false)
        end
    end)

    local res = Citizen.Await(p)
    return res
end

function GetDefaultBankAccountPermissions()
    return {
        MANAGE = 'BANK_ACCOUNT_MANAGE', -- Can Manage The Account (IDK What this does yet)
        WITHDRAW = 'BANK_ACCOUNT_WITHDRAW', -- Can Withdraw/Tranfer money
        DEPOSIT = 'BANK_ACCOUNT_DEPOSIT', -- Can Deposit
        TRANSACTIONS = 'BANK_ACCOUNT_TRANSACTIONS', -- Can View Transaction History
        BILL = 'BANK_ACCOUNT_BILL', -- Can Bill Using This Account
        BALANCE = 'BANK_ACCOUNT_BALANCE',
    }
end

function HasBankAccountPermission(source, accountData, permission, stateId)
    if accountData.Type == 'personal' then
        if accountData.Owner == stateId then
            return true
        end
    elseif accountData.Type == 'personal_savings' then
        if accountData.Owner == stateId then
            return true
        elseif accountData.JointOwners and #accountData.JointOwners > 0 then
            for k, v in ipairs(accountData.JointOwners) do
                if v == stateId and permission ~= 'MANAGE' then
                    return true
                end
            end
        end
    elseif accountData.Type == 'organization' then
        if accountData.JobAccess and #accountData.JobAccess > 0 then
            for k, v in ipairs(accountData.JobAccess) do
                if Jobs.Permissions:HasJob(source, v.Job, v.Workplace, false, false, false, v.Permissions[permission]) then
                    return true
                end
            end
        end
    end
    return false
end