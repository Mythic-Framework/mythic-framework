local _startup = false

local defaultOrganizationAccounts = {
    {
        accountId = 'police',
        accountName = 'Law Enforcement Shared Account',
        startingBalance = 750000,
        jobAccess = {
            {
                Job = 'police',
                Workplace = false,
                Permissions = GetDefaultBankAccountPermissions()
            },
        }
    },
    {
        accountId = 'police-lspd',
        accountName = 'LSPD Account',
        startingBalance = 0,
        jobAccess = {
            {
                Job = 'police',
                Workplace = 'lspd',
                Permissions = GetDefaultBankAccountPermissions()
            },
        }
    },
    {
        accountId = 'police-lscso',
        accountName = 'LSCSO Account',
        startingBalance = 0,
        jobAccess = {
            {
                Job = 'police',
                Workplace = 'lscso',
                Permissions = GetDefaultBankAccountPermissions()
            },
        }
    },
    {
        accountId = 'ems',
        accountName = 'EMS Account',
        startingBalance = 325000,
        jobAccess = {
            {
                Job = 'ems',
                Workplace = 'safd',
                Permissions = GetDefaultBankAccountPermissions()
            },
        }
    },
    {
        accountId = 'doctors',
        accountName = 'Mt Zonah Medical Account',
        startingBalance = 20000,
        jobAccess = {
            {
                Job = 'ems',
                Workplace = 'doctors',
                Permissions = GetDefaultBankAccountPermissions()
            },
        }
    },
    {
        accountId = 'doj',
        accountName = 'DOJ Account',
        startingBalance = 0,
        jobAccess = {
            {
                Job = 'government',
                Workplace = 'doj',
                Permissions = GetDefaultBankAccountPermissions()
            },
        }
    },
    {
        accountId = 'casino-bets',
        accountName = 'Diamond Casino Bets',
        startingBalance = 0,
        jobAccess = {
            {
                Job = 'casino',
                Workplace = false,
                Permissions = GetDefaultBankAccountPermissions()
            },
        }
    },
}

function RunBankingStartup()
    if _startup then return; end
    _startup = true

    local stateAccount = FindBankAccount({
        Type = 'organization',
        Account = 100000
    })

    if not stateAccount then
        local stateAccountPermissons = {
            BALANCE = 'STATE_ACCOUNT_BALANCE',
            MANAGE = 'STATE_ACCOUNT_MANAGE',
            WITHDRAW = 'STATE_ACCOUNT_WITHDRAW',
            DEPOSIT = 'STATE_ACCOUNT_DEPOSIT',
            TRANSACTIONS = 'STATE_ACCOUNT_TRANSACTIONS',
            BILL = 'STATE_ACCOUNT_BILL',
        }

        stateAccount = CreateBankAccount({
            Type = 'organization',
            Owner = 'government',
            Name = 'San Andreas State Account',
            Account = 100000,
            Balance = 500000, -- Government Should Probably Have Some Starter Money
            JobAccess = {
                {
                    Job = 'government',
                    Workplace = 'doj',
                    Permissions = stateAccountPermissons,
                },
                {
                    Job = 'government',
                    Workplace = 'mayoroffice',
                    Permissions = stateAccountPermissons,
                },
            }
        })
    end

    CreateOrganizationBankAccounts()

    Database.Game:aggregate({
        collection = 'bank_accounts',
        aggregate = {
            {
                ['$group'] = {
                    _id = '',
                    TotalBalance = { ['$sum'] = '$Balance' },
                    Count = { ['$sum'] = 1 }
                }
            }, 
            {
                ['$project'] = {
                    _id = 0,
                    TotalBalance = '$TotalBalance',
                    Count = '$Count',
                }
            }
        }
    }, function(success, results)
        if success and #results > 0 then
            local data = results[1]
            if data.Count then
                Logger:Trace('Banking', 'Loaded ^2'.. data.Count .. '^7 Bank Accounts')
            end
            if data.TotalBalance then
                Logger:Info('Banking', 'Total Balance Across All Accounts: ^2$' .. data.TotalBalance .. '^7')
            end
        end
        Logger:Info('Banking', 'Loaded State Government Account - Balance: ^2$'.. stateAccount.Balance .. '^7')
    end)

    Database.Game:delete({
        collection = 'bank_accounts_transactions',
        query = {
            Timestamp = {
                ['$lte'] = (os.time() - (60 * 60 * 24 * 30))
            }
        },
    }, function(success, deleted)
        if success then
            Logger:Info('Banking', 'Cleared ^2' .. deleted .. '^7' .. ' Old Bank Transactions')
        end
    end)
end

AddEventHandler('Finance:Server:Startup', function()
    Middleware:Add("Characters:Spawning", function(source)
        local char = Fetch:Source(source):GetData("Character")
        if char and not char:GetData("BankAccount") then
            local stateId = char:GetData("SID")
            local bankAccountData = Banking.Accounts:CreatePersonal(stateId)
            if bankAccountData then
                Logger:Trace('Banking', string.format('Personal Bank Account (%s) Created for Character: %s', bankAccountData.Account, stateId))
                char:SetData("BankAccount", bankAccountData.Account)
            end
        end
    end, 3)

	RegisterBankingCallbacks()
end)

AddEventHandler('Jobs:Server:CompleteStartup', function()
    RunBankingStartup()
end)

function CreateOrganizationBankAccounts()
    local orgBankAccounts = FindBankAccounts({
        Type = 'organization',
    }) or {}

    local accountsByJob = {}
    for k, v in ipairs(orgBankAccounts) do
        accountsByJob[v.Owner] = true
    end

    local created = 0

    for k, v in ipairs(defaultOrganizationAccounts) do
        if v.accountId and not accountsByJob[v.accountId] then
            local success = Banking.Accounts:CreateOrganization(v.accountId, v.accountName, v.startingBalance, v.jobAccess)
            if success then
                created = created + 1
            end
        end
    end

    local allJobs = Jobs:GetAll()
    if not allJobs then
        return
    end

    for k,v in pairs(allJobs) do
        if v.Type ~= 'Government' and not accountsByJob[v.Id] then
            local success = Banking.Accounts:CreateOrganization(v.Id, v.Name, 0, {
                {
                    Job = v.Id,
                    Workplace = false,
                    Permissions = GetDefaultBankAccountPermissions()
                }
            })
            if success then
                created = created + 1
            end
        end
    end

    if created > 0 then
        Logger:Trace('Banking', 'Created ^2'.. created .. '^7 Default Organization Accounts')
    end
end