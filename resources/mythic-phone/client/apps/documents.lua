RegisterNUICallback("EditDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Edit", data, cb)
end)

RegisterNUICallback("DeleteDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Delete", data.id, cb)
end)

RegisterNUICallback("CreateDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Create", data, cb)
end)

RegisterNUICallback("ShareDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Share", data, cb)
end)

RegisterNUICallback("SignDocument", function(data, cb)
	Callbacks:ServerCallback("Phone:Documents:Sign", data, cb)
end)