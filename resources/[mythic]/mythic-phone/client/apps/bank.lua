RegisterNUICallback("Banking:GetData", function(data, cb)
	Callbacks:ServerCallback('Banking:GetAccounts', {}, function(accounts, transactions, pendingBills)
		cb({
			accounts = accounts,
			transactions = transactions,
			pendingBills = pendingBills or {},
		})
	end)
end)

-- Transfer

RegisterNUICallback("Banking:Transfer", function(data, cb)
	data.action = 'TRANSFER'
	Callbacks:ServerCallback('Banking:DoAccountAction', data, function(success)
		if success then
			Callbacks:ServerCallback('Banking:GetAccounts', {}, function(accounts, transactions, pendingBills)
				Phone.Data:Set('bankLoans', {
					accounts = accounts,
					transactions = transactions,
					pendingBills = pendingBills or {},
				})
				cb(true)
			end)
		else
			cb(false)
		end
	end)
end)

-- Bills

RegisterNUICallback("Banking:AcceptBill", function(data, cb)
	Callbacks:ServerCallback('Billing:AcceptBill', data, function(success)
		cb(success)
	end)
end)

RegisterNUICallback("Banking:DismissBill", function(data, cb)
	Callbacks:ServerCallback('Billing:DismissBill', data, function(success)
		cb(success)
	end)
end)

RegisterNUICallback("Banking:Bill", function(data, cb)
	Callbacks:ServerCallback('Billing:CreateBill', data, function(success)
		cb(success)
	end)
end)

AddEventHandler("Phone:Nui:Bank:AcceptBill", function(data)
	Callbacks:ServerCallback('Billing:AcceptBill', {
		bill = data.bill,
		notify = true
	})
end)

AddEventHandler("Phone:Nui:Bank:DenyBill", function(data)
	Callbacks:ServerCallback('Billing:DismissBill', data)
end)