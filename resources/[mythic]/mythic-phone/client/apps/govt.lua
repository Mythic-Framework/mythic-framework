RegisterNUICallback("Govt:PurchaseService", function(data, cb)
	Callbacks:ServerCallback("Phone:Govt:PurchaseService", data, cb)
end)