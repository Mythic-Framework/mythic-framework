RegisterNetEvent("MDT:Client:BusinessLogin", function(job, jobPermissions, tabletData)
	_mdtLoggedIn = true
	SendNUIMessage({
		type = "JOB_LOGIN",
		data = {
			job = job,
			jobPermissions = jobPermissions,
            tabletData = tabletData,
		},
	})
end)

-- Documents

RegisterNUICallback("BusinessDocumentSearch", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Document:Search", data, cb)
end)

RegisterNUICallback("BusinessDocumentCreate", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Document:Create", data, cb)
end)

RegisterNUICallback("BusinessDocumentUpdate", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Document:Update", data, cb)
end)

RegisterNUICallback("BusinessDocumentView", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Document:View", data.id, cb)
end)

RegisterNUICallback("BusinessDocumentDelete", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Document:Delete", data.id, cb)
end)

-- Receipts

RegisterNUICallback("BusinessReceiptSearch", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Receipt:Search", data, cb)
end)

RegisterNUICallback("BusinessReceiptCreate", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Receipt:Create", data, cb)
end)

RegisterNUICallback("BusinessReceiptUpdate", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Receipt:Update", data, cb)
end)

RegisterNUICallback("BusinessReceiptView", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Receipt:View", data.id, cb)
end)

RegisterNUICallback("BusinessReceiptDelete", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Receipt:Delete", data.id, cb)
end)

RegisterNUICallback("BusinessReceiptDeleteAll", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Receipt:DeleteAll", data, function(success)
		cb(success)
	end)
end)

-- Notices

RegisterNUICallback("CreateBusinessNotice", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Notice:Create", data, cb)
end)

RegisterNUICallback("DeleteBusinessNotice", function(data, cb)
	Callbacks:ServerCallback("MDT:Business:Notice:Delete", data, cb)
end)