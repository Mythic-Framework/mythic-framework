AddEventHandler("Government:Client:OnDuty", function()
	Jobs.Duty:On("government")
end)

AddEventHandler("Government:Client:OffDuty", function()
	Jobs.Duty:Off("government")
end)

AddEventHandler("Government:Client:BuyID", function()
	Callbacks:ServerCallback("Government:BuyID")
end)

AddEventHandler("Government:Client:DoLicenseBuy", function(license)
	Callbacks:ServerCallback("Government:BuyLicense", license)
end)

AddEventHandler("Government:Client:DoWeaponsLicenseBuyPolice", function(license)
	Callbacks:ServerCallback("Government:Client:DoWeaponsLicenseBuyPolice", {})
end)

AddEventHandler("Government:Client:BuyLicense", function()
	local licenses = LocalPlayer.state.Character:GetData("Licenses")
	local items = {}

	if not licenses.Drivers.Active then
		if not licenses.Drivers.Suspended then
			table.insert(items, {
				label = "Drivers License",
				description = "Renew Drivers License ($1000)",
				event = "Government:Client:DoLicenseBuy",
				data = "drivers",
			})
		else
			table.insert(items, {
				label = "Drivers License",
				description = "Unable To Renew, License Is Suspended.",
			})
		end
	end

	if not licenses.Weapons.Active then
		if not licenses.Weapons.Suspended then
			if LocalPlayer.state.onDuty == 'police' then
				table.insert(items, {
					label = "Weapons License (Police)",
					description = "Purchase Weapons License ($20)",
					event = "Government:Client:DoWeaponsLicenseBuyPolice",
					data = "weapons_police",
				})
			else
				table.insert(items, {
					label = "Weapons License",
					description = "Purchase Weapons License ($2000)",
					event = "Government:Client:DoLicenseBuy",
					data = "weapons",
				})
			end
		else
			table.insert(items, {
				label = "Weapons License",
				description = "Unable To Purchase, License Is Suspended.",
			})
		end
	end

	if not licenses.Hunting.Active then
		if not licenses.Hunting.Suspended then
			table.insert(items, {
				label = "Hunting License",
				description = "Purchase Hunting License ($800)",
				event = "Government:Client:DoLicenseBuy",
				data = "hunting",
			})
		else
			table.insert(items, {
				label = "Hunting License",
				description = "Unable To Purchase, License Is Suspended.",
			})
		end
	end

	if not licenses.Fishing.Active then
		if not licenses.Fishing.Suspended then
			table.insert(items, {
				label = "Fishing License",
				description = "Purchase Fishing License ($800)",
				event = "Government:Client:DoLicenseBuy",
				data = "fishing",
			})
		else
			table.insert(items, {
				label = "Fishing License",
				description = "Unable To Purchase, License Is Suspended.",
			})
		end
	end

	ListMenu:Show({
		main = {
			label = "Licensing Services",
			items = items,
		}
	})
end)
