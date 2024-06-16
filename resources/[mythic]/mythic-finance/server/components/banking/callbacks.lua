local AccountsOccupied = {}

function RegisterBankingCallbacks()
	Callbacks:RegisterServerCallback("Finance:Paycheck", function(source, data, cb)
		local pState = Player(source).state
		pState.gettingPaycheck = true
		local char = Fetch:Source(source):GetData("Character")

		local salary = char:GetData("Salary") or {}
		local amt = 0
		local mts = 0
		for k, v in pairs(salary) do
			amt = amt + v.total
			mts = mts + v.minutes
		end

		if amt > 0 then
			char:SetData("Salary", false)
			Banking.Balance:Deposit(Banking.Accounts:GetPersonal(char:GetData("SID")).Account, amt, {
				type = 'paycheck',
				title = "Paycheck",
				description = string.format('Paycheck For %s Minutes Worked', mts),
				data = salary
			})
		end

		cb({
			total = amt,
			minutes = mts,
		})
		pState.gettingPaycheck = false
	end)

	Callbacks:RegisterServerCallback("Banking:RegisterAccount", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")

		if char ~= nil then
			if data.type == "personal_savings" then
				local acc = Banking.Accounts:CreatePersonalSavings(char:GetData("SID"), {})
				acc.Permissions = {
					MANAGE = true,
					BALANCE = true,
					WITHDRAW = true,
					DEPOSIT = true,
					TRANSACTIONS = true,
				}
				cb(acc)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Banking:RenameAccount", function(source, data, cb)
		cb(false)
	end)

	Callbacks:RegisterServerCallback("Banking:AddJoint", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char and data?.target > 0 then
			cb(Banking.Accounts:AddPersonalSavingsJointOwner(data.account, data.target))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Banking:RemoveJoint", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char then
			cb(Banking.Accounts:RemovePersonalSavingsJointOwner(data.account, data.target))
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Banking:GetAccounts", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if char then
			local SID = char:GetData("SID")

			local jobQueryList = {}
			local workplaceQueryList = { false }
			local charJobs = char:GetData("Jobs") or {}

			for k, v in ipairs(charJobs) do
				table.insert(jobQueryList, v.Id)

				if v.Workplace then
					table.insert(workplaceQueryList, v.Workplace.Id)
				end
			end

			local availableAccountsData = {}
			local accountTransactionData = {}
			local availableAccountTransactions = {}
			local availableAccounts = FindBankAccounts({
				["$or"] = {
					{
						Owner = SID,
					},
					{
						JointOwners = SID,
					},
					{
						Type = "organization",
						JobAccess = {
							["$elemMatch"] = {
								Job = {
									["$in"] = jobQueryList,
								},
								Workplace = {
									["$in"] = workplaceQueryList,
								},
							},
						},
					},
				},
			})

			for _, account in ipairs(availableAccounts) do
				if account.Type == "personal" then
					account.Permissions = {
						MANAGE = true,
						BALANCE = true,
						WITHDRAW = true,
						DEPOSIT = true,
						TRANSACTIONS = true,
					}
					table.insert(availableAccountsData, account)
				elseif account.Type == "personal_savings" then
					account.Permissions = {
						MANAGE = true,
						BALANCE = true,
						WITHDRAW = true,
						DEPOSIT = true,
						TRANSACTIONS = true,
					}
					table.insert(availableAccountsData, account)
				elseif account.Type == "organization" then
					if account.JobAccess then
						for _, job in ipairs(account.JobAccess) do
							local jobPermissions = Jobs.Permissions:GetPermissionsFromJob(
								source,
								job.Job,
								job.Workplace
							)
							if jobPermissions then
								account.Permissions = {}
								for perm, jobPerm in pairs(job.Permissions) do
									if jobPermissions[jobPerm] then
										account.Permissions[perm] = true
									else
										account.Permissions[perm] = false
									end
								end

								table.insert(availableAccountsData, account)
								break
							end
						end
					end
				end
			end

			for k, v in ipairs(availableAccountsData) do
				if v.Permissions and v.Permissions.TRANSACTIONS then
					table.insert(availableAccountTransactions, v.Account)
				end
			end

			-- local accountTransactions = FindBankAccountTransactions({
			-- 	Account = {
			-- 		["$in"] = availableAccountTransactions,
			-- 	},
			-- })

			for k, v in ipairs(availableAccountTransactions) do
				local accountTransactions = FindBankAccountTransactions({
					Account = v,
				})

				accountTransactionData[tostring(v)] = accountTransactions
			end

			-- if accountTransactions then
			-- 	for k, v in ipairs(accountTransactions) do
			-- 		if v.Account and v.Amount then
			-- 			if not accountTransactionData[tostring(v.Account)] then
			-- 				accountTransactionData[tostring(v.Account)] = {}
			-- 			end
			-- 			table.insert(accountTransactionData[tostring(v.Account)], v)
			-- 		end
			-- 	end
			-- end
			cb(availableAccountsData, accountTransactionData, PENDING_BILLS[SID])
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Banking:DoAccountAction", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local SID = char:GetData("SID")
		local account, action = data.account, data.action
		local accountData = Banking.Accounts:Get(account)
		if AccountsOccupied[accountData.Account] then return cb(false) end
		AccountsOccupied[accountData.Account] = true
		if accountData then
			if action == "WITHDRAW" then
				local withdrawAmount = tonumber(data.amount)
				if
					withdrawAmount
					and withdrawAmount > 0
					and accountData.Balance >= withdrawAmount
					and HasBankAccountPermission(source, accountData, action, SID)
				then
					local balance = Banking.Balance:Charge(accountData.Account, withdrawAmount, {
						type = "withdraw",
						title = "Cash Withdrawal",
						description = data.description or "No Description",
						transactionAccount = false,
						data = {
							character = SID,
						},
					})

					if balance then
						Wallet:Modify(source, withdrawAmount, true)
						AccountsOccupied[account] = nil
						cb(true, balance)
						return
					end
				end
			elseif action == "DEPOSIT" then
				local depositAmount = tonumber(data.amount)
				if
					depositAmount
					and depositAmount > 0
					and HasBankAccountPermission(source, accountData, action, SID)
				then
					if Wallet:Modify(source, -depositAmount, true) then
						local balance = Banking.Balance:Deposit(accountData.Account, depositAmount, {
							type = "deposit",
							title = "Cash Deposit",
							description = data.description or "No Description",
							transactionAccount = false,
							data = {
								character = SID,
							},
						})

						if balance then
							AccountsOccupied[account] = nil
							cb(true, balance)
							return
						end
					end
				end
			elseif action == "TRANSFER" then
				local transferAmount = tonumber(data.amount)
				local targetAccount = false
				if data.targetType then
					targetAccount = Banking.Accounts:GetPersonal(tonumber(data.target))
				else
					targetAccount = Banking.Accounts:Get(tonumber(data.target))
				end
				if transferAmount and transferAmount > 0 and targetAccount then
					if
						accountData.Balance >= transferAmount
						and HasBankAccountPermission(source, accountData, "WITHDRAW", SID)
					then
						local success = Banking.Balance:Withdraw(accountData.Account, transferAmount, {
							type = "transfer",
							title = "Outgoing Bank Transfer",
							description = string.format(
								"Transfer to Account: %s.%s",
								targetAccount.Account,
								(data.description and (" Description: " .. data.description) or "")
							),
							data = {
								character = SID,
							},
						})

						if success then
							local success2 = Banking.Balance:Deposit(targetAccount.Account, transferAmount, {
								type = "transfer",
								title = "Incoming Bank Transfer",
								description = string.format(
									"Transfer from Account: %s.%s",
									accountData.Account,
									(data.description and (" Description: " .. data.description) or "")
								),
								transactionAccount = accountData.Account,
								data = {
									character = SID,
								},
							})
							AccountsOccupied[account] = nil
							cb(success2)
							return
						end
					end
				end
			end
			AccountsOccupied[account] = nil
		end
		cb(false)
	end)
end
