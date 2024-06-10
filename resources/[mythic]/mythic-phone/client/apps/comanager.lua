RegisterNetEvent("Phone:Client:CoManager:GetJobOffer", function(time, jobData)
	local message
	if jobData.Workplace then
		message = string.format("You've received an employment offer as %s - %s", jobData.Workplace.Name, jobData.Grade.Name)
	else
		message = string.format("You've received an employment offer as %s - %s", jobData.Name, jobData.Grade.Name)
	end
	Phone.Notification:Add(
		"Employment Offer",
		message,
		time * 1000,
		-1,
		"comanager",
		{
			accept = "Phone:Client:CoManager:AcceptHire",
			cancel = "Phone:Client:CoManager:DeclineHire",
		},
		nil,
		{
			sound = _settings.texttone,
			volume = 0.1 * (_settings.volume / 100),
		}
	)
end)

RegisterNetEvent("Phone:Client:CoManager:GetOfferResult", function(time, state)
	if state then
		Phone.Notification:Add(
			"Employment Offer Response",
			"Your Employment Offer Was Accepted",
			time * 1000,
			6000,
			"comanager",
			{ view = "" },
			nil
		)
	else
		Phone.Notification:Add(
			"Employment Offer Response",
			"Your Employment Offer Was Declined",
			time * 1000,
			6000,
			"comanager",
			{ view = "" },
			nil
		)
	end
end)

AddEventHandler("Phone:Client:CoManager:AcceptHire", function()
	Callbacks:ServerCallback("Phone:CoManager:AcceptHire", {}, function(time, state)
		if state then
			Phone.Notification:Add("Employment", "You accepted an employment offer", time * 1000, 6000, "comanager", {
				view = "",
			}, nil)
		else
			Phone.Notification:Add("Employment", "Unable to accept an employment offer", time * 1000, 6000, "comanager", {
				view = "",
			}, nil)
		end
	end)
end)

AddEventHandler("Phone:Client:CoManager:DeclineHire", function()
	Callbacks:ServerCallback("Phone:CoManager:DeclineHire", {}, function(time)
		Phone.Notification:Add("Employment", "You declined an employment offer", time * 1000, 6000, "comanager", {}, nil)
	end)
end)

RegisterNetEvent("Phone:Client:CoManager:GetTransferRequest", function(time, data)
	Phone.Notification:Add(
		data.Name,
		string.format("%s Wants To Transfer Ownership of %s", data.Sender, data.Name),
		time * 1000,
		-1,
		"comanager",
		{
			accept = "Phone:Client:CoManager:AcceptXfer",
			cancel = "Phone:Client:CoManager:DeclineXfer",
		},
		nil
	)
end)

AddEventHandler("Phone:Client:CoManager:AcceptXfer", function()
	Callbacks:ServerCallback("Phone:CoManager:AcceptXfer", {}, function(time, state)
		if state then
			Phone.Notification:Add("Employment", "You accepted an ownership transfer request", time * 1000, 6000, "comanager", {
				view = "",
			}, nil)
		else
			Phone.Notification:Add("Employment", "Unable to accept an ownership transfer request", time * 1000, 6000, "comanager", {
				view = "",
			}, nil)
		end
	end)
end)

AddEventHandler("Phone:Client:CoManager:DeclineXfer", function()
	Callbacks:ServerCallback("Phone:CoManager:DeclineXfer", {}, function(time)
		Phone.Notification:Add("Employment", "You declined an ownership transfer request", time * 1000, 6000, "comanager", {}, nil)
	end)
end)

RegisterNUICallback("QuitJob", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:QuitJob", data, cb)
end)

RegisterNUICallback("FetchRoster", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:FetchRoster", data, cb)
end)

RegisterNUICallback("FetchTimeWorked", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:FetchTimeWorked", data, cb)
end)

RegisterNUICallback("RenameCompany", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:RenameCompany", data, cb)
end)

RegisterNUICallback("HireEmployee", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:HireEmployee", data, cb)
end)

RegisterNUICallback("FireEmployee", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:FireEmployee", data, cb)
end)

RegisterNUICallback("UpdateEmployee", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:UpdateEmployee", data, cb)
end)

RegisterNUICallback("EditWorkplace", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:EditWorkplace", data, cb)
end)

RegisterNUICallback("CreateGrade", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:CreateGrade", data, cb)
end)

RegisterNUICallback("EditGrade", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:EditGrade", data, cb)
end)

RegisterNUICallback("DeleteGrade", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:DeleteGrade", data, cb)
end)

RegisterNUICallback("PurchaseUpgrade", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:PurchaseUpgrade", data, cb)
end)

RegisterNUICallback("DisbandCompany", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:DisbandCompany", data, cb)
end)

RegisterNUICallback("TransferCompany", function(data, cb)
	Callbacks:ServerCallback("Phone:CoManager:TransferCompany", data, cb)
end)
