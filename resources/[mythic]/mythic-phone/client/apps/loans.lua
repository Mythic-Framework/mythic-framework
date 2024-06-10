RegisterNUICallback("Loans:GetData", function(data, cb)
	Callbacks:ServerCallback('Loans:GetLoans', {}, function(characterLoansData)
		cb(characterLoansData)
	end)
end)

RegisterNUICallback("Loans:Payment", function(data, cb)
	Callbacks:ServerCallback('Loans:Payment', data, function(res, updatedCharacterLoansData)
        if res and res.success and updatedCharacterLoansData then
            Phone.Data:Set('bankLoans', updatedCharacterLoansData)
        end

		cb(res)
	end)
end)