AddEventHandler("Banking:Shared:DependencyUpdate", RetrieveBankingComponents)
function RetrieveBankingComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
    Execute = exports["mythic-base"]:FetchComponent("Execute")
	Database = exports["mythic-base"]:FetchComponent("Database")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
    Chat = exports["mythic-base"]:FetchComponent("Chat")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Generator = exports["mythic-base"]:FetchComponent("Generator")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	Crypto = exports["mythic-base"]:FetchComponent("Crypto")
    Banking = exports["mythic-base"]:FetchComponent("Banking")
	Billing = exports["mythic-base"]:FetchComponent("Billing")
	Loans = exports["mythic-base"]:FetchComponent("Loans")
    Wallet = exports["mythic-base"]:FetchComponent("Wallet")
	Tasks = exports["mythic-base"]:FetchComponent("Tasks")
	Jobs = exports["mythic-base"]:FetchComponent("Jobs")
	Vehicles = exports["mythic-base"]:FetchComponent("Vehicles")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Banking", {
		"Fetch",
		"Utils",
        "Execute",
        "Chat",
		"Database",
		"Middleware",
		"Callbacks",
		"Logger",
		"Generator",
		"Phone",
        "Wallet",
        "Banking",
		"Billing",
		"Loans",
		"Crypto",
		"Jobs",
		"Tasks",
		"Vehicles",
		"Inventory",
	}, function(error)
		if #error > 0 then
			exports["mythic-base"]:FetchComponent("Logger"):Critical("Banking", "Failed To Load All Dependencies")
			return
		end
		RetrieveBankingComponents()
	end)
end)

_BANKING = {
	Accounts = {
		Get = function(self, accountNumber)
			return FindBankAccount({
				Account = accountNumber,
			})
		end,
		CreatePersonal = function(self, ownerSID)
			local hasAccount = Banking.Accounts:GetPersonal(ownerSID)
			if hasAccount then
				return hasAccount
			end

			return CreateBankAccount({
				Type = "personal",
				Owner = ownerSID,
				Balance = 5000,
			})
		end,
		GetPersonal = function(self, ownerSID)
			return FindBankAccount({
				Type = "personal",
				Owner = ownerSID,
			})
		end,
		CreatePersonalSavings = function(self, ownerSID, jointOwners)
			local existingSavingAccount = FindBankAccount({
				Type = "personal_savings",
				Owner = ownerSID,
			})

			if existingSavingAccount then
				return existingSavingAccount
			end

			return CreateBankAccount({
				Type = "personal_savings",
				Owner = ownerSID,
				JointOwners = jointOwners or {},
			})
		end,
		GetPersonalSavings = function(self, SID)
			return FindBankAccounts({
				Type = "personal_savings",
				["$or"] = {
					{
						Owner = SID,
					},
					{
						JointOwners = SID,
					},
				},
			})
		end,
		AddPersonalSavingsJointOwner = function(self, accountId, jointOwnerSID)
			local p = promise.new()
			Database.Game:findOneAndUpdate({
				collection = "bank_accounts",
				query = {
					Account = accountId,
				},
				update = {
					["$push"] = {
						JointOwners = jointOwnerSID,
					},
				},
				options = {
					returnDocument = "after",
				},
			}, function(success, results)
				if success and results then
					p:resolve(results)
				else
					p:resolve(false)
				end
			end)

			
			local res = Citizen.Await(p)
			return res
		end,
		RemovePersonalSavingsJointOwner = function(self, accountId, jointOwnerSID)
			local p = promise.new()
			Database.Game:findOneAndUpdate({
				collection = "bank_accounts",
				query = {
					Account = accountId,
				},
				update = {
					["$pull"] = {
						JointOwners = jointOwnerSID,
					},
				},
				options = {
					returnDocument = "after",
				},
			}, function(success, results)
				if success and results then
					p:resolve(results)
				else
					p:resolve(false)
				end
			end)

			
			local res = Citizen.Await(p)
			return res
		end,
		CreateOrganization = function(self, accountId, accountName, startingBalance, jobAccess)
			local account = FindBankAccount({
				Type = "organization",
				Owner = accountId,
			})

			if account then
				return account
			end

			return CreateBankAccount({
				Type = "organization",
				Owner = accountId,
				Name = accountName,
				Balance = startingBalance or 0,
				JobAccess = jobAccess,
			})
		end,
		GetOrganization = function(self, accountId)
			local account = FindBankAccount({
				Type = "organization",
				Owner = accountId,
			})
			return account
		end,
		AddOrganizationAccessingJob = function(self, job, workplace, permissionSettings)
			local account = FindBankAccount({
				Type = "organization",
				Owner = accountId,
			})

			if account then
				local currentAccess = account.JobAccess or {}

				for k, v in ipairs(currentAccess) do
					if v.Job == job and (not workplace or v.Workplace == workplace) then
						table.remove(currentAccess, k)
					end
				end

				table.insert(currentAccess, {
					Job = job,
					Workplace = workplace,
					Permissions = permissionSettings or GetDefaultBankAccountPermissions(),
				})

				local updatedAccountData = UpdateBankAccount({
					Account = account.Account,
				}, {
					["$set"] = {
						JobAccess = currentAccess,
					},
				})
				return updatedAccountData
			end
			return false
		end,
		RemoveOrganizationAccessingJob = function(self, job, workplace)
			local account = FindBankAccount({
				Type = "organization",
				Owner = accountId,
			})

			if account then
				local currentAccess = account.JobAccess or {}
				for k, v in ipairs(currentAccess) do
					if v.Job == job and v.Workplace == workplace then
						table.remove(currentAccess, k)
					end
				end

				local updatedAccountData = UpdateBankAccount({
					Account = account.Account,
				}, {
					["$set"] = {
						JobAccess = currentAccess,
					},
				})
				return updatedAccountData
			end
			return false
		end,
	},
	Balance = {
		Get = function(self, accountNumber)
			local account = Banking.Accounts:Get(accountNumber)
			if account then
				return account.Balance
			end
			return false
		end,
		Has = function(self, accountNumber, amount)
			local balance = Banking.Balance:Get(accountNumber)
			if balance then
				return balance >= amount
			end
			return false
		end,
		Deposit = function(self, accountNumber, amount, transactionLog, skipPhoneNoti)
			if amount and amount > 0 then
				local accountData = UpdateBankAccount({
					Account = accountNumber,
				}, {
					["$inc"] = {
						Balance = math.floor(amount),
					},
				})
				if accountData then
					if transactionLog then
						Banking.TransactionLogs:Add(
							accountNumber,
							transactionLog.type,
							math.floor(amount),
							transactionLog.title,
							transactionLog.description,
							transactionLog.transactionAccount,
							transactionLog.data
						)

                        if transactionLog.title ~= "Cash Deposit" then
                            local acct = Banking.Accounts:Get(accountNumber)
                            if acct ~= nil then
                                if acct.Type == "personal" or acct.Type == "personal_savings" then
                                    local p = Fetch:CharacterData("SID", acct.Owner)
                                    if p ~= nil and not skipPhoneNoti then
                                        Phone.Notification:Add(
                                            p:GetData("Source"),
                                            "Received A Deposit",
                                            string.format("$%s Deposited Into %s", math.floor(amount), acct.Name),
                                            os.time() * 1000,
                                            6000,
                                            "bank",
                                            {}
                                        )
                                    end
        
                                    if acct.JointOwners ~= nil and #acct.JointOwners > 0 and not skipPhoneNoti then
                                        for k, v in ipairs(acct.JointOwners) do
                                            local jo = Fetch:CharacterData("SID", v)
                                            if jo ~= nil then
                                                Phone.Notification:Add(
                                                    jo:GetData("Source"),
                                                    "Received A Deposit",
                                                    string.format("$%s Deposited Into %s", math.floor(amount), acct.Name),
                                                    os.time() * 1000,
                                                    6000,
                                                    "bank",
                                                    {}
                                                )
                                            end
                                        end
                                    end
                                end
                            end
                        end
					end
					return accountData.Balance
				end
			end
			return false
		end,
		Withdraw = function(self, accountNumber, amount, transactionLog)
			if amount and amount > 0 then
				local p = promise.new()
				local accountData = UpdateBankAccount({
					Account = accountNumber,
				}, {
					["$inc"] = {
						Balance = -(math.floor(amount)),
					},
				})

				if accountData then
					if transactionLog then
						Banking.TransactionLogs:Add(
							accountNumber,
							transactionLog.type,
							-(math.floor(amount)),
							transactionLog.title,
							transactionLog.description,
							transactionLog.transactionAccount,
							transactionLog.data
						)
					end
					return accountData.Balance
				end
			end
			return false
		end,
		-- Withdraw But Checks If Has Balance
		Charge = function(self, accountNumber, amount, transactionLog)
			if Banking.Balance:Has(accountNumber, (math.floor(amount))) then
				return Banking.Balance:Withdraw(accountNumber, (math.floor(amount)), transactionLog)
			end
			return false
		end,
	},
	TransactionLogs = {
		Add = function(self, accountNumber, type, amount, title, description, transactionAccount, data)
			local doc = {
				Type = type,
				Timestamp = os.time(),
				Account = accountNumber,
				Amount = (math.floor(amount)),
				Title = title or "Unknown",
				Description = description or "No Description",
				TransactionAccount = transactionAccount,
				Data = data,
			}

			Database.Game:insertOne({
				collection = "bank_accounts_transactions",
				document = doc,
			})
			return doc
		end,
		Get = function(self, accountNumber)
			local p = promise.new()
			Database.Game:find({
				collection = "bank_accounts_transactions",
				query = {
					Account = accountNumber,
				},
			}, function(success, results)
				if success then
					p:resolve(results)
				else
					p:resolve({})
				end
			end)

			local res = Citizen.Await(p)
			return res
		end,
	},
}

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Banking", _BANKING)
end)
