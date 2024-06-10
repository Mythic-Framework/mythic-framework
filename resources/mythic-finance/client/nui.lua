RegisterNUICallback("Bank:Fetch", function(data, cb)
	Callbacks:ServerCallback("Banking:GetAccounts", {}, function(accounts, transactions, _)
		cb({
			accounts = accounts,
			transactions = transactions,
		})
		-- Callbacks:ServerCallback("Loans:GetLoans", {}, function(loans, creditScore)
		-- 	cb({
		-- 		accounts = accounts,
		-- 		transactions = transactions,
		-- 		loans = loans,
		-- 		credit = creditScore,
		-- 	})
		-- end)
	end)
end)

RegisterNUICallback("Bank:Register", function(data, cb)
	Callbacks:ServerCallback("Banking:RegisterAccount", {
		type = data.type,
		name = data.name,
	}, cb)
end)

RegisterNUICallback("Bank:AddJoint", function(data, cb)
	Callbacks:ServerCallback("Banking:AddJoint", {
		account = data.account,
		target = tonumber(data.target),
	}, cb)
end)

RegisterNUICallback("Bank:RemoveJoint", function(data, cb)
	Callbacks:ServerCallback("Banking:RemoveJoint", {
		account = data.account,
		target = tonumber(data.target),
	}, cb)
end)

RegisterNUICallback("Bank:Rename", function(data, cb)
	Callbacks:ServerCallback("Banking:RenameAccount", {
		account = data.account,
		name = data.name,
	}, cb)
end)

RegisterNUICallback("Bank:Deposit", function(data, cb)
	Callbacks:ServerCallback("Banking:DoAccountAction", {
		account = data.account,
		action = "DEPOSIT",
		amount = data.amount,
		description = data.comments,
	}, function(succ, newBal)
		cb({
			state = succ,
			balance = newBal,
		})
	end)
end)

RegisterNUICallback("Bank:Withdraw", function(data, cb)
	Callbacks:ServerCallback("Banking:DoAccountAction", {
		account = data.account,
		action = "WITHDRAW",
		amount = data.amount,
		description = data.comments,
	}, function(succ, newBal)
		cb({
			state = succ,
			balance = newBal,
		})
	end)
end)

RegisterNUICallback("Bank:Transfer", function(data, cb)
	Callbacks:ServerCallback("Banking:DoAccountAction", {
		account = data.account,
		action = "TRANSFER",
		targetType = data.type,
		target = data.target,
		amount = data.amount,
		description = data.comments,
	}, function(succ, newBal)
		cb({
			state = succ,
			balance = newBal,
		})
	end)
end)
