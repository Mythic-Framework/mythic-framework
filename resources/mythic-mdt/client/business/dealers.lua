RegisterNUICallback("PDMGetDealerData", function(data, cb)
	Callbacks:ServerCallback(
        "Dealerships:GetDealershipData", 
        { dealerId = LocalPlayer.state.onDuty }, 
        cb
    )
end)

RegisterNUICallback("PDMSaveDealerData", function(data, cb)
	Callbacks:ServerCallback(
        "Dealerships:UpdateDealershipData", 
        { 
            dealerId = LocalPlayer.state.onDuty,
            updating = data.data,
        }, 
        cb
    )
end)

RegisterNUICallback("PDMGetStock", function(data, cb)
	Callbacks:ServerCallback(
        "Dealerships:Sales:FetchData", 
        LocalPlayer.state.onDuty, 
        function(authed, stocks, defaultInterestRate, dealerData)
            if authed then
                cb({
                    stock = stocks,
                    dealerData = dealerData,
                    interest = defaultInterestRate,
                })
            else
                cb(false)
            end
        end
    )
end)

RegisterNUICallback("PDMRunCredit", function(data, cb)
	Callbacks:ServerCallback(
        "Dealerships:CheckPersonsCredit", 
        { dealerId = LocalPlayer.state.onDuty, SID = data.term }, 
        cb
    )
end)

RegisterNUICallback("PDMStartSale", function(data, cb)
	Callbacks:ServerCallback(
        "Dealerships:Sales:StartSale", 
        {
            dealership = LocalPlayer.state.onDuty,
            type = data.type,
            data = {
                vehicle = data.vehicle,
                customer = data.SID,
                downPayment = data.downpayment,
                loanWeeks = data.weeks,
            }
        },
        function(success, message)
            cb({
                success = success,
                message = message,
            })
        end
    )
end)

RegisterNUICallback("PDMGetHistory", function(data, cb)
	Callbacks:ServerCallback(
        "Dealerships:FetchHistory",
        LocalPlayer.state.onDuty,
        function(penis)
            if penis then
                cb(penis)
            else
                cb(false)
            end
        end
    )
end)

RegisterNUICallback("PDMGetOwner", function(data, cb)
	Callbacks:ServerCallback(
        "Dealerships:FetchCurrentOwner",
        { dealerId = LocalPlayer.state.onDuty, VIN = data.VIN },
        function(penis)
            if penis then
                cb(penis)
            else
                cb(false)
            end
        end
    )
end)