local _services = {
	{
		Disabled = true,
		_id = 1,
		Label = "Business Registration",
		Price = 25000,
		Event = "CreateBusiness",
		Disclaimer = "You may not purchase this if you already own a company.<br /><br />You will be able to name your company via the Company Management app after purchasing this service.",
	},
}

AddEventHandler("Phone:Server:RegisterCallbacks", function()
	Callbacks:RegisterServerCallback("Phone:Govt:PurchaseService", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")

		if data == 1 then
			-- TODO: Add Billing

			if Jobs.Permissions:IsOwnerOfCompany(source) then
				local co =  Jobs.Management:Create(false, char:GetData('SID'))
				if co then
					cb({ error = false })
				else
					cb({ error = true, code = 2, message = "Error Creating Business" })
				end
			else
				cb({ error = true, code = 2, message = "You Already Own a Business" })
			end


		else
			cb({ error = true, code = 1 })
		end
	end)
end)


AddEventHandler("Phone:Server:RegisterMiddleware", function()
	Middleware:Add("Characters:Spawning", function(source)
		TriggerClientEvent("Phone:Client:SetData", source, "govtServices", _services)
	end, 2)
	Middleware:Add("Phone:UIReset", function(source)
		TriggerClientEvent("Phone:Client:SetData", source, "govtServices", _services)
	end, 2)
end)
